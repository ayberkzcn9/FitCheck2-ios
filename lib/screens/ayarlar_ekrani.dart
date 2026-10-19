import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/app_localizations.dart';
import '../main.dart';
import '../services/analytics_servisi.dart';
import '../services/auth_servisi.dart';
import '../utils/auth_hata_utils.dart';
import '../services/bildirim_servisi.dart';
import '../services/satin_alma_servisi.dart';
import 'reklamsiz_premium_ekrani.dart';
import '../widgets/dil_secim_modal.dart';
import '../widgets/modals/gizlilik_politikasi_modal.dart';
import '../widgets/modals/hesabi_sil_modal.dart';
import '../widgets/modals/stil_tercihleri_modal.dart';
import '../widgets/modals/stilist_hafizasi_modal.dart';
import '../services/stilist_hafizasi.dart';
import 'giris_ekrani.dart';

// DIŞARI AKTARILAN DİYALOGLARIN İMPORTU
import '../utils/ayarlar_dialoglar.dart';
import '../../theme/design_tokens.dart';

class AyarlarEkrani extends StatefulWidget {
  const AyarlarEkrani({super.key});

  @override
  State<AyarlarEkrani> createState() => _AyarlarEkraniState();
}

class _AyarlarEkraniState extends State<AyarlarEkrani> {
  // 👤 HESAP VE OTURUM DURUMU
  final AuthServisi _authServisi = AuthServisi();
  bool _isLoggedIn = false;
  bool _isAnonymous = true;
  String? _userEmail;
  String? _userName;
  String? _userPhotoUrl;

  // 🛡️ SOSYAL HESAP DURUMU
  bool _isGoogleConnected = false;

  // 👤 KİŞİSEL TERCİHLER
  String _seciliTenRengi = 'wheat';
  String _seciliStil = 'Streetwear / Casual';
  String _seciliFit = 'Regular Fit';
  String _seciliCinsiyet = 'Kadın';
  bool _temaKaranlikMi = false;

  // 🔔 BİLDİRİMLER
  bool _sabahBildirimi = true;
  bool _yikamaUyarisi = true;
  bool _haftalikRaporBildirimi = true;

  TimeOfDay _sabahBildirimSaati = const TimeOfDay(
    hour: 8,
    minute: 30,
  );

  // 🤖 YAPAY ZEKÂ
  String _aiStilistKisiligi = 'Samimi / Arkadaş Canlısı';
  bool _sikiRenkUyumModu = true;

  // 🧠 STİLİST HAFIZASI (kalıcı öğrenme)
  bool _stilistHafizasiAcik = true;
  int _stilistHafizaNotSayisi = 0;

  // 🌦️ LOKASYON & BİRİMLER
  String _sicaklikBirimi = '°C';
  String _varsayilanSehir = 'Otomatik (GPS)';

  // 📊 GİZLİLİK VE ANALİTİK
  bool _analitikIzinli = true;

  // ℹ️ KURULU SÜRÜM (paketten okunur, elle güncellenmez)
  String _surumMetni = '';

  @override
  void initState() {
    super.initState();
    _bilgileriYukle();
    _oturumDurumunuYukle();
    _surumBilgisiniYukle();
  }

  // ℹ️ Kurulu sürümü gerçek paketten oku (versionName + versionCode)
  Future<void> _surumBilgisiniYukle() async {
    try {
      final PackageInfo bilgi = await PackageInfo.fromPlatform();
      if (!mounted) return;
      setState(() {
        _surumMetni = 'v${bilgi.version} (${bilgi.buildNumber})';
      });
    } catch (e) {
      debugPrint('Sürüm bilgisi okunamadı: $e');
    }
  }

  // 🌍 YERELLEŞTİRİLMİŞ TEN RENGİ LİSTESİ
  List<Map<String, String>> _getTenRengiListesi(AppLocalizations l10n) {
    return [
      {'key': 'light', 'label': l10n.tenRengiAcik},
      {'key': 'wheat', 'label': l10n.tenRengiBugday},
      {'key': 'dark', 'label': l10n.tenRengiEsmer},
    ];
  }

  String _tenRengiAnahtariniDuzenle(String? deger) {
    final s = (deger ?? '').trim().toLowerCase();
    if (s == 'light' || s.contains('açık') || s.contains('beyaz')) {
      return 'light';
    }
    if (s == 'dark' || s.contains('esmer') || s.contains('koyu')) {
      return 'dark';
    }
    return 'wheat';
  }

  // 🌍 YERELLEŞTİRİLMİŞ STİL LİSTESİ
  List<Map<String, String>> _getStilListesi(AppLocalizations l10n) {
    return [
      {'key': 'Streetwear / Casual', 'label': l10n.stilStreetwear},
      {'key': 'Klasik / Ofis', 'label': l10n.stilKlasik},
      {'key': 'Minimalist', 'label': l10n.stilMinimalist},
      {'key': 'Spor / Athleisure', 'label': l10n.stilSpor},
      {'key': 'Vintage / Retro', 'label': l10n.stilVintage},
    ];
  }

  // 🌍 YERELLEŞTİRİLMİŞ FİT LİSTESİ
  List<Map<String, String>> _getFitListesi(AppLocalizations l10n) {
    return [
      {'key': 'Slim Fit', 'label': l10n.fitSlim},
      {'key': 'Regular Fit', 'label': l10n.fitRegular},
      {'key': 'Oversize / Relaxed', 'label': l10n.fitOversize},
    ];
  }

  String _getStilLabel(String key, AppLocalizations l10n) {
    final list = _getStilListesi(l10n);
    final match = list.firstWhere((element) => element['key'] == key,
        orElse: () => {'label': key});
    return match['label']!;
  }

  String _getFitLabel(String key, AppLocalizations l10n) {
    final list = _getFitListesi(l10n);
    final match = list.firstWhere((element) => element['key'] == key,
        orElse: () => {'label': key});
    return match['label']!;
  }

  List<Map<String, dynamic>> _getAiKisilikDetaylari(AppLocalizations l10n) {
    return [
      {
        'key': 'Samimi / Arkadaş Canlısı',
        'baslik': l10n.aiKisilikSamimiBaslik,
        'aciklama': l10n.aiKisilikSamimiAciklama,
        'ikon': Icons.sentiment_very_satisfied_rounded,
        'renk': AppAccents.warning,
      },
      {
        'key': 'Profesyonel Moda Eleştirmeni',
        'baslik': l10n.aiKisilikElestirmenBaslik,
        'aciklama': l10n.aiKisilikElestirmenAciklama,
        'ikon': Icons.auto_awesome_rounded,
        'renk': AppMiscColors.purple,
      },
      {
        'key': 'Minimalist & Kısa',
        'baslik': l10n.aiKisilikMinimalistBaslik,
        'aciklama': l10n.aiKisilikMinimalistAciklama,
        'ikon': Icons.bolt_rounded,
        'renk': AppMiscColors.greenLight,
      },
    ];
  }

  Future<void> _oturumDurumunuYukle() async {
    final user = _authServisi.mevcutKullanici;
    if (!mounted) return;

    setState(() {
      _isLoggedIn = user != null;
      _isAnonymous = user?.isAnonymous ?? true;
      _userEmail = user?.email;
      _userName = user?.displayName;
      _userPhotoUrl = user?.photoURL;
      _isGoogleConnected =
          user?.providerData.any((p) => p.providerId == 'google.com') ?? false;
    });
  }

  Future<void> _cikisYapTetikle() async {
    HapticFeedback.heavyImpact();
    final onay = await AyarlarDialoglar.cikisYapOnayGoster(context);

    if (onay == true) {
      await _authServisi.cikisYap();
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const GirisEkrani()),
        (route) => false,
      );
    }
  }

  void _girisEkraninaYonlendir() {
    HapticFeedback.lightImpact();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const GirisEkrani()),
    ).then((_) => _oturumDurumunuYukle());
  }

  Future<void> _googleHesapBagla() async {
    HapticFeedback.lightImpact();
    final l10n = AppLocalizations.of(context)!;

    try {
      final yeniDurum = _isGoogleConnected
          ? await _authServisi.googleHesabiBaglantisiniKes()
          : await _authServisi.googleHesabiBagla();
      if (!yeniDurum || !mounted) return;
      await _oturumDurumunuYukle();
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              _isGoogleConnected
                  ? l10n.googleHesabiBaglandi
                  : l10n.googleHesabiBaglantisiKesildi,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(l10n.gardirobumHataMesaji),
            behavior: SnackBarBehavior.floating),
      );
    }
  }

  Future<void> _sifreDegistirTetikle() async {
    HapticFeedback.lightImpact();
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final girilenEmail = await AyarlarDialoglar.sifreDegistirGoster(
        context: context, mevcutEmail: _userEmail);

    if (girilenEmail == null || girilenEmail.isEmpty || !mounted) return;

    try {
      await _authServisi.sifreSifirlamaEpostasiGonder(email: girilenEmail);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.sifreEpostasiGonderildi(girilenEmail),
              style: const TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: AppAccents.success,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authHatasiMetni(e, l10n),
              style: TextStyle(
                  color: colors.onError, fontWeight: FontWeight.w600)),
          backgroundColor: colors.error,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      );
    }
  }

  Future<void> _hesabiSilTetikle() async {
    final l10n = AppLocalizations.of(context)!;
    final onay = await HesabiSilModal.goster(context);

    if (onay == true) {
      try {
        await _authServisi.hesabiSil();
        final prefs = await SharedPreferences.getInstance();
        await prefs.clear();
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.hesabinizSilindi,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: AppAccents.error,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const GirisEkrani()),
          (route) => false,
        );
      } catch (_) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(l10n.gardirobumHataMesaji),
              behavior: SnackBarBehavior.floating),
        );
      }
    }
  }

  Future<void> _bilgileriYukle() async {
    final prefs = await SharedPreferences.getInstance();
    final hafiza = StilistHafizasi();
    await hafiza.yukle();
    if (!mounted) return;

    setState(() {
      _seciliTenRengi = _tenRengiAnahtariniDuzenle(
        prefs.getString('kullanici_ten_rengi'),
      );
      _seciliStil = prefs.getString('kullanici_tarzi') ??
          prefs.getString('kullanici_stil') ??
          'Streetwear / Casual';
      _seciliFit = prefs.getString('kullanici_fit') ?? 'Regular Fit';
      _temaKaranlikMi =
          (prefs.getString('uygulama_temasi_modu') ?? 'light') == 'dark';
      _seciliCinsiyet =
          prefs.getString('kullanici_cinsiyet') ?? 'Kadın';
      _sabahBildirimi = prefs.getBool('sabah_bildirimi') ?? true;
      _yikamaUyarisi = prefs.getBool('yikama_uyarisi') ?? true;
      _haftalikRaporBildirimi =
          prefs.getBool('haftalik_rapor_bildirimi') ?? true;

      final hour = prefs.getInt('sabah_bildirim_saat') ?? 8;
      final minute = prefs.getInt('sabah_bildirim_dakika') ?? 30;

      _sabahBildirimSaati = TimeOfDay(
        hour: hour.clamp(0, 23),
        minute: minute.clamp(0, 59),
      );

      _aiStilistKisiligi =
          prefs.getString('ai_kisilik') ?? 'Samimi / Arkadaş Canlısı';
      _sikiRenkUyumModu = prefs.getBool('siki_renk_uyumu') ?? true;
      _sicaklikBirimi = prefs.getString('sicaklik_birimi') ?? '°C';
      _varsayilanSehir =
          prefs.getString('varsayilan_sehir') ?? 'Otomatik (GPS)';
      _analitikIzinli = AnalyticsServisi.veriToplamaIzinli;
      _stilistHafizasiAcik = hafiza.acik;
      _stilistHafizaNotSayisi = hafiza.notlar.length;
    });
  }

  /// Stilist hafızası ekranından dönünce sayaç/anahtar durumunu tazeler.
  void _stilistHafizasiDurumunuYenile() {
    final hafiza = StilistHafizasi();
    if (!mounted) return;
    setState(() {
      _stilistHafizasiAcik = hafiza.acik;
      _stilistHafizaNotSayisi = hafiza.notlar.length;
    });
  }

  /// Hafızayı aç/kapat. Kapalıyken yeni bilgi öğrenilmez ve mevcut notlar
  /// AI'ya gönderilmez (notlar silinmez, kullanıcı isterse modalden siler).
  Future<void> _stilistHafizasiAnahtariniDegistir(bool deger) async {
    HapticFeedback.lightImpact();
    setState(() => _stilistHafizasiAcik = deger);
    await StilistHafizasi().acikAyarla(deger);
  }

  Future<void> _ayarKaydet(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    } else if (value is int) {
      await prefs.setInt(key, value);
    }
  }

  Future<void> _analitikIzniniDegistir(bool izinli) async {
    HapticFeedback.lightImpact();
    setState(() => _analitikIzinli = izinli);
    await AnalyticsServisi().veriToplamaIzniAyarla(izinli);
  }

  Future<void> _saatSec() async {
    HapticFeedback.lightImpact();
    final l10n = AppLocalizations.of(context)!;

    final TimeOfDay? secilen = await showTimePicker(
      context: context,
      initialTime: _sabahBildirimSaati,
      helpText: l10n.sabahBildirimSaatiSec,
      cancelText: l10n.iptal,
      confirmText: l10n.kaydet,
    );

    if (secilen == null || !mounted) return;

    setState(() {
      _sabahBildirimSaati = secilen;
    });

    await _ayarKaydet('sabah_bildirim_saat', secilen.hour);
    await _ayarKaydet('sabah_bildirim_dakika', secilen.minute);

    if (_sabahBildirimi) {
      try {
        await BildirimServisi().gunlukSabahBildirimiKur(
          saat: secilen.hour,
          dakika: secilen.minute,
          context: context,
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.saatKaydedildiAksama,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: AppAccents.warning,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        );
        return;
      }
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.sabahBildirimiAyarlandi(secilen.format(context)),
            style: const TextStyle(fontWeight: FontWeight.bold)),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  Future<void> _sabahBildiriminiDegistir(bool val) async {
    HapticFeedback.lightImpact();
    final l10n = AppLocalizations.of(context)!;

    if (val) {
      bool izinVerildi = false;
      try {
        izinVerildi =
            await BildirimServisi().bildirimIzniKontrolEtVeIste(context);
      } catch (e) {
        izinVerildi = false;
      }

      if (!mounted) return;

      if (!izinVerildi) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.bildirimIzinGerekliUyari,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: AppAccents.error,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        );
        setState(() {
          _sabahBildirimi = false;
        });
        return;
      }

      setState(() {
        _sabahBildirimi = true;
      });

      await _ayarKaydet('sabah_bildirimi', true);

      try {
        await BildirimServisi().gunlukSabahBildirimiKur(
          saat: _sabahBildirimSaati.hour,
          dakika: _sabahBildirimSaati.minute,
          context: context,
        );
      } catch (_) {}
    } else {
      setState(() {
        _sabahBildirimi = false;
      });

      await _ayarKaydet('sabah_bildirimi', false);
      try {
        await BildirimServisi().gunlukSabahBildiriminiIptalEt();
      } catch (_) {}
    }
  }

  Future<void> _haftalikRaporBildiriminiDegistir(bool val) async {
    HapticFeedback.lightImpact();
    final l10n = AppLocalizations.of(context)!;

    if (val) {
      final izinVerildi =
          await BildirimServisi().bildirimIzniKontrolEtVeIste(context);
      if (!mounted) return;
      if (!izinVerildi) {
        setState(() => _haftalikRaporBildirimi = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.bildirimIzinGerekliUyari)),
        );
        return;
      }
    }

    setState(() => _haftalikRaporBildirimi = val);
    await _ayarKaydet('haftalik_rapor_bildirimi', val);
    if (val) {
      await BildirimServisi().haftalikRaporBildiriminiKur(context: context);
    } else {
      await BildirimServisi().haftalikRaporBildiriminiIptalEt();
    }
  }

  Future<void> _onbellekTemizle() async {
    HapticFeedback.mediumImpact();
    final l10n = AppLocalizations.of(context)!;

    try {
      PaintingBinding.instance.imageCache.clear();
      PaintingBinding.instance.imageCache.clearLiveImages();

      final tempDir = await getTemporaryDirectory();

      if (tempDir.existsSync()) {
        final entities = tempDir.listSync();
        for (final entity in entities) {
          try {
            entity.deleteSync(recursive: true);
          } catch (_) {}
        }
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.onbellekTemizlendiBasari,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: AppAccents.success,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.onbellekTemizlerkenHata,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: AppAccents.warning,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      );
    }
  }

  Future<void> _verileriDisaAktar() async {
    HapticFeedback.lightImpact();
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;

    final prefs = await SharedPreferences.getInstance();
    final mevcutGardirobum = prefs.getString('gardirobum_data');

    if (!mounted) return;

    if (mevcutGardirobum == null ||
        mevcutGardirobum.isEmpty ||
        mevcutGardirobum == '[]') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.disaAktarilacakVeriYok,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: AppAccents.warning,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      );
      return;
    }

    await Clipboard.setData(ClipboardData(text: mevcutGardirobum));

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.gardiropVerisiKopyalandi,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: colors.inverseSurface,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  Future<void> _sehirSecimTetikle() async {
    final secilenSehir = await AyarlarDialoglar.sehirSecimGoster(
        context: context, mevcutSehir: _varsayilanSehir);

    if (secilenSehir != null && secilenSehir.isNotEmpty) {
      if (!mounted) return;
      setState(() {
        _varsayilanSehir = secilenSehir;
      });
      await _ayarKaydet('varsayilan_sehir', secilenSehir);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = KombinDanismaniApp.of(context);
    final l10n = AppLocalizations.of(context)!;
    final seciliLocale = appState.currentLocale;
    final String seciliDilEtiketi =
        _getDilEtiketi(seciliLocale?.languageCode, l10n);
    final aiKisilikDetaylari = _getAiKisilikDetaylari(l10n);
    final tenRengiListesi = _getTenRengiListesi(l10n);
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final bool canPop = Navigator.canPop(context);

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (canPop) {
          Navigator.maybePop(context);
        }
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: canPop
              ? IconButton(
                  icon: const Icon(Icons.arrow_back_rounded),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    Navigator.maybePop(context);
                  },
                )
              : null,
          iconTheme: IconThemeData(
            color: colors.onSurface,
          ),
          title: Text(
            l10n.ayarlarTitle,
            maxLines: 2,
            softWrap: true,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 18,
              letterSpacing: -0.5,
              color: colors.onSurface,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
        ),
        body: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 140),
          children: [
            // 👤 HESAP YÖNETİMİ & OTURUM DURUMU
            _buildSectionHeader(context, l10n.hesapVeGuvenlikMerkeziUst),
            _buildPremiumCard(
              child: Column(
                children: [
                  ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: CircleAvatar(
                      radius: 24,
                      backgroundColor: _isLoggedIn && !_isAnonymous
                          ? colors.primary
                          : colors.surfaceContainerHighest,
                      backgroundImage: _userPhotoUrl != null
                          ? NetworkImage(_userPhotoUrl!)
                          : null,
                      child: _userPhotoUrl == null
                          ? Text(
                              (_isLoggedIn && !_isAnonymous)
                                  ? (_userName != null && _userName!.isNotEmpty
                                      ? _userName![0].toUpperCase()
                                      : 'U')
                                  : '?',
                              style: TextStyle(
                                  color: _isLoggedIn && !_isAnonymous
                                      ? colors.onPrimary
                                      : colors.onSurfaceVariant,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            )
                          : null,
                    ),
                    title: Text(
                      _isLoggedIn && !_isAnonymous
                          ? (_userName != null && _userName!.isNotEmpty
                              ? _userName!
                              : l10n.kullaniciHesabi)
                          : l10n.misafirKullanici,
                      style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                          letterSpacing: -0.3,
                          color: colors.onSurface),
                    ),
                    subtitle: Row(
                      children: [
                        Icon(
                          _isLoggedIn && !_isAnonymous
                              ? Icons.verified_rounded
                              : Icons.info_outline_rounded,
                          size: 14,
                          color: _isLoggedIn && !_isAnonymous
                              ? AppAccents.success
                              : AppAccents.warning,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            _isLoggedIn && !_isAnonymous
                                ? (_userEmail ?? l10n.epostaDogrulanmis)
                                : l10n.esitlemekIcinGirisYapin,
                            style: TextStyle(
                                fontSize: 12,
                                color: colors.onSurfaceVariant,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                    trailing: _isLoggedIn && !_isAnonymous
                        ? IconButton(
                            icon:
                                Icon(Icons.logout_rounded, color: colors.error),
                            onPressed: _cikisYapTetikle,
                            tooltip: l10n.cikisYapTitle,
                          )
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  AppMiscColors.greenLight, // Canlı Yeşil Renk
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14)),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 8),
                            ),
                            onPressed: _girisEkraninaYonlendir,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                l10n.girisYap,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 14),
                              ),
                            ),
                          ),
                  ),
                  if (_isLoggedIn && !_isAnonymous) ...[
                    Divider(
                        height: 1,
                        color: colors.outlineVariant.withValues(alpha: 0.4)),

                    // 🛡️ SOSYAL HESAP BAĞLANTILARI
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.bagliHesaplarUst,
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w900,
                                color: colors.onSurfaceVariant,
                                letterSpacing: 1.2),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                    color: _isGoogleConnected
                                        ? colors.primary
                                        : colors.outlineVariant,
                                    width: 1.5),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14)),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 8),
                              ),
                              icon: Image.asset(
                                'assets/images/google_logo.png',
                                height: 24,
                                width: 24,
                                errorBuilder: (_, __, ___) => Icon(
                                  Icons.g_mobiledata_rounded,
                                  color: _isGoogleConnected
                                      ? colors.primary
                                      : colors.onSurfaceVariant,
                                  size: 26,
                                ),
                              ),
                              label: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  _isGoogleConnected
                                      ? l10n.googleHesabiBagli
                                      : l10n.googleHesabiniBagla,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: _isGoogleConnected
                                        ? colors.onSurface
                                        : colors.onSurfaceVariant,
                                  ),
                                ),
                              ),
                              onPressed: _googleHesapBagla,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Divider(
                        height: 1,
                        color: colors.outlineVariant.withValues(alpha: 0.4)),

                    // 🔐 GÜVENLİK VE ŞİFRE
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      leading: _buildIconContainer(Icons.lock_outline_rounded,
                          iconColor: colors.primary),
                      title: Text(l10n.sifreVeGuvenlik,
                          style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                              color: colors.onSurface)),
                      subtitle: Text(l10n.sifreYenilemeBaglantisiIste,
                          style: TextStyle(
                              fontSize: 12,
                              color: colors.onSurfaceVariant,
                              fontWeight: FontWeight.w600)),
                      trailing: Icon(Icons.arrow_forward_ios_rounded,
                          size: 14, color: colors.onSurfaceVariant),
                      onTap: _sifreDegistirTetikle,
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 24),

            _buildSectionHeader(context, 'Premium'),
            _buildPremiumCard(
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: _buildIconContainer(
                  Icons.workspace_premium_rounded,
                  iconColor: AppMiscColors.greenLight,
                ),
                title: Text(
                  l10n.premiumAylikBaslik,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    color: colors.onSurface,
                  ),
                ),
                subtitle: Text(
                  l10n.premiumAylikAltBaslik(
                    SatinAlmaServisi.ornek.aylikFiyat,
                  ),
                  style: TextStyle(
                    fontSize: 12,
                    color: colors.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: Icon(Icons.arrow_forward_ios_rounded,
                    size: 14, color: colors.onSurfaceVariant),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      settings: const RouteSettings(
                          name: AnalyticsServisi.ekranPremium),
                      builder: (_) => const ReklamsizPremiumEkrani(),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // 👗 1. KİŞİSEL STİL VE PROFİL
            _buildSectionHeader(context, l10n.kisiselStilVeProfilUst),
            _buildPremiumCard(
              child: Column(
                children: [
                  ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: _buildIconContainer(
                      Icons.style_rounded,
                      iconColor: AppMiscColors.purple,
                    ),
                    title: Text(
                      l10n.stilVeTarzTercihleri,
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                          color: colors.onSurface),
                    ),
                    subtitle: Text(
                      '${l10n.secili}: ${_getStilLabel(_seciliStil, l10n)} • ${_getFitLabel(_seciliFit, l10n)}',
                      style: TextStyle(
                          fontSize: 12,
                          color: colors.onSurfaceVariant,
                          fontWeight: FontWeight.w600),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios_rounded,
                        size: 14, color: colors.onSurfaceVariant),
                    onTap: () {
                      HapticFeedback.lightImpact();
                      StilTercihleriModal.goster(
                        context: context,
                        ilkStil: _seciliStil,
                        ilkFit: _seciliFit,
                        onKaydet: (yeniStil, yeniFit) {
                          setState(() {
                            _seciliStil = yeniStil;
                            _seciliFit = yeniFit;
                          });
                          _ayarKaydet('kullanici_tarzi', yeniStil);
                          _ayarKaydet('kullanici_stil', yeniStil);
                          _ayarKaydet('kullanici_fit', yeniFit);
                        },
                      );
                    },
                  ),
                  Divider(
                      height: 1,
                      color: colors.outlineVariant.withValues(alpha: 0.4)),
                  // 👤 CİNSİYET TERCİHİ
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.cinsiyetTercihiBaslik,
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 12,
                            color: colors.onSurfaceVariant,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          alignment: WrapAlignment.start,
                          children: [
                            _buildChip(
                              label: l10n.anaKadin,
                              isSelected: _seciliCinsiyet == 'Kadın',
                              onTap: () => _cinsiyetDegistir('Kadın'),
                            ),
                            _buildChip(
                              label: l10n.anaErkek,
                              isSelected: _seciliCinsiyet == 'Erkek',
                              onTap: () => _cinsiyetDegistir('Erkek'),
                            ),
                            _buildChip(
                              label: l10n.cinsiyetBelirtilmemis,
                              isSelected: _seciliCinsiyet == 'Belirtilmemiş',
                              onTap: () => _cinsiyetDegistir('Belirtilmemiş'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider(
                      height: 1,
                      color: colors.outlineVariant.withValues(alpha: 0.4)),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.tenRengiTercihinizUst,
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 12,
                            color: colors.onSurfaceVariant,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          alignment: WrapAlignment.start,
                          children: tenRengiListesi.map((tr) {
                            final key = tr['key']!;
                            final label = tr['label']!;
                            return _buildChip(
                              label: label,
                              isSelected: _seciliTenRengi == key,
                              onTap: () => _tenRengiDegistir(key),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 🤖 2. YAPAY ZEKÂ VE STİL HASSASİYETİ
            _buildSectionHeader(context, l10n.yapayZekaVeStilHassasiyetiUst),
            _buildPremiumCard(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.stilistKisiligiVeYantitTarziUst,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            color: colors.onSurfaceVariant,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Column(
                          children: aiKisilikDetaylari.map((item) {
                            final String key = item['key'];
                            final String baslik = item['baslik'];
                            final String aciklama = item['aciklama'];
                            final IconData ikon = item['ikon'];
                            final Color renk = item['renk'] as Color;
                            final bool secili = _aiStilistKisiligi == key;

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: InkWell(
                                onTap: () {
                                  HapticFeedback.selectionClick();
                                  setState(() {
                                    _aiStilistKisiligi = key;
                                  });
                                  _ayarKaydet('ai_kisilik', key);
                                },
                                borderRadius: BorderRadius.circular(16),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 240),
                                  curve: Curves.easeOutCubic,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: secili
                                        ? renk.withValues(alpha: 0.15)
                                        : colors.surfaceContainerHigh,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: secili
                                          ? renk
                                          : colors.outlineVariant
                                              .withValues(alpha: 0.3),
                                      width: secili ? 1.8 : 1.0,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      _buildIconContainer(
                                        ikon,
                                        iconColor: renk,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              baslik,
                                              style: TextStyle(
                                                fontWeight: secili
                                                    ? FontWeight.w900
                                                    : FontWeight.w700,
                                                fontSize: 14,
                                                color: colors.onSurface,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              aciklama,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: colors.onSurfaceVariant,
                                                height: 1.3,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (secili) ...[
                                        const SizedBox(width: 8),
                                        Icon(
                                          Icons.check_circle_rounded,
                                          color: renk,
                                          size: 20,
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                      height: 1,
                      color: colors.outlineVariant.withValues(alpha: 0.4)),
                  SwitchListTile.adaptive(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    secondary: _buildIconContainer(
                      Icons.color_lens_rounded,
                      iconColor: AppAccents.warning,
                    ),
                    title: Text(
                      l10n.sikiRenkTeorisiUyumModu,
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                          color: colors.onSurface),
                    ),
                    subtitle: Text(
                      l10n.sikiRenkTeorisiAciklama,
                      style: TextStyle(
                          fontSize: 12,
                          color: colors.onSurfaceVariant,
                          fontWeight: FontWeight.w500),
                    ),
                    value: _sikiRenkUyumModu,
                    activeColor: colors.primary,
                    onChanged: (val) {
                      HapticFeedback.lightImpact();
                      setState(() {
                        _sikiRenkUyumModu = val;
                      });
                      _ayarKaydet('siki_renk_uyumu', val);
                    },
                  ),
                  Divider(
                      height: 1,
                      color: colors.outlineVariant.withValues(alpha: 0.4)),
                  ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    leading: _buildIconContainer(
                      Icons.psychology_rounded,
                      iconColor: AppAccents.styleist,
                    ),
                    title: Text(
                      l10n.stilistHafizasiBaslik,
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                          color: colors.onSurface),
                    ),
                    subtitle: Text(
                      (_stilistHafizasiAcik && _stilistHafizaNotSayisi > 0)
                          ? l10n.stilistHafizasiAltBaslikNotlu(
                              _stilistHafizaNotSayisi)
                          : l10n.stilistHafizasiAltBaslikBos,
                      style: TextStyle(
                          fontSize: 12,
                          color: colors.onSurfaceVariant,
                          fontWeight: FontWeight.w500),
                    ),
                    trailing: Switch.adaptive(
                      value: _stilistHafizasiAcik,
                      onChanged: _stilistHafizasiAnahtariniDegistir,
                    ),
                    onTap: () {
                      HapticFeedback.selectionClick();
                      StilistHafizasiModal.goster(
                        context: context,
                        onDegisti: _stilistHafizasiDurumunuYenile,
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 🔔 3. BİLDİRİMLER VE HATIRLATICI
            _buildSectionHeader(context, l10n.bildirimlerVeHatirlaticiUst),
            _buildPremiumCard(
              child: Column(
                children: [
                  SwitchListTile.adaptive(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    secondary: _buildIconContainer(
                      Icons.notifications_active_rounded,
                      iconColor: AppAccents.warning,
                    ),
                    title: Text(
                      l10n.sabahKombinOnerisi,
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                          color: colors.onSurface),
                    ),
                    subtitle: Text(
                      l10n.herSabahBildirimAl(
                          _sabahBildirimSaati.format(context)),
                      style: TextStyle(
                          fontSize: 12,
                          color: colors.onSurfaceVariant,
                          fontWeight: FontWeight.w500),
                    ),
                    value: _sabahBildirimi,
                    activeColor: colors.primary,
                    onChanged: _sabahBildiriminiDegistir,
                  ),
                  ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    leading: const SizedBox(width: 40),
                    title: Text(
                      l10n.bildirimSaatiniOzellestir,
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: colors.onSurface),
                    ),
                    subtitle: Text(
                      l10n.gunlukKombinBildirimSaati,
                      style: TextStyle(
                          fontSize: 12,
                          color: colors.onSurfaceVariant,
                          fontWeight: FontWeight.w500),
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: colors.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.access_time_rounded,
                              size: 14, color: colors.onSurfaceVariant),
                          const SizedBox(width: 4),
                          Text(
                            _sabahBildirimSaati.format(context),
                            style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 12,
                                color: colors.onSurface),
                          ),
                        ],
                      ),
                    ),
                    onTap: _saatSec,
                  ),
                  Divider(
                      height: 1,
                      color: colors.outlineVariant.withValues(alpha: 0.4)),
                  SwitchListTile.adaptive(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    secondary: _buildIconContainer(
                      Icons.dry_cleaning_rounded,
                      iconColor: AppMiscColors.pink,
                    ),
                    title: Text(
                      l10n.camasirSepetiUyarilari,
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                          color: colors.onSurface),
                    ),
                    subtitle: Text(
                      l10n.camasirSepetiUyarilariAciklama,
                      style: TextStyle(
                          fontSize: 12,
                          color: colors.onSurfaceVariant,
                          fontWeight: FontWeight.w500),
                    ),
                    value: _yikamaUyarisi,
                    activeColor: colors.primary,
                    onChanged: (val) {
                      HapticFeedback.lightImpact();
                      setState(() {
                        _yikamaUyarisi = val;
                      });
                      _ayarKaydet('yikama_uyarisi', val);
                    },
                  ),
                  Divider(
                      height: 1,
                      color: colors.outlineVariant.withValues(alpha: 0.4)),
                  SwitchListTile.adaptive(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    secondary: _buildIconContainer(
                      Icons.assessment_rounded,
                      iconColor: AppAccents.success,
                    ),
                    title: Text(
                      l10n.haftalikStilRaporu,
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                          color: colors.onSurface),
                    ),
                    subtitle: Text(
                      l10n.haftalikStilRaporuAciklama,
                      style: TextStyle(
                          fontSize: 12,
                          color: colors.onSurfaceVariant,
                          fontWeight: FontWeight.w500),
                    ),
                    value: _haftalikRaporBildirimi,
                    activeColor: colors.primary,
                    onChanged: _haftalikRaporBildiriminiDegistir,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 🎨 4. GÖRÜNÜM VE BÖLGE
            _buildSectionHeader(context, l10n.gorunumVeBolgeUst),
            _buildPremiumCard(
              child: Column(
                children: [
                  ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    leading: _buildIconContainer(
                      Icons.language_rounded,
                      iconColor: AppMiscColors.purple,
                    ),
                    title: Text(
                      l10n.uygulamaDili,
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                          color: colors.onSurface),
                    ),
                    subtitle: Text(
                      seciliDilEtiketi,
                      style: TextStyle(
                          fontSize: 12,
                          color: colors.onSurfaceVariant,
                          fontWeight: FontWeight.w600),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios_rounded,
                        size: 14, color: colors.onSurfaceVariant),
                    onTap: () {
                      HapticFeedback.selectionClick();
                      DilSecimModal.goster(context);
                    },
                  ),
                  Divider(
                      height: 1,
                      color: colors.outlineVariant.withValues(alpha: 0.4)),
                  // 🌙 Karanlık Mod
                  SwitchListTile.adaptive(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    secondary: _buildIconContainer(
                      Icons.dark_mode_rounded,
                      iconColor: AppMiscColors.purple,
                    ),
                    title: Text(
                      l10n.karanlikMod,
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                          color: colors.onSurface),
                    ),
                    subtitle: Text(
                      _temaKaranlikMi
                          ? l10n.koyuTemaAktif
                          : l10n.acikTemaAktif,
                      style: TextStyle(
                          fontSize: 12,
                          color: colors.onSurfaceVariant,
                          fontWeight: FontWeight.w600),
                    ),
                    value: _temaKaranlikMi,
                    onChanged: (deger) {
                      HapticFeedback.selectionClick();
                      KombinDanismaniApp.of(context).setTheme(deger);
                      setState(() => _temaKaranlikMi = deger);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 🌦️ 5. LOKASYON VE BİRİMLER
            _buildSectionHeader(context, l10n.lokasyonVeBirimlerUst),
            _buildPremiumCard(
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              _buildIconContainer(
                                Icons.thermostat_rounded,
                                iconColor: AppAccents.error,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  l10n.sicaklikBirimi,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 14,
                                      color: colors.onSurface),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SegmentedButton<String>(
                          style: ButtonStyle(
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            visualDensity: VisualDensity.compact,
                            side: WidgetStateProperty.all(BorderSide(
                                color: colors.outlineVariant
                                    .withValues(alpha: 0.5))),
                          ),
                          segments: const [
                            ButtonSegment(
                                value: '°C',
                                label: Text('°C',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12))),
                            ButtonSegment(
                                value: '°F',
                                label: Text('°F',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12))),
                          ],
                          selected: {_sicaklikBirimi},
                          onSelectionChanged: (set) {
                            HapticFeedback.selectionClick();
                            final value = set.first;
                            setState(() {
                              _sicaklikBirimi = value;
                            });
                            _ayarKaydet('sicaklik_birimi', value);
                          },
                        ),
                      ],
                    ),
                  ),
                  Divider(
                      height: 1,
                      color: colors.outlineVariant.withValues(alpha: 0.4)),
                  ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    leading: _buildIconContainer(
                      Icons.location_city_rounded,
                      iconColor: const Color(0xFF06B6D4),
                    ),
                    title: Text(
                      l10n.varsayilanSehirBolge,
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                          color: colors.onSurface),
                    ),
                    subtitle: Text(
                      '${l10n.secili}: $_varsayilanSehir',
                      style: TextStyle(
                          fontSize: 12,
                          color: colors.onSurfaceVariant,
                          fontWeight: FontWeight.w600),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios_rounded,
                        size: 14, color: colors.onSurfaceVariant),
                    onTap: _sehirSecimTetikle,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 🧹 6. VERİ VE DEPOLAMA YÖNETİMİ
            _buildSectionHeader(context, l10n.veriVeDepolamaYonetimiUst),
            _buildPremiumCard(
              child: Column(
                children: [
                  ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    leading: _buildIconContainer(
                      Icons.cleaning_services_rounded,
                      iconColor: AppMiscColors.orangeLight,
                    ),
                    title: Text(
                      l10n.gorselOnbelleginiTemizle,
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                          color: colors.onSurface),
                    ),
                    subtitle: Text(
                      l10n.geciciFotografHafizasiAciklama,
                      style: TextStyle(
                          fontSize: 12,
                          color: colors.onSurfaceVariant,
                          fontWeight: FontWeight.w500),
                    ),
                    onTap: _onbellekTemizle,
                  ),
                  Divider(
                      height: 1,
                      color: colors.outlineVariant.withValues(alpha: 0.4)),
                  ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    leading: _buildIconContainer(
                      Icons.file_download_rounded,
                      iconColor: const Color(0xFF60A5FA),
                    ),
                    title: Text(
                      l10n.gardirobuDisaAktarYedekle,
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                          color: colors.onSurface),
                    ),
                    subtitle: Text(
                      l10n.tumKiyafetVeKombinJsonAciklama,
                      style: TextStyle(
                          fontSize: 12,
                          color: colors.onSurfaceVariant,
                          fontWeight: FontWeight.w500),
                    ),
                    onTap: _verileriDisaAktar,
                  ),
                  Divider(
                      height: 1,
                      color: colors.outlineVariant.withValues(alpha: 0.4)),
                  SwitchListTile.adaptive(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    secondary: _buildIconContainer(
                      Icons.insights_rounded,
                      iconColor: AppMiscColors.greenLight,
                    ),
                    title: Text(
                      l10n.analitikVerileriPaylas,
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                          color: colors.onSurface),
                    ),
                    subtitle: Text(
                      l10n.analitikVerileriPaylasAciklama,
                      style: TextStyle(
                          fontSize: 12,
                          color: colors.onSurfaceVariant,
                          fontWeight: FontWeight.w500),
                    ),
                    value: _analitikIzinli,
                    activeThumbColor: colors.primary,
                    onChanged: _analitikIzniniDegistir,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 💬 7. DESTEK VE DEĞERLENDİRME
            _buildSectionHeader(context, l10n.destekVeDegerlendirmeUst),
            _buildPremiumCard(
              child: Column(
                children: [
                  ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    leading: _buildIconContainer(
                      Icons.star_rounded,
                      iconColor: AppAccents.warning,
                    ),
                    title: Text(
                      l10n.uygulamayiDegerlendirin,
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                          color: colors.onSurface),
                    ),
                    subtitle: Text(
                      l10n.googlePlay5YildizDestek,
                      style: TextStyle(
                          fontSize: 12,
                          color: colors.onSurfaceVariant,
                          fontWeight: FontWeight.w500),
                    ),
                    trailing: Icon(Icons.open_in_new_rounded,
                        size: 16, color: colors.onSurfaceVariant),
                    onTap: () async {
                      HapticFeedback.lightImpact();
                      final marketUrl =
                          Uri.parse('market://details?id=com.fitcheck2.app');
                      final webUrl = Uri.parse(
                          'https://play.google.com/store/apps/details?id=com.fitcheck2.app');

                      try {
                        if (await canLaunchUrl(marketUrl)) {
                          await launchUrl(marketUrl,
                              mode: LaunchMode.externalNonBrowserApplication);
                        } else {
                          await launchUrl(webUrl,
                              mode: LaunchMode.externalApplication);
                        }
                      } catch (_) {
                        try {
                          await launchUrl(webUrl,
                              mode: LaunchMode.externalApplication);
                        } catch (_) {
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(l10n.googlePlayAcilamadi,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold))),
                          );
                        }
                      }
                    },
                  ),
                  Divider(
                      height: 1,
                      color: colors.outlineVariant.withValues(alpha: 0.4)),
                  ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    leading: _buildIconContainer(
                      Icons.mail_outline_rounded,
                      iconColor: AppAccents.success,
                    ),
                    title: Text(
                      l10n.geriBildirimVeDestek,
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                          color: colors.onSurface),
                    ),
                    subtitle: Text(
                      l10n.hataBildirVeyaOneri,
                      style: TextStyle(
                          fontSize: 12,
                          color: colors.onSurfaceVariant,
                          fontWeight: FontWeight.w500),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios_rounded,
                        size: 14, color: colors.onSurfaceVariant),
                    onTap: () async {
                      HapticFeedback.lightImpact();
                      final Uri emailUri = Uri(
                        scheme: 'mailto',
                        path: 'ayberkzcn9@gmail.com',
                        queryParameters: {
                          'subject':
                              '${l10n.geriBildirimKonu} $_surumMetni'.trim()
                        },
                      );

                      try {
                        if (await canLaunchUrl(emailUri)) {
                          await launchUrl(emailUri,
                              mode: LaunchMode.externalNonBrowserApplication);
                        } else {
                          throw Exception('Mail uygulaması bulunamadı');
                        }
                      } catch (_) {
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.epostaUygulamasiAcilamadi,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            backgroundColor: AppAccents.error,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                          ),
                        );
                      }
                    },
                  ),
                  Divider(
                      height: 1,
                      color: colors.outlineVariant.withValues(alpha: 0.4)),
                  ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    leading: _buildIconContainer(
                      Icons.security_rounded,
                      iconColor: AppMiscColors.pink,
                    ),
                    title: Text(
                      l10n.gizlilikPolitikasiTitle,
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                          color: colors.onSurface),
                    ),
                    subtitle: Text(
                      l10n.veriKullanimiVeGizlilikHaklari,
                      style: TextStyle(
                          fontSize: 12,
                          color: colors.onSurfaceVariant,
                          fontWeight: FontWeight.w500),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios_rounded,
                        size: 14, color: colors.onSurfaceVariant),
                    onTap: () => GizlilikPolitikasiModal.goster(context),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 🚨 TEHLİKELİ BÖLGE
            if (_isLoggedIn && !_isAnonymous) ...[
              _buildSectionHeader(context, l10n.hesapSilmeUst),
              _buildPremiumCard(
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  leading: _buildIconContainer(
                    Icons.delete_forever_rounded,
                    iconColor: colors.error,
                  ),
                  title: Text(
                    l10n.hesabiKaliciSilTitle,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                      color: colors.error,
                    ),
                  ),
                  subtitle: Text(
                    l10n.tumBulutVeYerelVeriTemizlenir,
                    style: TextStyle(
                        fontSize: 12,
                        color: colors.onSurfaceVariant,
                        fontWeight: FontWeight.w500),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: colors.error,
                  ),
                  onTap: _hesabiSilTetikle,
                ),
              ),
              const SizedBox(height: 24),
            ],

            // ℹ️ 8. HAKKINDA
            _buildSectionHeader(context, l10n.hakkindaUst),
            _buildPremiumCard(
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                leading: _buildIconContainer(
                  Icons.info_outline_rounded,
                  iconColor: AppAccents.success,
                ),
                title: Text(
                  l10n.surum,
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                      color: colors.onSurface),
                ),
                trailing: _surumMetni.isEmpty
                    ? null
                    : Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: colors.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          _surumMetni,
                          style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 12,
                              color: colors.onSurface),
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 36),

            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.diamond_rounded,
                    size: 20,
                    color: colors.onSurfaceVariant.withValues(alpha: 0.4),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.ayarlarAltbilgi,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: colors.onSurfaceVariant.withValues(alpha: 0.5),
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
            ),

                        const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumCard({required Widget child}) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: AppRadius.xlRadius,
        border: Border.all(
          color: colors.outlineVariant.withValues(alpha: 0.4),
          width: 1.2,
        ),
      ),
      clipBehavior: Clip.hardEdge,
      child: child,
    );
  }

  Widget _buildChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final colors = Theme.of(context).colorScheme;
    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? colors.secondaryContainer
              : colors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? colors.secondary
                : colors.outlineVariant.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            color: isSelected ? colors.onSecondaryContainer : colors.onSurface,
          ),
        ),
      ),
    );
  }

  Widget _buildIconContainer(IconData ikon, {Color? iconColor}) {
    final colors = Theme.of(context).colorScheme;
    final effectiveColor = iconColor ?? colors.onSurfaceVariant;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: effectiveColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        ikon,
        color: effectiveColor,
        size: 18,
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.2,
          color: colors.onSurface,
        ),
      ),
    );
  }

  String _getDilEtiketi(String? langCode, AppLocalizations l10n) {
    switch (langCode) {
      case 'tr':
        return '🇹🇷 Türkçe';
      case 'en':
        return '🇺🇸 English';
      case 'es':
        return '🇪🇸 Español';
      case 'it':
        return '🇮🇹 Italiano';
      case 'zh':
        return '🇨🇳 中文';
      case 'ar':
        return '🇸🇦 العربية';
      case 'fr':
        return '🇫🇷 Français';
      case 'de':
        return '🇩🇪 Deutsch';
      case 'pt':
        return '🇧🇷 Português';
      case 'ja':
        return '🇯🇵 日本語';
      case 'ko':
        return '🇰🇷 한국어';
      case 'ru':
        return '🇷🇺 Русский';
      default:
        return l10n.ayarOtomatikCihazDili;
    }
  }

  void _tenRengiDegistir(String yeniTenRengiKey) {
    if (_seciliTenRengi == yeniTenRengiKey) return;

    HapticFeedback.selectionClick();
    setState(() {
      _seciliTenRengi = yeniTenRengiKey;
    });
    _ayarKaydet('kullanici_ten_rengi', yeniTenRengiKey);
  }

  void _cinsiyetDegistir(String yeniCinsiyet) {
    if (_seciliCinsiyet == yeniCinsiyet) return;

    HapticFeedback.selectionClick();
    setState(() {
      _seciliCinsiyet = yeniCinsiyet;
    });
    _ayarKaydet('kullanici_cinsiyet', yeniCinsiyet);

    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          l10n.anaCinsiyetGuncellendi(
            yeniCinsiyet == 'Erkek'
                ? l10n.anaErkek
                : yeniCinsiyet == 'Belirtilmemiş'
                    ? l10n.cinsiyetBelirtilmemis
                    : l10n.anaKadin,
          ),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}


