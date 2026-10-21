// Dolap raf eşlemesi ve arama/filtre kuralları.

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';

import 'package:fitcheck/models/kiyafet.dart';
import 'package:fitcheck/utils/dolap_filtresi.dart';

final Uint8List _png = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8B'
  'QDwAEhQGAhKmMIQAAAABJRU5ErkJggg==',
);

Kiyafet _kiyafet(
  String id,
  String kategori, {
  String renk = 'Siyah',
  String stil = 'Regular',
}) {
  return Kiyafet(
    id: id,
    baslik: id,
    kategori: kategori,
    resimBytes: _png,
    renk: renk,
    stil: stil,
    eklenmeTarihi: DateTime(2026, 1, 1),
  );
}

void main() {
  group('raf kategorisi', () {
    test('standart dört kategori olduğu gibi kalır', () {
      expect(dolapRafKategorisi(_kiyafet('a', 'ust')), 'ust');
      expect(dolapRafKategorisi(_kiyafet('b', 'alt')), 'alt');
      expect(dolapRafKategorisi(_kiyafet('c', 'ayakkabi')), 'ayakkabi');
      expect(dolapRafKategorisi(_kiyafet('d', 'aksesuar')), 'aksesuar');
    });

    test('AI serbest metni doğru rafa düşer', () {
      // Eskiden bunlar hiçbir rafta görünmüyordu.
      expect(dolapRafKategorisi(_kiyafet('e', 'ceket')), 'ust');
      expect(dolapRafKategorisi(_kiyafet('f', 'mont')), 'ust');
      expect(dolapRafKategorisi(_kiyafet('g', 'pantolon')), 'alt');
      expect(dolapRafKategorisi(_kiyafet('h', 'etek')), 'alt');
      expect(dolapRafKategorisi(_kiyafet('i', 'sneaker')), 'ayakkabi');
      expect(dolapRafKategorisi(_kiyafet('j', 'çanta')), 'aksesuar');
      expect(dolapRafKategorisi(_kiyafet('k', 'gözlük')), 'aksesuar');
    });

    test('büyük harf ve boşluk toleransı', () {
      expect(dolapRafKategorisi(_kiyafet('l', '  ÜST ')), 'ust');
      expect(dolapRafKategorisi(_kiyafet('m', 'Aksesuar')), 'aksesuar');
    });

    test('tanınmayan kategori kaybolmaz, üst rafına düşer', () {
      expect(dolapRafKategorisi(_kiyafet('n', 'bilinmiyor')), 'ust');
      expect(dolapRafKategorisi(_kiyafet('o', '')), 'ust');
    });
  });

  group('arama ve filtre', () {
    final parcalar = [
      _kiyafet('Beyaz Tişört', 'ust', renk: 'Beyaz'),
      _kiyafet('Siyah Pantolon', 'alt'),
      _kiyafet('Deri Ceket', 'ceket'),
      _kiyafet('Beyaz Sneaker', 'ayakkabi', renk: 'Beyaz'),
      _kiyafet('Hasır Çanta', 'aksesuar', renk: 'Bej'),
      _kiyafet('Yün Kazak', 'ust', renk: 'Gri', stil: 'Oversize'),
    ];

    test('boş sorgu ve "tumu" her şeyi döndürür', () {
      expect(dolapFiltrele(parcalar).length, parcalar.length);
      expect(dolapFiltrele(parcalar, kategori: 'tumu').length, parcalar.length);
    });

    test('başlıkta arama büyük/küçük harf duyarsız', () {
      final sonuc = dolapFiltrele(parcalar, sorgu: 'beyaz');
      expect(sonuc.map((k) => k.baslik), ['Beyaz Tişört', 'Beyaz Sneaker']);
    });

    test('renk ve stilde arama', () {
      expect(dolapFiltrele(parcalar, sorgu: 'gri').single.baslik, 'Yün Kazak');
      expect(
        dolapFiltrele(parcalar, sorgu: 'oversize').single.baslik,
        'Yün Kazak',
      );
    });

    test('kategori filtresi raf eşlemesini kullanır', () {
      // 'ceket' üst rafına düşer, bu yüzden "Üst" filtresinde görünür.
      final ustler = dolapFiltrele(parcalar, kategori: 'ust');
      expect(ustler.map((k) => k.baslik),
          ['Beyaz Tişört', 'Deri Ceket', 'Yün Kazak']);
      expect(dolapFiltrele(parcalar, kategori: 'aksesuar').single.baslik,
          'Hasır Çanta');
    });

    test('kategori + sorgu birlikte çalışır', () {
      final sonuc =
          dolapFiltrele(parcalar, kategori: 'ust', sorgu: 'ceket');
      expect(sonuc.single.baslik, 'Deri Ceket');
    });

    test('eşleşme yoksa boş liste', () {
      expect(dolapFiltrele(parcalar, sorgu: 'palto'), isEmpty);
    });

    test('baş/son boşluklar sorguyu bozmaz', () {
      expect(dolapFiltrele(parcalar, sorgu: '  sneaker  ').single.baslik,
          'Beyaz Sneaker');
    });
  });
}
