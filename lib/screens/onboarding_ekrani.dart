import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';
import 'package:confetti/confetti.dart';

import 'ana_ekran.dart';
import '../main.dart';
import '../l10n/app_localizations.dart';
import '../widgets/dil_secim_modal.dart';
import '../services/auth_servisi.dart';
import '../services/analytics_servisi.dart';

class OnboardingEkrani extends StatefulWidget {
  const OnboardingEkrani({super.key});

  @override
  State<OnboardingEkrani> createState() => _OnboardingEkraniState();
}

class _OnboardingEkraniState extends State<OnboardingEkrani> {
  final PageController _pageController = PageController();
  final TextEditingController _isimController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _sifreController = TextEditingController();

  late ConfettiController _confettiController;
  final AuthServisi _authServisi = AuthServisi();

  int _mevcutSayfa = 0;
  bool _girisModu = true;
  bool _sifreGizli = true;
  bool _yukleniyor = false;

  String _seciliCinsiyet = 'female';
  final List<String> _seciliTarzlar = [];
  String? _seciliRenk;
  String _seciliTenRengi = 'wheat';

  bool _kosullarOkundu = false;
  bool _kosullariKabulEtti = false;

  String _cinsiyetKayitDegeri() {
    if (_seciliCinsiyet == 'male') return 'Erkek';
    if (_seciliCinsiyet == 'unspecified') return 'Belirtilmemiş';
    return 'Kadın';
  }

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 1));
  }

  @override
  void dispose() {
    _pageController.dispose();
    _isimController.dispose();
    _emailController.dispose();
    _sifreController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  // Her sayfa için canlı ve tematik renk paleti
  List<Color> _getSayfaRenkPaleti(int index) {
    const paletler = [
      [Color(0xFF6C5CE7), Color(0xFFA29BFE)], // Hoş Geldin - Mor / Indigo
      [Color(0xFF8E44AD), Color(0xFFE056FD)], // Dolap - Eflatun / Pembe
      [
        Color(0xFFFF9F43),
        Color(0xFFFECA57)
      ], // Hava Durumu - Sıcak Turuncu / Sarı
      [Color(0xFF00CEC9), Color(0xFF81ECEC)], // Yıkama - Turkuaz / Su Yeşili
      [Color(0xFFFF7675), Color(0xFFFF9FF3)], // Eksik Parça - Mercan / Roze
      [Color(0xFF1DD1A1), Color(0xFF10AC84)], // Analitik - Zümrüt Yeşili
      [Color(0xFFF39C12), Color(0xFFFFD32A)], // Stilist - Altın Sarı
      [Color(0xFF6C5CE7), Color(0xFFFF7675)], // Giriş / Kayıt - Canlı Gradient
    ];
    return paletler[index % paletler.length];
  }

  Color _getIconColor(String iconName, ColorScheme colors) {
    switch (iconName) {
      case 'language':
        return const Color(0xFF6C5CE7);
      case 'checkroom':
        return const Color(0xFF8E44AD);
      case 'wb_sunny':
        return const Color(0xFFFF9F43);
      case 'local_laundry_service':
        return const Color(0xFF00CEC9);
      case 'shopping_bag':
        return const Color(0xFFFF7675);
      case 'insights':
        return const Color(0xFF1DD1A1);
      case 'auto_awesome':
        return const Color(0xFFF39C12);
      default:
        return colors.primary;
    }
  }

  IconData _getIcon(String iconName) {
    switch (iconName) {
      case 'checkroom':
        return Icons.checkroom_rounded;
      case 'wb_sunny':
        return Icons.wb_sunny_rounded;
      case 'local_laundry_service':
        return Icons.local_laundry_service_rounded;
      case 'shopping_bag':
        return Icons.shopping_bag_rounded;
      case 'insights':
        return Icons.insights_rounded;
      case 'auto_awesome':
        return Icons.auto_awesome_rounded;
      case 'language':
        return Icons.language_rounded;
      default:
        return Icons.style_rounded;
    }
  }

  Future<void> _onboardingAtla() async {
    final colors = Theme.of(context).colorScheme;
    HapticFeedback.mediumImpact();
    setState(() => _yukleniyor = true);

    try {
      await _authServisi.anonimGirisYap(cinsiyet: _cinsiyetKayitDegeri());

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('kullanici_cinsiyet', _cinsiyetKayitDegeri());
      String kaydedilecekTarz =
          _seciliTarzlar.isEmpty ? 'Genel' : _seciliTarzlar.join(', ');
      await prefs.setString('kullanici_tarzi', kaydedilecekTarz);
      await prefs.setString('kullanici_renk_paleti', _seciliRenk ?? '');
      await prefs.setString('kullanici_ten_rengi', _seciliTenRengi);
      if (_isimController.text.trim().isNotEmpty) {
        await prefs.setString('kullanici_ismi', _isimController.text.trim());
      }
      await prefs.setBool('onboarding_tamamlandi', true);

      await AnalyticsServisi().olay('onboarding_complete', {'skipped': 1});

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AnaEkraniNavigasyon()),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
            style:
                TextStyle(color: colors.onError, fontWeight: FontWeight.w600),
          ),
          backgroundColor: colors.error,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      );
    } finally {
      if (mounted) setState(() => _yukleniyor = false);
    }
  }

  Future<void> _onboardingVeAuthTamamla(AppLocalizations l10n) async {
    final colors = Theme.of(context).colorScheme;
    final email = _emailController.text.trim();
    final sifre = _sifreController.text.trim();
    final isim = _isimController.text.trim();

    if (email.isEmpty || sifre.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.lutfenEpostaVeSifreGiriniz,
            style: TextStyle(
                color: colors.onTertiaryContainer, fontWeight: FontWeight.w600),
          ),
          backgroundColor: colors.tertiaryContainer,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      );
      return;
    }

    if (!_girisModu && isim.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.lutfenAdiniziGiriniz,
            style: TextStyle(
                color: colors.onTertiaryContainer, fontWeight: FontWeight.w600),
          ),
          backgroundColor: colors.tertiaryContainer,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      );
      return;
    }

    setState(() => _yukleniyor = true);

    try {
      if (_girisModu) {
        await _authServisi.girisYap(email: email, sifre: sifre);
      } else {
        await _authServisi.kayitOl(
          kullaniciAdi: isim,
          email: email,
          sifre: sifre,
          cinsiyet: _cinsiyetKayitDegeri(),
        );
      }

      _confettiController.play();
      HapticFeedback.heavyImpact();
      await Future.delayed(const Duration(milliseconds: 1000));

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('kullanici_cinsiyet', _cinsiyetKayitDegeri());
      String kaydedilecekTarz =
          _seciliTarzlar.isEmpty ? 'Genel' : _seciliTarzlar.join(', ');
      await prefs.setString('kullanici_tarzi', kaydedilecekTarz);
      await prefs.setString('kullanici_renk_paleti', _seciliRenk ?? '');
      await prefs.setString('kullanici_ten_rengi', _seciliTenRengi);
      if (isim.isNotEmpty) {
        await prefs.setString('kullanici_ismi', isim);
      }
      await prefs.setBool('onboarding_tamamlandi', true);

      await AnalyticsServisi().olay('onboarding_complete', {'skipped': 0});

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AnaEkraniNavigasyon()),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
            style:
                TextStyle(color: colors.onError, fontWeight: FontWeight.w600),
          ),
          backgroundColor: colors.error,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      );
    } finally {
      if (mounted) setState(() => _yukleniyor = false);
    }
  }

  // 🔵 GOOGLE İLE GİRİŞ / KAYIT TETİKLEYİCİSİ
  Future<void> _googleIleGirisTetikle() async {
    final colors = Theme.of(context).colorScheme;
    HapticFeedback.lightImpact();
    setState(() => _yukleniyor = true);

    try {
      final userCredential = await _authServisi.googleIleGirisYap(
        cinsiyet: _cinsiyetKayitDegeri(),
      );

      // Kullanıcı Google penceresini kapattıysa işlemi durdur
      if (userCredential == null) return;

      _confettiController.play();
      HapticFeedback.heavyImpact();
      await Future.delayed(const Duration(milliseconds: 1000));

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('kullanici_cinsiyet', _cinsiyetKayitDegeri());
      final String kaydedilecekTarz =
          _seciliTarzlar.isEmpty ? 'Genel' : _seciliTarzlar.join(', ');
      await prefs.setString('kullanici_tarzi', kaydedilecekTarz);
      await prefs.setString('kullanici_renk_paleti', _seciliRenk ?? '');
      await prefs.setString('kullanici_ten_rengi', _seciliTenRengi);

      final profil = await _authServisi.kullaniciProfiliniGetir();
      final String isim = _isimController.text.trim().isNotEmpty
          ? _isimController.text.trim()
          : (profil?['kullaniciAdi']?.toString() ??
              userCredential.user?.displayName ??
              '');
      if (isim.isNotEmpty) {
        await prefs.setString('kullanici_ismi', isim);
      }
      await prefs.setBool('onboarding_tamamlandi', true);

      await AnalyticsServisi().olay('onboarding_complete', {'skipped': 0});

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AnaEkraniNavigasyon()),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
            style:
                TextStyle(color: colors.onError, fontWeight: FontWeight.w600),
          ),
          backgroundColor: colors.error,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      );
    } finally {
      if (mounted) setState(() => _yukleniyor = false);
    }
  }

  void _kullanimKosullariModaliniAc(
      BuildContext context, AppLocalizations l10n) {
    HapticFeedback.lightImpact();
    final colors = Theme.of(context).colorScheme;

    final ScrollController modalScrollController = ScrollController();
    bool enAltaUlasildi = _kosullarOkundu;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return SafeArea(
            bottom: true,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.82,
                decoration: BoxDecoration(
                  color: colors.surfaceContainerHigh.withValues(alpha: 0.95),
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(28)),
                  border: Border.all(
                      color: const Color(0xFF6C5CE7).withValues(alpha: 0.3),
                      width: 1.5),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    Container(
                      width: 48,
                      height: 5,
                      decoration: BoxDecoration(
                        color: const Color(0xFF6C5CE7).withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      child: Row(
                        children: [
                          const Icon(Icons.gavel_rounded,
                              color: Color(0xFF6C5CE7), size: 24),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              l10n.kullanimKosullariBaslik,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.5,
                                color: colors.onSurface,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.close_rounded,
                                size: 22, color: colors.onSurfaceVariant),
                            onPressed: () => Navigator.pop(ctx),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                        height: 1,
                        color: colors.outlineVariant.withValues(alpha: 0.4)),
                    Expanded(
                      child: NotificationListener<ScrollNotification>(
                        onNotification: (scrollNotification) {
                          if (scrollNotification.metrics.pixels >=
                                  (scrollNotification.metrics.maxScrollExtent -
                                      40) &&
                              !enAltaUlasildi) {
                            setModalState(() {
                              enAltaUlasildi = true;
                            });
                            HapticFeedback.selectionClick();
                          }
                          return false;
                        },
                        child: SingleChildScrollView(
                          controller: modalScrollController,
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                          child: Text(
                            l10n.kullanimKosullariMetni,
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.6,
                              color: colors.onSurfaceVariant,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(16, 12, 16,
                          12 + MediaQuery.of(context).padding.bottom),
                      decoration: BoxDecoration(
                        color: colors.surfaceContainer,
                        border: Border(
                            top: BorderSide(
                                color: colors.outlineVariant
                                    .withValues(alpha: 0.4))),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (!enAltaUlasildi)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.arrow_downward_rounded,
                                      size: 14, color: Color(0xFF6C5CE7)),
                                  const SizedBox(width: 6),
                                  Flexible(
                                    child: Text(
                                      l10n.onaylamakIcinKaydirin,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF6C5CE7)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: enAltaUlasildi
                                    ? const Color(0xFF2E7D32)
                                    : colors.surfaceContainerHighest,
                                foregroundColor: enAltaUlasildi
                                    ? Colors.white
                                    : colors.onSurfaceVariant,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16)),
                              ),
                              onPressed: enAltaUlasildi
                                  ? () {
                                      HapticFeedback.mediumImpact();
                                      setState(() {
                                        _kosullarOkundu = true;
                                        _kosullariKabulEtti = true;
                                      });
                                      Navigator.pop(ctx);
                                    }
                                  : null,
                              child: Text(
                                l10n.okudumAnladimKabulEdiyorum,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    ).whenComplete(() {
      modalScrollController.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = KombinDanismaniApp.of(context);
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final seciliLocale = appState.currentLocale;

    if (_seciliTarzlar.isEmpty) _seciliTarzlar.add(l10n.tarzSpor);
    _seciliRenk ??= l10n.renkKoyuTonlar;
    _seciliTenRengi = _seciliTenRengi.isEmpty ? 'wheat' : _seciliTenRengi;

    final String dilAdiEtiketi =
        _getDilEtiketi(seciliLocale?.languageCode, l10n);
    final Color authGreenColor = const Color(0xFF2E7D32);
    final Color antrasitRenk = const Color(0xFF37474F);

    final List<Map<String, String>> tanitimSayfalari = [
      {
        "baslik": l10n.onboardingHosGeldinBaslik,
        "aciklama": l10n.ilkGorevAciklama,
        "icon": "language",
        "lottie": "https://assets9.lottiefiles.com/packages/lf20_q5pk6p1k.json"
      },
      {
        "baslik": l10n.onboardingDolabiniDijitallestir,
        "aciklama": l10n.onboardingDolapAciklama,
        "icon": "checkroom",
        "lottie": "https://assets3.lottiefiles.com/packages/lf20_pcqhwzdj.json"
      },
      {
        "baslik": l10n.onboardingHavaDurumu,
        "aciklama": l10n.onboardingHavaAciklama,
        "icon": "wb_sunny",
        "lottie": "https://assets5.lottiefiles.com/packages/lf20_xlky4sqw.json"
      },
      {
        "baslik": l10n.onboardingYikama,
        "aciklama": l10n.onboardingYikamaAciklama,
        "icon": "local_laundry_service",
        "lottie":
            "https://assets2.lottiefiles.com/private_files/lf30_j1t2h6.json"
      },
      {
        "baslik": l10n.onboardingEksikParca,
        "aciklama": l10n.onboardingEksikAciklama,
        "icon": "shopping_bag",
        "lottie": "https://assets8.lottiefiles.com/packages/lf20_p8tx08qj.json"
      },
      {
        "baslik": l10n.onboardingAnalitik,
        "aciklama": l10n.onboardingAnalitikAciklama,
        "icon": "insights",
        "lottie": "https://assets10.lottiefiles.com/packages/lf20_q5pk6p1k.json"
      },
      {
        "baslik": l10n.onboardingStilist,
        "aciklama": l10n.onboardingStilistAciklama,
        "icon": "auto_awesome",
        "lottie": "https://assets4.lottiefiles.com/packages/lf20_7k0f9h9p.json"
      },
    ];

    final int toplamSayfaSayisi = tanitimSayfalari.length + 1;
    final bool isGirisSayfasi = _mevcutSayfa == toplamSayfaSayisi - 1;
    final List<Color> aktifPalet = _getSayfaRenkPaleti(_mevcutSayfa);

    final List<Map<String, String>> cinsiyetListesi = [
      {'key': 'female', 'label': l10n.kadin},
      {'key': 'male', 'label': l10n.erkek},
      {'key': 'unspecified', 'label': l10n.cinsiyetBelirtilmemis},
    ];
    final List<String> tarzListesi = [
      l10n.tarzSpor,
      l10n.tarzKlasik,
      l10n.tarzSokakModasi,
      l10n.tarzMinimalist
    ];
    final List<String> renkListesi = [
      l10n.renkKoyuTonlar,
      l10n.renkPastel,
      l10n.renkCanli,
      l10n.renkNotr
    ];
    final List<Map<String, String>> tenRengiListesi = [
      {'key': 'light', 'label': l10n.tenAcikBeyaz},
      {'key': 'wheat', 'label': l10n.tenBugday},
      {'key': 'dark', 'label': l10n.tenEsmerKoyu},
    ];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          _buildPremiumIconButton(
                              icon: Icons.language_rounded,
                              iconColor: antrasitRenk,
                              onTap: () {
                                HapticFeedback.selectionClick();
                                DilSecimModal.goster(context);
                              }),
                        ],
                      ),
                      Flexible(
                        child: TextButton(
                          onPressed: _yukleniyor ? null : _onboardingAtla,
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            backgroundColor: colors.surfaceContainerHighest
                                .withValues(alpha: 0.8),
                          ),
                          child: Text(
                            l10n.onboardingAtla,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: colors.onSurfaceVariant,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    physics: const BouncingScrollPhysics(),
                    itemCount: toplamSayfaSayisi,
                    onPageChanged: (index) {
                      HapticFeedback.selectionClick();
                      setState(() => _mevcutSayfa = index);
                    },
                    itemBuilder: (context, index) {
                      if (index == toplamSayfaSayisi - 1) {
                        return SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(28, 16, 28, 120),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Icon(Icons.checkroom_rounded,
                                  size: 76, color: authGreenColor),
                              const SizedBox(height: 12),
                              Text(
                                _girisModu
                                    ? l10n.hesabinizaGirisYapin
                                    : l10n.yeniHesapOlusturun,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -0.5,
                                  color: colors.onSurface,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                _girisModu
                                    ? l10n.stilDunyanaTekrarHosGeldin
                                    : l10n.kombinleriniSaklamakIcinKatil,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: colors.onSurfaceVariant,
                                    fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 24),

                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: colors.surfaceContainerHighest,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () =>
                                            setState(() => _girisModu = true),
                                        child: AnimatedContainer(
                                          duration:
                                              const Duration(milliseconds: 200),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          decoration: BoxDecoration(
                                            color: _girisModu
                                                ? authGreenColor
                                                : null,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: _girisModu
                                                ? const Border(
                                                    bottom: BorderSide(
                                                      color: Color(0xFF1B5E20),
                                                      width: 2,
                                                    ),
                                                  )
                                                : null,
                                          ),
                                          child: Text(
                                            l10n.girisYap,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: _girisModu
                                                  ? Colors.white
                                                  : colors.onSurfaceVariant,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () =>
                                            setState(() => _girisModu = false),
                                        child: AnimatedContainer(
                                          duration:
                                              const Duration(milliseconds: 200),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          decoration: BoxDecoration(
                                            color: !_girisModu
                                                ? authGreenColor
                                                : null,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: !_girisModu
                                                ? const Border(
                                                    bottom: BorderSide(
                                                      color: Color(0xFF1B5E20),
                                                      width: 2,
                                                    ),
                                                  )
                                                : null,
                                          ),
                                          child: Text(
                                            l10n.kayitOl,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: !_girisModu
                                                  ? Colors.white
                                                  : colors.onSurfaceVariant,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),

                              if (!_girisModu) ...[
                                TextField(
                                  controller: _isimController,
                                  textCapitalization: TextCapitalization.words,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                      color: colors.onSurface),
                                  decoration: InputDecoration(
                                    labelText: l10n.adinizVeyaLakabiniz,
                                    labelStyle: TextStyle(
                                        color: colors.onSurfaceVariant),
                                    prefixIcon: Icon(
                                        Icons.person_outline_rounded,
                                        color: antrasitRenk),
                                    filled: true,
                                    fillColor: colors.surfaceContainerHighest
                                        .withValues(alpha: 0.6),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 14),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide.none),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide(
                                            color: authGreenColor, width: 2)),
                                  ),
                                ),
                                const SizedBox(height: 12),
                              ],

                              TextField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                    color: colors.onSurface),
                                decoration: InputDecoration(
                                  labelText: l10n.epostaAdresiniz,
                                  labelStyle:
                                      TextStyle(color: colors.onSurfaceVariant),
                                  prefixIcon: Icon(Icons.email_outlined,
                                      color: antrasitRenk),
                                  filled: true,
                                  fillColor: colors.surfaceContainerHighest
                                      .withValues(alpha: 0.6),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 14),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide.none),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(
                                          color: authGreenColor, width: 2)),
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: _sifreController,
                                obscureText: _sifreGizli,
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                    color: colors.onSurface),
                                decoration: InputDecoration(
                                  labelText: l10n.sifreniz,
                                  labelStyle:
                                      TextStyle(color: colors.onSurfaceVariant),
                                  prefixIcon: Icon(Icons.lock_outline_rounded,
                                      color: antrasitRenk),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                        _sifreGizli
                                            ? Icons.visibility_off_rounded
                                            : Icons.visibility_rounded,
                                        color: colors.onSurfaceVariant),
                                    onPressed: () => setState(
                                        () => _sifreGizli = !_sifreGizli),
                                  ),
                                  filled: true,
                                  fillColor: colors.surfaceContainerHighest
                                      .withValues(alpha: 0.6),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 14),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide.none),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(
                                          color: authGreenColor, width: 2)),
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Yeşil renkli işlem butonu (Hem Giriş Yap hem Kayıt Ol modunda)
                              Container(
                                height: 52,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: authGreenColor,
                                ),
                                child: ElevatedButton(
                                  onPressed: _yukleniyor
                                      ? null
                                      : () => _onboardingVeAuthTamamla(l10n),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    minimumSize:
                                        const Size(double.infinity, 52),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                  ),
                                  child: _yukleniyor
                                      ? const SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2.5))
                                      : Text(
                                          _girisModu
                                              ? l10n.girisYapVeBasla
                                              : l10n.kayitOlVeBasla,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Ayraç: veya
                              Row(
                                children: [
                                  Expanded(
                                      child: Divider(
                                          color: colors.outlineVariant)),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    child: Text(
                                      "veya",
                                      style: TextStyle(
                                          color: colors.onSurfaceVariant,
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  Expanded(
                                      child: Divider(
                                          color: colors.outlineVariant)),
                                ],
                              ),

                              const SizedBox(height: 16),

                               const SizedBox(height: 16),

                               // Google ile Giriş Yap Butonu - Tema uyumlu modern tasarım
                               OutlinedButton.icon(
                                 style: OutlinedButton.styleFrom(
                                   minimumSize: const Size(double.infinity, 52),
                                   shape: RoundedRectangleBorder(
                                       borderRadius: BorderRadius.circular(16)),
                                   side: BorderSide(color: colors.outlineVariant, width: 1.5),
                                   backgroundColor: colors.surfaceContainerLow,
                                   foregroundColor: colors.onSurface,
                                   elevation: 0,
                                   padding: const EdgeInsets.symmetric(vertical: 14),
                                 ),
                                 onPressed:
                                     _yukleniyor ? null : () { _googleIleGirisTetikle(); },
                                 icon: Image.asset(
                                   'assets/images/google_logo.png',
                                   height: 24,
                                   width: 24,
                                   errorBuilder: (_, __, ___) => const Icon(
                                     Icons.g_mobiledata_rounded,
                                     size: 26,
                                     color: Color(0xFF4285F4),
                                   ),
                                 ),
                                 label: Text(
                                   l10n.girisYapGoogle,
                                   style: TextStyle(
                                     fontSize: 15.5,
                                     fontWeight: FontWeight.w600,
                                     color: colors.onSurface,
                                     letterSpacing: 0.2,
                                   ),
                                 ),
                               ),
                              const SizedBox(height: 12),

                              OutlinedButton.icon(
                                onPressed: _yukleniyor ? null : _onboardingAtla,
                                icon: Icon(Icons.arrow_forward_rounded,
                                    size: 18, color: colors.onSurface),
                                label: Text(
                                  l10n.misafirOlarakDevamEt,
                                  style: TextStyle(
                                      color: colors.onSurface,
                                      fontWeight: FontWeight.bold),
                                ),
                                style: OutlinedButton.styleFrom(
                                  minimumSize: const Size(double.infinity, 50),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16)),
                                  side:
                                      BorderSide(color: colors.outlineVariant),
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      final sayfa = tanitimSayfalari[index];
                      final isLastTanitim =
                          index == tanitimSayfalari.length - 1;
                      final isFirstPage = index == 0;
                      final Color sayfaIkonRengi =
                          _getIconColor(sayfa["icon"]!, colors);

                      return SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(28, 16, 28, 120),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: isLastTanitim ? 80 : 200,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Canlı ve Parlak İkon Rozeti
                                  Container(
                                    padding:
                                        EdgeInsets.all(isLastTanitim ? 12 : 20),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: sayfaIkonRengi.withValues(
                                          alpha: 0.15),
                                      border: Border.all(
                                          color: sayfaIkonRengi.withValues(
                                              alpha: 0.3),
                                          width: 1.5),
                                    ),
                                    child: Icon(
                                      _getIcon(sayfa["icon"]!),
                                      size: isLastTanitim ? 36 : 64,
                                      color: sayfaIkonRengi,
                                    ),
                                  ),
                                  IgnorePointer(
                                    child: Lottie.network(
                                      sayfa["lottie"]!,
                                      fit: BoxFit.contain,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const SizedBox.shrink(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: isLastTanitim ? 16 : 32),
                            Text(
                              sayfa["baslik"]!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.5,
                                color: colors.onSurface,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              sayfa["aciklama"]!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14.5,
                                color: colors.onSurfaceVariant,
                                height: 1.5,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (isFirstPage) ...[
                              const SizedBox(height: 36),
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      const Color(0xFF6C5CE7)
                                          .withValues(alpha: 0.12),
                                      const Color(0xFFA29BFE)
                                          .withValues(alpha: 0.05),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color: const Color(0xFF6C5CE7)
                                          .withValues(alpha: 0.3),
                                      width: 1.5),
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 18, vertical: 6),
                                  leading: _buildPremiumIconContainer(
                                      Icons.language_rounded,
                                      iconColor: const Color(0xFF6C5CE7)),
                                  title: Text(l10n.uygulamaDili,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 15,
                                          color: colors.onSurface)),
                                  subtitle: Text(dilAdiEtiketi,
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: colors.onSurfaceVariant,
                                          fontWeight: FontWeight.w600)),
                                  trailing: const Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      size: 24,
                                      color: Color(0xFF6C5CE7)),
                                  onTap: () {
                                    HapticFeedback.selectionClick();
                                    DilSecimModal.goster(context);
                                  },
                                ),
                              ),
                            ],
                            if (isLastTanitim) ...[
                              const SizedBox(height: 24),
                              _buildSectionLabel(
                                  l10n.cinsiyetBaslik, colors, sayfaIkonRengi),
                              Wrap(
                                spacing: 10.0,
                                runSpacing: 10.0,
                                children: cinsiyetListesi
                                    .map((c) => _buildPremiumChip(
                                          label: c['label']!,
                                          isSelected:
                                              _seciliCinsiyet == c['key'],
                                          accentColor: sayfaIkonRengi,
                                          onTap: () => setState(() =>
                                              _seciliCinsiyet = c['key']!),
                                        ))
                                    .toList(),
                              ),
                              const SizedBox(height: 20),
                              _buildSectionLabel(
                                  l10n.tarzBaslik, colors, sayfaIkonRengi),
                              Wrap(
                                spacing: 10.0,
                                runSpacing: 10.0,
                                children: tarzListesi
                                    .map((t) => _buildPremiumChip(
                                          label: t,
                                          isSelected:
                                              _seciliTarzlar.contains(t),
                                          accentColor: sayfaIkonRengi,
                                          onTap: () {
                                            setState(() {
                                              if (_seciliTarzlar.contains(t)) {
                                                _seciliTarzlar.remove(t);
                                              } else {
                                                _seciliTarzlar.add(t);
                                              }
                                            });
                                          },
                                        ))
                                    .toList(),
                              ),
                              const SizedBox(height: 20),
                              _buildSectionLabel(l10n.renkTercihiBaslik, colors,
                                  sayfaIkonRengi),
                              Wrap(
                                spacing: 10.0,
                                runSpacing: 10.0,
                                children: renkListesi
                                    .map((r) => _buildPremiumChip(
                                          label: r,
                                          isSelected: _seciliRenk == r,
                                          accentColor: sayfaIkonRengi,
                                          onTap: () =>
                                              setState(() => _seciliRenk = r),
                                        ))
                                    .toList(),
                              ),
                              const SizedBox(height: 20),
                              _buildSectionLabel(
                                  l10n.tenRengiBaslik, colors, sayfaIkonRengi),
                              Wrap(
                                spacing: 10.0,
                                runSpacing: 10.0,
                                children: tenRengiListesi
                                    .map((tr) => _buildPremiumChip(
                                          label: tr['label']!,
                                          isSelected:
                                              _seciliTenRengi == tr['key'],
                                          accentColor: sayfaIkonRengi,
                                          onTap: () => setState(() =>
                                              _seciliTenRengi = tr['key']!),
                                        ))
                                    .toList(),
                              ),
                              const SizedBox(height: 24),
                              Container(
                                decoration: BoxDecoration(
                                  color: colors.surfaceContainerLow,
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(
                                    color: _kosullariKabulEtti
                                        ? sayfaIkonRengi
                                        : colors.outlineVariant
                                            .withValues(alpha: 0.4),
                                    width: 1.5,
                                  ),
                                ),
                                child: CheckboxListTile(
                                  value: _kosullariKabulEtti,
                                  activeColor: sayfaIkonRengi,
                                  checkColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 4),
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  title: GestureDetector(
                                    onTap: () => _kullanimKosullariModaliniAc(
                                        context, l10n),
                                    child: RichText(
                                      text: TextSpan(
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: colors.onSurfaceVariant,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: l10n.kullanimKosullarini,
                                            style: TextStyle(
                                              color: sayfaIkonRengi,
                                              decoration:
                                                  TextDecoration.underline,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                              text: l10n.okudumVeOnayliyorum),
                                        ],
                                      ),
                                    ),
                                  ),
                                  onChanged: (val) {
                                    if (!_kosullarOkundu) {
                                      HapticFeedback.heavyImpact();
                                      ScaffoldMessenger.of(context)
                                          .clearSnackBars();
                                      _kullanimKosullariModaliniAc(
                                          context, l10n);
                                    } else {
                                      HapticFeedback.selectionClick();
                                      setState(() =>
                                          _kosullariKabulEtti = val ?? false);
                                    }
                                  },
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.fromLTRB(
                  24, 12, 24, MediaQuery.of(context).padding.bottom + 12),
              decoration: BoxDecoration(
                color: colors.surfaceContainer.withValues(alpha: 0.9),
                border: Border(
                    top: BorderSide(
                        color: colors.outlineVariant.withValues(alpha: 0.4))),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Renkli ve Animasyonlu Sayfa Gösterge Çizgileri
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(toplamSayfaSayisi, (i) {
                      bool isActive = _mevcutSayfa == i;
                      final sayfaRenk = _getSayfaRenkPaleti(i)[0];
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeOutCubic,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 8,
                        width: isActive ? 28 : 8,
                        decoration: BoxDecoration(
                          color: isActive
                              ? sayfaRenk
                              : colors.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 12),

                  if (!isGirisSayfasi)
                    Container(
                      height: 52,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                            colors: [aktifPalet[0], aktifPalet[1]]),
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        onPressed: () {
                          if (_mevcutSayfa == tanitimSayfalari.length - 1 &&
                              !_kosullariKabulEtti) {
                            HapticFeedback.heavyImpact();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  l10n.devamEtmekIcinKosullariKabulEdin,
                                  style: TextStyle(
                                      color: colors.onTertiaryContainer,
                                      fontWeight: FontWeight.w600),
                                ),
                                backgroundColor: colors.tertiaryContainer,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16)),
                              ),
                            );
                            return;
                          }
                          HapticFeedback.mediumImpact();
                          _pageController.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeOutCubic);
                        },
                        child: Text(
                          l10n.onboardingDevamEt,
                          style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 0.5),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Color(0xFF6C5CE7),
                Color(0xFFFF7675),
                Color(0xFF00CEC9),
                Color(0xFFFECA57),
                Color(0xFF1DD1A1),
              ],
              numberOfParticles: 50,
              maxBlastForce: 40,
              minBlastForce: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    Color? accentColor,
  }) {
    final colors = Theme.of(context).colorScheme;
    final effectiveAccent = accentColor ?? colors.primary;

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? effectiveAccent : colors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: isSelected
                  ? effectiveAccent
                  : colors.outlineVariant.withValues(alpha: 0.4),
              width: 1.5),
        ),
        child: Text(label,
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
              color: isSelected ? Colors.white : colors.onSurfaceVariant,
            )),
      ),
    );
  }

  Widget _buildSectionLabel(String text, ColorScheme colors,
      [Color? labelColor]) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12.0, left: 4),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w900,
            color: labelColor ?? colors.onSurface,
            fontSize: 11,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumIconButton(
      {required IconData icon, Color? iconColor, required VoidCallback onTap}) {
    final colors = Theme.of(context).colorScheme;
    final effectiveColor = iconColor ?? colors.primary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: effectiveColor.withValues(alpha: 0.12),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: effectiveColor, size: 22),
      ),
    );
  }

  Widget _buildPremiumIconContainer(IconData icon, {Color? iconColor}) {
    final colors = Theme.of(context).colorScheme;
    final effectiveColor = iconColor ?? colors.primary;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: effectiveColor.withValues(alpha: 0.15),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: effectiveColor, size: 20),
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
}