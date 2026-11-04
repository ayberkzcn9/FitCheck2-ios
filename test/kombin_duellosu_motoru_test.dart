// "Kombin Düellosu" motorunun testleri.
//
// Kapsam:
//  - Renk adı → renk ailesi çözümlemesi (Türkçe ekler, İngilizce yedekler)
//  - Renk uyumu puanı ve gerekçesi
//  - Dolaplı düello üretimi: doğru taraf = yüksek puanlı kart
//  - Hava ölçütlü turlar
//  - Boş dolapta renk kartına düşme
//  - Tohum verilince deterministik sonuç
//
// Ağ çağrısı yok; hepsi saf fonksiyon.

import 'dart:typed_data';

import 'package:fitcheck/models/kiyafet.dart';
import 'package:fitcheck/services/kombin_duellosu_motoru.dart';
import 'package:flutter_test/flutter_test.dart';

Kiyafet k({
  required String id,
  required String kategori,
  required String renk,
  String? mevsim,
  String? baslik,
}) {
  return Kiyafet(
    id: id,
    baslik: baslik ?? 'Parça $id',
    kategori: kategori,
    resimBytes: Uint8List(4),
    renk: renk,
    stil: 'Regular',
    mevsim: mevsim,
    eklenmeTarihi: DateTime(2026, 1, 1),
  );
}

void main() {
  group('renkAilesi', () {
    test('Türkçe renk adlarını ve eklerini tanır', () {
      expect(renkAilesi('Lacivert'), RenkAilesi.mavi);
      expect(renkAilesi('Açık Mavi'), RenkAilesi.mavi);
      expect(renkAilesi('Koyu Yeşil'), RenkAilesi.yesil);
      expect(renkAilesi('Bordo'), RenkAilesi.kirmizi);
      expect(renkAilesi('Antrasit'), RenkAilesi.notr);
      expect(renkAilesi('Ekru'), RenkAilesi.notr);
    });

    test('altın sarıdan, gümüş griden önce gelir', () {
      expect(renkAilesi('Altın'), RenkAilesi.metalik);
      expect(renkAilesi('Gümüş'), RenkAilesi.metalik);
    });

    test('tanınmayan ve boş değerler bilinmiyor döner', () {
      expect(renkAilesi('Bilinmiyor'), RenkAilesi.bilinmiyor);
      expect(renkAilesi(''), RenkAilesi.bilinmiyor);
      expect(renkAilesi('Çok Renkli Desen'), RenkAilesi.bilinmiyor);
    });
  });

  group('renkDegerlendir', () {
    test('nötr zemin + tek vurgu en yüksek puanı alır', () {
      final sonuc = renkDegerlendir(['Lacivert', 'Beyaz', 'Kahverengi']);
      expect(sonuc.puan, 92);
      expect(sonuc.sebep, DuelSebebi.vurgu);
    });

    test('tamamen nötr kombin dengelidir', () {
      final sonuc = renkDegerlendir(['Siyah', 'Beyaz', 'Gri']);
      expect(sonuc.puan, 88);
      expect(sonuc.sebep, DuelSebebi.notr);
    });

    test('tek renk ailesi bütünlük verir', () {
      final sonuc = renkDegerlendir(['Lacivert', 'Mavi', 'Lacivert']);
      expect(sonuc.puan, 78);
      expect(sonuc.sebep, DuelSebebi.monokrom);
    });

    test('komşu renkler, karşıt renklerden daha yüksek puan alır', () {
      final komsu = renkDegerlendir(['Mavi', 'Yeşil', 'Beyaz']);
      final zit = renkDegerlendir(['Mavi', 'Turuncu', 'Beyaz']);
      expect(komsu.puan, greaterThan(zit.puan));
      expect(komsu.sebep, DuelSebebi.analog);
      expect(zit.sebep, DuelSebebi.zit);
    });

    test('üç canlı renk en düşük puanı alır', () {
      final sonuc = renkDegerlendir(['Kırmızı', 'Yeşil', 'Mavi']);
      expect(sonuc.puan, 38);
      expect(sonuc.sebep, DuelSebebi.cokRenk);
    });

    test('köprüsüz iki uzak renk zayıf puanlanır', () {
      final sonuc = renkDegerlendir(['Kırmızı', 'Mavi', 'Beyaz']);
      expect(sonuc.puan, 52);
      expect(sonuc.sebep, DuelSebebi.dagink);
    });

    test('hiç tanınmayan renkler oyunu kilitlemez', () {
      final sonuc = renkDegerlendir(['Bilinmiyor', '']);
      expect(sonuc.puan, 70);
    });
  });

  group('DuelMotoru.uret — dolaplı', () {
    final dolap = <Kiyafet>[
      k(id: 'u1', kategori: 'ust', renk: 'Beyaz'),
      k(id: 'u2', kategori: 'ust', renk: 'Kırmızı'),
      k(id: 'u3', kategori: 'ust', renk: 'Lacivert'),
      k(id: 'a1', kategori: 'alt', renk: 'Siyah'),
      k(id: 'a2', kategori: 'alt', renk: 'Bej'),
      k(id: 'a3', kategori: 'alt', renk: 'Yeşil'),
      k(id: 'y1', kategori: 'ayakkabi', renk: 'Beyaz'),
      k(id: 'y2', kategori: 'ayakkabi', renk: 'Kahverengi'),
      k(id: 'y3', kategori: 'ayakkabi', renk: 'Mavi'),
    ];

    test('dolapla üretir, doğru taraf her zaman yüksek puanlı karttır', () {
      final seti = DuelMotoru()
          .uret(gardirobum: dolap, adet: 10, tohum: 42);

      expect(seti.paletKullanildi, isFalse);
      expect(seti.sorular, isNotEmpty);

      for (final soru in seti.sorular) {
        expect(soru.solDogru, soru.solPuan > soru.sagPuan);
        expect(soru.sol.paletMi, isFalse);
        expect(soru.sol.parcalar, isNotEmpty);
        expect(soru.solPuan, isNot(soru.sagPuan));
      }
    });

    test('aynı tur iki kez sorulmaz', () {
      final seti = DuelMotoru()
          .uret(gardirobum: dolap, adet: 10, tohum: 7);
      final idler = seti.sorular.map((s) => s.id).toSet();
      expect(idler.length, seti.sorular.length);
    });

    test('aynı tohum aynı soruları üretir', () {
      final a = DuelMotoru().uret(gardirobum: dolap, adet: 10, tohum: 99);
      final b = DuelMotoru().uret(gardirobum: dolap, adet: 10, tohum: 99);
      expect(a.sorular.map((s) => s.id), b.sorular.map((s) => s.id));
    });
  });

  group('DuelMotoru.uret — hava', () {
    final dolap = <Kiyafet>[
      k(id: 'k1', kategori: 'ust', renk: 'Lacivert', mevsim: 'kislik'),
      k(id: 'k2', kategori: 'ust', renk: 'Gri', mevsim: 'kislik'),
      k(id: 'y1', kategori: 'ust', renk: 'Beyaz', mevsim: 'yazlik'),
      k(id: 'y2', kategori: 'ust', renk: 'Sarı', mevsim: 'yazlik'),
      k(id: 'b1', kategori: 'alt', renk: 'Siyah', mevsim: 'kislik'),
      k(id: 'b2', kategori: 'alt', renk: 'Bej', mevsim: 'yazlik'),
      k(id: 's1', kategori: 'ayakkabi', renk: 'Kahverengi', mevsim: 'kislik'),
      k(id: 's2', kategori: 'ayakkabi', renk: 'Beyaz', mevsim: 'yazlik'),
    ];

    test('soğuk havada hava ölçütlü tur üretir', () {
      final seti = DuelMotoru().uret(
        gardirobum: dolap,
        gunlukHava: 'İstanbul 5°C Parçalı Bulutlu',
        adet: 10,
        tohum: 5,
      );

      final havaSorulari = seti.sorular
          .where((s) => s.olcu == DuelOlcusu.hava)
          .toList();
      expect(havaSorulari, isNotEmpty);

      for (final soru in havaSorulari) {
        expect(soru.kazananSebep, DuelSebebi.havaUygun);
        expect(soru.kaybedenSebep, DuelSebebi.havaHafif);
        expect(soru.solDogru, soru.solPuan > soru.sagPuan);
      }
    });

    test('hava metni yoksa hava ölçütü kullanılmaz', () {
      final seti = DuelMotoru()
          .uret(gardirobum: dolap, gunlukHava: '', adet: 10, tohum: 5);
      expect(
        seti.sorular.every((s) => s.olcu == DuelOlcusu.renk),
        isTrue,
      );
    });
  });

  group('DuelMotoru.uret — boş dolap', () {
    test('renk kartlarına düşer ve oyun yine oynanır', () {
      final seti = DuelMotoru()
          .uret(gardirobum: const <Kiyafet>[], adet: 10, tohum: 3);

      expect(seti.paletKullanildi, isTrue);
      expect(seti.sorular, hasLength(10));

      for (final soru in seti.sorular) {
        expect(soru.sol.paletMi, isTrue);
        expect(soru.sol.parcalar, hasLength(3));
        expect(soru.solDogru, soru.solPuan > soru.sagPuan);
        expect(soru.kazananSebep, isNotNull);
        expect(soru.kaybedenSebep, isNotNull);
      }
    });
  });

  group('geçersiz veri', () {
    test('tek parçalı dolap çökmez', () {
      final seti = DuelMotoru().uret(
        gardirobum: [k(id: 'tek', kategori: 'ust', renk: 'Siyah')],
        adet: 5,
        tohum: 1,
      );
      expect(seti.sorular, isNotEmpty);
      expect(seti.paletKullanildi, isTrue);
    });

    test('adet sıfır ise boş liste döner', () {
      final seti = DuelMotoru()
          .uret(gardirobum: const <Kiyafet>[], adet: 0, tohum: 1);
      expect(seti.sorular, isEmpty);
    });
  });
}
