// Kesim kalite denetimini (zemin kıyafete çok yakın mı?) doğrular.
//
// Kritik davranışlar:
//  • Beyaz kıyafet + beyaz zemin  → uyarı VERİLİR.
//  • Beyaz kıyafet + siyah zemin  → uyarı verilmez.
//  • Dağınık/desenli zemin        → karar VERİLMEZ (yanlış uyarı çıkmasın).
//  • Sınır örneği yetersizse      → karar verilmez.
//
// Çalıştırma: flutter test test/kesim_kalite_denetimi_test.dart
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;

import 'package:fitcheck/services/kesim_kalite_denetimi.dart';

/// Orijinal fotoğraf: [zemin] renginde arka plan + ortada [kiyafet] renginde
/// bir dikdörtgen. [dagink] true ise arka plan satranç deseni olur.
img.Image _orijinal(
  img.ColorRgb8 zemin,
  img.ColorRgb8 kiyafet, {
  int boyut = 200,
  bool dagink = false,
}) {
  final g = img.Image(width: boyut, height: boyut, numChannels: 3);
  if (dagink) {
    for (var y = 0; y < boyut; y++) {
      for (var x = 0; x < boyut; x++) {
        final acik = (x ~/ 8 + y ~/ 8) % 2 == 0;
        g.setPixelRgb(x, y, acik ? 240 : 20, acik ? 240 : 20, acik ? 240 : 20);
      }
    }
  } else {
    img.fill(g, color: zemin);
  }
  final bas = boyut ~/ 4;
  final son = boyut - bas - 1;
  img.fillRect(
    g,
    x1: bas,
    y1: bas,
    x2: son,
    y2: son,
    color: kiyafet,
    alphaBlend: false,
  );
  return g;
}

/// Sunucunun döndürdüğü biçim: kıyafet pikselleri opak ve RENKLİ, dışarısı
/// tamamen saydam ve RENGİ SIFIR (gerçek sunucu çıktısı böyle).
img.Image _kesim(
  img.ColorRgb8 zemin,
  img.ColorRgb8 kiyafet, {
  int boyut = 200,
  bool dagink = false,
}) {
  final kaynak = _orijinal(zemin, kiyafet, boyut: boyut, dagink: dagink);
  final k = img.Image(width: boyut, height: boyut, numChannels: 4);
  final bas = boyut ~/ 4;
  final son = boyut - bas - 1;
  for (var y = 0; y < boyut; y++) {
    for (var x = 0; x < boyut; x++) {
      final icerde = x >= bas && x <= son && y >= bas && y <= son;
      if (icerde) {
        final p = kaynak.getPixel(x, y);
        k.setPixelRgba(x, y, p.r, p.g, p.b, 255);
      } else {
        k.setPixelRgba(x, y, 0, 0, 0, 0);
      }
    }
  }
  return k;
}

bool _kontrol(img.Image orijinal, img.Image kesim) {
  return KesimKaliteDenetimi.zeminBenzerSenkron(<Uint8List>[
    Uint8List.fromList(img.encodePng(orijinal)),
    Uint8List.fromList(img.encodePng(kesim)),
  ]);
}

void main() {
  final beyaz = img.ColorRgb8(242, 242, 242);
  final beyazaYakinZemin = img.ColorRgb8(252, 250, 249);
  final siyahZemin = img.ColorRgb8(8, 8, 8);
  final acikGriZemin = img.ColorRgb8(150, 150, 150);

  group('KesimKaliteDenetimi', () {
    test('beyaz kıyafet + beyaz zemin → uyarı verilir', () {
      expect(
        _kontrol(_orijinal(beyazaYakinZemin, beyaz), _kesim(beyazaYakinZemin, beyaz)),
        isTrue,
      );
    });

    test('beyaz kıyafet + siyah zemin → uyarı verilmez', () {
      expect(
        _kontrol(_orijinal(siyahZemin, beyaz), _kesim(siyahZemin, beyaz)),
        isFalse,
      );
    });

    test('beyaz kıyafet + açık gri zemin → uyarı verilmez', () {
      expect(
        _kontrol(_orijinal(acikGriZemin, beyaz), _kesim(acikGriZemin, beyaz)),
        isFalse,
      );
    });

    test('dağınık (desenli) zemin → karar verilmez', () {
      expect(
        _kontrol(
          _orijinal(beyazaYakinZemin, beyaz, dagink: true),
          _kesim(beyazaYakinZemin, beyaz, dagink: true),
        ),
        isFalse,
      );
    });

    test('sınır örneği yetersizse karar verilmez', () {
      // Kare neredeyse tamamen kıyafet: sınır çok kısa (≈160 örnek < 300).
      const boyut = 40;
      final o = img.Image(width: boyut, height: boyut, numChannels: 3);
      img.fill(o, color: beyazaYakinZemin);
      img.fillRect(o, x1: 0, y1: 0, x2: boyut - 1, y2: boyut - 1,
          color: beyaz, alphaBlend: false);
      final k = img.Image(width: boyut, height: boyut, numChannels: 4);
      for (var y = 1; y < boyut - 1; y++) {
        for (var x = 1; x < boyut - 1; x++) {
          k.setPixelRgba(x, y, 242, 242, 242, 255);
        }
      }
      expect(_kontrol(o, k), isFalse);
    });

    test('saydamlık yoksa karar verilmez', () {
      final o = _orijinal(beyazaYakinZemin, beyaz);
      final k = img.Image(width: 200, height: 200, numChannels: 4);
      img.fill(k, color: img.ColorRgba8(242, 242, 242, 255));
      expect(_kontrol(o, k), isFalse);
    });

    test('eşik değeri tutucu (45): sınırda kalan ton farkı uyarı vermez', () {
      // Kıyafet (242) ile zemin (200) arasındaki fark ≈ 72 > 45.
      final gri = img.ColorRgb8(200, 200, 200);
      expect(_kontrol(_orijinal(gri, beyaz), _kesim(gri, beyaz)), isFalse);
    });

    test('kırmızı kıyafet + kırmızı zemin → uyarı verilir', () {
      final kirmizi = img.ColorRgb8(190, 40, 40);
      final kirmiziZemin = img.ColorRgb8(200, 50, 45);
      expect(_kontrol(_orijinal(kirmiziZemin, kirmizi), _kesim(kirmiziZemin, kirmizi)),
          isTrue);
    });

    test('büyük fotoğrafta da karar verilir (sınır örneklemesi seyreltilmez)', () {
      // Regresyon: sınır taraması seyreltildiğinde büyük görsellerde örnek
      // sayısı 300'ün altına düşüp uyarı hiç çıkmıyordu.
      const boyut = 900;
      expect(
        _kontrol(
          _orijinal(beyazaYakinZemin, beyaz, boyut: boyut),
          _kesim(beyazaYakinZemin, beyaz, boyut: boyut),
        ),
        isTrue,
      );
    });

    test('aynı girdi her seferinde aynı kararı verir', () {
      final o = _orijinal(beyazaYakinZemin, beyaz);
      final k = _kesim(beyazaYakinZemin, beyaz);
      expect(_kontrol(o, k), _kontrol(o, k));
    });
  });
}
