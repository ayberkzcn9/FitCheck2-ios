import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
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
// "Kendin Kombin Yap" sekmesi devre dışı bırakıldı; ekran dosyası
// (kendi_kombinim_ekrani.dart) repoda duruyor, sekme açılınca import geri gelir.
import 'profil_analiz_ekrani.dart';
import 'kombin_duellosu_ekrani.dart';
import 'ai_chatbot_modal.dart';
import 'ayarlar_ekrani.dart';
import 'izin_ekrani.dart';
import '../l10n/app_localizations.dart';
import '../services/analytics_servisi.dart';
import '../services/bildirim_servisi.dart';
import '../services/bildirim_zamanlayici.dart';
import '../services/kilyafet_yukleme_servisi.dart';
import '../services/fcm_service.dart';
import '../services/reklam_servisi.dart';
import '../utils/helpers.dart';
import '../ai/ai_dil.dart';
import '../widgets/ana_ekran_rehber.dart';
import '../widgets/alt_menu_cubugu.dart';
import 'bugun_ekrani.dart';
import 'seyahat_ekrani.dart';
import 'stil_gunlugu_ekrani.dart';

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

  // ---- Sekme indeksleri -------------------------------------------------
  // Sihirli sayı yerine ad kullanılıyor: başa yeni bir sekme eklendiğinde
  // (Bugün gibi) çağrıların tek tek düzeltilmesi gerekmiyor.
  static const int _sekmeBugun = Sekmeler.bugun;
  static const int _sekmeDolap = Sekmeler.dolap;
  static const int _sekmePlan = Sekmeler.plan;
  static const int _sekmeKombin = Sekmeler.kombin;
  static const int _sekmeKendi = Sekmeler.kendi;
  static const int _sekmeProfil = Sekmeler.profil; // ignore: unused_field
  static const int _sekmeOyun = Sekmeler.oyun;
  List<Kiyafet> _gardirobum = [];
  List<FavoriKombin> _favoriKombinler = [];
  List<Map<String, String>> _gecmisKombinler = [];

  /// Takvimde plan değiştikçe artar; Bugün ekranındaki plan kartını tazeler.
  int _planJetonu = 0;

  /// Çamaşır sepeti her değiştiğinde artar; Bugün ekranındaki "Giydildi"
  /// işaretinin yıkanan parçalar için sıfırlanmasını sağlar.
  int _sepetJetonu = 0;

  /// Arka plan yükleme durumu dinleyicisi.
  late final ValueNotifier<KilyafetYuklemeDurumu> _yuklemeListener;

  /// Arka plan işi daha önce çalışıyordu mu (bitiş bildirimini bir kez vermek için).
  bool _arkaPlanCalisiyordu = false;
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
  final bool _isBarsVisible = true;

  final GlobalKey<GunlukKombinEkraniState> _dolaptanKombinKey =
      GlobalKey<GunlukKombinEkraniState>();
  final GlobalKey<GardirobumEkraniState> _gardirobumKey =
      GlobalKey<GardirobumEkraniState>();

  final GlobalKey _topluFotografEkleKey = GlobalKey();
  final GlobalKey _aiStilistKey = GlobalKey();
  final GlobalKey _sesliAsistanKey = GlobalKey();
  final GlobalKey _ayarlarKey = GlobalKey();

  final GlobalKey _bugunNavKey = GlobalKey();
  final GlobalKey _gardirobumNavKey = GlobalKey();
  final GlobalKey _haftalikNavKey = GlobalKey();
  final GlobalKey _dolaptanNavKey = GlobalKey();
  // "Kendin Kombin Yap" sekmesi devre dışı: alt menüde ve rehberde yok.
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

    // Arka planda kıyafet yükleme durumu (ilerleme + bitiş bildirimi).
    _yuklemeListener = KilyafetYuklemeServisi().durum;
    _yuklemeListener.addListener(_arkaPlanDurumuDegisti);

    ReklamServisi().odulluReklamYukle();
    ReklamServisi().gecisReklamiYukle();

    // Bildirime dokununca ilgili sekme açılsın.
    BildirimServisi().hedefSekme.addListener(_bildirimYonlendirmesi);

    _degerlendirmeKontrolEt();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _rehberBaslat();
      if (mounted) {
        _bildirimYonlendirmesi();
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
    _yuklemeListener.removeListener(_arkaPlanDurumuDegisti);
    BildirimServisi().hedefSekme.removeListener(_bildirimYonlendirmesi);
    _speechToText.stop();
    super.dispose();
  }

  /// Arka plan yükleme bittiğinde kullanıcıya özet gösterir.
  void _arkaPlanDurumuDegisti() {
    final durum = _yuklemeListener.value;

    if (durum.calisiyor) {
      _arkaPlanCalisiyordu = true;
      return;
    }
    if (!_arkaPlanCalisiyordu) return;
    _arkaPlanCalisiyordu = false;
    if (!mounted) return;

    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;

    if (durum.eklenen > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.arkaPlandaTamamlandi(durum.eklenen)),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.lgRadius),
        ),
      );
    }

    if (durum.atlanan > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.arkaPlandaBaziAtlandi(durum.atlanan)),
          behavior: SnackBarBehavior.floating,
          backgroundColor: colors.error,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.lgRadius),
        ),
      );
    }
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
                borderRadius: AppRadius.mdRadius,
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
      await Future.delayed(AppMotion.uzun);
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
              borderRadius: AppRadius.lgRadius,
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
        // Sepet durumu değişti: Bugün'deki "Giydildi" işareti tazelensin.
        _sepetJetonu++;
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

  // NOT: Aşağıdaki iki yardımcı yalnızca "Kendin Kombin Yap" ekranı için
  // kullanılıyordu; sekme devre dışı olduğu için şimdilik çağrılmıyorlar.
  // Sekme yeniden açıldığında bağlantılar da geri gelecek.
  // ignore: unused_element
  Future<void> _favoriKombinBaslikIleSil(String baslik) async {
    await _dataLock.synchronized(() async {
      if (_verilerYukleniyor) return;
      setState(() {
        _favoriKombinler.removeWhere((f) => f.baslik == baslik);
      });
      await _verileriKaydet();
    });
  }

  // ignore: unused_element
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

  /// Fotoğraf ekleme akışı.
  ///
  /// Hem uygulama çubuğundaki kamera ikonu hem de "Bugün" ekranındaki
  /// "Fotoğrafla ekle" kutusu bu yolu kullanır; iki yerde ayrı mantık
  /// tutulmasın diye tek yere alındı.
  Future<void> _fotografEkleAkisi() async {
    HapticFeedback.mediumImpact();
    final int maxLimit = await ReklamServisi().maxKiyafetLimitiniGetir();
    if (!mounted) return;

    if (_gardirobum.length >= maxLimit) {
      AnaEkranDialoglar.gardiropLimitiDolduDiyaloguGoster(
        context: context,
        anaRenk: _anaRenk,
        maxLimit: maxLimit,
      );
      return;
    }

    if (_seciliSekme != _sekmeDolap) {
      _sekmeSec(_sekmeDolap);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _gardirobumKey.currentState?.topluFotografEkle();
      });
    } else {
      _gardirobumKey.currentState?.topluFotografEkle();
    }
  }

  /// "Stil Günlüğüm": takvim + günlük + haftalık rapor.
  Future<void> _stilGunluguAc() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => StilGunluguEkrani(
          gardirobum: _gardirobum,
          gecmisKombinler: _gecmisKombinler,
          favoriKombinler: _favoriKombinler,
          onKombinSekmesineGit: () {
            if (!mounted) return;
            _sekmeSec(Sekmeler.kombin);
          },
        ),
      ),
    );
    // Takvimde plan değişmiş olabilir; Bugün kartını tazele.
    if (!mounted) return;
    setState(() => _planJetonu++);
    // Bildirim metinleri tarihe özel planı okuduğu için seriyi yeniden kur.
    unawaited(
      BildirimZamanlayici.yenidenKur(context: context).catchError((_) {}),
    );
  }

  /// "Seyahat Modu": kısa geziler için valiz planı.
  void _seyahatAc() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => SeyahatEkrani(gardirobum: _gardirobum),
      ),
    );
  }

  /// Raftan tek parça "bugün giydim": parçayı sepete taşır ve kaydeder.
  Future<void> _kiyafetGiydi(Kiyafet kiyafet) async {
    await _dataLock.synchronized(() async {
      if (_verilerYukleniyor) {
        await _verilerHazir;
        if (!mounted) return;
      }

      final index = _gardirobum.indexWhere((k) => k.id == kiyafet.id);
      if (index < 0) return;

      final l10n = AppLocalizations.of(context)!;
      final eskiGiyilme = _gardirobum[index].sonGiyilmeTarihi;
      final eskiSayi = _gardirobum[index].giyilmeSayisi;

      setState(() {
        _gardirobum[index].giyildiOlarakIsaretle();
      });
      await _verileriKaydet();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.bugunParcaGiydimIsaretlendi(_gardirobum[index].gorunenBaslik),
          ),
          behavior: SnackBarBehavior.floating,
          // Yanlışlıkla işaretlenen parça geri alınabilsin.
          action: SnackBarAction(
            label: l10n.geriAl,
            onPressed: () => _kiyafetGiydimiGeriAl(
              kiyafet.id,
              eskiGiyilme,
              eskiSayi,
            ),
          ),
        ),
      );
    });
  }

  /// "Bugün giydim" işlemini geri alır: parça tekrar temiz olur.
  Future<void> _kiyafetGiydimiGeriAl(
    String id,
    DateTime? eskiGiyilme,
    int eskiSayi,
  ) async {
    await _dataLock.synchronized(() async {
      final index = _gardirobum.indexWhere((k) => k.id == id);
      if (index < 0) return;

      setState(() {
        _gardirobum[index]
          ..sepetteMi = false
          ..giyilmeSayisi = eskiSayi
          ..sonGiyilmeTarihi = eskiGiyilme;
        // Parça yeniden temiz: Bugün'deki "Giydildi" işareti tazelensin.
        _sepetJetonu++;
      });
      await _verileriKaydet();
    });
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

      final bugun = DateTime.now().toString().substring(0, 10);

      setState(() {
        // Aynı kombin bugün zaten kayıtlıysa satırı çoğaltma: sepet
        // temizlendikten sonra aynı kombin tekrar "Giydim" denebiliyor.
        final zatenVar = _gecmisKombinler.indexWhere(
          (k) =>
              k['tarih'] == bugun &&
              k['baslik'] == kombinAdi &&
              k['detay'] == detayMetni,
        );
        if (zatenVar >= 0) _gecmisKombinler.removeAt(zatenVar);

        _gecmisKombinler.insert(0, {
          "tarih": bugun,
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
            Future.delayed(AppMotion.orta, () {
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
                          borderRadius: AppRadius.mdRadius,
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
        // Parçalar sepete geri alındı: Bugün'deki "Giydildi" tazelensin.
        _sepetJetonu++;
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
        _sekmeSec(_sekmeKombin);

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
        _sekmeSec(_sekmeKombin);
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
        _sekmeSec(_sekmeKombin);
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
        // Bugün ekranı "Giydildi" işaretini bırakıp yeniden "Giydim" göstersin.
        _sepetJetonu++;
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
        _sepetJetonu++;
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
        duration: AppMotion.kisa,
        curve: AppMotion.giris,
        height: _isBarsVisible
            ? barHeight + MediaQuery.of(context).padding.top
            : 0.0,
        child: AnimatedOpacity(
          duration: AppMotion.kisa,
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
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
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
                            duration: AppMotion.kisa,
                            curve: AppMotion.giris,
                            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
                            decoration: BoxDecoration(
                              color: _kalanHak > 0
                                  ? AppAccents.warning.withValues(alpha: 0.15)
                                  : colorScheme.errorContainer,
                              borderRadius: AppRadius.xlRadius,
                              border: Border.all(
                                color: (_kalanHak > 0
                                        ? AppAccents.warning
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
                                      ? AppAccents.warning
                                      : colorScheme.error,
                                  size: 20,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _kalanHak >= 99999 ? '∞' : '$_kalanHak',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: AppText.sizeBodySmall,
                                    color: _kalanHak > 0
                                        ? AppAccents.warning
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
                              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
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
                                    onPressed: _fotografEkleAkisi,
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
    return AltMenuCubugu(
      seciliSekme: _seciliSekme,
      gorunur: _isBarsVisible,
      onSec: _sekmeSec,
      anahtarlar: <int, Key>{
        Sekmeler.bugun: _bugunNavKey,
        Sekmeler.dolap: _gardirobumNavKey,
        Sekmeler.plan: _haftalikNavKey,
        Sekmeler.kombin: _dolaptanNavKey,
        Sekmeler.profil: _profilNavKey,
      },
    );
  }

  /// Sekmeyi değiştirir ve analitik için ekran görüntülemesi gönderir.
  void _sekmeSec(int index) {
    // Devre dışı sekme: yanlışlıkla bir yönlendirme olursa Bugün'e düş.
    if (index == _sekmeKendi) {
      index = _sekmeBugun;
    }
    if (_seciliSekme == index) return;
    setState(() => _seciliSekme = index);
    AnalyticsServisi().ekranGoruntule(AnalyticsServisi.sekmeAdlari[index]);
  }

  /// Bildirim yükü → sekme. `BildirimServisi` bu değerleri kullanıyor.
  static const Map<String, int> _bildirimSekmeleri = <String, int>{
    'bugun': _sekmeBugun,
    'plan': _sekmePlan,
    'duello': _sekmeOyun,
  };

  /// Bildirime dokunulduysa hedef sekmeye geçer ve isteği tüketir.
  void _bildirimYonlendirmesi() {
    final hedef = BildirimServisi().hedefSekme.value;
    if (hedef == null) return;

    // Aynı bildirime iki kez tepki vermemek için önce tüket.
    BildirimServisi().hedefSekme.value = null;

    final index = _bildirimSekmeleri[hedef];
    if (index == null || !mounted) return;
    _sekmeSec(index);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final List<Widget> ekranlar = [
      BugunEkrani(
        gardirobum: _gardirobum,
        gunlukHava: _gunlukHavaDurumu,
        havaYukleniyor: _havaYukleniyor,
        isAktifSekme: _seciliSekme == _sekmeBugun,
        onSekmeSec: _sekmeSec,
        onFotografEkle: _fotografEkleAkisi,
        onFavoriEkle: _favoriKombinEkle,
        onGecmiseEkle: _kombinGecmisineEkle,
        onStilistAc: () => _aiChatbotModalAc(),
        onKiyafetGiyildi: _kiyafetGiydi,
        onKombinIstegi: _odakKiyafetIleKombinBaslat,
        onStilGunluguAc: _stilGunluguAc,
        onSeyahatAc: _seyahatAc,
        anaRenk: _anaRenk,
        planJetonu: _planJetonu,
        favoriKombinler: _favoriKombinler,
        gecmisKombinler: _gecmisKombinler,
        sepetJetonu: _sepetJetonu,
      ),
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
        isAktifSekme: _seciliSekme == _sekmeKombin,
      ),
      // 4) "Kendin Kombin Yap" sekmesi devre dışı bırakıldı.
      // Ekran kodu `kendi_kombinim_ekrani.dart` içinde duruyor; sekme
      // yeniden açılacaksa buradaki yer tutucu silinip ekran geri konur.
      // İndeksler (profil = 5, düello = 6) bozulmasın diye yer tutucu var.
      const SizedBox.shrink(),
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
      KombinDuellosuEkrani(
        gardirobum: _gardirobum,
        gunlukHava: _gunlukHavaDurumu,
        onReturnToHome: () => _sekmeSec(_sekmeBugun),
        onDolapAc: () => _sekmeSec(_sekmeDolap),
      ),
    ];

    return Scaffold(
      extendBody: true,
      appBar: _buildPremiumAppBar(l10n),
      body: Column(
        children: [
          // Arka planda kıyafet yükleniyorsa ince ilerleme çubuğu; ekran
          // kilitlenmez, kullanıcı uygulamayı kullanmaya devam eder.
          _arkaPlanIlerlemeCubugu(l10n),
          Expanded(
            child: FadeIndexedStack(
              index: _seciliSekme,
              duration: AppMotion.normal,
              children: ekranlar,
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildCustomBottomNav(),
    );
  }

  /// Arka plan yükleme durumu (varsa) ince bir çubuk olarak gösterilir.
  Widget _arkaPlanIlerlemeCubugu(AppLocalizations l10n) {
    return ValueListenableBuilder<KilyafetYuklemeDurumu>(
      valueListenable: KilyafetYuklemeServisi().durum,
      builder: (context, durum, _) {
        if (!durum.calisiyor) return const SizedBox.shrink();
        final colors = Theme.of(context).colorScheme;
        return Container(
          width: double.infinity,
          color: colors.surfaceContainerHigh,
          padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 6, AppSpacing.lg, AppSpacing.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.arkaPlandaIlerleme(durum.islenen, durum.toplam),
                      style: TextStyle(
                        fontSize: AppText.sizeMicro,
                        fontWeight: FontWeight.w700,
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ),
                  Text(
                    l10n.arkaPlandaEkle,
                    style: TextStyle(
                      fontSize: AppText.sizeMicro,
                      fontWeight: FontWeight.w800,
                      color: colors.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              ClipRRect(
                borderRadius: AppRadius.xsRadius,
                child: LinearProgressIndicator(
                  value: durum.oran,
                  minHeight: 4,
                  backgroundColor: colors.outlineVariant.withValues(alpha: 0.3),
                  color: colors.primary,
                ),
              ),
            ],
          ),
        );
      },
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