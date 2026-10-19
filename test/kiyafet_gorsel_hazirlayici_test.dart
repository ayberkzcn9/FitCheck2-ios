// Kıyafet görsellerinin vision için hazırlanmasının testleri.
//
// Kritik davranışlar:
//  • Görsel küçültülür (en uzun kenar 384) ve JPEG üretilir.
//  • Şeffaf arka plan BEYAZA boyanır (boyanmazsa JPEG'de siyah çıkar ve model
//    kıyafeti yanlış yorumlar).
//  • Bozuk/çözülemeyen görsel uygulamayı çökertmez, null döner.
//  • Aynı parça için ikinci kez kodlama yapılmaz (önbellek).
//
// Çalıştırma: flutter test test/kiyafet_gorsel_hazirlayici_test.dart
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;

import 'package:fitcheck/models/kiyafet.dart';
import 'package:fitcheck/services/kiyafet_gorsel_hazirlayici.dart';

/// Şeffaf zeminde kırmızı bir dikdörtgen içeren test PNG'si üretir.
Uint8List testPng({int genislik = 1200, int yukseklik = 800}) {
  final gorsel = img.Image(width: genislik, height: yukseklik, numChannels: 4);
  img.fill(gorsel, color: img.ColorRgba8(0, 0, 0, 0));
  final kutuGenislik = (genislik * 0.4).round();
  final kutuYukseklik = (yukseklik * 0.4).round();
  img.fillRect(
    gorsel,
    x1: (genislik * 0.3).round(),
    y1: (yukseklik * 0.3).round(),
    x2: (genislik * 0.3).round() + kutuGenislik,
    y2: (yukseklik * 0.3).round() + kutuYukseklik,
    color: img.ColorRgba8(200, 30, 30, 255),
  );
  return Uint8List.fromList(img.encodePng(gorsel));
}

Kiyafet parca({required String id, required Uint8List bytes}) {
  return Kiyafet(
    id: id,
    baslik: 'Test Gömlek',
    kategori: 'ust',
    resimBytes: bytes,
    renk: 'Kırmızı',
    stil: 'Casual',
  );
}

void main() {
  setUp(KiyafetGorselHazirlayici.onbellegiTemizle);

  test('görsel küçültülür ve JPEG üretilir', () {
    final jpeg = kucultVeJpegYap(testPng());

    expect(jpeg, isNotNull);
    // JPEG imzası: FF D8 FF
    expect(jpeg!.sublist(0, 3), <int>[0xFF, 0xD8, 0xFF]);

    final cozulen = img.decodeJpg(jpeg)!;
    expect(cozulen.width, 384); // 1200 -> 384 (en uzun kenar)
    expect(cozulen.height, 256); // oran korunur (800 * 0.32)
  });

  test('küçük görsel büyütülmez', () {
    final kucuk = testPng(genislik: 100, yukseklik: 80);

    final cozulen = img.decodeJpg(kucultVeJpegYap(kucuk)!)!;

    expect(cozulen.width, 100);
    expect(cozulen.height, 80);
  });

  test('şeffaf arka plan beyaza boyanır', () {
    final cozulen = img.decodeJpg(kucultVeJpegYap(testPng())!)!;

    // Sol üst köşe kıyafetin dışında kalır: beyaz olmalı.
    final kose = cozulen.getPixel(0, 0);
    expect(kose.r, greaterThan(245));
    expect(kose.g, greaterThan(245));
    expect(kose.b, greaterThan(245));

    // Ortadaki kutu hâlâ kırmızı olmalı (kıyafet kaybolmasın).
    final orta = cozulen.getPixel(cozulen.width ~/ 2, cozulen.height ~/ 2);
    expect(orta.r, greaterThan(150));
    expect(orta.g, lessThan(100));
  });

  test('bozuk veri null döner (çökme yok)', () {
    expect(kucultVeJpegYap(Uint8List.fromList(<int>[1, 2, 3, 4])), isNull);
    expect(kucultVeJpegYap(Uint8List(0)), isNull);
  });

  test('hazırla: bozuk parça atlanır, geçerli parçalar sırayla döner', () async {
    final saglam = parca(id: 'a', bytes: testPng());
    final bozuk = parca(id: 'b', bytes: Uint8List.fromList(<int>[9, 9, 9]));

    final hazir = await KiyafetGorselHazirlayici.hazirla(<Kiyafet>[saglam, bozuk]);

    expect(hazir.uzunluk, 1);
    expect(hazir.parcalar.single.id, 'a');
    expect(hazir.gorseller.single.isNotEmpty, isTrue);
    expect(hazir.bosMu, isFalse);
  });

  test('hazırla: enFazla sınırına uyar', () async {
    final parcalar = <Kiyafet>[
      parca(id: 'a', bytes: testPng(genislik: 400, yukseklik: 400)),
      parca(id: 'b', bytes: testPng(genislik: 400, yukseklik: 400)),
      parca(id: 'c', bytes: testPng(genislik: 400, yukseklik: 400)),
    ];

    final hazir = await KiyafetGorselHazirlayici.hazirla(parcalar, enFazla: 2);

    expect(hazir.uzunluk, 2);
    expect(hazir.parcalar.map((k) => k.id).toList(), <String>['a', 'b']);
  });

  test('önbellek: aynı parça ikinci kez kodlanmaz', () async {
    final tek = parca(id: 'a', bytes: testPng(genislik: 400, yukseklik: 400));

    final ilk = await KiyafetGorselHazirlayici.hazirlaTek(tek);
    final ikinci = await KiyafetGorselHazirlayici.hazirlaTek(tek);

    expect(identical(ilk, ikinci), isTrue);
  });
}
