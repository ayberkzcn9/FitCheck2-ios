// "Bugün" ekranının mantık testleri.
//
// Kapsam:
//  - Akıllı raflar (giyilmeyenler, yeniler, havaya uygunlar)
//  - Kural bazlı kombin üretimi (deterministik, tekrarsız, üst+alt zorunlu)
//  - Yapay zekâ cevabının doğrulanması (uydurma id, yarım kombin, tekrar)
//  - Akış önbelleğinin parmak izi
//
// Ağ çağrısı YAPILMAZ: AiService'e hiç gidilmez, yalnızca saf fonksiyonlar
// sınanır. Gerçek akış cihazda ayrıca denenir.

import 'dart:typed_data';

import 'package:fitcheck/models/bugun_kombin.dart';
import 'package:fitcheck/models/kiyafet.dart';
import 'package:fitcheck/services/akilli_raflar.dart';
import 'package:fitcheck/services/bugun_feed_servisi.dart';
import 'package:fitcheck/utils/hava_uygunlugu.dart';
import 'package:flutter_test/flutter_test.dart';

Kiyafet kiyafet({
  required String id,
  required String kategori,
  String? baslik,
  String renk = 'Siyah',
  String? mevsim,
  bool sepette = false,
  int giyilme = 0,
  DateTime? sonGiyilme,
  DateTime? eklenme,
}) {
  return Kiyafet(
    id: id,
    baslik: baslik ?? 'Parça $id',
    kategori: kategori,
    resimBytes: Uint8List(4),
    renk: renk,
    stil: 'Regular',
    mevsim: mevsim,
    sepetteMi: sepette,
    giyilmeSayisi: giyilme,
    sonGiyilmeTarihi: sonGiyilme,
    eklenmeTarihi: eklenme ?? DateTime(2026, 1, 1),
  );
}

void main() {
  final simdi = DateTime(2026, 10, 20, 9);

  group('AkilliRaflar.ikiHaftadirGiymedikler', () {
    test('son 14 gündür giyilmeyenleri getirir, yeni giyileni getirmez', () {
      final dolap = [
        kiyafet(
          id: 'eski',
          kategori: 'ust',
          sonGiyilme: simdi.subtract(const Duration(days: 40)),
        ),
        kiyafet(
          id: 'taze',
          kategori: 'ust',
          sonGiyilme: simdi.subtract(const Duration(days: 2)),
        ),
      ];

      final sonuc =
          AkilliRaflar.ikiHaftadirGiymedikler(dolap, simdi: simdi);

      expect(sonuc.map((k) => k.id), ['eski']);
    });

    test('hiç giyilmemiş parça için eklenme tarihi kullanılır', () {
      final dolap = [
        kiyafet(id: 'yeni', kategori: 'ust', eklenme: simdi),
        kiyafet(
          id: 'bekleyen',
          kategori: 'ust',
          eklenme: simdi.subtract(const Duration(days: 60)),
        ),
      ];

      final sonuc =
          AkilliRaflar.ikiHaftadirGiymedikler(dolap, simdi: simdi);

      expect(sonuc.map((k) => k.id), ['bekleyen']);
    });

    test('en uzun süre giyilmeyen başta gelir', () {
      final dolap = [
        kiyafet(
          id: 'orta',
          kategori: 'alt',
          sonGiyilme: simdi.subtract(const Duration(days: 20)),
        ),
        kiyafet(
          id: 'cok',
          kategori: 'alt',
          sonGiyilme: simdi.subtract(const Duration(days: 90)),
        ),
      ];

      final sonuc =
          AkilliRaflar.ikiHaftadirGiymedikler(dolap, simdi: simdi);

      expect(sonuc.map((k) => k.id), ['cok', 'orta']);
    });
  });

  group('AkilliRaflar.yeniEklenenler', () {
    test('son 7 günde eklenenleri yeniden eskiye sıralar', () {
      final dolap = [
        kiyafet(id: 'a', kategori: 'ust', eklenme: simdi.subtract(const Duration(days: 2))),
        kiyafet(id: 'b', kategori: 'ust', eklenme: simdi.subtract(const Duration(days: 30))),
        kiyafet(id: 'c', kategori: 'ust', eklenme: simdi),
      ];

      final sonuc = AkilliRaflar.yeniEklenenler(dolap, simdi: simdi);

      expect(sonuc.map((k) => k.id), ['c', 'a']);
    });
  });

  group('AkilliRaflar.havayaUygunlar', () {
    test('hava bilgisi yoksa raf boş döner', () {
      final dolap = [kiyafet(id: 'a', kategori: 'ust')];
      expect(AkilliRaflar.havayaUygunlar(dolap, ''), isEmpty);
      expect(AkilliRaflar.havayaUygunlar(dolap, 'Bilinmiyor'), isEmpty);
    });

    test('sıcak günde kışlık parça rafa girmez', () {
      final dolap = [
        kiyafet(id: 'tisort', kategori: 'ust', baslik: 'Beyaz Tişört', mevsim: 'yazlik'),
        kiyafet(id: 'kazak', kategori: 'ust', baslik: 'Yün Kazak', mevsim: 'kislik'),
      ];

      final sonuc = AkilliRaflar.havayaUygunlar(dolap, 'İstanbul • 31°C • Güneşli');

      expect(sonuc.map((k) => k.id), contains('tisort'));
      expect(sonuc.map((k) => k.id), isNot(contains('kazak')));
    });

    test('sepetteki parça rafa girmez', () {
      final dolap = [
        kiyafet(id: 'temiz', kategori: 'ust', baslik: 'Tişört', mevsim: 'yazlik'),
        kiyafet(
          id: 'kirli',
          kategori: 'ust',
          baslik: 'Gömlek',
          mevsim: 'yazlik',
          sepette: true,
        ),
      ];

      final sonuc = AkilliRaflar.havayaUygunlar(dolap, '28°C');

      expect(sonuc.map((k) => k.id), ['temiz']);
    });
  });

  group('AkilliRaflar.kurallIleKombinler', () {
    List<Kiyafet> dolap() => [
          kiyafet(id: 'u1', kategori: 'ust'),
          kiyafet(id: 'u2', kategori: 'ust'),
          kiyafet(id: 'a1', kategori: 'alt'),
          kiyafet(id: 'a2', kategori: 'alt'),
          kiyafet(id: 's1', kategori: 'ayakkabi'),
        ];

    test('üst veya alt yoksa kombin üretmez', () {
      final sadeceUst = [kiyafet(id: 'u1', kategori: 'ust')];
      expect(AkilliRaflar.kurallIleKombinler(sadeceUst), isEmpty);

      final sadeceAlt = [kiyafet(id: 'a1', kategori: 'alt')];
      expect(AkilliRaflar.kurallIleKombinler(sadeceAlt), isEmpty);
    });

    test('her kombin en az bir üst ve bir alt içerir', () {
      final kombinler =
          AkilliRaflar.kurallIleKombinler(dolap(), adet: 4, gun: simdi);

      expect(kombinler, isNotEmpty);
      final indeks = {for (final k in dolap()) k.id: k};
      for (final kombin in kombinler) {
        final kodlar = kombin.kategoriKodlari(indeks);
        expect(kodlar, contains('ust'));
        expect(kodlar, contains('alt'));
      }
    });

    test('aynı gün ve aynı dolap için sonuç değişmez', () {
      final birinci =
          AkilliRaflar.kurallIleKombinler(dolap(), adet: 4, gun: simdi);
      final ikinci =
          AkilliRaflar.kurallIleKombinler(dolap(), adet: 4, gun: simdi);

      expect(
        birinci.map((k) => k.anahtar).toList(),
        ikinci.map((k) => k.anahtar).toList(),
      );
    });

    test('kombinler birbirini tekrar etmez', () {
      final kombiler =
          AkilliRaflar.kurallIleKombinler(dolap(), adet: 4, gun: simdi);
      final anahtarlar = kombiler.map((k) => k.anahtar).toList();

      expect(anahtarlar.toSet().length, anahtarlar.length);
    });

    test('sıcak havada dış giyim eklenmez', () {
      final genis = [
        ...dolap(),
        kiyafet(id: 'd1', kategori: 'ceket', baslik: 'Yün Kaban'),
      ];

      final serin = AkilliRaflar.kurallIleKombinler(
          genis, adet: 4, gun: simdi, hava: HavaKosulu.soguk);
      final sicak = AkilliRaflar.kurallIleKombinler(
          genis, adet: 4, gun: simdi, hava: HavaKosulu.sicak);

      expect(
        serin.any((k) => k.kiyafetIdleri.contains('d1')),
        isTrue,
        reason: 'soğuk havada ceket önerilmeli',
      );
      expect(
        sicak.any((k) => k.kiyafetIdleri.contains('d1')),
        isFalse,
        reason: 'sıcak havada ceket önerilmemeli',
      );
    });
  });

  group('BugunFeedServisi.ayikla', () {
    final indeks = {
      'u1': kiyafet(id: 'u1', kategori: 'ust'),
      'a1': kiyafet(id: 'a1', kategori: 'alt'),
      's1': kiyafet(id: 's1', kategori: 'ayakkabi'),
    };

    test('geçerli cevabı okur', () {
      final cevap = '''
{"kombinler":[{"baslik":"Ofis","aciklama":"Sade ve temiz","idler":["u1","a1","s1"]}]}
''';
      final sonuc = BugunFeedServisi().ayikla(cevap: cevap, indeks: indeks);

      expect(sonuc, hasLength(1));
      expect(sonuc.first.baslik, 'Ofis');
      expect(sonuc.first.kiyafetIdleri, ['u1', 'a1', 's1']);
    });

    test('markdown çiti içindeki JSON da okunur', () {
      const cevap = 'İşte sonuç:\n```json\n'
          '{"kombinler":[{"baslik":"X","idler":["u1","a1"]}]}\n```';
      final sonuc = BugunFeedServisi().ayikla(cevap: cevap, indeks: indeks);

      expect(sonuc, hasLength(1));
    });

    test('uydurma id atılır, tek parça kalan kombin gösterilmez', () {
      const cevap = '{"kombinler":['
          '{"baslik":"Uydurma","idler":["u1","yok-boyle-id"]},'
          '{"baslik":"Tek","idler":["u1"]}'
          ']}';
      final sonuc = BugunFeedServisi().ayikla(cevap: cevap, indeks: indeks);

      expect(sonuc, isEmpty);
    });

    test('üst/alt zorunlu: yarım kombin atılır', () {
      const cevap = '{"kombinler":['
          '{"baslik":"Sadece üst","idler":["u1","s1"]}'
          ']}';
      final sonuc = BugunFeedServisi().ayikla(cevap: cevap, indeks: indeks);

      expect(sonuc, isEmpty);
    });

    test('aynı kombin iki kez gelirse biri tutulur', () {
      const cevap = '{"kombinler":['
          '{"baslik":"A","idler":["u1","a1"]},'
          '{"baslik":"B","idler":["a1","u1"]}'
          ']}';
      final sonuc = BugunFeedServisi().ayikla(cevap: cevap, indeks: indeks);

      expect(sonuc, hasLength(1));
    });

    test('bozuk JSON çökmez, boş liste döner', () {
      expect(
        BugunFeedServisi().ayikla(cevap: 'cevap yok', indeks: indeks),
        isEmpty,
      );
      expect(
        BugunFeedServisi().ayikla(cevap: '{"kombinler": [}', indeks: indeks),
        isEmpty,
      );
    });

    test('başlık boşsa parça adlarından üretilir', () {
      const cevap = '{"kombinler":[{"baslik":"","idler":["u1","a1"]}]}';
      final sonuc = BugunFeedServisi().ayikla(cevap: cevap, indeks: indeks);

      expect(sonuc.single.baslik, 'Parça u1 + Parça a1');
    });
  });

  group('BugunFeedServisi.parmakIzi', () {
    test('aynı dolap + aynı gün aynı izi verir', () {
      final dolap = [kiyafet(id: 'u1', kategori: 'ust')];
      final a = BugunFeedServisi.parmakIzi(
          dolap: dolap, hava: '20°C', dil: 'tr', gun: '2026-10-20');
      final b = BugunFeedServisi.parmakIzi(
          dolap: dolap, hava: '20°C', dil: 'tr', gun: '2026-10-20');

      expect(a, b);
    });

    test('dolap değişince iz değişir', () {
      final a = BugunFeedServisi.parmakIzi(
        dolap: [kiyafet(id: 'u1', kategori: 'ust')],
        hava: '20°C',
        dil: 'tr',
        gun: '2026-10-20',
      );
      final b = BugunFeedServisi.parmakIzi(
        dolap: [
          kiyafet(id: 'u1', kategori: 'ust'),
          kiyafet(id: 'a1', kategori: 'alt'),
        ],
        hava: '20°C',
        dil: 'tr',
        gun: '2026-10-20',
      );

      expect(a, isNot(b));
    });

    test('gün değişince iz değişir', () {
      final dolap = [kiyafet(id: 'u1', kategori: 'ust')];
      final a = BugunFeedServisi.parmakIzi(
          dolap: dolap, hava: '20°C', dil: 'tr', gun: '2026-10-20');
      final b = BugunFeedServisi.parmakIzi(
          dolap: dolap, hava: '20°C', dil: 'tr', gun: '2026-10-21');

      expect(a, isNot(b));
    });

    test('gün anahtarı iki haneli yazılır', () {
      expect(BugunFeedServisi.gunAnahtari(DateTime(2026, 3, 7)), '2026-03-07');
    });
  });

  group('BugunKombin', () {
    test('sırasız da olsa aynı parça kümesi aynı anahtarı verir', () {
      const a = BugunKombin(baslik: 'A', kiyafetIdleri: ['u1', 'a1']);
      const b = BugunKombin(baslik: 'B', kiyafetIdleri: ['a1', 'u1']);

      expect(a.anahtar, b.anahtar);
    });

    test('silinen parça listeyi bozmaz', () {
      final indeks = {'u1': kiyafet(id: 'u1', kategori: 'ust')};
      const kombin = BugunKombin(baslik: 'A', kiyafetIdleri: ['u1', 'silinmis']);

      expect(kombin.parcalar(indeks), hasLength(1));
      expect(kombin.gecerliMi, isTrue);
    });

    test('JSON gidiş dönüşü bilgi kaybetmez', () {
      const kombin = BugunKombin(
        baslik: 'Ofis',
        aciklama: 'Sade',
        kiyafetIdleri: ['u1', 'a1'],
      );
      final geri = BugunKombin.fromJson(kombin.toJson());

      expect(geri.baslik, 'Ofis');
      expect(geri.aciklama, 'Sade');
      expect(geri.kiyafetIdleri, ['u1', 'a1']);
    });
  });
}
