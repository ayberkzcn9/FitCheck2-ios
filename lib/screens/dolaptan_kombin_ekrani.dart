import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

import '../l10n/app_localizations.dart';
import '../models/favori_kombin.dart';
import '../models/kiyafet.dart';
import '../services/ai_service.dart';
import '../services/analytics_servisi.dart';
import '../services/reklam_servisi.dart';
import '../utils/haftalik_dialoglar.dart';
import '../utils/hava_uygunlugu.dart';
import '../utils/helpers.dart';
import '../utils/kategori_utils.dart';
import '../ai/ai_dil.dart';
import '../../theme/design_tokens.dart';

class DolaptanKombinStilistiEkrani extends StatefulWidget {
  final List<Kiyafet> gardirobum;
  final List<FavoriKombin> favoriKombinler;
  final String gunlukHava;
  final bool havaYukleniyor;
  final bool havaHatasi;
  final Function(FavoriKombin) onFavoriEkle;
  final Function(FavoriKombin)? onFavoriSil;
  final Future<void> Function(String, dynamic) onGecmiseEkle;
  final VoidCallback onKonumuYenile;
  final VoidCallback? onKonumAyarlariniAc;
  final Future<bool> Function()? onTekliKiyafetDegistir;
  final Color anaRenk;
  final bool isAktifSekme;

  const DolaptanKombinStilistiEkrani({
    super.key,
    required this.gardirobum,
    required this.favoriKombinler,
    required this.gunlukHava,
    required this.havaYukleniyor,
    this.havaHatasi = false,
    required this.onFavoriEkle,
    this.onFavoriSil,
    required this.onGecmiseEkle,
    required this.onKonumuYenile,
    this.onKonumAyarlariniAc,
    this.onTekliKiyafetDegistir,
    required this.anaRenk,
    this.isAktifSekme = true,
  });

  @override
  State<DolaptanKombinStilistiEkrani> createState() => DolaptanKombinStilistiEkraniState();
}

class DolaptanKombinStilistiEkraniState extends State<DolaptanKombinStilistiEkrani> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _donmeAnimasyonu;
  late Animation<double> _buyumeAnimasyonu;
  ShakeDetector? _shakeDetector;

  Kiyafet? _sonKombinUst;
  Kiyafet? _sonKombinAlt;
  Kiyafet? _sonKombinAyakkabi;
  Kiyafet? _sonKombinAksesuar;

  String _stilistYorumu = '';
  int _renkUyumuPuani = 90;
  bool _isFavori = false;
  bool _isBugunGiydildi = false;
  String _kombinTuru = '';
  bool _aiAnalizEdiyor = false;
  bool _popUpGosterildi = false;

  /// Kombin henüz oluşturulmadıysa daima lokalize bir ad döner.
  String _kombinBasligi(AppLocalizations l10n) =>
      l10n.stilistKombininTitle(
        _kombinTuru.trim().isEmpty ? l10n.rastgeleKombinTuru : _kombinTuru,
      );

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));

    _donmeAnimasyonu = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOutBack),
    );

    _buyumeAnimasyonu = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.2).chain(CurveTween(curve: Curves.easeOutCubic)), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.2, end: 1.0).chain(CurveTween(curve: Curves.easeInCubic)), weight: 50),
    ]).animate(_animController);

    _kayitliGiyilmeDurumunuYukle();

    _shakeDetector = ShakeDetector.autoStart(
      onPhoneShake: () {
        if (!mounted || _animController.isAnimating) return;
        HapticFeedback.heavyImpact();
        Vibration.vibrate(duration: 120);
        _animController.forward(from: 0.0);
        _rastgeleKombinOlustur();
      },
      minimumShakeCount: 1,
      shakeSlopTimeMS: 500,
      shakeCountResetTime: 3000,
      shakeThresholdGravity: 2.7,
    );

    _kontrolEtVePopUpGoster();
  }

  @override
  void didUpdateWidget(covariant DolaptanKombinStilistiEkrani oldWidget) {
    super.didUpdateWidget(oldWidget);
    _kontrolEtVePopUpGoster();
  }

  Future<void> _kontrolEtVePopUpGoster() async {
    if (!widget.isAktifSekme || _popUpGosterildi) return;

    final prefs = await SharedPreferences.getInstance();
    final bool dahaOnceGosterildi = prefs.getBool('zar_popup_gosterildi') ?? false;

    if (!dahaOnceGosterildi) {
      _popUpGosterildi = true;
      await prefs.setBool('zar_popup_gosterildi', true);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _zarSallaPopUpGoster();
        }
      });
    } else {
      _popUpGosterildi = true;
    }
  }

  @override
  void dispose() {
    _shakeDetector?.stopListening();
    _animController.dispose();
    super.dispose();
  }

  void _zarSallaPopUpGoster() {
    HapticFeedback.heavyImpact();
    Vibration.vibrate(duration: 80);
    HapticFeedback.mediumImpact();

    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.65),
      builder: (dialogContext) => ZarSallaDialog(
        onZarAtildi: () async {
          if (_animController.isAnimating) return;
          HapticFeedback.heavyImpact();
          Vibration.vibrate(duration: 150);
          await _animController.forward(from: 0.0);
          _rastgeleKombinOlustur();
        },
      ),
    );
  }

  Color _uyumRengiGetir(int puan) {
    if (puan <= 60) {
      return AppAccents.error;
    } else if (puan <= 80) {
      return AppAccents.info;
    } else {
      return AppAccents.success;
    }
  }

  bool _dolapKurallariniDogrula(List<Kiyafet> temizKiyafetler) {
    if (!mounted) return false;
    final l10n = AppLocalizations.of(context)!;
    final sayilar = <String, int>{'ust': 0, 'alt': 0, 'ayakkabi': 0};
    for (final kiyafet in temizKiyafetler) {
      final kategori = kategoriModeldenCikar(kiyafet.kategori);
      if (sayilar.containsKey(kategori)) {
        sayilar[kategori] = sayilar[kategori]! + 1;
      }
    }

    final eksikler = <String>[];
    if (sayilar['ust'] == 0) eksikler.add('${l10n.ustGiyim}: 0');
    if (sayilar['alt'] == 0) eksikler.add('${l10n.altGiyim}: 0');
    if (sayilar['ayakkabi'] == 0) eksikler.add('${l10n.ayakkabi}: 0');
    if (eksikler.isEmpty) return true;

    _tatliUyariGoster(
      l10n.stilistUyariDolapBosBaslik,
      '${l10n.dolabiKaristirEksikUyari}\n\n${eksikler.join(' • ')}',
    );
    return false;
  }

  /// Dolaptaki temiz parçaları kategoriye ve günün hava koşuluna göre süzer.
  ///
  /// Kışın şort/keten gibi yazlık, yazın ise yün/mont gibi kışlık parçalar
  /// rastgele kombinlere hiç girmez.
  List<Kiyafet> _kategoridekiUygunKiyafetler(
    List<Kiyafet> temizKiyafetler,
    String kategori,
    HavaKosulu? havaKosulu,
  ) {
    final kategoridekiler = temizKiyafetler
        .where((k) => kategoriModeldenCikar(k.kategori) == kategori)
        .toList();
    return havayaUygunKiyafetler(kategoridekiler, havaKosulu);
  }

  void _favoriDurumunuGuncelle() {
    final l10n = AppLocalizations.of(context)!;
    final mevcutParcalar = _mevcutKombinParcalariniGetir().map((k) => k.gorunenBaslik).toList();
    if (mevcutParcalar.isEmpty) {
      if (mounted) setState(() => _isFavori = false);
      return;
    }

    final geciciKombin = FavoriKombin(
      baslik: _kombinBasligi(l10n),
      parcalar: mevcutParcalar,
      tuyo: _stilistYorumu,
      renkUyumuPuani: _renkUyumuPuani,
    );

    final eslesmeVar = widget.favoriKombinler.any((f) => f == geciciKombin);

    if (mounted) {
      setState(() {
        _isFavori = eslesmeVar;
      });
    }
  }

  void _kombinHakkiBittiDiyaloguGoster() {
    if (!mounted) return;
    HaftalikDialoglar.kombinHakkiBittiGoster(
      context: context,
      anaRenk: widget.anaRenk,
      onHakKazanildi: () {
        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.tebriklerHakEklendi, style: const TextStyle(fontWeight: FontWeight.bold)),
              backgroundColor: AppAccents.success,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
          );
        }
      },
    );
  }

  Future<void> _kayitliGiyilmeDurumunuYukle() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final bugunStr = DateTime.now().toIso8601String().split('T').first;
      final kayitliTarih = prefs.getString('giyildi_tarihi_kombin_stilisti');
      if (mounted) {
        setState(() {
          _isBugunGiydildi = (kayitliTarih == bugunStr);
        });
      }
    } catch (e) {
      debugPrint("Giyildi bilgisi okunurken hata: $e");
    }
  }

  /// Favori durumunu değiştirir ve üst katmana bildirir.
  void _favoriDurumunuDegistir() {
    HapticFeedback.mediumImpact();
    final l10n = AppLocalizations.of(context)!;

    final mevcutParcalar = _mevcutKombinParcalariniGetir();
    final List<String> parcalar = mevcutParcalar.map((k) => k.gorunenBaslik).toList();

    final favoriObjesi = FavoriKombin(
      baslik: _kombinBasligi(l10n),
      parcalar: parcalar,
      tuyo: _stilistYorumu,
      renkUyumuPuani: _renkUyumuPuani,
    );

    setState(() {
      if (_isFavori) {
        _isFavori = false;
        if (widget.onFavoriSil != null) {
          final silinecek = widget.favoriKombinler.firstWhere(
            (f) => f == favoriObjesi,
            orElse: () => favoriObjesi,
          );
          widget.onFavoriSil!(silinecek);
        }
      } else {
        _isFavori = true;
        widget.onFavoriEkle(favoriObjesi);
      }
    });
  }

  Future<void> _bugunGiydimTetikle() async {
    HapticFeedback.heavyImpact();
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    final bool yeniDurum = !_isBugunGiydildi;

    setState(() {
      _isBugunGiydildi = yeniDurum;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final bugunStr = DateTime.now().toIso8601String().split('T').first;
      if (yeniDurum) {
        await prefs.setString('giyildi_tarihi_kombin_stilisti', bugunStr);
        final mevcutParcalar = _mevcutKombinParcalariniGetir();
        await widget.onGecmiseEkle(_kombinBasligi(l10n), mevcutParcalar);
      } else {
        await prefs.remove('giyildi_tarihi_kombin_stilisti');
      }
    } catch (e) {
      debugPrint("Giyildi kaydı hatası: $e");
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          yeniDurum
              ? l10n.kombinGiydimIsaretlendi(_kombinBasligi(l10n))
              : l10n.kombinIsaretlemeKaldirildi(_kombinBasligi(l10n)),
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: yeniDurum ? AppAccents.success : Colors.grey.shade700,
      ),
    );
  }

  List<Kiyafet> _mevcutKombinParcalariniGetir() {
    final List<Kiyafet> liste = [];
    if (_sonKombinUst != null) liste.add(_sonKombinUst!);
    if (_sonKombinAlt != null) liste.add(_sonKombinAlt!);
    if (_sonKombinAyakkabi != null) liste.add(_sonKombinAyakkabi!);
    if (_sonKombinAksesuar != null) liste.add(_sonKombinAksesuar!);
    return liste;
  }

  /// Konum etiketini temizlenmiş günlük hava metni. Hava durumu alınamadığında
  /// gösterilen durum metinleri olduğu gibi bırakılır.
  String get _formatliHavaMetni {
    final ham = widget.gunlukHava.trim();
    if (!havaDurumuKullanilabilirMi(ham, AppLocalizations.of(context)!)) {
      return ham;
    }
    return ham
        .replaceAll(RegExp(r'^(Konum Bugün:|Location Today:|Konum|Location):?\s*•?', caseSensitive: false), '')
        .trim();
  }

  /// Yapay zekâ istemlerinde kullanılacak hava durumu metni.
  String _istemIcinHavaMetni(AppLocalizations l10n) =>
      havaDurumuKullanilabilirMi(widget.gunlukHava, l10n)
          ? widget.gunlukHava
          : 'bilinmiyor (konum servisi kapalı, izin verilmedi veya veri yükleniyor)';

  /// Ekrandaki anlık kombin hakkında yapay zeka ile sohbet penceresini açar.
  void _kombinSohbetiniAc() {
    final parcalar = _mevcutKombinParcalariniGetir();
    if (parcalar.isEmpty) return;

    HapticFeedback.lightImpact();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Bu özellik yakında eklenecek'),
        backgroundColor: widget.anaRenk,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  void _netGorselModaliniAc(BuildContext context, Kiyafet seciliKiyafet) {
    final tumParcalar = _mevcutKombinParcalariniGetir();
    if (tumParcalar.isEmpty) return;

    final int baslangicIndex = tumParcalar.indexWhere((k) => k.id == seciliKiyafet.id);
    final tumParcalarId = tumParcalar.map((k) => k.id).toList();

    HaftalikDialoglar.netGorselModalGoster(
      context: context,
      anaRenk: widget.anaRenk,
      tumParcalarMetinleri: tumParcalarId,
      baslangicIndex: baslangicIndex != -1 ? baslangicIndex : 0,
      parcaBilgisiAyristir: (id, l10n) {
        final item = tumParcalar.firstWhere((k) => k.id == id, orElse: () => seciliKiyafet);
        String kat = kategoriModeldenCikar(item.kategori);
        String katGosterim = kategoriEtiketiGetir(kat, l10n);

        return {
          'baslik': item.gorunenBaslik,
          'kategori': katGosterim,
          'renk': item.renk,
          'stil': item.stil,
        };
      },
      gucluGorselBul: (id) {
        final item = tumParcalar.firstWhere((k) => k.id == id, orElse: () => seciliKiyafet);
        return item.resimBytes;
      },
    );
  }

  Future<void> otomatikKombinUret({String? hedefOrtam}) async {
    final temizKiyafetler = widget.gardirobum.where((k) => !k.sepetteMi).toList();
    if (!_dolapKurallariniDogrula(temizKiyafetler)) return;

    final int kalanHak = await ReklamServisi().kalanHakGetir();
    if (kalanHak <= 0) {
      _kombinHakkiBittiDiyaloguGoster();
      return;
    }

    _kombiniTemizle();
    await Future.delayed(const Duration(milliseconds: 300));

    if (!mounted) return;

    if (hedefOrtam != null && hedefOrtam.contains('[ZORUNLU_PARCA:')) {
      final RegExp regExp = RegExp(r'\[ZORUNLU_PARCA:\s*(.*?)\]');
      final match = regExp.firstMatch(hedefOrtam);

      if (match != null && match.group(1) != null) {
        final String zorunluMetin = match.group(1)!.trim().toLowerCase();

        try {
          final Kiyafet zorunluKiyafet = widget.gardirobum.firstWhere(
            (k) => !k.sepetteMi && (
              k.baslik.toLowerCase().contains(zorunluMetin) ||
              k.gorunenBaslik.toLowerCase().contains(zorunluMetin) ||
              zorunluMetin.contains(k.gorunenBaslik.toLowerCase()) ||
              zorunluMetin.contains(k.baslik.toLowerCase())
            )
          );

          _zorunluParcaIleKombinUret(zorunluKiyafet);
          return;
        } catch (e) {
          debugPrint("Zorunlu parça bulunamadı: $zorunluMetin");
        }
      }
    }

    _rastgeleKombinOlustur();
  }

  Future<void> _zorunluParcaIleKombinUret(Kiyafet zorunluKiyafet) async {
    await ReklamServisi().hakDusur();
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    HapticFeedback.heavyImpact();
    final random = Random();
    final temizKiyafetler = widget.gardirobum.where((k) => !k.sepetteMi).toList();
    if (!_dolapKurallariniDogrula(temizKiyafetler)) return;

    final HavaKosulu? havaKosulu = havaKosuluCikar(widget.gunlukHava);

    final temizUstler = _kategoridekiUygunKiyafetler(temizKiyafetler, 'ust', havaKosulu);
    final temizAltlar = _kategoridekiUygunKiyafetler(temizKiyafetler, 'alt', havaKosulu);
    final temizAyakkabilar = _kategoridekiUygunKiyafetler(temizKiyafetler, 'ayakkabi', havaKosulu);
    final temizAksesuarlar = _kategoridekiUygunKiyafetler(temizKiyafetler, 'aksesuar', havaKosulu);

    String zorunluKategori = kategoriModeldenCikar(zorunluKiyafet.kategori);

    setState(() {
      _sonKombinUst = zorunluKategori == 'ust' ? zorunluKiyafet : (temizUstler.isNotEmpty ? temizUstler[random.nextInt(temizUstler.length)] : null);
      _sonKombinAlt = zorunluKategori == 'alt' ? zorunluKiyafet : (temizAltlar.isNotEmpty ? temizAltlar[random.nextInt(temizAltlar.length)] : null);
      _sonKombinAyakkabi = zorunluKategori == 'ayakkabi' ? zorunluKiyafet : (temizAyakkabilar.isNotEmpty ? temizAyakkabilar[random.nextInt(temizAyakkabilar.length)] : null);
      _sonKombinAksesuar = zorunluKategori == 'aksesuar' ? zorunluKiyafet : (temizAksesuarlar.isNotEmpty && random.nextBool() ? temizAksesuarlar[random.nextInt(temizAksesuarlar.length)] : null);

      _renkUyumuPuani = (85 + random.nextInt(15)).toInt();
      _stilistYorumu = l10n.zorunluParcaYorumu(zorunluKiyafet.gorunenBaslik);
      _isBugunGiydildi = false;
      _kombinTuru = l10n.sihirliDokunus;
      _aiAnalizEdiyor = false;
    });

    _favoriDurumunuGuncelle();
    await AnalyticsServisi().olay('outfit_generated', {'source': 'focus_item'});
  }

  void _tatliUyariGoster(String baslik, String mesaj) {
    HaftalikDialoglar.tatliUyariGoster(
      context: context,
      baslik: baslik,
      mesaj: mesaj,
      anaRenk: widget.anaRenk,
    );
  }

  void _kombiniTemizle() {
    HapticFeedback.lightImpact();
    setState(() {
      _sonKombinUst = null;
      _sonKombinAlt = null;
      _sonKombinAyakkabi = null;
      _sonKombinAksesuar = null;
      _stilistYorumu = '';
      _isFavori = false;
      _isBugunGiydildi = false;
      _aiAnalizEdiyor = false;
    });
  }

  Future<void> _rastgeleKombinOlustur() async {
    final int kalanHak = await ReklamServisi().kalanHakGetir();
    if (!mounted) return;
    if (kalanHak <= 0) {
      _kombinHakkiBittiDiyaloguGoster();
      return;
    }

    final random = Random();
    final temizKiyafetler = widget.gardirobum.where((k) => !k.sepetteMi).toList();

    if (!_dolapKurallariniDogrula(temizKiyafetler)) return;

    final HavaKosulu? havaKosulu = havaKosuluCikar(widget.gunlukHava);

    final temizUstler = _kategoridekiUygunKiyafetler(temizKiyafetler, 'ust', havaKosulu);
    final temizAltlar = _kategoridekiUygunKiyafetler(temizKiyafetler, 'alt', havaKosulu);
    final temizAyakkabilar = _kategoridekiUygunKiyafetler(temizKiyafetler, 'ayakkabi', havaKosulu);
    final temizAksesuarlar = _kategoridekiUygunKiyafetler(temizKiyafetler, 'aksesuar', havaKosulu);

    await ReklamServisi().hakDusur();
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    HapticFeedback.heavyImpact();

    setState(() {
      _sonKombinUst = temizUstler[random.nextInt(temizUstler.length)];
      _sonKombinAlt = temizAltlar[random.nextInt(temizAltlar.length)];
      _sonKombinAyakkabi = temizAyakkabilar[random.nextInt(temizAyakkabilar.length)];

      if (temizAksesuarlar.isNotEmpty && random.nextBool()) {
        _sonKombinAksesuar = temizAksesuarlar[random.nextInt(temizAksesuarlar.length)];
      } else {
        _sonKombinAksesuar = null;
      }

      _renkUyumuPuani = (70 + random.nextInt(30)).toInt();
      _stilistYorumu = l10n.zarlarAtildiYorumu;
      _isBugunGiydildi = false;
      _kombinTuru = l10n.rastgeleKombinTuru;
      _aiAnalizEdiyor = false;
    });

    _favoriDurumunuGuncelle();
    await AnalyticsServisi().olay('outfit_generated', {'source': 'random'});
  }

  void _parcaDegistirModaliniAc(String bolge, Kiyafet guncelKiyafet) {
    HapticFeedback.mediumImpact();
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    final temizKiyafetler = widget.gardirobum.where((k) => !k.sepetteMi).toList();
    final secenekler = temizKiyafetler.where((k) => kategoriModeldenCikar(k.kategori) == bolge).toList();

    String modalBaslik = l10n.ustGiyim;
    if (bolge == 'alt') modalBaslik = l10n.altGiyim;
    if (bolge == 'ayakkabi') modalBaslik = l10n.ayakkabi;
    if (bolge == 'aksesuar') modalBaslik = l10n.disGiyim;

    HaftalikDialoglar.parcaDegistirModalGoster(
      context: context,
      anaRenk: widget.anaRenk,
      modalBaslik: modalBaslik,
      secenekler: secenekler,
      temizKiyafetler: temizKiyafetler,
      kategoriModeldenCikar: kategoriModeldenCikar,
      onTekliKiyafetDegistir: widget.onTekliKiyafetDegistir,
      onSecim: (yeniMetin) {
        final secilenItem = secenekler.firstWhere(
          (k) => yeniMetin.contains(k.baslik) || yeniMetin.contains(k.gorunenBaslik),
          orElse: () => secenekler.isNotEmpty ? secenekler.first : guncelKiyafet,
        );

        _parcaGuncelleVeAiAnalizEt(bolge, secilenItem);
      },
    );
  }

  Future<void> _parcaGuncelleVeAiAnalizEt(String bolge, Kiyafet yeniParca) async {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    final random = Random();
    final aiDili = aiHedefDil(Localizations.localeOf(context).languageCode);

    setState(() {
      if (bolge == 'ust') _sonKombinUst = yeniParca;
      if (bolge == 'alt') _sonKombinAlt = yeniParca;
      if (bolge == 'ayakkabi') _sonKombinAyakkabi = yeniParca;
      if (bolge == 'aksesuar') _sonKombinAksesuar = yeniParca;

      _kombinTuru = l10n.kisiselDokunus;
      _stilistYorumu = l10n.aiYeniParcaAnalizEdiyor;
      _isBugunGiydildi = false;
      _aiAnalizEdiyor = true;
    });

    _favoriDurumunuGuncelle();

    try {
      String parcaListesi = "";
      if (_sonKombinUst != null) parcaListesi += "${l10n.ustGiyim}: ${_sonKombinUst!.gorunenBaslik} (${_sonKombinUst!.renk}), ";
      if (_sonKombinAlt != null) parcaListesi += "${l10n.altGiyim}: ${_sonKombinAlt!.gorunenBaslik} (${_sonKombinAlt!.renk}), ";
      if (_sonKombinAyakkabi != null) parcaListesi += "${l10n.ayakkabi}: ${_sonKombinAyakkabi!.gorunenBaslik} (${_sonKombinAyakkabi!.renk}), ";
      if (_sonKombinAksesuar != null) parcaListesi += "${l10n.disGiyim}: ${_sonKombinAksesuar!.gorunenBaslik} (${_sonKombinAksesuar!.renk}), ";

      final aiCevap = await AiService().hibritAiSorgula(
        sistemPromptu: "Sen uzman bir moda stilistisin. You MUST answer in $aiDili language. Kullanıcının değiştirdiği bu kombini renk uyumu, stil ve hava durumuna (${_istemIcinHavaMetni(l10n)}) göre yeniden değerlendir.\n"
            "MEVSİM KURALI (ÇOK ÖNEMLİ): Kombini havaya uygunluğu açısından da değerlendir. Hava soğuksa (en yüksek sıcaklık 12°C ve altı) şort, keten, askılı, sandalet gibi yazlık parçalar uygun değildir; hava sıcaksa (en yüksek sıcaklık 28°C ve üstü) yün, mont, kaban, kalın triko, bot gibi kışlık parçalar uygun değildir. Uygun olmayan parça varsa 'yorum' alanında bunu açıkça belirt ve puanı düşür.\n"
            "SADECE şu JSON formatında cevap ver (başka hiçbir açıklama yazma):\n"
            "{\n  \"puan\": 85,\n  \"yorum\": \"Stilistin bu yeni kombinasyon hakkındaki samimi, yaratıcı ve profesyonel yorumu\"\n}",
        kullaniciMesaji: "Güncel kombin parçaları: $parcaListesi. Bu kombini puanla ve yorumla.",
      );

      String clean = aiCevap.replaceAll(RegExp(r'```json\s*|```\s*'), '').trim();
      final int firstBrace = clean.indexOf('{');
      final int lastBrace = clean.lastIndexOf('}');
      if (firstBrace != -1 && lastBrace != -1) {
        clean = clean.substring(firstBrace, lastBrace + 1);
      }

      final Map<String, dynamic> parsed = safeJsonDecodeMap(clean, tag: 'ai_swap');

      if (mounted) {
        setState(() {
          _renkUyumuPuani = (parsed['puan'] as num?)?.toInt() ?? (75 + random.nextInt(25)).toInt();
          _stilistYorumu = parsed['yorum']?.toString() ?? l10n.parcaDegisimVarsayilanYorum;
          _aiAnalizEdiyor = false;
        });
        _favoriDurumunuGuncelle();
        await AnalyticsServisi().olay('outfit_generated', {'source': 'ai_swap'});
      }
    } catch (e) {
      debugPrint("AI Kombin Güncelleme Hatası: $e");
      if (mounted) {
        setState(() {
          _renkUyumuPuani = (75 + random.nextInt(25)).toInt();
          _stilistYorumu = l10n.parcaDegisimHataYorum;
          _aiAnalizEdiyor = false;
        });
        _favoriDurumunuGuncelle();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    final bool kombinVarMi = _sonKombinUst != null || _sonKombinAlt != null || _sonKombinAyakkabi != null;
    final Color uyumRengi = _uyumRengiGetir(_renkUyumuPuani);

    Widget zarAtButonu = ElevatedButton(
      onPressed: () async {
        if (_animController.isAnimating) return;
        HapticFeedback.selectionClick();
        await _animController.forward(from: 0.0);
        _rastgeleKombinOlustur();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppAccents.success,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          ScaleTransition(
            scale: _buyumeAnimasyonu,
            child: RotationTransition(
              turns: _donmeAnimasyonu,
              child: const Icon(
                Icons.casino_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                kombinVarMi ? l10n.yenidenZarAt : l10n.zarAtKaristir,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
           SliverAppBar(
  pinned: false,
  floating: false,
  snap: false,
  backgroundColor: theme.scaffoldBackgroundColor,
  surfaceTintColor: Colors.transparent,
  elevation: 0,
  centerTitle: true,
  title: Text(
    l10n.stilistTitle,
    style: TextStyle(
      fontWeight: FontWeight.w900,
      fontSize: 18,
      letterSpacing: -0.5,
      color: colors.onSurface,
    ),
  ),
  actions: [
    IconButton(
      onPressed: _zarSallaPopUpGoster,
      icon: const Icon(Icons.casino_rounded),
      tooltip: l10n.zarSalla,
    ),
    const SizedBox(width: 8),
  ],
),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Card(
                          elevation: 0,
                          color: colors.surfaceContainerLow,
                          shape: RoundedRectangleBorder(
                            borderRadius: AppRadius.xlRadius,
                            side: BorderSide(
                              color: widget.havaHatasi
                                  ? colors.error.withValues(alpha: 0.3)
                                  : colors.outlineVariant.withValues(alpha: 0.4),
                              width: 1.2,
                            ),
                          ),
                          child: InkWell(
                            borderRadius: AppRadius.xlRadius,
                            onTap: () {
                              HapticFeedback.lightImpact();
                              widget.onKonumuYenile();
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: widget.havaHatasi
                                          ? colors.errorContainer
                                          : colors.primaryContainer,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      widget.havaHatasi
                                          ? Icons.location_off_rounded
                                          : Icons.my_location_rounded,
                                      color: widget.havaHatasi
                                          ? colors.onErrorContainer
                                          : colors.onPrimaryContainer,
                                      size: 18,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          l10n.stilistAnlikHavaDurumu.toUpperCase(),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: colors.primary,
                                            fontWeight: FontWeight.w900,
                                            letterSpacing: 1.0,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          widget.havaYukleniyor
                                              ? l10n.stilistKonumKontrol
                                              : (_formatliHavaMetni.isEmpty ? l10n.yukleniyor : _formatliHavaMetni),
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w800,
                                            color: widget.havaHatasi ? colors.error : colors.onSurface,
                                            letterSpacing: -0.2,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (widget.havaHatasi && widget.onKonumAyarlariniAc != null) ...[
                                    IconButton.filledTonal(
                                      onPressed: () {
                                        HapticFeedback.lightImpact();
                                        widget.onKonumAyarlariniAc?.call();
                                      },
                                      icon: const Icon(Icons.settings_rounded, size: 18),
                                      tooltip: l10n.ayarlaraGit,
                                      style: IconButton.styleFrom(
                                        backgroundColor: colors.errorContainer,
                                        foregroundColor: colors.onErrorContainer,
                                        padding: const EdgeInsets.all(8),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                  ],
                                  Icon(
                                    Icons.refresh_rounded,
                                    size: 18,
                                    color: colors.onSurfaceVariant,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        if (kombinVarMi)
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: SizedBox(
                                  height: 50,
                                  child: OutlinedButton.icon(
                                    onPressed: _kombiniTemizle,
                                    icon: Icon(Icons.delete_sweep_rounded, size: 18, color: colors.error),
                                    label: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        l10n.temizle,
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: colors.error),
                                      ),
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: colors.error,
                                      side: BorderSide(color: colors.error.withValues(alpha: 0.4), width: 1.5),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                      padding: const EdgeInsets.symmetric(horizontal: 4),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                flex: 2,
                                child: SizedBox(
                                  height: 50,
                                  child: zarAtButonu,
                                ),
                              ),
                            ],
                          )
                        else
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: zarAtButonu,
                          ),

                        const SizedBox(height: 16),
                      ],
                    ),

                    if (kombinVarMi)
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: colors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(color: colors.outlineVariant.withValues(alpha: 0.4), width: 1.2),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Kombin Başlığı ve Uyum Puanı
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: uyumRengi.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: uyumRengi.withValues(alpha: 0.4)),
                                  ),
                                  child: Text(
                                    l10n.stilistUyum(_renkUyumuPuani.toString()),
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w900,
                                      color: uyumRengi,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 250),
                                child: Text(
                                  l10n.stilistKombininTitle(_kombinTuru),
                                  key: ValueKey<String>(_kombinTuru),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: -0.3, color: colors.onSurface),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              height: 220,
                              child: ListView(
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                children: [
                                  if (_sonKombinUst != null) _kombinParcaKart(context, l10n.stilistUstGiyim, _sonKombinUst!, 'ust'),
                                  if (_sonKombinAlt != null) _kombinParcaKart(context, l10n.stilistAltGiyim, _sonKombinAlt!, 'alt'),
                                  if (_sonKombinAyakkabi != null) _kombinParcaKart(context, l10n.stilistAyakkabi, _sonKombinAyakkabi!, 'ayakkabi'),
                                  if (_sonKombinAksesuar != null) _kombinParcaKart(context, l10n.disGiyim, _sonKombinAksesuar!, 'aksesuar'),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),

                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppTints.styleistBgDinamik(context),
                                borderRadius: AppRadius.xlRadius,
                                border: Border.all(
                                  color: AppTints.styleistBorderDinamik(context),
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.auto_awesome_rounded,
                                    size: 18,
                                    color: AppAccents.styleist,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _aiAnalizEdiyor
                                        ? Row(
                                            children: [
                                              const SizedBox(
                                                width: 16,
                                                height: 16,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  color: AppAccents.styleist,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                l10n.yenidenDegerlendiriliyor,
                                                style: theme.textTheme.bodyMedium?.copyWith(
                                                  fontStyle: FontStyle.italic,
                                                  color: AppMiscColors.styleistAltTextDinamik(context),
                                                ),
                                              ),
                                            ],
                                          )
                                        : Text(
                                            metniGuvenliYap(_stilistYorumu),
                                            style: theme.textTheme.bodyMedium?.copyWith(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: AppMiscColors.styleistTextDinamik(context),
                                              height: 1.45,
                                            ),
                                          ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                // Favori Butonu
                                Tooltip(
                                  message: _isFavori ? l10n.favorilerdeEtiketi : l10n.stilistFavoriyeEkle,
                                  child: IconButton.filledTonal(
                                    icon: Icon(
                                      _isFavori ? Icons.star_rounded : Icons.star_border_rounded,
                                      size: 22,
                                    ),
                                    style: IconButton.styleFrom(
                                      backgroundColor: _isFavori ? AppStatusColors.favoriteBgDinamik(context) : colors.surfaceContainerHighest,
                                      foregroundColor: _isFavori ? AppStatusColors.favoriteFgDinamik(context) : colors.onSurfaceVariant,
                                    ),
                                    onPressed: _favoriDurumunuDegistir,
                                  ),
                                ),
                                const SizedBox(width: 8),

                                // Giydim Butonu
                                Tooltip(
                                  message: _isBugunGiydildi ? l10n.bugunGiydildiEtiketi : l10n.stilistBugunGiydim,
                                  child: IconButton.filledTonal(
                                    icon: Icon(
                                      _isBugunGiydildi ? Icons.check_circle_rounded : Icons.check_circle_outline_rounded,
                                      size: 22,
                                    ),
                                    style: IconButton.styleFrom(
                                      backgroundColor: _isBugunGiydildi ? AppStatusColors.wornBgDinamik(context) : colors.surfaceContainerHighest,
                                      foregroundColor: _isBugunGiydildi ? AppStatusColors.wornFgDinamik(context) : colors.onSurfaceVariant,
                                    ),
                                    onPressed: _bugunGiydimTetikle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // Sohbet Butonu
                                Tooltip(
                                  message: l10n.kombinSohbetAc,
                                  child: IconButton.filledTonal(
                                    icon: const Icon(Icons.chat_bubble_outline_rounded, size: 22),
                                    style: IconButton.styleFrom(
                                      backgroundColor: colors.surfaceContainerHighest,
                                      foregroundColor: colors.onSurfaceVariant,
                                    ),
                                    onPressed: _mevcutKombinParcalariniGetir().isNotEmpty ? _kombinSohbetiniAc : null,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _kombinParcaKart(BuildContext context, String etiket, Kiyafet kiyafet, String bolge) {
    return SadeKiyafetKarti(
      kiyafet: kiyafet,
      etiket: etiket,
      bolge: bolge,
      onDegistir: ([bool ileriMi = true]) => _parcaDegistirModaliniAc(bolge, kiyafet),
      onDokunma: () => _netGorselModaliniAc(context, kiyafet),
    );
  }
}

class SadeKiyafetKarti extends StatelessWidget {
  final Kiyafet kiyafet;
  final String etiket;
  final String bolge;
  final Function([bool ileriMi]) onDegistir;
  final VoidCallback onDokunma;

  const SadeKiyafetKarti({
    super.key,
    required this.kiyafet,
    required this.etiket,
    required this.bolge,
    required this.onDegistir,
    required this.onDokunma,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: 145,
      margin: const EdgeInsets.only(right: 16, top: 4, bottom: 4),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: colors.outlineVariant.withValues(alpha: 0.4),
          width: 1.2,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onDokunma,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20.5)),
                      child: SizedBox(
                        height: 110,
                        width: double.infinity,
                        child: Image.memory(
                          kiyafet.resimBytes,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Center(
                            child: Icon(Icons.broken_image_outlined, color: colors.onSurfaceVariant),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0, left: 0, right: 0, height: 40,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter, end: Alignment.bottomCenter,
                            colors: [Colors.black.withValues(alpha: 0.4), Colors.transparent],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 6,
                      right: 6,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: AppRadius.xlRadius,
                          onTap: () => onDegistir(true),
                          child: ClipRRect(
                            borderRadius: AppRadius.xlRadius,
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.35),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
                                ),
                                child: const Icon(Icons.sync_rounded, color: Colors.white, size: 16),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          etiket.toUpperCase(),
                          style: TextStyle(
                            fontSize: 12,
                            color: colors.primary,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.8,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          kiyafet.gorunenBaslik,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: colors.onSurface,
                            letterSpacing: -0.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 1),
                        Text(
                          kiyafet.renk,
                          style: TextStyle(
                            fontSize: 12,
                            color: colors.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Static Dice Pop-up Dialog (Animasyonsuz)
class ZarSallaDialog extends StatelessWidget {
  final VoidCallback onZarAtildi;

  const ZarSallaDialog({super.key, required this.onZarAtildi});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Dialog(
        backgroundColor: colors.surfaceContainerHigh,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
          side: BorderSide(color: colors.outlineVariant.withValues(alpha: 0.4)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppAccents.success.withValues(alpha: 0.15),
                      borderRadius: AppRadius.xlRadius,
                      border: Border.all(
                        color: AppAccents.success.withValues(alpha: 0.4),
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.casino_rounded,
                      size: 40,
                      color: AppAccents.success,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colors.primary.withValues(alpha: 0.15),
                      borderRadius: AppRadius.xlRadius,
                      border: Border.all(
                        color: colors.primary.withValues(alpha: 0.4),
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.casino_rounded,
                      size: 40,
                      color: colors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                l10n.zarPopupBaslik,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                  color: colors.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.zarPopupAciklama,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  fontWeight: FontWeight.w500,
                  color: colors.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        HapticFeedback.selectionClick();
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        l10n.iptal,
                        style: TextStyle(
                          color: colors.onSurfaceVariant,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        HapticFeedback.heavyImpact();
                        Vibration.vibrate(duration: 120);
                        Navigator.pop(context);
                        onZarAtildi();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppAccents.success,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      icon: const Icon(Icons.casino_rounded, size: 20),
                      label: Text(
                        l10n.zarlariAt,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ShakeDetector {
  final void Function() onPhoneShake;
  final double shakeThresholdGravity;
  final int minimumShakeCount;
  final int shakeSlopTimeMS;
  final int shakeCountResetTime;

  StreamSubscription<AccelerometerEvent>? _subscription;
  int _shakeCount = 0;
  int _lastShakeTime = 0;

  ShakeDetector.autoStart({
    required this.onPhoneShake,
    this.shakeThresholdGravity = 2.7,
    this.minimumShakeCount = 1,
    this.shakeSlopTimeMS = 500,
    this.shakeCountResetTime = 3000,
  }) {
    startListening();
  }

  void startListening() {
    _subscription = accelerometerEventStream().listen((AccelerometerEvent event) {
      double gX = event.x / 9.80665;
      double gY = event.y / 9.80665;
      double gZ = event.z / 9.80665;

      double gForce = sqrt(gX * gX + gY * gY + gZ * gZ);

      if (gForce > shakeThresholdGravity) {
        final now = DateTime.now().millisecondsSinceEpoch;

        if (_lastShakeTime + shakeSlopTimeMS > now) {
          return;
        }

        if (_lastShakeTime + shakeCountResetTime < now) {
          _shakeCount = 0;
        }

        _lastShakeTime = now;
        _shakeCount++;

        if (_shakeCount >= minimumShakeCount) {
          onPhoneShake();
        }
      }
    });
  }

  void stopListening() {
    _subscription?.cancel();
    _subscription = null;
  }
}