// Günlük Kombin Ekranı - Haftalık planlayıcı tasarımında tek günlük kombin
// Zar atarak rastgele günlük kombin üretir

import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

import '../l10n/app_localizations.dart';
import '../models/favori_kombin.dart';
import '../models/kiyafet.dart';
import '../services/analytics_servisi.dart';
import '../services/reklam_servisi.dart';
import '../utils/haftalik_dialoglar.dart';
import '../utils/hava_uygunlugu.dart';
import '../utils/helpers.dart';
import '../utils/kategori_utils.dart';
import '../utils/shake_detector.dart';
import '../widgets/hava_bar.dart';
import '../widgets/zar_salla_dialog.dart';
import 'ai_chatbot_modal.dart';

class GunlukKombinEkrani extends StatefulWidget {
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
  final Color anaRenk;
  final bool isAktifSekme;

  const GunlukKombinEkrani({
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
    required this.anaRenk,
    this.isAktifSekme = true,
  });

  @override
  State<GunlukKombinEkrani> createState() => GunlukKombinEkraniState();
}

class GunlukKombinEkraniState extends State<GunlukKombinEkrani>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late AnimationController _pulseController;
  ShakeDetector? _shakeDetector;

  Kiyafet? _sonKombinUst;
  Kiyafet? _sonKombinAlt;
  Kiyafet? _sonKombinAyakkabi;
  Kiyafet? _sonKombinAksesuar;

  String _stilistYorumu = '';
  int _renkUyumuPuani = 90;
  bool _isFavori = false;
  bool _isBugunGiydildi = false;
  bool _aiAnalizEdiyor = false;
  bool _popUpGosterildi = false;

  String get _kombinBasligi {
    final l10n = AppLocalizations.of(context)!;
    return l10n.gunlukKombinKartBaslik;
  }

  /// Dışarıdan (AI chatbot, odak parça vb.) kombin üretim tetiklemesi.
  /// [hedefOrtam] içinde '[ZORUNLU_PARCA: ...]' varsa o parça zorunlu tutulur.
  Future<void> otomatikKombinUret({String? hedefOrtam}) async {
    final temizKiyafetler =
        widget.gardirobum.where((k) => !k.sepetteMi).toList();
    if (temizKiyafetler.isEmpty) return;

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
            (k) =>
                !k.sepetteMi &&
                (k.baslik.toLowerCase().contains(zorunluMetin) ||
                    k.gorunenBaslik.toLowerCase().contains(zorunluMetin) ||
                    zorunluMetin.contains(k.gorunenBaslik.toLowerCase()) ||
                    zorunluMetin.contains(k.baslik.toLowerCase())),
          );
          await _zorunluParcaIleKombinUret(zorunluKiyafet);
          return;
        } catch (e) {
          debugPrint("Zorunlu parça bulunamadı: $zorunluMetin");
        }
      }
    }

    await _rastgeleKombinOlustur();
  }

  Future<void> _zorunluParcaIleKombinUret(Kiyafet zorunluKiyafet) async {
    final int kalanHak = await ReklamServisi().kalanHakGetir();
    if (!mounted) return;
    if (kalanHak <= 0) {
      HaftalikDialoglar.kombinHakkiBittiGoster(
        context: context,
        anaRenk: widget.anaRenk,
        onHakKazanildi: () {},
      );
      return;
    }

    await ReklamServisi().hakDusur();
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    HapticFeedback.heavyImpact();
    final random = Random();
    final temizKiyafetler =
        widget.gardirobum.where((k) => !k.sepetteMi).toList();

    final HavaKosulu? havaKosulu = havaKosuluCikar(widget.gunlukHava);
    final temizUstler =
        _kategoridekiUygunKiyafetler(temizKiyafetler, 'ust', havaKosulu);
    final temizAltlar =
        _kategoridekiUygunKiyafetler(temizKiyafetler, 'alt', havaKosulu);
    final temizAyakkabilar =
        _kategoridekiUygunKiyafetler(temizKiyafetler, 'ayakkabi', havaKosulu);
    final temizAksesuarlar =
        _kategoridekiUygunKiyafetler(temizKiyafetler, 'aksesuar', havaKosulu);

    final String zorunluKategori = kategoriModeldenCikar(zorunluKiyafet.kategori);

    setState(() {
      _sonKombinUst = zorunluKategori == 'ust'
          ? zorunluKiyafet
          : (temizUstler.isNotEmpty
              ? temizUstler[random.nextInt(temizUstler.length)]
              : null);
      _sonKombinAlt = zorunluKategori == 'alt'
          ? zorunluKiyafet
          : (temizAltlar.isNotEmpty
              ? temizAltlar[random.nextInt(temizAltlar.length)]
              : null);
      _sonKombinAyakkabi = zorunluKategori == 'ayakkabi'
          ? zorunluKiyafet
          : (temizAyakkabilar.isNotEmpty
              ? temizAyakkabilar[random.nextInt(temizAyakkabilar.length)]
              : null);
      _sonKombinAksesuar = zorunluKategori == 'aksesuar'
          ? zorunluKiyafet
          : (temizAksesuarlar.isNotEmpty && random.nextBool()
              ? temizAksesuarlar[random.nextInt(temizAksesuarlar.length)]
              : null);

      _renkUyumuPuani = (85 + random.nextInt(15)).toInt();
      _stilistYorumu = l10n.zorunluParcaYorumu(zorunluKiyafet.gorunenBaslik);
      _isBugunGiydildi = false;
      _aiAnalizEdiyor = false;
    });

    _favoriDurumunuYenile();
    await AnalyticsServisi()
        .olay('outfit_generated', {'source': 'focus_item'});
    _olusturulanKombiniTamEkranAc();
  }

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));

    // Zar butonu için sürekli yanıp sönen glow animasyonu
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _kayitliDurumlariYukle();

    _shakeDetector = ShakeDetector.autoStart(
      onPhoneShake: () {
        if (!mounted || _animController.isAnimating) return;
        // Yalnızca bu sekme aktifken ve modal açık değilken sallamaya tepki ver.
        if (!widget.isAktifSekme) return;
        if (_modalAcik) return;
        HapticFeedback.heavyImpact();
        Vibration.vibrate(duration: 120);
        _animController.forward(from: 0.0);
        _rastgeleKombinOlustur();
      },
      minimumShakeCount: 1,
      shakeSlopTimeMS: 450,
      shakeCountResetTime: 3000,
      // Daha yumuşak/küçük sallamalarla da tetiklensin diye eşik düşürüldü.
      shakeThresholdGravity: 1.6,
    );

    _kontrolEtVePopUpGoster();
  }

  /// Ekranın üstünde bir modal (dialog / bottom sheet) açık mı?
  /// ModalRoute yerine kendi bayrağımızı kullanıyoruz; böylece sallama
  /// algılayıcısı yanlışlıkla bloke edilmez.
  bool _modalAcik = false;

  /// İlk açılışta "telefonu salla" ipucu popup'ını, sekme ilk kez aktif
  /// olduğunda bir kez gösterir.
  Future<void> _kontrolEtVePopUpGoster() async {
    if (!widget.isAktifSekme || _popUpGosterildi) return;
    _popUpGosterildi = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final bool dahaOnceGosterildi =
          prefs.getBool('zar_popup_gosterildi_gunluk') ?? false;
      if (dahaOnceGosterildi) return;
      await prefs.setBool('zar_popup_gosterildi_gunluk', true);
      if (!mounted) return;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _zarSallaPopUpGoster();
      });
    } catch (e) {
      debugPrint('Zar popup hatası: $e');
    }
  }

  @override
  void didUpdateWidget(covariant GunlukKombinEkrani oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isAktifSekme && !oldWidget.isAktifSekme) {
      _kontrolEtVePopUpGoster();
    }
  }

  void _zarSallaPopUpGoster() {
    if (!mounted) return;
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

  @override
  void dispose() {
    _shakeDetector?.stopListening();
    _animController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _kayitliDurumlariYukle() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final bugunStr = DateTime.now().toIso8601String().split('T').first;
      final kayitliTarih = prefs.getString('giyildi_tarihi_gunluk_kombin');
      if (mounted) {
        setState(() {
          _isBugunGiydildi = (kayitliTarih == bugunStr);
        });
      }
    } catch (e) {
      debugPrint("Giyildi bilgisi okunurken hata: $e");
    }
  }

  List<Kiyafet> _mevcutKombinParcalariniGetir() {
    final liste = <Kiyafet>[];
    if (_sonKombinUst != null) liste.add(_sonKombinUst!);
    if (_sonKombinAlt != null) liste.add(_sonKombinAlt!);
    if (_sonKombinAyakkabi != null) liste.add(_sonKombinAyakkabi!);
    if (_sonKombinAksesuar != null) liste.add(_sonKombinAksesuar!);
    return liste;
  }

  bool get _kombinVarMi =>
      _sonKombinUst != null ||
      _sonKombinAlt != null ||
      _sonKombinAyakkabi != null;

  /// Dolapta kombin kurulabilecek temiz parça var mı?
  bool get _temizKiyafetVarMi =>
      widget.gardirobum.any((k) => !k.sepetteMi);

  void _favoriDurumunuDegistir() {
    HapticFeedback.mediumImpact();
    final mevcutParcalar = _mevcutKombinParcalariniGetir();
    if (mevcutParcalar.isEmpty) return;

    final favoriObjesi = FavoriKombin(
      baslik: _kombinBasligi,
      parcalar: mevcutParcalar.map((k) => k.gorunenBaslik).toList(),
      tuyo: _stilistYorumu,
      renkUyumuPuani: _renkUyumuPuani,
    );

    setState(() {
      if (_isFavori) {
        _isFavori = false;
        widget.onFavoriSil
            ?.call(widget.favoriKombinler.firstWhere((f) => f == favoriObjesi,
                orElse: () => favoriObjesi));
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

    setState(() => _isBugunGiydildi = yeniDurum);

    try {
      final prefs = await SharedPreferences.getInstance();
      final bugunStr = DateTime.now().toIso8601String().split('T').first;
      if (yeniDurum) {
        await prefs.setString('giyildi_tarihi_gunluk_kombin', bugunStr);
        await widget.onGecmiseEkle(
            _kombinBasligi, _mevcutKombinParcalariniGetir());
      } else {
        await prefs.remove('giyildi_tarihi_gunluk_kombin');
      }
    } catch (e) {
      debugPrint("Giyildi kaydı hatası: $e");
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          yeniDurum
              ? l10n.kombinGiydimIsaretlendi(_kombinBasligi)
              : l10n.kombinIsaretlemeKaldirildi(_kombinBasligi),
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor:
            yeniDurum ? const Color(0xFF16A34A) : Colors.grey.shade700,
      ),
    );
  }

  Future<void> _kombinSohbetiniAc() async {
    final parcalar = _mevcutKombinParcalariniGetir();
    if (parcalar.isEmpty) return;
    HapticFeedback.lightImpact();
    if (!mounted) return;

    // Görünen mesaj sadece kombin başlığı; parça bilgisi gizli bağlam olarak
    // AI'ya iletilir (chat ekranında görünmez).
    final baslangicMetni = _kombinBasligi;
    final parcaMetinleri =
        parcalar.map((k) => '${k.gorunenBaslik} (${k.renk})').join(', ');
    final gizliBaglam =
        'Kombin: $_kombinBasligi\n'
        'Parçalar: $parcaMetinleri\n'
        'Renk Uyumu: $_renkUyumuPuani%\n'
        'Hava: ${widget.gunlukHava}';

    _modalAcik = true;
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 20),
        child: AiChatbotPenceresi(
          gardirobum: widget.gardirobum,
          gunlukHava: widget.gunlukHava,
          ilkMesaj: baslangicMetni,
          gizliBaglam: gizliBaglam,
          anaRenk: widget.anaRenk,
        ),
      ),
    );
    _modalAcik = false;
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

  List<Kiyafet> _kategoridekiUygunKiyafetler(
      List<Kiyafet> temizKiyafetler, String kategori, HavaKosulu? havaKosulu) {
    final kategoridekiler = temizKiyafetler
        .where((k) => kategoriModeldenCikar(k.kategori) == kategori)
        .toList();
    return havayaUygunKiyafetler(kategoridekiler, havaKosulu);
  }

  Future<void> _rastgeleKombinOlustur() async {
    final int kalanHak = await ReklamServisi().kalanHakGetir();
    if (!mounted) return;
    if (kalanHak <= 0) {
      HaftalikDialoglar.kombinHakkiBittiGoster(
        context: context,
        anaRenk: widget.anaRenk,
        onHakKazanildi: () {},
      );
      return;
    }

    final random = Random();
    final temizKiyafetler =
        widget.gardirobum.where((k) => !k.sepetteMi).toList();

    if (temizKiyafetler.isEmpty) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      HaftalikDialoglar.tatliUyariGoster(
        context: context,
        baslik: l10n.haftalikUyariDolapBosBaslik,
        mesaj: l10n.haftalikUyariDolapBosIcerik,
        anaRenk: widget.anaRenk,
      );
      return;
    }

    final HavaKosulu? havaKosulu = havaKosuluCikar(widget.gunlukHava);
    final temizUstler =
        _kategoridekiUygunKiyafetler(temizKiyafetler, 'ust', havaKosulu);
    final temizAltlar =
        _kategoridekiUygunKiyafetler(temizKiyafetler, 'alt', havaKosulu);
    final temizAyakkabilar =
        _kategoridekiUygunKiyafetler(temizKiyafetler, 'ayakkabi', havaKosulu);
    final temizAksesuarlar =
        _kategoridekiUygunKiyafetler(temizKiyafetler, 'aksesuar', havaKosulu);

    await ReklamServisi().hakDusur();
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    HapticFeedback.heavyImpact();

    setState(() {
      _sonKombinUst =
          temizUstler.isNotEmpty ? temizUstler[random.nextInt(temizUstler.length)] : null;
      _sonKombinAlt =
          temizAltlar.isNotEmpty ? temizAltlar[random.nextInt(temizAltlar.length)] : null;
      _sonKombinAyakkabi = temizAyakkabilar.isNotEmpty
          ? temizAyakkabilar[random.nextInt(temizAyakkabilar.length)]
          : null;
      _sonKombinAksesuar = temizAksesuarlar.isNotEmpty && random.nextBool()
          ? temizAksesuarlar[random.nextInt(temizAksesuarlar.length)]
          : null;

      _renkUyumuPuani = (70 + random.nextInt(30)).toInt();
      _stilistYorumu = l10n.zarlarAtildiYorumu;
      _isBugunGiydildi = false;
      _aiAnalizEdiyor = false;
    });

    _favoriDurumunuYenile();
    await AnalyticsServisi().olay('outfit_generated', {'source': 'daily_random'});
    _olusturulanKombiniTamEkranAc();
  }

  /// Kombin üretildikten sonra haftalık planlayıcıdaki gibi tam ekran görsel aç.
  void _olusturulanKombiniTamEkranAc() {
    final parcalar = _mevcutKombinParcalariniGetir();
    if (parcalar.isEmpty) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _netGorselModaliniAc(parcalar.first);
    });
  }

  void _favoriDurumunuYenile() {
    final mevcutParcalar = _mevcutKombinParcalariniGetir();
    if (mevcutParcalar.isEmpty) {
      if (mounted) setState(() => _isFavori = false);
      return;
    }

    final geciciKombin = FavoriKombin(
      baslik: _kombinBasligi,
      parcalar: mevcutParcalar.map((k) => k.gorunenBaslik).toList(),
      tuyo: _stilistYorumu,
      renkUyumuPuani: _renkUyumuPuani,
    );

    final eslesmeVar = widget.favoriKombinler.any((f) => f == geciciKombin);
    if (mounted) setState(() => _isFavori = eslesmeVar);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    final formatliHava = widget.gunlukHava
        .replaceAll(
            RegExp(r'^(Konum Bugün:|Location Today:|Konum|Location):?\s*•?',
                caseSensitive: false),
            '')
        .trim();
    final int ayiriciIndex = formatliHava.indexOf('—');
    final String havaSicaklikMetni = ayiriciIndex == -1
        ? formatliHava
        : formatliHava.substring(0, ayiriciIndex).trim();
    final String havaDurumMetni = ayiriciIndex == -1
        ? ''
        : formatliHava.substring(ayiriciIndex + 1).trim();

    // Yanıp sönen (pulse eden) yuvarlak zar butonu - boyut parametrik.
    Widget zarDairesi({required double boyut, required double ikonBoyut}) {
      return GestureDetector(
        onTap: () async {
          if (_animController.isAnimating) return;
          HapticFeedback.selectionClick();
          await _animController.forward(from: 0.0);
          _rastgeleKombinOlustur();
        },
        child: AnimatedBuilder(
          animation: _pulseController,
          builder: (context, __) {
            final double t = _pulseController.value; // 0..1
            return Container(
              width: boyut,
              height: boyut,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF22C55E), Color(0xFF16A34A)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF16A34A)
                        .withValues(alpha: 0.30 + 0.35 * t),
                    blurRadius: 14 + 18 * t,
                    spreadRadius: 2 + 5 * t,
                  ),
                ],
              ),
              child: Transform.scale(
                scale: 1.0 + 0.05 * t,
                child: RotationTransition(
                  turns: Tween<double>(begin: 0, end: 2).animate(
                    CurvedAnimation(
                        parent: _animController, curve: Curves.easeInOut),
                  ),
                  child: Icon(
                    Icons.casino_rounded,
                    size: ikonBoyut,
                    color: Colors.white,
                  ),
                ),
              ),
            );
          },
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // AppBar
            SliverAppBar(
              pinned: false,
              floating: false,
              snap: false,
              backgroundColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              automaticallyImplyLeading: false,
              titleSpacing: 16,
              toolbarHeight: 64,
              title: Text(
                l10n.gunlukKombinTitle,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                  color: colorScheme.onSurface,
                ),
              ),
            ),

            // İçerik
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hava Bar Widget (haftalık ile aynı)
                    HavaBar(
                      havaEtiketi: l10n.havaEtiketi,
                      havaSicaklikMetni: havaSicaklikMetni,
                      havaDurumMetni: havaDurumMetni,
                      havaYukleniyor: widget.havaYukleniyor,
                      havaHatasi: widget.havaHatasi,
                      onKonumuYenile: widget.onKonumuYenile,
                      onKonumAyarlariniAc: widget.onKonumAyarlariniAc,
                      havaDurumuIkonu: _havaDurumuIkonu,
                      yukleniyorMetni: l10n.yukleniyor,
                      ayarlarTooltip: l10n.ayarlaraGit,
                    ),

                    const SizedBox(height: 12),

                    // Kombin VARSA: kompakt satır (küçük zar + etiket + temizle)
                    // Kombin YOKSA: ortada büyük yanıp sönen zar
                    if (_kombinVarMi)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            zarDairesi(boyut: 58, ikonBoyut: 28),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                l10n.yenidenZarAt,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.2,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            TextButton.icon(
                              onPressed: _kombiniTemizle,
                              icon: Icon(Icons.delete_sweep_rounded,
                                  size: 18, color: colorScheme.error),
                              label: Text(
                                l10n.temizle,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.error,
                                ),
                              ),
                              style: TextButton.styleFrom(
                                foregroundColor: colorScheme.error,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            zarDairesi(boyut: 96, ikonBoyut: 46),
                            const SizedBox(height: 14),
                            Text(
                              l10n.zarAtKaristir,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.2,
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 20),

                    // Ana Kombin Kartı (haftalık planlayıcı stilinde)
                    if (_kombinVarMi)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: _anaKombinKarti(
                            l10n, theme, colorScheme, havaSicaklikMetni,
                            havaDurumMetni),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.fromLTRB(32, 24, 32, 24),
                        child: Column(
                          children: [
                            Text(
                              _temizKiyafetVarMi
                                  ? l10n.gunlukKombinHazirBaslik
                                  : l10n.haftalikUyariDolapBosBaslik,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _temizKiyafetVarMi
                                  ? l10n.gunlukKombinHazirIcerik
                                  : l10n.haftalikUyariDolapBosIcerik,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                height: 1.5,
                              ),
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

  IconData _havaDurumuIkonu(String metin) {
    final s = metin.toLowerCase();
    if (s.contains('yağmur') || s.contains('rain')) {
      return Icons.umbrella_rounded;
    }
    if (s.contains('kar') || s.contains('snow')) return Icons.ac_unit_rounded;
    if (s.contains('güneş') || s.contains('sun')) {
      return Icons.wb_sunny_rounded;
    }
    if (s.contains('bulut') || s.contains('cloud')) {
      return Icons.wb_cloudy_rounded;
    }
    return Icons.cloud_outlined;
  }

  Widget _anaKombinKarti(
      AppLocalizations l10n,
      ThemeData theme,
      ColorScheme colorScheme,
      String havaSicaklikMetni,
      String havaDurumMetni) {
    final parcalarListesi = <MapEntry<String, Kiyafet>>[
      if (_sonKombinUst != null) MapEntry('ust', _sonKombinUst!),
      if (_sonKombinAlt != null) MapEntry('alt', _sonKombinAlt!),
      if (_sonKombinAyakkabi != null)
        MapEntry('ayakkabi', _sonKombinAyakkabi!),
      if (_sonKombinAksesuar != null)
        MapEntry('aksesuar', _sonKombinAksesuar!),
    ];

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
        side: BorderSide(
          color: _isBugunGiydildi
              ? Colors.green
              : colorScheme.outlineVariant,
          width: _isBugunGiydildi ? 2.0 : 1.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Başlık
            Text(
              l10n.gunlukKombinKartBaslik,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),

            // Rozetler
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.analytics_rounded,
                          size: 16, color: Colors.black),
                      const SizedBox(width: 6),
                      Text(
                        l10n.stilistUyum(_renkUyumuPuani.toString()),
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
                if (havaSicaklikMetni.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(_havaDurumuIkonu(havaDurumMetni),
                            size: 16, color: Colors.black),
                        const SizedBox(width: 6),
                        Text(
                          havaSicaklikMetni,
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 20),

            // Parça Listesi (Yatay)
            SizedBox(
              height: 160,
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: parcalarListesi.length,
                separatorBuilder: (context, _) => const SizedBox(width: 12),
                itemBuilder: (context, i) {
                  final parca = parcalarListesi[i];
                  return _parcaKart(context, parca.key, parca.value, l10n);
                },
              ),
            ),

            const SizedBox(height: 16),

            // Stilist Yorumu (Mor kutu - haftalık ile aynı)
            if (_stilistYorumu.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F2FA),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE8DEF8)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.auto_awesome_rounded,
                        size: 18, color: Color(0xFF9A73B5)),
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
                                        color: Color(0xFF9A73B5))),
                                const SizedBox(width: 10),
                                Text(l10n.yenidenDegerlendiriliyor,
                                    style: theme.textTheme.bodyMedium
                                        ?.copyWith(
                                            fontStyle: FontStyle.italic,
                                            color: const Color(0xFF6B5382))),
                              ],
                            )
                          : Text(
                              metniGuvenliYap(_stilistYorumu),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF4A3B5A),
                                height: 1.45,
                              ),
                            ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 20),

            // Aksiyon Butonları (haftalık ile aynı stil)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton.filledTonal(
                  icon: Icon(
                    _isFavori
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    size: 22,
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: _isFavori
                        ? Colors.amber.shade100
                        : colorScheme.surfaceContainerHighest,
                    foregroundColor: _isFavori
                        ? Colors.amber.shade900
                        : colorScheme.onSurfaceVariant,
                  ),
                  onPressed: _favoriDurumunuDegistir,
                ),
                const SizedBox(width: 8),
                IconButton.filledTonal(
                  icon: Icon(
                    _isBugunGiydildi
                        ? Icons.check_circle_rounded
                        : Icons.check_circle_outline_rounded,
                    size: 22,
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: _isBugunGiydildi
                        ? Colors.green.shade100
                        : colorScheme.surfaceContainerHighest,
                    foregroundColor: _isBugunGiydildi
                        ? Colors.green.shade800
                        : colorScheme.onSurfaceVariant,
                  ),
                  onPressed: _bugunGiydimTetikle,
                ),
                const SizedBox(width: 8),
                IconButton.filledTonal(
                  icon: const Icon(Icons.chat_bubble_outline_rounded,
                      size: 22),
                  style: IconButton.styleFrom(
                    backgroundColor: colorScheme.surfaceContainerHighest,
                    foregroundColor: colorScheme.onSurfaceVariant,
                  ),
                  onPressed: _kombinSohbetiniAc,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _parcaKart(BuildContext context, String bolge, Kiyafet kiyafet,
      AppLocalizations l10n) {
    return GestureDetector(
      onTap: () => _netGorselModaliniAc(kiyafet),
      child: SizedBox(
        width: 120,
        height: 120,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.memory(
                kiyafet.resimBytes,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: const Icon(Icons.checkroom_rounded, size: 36),
                ),
              ),
            ),
            Positioned(
              top: 6,
              right: 6,
              child: InkWell(
                onTap: () => _parcaDegistirModaliniAc(bolge, kiyafet),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.3),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.sync_rounded,
                          size: 16, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Kıyafete dokununca haftalık planlayıcı gibi tam ekran görsel/galeri açar.
  Future<void> _netGorselModaliniAc(Kiyafet seciliKiyafet) async {
    final tumParcalar = _mevcutKombinParcalariniGetir();
    if (tumParcalar.isEmpty) return;

    HapticFeedback.lightImpact();

    final int baslangicIndex =
        tumParcalar.indexWhere((k) => k.id == seciliKiyafet.id);
    final List<String> tumParcalarId =
        tumParcalar.map((k) => k.id).toList();

    _modalAcik = true;
    await HaftalikDialoglar.netGorselModalGoster(
      context: context,
      anaRenk: widget.anaRenk,
      tumParcalarMetinleri: tumParcalarId,
      baslangicIndex: baslangicIndex != -1 ? baslangicIndex : 0,
      parcaBilgisiAyristir: (id, l10n) {
        final item = tumParcalar.firstWhere((k) => k.id == id,
            orElse: () => seciliKiyafet);
        final kat = kategoriModeldenCikar(item.kategori);
        return {
          'baslik': item.gorunenBaslik,
          'kategori': kategoriEtiketiGetir(kat, l10n),
          'renk': item.renk,
          'stil': item.stil,
        };
      },
      gucluGorselBul: (id) {
        final item = tumParcalar.firstWhere((k) => k.id == id,
            orElse: () => seciliKiyafet);
        return item.resimBytes;
      },
    );
    _modalAcik = false;
  }

  void _parcaDegistirModaliniAc(String bolge, Kiyafet guncelKiyafet) {
    HapticFeedback.mediumImpact();
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    final temizKiyafetler =
        widget.gardirobum.where((k) => !k.sepetteMi).toList();
    final secenekler = temizKiyafetler
        .where((k) => kategoriModeldenCikar(k.kategori) == bolge)
        .toList();

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
      onTekliKiyafetDegistir: null,
      onSecim: (yeniMetin) {
        final secilenItem = secenekler.firstWhere(
          (k) =>
              yeniMetin.contains(k.baslik) ||
              yeniMetin.contains(k.gorunenBaslik),
          orElse: () =>
              secenekler.isNotEmpty ? secenekler.first : guncelKiyafet,
        );

        setState(() {
          if (bolge == 'ust') _sonKombinUst = secilenItem;
          if (bolge == 'alt') _sonKombinAlt = secilenItem;
          if (bolge == 'ayakkabi') _sonKombinAyakkabi = secilenItem;
          if (bolge == 'aksesuar') _sonKombinAksesuar = secilenItem;
          _renkUyumuPuani = (75 + Random().nextInt(25)).toInt();
        });
        _favoriDurumunuYenile();
      },
    );
  }
}