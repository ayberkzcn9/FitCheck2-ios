// Gardırop görsellerinin yön standartlaştırmasını doğrular.
//
// Kritik davranışlar:
//  • Yatay görsel dikeyleşir ve saat yönünde döner.
//  • Zaten dikey/kare görsel **hiç yeniden kodlanmaz** (kalite kaybı olmaz).
//  • Saydam (RGBA) görsel PNG kalır; şeffaflık kaybolmaz.
//
// Çalıştırma: flutter test test/gorsel_yon_service_test.dart
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;

import 'package:fitcheck/services/gorsel_yon_service.dart';

/// Sol yarısı kırmızı, sağ yarısı mavi görsel.
///
/// Yarıya bölünmüş bloklar JPEG sıkıştırmasından etkilenmez; tek piksellik
/// işaretçiden daha güvenilirdir.
img.Image _yariliGorsel(int genislik, int yukseklik, {int kanal = 3}) {
  final gorsel = img.Image(width: genislik, height: yukseklik, numChannels: kanal);
  img.fill(gorsel, color: img.ColorRgb8(0, 0, 255)); // mavi
  img.fillRect(
    gorsel,
    x1: 0,
    y1: 0,
    x2: (genislik ~/ 2) - 1,
    y2: yukseklik - 1,
    color: img.ColorRgb8(255, 0, 0), // sol yarı kırmızı
  );
  return gorsel;
}

bool _kirmiziMi(img.Image g, int x, int y) {
  final p = g.getPixel(x, y);
  return p.r > 150 && p.b < 120;
}

bool _maviMi(img.Image g, int x, int y) {
  final p = g.getPixel(x, y);
  return p.b > 150 && p.r < 120;
}

/// PNG/JPEG imzasından biçimi okur.
String _bicim(Uint8List bytes) {
  if (bytes.length > 8 &&
      bytes[0] == 0x89 &&
      bytes[1] == 0x50 &&
      bytes[2] == 0x4E &&
      bytes[3] == 0x47) {
    return 'png';
  }
  if (bytes.length > 3 && bytes[0] == 0xFF && bytes[1] == 0xD8) {
    return 'jpeg';
  }
  return 'bilinmiyor';
}

void main() {
  group('dikeylestirSenkron', () {
    test('yatay görsel dikeyleşir ve saat yönünde döner', () {
      // 40x20, sol yarı kırmızı → dikeyleşince kırmızı ÜSTTE olmalı.
      final girdi = Uint8List.fromList(img.encodePng(_yariliGorsel(40, 20)));

      final cikti = GorselYonService.dikeylestirSenkron(girdi);
      expect(cikti, isNotNull);

      final sonuc = img.decodeImage(cikti!)!;
      expect(sonuc.width, 20, reason: 'yatay → dikey olmalı');
      expect(sonuc.height, 40);
      expect(_kirmiziMi(sonuc, 10, 5), isTrue,
          reason: 'Saat yönünde dönüşte sol kenar üste gelir');
      expect(_maviMi(sonuc, 10, 35), isTrue, reason: 'Sağ kenar alta gelir');
    });

    test('zaten dikey olan görsel değiştirilmez', () {
      final girdi = Uint8List.fromList(img.encodePng(_yariliGorsel(20, 40)));

      final cikti = GorselYonService.dikeylestirSenkron(girdi);
      expect(cikti, isNotNull);
      expect(identical(cikti, girdi), isTrue,
          reason: 'Gereksiz yeniden kodlama yapılmamalı (kalite kaybı)');
    });

    test('kare görsel değiştirilmez', () {
      final girdi = Uint8List.fromList(img.encodePng(_yariliGorsel(30, 30)));

      final cikti = GorselYonService.dikeylestirSenkron(girdi);
      expect(identical(cikti, girdi), isTrue);
    });

    test('bozuk baytlar null döner (çağıran ham bayta düşer)', () {
      final cikti = GorselYonService.dikeylestirSenkron(
        Uint8List.fromList([1, 2, 3, 4]),
      );
      expect(cikti, isNull);
    });

    test('saydam (RGBA) yatay görsel PNG kalır ve şeffaflık korunur', () {
      final gorsel = _yariliGorsel(40, 20, kanal: 4);
      // Sağ yarıyı tamamen şeffaf yap (alphaBlend kapalı olmadan dolgu
      // şeffaflığı uygulamaz).
      img.fillRect(
        gorsel,
        x1: 20,
        y1: 0,
        x2: 39,
        y2: 19,
        color: img.ColorRgba8(0, 0, 0, 0),
        alphaBlend: false,
      );

      final cikti = GorselYonService.dikeylestirSenkron(
        Uint8List.fromList(img.encodePng(gorsel)),
      );
      expect(cikti, isNotNull);
      expect(_bicim(cikti!), 'png',
          reason: 'Saydam görsel JPEG\'e çevrilirse arka plan siyah olur');

      final sonuc = img.decodeImage(cikti)!;
      expect(sonuc.width, 20);
      expect(sonuc.height, 40);
      expect(sonuc.numChannels, 4);
      expect(sonuc.getPixel(10, 5).a, greaterThan(200),
          reason: 'Kıyafetin olduğu üst yarı saydam olmamalı');
      expect(sonuc.getPixel(10, 35).a, lessThan(10),
          reason: 'Şeffaf alan korunmalı');
    });
  });

  group('saatYonundeDondurSenkron', () {
    test('90° döner ve boyutları takas eder', () {
      final girdi = Uint8List.fromList(img.encodePng(_yariliGorsel(40, 20)));

      final cikti = GorselYonService.saatYonundeDondurSenkron(girdi);
      expect(cikti, isNotNull);

      final sonuc = img.decodeImage(cikti!)!;
      expect(sonuc.width, 20);
      expect(sonuc.height, 40);
      expect(_kirmiziMi(sonuc, 10, 5), isTrue);
      expect(_maviMi(sonuc, 10, 35), isTrue);
    });

    test('4 kez döndürünce görsel ilk yönüne döner', () {
      final girdi = Uint8List.fromList(img.encodePng(_yariliGorsel(40, 20)));

      var gecerli = girdi;
      for (var i = 0; i < 4; i++) {
        gecerli = GorselYonService.saatYonundeDondurSenkron(gecerli)!;
      }

      final sonuc = img.decodeImage(gecerli)!;
      expect(sonuc.width, 40);
      expect(sonuc.height, 20);
      expect(_kirmiziMi(sonuc, 10, 10), isTrue,
          reason: '360° sonrası sol yarı yine kırmızı olmalı');
      expect(_maviMi(sonuc, 30, 10), isTrue);
    });

    test('bozuk baytlar null döner', () {
      expect(
        GorselYonService.saatYonundeDondurSenkron(Uint8List.fromList([9, 9])),
        isNull,
      );
    });
  });

  group('icerigeKirpSenkron', () {
    test('çevredeki saydam boşluk kırpılır, pay bırakılır', () {
      // 60x40 kare, ortada 20x20 kırmızı blok (x:20..39, y:10..29).
      final girdi = Uint8List.fromList(img.encodePng(_blokluGorsel(60, 40)));

      final cikti = GorselYonService.icerigeKirpSenkron(girdi);
      expect(cikti, isNotNull);
      expect(identical(cikti, girdi), isFalse, reason: 'Kırpılmalı');

      final sonuc = img.decodeImage(cikti!)!;
      // pay = round(60 * 0.05) = 3 → 20 + 2*3 = 26
      expect(sonuc.width, 26);
      expect(sonuc.height, 26);
      expect(sonuc.numChannels, 4, reason: 'Saydamlık korunmalı (PNG)');
      expect(_kirmiziMi(sonuc, 13, 13), isTrue, reason: 'Kıyafet ortada kalmalı');
      expect(sonuc.getPixel(0, 0).a, lessThan(10),
          reason: 'Bırakılan pay saydam olmalı');
    });

    test('zaten sıkı görsel değiştirilmez', () {
      // İçerik karenin tamamını kaplıyor → kırpılacak boşluk yok.
      final gorsel = img.Image(width: 20, height: 20, numChannels: 4);
      img.fillRect(
        gorsel,
        x1: 0,
        y1: 0,
        x2: 19,
        y2: 19,
        color: img.ColorRgba8(255, 0, 0, 255),
        alphaBlend: false,
      );
      final girdi = Uint8List.fromList(img.encodePng(gorsel));

      final cikti = GorselYonService.icerigeKirpSenkron(girdi);
      expect(identical(cikti, girdi), isTrue,
          reason: 'Gereksiz yeniden kodlama yapılmamalı');
    });

    test('saydamlık yoksa (JPEG) dokunulmaz', () {
      final girdi = Uint8List.fromList(img.encodeJpg(_yariliGorsel(60, 40)));

      final cikti = GorselYonService.icerigeKirpSenkron(girdi);
      expect(identical(cikti, girdi), isTrue);
    });

    test('tamamen saydam görsel değiştirilmez', () {
      final girdi = Uint8List.fromList(
        img.encodePng(img.Image(width: 30, height: 30, numChannels: 4)),
      );

      final cikti = GorselYonService.icerigeKirpSenkron(girdi);
      expect(identical(cikti, girdi), isTrue);
    });

    test('içerik karenin çok küçük bir parçasıysa kırpılmaz', () {
      // 200x200 karede 10x10 blok ≈ %0,25 → model yanlış bulmuş olabilir.
      final girdi = Uint8List.fromList(
        img.encodePng(_blokluGorsel(200, 200, blokG: 10, blokY: 10)),
      );

      final cikti = GorselYonService.icerigeKirpSenkron(girdi);
      expect(identical(cikti, girdi), isTrue);
    });

    test('bozuk baytlar null döner', () {
      expect(
        GorselYonService.icerigeKirpSenkron(Uint8List.fromList([7, 7, 7])),
        isNull,
      );
    });
  });

  group('duzenleSenkron', () {
    test('önce dikeyleştirir, sonra kırpar', () {
      // 60x40 yatay kare, ortada 20x20 blok → 40x60 olmalı, sonra kırpılmalı.
      final girdi = Uint8List.fromList(img.encodePng(_blokluGorsel(60, 40)));

      final cikti = GorselYonService.duzenleSenkron(girdi);
      expect(cikti, isNotNull);

      final sonuc = img.decodeImage(cikti!)!;
      expect(sonuc.width, 26, reason: 'Kırpma payı: round(60*0,05)=3');
      expect(sonuc.height, 26);
    });

    test('dikey görselde yalnızca kırpma yapılır', () {
      final girdi = Uint8List.fromList(img.encodePng(_blokluGorsel(40, 60)));

      final cikti = GorselYonService.duzenleSenkron(girdi);
      final sonuc = img.decodeImage(cikti!)!;
      expect(sonuc.width, 26);
      expect(sonuc.height, 26);
    });

    test('bozuk baytlar null döner', () {
      expect(
        GorselYonService.duzenleSenkron(Uint8List.fromList([3])),
        isNull,
      );
    });
  });
}

/// Saydam zemin üzerinde ortada kırmızı blok olan RGBA görsel üretir.
img.Image _blokluGorsel(
  int genislik,
  int yukseklik, {
  int blokG = 20,
  int blokY = 20,
}) {
  final gorsel = img.Image(width: genislik, height: yukseklik, numChannels: 4);
  final sol = (genislik - blokG) ~/ 2;
  final ust = (yukseklik - blokY) ~/ 2;
  img.fillRect(
    gorsel,
    x1: sol,
    y1: ust,
    x2: sol + blokG - 1,
    y2: ust + blokY - 1,
    color: img.ColorRgba8(255, 0, 0, 255),
    alphaBlend: false,
  );
  return gorsel;
}
