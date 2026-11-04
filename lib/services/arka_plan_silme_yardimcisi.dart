// FitCheck — Arka plan silme akışının orkestrasyonu.
//
// KURAL (kullanıcı geri bildirimi): Arka plan silinemezse kullanıcıya SORULUR.
// Eskiden hem yerel sunucu hem bulut başarısız olduğunda fotoğraf **sessizce
// arka planıyla** kaydediliyordu; kullanıcı bunu "arka plan silinmiyor" olarak
// görüyordu ve hatanın nedenini anlayamıyordu.
//
// Sıra:
//   1) Yerel sunucu (rembg) — hızlı ve ücretsiz. Geçici ağ hataları için
//      varsayılan olarak **bir kez daha** denenir.
//   2) Bulut (remove.bg) — yedek.
//   3) İkisi de olmazsa `null` döner; karar ekranı kullanıcıya bırakır.
//
// Sınıf, arka plan silici fonksiyonları DIŞARIDAN alır: böylece gerçek ağ
// çağrısı yapmadan test edilebilir (bkz. test/arka_plan_silme_yardimcisi_test.dart).
//
// NOT: remove.bg hesabında kredi bittiğinde servis `null` döner (istisna
// atmaz); bu yüzden "geçersiz yanıt" kontrolü tek başına yeterli değildir —
// aşağıdaki durum makinesi her iki durumu da aynı şekilde ele alır.

import '../theme/design_tokens.dart';
import 'dart:typed_data';

/// Bir arka plan silici: görseli alır, arka planı silinmiş PNG'yi döndürür.
/// Başarısızsa `null` (ya da kısa/bozuk baytlar) döner.
typedef ArkaPlanSilici = Future<Uint8List?> Function(Uint8List girdi);

class ArkaPlanSilmeYardimcisi {
  ArkaPlanSilmeYardimcisi._();

  /// Bu uzunluğun altındaki yanıt geçersiz sayılır (boş/bozuk PNG).
  static const int enAzGecerliBayt = 100;

  /// Yerel sunucu için deneme sayısı (ilk deneme + tekrar).
  static const int yerelDenemeSayisi = 2;

  /// Denemeler arası bekleme: anlık ağ/sunucu dalgalanmalarında işe yarar.
  static const Duration denemelerArasiBekleme = AppMotion.uzun;

  /// Arka planı silmeyi dener. Başarısızsa `null` döner.
  static Future<Uint8List?> dene(
    Uint8List girdi, {
    required ArkaPlanSilici yerel,
    required ArkaPlanSilici bulut,
    int yerelDeneme = yerelDenemeSayisi,
    Duration bekleme = denemelerArasiBekleme,
  }) async {
    for (var deneme = 1; deneme <= yerelDeneme; deneme++) {
      final sonuc = await _guvenli(yerel, girdi);
      if (gecerliMi(sonuc)) return sonuc;

      if (deneme < yerelDeneme && bekleme > Duration.zero) {
        await Future<void>.delayed(bekleme);
      }
    }

    final bulutSonuc = await _guvenli(bulut, girdi);
    return gecerliMi(bulutSonuc) ? bulutSonuc : null;
  }

  /// Dönen baytlar kullanılabilir mi? (Boş, kısa ya da `null` → hayır.)
  static bool gecerliMi(Uint8List? baytlar) =>
      baytlar != null && baytlar.length > enAzGecerliBayt;

  /// Servisler hataları kendi içinde yutar; yine de beklenmeyen bir istisna
  /// tüm ekleme akışını bozmasın.
  static Future<Uint8List?> _guvenli(
    ArkaPlanSilici silici,
    Uint8List girdi,
  ) async {
    try {
      return await silici(girdi);
    } catch (_) {
      return null;
    }
  }
}
