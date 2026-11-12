import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'analytics_servisi.dart';

class ReklamServisi {
  static final ReklamServisi _instance = ReklamServisi._internal();
  factory ReklamServisi() => _instance;
  ReklamServisi._internal();

  static const int ucretsizGunlukHak = 3;
  static const int varsayilanKiyafetLimiti = 21;
  static const int reklamOduluSlot = 2;
  static bool reklamlarEtkinMi = true;

  /// iOS LANSMAN MODU — geri alınabilir tek anahtar.
  ///
  /// `true`: iOS'ta herkes sınırsız ve reklamsız kullanır; premium ekranı
  /// zaten kapalıdır ([SatinAlmaServisi.premiumSunuluyor]). Premium, limit ve
  /// reklam kodu silinmez, yalnızca devre dışı kalır. Android etkilenmez.
  ///
  /// Lansman bitince `false` yap ve ayrıca (izleme/ATT geri gelir):
  /// - pubspec.yaml: `app_tracking_transparency: ^2.0.7` paketini geri ekle,
  ///   [reklamlariBaslat] içindeki ATT çağrısını yorumdan çıkar.
  /// - ios/Runner/Info.plist ve *.lproj/InfoPlist.strings:
  ///   NSUserTrackingUsageDescription metnini geri ekle (git geçmişinde var).
  /// - ios/Runner/PrivacyInfo.xcprivacy: NSPrivacyTracking → true, DeviceID
  ///   girdisinde Tracking → true, NSPrivacyTrackingDomains geri.
  /// - App Store Connect > App Privacy: izleme (Device ID) yeniden işaretle.
  static const bool iosLansmanUcretsiz = true;

  static bool lansmanUcretsizKarari(TargetPlatform platform) =>
      iosLansmanUcretsiz && platform == TargetPlatform.iOS;

  static bool get lansmanUcretsizMi =>
      !kIsWeb && lansmanUcretsizKarari(defaultTargetPlatform);
  static const int reklamOduluKredi = 2;

  /// Yönetici kuponu kaynakta tutulmaz. Yalnızca geliştirme derlemesinde,
  /// `--dart-define=FITCHECK_ADMIN_KUPON=...` ile verilirse etkinleşir.
  static const String adminKuponKodu =
      String.fromEnvironment('FITCHECK_ADMIN_KUPON');
  static const String _adminAnahtari = 'fitcheck_admin_modu';

  /// Kupon yalnızca geliştirme derlemesinde ve kod tanımlıysa etkindir.
  static bool get kuponAktifMi =>
      kuponKarari(yayinModu: kReleaseMode, kod: adminKuponKodu);

  static bool kuponKarari({required bool yayinModu, required String kod}) =>
      !yayinModu && kod.isNotEmpty;

  /// Yönetici modu yalnızca geliştirme derlemesinde geçerlidir; yayın
  /// sürümünde daha önce etkinleştirilmiş bir kayıt da yok sayılır.
  static bool adminModuKarari({
    required bool yayinModu,
    required bool kayitliAdmin,
  }) =>
      !yayinModu && kayitliAdmin;

  static bool adminModuAcikMi(SharedPreferences prefs) => adminModuKarari(
        yayinModu: kReleaseMode,
        kayitliAdmin: prefs.getBool(_adminAnahtari) ?? false,
      );

  /// 🔧 ÖDÜLLÜ REKLAM AD UNIT ID (platforma göre)
  static const String _odulluReklamIdAndroid =
      'ca-app-pub-7826590886723969/6009484469';
  static const String _odulluReklamIdIos =
      'ca-app-pub-7826590886723969/5331389661';

  /// 🔧 GEÇİŞ (INTERSTITIAL) REKLAM AD UNIT ID (platforma göre)
  static const String _gecisReklamIdAndroid =
      'ca-app-pub-7826590886723969/7311218571';
  static const String _gecisReklamIdIos =
      'ca-app-pub-7826590886723969/8279232611';

  /// Aktif platforma göre ödüllü reklam birim kimliği.
  static String get _odulluReklamId =>
      Platform.isIOS ? _odulluReklamIdIos : _odulluReklamIdAndroid;

  /// Aktif platforma göre geçiş reklamı birim kimliği.
  static String get _gecisReklamId =>
      Platform.isIOS ? _gecisReklamIdIos : _gecisReklamIdAndroid;

  RewardedAd? _odulluReklam;
  bool _odulluReklamYukleniyor = false;

  InterstitialAd? _gecisReklam;
  bool _gecisReklamYukleniyor = false;
  DateTime? _sonGecisReklamZamani;

  /// İki geçiş reklamı arasındaki asgari süre (kullanıcıyı rahatsız etmemek
  /// ve Google politikalarına uymak için).
  static const Duration _gecisReklamAraligi = Duration(seconds: 75);

  static int? _kalanHakCache;
  static bool? _isAdminCache;

  /// AdMob SDK'sının bir kez başlatıldığını izler.
  bool _reklamSdkBaslatildi = false;

  // Global hak sayacı dinleyicisi (instance-based for proper disposal)
  final ValueNotifier<int> kalanHakNotifier = ValueNotifier<int>(3);

  void _guncelleKalanHakCache(int yeni) {
    _kalanHakCache = yeni;
    kalanHakNotifier.value = yeni;
  }

  /// Call this when app is shutting down to clean up resources.
  void dispose() {
    kalanHakNotifier.dispose();
    _odulluReklam?.dispose();
    _gecisReklam?.dispose();
  }

  // --- KULLANICI & ADMIN KONTROLLERİ ---

  Future<void> kullaniciEmailKaydet(String email) async {}

  Future<void> premiumDurumunuYukle() async {
    final prefs = await SharedPreferences.getInstance();
    final uid = AnalyticsServisi.firebaseHazir
        ? FirebaseAuth.instance.currentUser?.uid
        : null;
    final serverTs = prefs.getInt('premium_sunucu_dogrulama_ts');
    final serverDogrulamasiGecerli =
        prefs.getBool('premium_sunucu_dogrulandi') == true &&
            uid != null &&
            prefs.getString('premium_sahip_uid') == uid &&
            serverTs != null &&
            DateTime.now().difference(
                  DateTime.fromMillisecondsSinceEpoch(serverTs),
                ) <=
                const Duration(hours: 24);
    final bool premium =
        prefs.getBool('reklamsiz_premium') == true && serverDogrulamasiGecerli;
    final bool admin = adminModuAcikMi(prefs);
    // Premium ya da kuponla sınırsız (admin) kullanıcıya reklam gösterilmez.
    reklamlarEtkinMi = !(premium || admin || lansmanUcretsizMi);
  }

  Future<void> reklamlariKapat() async {
    reklamlarEtkinMi = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('reklamsiz_premium', true);
  }

  /// Aboneliği sona ermiş/iptal edilmiş kullanıcıda reklamları yeniden devreye
  /// alır. Reklam SDK'sı da burada yeniden başlatılır; böylece iptal aynı
  /// oturumda fark edilse bile reklamlar çalışır.
  ///
  /// Yönetici/kupon erişimi olan kullanıcıda reklamlar kapalı kalır.
  Future<void> reklamlariAc() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('reklamsiz_premium', false);
    final bool admin = adminModuAcikMi(prefs);
    reklamlarEtkinMi = !(admin || lansmanUcretsizMi);
    if (reklamlarEtkinMi) unawaited(reklamlariBaslat());
  }

  /// AdMob SDK'sını başlatır ve reklamları önceden yükler.
  ///
  /// Uygulama açılışında çağrılır. Reklamlar kapalıysa (premium/kupon) hiç
  /// başlatılmaz; erişim sonradan kapanırsa [reklamlariAc] üzerinden yeniden
  /// tetiklenir. Tekrar çağrılması güvenlidir.
  Future<void> reklamlariBaslat() async {
    if (!reklamlarEtkinMi) return;
    if (_reklamSdkBaslatildi) return;
    _reklamSdkBaslatildi = true;

    try {
      // iOS izleme izni (ATT) lansman modunda kaldırıldı; bkz.
      // [iosLansmanUcretsiz]. Reklamlar iOS'a dönünce buraya geri eklenir:
      //   if (Platform.isIOS) {
      //     final s = await AppTrackingTransparency.trackingAuthorizationStatus;
      //     if (s == TrackingStatus.notDetermined) {
      //       await Future.delayed(AppMotion.uzun);
      //       await AppTrackingTransparency.requestTrackingAuthorization();
      //     }
      //   }
      // ATT olmadan AdMob kişiselleştirilmemiş reklam gösterir.

      // AdMob başlatma ağ gerektirebilir; takılmayı önlemek için zaman aşımı.
      await MobileAds.instance
          .initialize()
          .timeout(const Duration(seconds: 12));
      // Ön yükleme: reklamlar hazır bekler, gerektiğinde anında gösterilir.
      gecisReklamiYukle();
      odulluReklamYukle();
    } catch (e) {
      debugPrint('AdMob başlatma hatası: $e');
    }
  }

  Future<bool> isAdmin() async {
    if (_isAdminCache != null) return _isAdminCache!;
    final prefs = await SharedPreferences.getInstance();
    final val = adminModuAcikMi(prefs);
    _isAdminCache = val;
    return val;
  }

  // --- HAK VE LİMİT METODLARI (TAMAMI SINIRSIZ) ---

  // Günlük hak ile reklamla kazanılan hak ayrı sayaçlarda tutulur. Böylece
  // gece yarısı günlük hak yenilenirken reklamla kazanılan haklar silinmez.
  static const String _kalanHakAnahtari = 'reklam_kalan_hak';
  static const String _gunlukHakAnahtari = 'reklam_gunluk_hak';
  static const String _ekstraHakAnahtari = 'reklam_ekstra_hak';
  static const String _hakTarihiAnahtari = 'reklam_hak_tarihi';

  static String _bugun() => DateTime.now().toIso8601String().substring(0, 10);

  /// Testlerde önbelleği temizlemek için.
  @visibleForTesting
  static void onbellegiSifirla() {
    _kalanHakCache = null;
    _isAdminCache = null;
  }

  /// Eski tek sayaçlı modelden iki sayaçlı modele geçer.
  ///
  /// Eski toplam korunur; günlük/ekstra ayrımı bilinemediği için tüm bakiye
  /// ekstra sayılır. Böylece hiçbir kazanılmış hak silinmez. İlk geçişte
  /// günlük 3 hak bir kez fazla verilebilir; bu, hak kaybından yeğdir.
  Future<void> _hakModeliniHazirla(SharedPreferences prefs) async {
    if (prefs.containsKey(_gunlukHakAnahtari) &&
        prefs.containsKey(_ekstraHakAnahtari)) {
      return;
    }
    final eskiSayacVar = prefs.containsKey(_kalanHakAnahtari);
    final toplam = eskiSayacVar ? (prefs.getInt(_kalanHakAnahtari) ?? 0) : 0;
    await prefs.setInt(_gunlukHakAnahtari, 0);
    await prefs.setInt(_ekstraHakAnahtari, toplam.clamp(0, 999999));
  }

  /// Gün değiştiyse günlük hakkı 3'e tamamlar; ekstra haklara dokunmaz.
  Future<int> _haklariYenile(SharedPreferences prefs) async {
    await _hakModeliniHazirla(prefs);
    final bugun = _bugun();
    if (prefs.getString(_hakTarihiAnahtari) != bugun) {
      await prefs.setString(_hakTarihiAnahtari, bugun);
      await prefs.setInt(_gunlukHakAnahtari, ucretsizGunlukHak);
    }
    return _toplamHak(prefs);
  }

  Future<int> _toplamHak(SharedPreferences prefs) async {
    final gunluk = prefs.getInt(_gunlukHakAnahtari) ?? ucretsizGunlukHak;
    final ekstra = prefs.getInt(_ekstraHakAnahtari) ?? 0;
    final toplam = gunluk + ekstra;
    // Eski anahtar, geri uyumluluk için toplamla güncellenir.
    await prefs.setInt(_kalanHakAnahtari, toplam);
    _guncelleKalanHakCache(toplam);
    return toplam;
  }

  Future<int> kalanHakGetir() async {
    if (await isAdmin()) return 999999;
    if (!reklamlarEtkinMi) return 999999;
    final prefs = await SharedPreferences.getInstance();
    await _hakModeliniHazirla(prefs);
    final bugun = _bugun();
    // Tarih önbellekten önce kontrol edilir: uygulama gece yarısını aşarak
    // açık kalırsa dünün değeri yeni günde görünmesin.
    if (prefs.getString(_hakTarihiAnahtari) != bugun) {
      await prefs.setString(_hakTarihiAnahtari, bugun);
      await prefs.setInt(_gunlukHakAnahtari, ucretsizGunlukHak);
      _kalanHakCache = null;
    }
    if (_kalanHakCache != null) return _kalanHakCache!;
    return _toplamHak(prefs);
  }

  Future<void> hakDusur() async {
    if (await isAdmin()) return;
    if (!reklamlarEtkinMi) return;
    final prefs = await SharedPreferences.getInstance();
    await _haklariYenile(prefs);

    // Önce günlük hak tüketilir; reklamla kazanılan haklar en sona kalır.
    final gunluk = prefs.getInt(_gunlukHakAnahtari) ?? 0;
    final ekstra = prefs.getInt(_ekstraHakAnahtari) ?? 0;
    if (gunluk > 0) {
      await prefs.setInt(_gunlukHakAnahtari, gunluk - 1);
    } else if (ekstra > 0) {
      await prefs.setInt(_ekstraHakAnahtari, ekstra - 1);
    }
    await _toplamHak(prefs);
  }

  Future<void> hakIadeEt() async {
    final prefs = await SharedPreferences.getInstance();
    await _haklariYenile(prefs);
    final ekstra = prefs.getInt(_ekstraHakAnahtari) ?? 0;
    // İade edilen hak süresizdir; günlük sayaçla karışmaz.
    await prefs.setInt(_ekstraHakAnahtari, ekstra + 1);
    await _toplamHak(prefs);
  }

  Future<void> reklamIzleyerekHakEkle(int eklenecekHak) async {
    if (await isAdmin()) return;
    if (!reklamlarEtkinMi) return;
    final prefs = await SharedPreferences.getInstance();
    await _haklariYenile(prefs);
    final ekstra = prefs.getInt(_ekstraHakAnahtari) ?? 0;
    // Reklam ödülü günlük hakka değil, süresiz ekstra hakka eklenir.
    await prefs.setInt(_ekstraHakAnahtari, ekstra + eklenecekHak);
    await _toplamHak(prefs);
  }

  Future<int> kuponKoduKullan(String kod) async {
    if (!kuponAktifMi) return 0;
    final temizKod = kod.trim().toUpperCase();
    if (temizKod != adminKuponKodu.toUpperCase()) return 0;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_adminAnahtari, true);
    _isAdminCache = true;
    // Kuponla sınırsız olan (admin) kullanıcıya da reklam gösterilmez.
    reklamlarEtkinMi = false;
    _gecisReklam?.dispose();
    _gecisReklam = null;
    _odulluReklam?.dispose();
    _odulluReklam = null;
    return 1;
  }

  Future<int> maxKiyafetLimitiniGetir() async {
    if (await isAdmin()) return 999999;
    if (!reklamlarEtkinMi) return 999999;
    final prefs = await SharedPreferences.getInstance();
    return varsayilanKiyafetLimiti +
        (prefs.getInt('ekstra_kiyafet_limiti') ?? 0);
  }

  Future<void> reklamIzleyerekKiyafetLimitiEkle(int eklenecekLimit) async {
    final prefs = await SharedPreferences.getInstance();
    final mevcut = prefs.getInt('ekstra_kiyafet_limiti') ?? 0;
    await prefs.setInt('ekstra_kiyafet_limiti', mevcut + eklenecekLimit);
  }

  // --- PASİF REKLAM TETİKLEYİCİLERİ ---

  void appOpenReklamYukle() {}

  void appOpenReklamYukleVeGoster() {}

  void gecisReklamiYukle() {
    if (!reklamlarEtkinMi) return;
    if (!Platform.isAndroid && !Platform.isIOS) return;
    if (_gecisReklamYukleniyor || _gecisReklam != null) return;

    _gecisReklamYukleniyor = true;
    InterstitialAd.load(
      adUnitId: _gecisReklamId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _gecisReklamYukleniyor = false;
          _gecisReklam = ad;
        },
        onAdFailedToLoad: (error) {
          _gecisReklamYukleniyor = false;
          _gecisReklam = null;
          debugPrint('Geçiş reklamı yüklenemedi: $error');
        },
      ),
    );
  }

  Future<void> gecisReklamiGoster({required VoidCallback onAdClosed}) async {
    // Premium/admin kullanıcıya reklam gösterilmez; akış kesintisiz devam eder.
    if (!reklamlarEtkinMi) {
      onAdClosed();
      return;
    }

    // Politika: günlük kombin hakkı henüz bitmemiş kullanıcıya geçiş reklamı
    // gösterilmez. Böylece ücretsiz kullanıcı deneyimi korunur; reklam, hakkını
    // tüketen yoğun kullanıcıya yönelir (hem gelir hem premium dönüşümü için).
    final int kalanHak = await kalanHakGetir();
    if (kalanHak > 0) {
      onAdClosed();
      return;
    }

    final ad = _gecisReklam;
    if (ad == null) {
      // Reklam hazır değilse akışı beklemeden sürdür ve arka planda yükle.
      gecisReklamiYukle();
      onAdClosed();
      return;
    }

    // Sıklık sınırı: çok sık gösterme.
    final now = DateTime.now();
    if (_sonGecisReklamZamani != null &&
        now.difference(_sonGecisReklamZamani!) < _gecisReklamAraligi) {
      onAdClosed();
      return;
    }
    _sonGecisReklamZamani = now;

    _gecisReklam = null;
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        gecisReklamiYukle();
        onAdClosed();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('Geçiş reklamı gösterilemedi: $error');
        ad.dispose();
        gecisReklamiYukle();
        onAdClosed();
      },
    );
    ad.show();
  }

  void onboardingSonrasiZamanliReklamGoster({int saniye = 20}) {}

  void odulluReklamYukle() {
    if (!reklamlarEtkinMi) return;
    if (!Platform.isAndroid && !Platform.isIOS) return;
    if (_odulluReklamYukleniyor) return;

    _odulluReklamYukleniyor = true;
    RewardedAd.load(
      adUnitId: _odulluReklamId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _odulluReklamYukleniyor = false;
          _odulluReklam = ad;
        },
        onAdFailedToLoad: (error) {
          _odulluReklamYukleniyor = false;
          _odulluReklam = null;
          debugPrint('Ödüllü reklam yüklenemedi: $error');
        },
      ),
    );
  }

  void odulluReklamGoster({
    required BuildContext context,
    required Function(dynamic reward) onReward,
    VoidCallback? onAdNotReady,
  }) {
    if (!reklamlarEtkinMi) {
      onAdNotReady?.call();
      return;
    }
    final ad = _odulluReklam;
    if (ad == null) {
      onAdNotReady?.call();
      odulluReklamYukle();
      return;
    }

    _odulluReklam = null;
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        odulluReklamYukle();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('Ödüllü reklam gösterilemedi: $error');
        ad.dispose();
        odulluReklamYukle();
        onAdNotReady?.call();
      },
    );
    ad.show(
      onUserEarnedReward: (ad, reward) {
        AnalyticsServisi().olay('rewarded_ad_watched');
        onReward(reward);
      },
    );
  }
}
