import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'l10n/app_localizations.dart';

// EKRANLAR
import 'screens/ana_ekran.dart';
import 'screens/onboarding_ekrani.dart';
import 'screens/giris_ekrani.dart';

// BİLEŞENLER
import 'widgets/yukleme_ekrani.dart';
import 'widgets/modals/ai_onay_modal.dart';

// SERVİSLER
import 'services/ai_service.dart';
import 'services/analytics_servisi.dart';
import 'services/auth_servisi.dart';
import 'services/bildirim_servisi.dart';
import 'services/bildirim_zamanlayici.dart';
import 'services/fcm_service.dart';
import 'services/reklam_servisi.dart';
import 'services/satin_alma_servisi.dart';
import '../theme/design_tokens.dart';
import 'theme/app_tema.dart';

final GlobalKey<NavigatorState> fitcheckNavigatorKey =
    GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AiService.onayIste = () async {
    final context = fitcheckNavigatorKey.currentContext;
    if (context == null) return false;
    return AiOnayModal.goster(context);
  };

  await dotenv.load(fileName: '.env');

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
    await AnalyticsServisi().izniYukle().timeout(const Duration(seconds: 5));
    await AnalyticsServisi().baslat().timeout(const Duration(seconds: 8));
  } catch (e) {
    debugPrint('Analytics başlatma hatası: $e');
  }

  await ReklamServisi().premiumDurumunuYukle();

  // Abonelik: mağaza fiyatları/planları önceden yüklenir (paywall, ayarlar
  // kartı ve satın alma diyalogları gerçek fiyatı göstersin) ve yerelde premium
  // görünen aboneliğin hâlâ geçerli olduğu düzenli aralıkla doğrulanır.
  // Arayüzü bekletmemek için await edilmez; hata durumunda akış etkilenmez.
  if (SatinAlmaServisi.premiumSunuluyor) {
    unawaited(SatinAlmaServisi.ornek.baslat());
  }

  if (!kIsWeb && ReklamServisi.reklamlarEtkinMi) {
    // AdMob başlatma + ATT izni + ön yükleme tek yerde: ReklamServisi.
    // Abonelik iptalinde aynı metot yeniden tetiklenir.
    await ReklamServisi().reklamlariBaslat();
  }

  try {
    await BildirimServisi().init().timeout(const Duration(seconds: 10));
    final prefs = await SharedPreferences.getInstance();

    // Sabah + akşam serileri: haftalık plan varsa gövdede o günün gerçek
    // kombini yazar, bildirime dokununca ilgili sekme açılır.
    await BildirimZamanlayici.yenidenKur();

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
            item['id'] =
                '${DateTime.now().microsecondsSinceEpoch}_${Random().nextInt(999999999)}_${currentId.hashCode}';
            changed = true;
            debugPrint(
                '🔧 Gardırop ID çakışması düzeltildi: $currentId -> ${item['id']}');
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
            item['id'] =
                '${DateTime.now().microsecondsSinceEpoch}_${Random().nextInt(999999999)}_${currentId.hashCode}';
            changed = true;
            debugPrint(
                '🔧 Favori ID çakışması düzeltildi: $currentId -> ${item['id']}');
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
            item['id'] =
                '${DateTime.now().microsecondsSinceEpoch}_${Random().nextInt(999999999)}_${currentId.hashCode}';
            changed = true;
            debugPrint(
                '🔧 Geçmiş ID çakışması düzeltildi: $currentId -> ${item['id']}');
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

  static KombinDanismaniAppState? maybeOf(BuildContext context) =>
      context.findAncestorStateOfType<KombinDanismaniAppState>();

  static KombinDanismaniAppState of(BuildContext context) {
    final state = maybeOf(context);
    assert(state != null,
        'KombinDanismaniAppState bulunamadı. Widget ağacında KombinDanismaniApp altında olmalı.');
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
    final brightness = PlatformDispatcher.instance.platformBrightness;
    return brightness == Brightness.dark;
  }

  Locale? get currentLocale => _locale;

  ColorScheme _buildColorScheme(Brightness brightness) =>
      AppTema.renkSemasi(brightness);

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
      navigatorKey: fitcheckNavigatorKey,
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
        return ColoredBox(
          color: Theme.of(context).colorScheme.surface,
          child: child ?? const SizedBox.expand(),
        );
      },
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: lightColorScheme,
        textTheme: Typography.material2021().black.apply(
              bodyColor: lightColorScheme.onSurface,
              displayColor: lightColorScheme.onSurface,
            ),
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
        scaffoldBackgroundColor: lightColorScheme.surface,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: lightColorScheme.onSurface,
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
            borderRadius: AppRadius.lgRadius,
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
        textTheme: Typography.material2021().white.apply(
              bodyColor: darkColorScheme.onSurface,
              displayColor: darkColorScheme.onSurface,
            ),
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
        scaffoldBackgroundColor: darkColorScheme.surface,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: darkColorScheme.onSurface,
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
            borderRadius: AppRadius.lgRadius,
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
          debugPrint('Uygulama başlatma zaman aşımına uğradı; devam ediliyor.');
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
      duration: AppMotion.orta,
      switchInCurve: AppMotion.giris,
      switchOutCurve: AppMotion.cikis,
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
