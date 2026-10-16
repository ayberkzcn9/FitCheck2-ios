import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'l10n/app_localizations.dart';

// EKRANLAR
import 'screens/ana_ekran.dart';
import 'screens/onboarding_ekrani.dart';
import 'screens/giris_ekrani.dart';

// BİLEŞENLER
import 'widgets/yukleme_ekrani.dart';

// SERVİSLER
import 'services/analytics_servisi.dart';
import 'services/auth_servisi.dart';
import 'services/background_removal_service.dart';
import 'services/bildirim_servisi.dart';
import 'services/fcm_service.dart';
import 'services/reklam_servisi.dart';
import '../theme/design_tokens.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  BackgroundRemovalService().initialize();

  final prefs = await SharedPreferences.getInstance();
  final bool onboardingTamamlandi =
      prefs.getBool('onboarding_tamamlandi') ?? false;
  final String kayitliTemaModu =
      prefs.getString('uygulama_temasi_modu') ?? 'light';
  final String? secilenDilKodu = prefs.getString('secilen_dil_kodu');

  runApp(
    KombinDanismaniApp(
      onboardingTamamlandi: onboardingTamamlandi,
      baslangicTemaModuStr: kayitliTemaModu,
      baslangicDilKodu: secilenDilKodu,
      baslatmaIslemi: uygulamaHazirliklariniBaslat(),
    ),
  );
}

Future<UygulamaBaslatmaSonucu> uygulamaHazirliklariniBaslat() async {
  bool firebaseHazir = false;
  try {
    // Ağ yoksa Firebase başlatma sonsuza kadar bekleyebilir; zaman aşımı koy.
    await Firebase.initializeApp().timeout(const Duration(seconds: 12));
    firebaseHazir = true;
  } catch (e) {
    debugPrint('Firebase başlatma uyarısı: $e');
  }

  if (firebaseHazir) {
    try {
      await FcmService().init().timeout(const Duration(seconds: 10));
      await FcmService()
          .subscribeToTopic('genel')
          .timeout(const Duration(seconds: 10));
    } catch (e) {
      debugPrint('FCM başlatma hatası: $e');
    }
  }

  if (firebaseHazir) {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      debugPrint(
        'Açılışta kayıtlı oturum: ${auth.currentUser == null ? 'yok' : 'var'}',
      );
      await AuthServisi()
          .oturumuSessizceGeriYukle()
          .timeout(const Duration(seconds: 10));
    } catch (e) {
      debugPrint('Oturum geri yükleme hatası: $e');
    }
  }

  AnalyticsServisi.firebaseHazir = firebaseHazir;
  try {
    await AnalyticsServisi()
        .izniYukle()
        .timeout(const Duration(seconds: 5));
    await AnalyticsServisi().baslat().timeout(const Duration(seconds: 8));
  } catch (e) {
    debugPrint('Analytics başlatma hatası: $e');
  }

  await ReklamServisi().premiumDurumunuYukle();

  if (!kIsWeb && ReklamServisi.reklamlarEtkinMi) {
    try {
      // iOS 14+: reklamlar için izleme izni (ATT). Kullanıcı reddederse AdMob
      // kişiselleştirilmemiş reklam servis eder; akış hiçbir durumda bozulmaz.
      if (Platform.isIOS) {
        try {
          final TrackingStatus attDurum =
              await AppTrackingTransparency.trackingAuthorizationStatus;
          if (attDurum == TrackingStatus.notDetermined) {
            // iOS, uygulama tam aktif olmadan diyaloğu göstermez; kısa bekle.
            await Future.delayed(const Duration(milliseconds: 600));
            await AppTrackingTransparency.requestTrackingAuthorization();
          }
        } catch (e) {
          debugPrint('ATT izni hatası: $e');
        }
      }

      // AdMob başlatma ağ gerektirebilir; takılmayı önlemek için zaman aşımı.
      await MobileAds.instance
          .initialize()
          .timeout(const Duration(seconds: 12));
      // Ön yükleme (non-blocking): reklamlar hazır bekler, gerektiğinde anında
      // gösterilir. initialize() await edildiği için SDK hazır durumdadır.
      ReklamServisi().gecisReklamiYukle();
      ReklamServisi().odulluReklamYukle();
    } catch (e) {
      debugPrint('AdMob başlatma hatası: $e');
    }
  }

  try {
    await BildirimServisi().init().timeout(const Duration(seconds: 10));
    final prefs = await SharedPreferences.getInstance();
    final bool sabahBildirimiAcik = prefs.getBool('sabah_bildirimi') ?? true;

    if (sabahBildirimiAcik) {
      final int saat = prefs.getInt('sabah_bildirim_saat') ?? 8;
      final int dakika = prefs.getInt('sabah_bildirim_dakika') ?? 30;

      await BildirimServisi().gunlukSabahBildirimiKur(
        saat: saat,
        dakika: dakika,
      );
    } else {
      await BildirimServisi().gunlukSabahBildiriminiIptalEt();
    }

    final bool haftalikRaporAcik =
        prefs.getBool('haftalik_rapor_bildirimi') ?? true;
    if (haftalikRaporAcik) {
      await BildirimServisi().haftalikRaporBildiriminiKur();
    } else {
      await BildirimServisi().haftalikRaporBildiriminiIptalEt();
    }
  } catch (e) {
    debugPrint('Bildirim servisi hatası: $e');
  }

  await _eskiIdCakismalariniTemizle();

  return UygulamaBaslatmaSonucu(firebaseHazir: firebaseHazir);
}

Future<void> _eskiIdCakismalariniTemizle() async {
  const migrationKey = 'id_migration_v1_done';
  try {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(migrationKey) == true) return;

    var changed = false;
    final seen = <String>{};

    final gardiropString = prefs.getString('gardirobum_data');
    if (gardiropString != null && gardiropString.isNotEmpty) {
      final List<dynamic> decoded = jsonDecode(gardiropString);
      for (var item in decoded) {
        if (item is Map && item['id'] != null) {
          final currentId = item['id'] as String;
          if (seen.contains(currentId)) {
            item['id'] = '${DateTime.now().microsecondsSinceEpoch}_${Random().nextInt(999999999)}_${currentId.hashCode}';
            changed = true;
            debugPrint('🔧 Gardırop ID çakışması düzeltildi: $currentId -> ${item['id']}');
          }
          seen.add(item['id'] as String);
        }
      }
      if (changed) {
        await prefs.setString('gardirobum_data', jsonEncode(decoded));
      }
    }

    seen.clear();
    final favoriString = prefs.getString('favoriler_data');
    if (favoriString != null && favoriString.isNotEmpty) {
      final List<dynamic> decoded = jsonDecode(favoriString);
      for (var item in decoded) {
        if (item is Map && item['id'] != null) {
          final currentId = item['id'] as String;
          if (seen.contains(currentId)) {
            item['id'] = '${DateTime.now().microsecondsSinceEpoch}_${Random().nextInt(999999999)}_${currentId.hashCode}';
            changed = true;
            debugPrint('🔧 Favori ID çakışması düzeltildi: $currentId -> ${item['id']}');
          }
          seen.add(item['id'] as String);
        }
      }
      if (changed) {
        await prefs.setString('favoriler_data', jsonEncode(decoded));
      }
    }

    seen.clear();
    final gecmisString = prefs.getString('gecmis_data');
    if (gecmisString != null && gecmisString.isNotEmpty) {
      final List<dynamic> decoded = jsonDecode(gecmisString);
      for (var item in decoded) {
        if (item is Map && item['id'] != null) {
          final currentId = item['id'] as String;
          if (seen.contains(currentId)) {
            item['id'] = '${DateTime.now().microsecondsSinceEpoch}_${Random().nextInt(999999999)}_${currentId.hashCode}';
            changed = true;
            debugPrint('🔧 Geçmiş ID çakışması düzeltildi: $currentId -> ${item['id']}');
          }
          seen.add(item['id'] as String);
        }
      }
      if (changed) {
        await prefs.setString('gecmis_data', jsonEncode(decoded));
      }
    }

    if (changed) {
      debugPrint('✅ ID migrasyonu tamamlandı (${seen.length} benzersiz ID)');
    } else {
      debugPrint('ℹ️ ID çakışması bulunamadı, migrasyon atlandı');
    }

    await prefs.setBool(migrationKey, true);
  } catch (e) {
    debugPrint('⚠️ ID migrasyon hatası (yoksayılıyor): $e');
  }
}

class UygulamaBaslatmaSonucu {
  const UygulamaBaslatmaSonucu({required this.firebaseHazir});

  final bool firebaseHazir;
}

class KombinDanismaniApp extends StatefulWidget {
  final bool onboardingTamamlandi;
  final String baslangicTemaModuStr;
  final String? baslangicDilKodu;
  final Future<UygulamaBaslatmaSonucu> baslatmaIslemi;

  const KombinDanismaniApp({
    super.key,
    required this.onboardingTamamlandi,
    required this.baslangicTemaModuStr,
    required this.baslatmaIslemi,
    this.baslangicDilKodu,
  });

  static KombinDanismaniAppState of(BuildContext context) {
    final state = context.findAncestorStateOfType<KombinDanismaniAppState>();
    assert(state != null, 'KombinDanismaniAppState bulunamadı. Widget ağacında KombinDanismaniApp altında olmalı.');
    return state!;
  }

  @override
  State<KombinDanismaniApp> createState() => KombinDanismaniAppState();
}

class KombinDanismaniAppState extends State<KombinDanismaniApp> {
  final AnalyticsNavigatorObserver _analyticsObserver =
      AnalyticsNavigatorObserver();
  Locale? _locale;
  late ThemeMode _temaModu;

  static const Color _seedColor = Color(0xFF3B3B3B);

  @override
  void initState() {
    super.initState();
    // Kayıtlı tema modunu uygula
    switch (widget.baslangicTemaModuStr) {
      case 'dark':
        _temaModu = ThemeMode.dark;
        break;
      case 'system':
        _temaModu = ThemeMode.system;
        break;
      default:
        _temaModu = ThemeMode.light;
    }
    if (widget.baslangicDilKodu != null &&
        widget.baslangicDilKodu!.isNotEmpty) {
      _locale = Locale(widget.baslangicDilKodu!);
    }
  }

  Future<void> setLocale(Locale? yeniLocale) async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;

    setState(() {
      _locale = yeniLocale;
    });

    if (yeniLocale == null) {
      await prefs.remove('secilen_dil_kodu');
    } else {
      await prefs.setString('secilen_dil_kodu', yeniLocale.languageCode);
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;

    setState(() {
      _temaModu = mode;
    });

    final deger = mode == ThemeMode.dark
        ? 'dark'
        : (mode == ThemeMode.system ? 'system' : 'light');
    await prefs.setString('uygulama_temasi_modu', deger);
  }

  void setTheme(bool isDark) {
    setThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
  }

  bool get isDarkMode {
    if (_temaModu == ThemeMode.dark) return true;
    if (_temaModu == ThemeMode.light) return false;
    // system: cihaz ayarına bak
    final brightness =
        PlatformDispatcher.instance.platformBrightness;
    return brightness == Brightness.dark;
  }

  Locale? get currentLocale => _locale;

  ColorScheme _buildColorScheme(Brightness brightness) {
    final base = ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: brightness,
    );
    final isDark = brightness == Brightness.dark;

    if (isDark) {
      return base.copyWith(
        primary: const Color(0xFFD0D0D0),
        onPrimary: const Color(0xFF202020),
        primaryContainer: const Color(0xFF4A4A4A),
        onPrimaryContainer: const Color(0xFFF2F2F2),
        secondary: const Color(0xFFC6C6C6),
        onSecondary: const Color(0xFF202020),
        secondaryContainer: const Color(0xFF464646),
        onSecondaryContainer: const Color(0xFFF0F0F0),
        tertiary: const Color(0xFFBDBDBD),
        onTertiary: const Color(0xFF202020),
        tertiaryContainer: const Color(0xFF414141),
        onTertiaryContainer: const Color(0xFFEDEDED),
        surfaceTint: const Color(0xFFD0D0D0),
      );
    }

    return base.copyWith(
      surface: const Color(0xFFF8F9FA),
      surfaceContainerLow: Colors.white,
      surfaceContainer: Colors.white,
      surfaceContainerHighest:
          const Color(0xFFEFF1F3),
      primary: const Color(0xFF3B3B3B),
      onPrimary: Colors.white,
      primaryContainer: const Color(0xFFE3E3E3),
      onPrimaryContainer: const Color(0xFF1B1B1B),
      secondary: const Color(0xFF5F5F5F),
      onSecondary: Colors.white,
      secondaryContainer: const Color(0xFFE7E7E7),
      onSecondaryContainer: const Color(0xFF202020),
      tertiary: const Color(0xFF686868),
      onTertiary: Colors.white,
      tertiaryContainer: const Color(0xFFEAEAEA),
      onTertiaryContainer: const Color(0xFF242424),
      onSurface: const Color(0xFF1C1B1F),
      onSurfaceVariant: const Color(0xFF49454F),
      outline: const Color(0xFF79747E),
      outlineVariant: const Color(0xFFCAC4D0),
      surfaceTint: const Color(0xFF3B3B3B),
    );
  }

  Widget _oturumKapisi(bool firebaseHazir) {
    if (!firebaseHazir) {
      return widget.onboardingTamamlandi
          ? const AnaEkraniNavigasyon()
          : const _SayfaIzleyici(
              ad: AnalyticsServisi.ekranOnboarding,
              child: OnboardingEkrani(),
            );
    }

    return StreamBuilder<User?>(
      initialData: FirebaseAuth.instance.currentUser,
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            !snapshot.hasData) {
          return const YuklemeEkrani(animasyonluGiris: false);
        }

        if (snapshot.hasData && snapshot.data != null) {
          final userEmail = snapshot.data!.email;
          if (userEmail != null && userEmail.isNotEmpty) {
            ReklamServisi().kullaniciEmailKaydet(userEmail);
          }

          AnalyticsServisi().kullaniciKimligiAyarla(snapshot.data!.uid);

          return const AnaEkraniNavigasyon();
        }

        return widget.onboardingTamamlandi
            ? const _SayfaIzleyici(
                ad: AnalyticsServisi.ekranGiris,
                child: GirisEkrani(),
              )
            : const _SayfaIzleyici(
                ad: AnalyticsServisi.ekranOnboarding,
                child: OnboardingEkrani(),
              );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final lightColorScheme = _buildColorScheme(Brightness.light);
    final darkColorScheme = _buildColorScheme(Brightness.dark);

    return MaterialApp(
      title: 'FitCheck',
      debugShowCheckedModeBanner: false,
      navigatorObservers: [_analyticsObserver],
      locale: _locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('tr'),
        Locale('it'),
        Locale('es'),
        Locale('zh'),
        Locale('ar'),
        Locale('fr'),
        Locale('de'),
        Locale('pt'),
        Locale('ja'),
        Locale('ko'),
        Locale('ru'),
      ],
      builder: (context, child) {
        final bool koyuMu =
            Theme.of(context).brightness == Brightness.dark;
        return Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: koyuMu
                        ? const [
                            Color(0xFF121212),
                            Color(0xFF1A1A1A),
                            Color(0xFF202020),
                          ]
                        : const [
                            Color(0xFFFAFAFC),
                            Color(0xFFF2F4F7),
                            Color(0xFFEAECF0),
                          ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: -100,
              left: -100,
              child: Container(
                width: 320,
                height: 320,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (koyuMu
                          ? const Color(0xFF2A2A2A)
                          : const Color(0xFFE2E8F0))
                      .withValues(alpha: koyuMu ? 0.4 : 0.6),
                ),
              ),
            ),
            Positioned(
              bottom: -120,
              right: -100,
              child: Container(
                width: 380,
                height: 380,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (koyuMu
                          ? const Color(0xFF262626)
                          : const Color(0xFFD1D5DB))
                      .withValues(alpha: 0.4),
                ),
              ),
            ),
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 70, sigmaY: 70),
                child: const SizedBox.expand(),
              ),
            ),
            if (child != null) child,
          ],
        );
      },
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: lightColorScheme,
        textTheme: Typography.material2021().black,
        dividerTheme: DividerThemeData(
          color: lightColorScheme.outlineVariant,
          thickness: 1,
        ),
        iconTheme: IconThemeData(
          color: lightColorScheme.onSurfaceVariant,
          size: 24,
        ),
        iconButtonTheme: IconButtonThemeData(
          style: IconButton.styleFrom(
            foregroundColor: lightColorScheme.onSurfaceVariant,
          ),
        ),
        scaffoldBackgroundColor: Colors.transparent,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: Color(0xFF1C1B1F),
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: false,
        ),
        listTileTheme: ListTileThemeData(
          iconColor: lightColorScheme.onSurfaceVariant,
          textColor: lightColorScheme.onSurface,
        ),
        cardTheme: CardThemeData(
          color: lightColorScheme.surfaceContainerLow,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        dialogTheme: DialogThemeData(
          backgroundColor: lightColorScheme.surfaceContainerHigh,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.dialogRadius,
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.transparent,
          selectedItemColor: lightColorScheme.primary,
          unselectedItemColor: lightColorScheme.onSurfaceVariant,
          elevation: 0,
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Colors.transparent,
          indicatorColor: lightColorScheme.primaryContainer,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          iconTheme: WidgetStateProperty.resolveWith((states) {
            final selected = states.contains(WidgetState.selected);
            return IconThemeData(
              color: selected
                  ? lightColorScheme.onPrimaryContainer
                  : lightColorScheme.onSurfaceVariant,
            );
          }),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            final selected = states.contains(WidgetState.selected);
            return TextStyle(
              color: selected
                  ? lightColorScheme.onSurface
                  : lightColorScheme.onSurfaceVariant,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            );
          }),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: darkColorScheme,
        textTheme: Typography.material2021().white,
        dividerTheme: DividerThemeData(
          color: darkColorScheme.outlineVariant,
          thickness: 1,
        ),
        iconTheme: IconThemeData(
          color: darkColorScheme.onSurfaceVariant,
          size: 24,
        ),
        iconButtonTheme: IconButtonThemeData(
          style: IconButton.styleFrom(
            foregroundColor: darkColorScheme.onSurfaceVariant,
          ),
        ),
        scaffoldBackgroundColor: Colors.transparent,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: Color(0xFFF2F2F2),
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: false,
        ),
        listTileTheme: ListTileThemeData(
          iconColor: darkColorScheme.onSurfaceVariant,
          textColor: darkColorScheme.onSurface,
        ),
        cardTheme: CardThemeData(
          color: darkColorScheme.surfaceContainerLow,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        dialogTheme: DialogThemeData(
          backgroundColor: darkColorScheme.surfaceContainerHigh,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.dialogRadius,
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.transparent,
          selectedItemColor: darkColorScheme.primary,
          unselectedItemColor: darkColorScheme.onSurfaceVariant,
          elevation: 0,
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Colors.transparent,
          indicatorColor: darkColorScheme.primaryContainer,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          iconTheme: WidgetStateProperty.resolveWith((states) {
            final selected = states.contains(WidgetState.selected);
            return IconThemeData(
              color: selected
                  ? darkColorScheme.onPrimaryContainer
                  : darkColorScheme.onSurfaceVariant,
            );
          }),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            final selected = states.contains(WidgetState.selected);
            return TextStyle(
              color: selected
                  ? darkColorScheme.onSurface
                  : darkColorScheme.onSurfaceVariant,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            );
          }),
        ),
      ),
      themeMode: _temaModu,
      home: _BaslangicKapisi(
        baslatmaIslemi: widget.baslatmaIslemi,
        anaSayfaOlustur: _oturumKapisi,
      ),
    );
  }
}

class _BaslangicKapisi extends StatefulWidget {
  const _BaslangicKapisi({
    required this.baslatmaIslemi,
    required this.anaSayfaOlustur,
  });

  final Future<UygulamaBaslatmaSonucu> baslatmaIslemi;
  final Widget Function(bool firebaseHazir) anaSayfaOlustur;

  @override
  State<_BaslangicKapisi> createState() => _BaslangicKapisiState();
}

class _BaslangicKapisiState extends State<_BaslangicKapisi> {
  static const Duration _enKisaGosterim = Duration(milliseconds: 1000);

  UygulamaBaslatmaSonucu? _sonuc;

  @override
  void initState() {
    super.initState();
    _hazirla();
  }

  Future<void> _hazirla() async {
    final Future<void> enAzSure = Future<void>.delayed(_enKisaGosterim);

    UygulamaBaslatmaSonucu sonuc;
    try {
      // 🔒 GÜVENLİK AĞI: Başlatma herhangi bir nedenle (ağ, SDK takılması)
      // 25 saniyede tamamlanmazsa uygulama yine de açılır.
      sonuc = await widget.baslatmaIslemi.timeout(
        const Duration(seconds: 25),
        onTimeout: () {
          debugPrint(
              'Uygulama başlatma zaman aşımına uğradı; devam ediliyor.');
          return const UygulamaBaslatmaSonucu(firebaseHazir: false);
        },
      );
    } catch (e) {
      debugPrint('Uygulama başlatma hatası: $e');
      sonuc = const UygulamaBaslatmaSonucu(firebaseHazir: false);
    }

    await enAzSure;
    if (!mounted) return;

    setState(() => _sonuc = sonuc);
  }

  @override
  Widget build(BuildContext context) {
    final sonuc = _sonuc;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 450),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      layoutBuilder: (mevcut, onceki) => Stack(
        fit: StackFit.expand,
        children: [...onceki, if (mevcut != null) mevcut],
      ),
      child: sonuc == null
          ? const YuklemeEkrani(key: ValueKey('yukleme'))
          : KeyedSubtree(
              key: const ValueKey('uygulama'),
              child: widget.anaSayfaOlustur(sonuc.firebaseHazir),
            ),
    );
  }
}

class _SayfaIzleyici extends StatefulWidget {
  const _SayfaIzleyici({required this.ad, required this.child});

  final String ad;
  final Widget child;

  @override
  State<_SayfaIzleyici> createState() => _SayfaIzleyiciState();
}

class _SayfaIzleyiciState extends State<_SayfaIzleyici> {
  @override
  void initState() {
    super.initState();
    AnalyticsServisi().ekranGoruntule(widget.ad);
  }

  @override
  void didUpdateWidget(covariant _SayfaIzleyici eskiWidget) {
    super.didUpdateWidget(eskiWidget);
    if (eskiWidget.ad != widget.ad) {
      AnalyticsServisi().ekranGoruntule(widget.ad);
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}