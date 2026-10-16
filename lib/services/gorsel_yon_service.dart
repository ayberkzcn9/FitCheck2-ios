// FitCheck — Gardırop görsellerinin yönünü ve çerçevesini standartlaştıran
// servis.
//
// Sorun 1: Telefon yatay tutularak çekilen fotoğraflar yatay kalır; gardıropta
// kıyafet "yan yatmış" görünür ve ızgarada diğer kıyafetlerle aynı durmaz.
// Çözüm 1: Arka planı silinmiş görsel hâlâ yataysa saat yönünde 90°
// döndürülüp dikeyleştirilir.
//
// Sorun 2: Arka planı silinen görselin çevresinde fotoğrafın boş alanı kalır;
// kıyafet kutuda küçük görünür.
// Çözüm 2: Saydam boşluk, görselin gerçek içeriğine (alfa sınırına) göre
// kırpılır — bkz. [icerigeKirp].
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

import 'dart:math' as math;

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

  /// Kırpma sırasında içeriğin çevresinde bırakılan boşluk oranı
  /// (görselin uzun kenarına göre). Kıyafet kutuya yapışmaz.
  static const double kenarPayiOrani = 0.05;

  /// Bu eşiğin altındaki alfa "boş" sayılır (fotoğraf gürültüsü sınırı
  /// bozmasın diye 0 değil, küçük bir eşik kullanılır).
  static const int alfaEsigi = 8;

  /// İçerik, karenin bu oranından daha azını kaplıyorsa kırpma yapılmaz:
  /// bu durumda büyük olasılıkla model kıyafetin yalnızca bir parçasını
  /// bulmuştur ve kırpmak yanlış yeri devasa büyütür.
  static const double enAzIcerikOrani = 0.05;

  /// Yatay görseli dikeyleştirir; zaten dikeyse **aynı baytları** döndürür
  /// (gereksiz yeniden kodlama / kalite kaybı olmaz).
  ///
  /// Görsel çözümlenemezse `null` döner; çağıran ham veriye düşmelidir.
  static Future<Uint8List?> dikeylestir(Uint8List bytes) =>
      compute(dikeylestirSenkron, bytes);

  /// Görseli saat yönünde 90° döndürür (kullanıcının "Döndür" butonu).
  static Future<Uint8List?> saatYonundeDondur(Uint8List bytes) =>
      compute(saatYonundeDondurSenkron, bytes);

  /// Gardıroba kaydedilecek görseli hazırlar: gerekirse dikeyleştirir ve
  /// çevresindeki boş (saydam) alanı kırpar. Tek isolate turu kullanır.
  static Future<Uint8List?> duzenle(Uint8List bytes) =>
      compute(duzenleSenkron, bytes);

  /// Görselin çevresindeki boş alanı kırpar (bkz. [icerigeKirpSenkron]).
  static Future<Uint8List?> icerigeKirp(Uint8List bytes) =>
      compute(icerigeKirpSenkron, bytes);


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

  /// [duzenle] ile aynı işi yapar, isolate açmadan (testler için).
  ///
  /// Sıra önemli: önce yön (karenin en-boy oranına göre karar verilir),
  /// sonra kırpma. Ters sırada kırpma kararı içeriğin oranına göre verilirdi
  /// ve kare biçimli çekilmiş yatay fotoğraflar yanlış dönerdi.
  static Uint8List? duzenleSenkron(Uint8List bytes) {
    final dikey = dikeylestirSenkron(bytes);
    if (dikey == null) return null;
    return icerigeKirpSenkron(dikey) ?? dikey;
  }

  /// Görselin çevresindeki saydam boşluğu kırpar; kıyafet kareyi doldurur ve
  /// ızgarada tüm kıyafetler aynı ölçekte görünür.
  ///
  /// Kırpılacak anlamlı bir alan yoksa (görsel zaten sıkıysa, saydamlık
  /// yoksa veya içerik karenin çok küçük bir bölümündeyse) **aynı baytları**
  /// döndürür — gereksiz yeniden kodlama yapılmaz.
  static Uint8List? icerigeKirpSenkron(Uint8List bytes) {
    try {
      final cozulen = _coz(bytes);
      if (cozulen == null) return null;

      // Saydamlık yoksa kırpılacak boş alan da yoktur (ör. JPEG).
      if (!cozulen.hasAlpha) return bytes;

      final kutu = _alfaSinirKutusu(cozulen);
      if (kutu == null) return bytes;

      final kareAlan = cozulen.width * cozulen.height;
      if (kutu[2] * kutu[3] < kareAlan * enAzIcerikOrani) return bytes;

      final pay = (math.max(cozulen.width, cozulen.height) * kenarPayiOrani)
          .round();
      final sol = math.max(0, kutu[0] - pay);
      final ust = math.max(0, kutu[1] - pay);
      final sag = math.min(cozulen.width, kutu[0] + kutu[2] + pay);
      final alt = math.min(cozulen.height, kutu[1] + kutu[3] + pay);

      // Zaten kırpılmışsa (kenarlarda boşluk yoksa) yeniden kodlama yapma.
      if (sol == 0 &&
          ust == 0 &&
          sag == cozulen.width &&
          alt == cozulen.height) {
        return bytes;
      }

      return _kodla(
        img.copyCrop(
          cozulen,
          x: sol,
          y: ust,
          width: sag - sol,
          height: alt - ust,
        ),
      );
    } catch (e) {
      debugPrint('Görsel kırpılamadı: $e');
      return null;
    }
  }

  /// Alfa kanalına göre içeriğin sınır kutusunu bulur: `[x, y, genişlik,
  /// yükseklik]`. Görsel tamamen saydamsa `null` döner.
  static List<int>? _alfaSinirKutusu(img.Image gorsel) {
    final veri = gorsel.getBytes(order: img.ChannelOrder.rgba);
    var sol = gorsel.width;
    var ust = gorsel.height;
    var sag = -1;
    var alt = -1;

    for (var y = 0; y < gorsel.height; y++) {
      final satir = y * gorsel.width * 4;
      for (var x = 0; x < gorsel.width; x++) {
        if (veri[satir + x * 4 + 3] > alfaEsigi) {
          if (x < sol) sol = x;
          if (x > sag) sag = x;
          if (y < ust) ust = y;
          if (y > alt) alt = y;
        }
      }
    }

    if (sag < 0 || alt < 0) return null;
    return [sol, ust, sag - sol + 1, alt - ust + 1];
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
