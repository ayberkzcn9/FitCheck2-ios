// Kesilmiş kıyafeti zemine yerleştirme (birleştirme) testleri.

import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;

import 'package:fitcheck/services/kiyafet_arka_plan_ozellestirici.dart';

/// 200×200 şeffaf PNG: ortada kırmızı bir kare, köşeler saydam.
Uint8List _kesimUret({int boyut = 200, int renk = 0xFFFF0000}) {
  final gorsel = img.Image(width: boyut, height: boyut, numChannels: 4);
  img.fill(gorsel, color: img.ColorRgba8(0, 0, 0, 0));
  img.fillRect(
    gorsel,
    x1: boyut ~/ 4,
    y1: boyut ~/ 4,
    x2: boyut * 3 ~/ 4,
    y2: boyut * 3 ~/ 4,
    color: img.ColorRgba8((renk >> 16) & 0xFF, (renk >> 8) & 0xFF, renk & 0xFF, 255),
  );
  return img.encodePng(gorsel);
}

/// Kırmızı (kesim) piksel sayısı — ölçek/kayma testleri için.
int _kirmiziPiksel(Uint8List veri) {
  final gorsel = img.decodeImage(veri)!;
  var sayac = 0;
  for (var y = 0; y < gorsel.height; y += 4) {
    for (var x = 0; x < gorsel.width; x += 4) {
      final p = gorsel.getPixel(x, y);
      if (p.r.toInt() > 200 && p.g.toInt() < 80) sayac++;
    }
  }
  return sayac;
}

void main() {
  group('zemin rengi', () {
    test('her zemin için renk var, saydam hariç', () {
      expect(
        KiyafetArkaPlanOzellestirici.zeminRengi(KirmaZemin.beyaz),
        0xFFFFFFFF,
      );
      expect(
        KiyafetArkaPlanOzellestirici.zeminRengi(KirmaZemin.kirikBeyaz),
        isNotNull,
      );
      expect(
        KiyafetArkaPlanOzellestirici.zeminRengi(KirmaZemin.acikGri),
        isNotNull,
      );
      expect(
        KiyafetArkaPlanOzellestirici.zeminRengi(KirmaZemin.saydam),
        isNull,
      );
    });
  });

  group('birleştirme', () {
    test('beyaz zemin: tuval kare ve zemin beyaz', () {
      final sonuc = KiyafetArkaPlanOzellestirici.birlestirDogrudan(
        _kesimUret(),
        zemin: KirmaZemin.beyaz,
      );

      final (genislik, yukseklik) = KiyafetArkaPlanOzellestirici.boyut(sonuc);
      expect(genislik, KiyafetArkaPlanOzellestirici.tuvalBoyutu);
      expect(yukseklik, KiyafetArkaPlanOzellestirici.tuvalBoyutu);

      // Üst kenar zemin renginde (kesim ortada).
      final renk = KiyafetArkaPlanOzellestirici.ustMerkezRengi(sonuc);
      expect(renk, isNotNull);
      final r = (renk! >> 16) & 0xFF;
      final g = (renk >> 8) & 0xFF;
      final b = renk & 0xFF;
      expect(r, 255);
      expect(g, 255);
      expect(b, 255);
    });

    test('kırık beyaz zemin uygulanır', () {
      final sonuc = KiyafetArkaPlanOzellestirici.birlestirDogrudan(
        _kesimUret(),
        zemin: KirmaZemin.kirikBeyaz,
      );

      final renk = KiyafetArkaPlanOzellestirici.ustMerkezRengi(sonuc);
      final beklenen = KiyafetArkaPlanOzellestirici.zeminRengi(
        KirmaZemin.kirikBeyaz,
      )!;
      expect(renk! & 0xFFFFFF, beklenen & 0xFFFFFF);
    });

    test('saydam zemin PNG üretir ve köşe saydam kalır', () {
      final sonuc = KiyafetArkaPlanOzellestirici.birlestirDogrudan(
        _kesimUret(),
        zemin: KirmaZemin.saydam,
      );

      final gorsel = img.decodeImage(sonuc);
      expect(gorsel, isNotNull);
      // PNG imzası (JPEG değil).
      expect(sonuc[0], 0x89);
      expect(sonuc[1], 0x50);

      final kose = gorsel!.getPixel(4, 4);
      expect(kose.a.toInt(), lessThan(20));
    });

    test('opak zemin JPEG üretir', () {
      final sonuc = KiyafetArkaPlanOzellestirici.birlestirDogrudan(
        _kesimUret(),
        zemin: KirmaZemin.beyaz,
      );
      // JPEG imzası (FFD8).
      expect(sonuc[0], 0xFF);
      expect(sonuc[1], 0xD8);
    });

    test('ölçek büyütme kesimi büyütür', () {
      final kucuk = KiyafetArkaPlanOzellestirici.birlestirDogrudan(
        _kesimUret(),
        zemin: KirmaZemin.beyaz,
        olcek: 1,
      );
      final buyuk = KiyafetArkaPlanOzellestirici.birlestirDogrudan(
        _kesimUret(),
        zemin: KirmaZemin.beyaz,
        olcek: 2,
      );

      // Büyük hâlde kesim daha çok piksel kaplar.
      expect(_kirmiziPiksel(buyuk), greaterThan(_kirmiziPiksel(kucuk)));
    });

    test('kayma kesimi yukarı taşır (üst kenarda kesim görünür)', () {
      final sonuc = KiyafetArkaPlanOzellestirici.birlestirDogrudan(
        _kesimUret(),
        zemin: KirmaZemin.beyaz,
        olcek: 1,
        konumY: -0.4,
      );

      final gorsel = img.decodeImage(sonuc)!;
      // Üst kenarda artık kırmızı var (kesim yukarı kaydı).
      final p = gorsel.getPixel(gorsel.width ~/ 2, 2);
      expect(p.r.toInt(), greaterThan(200));
    });

    test('bozuk görsel girdi olduğunda girdi aynen döner', () {
      final bozuk = Uint8List.fromList([1, 2, 3, 4]);
      final sonuc = KiyafetArkaPlanOzellestirici.birlestirDogrudan(
        bozuk,
        zemin: KirmaZemin.beyaz,
      );
      expect(sonuc, bozuk);
    });
  });

  test('hesaplama arka planda da aynı sonucu verir', () async {
    final sonuc = await KiyafetArkaPlanOzellestirici.birlestir(
      _kesimUret(),
      zemin: KirmaZemin.acikGri,
    );
    final (genislik, yukseklik) = KiyafetArkaPlanOzellestirici.boyut(sonuc);
    expect(genislik, KiyafetArkaPlanOzellestirici.tuvalBoyutu);
    expect(yukseklik, KiyafetArkaPlanOzellestirici.tuvalBoyutu);
  });
}
