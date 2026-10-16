import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'reklam_servisi.dart';
import 'analytics_servisi.dart';

/// Kullanıcının seçebileceği abonelik planı.
enum PremiumPlan { aylik, yillik }

class SatinAlmaServisi extends ChangeNotifier {
  SatinAlmaServisi._();

  /// Uygulama genelinde tek örnek. Satın alma dinleyicisi ekran kapandığında
  /// da açık kalır; böylece tamamlanan ya da geri yüklenen satın alma kaybolmaz.
  static final SatinAlmaServisi ornek = SatinAlmaServisi._();

  // --- ÜRÜN KİMLİKLERİ ---
  // Play Console > Monetize > Abonelikler ve App Store Connect > Abonelikler
  // altındaki kimliklerle birebir aynı olmalıdır; uyuşmazsa ürün sorgusu boş
  // döner ve "abone ol" düğmesi pasif kalır.
  static const String aylikUrunKimligi = 'fitcheck_premium_monthly';
  static const String yillikUrunKimligi = 'fitcheck_premium_yearly';

  /// Geriye dönük uyumluluk için aylık ürün kimliğinin eski adı.
  static const String reklamsizUrunKimligi = aylikUrunKimligi;

  // Mağaza fiyatı okunana kadar gösterilen varsayılan fiyatlar.
  static const String varsayilanFiyat = '49,90 TL';
  static const String varsayilanYillikFiyat = '399,90 TL';

  /// Ücretsiz deneme (introductory offer) gün sayısı.
  ///
  /// Play Console > Abonelik > Teklifler ve App Store Connect > Abonelik >
  /// Introductory Offer altında tanımlı süreyle **birebir aynı** olmalıdır.
  /// Deneme tanımlamadıysan 0 yap: aksi halde uygulama deneme vaat edip ödeme
  /// ekranı deneme göstermez ve mağaza politikası ihlali oluşur.
  ///
  /// Android'de ayrıca mağazanın 0 fiyatlı bir teklif döndürmesi doğrulanır;
  /// yani yanlışlıkla açık bırakılsa bile deneme yoksa rozet gösterilmez.
  static const int denemeGunSayisi = 7;

  // Mağazadan gelen metinler dışındaki hata durumları; ekran bunları
  // yerelleştirilmiş mesaja çevirir.
  static const String hataSatinAlmaBaslatilamadi = 'satin_alma_baslatilamadi';
  static const String hataSatinAlmaBasarisiz = 'satin_alma_basarisiz';

  final InAppPurchase _magaza = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _satinalmaDinleyicisi;

  /// Aynı ürün için mağaza birden fazla teklif döndürebiliyor (Android'de her
  /// temel plan ve teklif ayrı bir kayıt olur). Satın alma için uygun olan
  /// teklif, gösterim için ise gerçek (0 olmayan) fiyat ayrı ayrı seçilir.
  List<ProductDetails> _aylikAdaylar = <ProductDetails>[];
  List<ProductDetails> _yillikAdaylar = <ProductDetails>[];

  PremiumPlan seciliPlan = PremiumPlan.yillik;

  bool magazaHazir = false;
  bool yukleniyor = false;
  bool hazirlaniyor = true;
  bool premiumAktif = false;
  String? hata;

  /// Ürünün/mağazanın neden hazır olmadığını gösteren ham teknik ayrıntı.
  String? tani;

  bool _sorguSuruyor = false;

  // --- DURUM SORGULARI ---

  bool get yillikVar => _yillikAdaylar.isNotEmpty;
  bool get aylikVar => _aylikAdaylar.isNotEmpty;

  /// Satın alma için kullanılacak ürün (seçili plana göre).
  ProductDetails? get seciliUrun {
    if (seciliPlan == PremiumPlan.yillik) {
      return yillikUrun ?? aylikUrun;
    }
    return aylikUrun ?? yillikUrun;
  }

  /// Satın alma için tercih edilen aylık teklif (deneme varsa deneme teklifi).
  ProductDetails? get aylikUrun =>
      denemeGunSayisi > 0 ? (_aylikDenemeTeklifi ?? _aylikNormalTeklif) : _aylikNormalTeklif;

  /// Satın alma için tercih edilen yıllık teklif (deneme varsa deneme teklifi).
  ProductDetails? get yillikUrun =>
      denemeGunSayisi > 0 ? (_yillikDenemeTeklifi ?? _yillikNormalTeklif) : _yillikNormalTeklif;

  ProductDetails? get _aylikDenemeTeklifi => _ilkUygunTeklif(_aylikAdaylar, 0);
  ProductDetails? get _yillikDenemeTeklifi => _ilkUygunTeklif(_yillikAdaylar, 0);
  ProductDetails? get _aylikNormalTeklif => _ilkUygunTeklif(_aylikAdaylar, 1);
  ProductDetails? get _yillikNormalTeklif => _ilkUygunTeklif(_yillikAdaylar, 1);

  /// Ekranda gösterilecek aylık fiyat (deneme teklifinin "0 / Ücretsiz"
  /// fiyatı yerine gerçek fiyat; hiç yoksa varsayılan).
  String get aylikFiyat => _fiyatMetni(_aylikAdaylar, varsayilanFiyat);

  /// Ekranda gösterilecek yıllık fiyat.
  String get yillikFiyat => _fiyatMetni(_yillikAdaylar, varsayilanYillikFiyat);

  /// Ücretsiz deneme gerçekten sunuluyor mu?
  ///
  /// Android'de mağaza 0 fiyatlı teklif döndürmüyorsa deneme yoktur; rozet
  /// gösterilmez. iOS'ta bu paket deneme bilgisini paylaşmadığı için tanıma
  /// güvenilir.
  bool get denemeSunuluyor {
    if (denemeGunSayisi <= 0) return false;
    if (Platform.isAndroid) {
      return _denemeVar(_aylikAdaylar) || _denemeVar(_yillikAdaylar);
    }
    return true;
  }

  /// Seçili planın deneme sunup sunmadığı (plan kartındaki rozet için).
  bool planDenemesiVar(PremiumPlan plan) {
    if (denemeGunSayisi <= 0) return false;
    if (plan == PremiumPlan.yillik) {
      if (_yillikAdaylar.isEmpty) return false;
      return Platform.isAndroid ? _denemeVar(_yillikAdaylar) : true;
    }
    if (_aylikAdaylar.isEmpty) return false;
    return Platform.isAndroid ? _denemeVar(_aylikAdaylar) : true;
  }

  /// Yıllık planın aylık ödemeye göre yüzde tasarrufu; hesaplanamazsa 0.
  int get yillikTasarrufYuzde {
    final aylik = _gercekFiyat(_aylikAdaylar);
    final yillik = _gercekFiyat(_yillikAdaylar);
    if (aylik == null || yillik == null) return 0;
    if (aylik.currencyCode != yillik.currencyCode) return 0;
    final tamYil = aylik.rawPrice * 12;
    if (tamYil <= 0 || yillik.rawPrice <= 0) return 0;
    if (yillik.rawPrice >= tamYil) return 0;
    return (((tamYil - yillik.rawPrice) / tamYil) * 100).round();
  }

  // --- AKIŞ ---

  Future<void> baslat() async {
    if (_sorguSuruyor) return;
    _sorguSuruyor = true;
    hazirlaniyor = true;
    hata = null;
    tani = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      premiumAktif = prefs.getBool('reklamsiz_premium') ?? false;
      if (premiumAktif) {
        await ReklamServisi().reklamlariKapat();
      }

      _satinalmaDinleyicisi ??= _magaza.purchaseStream.listen(
        _satinalmalariIsle,
        onError: (Object error) {
          hata = error.toString();
          yukleniyor = false;
          notifyListeners();
        },
      );

      await _urunleriSorgula();
    } finally {
      hazirlaniyor = false;
      _sorguSuruyor = false;
      notifyListeners();
    }
  }

  Future<void> _urunleriSorgula() async {
    _aylikAdaylar = <ProductDetails>[];
    _yillikAdaylar = <ProductDetails>[];

    try {
      magazaHazir = await _magaza.isAvailable();
    } catch (e) {
      // Ödeme altyapısı olmayan platformlarda (masaüstü, web) hata verir.
      magazaHazir = false;
      tani = e.toString();
    }
    debugPrint('[SatinAlma] magazaHazir=$magazaHazir');
    if (!magazaHazir) return;

    try {
      final response = await _magaza.queryProductDetails(
        {aylikUrunKimligi, yillikUrunKimligi},
      );
      hata = response.error?.message;
      if (response.notFoundIDs.isNotEmpty) {
        tani = 'notFoundIDs: ${response.notFoundIDs.join(', ')}';
      }
      _aylikAdaylar = response.productDetails
          .where((u) => u.id == aylikUrunKimligi)
          .toList(growable: false);
      _yillikAdaylar = response.productDetails
          .where((u) => u.id == yillikUrunKimligi)
          .toList(growable: false);
      seciliPlan = _varsayilanPlan();
    } catch (e) {
      // Abonelik ürününde etkin temel plan/teklif yoksa mağaza katmanı hata
      // fırlatabiliyor; mağazayı hazır sayıp ham sebebi görünür bırakıyoruz.
      _aylikAdaylar = <ProductDetails>[];
      _yillikAdaylar = <ProductDetails>[];
      tani = e.toString();
    }
    debugPrint(
      '[SatinAlma] aylikAdet=${_aylikAdaylar.length} aylikFiyat=$aylikFiyat '
      'yillikAdet=${_yillikAdaylar.length} yillikFiyat=$yillikFiyat '
      'tasarruf=$yillikTasarrufYuzde tani=$tani hata=$hata',
    );
  }

  Future<void> planSec(PremiumPlan plan) async {
    if (seciliPlan == plan) return;
    seciliPlan = plan;
    notifyListeners();
  }

  Future<void> satinAl() async {
    final ProductDetails? urun = seciliUrun;
    if (urun == null || yukleniyor) return;
    yukleniyor = true;
    hata = null;
    notifyListeners();

    // Flutter'ın storefront bağımsız API'sinde abonelik satın alımı da
    // buyNonConsumable üzerinden başlatılır. Ürün türü mağazada abonelik
    // (Subscription / Auto-Renewable) olarak tanımlanmalıdır.
    try {
      final basarili = await _magaza.buyNonConsumable(
        purchaseParam: PurchaseParam(productDetails: urun),
      );
      // Ödeme ekranı açıldıysa sonuç purchaseStream'den işlenir.
      if (basarili) return;

      hata = hataSatinAlmaBaslatilamadi;
      await AnalyticsServisi().olay('premium_purchase_failed');
    } catch (e) {
      hata = hataSatinAlmaBasarisiz;
      tani = e.toString();
    }

    yukleniyor = false;
    notifyListeners();
  }

  Future<void> satinAlmalariGeriYukle() async {
    if (!magazaHazir || yukleniyor) return;
    yukleniyor = true;
    hata = null;
    notifyListeners();
    try {
      await _magaza.restorePurchases();
    } catch (e) {
      hata = hataSatinAlmaBasarisiz;
      tani = e.toString();
    } finally {
      // Mağaza hata verdiğinde akış hiç olay göndermez; düğmeler kilitli
      // kalmasın diye yükleniyor durumu burada mutlaka kapatılır.
      yukleniyor = false;
      notifyListeners();
    }
  }

  Future<void> _satinalmalariIsle(
    List<PurchaseDetails> satinAlmalar,
  ) async {
    for (final satinAlma in satinAlmalar) {
      if (satinAlma.productID != aylikUrunKimligi &&
          satinAlma.productID != yillikUrunKimligi) {
        continue;
      }

      if (satinAlma.status == PurchaseStatus.purchased ||
          satinAlma.status == PurchaseStatus.restored) {
        // Üretimde satın alma doğrulaması güvenli bir sunucuda yapılmalıdır.
        premiumAktif = true;
        await ReklamServisi().reklamlariKapat();
        await AnalyticsServisi().olay(
          satinAlma.status == PurchaseStatus.restored
              ? 'premium_restore'
              : 'premium_purchase',
          {'product_id': satinAlma.productID},
        );
      } else if (satinAlma.status == PurchaseStatus.error) {
        hata = satinAlma.error?.message ?? hataSatinAlmaBasarisiz;
      }

      if (satinAlma.pendingCompletePurchase) {
        await _magaza.completePurchase(satinAlma);
      }
    }

    yukleniyor = false;
    notifyListeners();
  }

  // --- YARDIMCILAR ---

  /// Ücretsiz deneme hangi planda varsa onu, yoksa yıllık planı öne çıkarır.
  PremiumPlan _varsayilanPlan() {
    if (_yillikAdaylar.isNotEmpty && _denemeVar(_yillikAdaylar)) {
      return PremiumPlan.yillik;
    }
    if (_aylikAdaylar.isNotEmpty && _denemeVar(_aylikAdaylar)) {
      return PremiumPlan.aylik;
    }
    if (_yillikAdaylar.isNotEmpty) return PremiumPlan.yillik;
    return PremiumPlan.aylik;
  }

  /// Mağaza 0 fiyatlı (ücretsiz deneme) bir teklif döndürdü mü?
  bool _denemeVar(List<ProductDetails> adaylar) =>
      denemeGunSayisi > 0 && adaylar.any((u) => u.rawPrice <= 0);

  /// [tur] 0 → 0 fiyatlı (deneme) teklif, 1 → gerçek fiyatlı teklif.
  ProductDetails? _ilkUygunTeklif(List<ProductDetails> adaylar, int tur) {
    for (final u in adaylar) {
      if (tur == 0 && u.rawPrice <= 0) return u;
      if (tur == 1 && u.rawPrice > 0) return u;
    }
    return null;
  }

  /// Gerçek (0 olmayan) fiyatlı ilk teklif; tasarruf hesabı için.
  ProductDetails? _gercekFiyat(List<ProductDetails> adaylar) =>
      _ilkUygunTeklif(adaylar, 1);

  String _fiyatMetni(List<ProductDetails> adaylar, String varsayilan) {
    final gercek = _gercekFiyat(adaylar);
    final metin = gercek?.price.trim() ?? '';
    if (metin.isEmpty || _ucretsizGorunumlu(metin)) return varsayilan;
    return metin;
  }

  /// Mağaza "Ücretsiz" / "Free" döndürdüyse ekranda varsayılana düşülür.
  static bool _ucretsizGorunumlu(String metin) {
    final kucuk = metin.toLowerCase();
    return kucuk.contains('free') ||
        kucuk.contains('ücretsiz') ||
        kucuk.contains('gratis') ||
        kucuk.contains('gratuit') ||
        RegExp(r'^[^\d]*0[.,]?0*\s*[^\d]*$').hasMatch(kucuk);
  }
}
