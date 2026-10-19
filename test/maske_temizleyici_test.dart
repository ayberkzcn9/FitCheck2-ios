// Maske temizliğini (leke silme + delik kapatma) doğrular.
//
// Kritik davranışlar:
//  • Küçük/gürültü benzeri saydam olmayan adacıklar silinir.
//  • Büyük ve dolu ayrı parçalar (ör. ayrı duran kemer) KORUNUR.
//  • Kıyafetin içindeki küçük delikler kumaş rengiyle kapatılır.
//  • Büyük delikler (ör. çanta sapı boşluğu) KORUNUR.
//  • Leke temizliği kırpmayı bozmaz: kıyafet kutuyu doldurur.
//
// Çalıştırma: flutter test test/maske_temizleyici_test.dart
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;

import 'package:fitcheck/services/gorsel_yon_service.dart';
import 'package:fitcheck/services/maske_temizleyici.dart';

/// 400x400 kare, ortada 200x200 kırmızı kıyafet, gerisi saydam.
///
/// Eşikler bu boyutta anlamlı: leke eşiği 32 px, orta eşik 128 px,
/// delik eşiği 320 px (bkz. MaskeTemizleyici sabitleri).
img.Image _kare() {
  final gorsel = img.Image(width: 400, height: 400, numChannels: 4);
  img.fillRect(
    gorsel,
    x1: 100,
    y1: 100,
    x2: 299,
    y2: 299,
    color: img.ColorRgba8(220, 30, 30, 255),
    alphaBlend: false,
  );
  return gorsel;
}

void _leke(img.Image gorsel, int x, int y, int genislik, int yukseklik) {
  img.fillRect(
    gorsel,
    x1: x,
    y1: y,
    x2: x + genislik - 1,
    y2: y + yukseklik - 1,
    color: img.ColorRgba8(20, 20, 200, 255),
    alphaBlend: false,
  );
}

int _alfa(img.Image g, int x, int y) => g.getPixel(x, y).a.toInt();

bool _kirmiziMi(img.Image g, int x, int y) {
  final p = g.getPixel(x, y);
  return p.r > 150 && p.b < 120;
}

void main() {
  group('MaskeTemizleyici.temizle', () {
    test('küçük leke silinir, kıyafet korunur', () {
      final gorsel = _kare();
      _leke(gorsel, 10, 10, 3, 3); // 9 px → küçük eşiğin (32) altında

      expect(MaskeTemizleyici.temizle(gorsel), isTrue);
      expect(_alfa(gorsel, 11, 11), 0, reason: 'Leke silinmeli');
      expect(_alfa(gorsel, 200, 200), 255, reason: 'Kıyafet dokunulmamalı');
    });

    test('büyük ve dolu ayrı parça korunur', () {
      final gorsel = _kare();
      _leke(gorsel, 10, 10, 10, 10); // 100 px, dolu → ayrı duran kemer gibi

      expect(MaskeTemizleyici.temizle(gorsel), isFalse);
      expect(_alfa(gorsel, 15, 15), 255, reason: 'Gerçek parça silinmemeli');
    });

    test('gürültü benzeri seyrek leke silinir', () {
      final gorsel = _kare();
      // 100 px ama 46x46 kutuya dağılmış (seyreklik ≈ 0,05) → gürültü.
      for (var i = 0; i < 10; i++) {
        for (var j = 0; j < 10; j++) {
          _leke(gorsel, 10 + i * 5, 10 + j * 5, 1, 1);
        }
      }

      expect(MaskeTemizleyici.temizle(gorsel), isTrue);
      expect(_alfa(gorsel, 10, 10), 0);
      expect(_alfa(gorsel, 200, 200), 255);
    });

    test('küçük delik kapatılır ve kumaş rengiyle dolar', () {
      final gorsel = _kare();
      // Kıyafetin ortasında 10x10 delik (100 px ≤ 320).
      img.fillRect(
        gorsel,
        x1: 190,
        y1: 190,
        x2: 199,
        y2: 199,
        color: img.ColorRgba8(0, 0, 0, 0),
        alphaBlend: false,
      );

      expect(MaskeTemizleyici.temizle(gorsel), isTrue);
      expect(_alfa(gorsel, 195, 195), 255, reason: 'Delik kapanmalı');
      expect(_kirmiziMi(gorsel, 195, 195), isTrue,
          reason: 'Delik arka plan rengiyle değil kumaş rengiyle dolmalı');
    });

    test('büyük delik korunur', () {
      final gorsel = _kare();
      // 25x25 delik = 625 px > 320 → gerçek boşluk (ör. çanta sapı).
      img.fillRect(
        gorsel,
        x1: 180,
        y1: 180,
        x2: 204,
        y2: 204,
        color: img.ColorRgba8(0, 0, 0, 0),
        alphaBlend: false,
      );

      expect(MaskeTemizleyici.temizle(gorsel), isFalse);
      expect(_alfa(gorsel, 192, 192), 0, reason: 'Gerçek boşluk kapanmamalı');
    });

    test('ince ama bağlı parça korunur', () {
      final gorsel = _kare();
      _leke(gorsel, 200, 40, 1, 60); // 1 px genişliğinde, gövdeye bağlı kayış

      expect(MaskeTemizleyici.temizle(gorsel), isFalse);
      expect(_alfa(gorsel, 200, 50), 255, reason: 'İnce askı silinmemeli');
    });

    test('saydamlık yoksa dokunulmaz', () {
      final gorsel = img.Image(width: 40, height: 40, numChannels: 3);
      img.fill(gorsel, color: img.ColorRgb8(10, 10, 10));

      expect(MaskeTemizleyici.temizle(gorsel), isFalse);
    });

    test('tamamen saydam ve tamamen dolu görselde değişiklik yok', () {
      final bos = img.Image(width: 30, height: 30, numChannels: 4);
      expect(MaskeTemizleyici.temizle(bos), isFalse);

      final dolu = img.Image(width: 30, height: 30, numChannels: 4);
      img.fill(dolu, color: img.ColorRgba8(5, 5, 5, 255));
      expect(MaskeTemizleyici.temizle(dolu), isFalse);
    });
  });

  group('GorselYonService.duzenleSenkron + maske temizliği', () {
    test('leke silindikten sonra kırpma sıkılaşır', () {
      // 120x120 kare, ortada 30x30 blok (x:40..69) + köşede 2x2 leke.
      final gorsel = img.Image(width: 120, height: 120, numChannels: 4);
      img.fillRect(
        gorsel,
        x1: 40,
        y1: 40,
        x2: 69,
        y2: 69,
        color: img.ColorRgba8(255, 0, 0, 255),
        alphaBlend: false,
      );
      _leke(gorsel, 5, 5, 2, 2);

      final cikti = GorselYonService.duzenleSenkron(
        Uint8List.fromList(img.encodePng(gorsel)),
      );
      expect(cikti, isNotNull);

      final sonuc = img.decodeImage(cikti!)!;
      // pay = round(120 * 0,05) = 6 → 30 + 2*6 = 42.
      // Leke silinmeseydi sınır kutusu (5..69) olur ve genişlik 77 çıkardı.
      expect(sonuc.width, 42, reason: 'Leke kırpmayı büyütmemeli');
      expect(sonuc.height, 42);
      expect(sonuc.numChannels, 4, reason: 'Saydamlık korunmalı (PNG)');
    });
  });
}
