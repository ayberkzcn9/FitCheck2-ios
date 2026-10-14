import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'reklam_servisi.dart';
import 'analytics_servisi.dart';

class SatinAlmaServisi extends ChangeNotifier {
  SatinAlmaServisi._();

  /// Uygulama genelinde tek örnek. Satın alma dinleyicisi ekran kapandığında
  /// da açık kalır; böylece tamamlanan ya da geri yüklenen satın alma kaybolmaz.
  static final SatinAlmaServisi ornek = SatinAlmaServisi._();

  // Play Console > Abonelikler'deki ürün kimliğiyle birebir aynı olmalıdır;
  // uyuşmazsa ürün sorgusu boş döner ve abone ol düğmesi pasif kalır.
  static const String reklamsizUrunKimligi = 'fitcheck_premium_monthly';

  // Mağaza fiyatı okunana kadar gösterilen varsayılan aylık fiyat.
  static const String varsayilanFiyat = '49,90 TL';

  // Mağazadan gelen metinler dışındaki hata durumları; ekran bunları
  // yerelleştirilmiş mesaja çevirir.
  static const String hataSatinAlmaBaslatilamadi = 'satin_alma_baslatilamadi';
  static const String hataSatinAlmaBasarisiz = 'satin_alma_basarisiz';

  final InAppPurchase _magaza = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _satinalmaDinleyicisi;
  ProductDetails? urun;
  bool magazaHazir = false;
  bool yukleniyor = false;
  bool hazirlaniyor = true;
  bool premiumAktif = false;
  String? hata;

  /// Ürünün/mağazanın neden hazır olmadığını gösteren ham teknik ayrıntı.
  String? tani;

  bool _sorguSuruyor = false;

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
    urun = null;

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
      final response = await _magaza.queryProductDetails({reklamsizUrunKimligi});
      hata = response.error?.message;
      if (response.notFoundIDs.isNotEmpty) {
        tani = 'notFoundIDs: ${response.notFoundIDs.join(', ')}';
      }
      urun = response.productDetails.isEmpty
          ? null
          : response.productDetails.first;
    } catch (e) {
      // Abonelik ürününde etkin temel plan/teklif yoksa mağaza katmanı hata
      // fırlatabiliyor; mağazayı hazır sayıp ham sebebi görünür bırakıyoruz.
      urun = null;
      tani = e.toString();
    }
    debugPrint(
      '[SatinAlma] urun=${urun?.id} fiyat=${urun?.price} tani=$tani hata=$hata',
    );
  }

  Future<void> satinAl() async {
    final seciliUrun = urun;
    if (seciliUrun == null || yukleniyor) return;
    yukleniyor = true;
    hata = null;
    notifyListeners();

    // Flutter'ın storefront bağımsız API'sinde abonelik satın alımı da
    // buyNonConsumable üzerinden başlatılır. Ürün türü Play Console'da
    // Subscription olarak tanımlanmalıdır.
    try {
      final basarili = await _magaza.buyNonConsumable(
        purchaseParam: PurchaseParam(productDetails: seciliUrun),
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
      if (satinAlma.productID != reklamsizUrunKimligi) continue;

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
}
