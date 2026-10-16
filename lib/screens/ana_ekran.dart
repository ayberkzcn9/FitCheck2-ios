import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:in_app_review/in_app_review.dart';

import '../models/kiyafet.dart';
import '../models/favori_kombin.dart';
import 'gardirobum_ekrani.dart';
import 'haftalik_planlayici_ekrani.dart';
import 'gunluk_kombin_ekrani.dart';
import 'kendi_kombinim_ekrani.dart';
import 'profil_analiz_ekrani.dart';
import 'kombin_oyunu_ekrani.dart';
import 'ai_chatbot_modal.dart';
import 'ayarlar_ekrani.dart';
import 'izin_ekrani.dart';
import '../l10n/app_localizations.dart';
import '../services/analytics_servisi.dart';
import '../services/bildirim_servisi.dart';
import '../services/fcm_service.dart';
import '../services/reklam_servisi.dart';
import '../utils/helpers.dart';
import '../ai/ai_dil.dart';
import '../widgets/ana_ekran_rehber.dart';

import '../widgets/fade_indexed_stack.dart';
import '../utils/ana_ekran_dialoglar.dart';
import '../../theme/design_tokens.dart';

class AnaEkraniNavigasyon extends StatefulWidget {
  const AnaEkraniNavigasyon({super.key});

  @override
  State<AnaEkraniNavigasyon> createState() => _AnaEkraniNavigasyonState();
}

class _AnaEkraniNavigasyonState extends State<AnaEkraniNavigasyon> {
  int _seciliSekme = 0;
  List<Kiyafet> _gardirobum = [];
  List<FavoriKombin> _favoriKombinler = [];
  List<Map<String, String>> _gecmisKombinler = [];
  final Map<String, Set<String>> _bugunGiydimdeEklenenSepetIdleri = {};

  String _gunlukHavaDurumu = '';
  String _detayliHaftalikHavaMetni = '';
  bool _havaYukleniyor = true;
  bool _havaHatasi = false;
  bool _verilerYukleniyor = true;
  bool _ilkYuklemeYapildi = false;
  late final Future<void> _verilerHazir;

  // 🔒 Async mutex for preventing race conditions on data operations
  final _dataLock = _AsyncLock();

  int _kalanHak = 3;
  Locale? _aktifDil;
  late final ValueListenable<int> _hakListener;
  bool _isBarsVisible = true;

  final GlobalKey<GunlukKombinEkraniState> _dolaptanKombinKey =
      GlobalKey<GunlukKombinEkraniState>();
  final GlobalKey<GardirobumEkraniState> _gardirobumKey =
      GlobalKey<GardirobumEkraniState>();

  final GlobalKey _topluFotografEkleKey = GlobalKey();
  final GlobalKey _aiStilistKey = GlobalKey();
  final GlobalKey _sesliAsistanKey = GlobalKey();
  final GlobalKey _ayarlarKey = GlobalKey();

  final GlobalKey _gardirobumNavKey = GlobalKey();
  final GlobalKey _haftalikNavKey = GlobalKey();
  final GlobalKey _dolaptanNavKey = GlobalKey();
  final GlobalKey _kendiNavKey = GlobalKey();
  final GlobalKey _profilNavKey = GlobalKey();

  String _varsayilanCinsiyet = 'Kadın';

  Color get _anaRenk => Theme.of(context).colorScheme.primary;

  final stt.SpeechToText _speechToText = stt.SpeechToText();
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _hakListener = ReklamServisi().kalanHakNotifier;
    _hakListener.addListener(_onHakChanged);
    _kalanHak = _hakListener.value;
    AnalyticsServisi().ekranGoruntule(
      AnalyticsServisi.sekmeAdlari[_seciliSekme],
    );
    _verilerHazir = _verileriYukle();
    _speechInit();
    _hakSayaciniGuncelle();

    ReklamServisi().odulluReklamYukle();
    ReklamServisi().gecisReklamiYukle();

    _degerlendirmeKontrolEt();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _rehberBaslat();
      if (mounted) {
        await _izinKontrolEtVeGoster();
      }
      if (!mounted) return;
      // FCM dil topic'ini güncelle
      final locale = Localizations.localeOf(context).languageCode;
      await FcmService().updateLanguageTopic(locale);
    });
  }

  void _onHakChanged() {
    if (mounted) {
      setState(() {
        _kalanHak = _hakListener.value;
      });
    }
  }

  @override
  void dispose() {
    _hakListener.removeListener(_onHakChanged);
    _speechToText.stop();
    super.dispose();
  }

  Future<void> _izinKontrolEtVeGoster() async {
    final locationStatus = await Permission.location.status;
    final cameraStatus = await Permission.camera.status;

    if (!locationStatus.isGranted || !cameraStatus.isGranted) {
      if (mounted) {
        await IzinDiyalogu.goster(context);
      }
    }
  }

  // ============================================================
  // ⭐ UYGULAMA DEĞERLENDİRME (PLAY STORE YORUMU)
  // ============================================================
  // Uygulama ilk açıldığında istenmez; 2. açılışta (ve kullanıcı
  // reddederse sonrasında her 3 açılışta bir) değerlendirme penceresi
  // gösterilir. "Evet, değerlendireyim" dendiğinde Google Play'in
  // yerel puanlama penceresi açılır ve bir daha sorulmaz.
  Future<void> _degerlendirmeKontrolEt() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Açılış sayacını artır
      final int acilisSayisi = (prefs.getInt('acilis_sayisi') ?? 0) + 1;
      await prefs.setInt('acilis_sayisi', acilisSayisi);

      // İlk açılışta değerlendirme İSTEME
      if (acilisSayisi < 2) return;

      // "Evet, değerlendireyim" dendi ise bir daha sorma
      final bool degerlendirildi = prefs.getBool('degerlendirme_yapildi') ?? false;
      if (degerlendirildi) return;

      // Reddedildiyse her 3 açılışta bir tekrar sor
      final int sonIsteme = prefs.getInt('degerlendirme_son_isteme') ?? 0;
      if (acilisSayisi != 2 && acilisSayisi - sonIsteme < 3) return;

      if (!mounted) return;

      // Ana ekran otursun, rehber/konum diyalogları ile çakışmasın
      await Future.delayed(const Duration(milliseconds: 2000));
      if (!mounted) return;

      await prefs.setInt('degerlendirme_son_isteme', acilisSayisi);
      _degerlendirmeDiyaloguGoster();
    } catch (e) {
      debugPrint('Değerlendirme kontrol hatası: $e');
    }
  }

  void _degerlendirmeDiyaloguGoster() {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: colorScheme.surfaceContainerHigh,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.xxlRadius,
        ),
        title: Row(
          children: [
            Icon(
              Icons.favorite_rounded,
              color: colorScheme.primary,
              size: 24,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                l10n.degerlendirmeBaslik,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          l10n.degerlendirmeIcerik,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              l10n.degerlendirmeBelkiSonra,
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.primaryContainer,
              foregroundColor: colorScheme.onPrimaryContainer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              Navigator.pop(dialogContext);
              _degerlendirmeBaslat();
            },
            child: Text(
              l10n.degerlendirmeEvet,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _degerlendirmeBaslat() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // Kullanıcı kabul etti: bir daha sorma
      await prefs.setBool('degerlendirme_yapildi', true);

      // Google Play'in yerel puanlama penceresi (kota doluysa Play Store sayfası açılır)
      if (await InAppReview.instance.isAvailable()) {
        await InAppReview.instance.requestReview();
      } else {
        await InAppReview.instance.openStoreListing();
      }

      await AnalyticsServisi().olay('review_prompt_accepted', {});
    } catch (e) {
      debugPrint('Değerlendirme başlatma hatası: $e');
    }
  }

  Future<void> _hakSayaciniGuncelle() async {
    final hak = await ReklamServisi().kalanHakGetir();
    if (mounted) {
      setState(() {
        _kalanHak = hak;
      });
    }
  }

  Future<void> _rehberBaslat() async {
    final prefs = await SharedPreferences.getInstance();
    final bool rehberGosterildi = prefs.getBool('rehber_gosterildi') ?? false;

    if (!rehberGosterildi) {
      await Future.delayed(const Duration(milliseconds: 600));
      if (!mounted) return;

      if (_topluFotografEkleKey.currentContext != null) {
        final completer = Completer<void>();

        AnaEkranRehber.rehberiBaslat(
          context: context,
          gardirobaEkleKey: _topluFotografEkleKey,
          aiStilistKey: _aiStilistKey,
          yikamaTakipKey: _sesliAsistanKey,
          havaDurumuKey: _ayarlarKey,
          gardirobumNavKey: _gardirobumNavKey,
          haftalikNavKey: _haftalikNavKey,
          dolaptanNavKey: _dolaptanNavKey,
          kendiNavKey: _kendiNavKey,
          profilNavKey: _profilNavKey,
          onFinish: () async {
            final p = await SharedPreferences.getInstance();
            await p.setBool('rehber_gosterildi', true);
            if (!completer.isCompleted) {
              completer.complete();
            }
          },
        );

        await completer.future;
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final mevcudDil = Localizations.localeOf(context);

    if (!_ilkYuklemeYapildi) {
      _ilkYuklemeYapildi = true;
      _aktifDil = mevcudDil;
      _gunlukHavaDurumu = AppLocalizations.of(context)!.anaHavaYukleniyor;
      _konumVeHavaDurumlariniAl();
    } else if (_aktifDil != null &&
        _aktifDil?.languageCode != mevcudDil.languageCode) {
      _aktifDil = mevcudDil;
      _konumVeHavaDurumlariniAl();
    }
    _hakSayaciniGuncelle();
  }

  void _speechInit() async {
    await _speechToText.initialize();
  }

  void _sesliAsistanTetikle() async {
    HapticFeedback.mediumImpact();
    final l10n = AppLocalizations.of(context)!;

    if (_isListening) {
      await _speechToText.stop();
      if (mounted) {
        setState(() {
          _isListening = false;
        });
      }
    } else {
      bool available = await _speechToText.initialize();

      if (!mounted) return;

      if (available) {
        setState(() {
          _isListening = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              l10n.anaDinliyor,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            duration: const Duration(seconds: 3),
            backgroundColor: _anaRenk,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        );

        _speechToText.listen(
          listenOptions: stt.SpeechListenOptions(
            localeId: konusmaDiliKodu(
                Localizations.localeOf(context).languageCode),
          ),
          onResult: (result) {
            if (result.finalResult) {
              if (mounted) {
                setState(() {
                  _isListening = false;
                });
              }
              _aiChatbotModalAc(baslangicMetni: result.recognizedWords);
            }
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.anaMikrofonHata)),
        );
      }
    }
  }

  Future<void> _verileriKaydet() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final gardiropJsonList = _gardirobum.map((k) => k.toJson()).toList();
      await prefs.setString('gardirobum_data', jsonEncode(gardiropJsonList));

      final favoriJsonList = _favoriKombinler.map((f) => f.toJson()).toList();
      await prefs.setString('favoriler_data', jsonEncode(favoriJsonList));

      await prefs.setString('gecmis_data', jsonEncode(_gecmisKombinler));
      await prefs.setString('kullanici_cinsiyet', _varsayilanCinsiyet);
    } catch (e) {
      debugPrint("Kayıt Hatası: $e");
    }
  }

  Future<void> _verileriYukle() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final gardiropString = prefs.getString('gardirobum_data');
      final gardiropDecoded = safeJsonDecodeList(gardiropString, tag: 'gardirobum_data');
      _gardirobum = gardiropDecoded.map((item) => Kiyafet.fromJson(item)).toList();

      final favoriString = prefs.getString('favoriler_data');
      final favoriDecoded = safeJsonDecodeList(favoriString, tag: 'favoriler_data');
      _favoriKombinler =
          favoriDecoded.map((item) => FavoriKombin.fromJson(item)).toList();

      final gecmisString = prefs.getString('gecmis_data');
      final gecmisDecoded = safeJsonDecodeList(gecmisString, tag: 'gecmis_data');
      _gecmisKombinler =
          gecmisDecoded.map((item) => Map<String, String>.from(item)).toList();

      if (mounted) {
        setState(() {
          _varsayilanCinsiyet =
              prefs.getString('kullanici_cinsiyet') ?? 'Kadın';
        });
      }
    } catch (e) {
      debugPrint("Veri Yükleme Hatası: $e");
    } finally {
      if (mounted) {
        setState(() {
          _verilerYukleniyor = false;
        });
      }
    }
  }

  Future<void> _konumVeHavaDurumlariniAl({bool konumuZorla = false}) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      setState(() {
        _gunlukHavaDurumu = l10n.anaHavaYukleniyor;
        _havaYukleniyor = true;
        _havaHatasi = false;
      });

      final prefs = await SharedPreferences.getInstance();
      final kayitliSehir = konumuZorla
          ? ''
          : (prefs.getString('varsayilan_sehir') ?? '').trim();
      final ozelSehir = kayitliSehir.isNotEmpty &&
          kayitliSehir != 'Otomatik (GPS)' &&
          kayitliSehir.toLowerCase() != 'automatic (gps)';

      double enlem;
      double boylam;
      String sehirAdi = '';

      if (ozelSehir) {
        final geoUrl = Uri.parse(
          'https://geocoding-api.open-meteo.com/v1/search?name=${Uri.encodeQueryComponent(kayitliSehir)}&count=1&language=tr&format=json',
        );
        final geoRes =
            await http.get(geoUrl).timeout(const Duration(seconds: 10));
        final geoData = safeJsonDecodeMap(geoRes.body, tag: 'geocoding');
        final results = geoData['results'];
        if (geoRes.statusCode != 200 || results is! List || results.isEmpty) {
          throw const FormatException('Seçilen şehir bulunamadı');
        }
        final city = results.first as Map<String, dynamic>;
        enlem = (city['latitude'] as num).toDouble();
        boylam = (city['longitude'] as num).toDouble();
        sehirAdi = (city['name'] ?? kayitliSehir).toString();
      } else {
        final serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) {
          if (mounted) {
            setState(() {
              _gunlukHavaDurumu = l10n.anaKonumKapaliBaslik;
              _detayliHaftalikHavaMetni = l10n.anaHavaTahminiYuklenemedi;
              _havaYukleniyor = false;
              _havaHatasi = true;
            });
          }
          return;
        }

        var permission = await Geolocator.checkPermission();
        if (konumuZorla && permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
        }
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          if (mounted) {
            setState(() {
              _gunlukHavaDurumu = l10n.anaKonumIzinRedBaslik;
              _detayliHaftalikHavaMetni = l10n.anaKonumIzinRedIcerik1;
              _havaYukleniyor = false;
              _havaHatasi = true;
            });
          }
          return;
        }

        final position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.low,
            timeLimit: Duration(seconds: 10),
          ),
        );
        enlem = position.latitude;
        boylam = position.longitude;

        try {
          if (!mounted) return;
          final dilKodu = Localizations.localeOf(context).languageCode;
          final bdcUrl = Uri.parse(
              'https://api.bigdatacloud.net/data/reverse-geocode-client?latitude=${position.latitude}&longitude=${position.longitude}&localityLanguage=$dilKodu');
          final bdcRes =
              await http.get(bdcUrl).timeout(const Duration(seconds: 10));

          if (bdcRes.statusCode == 200) {
            final bdcData = safeJsonDecodeMap(bdcRes.body, tag: 'bigdatacloud');
            sehirAdi = bdcData['locality'] ??
                bdcData['city'] ??
                bdcData['principalSubdivision'] ??
                '';
          }
        } catch (e) {
          sehirAdi = "";
        }
      }

      sehirAdi = sehirAdi.trim();
      if (sehirAdi.isNotEmpty) {
        List<String> parcalar = sehirAdi.split(' ');
        if (parcalar.length > 1 && parcalar[0] == parcalar[1]) {
          sehirAdi = parcalar[0];
        }
      }

      final url = Uri.parse(
        'https://api.open-meteo.com/v1/forecast?latitude=$enlem&longitude=$boylam&daily=temperature_2m_max,temperature_2m_min,weather_code&timezone=auto',
      );

      final response =
          await http.get(url).timeout(const Duration(seconds: 10));
      if (response.statusCode != 200) {
        throw Exception(
            'Hava durumu isteği başarısız: ${response.statusCode}');
      }

      final data = safeJsonDecodeMap(response.body, tag: 'open-meteo');
      final daily = data['daily'];
      final List? gunler = daily is Map ? daily['time'] as List? : null;
      final List? maxSicakliklar =
          daily is Map ? daily['temperature_2m_max'] as List? : null;
      final List? minSicakliklar =
          daily is Map ? daily['temperature_2m_min'] as List? : null;
      final List? havaKodlari =
          daily is Map ? daily['weather_code'] as List? : null;

      if (gunler == null ||
          maxSicakliklar == null ||
          minSicakliklar == null ||
          havaKodlari == null ||
          gunler.isEmpty ||
          maxSicakliklar.length != gunler.length ||
          minSicakliklar.length != gunler.length ||
          havaKodlari.length != gunler.length ||
          maxSicakliklar.any((value) => value is! num) ||
          minSicakliklar.any((value) => value is! num) ||
          havaKodlari.any((value) => value is! num)) {
        throw const FormatException('Hava durumu günlük verisi eksik veya bozuk');
      }

      {
        final sicaklikBirimi = prefs.getString('sicaklik_birimi') ?? '°C';
        double gosterilecekSicaklik(double celsius) =>
            sicaklikBirimi == '°F' ? (celsius * 9 / 5) + 32 : celsius;
        final double maxS = maxSicakliklar[0];
        final double minS = minSicakliklar[0];
        final int kod = (havaKodlari[0] as num).toInt();

        String durum = l10n.havaParcaliBulutlu;
        if (maxS > 28) {
          durum = l10n.havaSicakGunesli;
        } else if (maxS < 12) {
          durum = l10n.havaSogukKarli;
        }

        if ((kod >= 51 && kod <= 67) || (kod >= 80 && kod <= 99)) {
          durum = l10n.havaYagmurlu;
          final prefs = await SharedPreferences.getInstance();
          final bildirimAnahtari =
              '${gunler[0]}-$kod-${maxS.toStringAsFixed(1)}-${minS.toStringAsFixed(1)}';
          if (prefs.getString('son_yagmur_bildirim_anahtari') !=
              bildirimAnahtari) {
            await BildirimServisi().anlikBildirimGoster(
              baslik: l10n.anaSemsiyeBildirimBaslik,
              icerik: l10n.anaSemsiyeBildirimIcerik,
            );
            await prefs.setString(
                'son_yagmur_bildirim_anahtari', bildirimAnahtari);
          }
        }

        List<String> haftalikOzetListesi = [];
        final gunIsimleri = [
          l10n.gunPzt,
          l10n.gunSal,
          l10n.gunCar,
          l10n.gunPer,
          l10n.gunCum,
          l10n.gunCmt,
          l10n.gunPaz
        ];

        for (int i = 0; i < gunler.length && i < 7; i++) {
          final double dayMax = (maxSicakliklar[i] as num).toDouble();
          final double dayMin = (minSicakliklar[i] as num).toDouble();
          final int dayCode = (havaKodlari[i] as num).toInt();

          String dayDurum = l10n.havaParcaliBulutlu;
          if (dayMax > 28) {
            dayDurum = l10n.havaGunesli;
          }
          if (dayMax < 12) {
            dayDurum = l10n.havaSoguk;
          }
          if ((dayCode >= 51 && dayCode <= 67) ||
              (dayCode >= 80 && dayCode <= 99)) {
            dayDurum = l10n.havaYagmurlu;
          }

          DateTime tarih;
          try {
            tarih = DateTime.parse(gunler[i].toString());
          } catch (e) {
            tarih = DateTime.now().add(Duration(days: i));
          }
          int haftaninGunuIndex = tarih.weekday - 1;
          String gercekGunAdi = gunIsimleri[haftaninGunuIndex];

          final minGosterim = gosterilecekSicaklik(dayMin);
          final maxGosterim = gosterilecekSicaklik(dayMax);
          haftalikOzetListesi.add(
              "$gercekGunAdi: ${minGosterim.toStringAsFixed(0)}$sicaklikBirimi / ${maxGosterim.toStringAsFixed(0)}$sicaklikBirimi, $dayDurum");
        }

        final String sehirEtiketi =
            sehirAdi.isNotEmpty ? "$sehirAdi • " : "";

        if (mounted) {
          setState(() {
            final minGosterim = gosterilecekSicaklik(minS);
            final maxGosterim = gosterilecekSicaklik(maxS);
            _gunlukHavaDurumu =
                '$sehirEtiketi${minGosterim.toStringAsFixed(0)}$sicaklikBirimi / ${maxGosterim.toStringAsFixed(0)}$sicaklikBirimi — $durum';
            _detayliHaftalikHavaMetni = haftalikOzetListesi.join("\n");
            _havaYukleniyor = false;
            _havaHatasi = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _gunlukHavaDurumu = l10n.anaHavaDurumuAlinamadi;
          _detayliHaftalikHavaMetni = l10n.anaHavaTahminiYuklenemedi;
          _havaYukleniyor = false;
          _havaHatasi = true;
        });
      }
    }
  }

  Future<void> _konumAyarlariniAc() async {
    await Geolocator.openLocationSettings();
  }

  Future<void> _konumuYenileVeIzinIste() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
      return;
    }
    if (permission == LocationPermission.denied) return;

    await _konumVeHavaDurumlariniAl(konumuZorla: true);
  }

  Future<void> _kiyafetEkle(Kiyafet kiyafet) async {
    await _dataLock.synchronized(() async {
      if (_verilerYukleniyor) return;
      final int maxLimit = await ReklamServisi().maxKiyafetLimitiniGetir();

      if (!mounted) return;

      if (_gardirobum.length >= maxLimit) {
        AnaEkranDialoglar.gardiropLimitiDolduDiyaloguGoster(
            context: context, anaRenk: _anaRenk, maxLimit: maxLimit);
        return;
      }

      final int varOlanIndex = _gardirobum.indexWhere((k) => k.id == kiyafet.id);

      setState(() {
        if (varOlanIndex != -1) {
          _gardirobum[varOlanIndex] = kiyafet;
        } else {
          _gardirobum.add(kiyafet);
        }
      });
      await _verileriKaydet();

      await AnalyticsServisi().olay(
        varOlanIndex != -1 ? 'garment_updated' : 'garment_added',
        {'category': kiyafet.kategori},
      );
    });
  }

  Future<void> _kiyafetSil(String id) async {
    await _dataLock.synchronized(() async {
      if (_verilerYukleniyor) return;
      setState(() {
        _gardirobum.removeWhere((item) => item.id == id);
      });
      await _verileriKaydet();
      AnalyticsServisi().olay('garment_deleted');
    });
  }

  Future<void> _gardirobuTemizle() async {
    await _dataLock.synchronized(() async {
      if (_verilerYukleniyor) return;
      setState(() {
        _gardirobum.clear();
        _favoriKombinler.clear();
        _gecmisKombinler.clear();
      });
      await _verileriKaydet();
    });
  }

  Future<void> _sepetDurumunuDegistir(String id) async {
    await _dataLock.synchronized(() async {
      if (_verilerYukleniyor) return;
      HapticFeedback.selectionClick();
      setState(() {
        final index = _gardirobum.indexWhere((k) => k.id == id);
        if (index != -1) {
          _gardirobum[index].sepetteMi = !_gardirobum[index].sepetteMi;
        }
      });
      await _verileriKaydet();
    });
  }

  Future<void> _favoriKombinEkle(FavoriKombin kombin) async {
    await _dataLock.synchronized(() async {
      if (_verilerYukleniyor) return;
      final l10n = AppLocalizations.of(context)!;
      HapticFeedback.lightImpact();
      setState(() {
        _favoriKombinler.removeWhere((f) => f == kombin);
        _favoriKombinler.add(kombin);
      });
      await _verileriKaydet();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.anaFavoriEklendi),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });
  }

  Future<void> _favoriKombinSil(int index) async {
    await _dataLock.synchronized(() async {
      if (_verilerYukleniyor) return;
      if (index >= 0 && index < _favoriKombinler.length) {
        setState(() {
          _favoriKombinler.removeAt(index);
        });
        await _verileriKaydet();
      }
    });
  }

  Future<void> _favoriKombinNesneIleSil(FavoriKombin favori) async {
    await _dataLock.synchronized(() async {
      if (_verilerYukleniyor) return;
      setState(() {
        _favoriKombinler.removeWhere((f) => f == favori);
      });
      await _verileriKaydet();
    });
  }

  Future<void> _favoriKombinBaslikIleSil(String baslik) async {
    await _dataLock.synchronized(() async {
      if (_verilerYukleniyor) return;
      setState(() {
        _favoriKombinler.removeWhere((f) => f.baslik == baslik);
      });
      await _verileriKaydet();
    });
  }

  bool _isKombinFavoride(List<String> parcaBasliklari) {
    if (parcaBasliklari.isEmpty) return false;

    final sortedInput = List<String>.from(
        parcaBasliklari.map((e) => e.trim().toLowerCase()))..sort();

    return _favoriKombinler.any((fav) {
      if (fav.parcalar.length != sortedInput.length) return false;
      final sortedFav = List<String>.from(
          fav.parcalar.map((e) => e.trim().toLowerCase()))..sort();
      for (int i = 0; i < sortedInput.length; i++) {
        if (sortedInput[i] != sortedFav[i]) return false;
      }
      return true;
    });
  }

  String _kombinTekrarKnt(String detay, AppLocalizations l10n) {
    int tekrarSayisi = 0;
    for (var gecmis in _gecmisKombinler.take(5)) {
      if ((gecmis['detay'] ?? '').contains(detay)) {
        tekrarSayisi++;
      }
    }
    if (tekrarSayisi >= 2) {
      return l10n.anaKombinTekrarUyari;
    }
    return l10n.anaKombinMukemmel;
  }

  Future<void> _kombinGecmisineEkle(
      String kombinAdi, dynamic detayOrList) async {
    await _dataLock.synchronized(() async {
      if (_verilerYukleniyor) {
        await _verilerHazir;
        if (!mounted) return;
      }
      final l10n = AppLocalizations.of(context)!;
      final theme = Theme.of(context);
      final colorScheme = theme.colorScheme;
      final prefs = await SharedPreferences.getInstance();
      final bool yikamaUyarisiAktif = prefs.getBool('yikama_uyarisi') ?? true;

      List<Kiyafet> seciliKiyafetler = [];
      String detayMetni = "";

      if (detayOrList is List<Kiyafet>) {
        seciliKiyafetler = detayOrList;
        detayMetni = seciliKiyafetler.map((k) => k.gorunenBaslik).join(", ");
      } else if (detayOrList is String) {
        detayMetni = detayOrList;
        final List<String> seciliParcaAdlari = detayMetni
            .split(',')
            .map((e) => e.trim().toLowerCase())
            .where((e) => e.isNotEmpty)
            .toList();

        // 🔧 Benzersiz ID ile eşleşme - aynı isimde birden fazla kıyafet olsa bile her biri bir kez işaretlenir
        final Map<String, Kiyafet> eslesenlerMap = {};
        for (final k in _gardirobum) {
          final baslik = k.baslik.trim().toLowerCase();
          final gorunen = k.gorunenBaslik.trim().toLowerCase();
          if (seciliParcaAdlari.any((p) => p == baslik || p == gorunen)) {
            // Aynı ID varsa atla (benzersiz kıyafet garanti)
            if (!eslesenlerMap.containsKey(k.id)) {
              eslesenlerMap[k.id] = k;
            }
          }
        }
        seciliKiyafetler = eslesenlerMap.values.toList();

        // 🐛 Debug log
        debugPrint('Bugun Giydim eslesmesi:');
        debugPrint('   Aranan parcalar: $seciliParcaAdlari');
        debugPrint('   Bulunan (${seciliKiyafetler.length} adet): ${seciliKiyafetler.map((k) => "${k.gorunenBaslik} (id:${k.id.substring(0,8)})").join(", ")}');
      }

      final uyariMesaji = _kombinTekrarKnt(detayMetni, l10n);
      final Set<String> seciliIdler = seciliKiyafetler.map((k) => k.id).toSet();

      final Set<String> sepeteEklenenIdler = <String>{};

      setState(() {
        _gecmisKombinler.insert(0, {
          "tarih": DateTime.now().toString().substring(0, 10),
          "baslik": kombinAdi,
          "detay": detayMetni,
        });

        List<String> yikanmasiGerekenler = [];
        int sepettekiToplamEsyaSayisi = 0;

        for (var item in _gardirobum) {
          if (seciliIdler.contains(item.id)) {
            if (!item.sepetteMi) {
              item.giyildiOlarakIsaretle();
              yikanmasiGerekenler.add(item.gorunenBaslik);
              sepeteEklenenIdler.add(item.id);
            }
          }

          if (item.sepetteMi) {
            sepettekiToplamEsyaSayisi++;
          }
        }

        _bugunGiydimdeEklenenSepetIdleri['$kombinAdi|$detayMetni'] =
            sepeteEklenenIdler;

        if (yikamaUyarisiAktif) {
          if (sepettekiToplamEsyaSayisi >= 5) {
            BildirimServisi().anlikBildirimGoster(
              baslik: l10n.anaCamasirGunuBildirimBaslik,
              icerik: l10n.anaCamasirGunuBildirimIcerik,
            );
          }

          if (yikanmasiGerekenler.isNotEmpty) {
            Future.delayed(const Duration(milliseconds: 500), () {
              if (!mounted) return;
              showDialog(
                context: context,
                useRootNavigator: true,
                builder: (context) => AlertDialog(
                  backgroundColor: colorScheme.surfaceContainerHigh,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.xxlRadius,
                  ),
                  title: Row(
                    children: [
                      Icon(
                        Icons.local_laundry_service_rounded,
                        color: colorScheme.primary,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          l10n.anaYikamaUyariBaslik,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                  content: Text(
                    l10n.anaYikamaUyariIcerik(yikanmasiGerekenler.join(", ")),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  actions: [
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: colorScheme.primaryContainer,
                        foregroundColor: colorScheme.onPrimaryContainer,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        l10n.anaTamam,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            });
          }
        }
      });

      await _verileriKaydet();

      if (sepeteEklenenIdler.isNotEmpty) {
        await AnalyticsServisi().olay(
          'outfit_worn_today',
          {'items': sepeteEklenenIdler.length},
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$uyariMesaji 📅'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });
  }

  Future<void> _kombinGecmistenCikar(
      String kombinAdi, String detayMetni) async {
    await _dataLock.synchronized(() async {
      final anahtar = '$kombinAdi|$detayMetni';
      final eklenenIdler =
          _bugunGiydimdeEklenenSepetIdleri.remove(anahtar) ?? <String>{};

      setState(() {
        final gecmisIndex = _gecmisKombinler.indexWhere(
          (gecmis) =>
              gecmis['baslik'] == kombinAdi && gecmis['detay'] == detayMetni,
        );
        if (gecmisIndex != -1) {
          _gecmisKombinler.removeAt(gecmisIndex);
        }

        // 🔧 Sadece ID ile eşleştirme (isim fallback'u kaldırıldı - bug #4 fix)
        for (final item in _gardirobum) {
          if (eklenenIdler.contains(item.id)) {
            item.sepetteMi = false;
            if (item.giyilmeSayisi > 0) item.giyilmeSayisi--;
          }
        }
      });

      await _verileriKaydet();
    });
  }

  void _odakKiyafetIleKombinBaslat(Kiyafet odakKiyafet) async {
    HapticFeedback.lightImpact();

    final int kalanHak = await ReklamServisi().kalanHakGetir();

    if (!mounted) return;

    if (kalanHak <= 0) {
      AnaEkranDialoglar.kombinHakkiBittiDiyaloguGoster(
          context: context,
          anaRenk: _anaRenk,
          onHakGuncelle: _hakSayaciniGuncelle);
      return;
    }

    await ReklamServisi().hakDusur();

    ReklamServisi().gecisReklamiGoster(
      onAdClosed: () {
        if (!mounted) return;
        _sekmeSec(2);

        WidgetsBinding.instance.addPostFrameCallback((_) {
          final promptHedef =
              "[ZORUNLU_PARCA: ${odakKiyafet.gorunenBaslik} (${odakKiyafet.kategori}, ${odakKiyafet.renk})]";
          _dolaptanKombinKey.currentState
              ?.otomatikKombinUret(hedefOrtam: promptHedef);
        });
      },
    );
  }

  void _aiChatbotModalAc({String? baslangicMetni}) async {
    HapticFeedback.lightImpact();

    if (baslangicMetni != null && baslangicMetni.contains("[ZORUNLU_PARCA:")) {
      final int kalanHak = await ReklamServisi().kalanHakGetir();

      if (!mounted) return;

      if (kalanHak <= 0) {
        AnaEkranDialoglar.kombinHakkiBittiDiyaloguGoster(
            context: context,
            anaRenk: _anaRenk,
            onHakGuncelle: _hakSayaciniGuncelle);
        return;
      }
      await ReklamServisi().hakDusur();

      if (mounted) {
        _sekmeSec(2);
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _dolaptanKombinKey.currentState
            ?.otomatikKombinUret(hedefOrtam: baslangicMetni);
      });
      return;
    }

    final dynamic sonuc = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 20),
        child: AiChatbotPenceresi(
          gardirobum: _gardirobum,
          gunlukHava: _gunlukHavaDurumu,
          ilkMesaj: baslangicMetni,
          anaRenk: _anaRenk,
        ),
      ),
    );

    if (sonuc != null && sonuc != false) {
      final int kalanHak = await ReklamServisi().kalanHakGetir();

      if (!mounted) return;

      if (kalanHak <= 0) {
        AnaEkranDialoglar.kombinHakkiBittiDiyaloguGoster(
            context: context,
            anaRenk: _anaRenk,
            onHakGuncelle: _hakSayaciniGuncelle);
        return;
      }
      await ReklamServisi().hakDusur();

      if (mounted) {
        _sekmeSec(2);
      }
      String? hedefOrtam = sonuc is String ? sonuc : null;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _dolaptanKombinKey.currentState
            ?.otomatikKombinUret(hedefOrtam: hedefOrtam);
      });
    }
  }

  // 🔒 Lock-protected callbacks for ProfilVeAnalizEkrani
  Future<void> _onSepetiTemizle() async {
    await _dataLock.synchronized(() async {
      final int temizlenenSayi =
          _gardirobum.where((k) => k.sepetteMi).length;
      setState(() {
        for (var k in _gardirobum) {
          k.sepetteMi = false;
        }
      });
      await _verileriKaydet();
      if (temizlenenSayi > 0) {
        AnalyticsServisi().olay(
          'laundry_basket_cleared',
          {'items': temizlenenSayi},
        );
      }
    });
  }

  Future<void> _onTekliSepettenCikar(String id) async {
    await _dataLock.synchronized(() async {
      setState(() {
        final index = _gardirobum.indexWhere((k) => k.id == id);
        if (index != -1) _gardirobum[index].sepetteMi = false;
      });
      await _verileriKaydet();
    });
  }

  Future<void> _onGecmisiTemizle() async {
    await _dataLock.synchronized(() async {
      setState(() {
        _gecmisKombinler.clear();
      });
      await _verileriKaydet();
    });
  }

  Future<void> _onTekliGecmisSil(int index) async {
    await _dataLock.synchronized(() async {
      setState(() {
        if (index >= 0 && index < _gecmisKombinler.length) {
          _gecmisKombinler.removeAt(index);
        }
      });
      await _verileriKaydet();
    });
  }

  PreferredSizeWidget _buildPremiumAppBar(AppLocalizations l10n) {
    const double barHeight = 72.0;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return PreferredSize(
      preferredSize: const Size.fromHeight(barHeight),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        height: _isBarsVisible
            ? barHeight + MediaQuery.of(context).padding.top
            : 0.0,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 220),
          opacity: _isBarsVisible ? 1.0 : 0.0,
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerLow.withValues(alpha: 0.85),
                  border: Border(
                    bottom: BorderSide(
                      color: colorScheme.outlineVariant.withValues(alpha: 0.4),
                      width: 1,
                    ),
                  ),
                ),
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Sol Taraf: Hak / Enerji Göstergesi
                        GestureDetector(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            AnaEkranDialoglar.hakDetayVeKuponModalGoster(
                                context: context,
                                anaRenk: _anaRenk,
                                kalanHak: _kalanHak,
                                onHakGuncelle: _hakSayaciniGuncelle);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 240),
                            curve: Curves.easeOutCubic,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: _kalanHak > 0
                                  ? Colors.amber.withValues(alpha: 0.15)
                                  : colorScheme.errorContainer,
                              borderRadius: AppRadius.xlRadius,
                              border: Border.all(
                                color: (_kalanHak > 0
                                        ? Colors.amber
                                        : colorScheme.error)
                                    .withValues(alpha: 0.4),
                                width: 1.2,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.bolt_rounded,
                                  color: _kalanHak > 0
                                      ? Colors.amber[700]
                                      : colorScheme.error,
                                  size: 20,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _kalanHak >= 99999 ? '∞' : '$_kalanHak',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 14,
                                    color: _kalanHak > 0
                                        ? Colors.amber[800]
                                        : colorScheme.onErrorContainer,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Sağ Taraf: Aksiyon İkonları Grubu
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              height: 40,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4),
                              decoration: BoxDecoration(
                                color: colorScheme.surfaceContainerHighest,
                                borderRadius: AppRadius.xlRadius,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _buildHeaderIconButton(
                                    key: _topluFotografEkleKey,
                                    icon: Icons.add_photo_alternate_outlined,
                                    tooltip: l10n.topluFotografEkleTooltip,
                                    iconColor: colorScheme.onSurface,
                                    onPressed: () async {
                                      HapticFeedback.mediumImpact();
                                      final int maxLimit = await ReklamServisi()
                                          .maxKiyafetLimitiniGetir();

                                      if (!mounted) return;

                                      if (_gardirobum.length >= maxLimit) {
                                        AnaEkranDialoglar
                                            .gardiropLimitiDolduDiyaloguGoster(
                                                context: context,
                                                anaRenk: _anaRenk,
                                                maxLimit: maxLimit);
                                        return;
                                      }
                                      if (_seciliSekme != 0) {
                                        _sekmeSec(0);
                                        WidgetsBinding.instance
                                            .addPostFrameCallback((_) {
                                          _gardirobumKey.currentState
                                              ?.topluFotografEkle();
                                        });
                                      } else {
                                        _gardirobumKey.currentState
                                            ?.topluFotografEkle();
                                      }
                                    },
                                  ),
                                  _buildHeaderIconButton(
                                    key: _sesliAsistanKey,
                                    icon: _isListening
                                        ? Icons.mic_rounded
                                        : Icons.mic_none_rounded,
                                    tooltip: l10n.anaSesleKonus,
                                    iconColor: _isListening
                                        ? colorScheme.error
                                        : colorScheme.onSurface,
                                    onPressed: _sesliAsistanTetikle,
                                  ),
                                  _buildHeaderIconButton(
                                    key: _aiStilistKey,
                                    icon: Icons.auto_awesome_rounded,
                                    tooltip: l10n.anaStilistAsistani,
                                    iconColor: colorScheme.onSurface,
                                    onPressed: () => _aiChatbotModalAc(),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                color: colorScheme.surfaceContainerHighest,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                key: _ayarlarKey,
                                padding: EdgeInsets.zero,
                                icon: Icon(
                                  Icons.settings_outlined,
                                  size: 20,
                                  color: colorScheme.onSurface,
                                ),
                                onPressed: () async {
                                  HapticFeedback.lightImpact();
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        settings: const RouteSettings(
                                            name: AnalyticsServisi.ekranAyarlar),
                                        builder: (context) =>
                                            const AyarlarEkrani()),
                                  );
                                  if (!mounted) return;
                                  _verileriYukle();
                                  _hakSayaciniGuncelle();
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderIconButton({
    required Key key,
    required IconData icon,
    required String tooltip,
    required Color iconColor,
    required VoidCallback onPressed,
  }) {
    // Dokunma alanı min 44dp olmalı (erişilebilirlik); ikon boyutu aynı kalır.
    return SizedBox(
      width: 44,
      height: 44,
      child: IconButton(
        key: key,
        padding: EdgeInsets.zero,
        tooltip: tooltip,
        icon: Icon(icon, size: 20, color: iconColor),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildCustomBottomNav() {
    final colorScheme = Theme.of(context).colorScheme;
    final double altBosluk = MediaQuery.of(context).padding.bottom;
    final double normalYukseklik = 62.0 + altBosluk;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeInOut,
      height: _isBarsVisible ? normalYukseklik : 0.0,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: _isBarsVisible ? 1.0 : 0.0,
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: ClipRRect(
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(24)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: Container(
                height: normalYukseklik,
                padding: EdgeInsets.fromLTRB(
                    8, 8, 8, altBosluk > 0 ? altBosluk : 8),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerLow.withValues(alpha: 0.90),
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(24)),
                  border: Border(
                    top: BorderSide(
                      color:
                          colorScheme.outlineVariant.withValues(alpha: 0.4),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(
                        Icons.door_sliding_outlined, Icons.door_sliding_rounded, 0,
                        key: _gardirobumNavKey),
                    _buildNavItem(Icons.calendar_month_outlined,
                        Icons.calendar_month_rounded, 1,
                        key: _haftalikNavKey),
                    _buildNavItem(Icons.casino_outlined, Icons.casino_rounded, 2,
                        key: _dolaptanNavKey),
                    _buildNavItem(Icons.add_box_outlined,
                        Icons.add_box_rounded, 3,
                        key: _kendiNavKey),
                    _buildNavItem(Icons.insights_outlined,
                        Icons.insights_rounded, 4,
                        key: _profilNavKey),
                    _buildNavItem(Icons.quiz_outlined, Icons.quiz_rounded, 5),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Sekmeyi değiştirir ve analitik için ekran görüntülemesi gönderir.
  void _sekmeSec(int index) {
    if (_seciliSekme == index) return;
    setState(() => _seciliSekme = index);
    AnalyticsServisi().ekranGoruntule(AnalyticsServisi.sekmeAdlari[index]);
  }

  Widget _buildNavItem(
      IconData unselectedIcon, IconData selectedIcon, int index,
      {Key? key}) {
    final isSelected = _seciliSekme == index;
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final labels = [
      l10n.anaSekmeGardirop,
      l10n.anaSekmeHaftalik,
      l10n.anaSekmeAnlik,
      l10n.kendiKombininiTasarlaTitle,
      l10n.anaSekmeProfil,
      l10n.yakinda,
    ];

    final iconColor = isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant;

    return Expanded(
      child: Semantics(
        label: labels[index],
        selected: isSelected,
        button: true,
        child: InkWell(
          key: key,
          onTap: () {
            if (_seciliSekme != index) {
              HapticFeedback.selectionClick();
              _sekmeSec(index);
            }
          },
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  transform: isSelected
                      ? Matrix4.diagonal3Values(1.1, 1.1, 1.0)
                      : Matrix4.identity(),
                  child: Icon(
                    isSelected ? selectedIcon : unselectedIcon,
                    color: iconColor,
                    size: 25,
                  ),
                ),
                const SizedBox(height: 4),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  width: isSelected ? 5 : 0,
                  height: isSelected ? 5 : 0,
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final List<Widget> ekranlar = [
      GardirobumEkrani(
        key: _gardirobumKey,
        gardirobum: _gardirobum,
        onKiyafetEkle: _kiyafetEkle,
        onKiyafetSil: _kiyafetSil,
        onGardirobuTemizle: _gardirobuTemizle,
        onSepetToggle: _sepetDurumunuDegistir,
        onKombinIstegi: _odakKiyafetIleKombinBaslat,
        anaRenk: _anaRenk,
      ),
      HaftalikPlanlayiciEkrani(
        gardirobum: _gardirobum,
        gunlukHava: _gunlukHavaDurumu,
        detayliHaftalikHava: _detayliHaftalikHavaMetni,
        havaYukleniyor: _havaYukleniyor,
        havaHatasi: _havaHatasi,
        onFavoriEkle: _favoriKombinEkle,
        onFavoriSil: _favoriKombinNesneIleSil,
        onGecmiseEkle: _kombinGecmisineEkle,
        onGecmistenCikar: _kombinGecmistenCikar,
        onKonumuYenile: _konumuYenileVeIzinIste,
        onKonumAyarlariniAc: _konumAyarlariniAc,
        anaRenk: _anaRenk,
      ),
      GunlukKombinEkrani(
        key: _dolaptanKombinKey,
        gardirobum: _gardirobum,
        favoriKombinler: _favoriKombinler,
        gunlukHava: _gunlukHavaDurumu,
        havaYukleniyor: _havaYukleniyor,
        havaHatasi: _havaHatasi,
        onFavoriEkle: _favoriKombinEkle,
        onFavoriSil: _favoriKombinNesneIleSil,
        onGecmiseEkle: _kombinGecmisineEkle,
        onKonumuYenile: _konumVeHavaDurumlariniAl,
        onKonumAyarlariniAc: _konumAyarlariniAc,
        anaRenk: _anaRenk,
        isAktifSekme: _seciliSekme == 2,
      ),
      KendiKombinimEkrani(
        gardirobum: _gardirobum,
        anaRenk: _anaRenk,
        onFavoriEkle: _favoriKombinEkle,
        onFavoriCikar: _favoriKombinBaslikIleSil,
        isFavoriKontrol: (parcaBasliklari) =>
            _isKombinFavoride(parcaBasliklari),
        onGecmiseEkle: _kombinGecmisineEkle,
      ),
      ProfilVeAnalizEkrani(
        gardirobum: _gardirobum,
        favoriKombinler: _favoriKombinler,
        gecmisKombinler: _gecmisKombinler,
        gunlukHava: _gunlukHavaDurumu,
        anaRenk: _anaRenk,
        onFavoriSil: _favoriKombinSil,
        onSepetiTemizle: _onSepetiTemizle,
        onTekliSepettenCikar: _onTekliSepettenCikar,
        onGecmisiTemizle: _onGecmisiTemizle,
        onTekliGecmisSil: _onTekliGecmisSil,
      ),
      KombinOyunuEkrani(onReturnToHome: () => _sekmeSec(0), gardirobum: _gardirobum),
    ];

    return Scaffold(
      extendBody: true,
      appBar: _buildPremiumAppBar(l10n),
      body: FadeIndexedStack(
        index: _seciliSekme,
        duration: const Duration(milliseconds: 300),
        children: ekranlar,
      ),
      bottomNavigationBar: _buildCustomBottomNav(),
    );
  }
}

/// 🔒 Simple async mutex to prevent race conditions on shared data operations.
/// Usage: `await _dataLock.synchronized(() async { ... });`
class _AsyncLock {
  bool _locked = false;

  Future<T> synchronized<T>(FutureOr<T> Function() callback) async {
    while (_locked) {
      await Future.delayed(const Duration(milliseconds: 10));
    }
    _locked = true;
    try {
      return await callback();
    } finally {
      _locked = false;
    }
  }
}