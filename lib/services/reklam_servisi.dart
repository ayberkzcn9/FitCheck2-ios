import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';
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
  static const int reklamOduluKredi = 2;
  static const String adminKuponKodu = 'FITCHECK-ADMIN-2026';

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
    final bool premium = prefs.getBool('reklamsiz_premium') ?? false;
    final bool admin = prefs.getBool('fitcheck_admin_modu') ?? false;
    // Premium ya da kuponla sınırsız (admin) kullanıcıya reklam gösterilmez.
    reklamlarEtkinMi = !(premium || admin);
  }

  Future<void> reklamlariKapat() async {
    reklamlarEtkinMi = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('reklamsiz_premium', true);
  }

  Future<bool> isAdmin() async {
    if (_isAdminCache != null) return _isAdminCache!;
    final prefs = await SharedPreferences.getInstance();
    final val = prefs.getBool('fitcheck_admin_modu') ?? false;
    _isAdminCache = val;
    return val;
  }

  // --- HAK VE LİMİT METODLARI (TAMAMI SINIRSIZ) ---

  Future<int> kalanHakGetir() async {
    if (await isAdmin()) return 999999;
    if (!reklamlarEtkinMi) return 999999;
    if (_kalanHakCache != null) return _kalanHakCache!;
    final prefs = await SharedPreferences.getInstance();
    final bugun = DateTime.now().toIso8601String().substring(0, 10);
    if (prefs.getString('reklam_hak_tarihi') != bugun) {
      await prefs.setString('reklam_hak_tarihi', bugun);
      await prefs.setInt('reklam_kalan_hak', ucretsizGunlukHak);
      _guncelleKalanHakCache(ucretsizGunlukHak);
      return ucretsizGunlukHak;
    }
    final hak = prefs.getInt('reklam_kalan_hak') ?? ucretsizGunlukHak;
    _guncelleKalanHakCache(hak);
    return hak;
  }

  Future<void> hakDusur() async {
    if (await isAdmin()) return;
    if (!reklamlarEtkinMi) return;
    final prefs = await SharedPreferences.getInstance();
    final bugun = DateTime.now().toIso8601String().substring(0, 10);
    if (prefs.getString('reklam_hak_tarihi') != bugun) {
      await prefs.setString('reklam_hak_tarihi', bugun);
      await prefs.setInt('reklam_kalan_hak', ucretsizGunlukHak);
      _guncelleKalanHakCache(ucretsizGunlukHak);
    }
    final mevcut = _kalanHakCache ?? prefs.getInt('reklam_kalan_hak') ?? ucretsizGunlukHak;
    final yeni = (mevcut - 1).clamp(0, 999);
    await prefs.setInt('reklam_kalan_hak', yeni);
    _guncelleKalanHakCache(yeni);
  }

  Future<void> hakIadeEt() async {
    final prefs = await SharedPreferences.getInstance();
    final mevcut = _kalanHakCache ?? prefs.getInt('reklam_kalan_hak') ?? ucretsizGunlukHak;
    final yeni = mevcut + 1;
    await prefs.setInt('reklam_kalan_hak', yeni);
    _guncelleKalanHakCache(yeni);
  }

  Future<void> reklamIzleyerekHakEkle(int eklenecekHak) async {
    if (await isAdmin()) return;
    if (!reklamlarEtkinMi) return;
    final prefs = await SharedPreferences.getInstance();
    final bugun = DateTime.now().toIso8601String().substring(0, 10);
    if (prefs.getString('reklam_hak_tarihi') != bugun) {
      await prefs.setString('reklam_hak_tarihi', bugun);
      await prefs.setInt('reklam_kalan_hak', ucretsizGunlukHak);
      _guncelleKalanHakCache(ucretsizGunlukHak);
    }
    final mevcut = _kalanHakCache ?? prefs.getInt('reklam_kalan_hak') ?? ucretsizGunlukHak;
    final yeni = mevcut + eklenecekHak;
    await prefs.setInt('reklam_kalan_hak', yeni);
    _guncelleKalanHakCache(yeni);
  }

  Future<int> kuponKoduKullan(String kod) async {
    final temizKod = kod.trim().toUpperCase();
    if (temizKod != adminKuponKodu) return 0;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('fitcheck_admin_modu', true);
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
