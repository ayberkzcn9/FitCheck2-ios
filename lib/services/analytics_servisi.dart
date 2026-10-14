import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Firebase Analytics sarmalayıcısı.
///
/// Analitik yalnızca Firebase'in yapılandırıldığı platformlarda (Android/iOS)
/// çalışır. [firebaseHazir] `false` iken (web/masaüstü) veya bir çağrı hata
/// verdiğinde olaylar sessizce yok sayılır; uygulama hiçbir koşulda analitik
/// yüzünden çökmez.
///
/// Kullanıcı [veriToplamaIzniAyarla] ile veri toplamayı kapatabilir; tercih
/// cihazda saklanır ve açılışta [izniYukle] ile geri yüklenir.
///
/// Ekran ve olay adları, raporlarda tutarlı görünmesi için İngilizce
/// `snake_case` olarak ve dile göre değişmeyecek şekilde sabitlenmiştir.
class AnalyticsServisi {
  static final AnalyticsServisi _instance = AnalyticsServisi._internal();
  factory AnalyticsServisi() => _instance;
  AnalyticsServisi._internal();

  /// `main()` içinde Firebase başarıyla başlatıldıysa `true` yapılır.
  static bool firebaseHazir = false;

  /// Kullanıcı veri toplamayı reddettiyse `false` yapılır.
  static bool veriToplamaIzinli = true;

  static bool get aktif => firebaseHazir && veriToplamaIzinli;

  /// Veri toplama tercihinin saklandığı `SharedPreferences` anahtarı.
  static const String izinAnahtari = 'analitik_veri_toplama_izni';

  // Sabit ekran adları
  static const String ekranOnboarding = 'onboarding';
  static const String ekranGiris = 'login_screen';
  static const String ekranAyarlar = 'settings';
  static const String ekranPremium = 'premium_screen';

  /// Ana ekran sekmelerinin adları (`_seciliSekme` sırasıyla aynı).
  static const List<String> sekmeAdlari = <String>[
    'tab_wardrobe',
    'tab_weekly_plan',
    'tab_now',
    'tab_design',
    'tab_profile',
    'tab_combo_game',
  ];

  String? _sonKullaniciKimligi;
  bool _kimlikAyarlanmis = false;

  /// Cihazda saklanan veri toplama tercihini yükler.
  ///
  /// [baslat] çağrılmadan önce çalıştırılmalıdır; aksi halde kullanıcının
  /// kapatma tercihi ilk açılışta yok sayılır.
  Future<void> izniYukle() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      veriToplamaIzinli = prefs.getBool(izinAnahtari) ?? true;
    } catch (e) {
      debugPrint('Analytics izni okunamadı: $e');
      veriToplamaIzinli = true;
    }
  }

  /// Analitik toplamayı başlatır ve kayıtlı izin durumunu uygular.
  Future<void> baslat() async {
    if (!firebaseHazir) return;
    await _koru(() async {
      await FirebaseAnalytics.instance
          .setAnalyticsCollectionEnabled(veriToplamaIzinli);
    }, 'baslat');
  }

  /// Ekran görüntüleme olayı gönderir.
  Future<void> ekranGoruntule(String ekranAdi) async {
    if (!aktif) return;
    await _koru(() async {
      await FirebaseAnalytics.instance.logScreenView(
        screenName: ekranAdi,
        screenClass: ekranAdi,
      );
    }, 'ekranGoruntule($ekranAdi)');
  }

  /// Özel olay gönderir. [parametreler] değerleri `String`, `int` veya
  /// `double` olmalıdır.
  Future<void> olay(String ad, [Map<String, Object>? parametreler]) async {
    if (!aktif) return;
    await _koru(() async {
      await FirebaseAnalytics.instance.logEvent(
        name: ad,
        parameters: parametreler,
      );
    }, 'olay($ad)');
  }

  /// Kullanıcı kimliği atar; `null` gönderilirse kimlik temizlenir.
  /// Aynı kimlik tekrar gönderildiğinde gereksiz çağrı yapılmaz.
  Future<void> kullaniciKimligiAyarla(String? kimlik) async {
    if (!aktif) return;
    if (_kimlikAyarlanmis && _sonKullaniciKimligi == kimlik) return;
    _sonKullaniciKimligi = kimlik;
    _kimlikAyarlanmis = true;
    await _koru(() async {
      await FirebaseAnalytics.instance.setUserId(id: kimlik);
    }, 'kullaniciKimligiAyarla');
  }

  /// Kullanıcı özelliği atar.
  Future<void> ozellikAyarla(String ad, String? deger) async {
    if (!aktif) return;
    await _koru(() async {
      await FirebaseAnalytics.instance.setUserProperty(name: ad, value: deger);
    }, 'ozellikAyarla($ad)');
  }

  /// Kullanıcının veri toplama iznini uygular ve cihazda saklar.
  ///
  /// İzin kaldırıldığında toplama durdurulur ve cihazda biriken analitik
  /// veriler sıfırlanır; izin geri verildiğinde saklanan kullanıcı kimliği
  /// yeniden atanır.
  Future<void> veriToplamaIzniAyarla(bool izinli) async {
    veriToplamaIzinli = izinli;
    await _izniKaydet(izinli);
    if (!firebaseHazir) return;
    await _koru(() async {
      await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(izinli);
      if (izinli) {
        if (_sonKullaniciKimligi != null) {
          await FirebaseAnalytics.instance.setUserId(id: _sonKullaniciKimligi);
          _kimlikAyarlanmis = true;
        }
      } else {
        await FirebaseAnalytics.instance.resetAnalyticsData();
        _kimlikAyarlanmis = false;
      }
    }, 'veriToplamaIzniAyarla($izinli)');
  }

  Future<void> _izniKaydet(bool izinli) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(izinAnahtari, izinli);
    } catch (e) {
      debugPrint('Analytics izni kaydedilemedi: $e');
    }
  }

  Future<void> _koru(Future<void> Function() islem, String etiket) async {
    try {
      await islem();
    } catch (e) {
      debugPrint('Analytics "$etiket" gönderilemedi: $e');
    }
  }
}

/// Adlandırılmış rotaları otomatik olarak `screen_view` olayına çevirir.
///
/// Yalnızca `RouteSettings(name: ...)` ile adlandırılmış rotalar kaydedilir;
/// adsız rotalar ve kök rota (`/`) yok sayılır. Ekranın kimliği
/// [AnalyticsServisi] içindeki sabit adlarla verilmelidir.
class AnalyticsNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _kaydet(route);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute != null) _kaydet(previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null) _kaydet(newRoute);
  }

  void _kaydet(Route<dynamic> route) {
    final ad = route.settings.name;
    if (ad == null || ad.isEmpty || ad == '/') return;
    AnalyticsServisi().ekranGoruntule(ad);
  }
}
