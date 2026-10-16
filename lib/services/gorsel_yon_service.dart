// FitCheck — Gardırop görsellerinin yönünü standartlaştıran servis.
//
// Sorun: Telefon yatay tutularak çekilen fotoğraflar yatay kalır; gardıropta
// kıyafet "yan yatmış" görünür ve ızgarada diğer kıyafetlerle aynı durmaz.
//
// Çözüm: Arka planı silinmiş görsel hâlâ yataysa saat yönünde 90° döndürülüp
// dikeyleştirilir.
//
// ⚠️ Neden ham fotoğrafa değil de arka plan silme ÇIKTISINA uygulanıyor:
//    • Fotoğrafların yönü çoğu zaman yalnızca EXIF etiketinde durur ve EXIF
//      yönünü arka plan silme sunucusu piksellere işler (test edildi:
//      800x600 + EXIF 6 → 600x800). Ham baytlara ayrıca döndürme uygulamak
//      sunucunun işlemiyle birleşip çift döndürme (ters görüntü) yapardı.
//    • Sunucu/API çıktısı PNG'dir ve PNG EXIF taşımaz; yani çıktıyı döndürmek
//      her zaman güvenlidir.
//
// Dönüş yönü yanlış çıkan bir cihaz olursa tek yapılacak: aşağıdaki
// `yatayiSaatYonundeDondur` değerini `false` yapmak.
//
// Ayrıca kullanıcı, düzenleme ekranındaki "Döndür" ile her kıyafeti
// istediği yöne çevirebilir (bkz. GardirobumEkrani._kiyafetDuzenle).

import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

class GorselYonService {
  GorselYonService._();

  /// Yatay görseller dikeyleştirilirken döndürme yönü.
  ///
  /// Telefonların arka kamera sensörleri "yatay doğal" düzendedir
  /// (Android `sensorOrientation` ≈ 90°). Bu yüzden yatay kaydedilmiş bir
  /// görselde dünya "yukarı"sı görselin SOL kenarına bakar; sol kenarı üste
  /// taşımak saat yönünde (90°) döndürmek demektir.
  static const bool yatayiSaatYonundeDondur = true;

  /// Yatay görseli dikeyleştirir; zaten dikeyse **aynı baytları** döndürür
  /// (gereksiz yeniden kodlama / kalite kaybı olmaz).
  ///
  /// Görsel çözümlenemezse `null` döner; çağıran ham veriye düşmelidir.
  static Future<Uint8List?> dikeylestir(Uint8List bytes) =>
      compute(dikeylestirSenkron, bytes);

  /// Görseli saat yönünde 90° döndürür (kullanıcının "Döndür" butonu).
  static Future<Uint8List?> saatYonundeDondur(Uint8List bytes) =>
      compute(saatYonundeDondurSenkron, bytes);

  /// [dikeylestir] ile aynı işi yapar, isolate açmadan (testler için).
  static Uint8List? dikeylestirSenkron(Uint8List bytes) {
    try {
      final cozulen = _coz(bytes);
      if (cozulen == null) return null;

      // Zaten dikey (veya kare) → dokunma.
      if (cozulen.width <= cozulen.height) return bytes;

      final dikey = img.copyRotate(
        cozulen,
        angle: yatayiSaatYonundeDondur ? 90 : -90,
      );
      return _kodla(dikey);
    } catch (e) {
      debugPrint('Görsel dikeyleştirilemedi: $e');
      return null;
    }
  }

  /// [saatYonundeDondur] ile aynı işi yapar, isolate açmadan (testler için).
  static Uint8List? saatYonundeDondurSenkron(Uint8List bytes) {
    try {
      final cozulen = _coz(bytes);
      if (cozulen == null) return null;

      return _kodla(img.copyRotate(cozulen, angle: 90));
    } catch (e) {
      debugPrint('Görsel döndürülemedi: $e');
      return null;
    }
  }

  /// Görseli çözer: yalnızca PNG ve JPEG.
  ///
  /// `img.decodeImage` yerine biçime özel çözücüler kullanılıyor: aksi hâlde
  /// paketin GIF/WebP/TIFF/BMP... çözücüleri de uygulamaya gömülüp APK'yı
  /// gereksiz yere büyütüyor. Desteklenmeyen biçimde `null` döner ve çağıran
  /// ham veriyi korur (görsel yine sorunsuz gösterilir, yalnızca döndürülmez).
  static img.Image? _coz(Uint8List bytes) {
    if (_jpegMi(bytes)) return img.decodeJpg(bytes);
    if (_pngMi(bytes)) return img.decodePng(bytes);
    return null;
  }

  static bool _pngMi(Uint8List b) =>
      b.length > 8 &&
      b[0] == 0x89 &&
      b[1] == 0x50 &&
      b[2] == 0x4E &&
      b[3] == 0x47;

  static bool _jpegMi(Uint8List b) =>
      b.length > 3 && b[0] == 0xFF && b[1] == 0xD8 && b[2] == 0xFF;

  /// Saydamlık varsa PNG, yoksa JPEG olarak kodlar.
  ///
  /// JPEG'e çevirmek şeffaf alanı siyaha boyayıp kıyafetin arka planını
  /// bozacağı için saydam görseller her zaman PNG kalır.
  static Uint8List _kodla(img.Image gorsel) {
    final saydam = gorsel.numChannels == 4 ||
        gorsel.numChannels == 2 ||
        gorsel.hasPalette;
    return saydam ? img.encodePng(gorsel) : img.encodeJpg(gorsel, quality: 92);
  }
}
