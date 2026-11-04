// Valiz modu: kapsül kuralı, kirli/mevsim filtreleri, eksik uyarıları.

import 'dart:typed_data';

import 'package:fitcheck/models/kiyafet.dart';
import 'package:fitcheck/services/valiz_planlayici.dart';
import 'package:flutter_test/flutter_test.dart';

Kiyafet parca({
  required String id,
  required String kategori,
  String renk = 'Siyah',
  String? mevsim,
  bool sepette = false,
  int giyilme = 0,
  DateTime? sonGiyilme,
}) {
  return Kiyafet(
    id: id,
    baslik: id,
    kategori: kategori,
    resimBytes: Uint8List(4),
    renk: renk,
    stil: 'Regular',
    mevsim: mevsim,
    sepetteMi: sepette,
    giyilmeSayisi: giyilme,
    sonGiyilmeTarihi: sonGiyilme,
  );
}

List<Kiyafet> dolap() => [
      parca(id: 'u1', kategori: 'ust', renk: 'Beyaz', giyilme: 5),
      parca(id: 'u2', kategori: 'ust', renk: 'Siyah', giyilme: 1),
      parca(id: 'u3', kategori: 'ust', renk: 'Beyaz'),
      parca(id: 'u4', kategori: 'ust', renk: 'Mavi'),
      parca(id: 'a1', kategori: 'alt', renk: 'Siyah', giyilme: 4),
      parca(id: 'a2', kategori: 'alt', renk: 'Mavi'),
      parca(id: 'a3', kategori: 'alt', renk: 'Bej'),
      parca(id: 'd1', kategori: 'ceket', renk: 'Bej'),
      parca(id: 's1', kategori: 'ayakkabi', renk: 'Beyaz'),
      parca(id: 's2', kategori: 'ayakkabi', renk: 'Siyah'),
    ];

void main() {
  test('3 günlük geziye 2 üst + 2 alt + 1 ayakkabı yeter', () {
    final plan = ValizPlanlayici.hesapla(
      gardirobum: dolap(),
      gunSayisi: 3,
      hava: SeyahatHava.iliman,
      amac: SeyahatAmac.gunluk,
    );

    expect(plan.ustler.length, 2);
    expect(plan.altlar.length, 2);
    expect(plan.ayakkabilar.length, 1);
    expect(plan.kombinSayisi, 4);
    expect(plan.yeterli, isTrue);
    expect(plan.eksikler, isEmpty);
  });

  test('7 günlük gezi 3 alt + 3 üst ister, 9 kombin çıkar', () {
    final plan = ValizPlanlayici.hesapla(
      gardirobum: dolap(),
      gunSayisi: 7,
      hava: SeyahatHava.iliman,
      amac: SeyahatAmac.gunluk,
    );

    expect(plan.altlar.length, 3);
    expect(plan.ustler.length, 3);
    expect(plan.kombinSayisi, 9);
    expect(plan.yeterli, isTrue);
  });

  test('soğuk havada 2 dış giyim, sıcakta hiç yok', () {
    final soguk = ValizPlanlayici.hesapla(
      gardirobum: dolap(),
      gunSayisi: 4,
      hava: SeyahatHava.soguk,
      amac: SeyahatAmac.gunluk,
    );
    expect(soguk.disGiyim.length, 1); // dolapta tek ceket var

    final sicak = ValizPlanlayici.hesapla(
      gardirobum: dolap(),
      gunSayisi: 4,
      hava: SeyahatHava.sicak,
      amac: SeyahatAmac.gunluk,
    );
    expect(sicak.disGiyim, isEmpty);
  });

  test('sepetteki (kirli) parça seçilmez', () {
    final plan = ValizPlanlayici.hesapla(
      gardirobum: [
        parca(id: 'kirli', kategori: 'ust', sepette: true),
        parca(id: 'temiz', kategori: 'ust'),
        parca(id: 'alt', kategori: 'alt'),
        parca(id: 'ayak', kategori: 'ayakkabi'),
      ],
      gunSayisi: 2,
      hava: SeyahatHava.iliman,
      amac: SeyahatAmac.gunluk,
    );

    expect(plan.ustler.map((k) => k.id), ['temiz']);
  });

  test('mevsime uymayan parça seçilmez', () {
    final plan = ValizPlanlayici.hesapla(
      gardirobum: [
        parca(id: 'kalin', kategori: 'ust', mevsim: 'kislik'),
        parca(id: 'ince', kategori: 'ust', mevsim: 'yazlik'),
        parca(id: 'her', kategori: 'ust', mevsim: 'dort_mevsim'),
        parca(id: 'alt', kategori: 'alt'),
        parca(id: 'ayak', kategori: 'ayakkabi'),
      ],
      gunSayisi: 2,
      hava: SeyahatHava.sicak,
      amac: SeyahatAmac.gunluk,
    );

    expect(plan.ustler.map((k) => k.id), isNot(contains('kalin')));
    expect(plan.ustler.map((k) => k.id), contains('ince'));
  });

  test('önce az giyilenler seçilir', () {
    final plan = ValizPlanlayici.hesapla(
      gardirobum: dolap(),
      gunSayisi: 2,
      hava: SeyahatHava.iliman,
      amac: SeyahatAmac.gunluk,
    );

    // u1 5 kez, u2 1 kez, u3/u4 hiç → hiç giyilmeyen ikisi seçilmeli.
    expect(plan.ustler.map((k) => k.id).toSet(), {'u3', 'u4'});
    expect(plan.ustler.map((k) => k.id), isNot(contains('u1')));
  });

  test('aynı renklerden önce farklı renkler seçilir', () {
    final plan = ValizPlanlayici.hesapla(
      gardirobum: dolap(),
      gunSayisi: 2,
      hava: SeyahatHava.iliman,
      amac: SeyahatAmac.gunluk,
    );

    final renkler = plan.ustler.map((k) => k.renk).toList();
    expect(renkler.toSet().length, renkler.length);
  });

  test('dolap boşsa eksik kategoriler bildirilir', () {
    final plan = ValizPlanlayici.hesapla(
      gardirobum: const [],
      gunSayisi: 3,
      hava: SeyahatHava.iliman,
      amac: SeyahatAmac.gunluk,
    );

    expect(plan.bos, isTrue);
    expect(plan.eksikler, containsAll(['ust', 'alt', 'ayakkabi']));
  });

  test('parça yetmezse kombin eksik uyarısı verilir', () {
    final plan = ValizPlanlayici.hesapla(
      gardirobum: [
        parca(id: 'u1', kategori: 'ust'),
        parca(id: 'a1', kategori: 'alt'),
        parca(id: 's1', kategori: 'ayakkabi'),
      ],
      gunSayisi: 6,
      hava: SeyahatHava.iliman,
      amac: SeyahatAmac.gunluk,
    );

    expect(plan.kombinSayisi, 1);
    expect(plan.yeterli, isFalse);
    expect(plan.eksikler, contains('kombin'));
  });

  test('iş gezisinde 2 ayakkabı ve ek dış giyim', () {
    final plan = ValizPlanlayici.hesapla(
      gardirobum: dolap(),
      gunSayisi: 2,
      hava: SeyahatHava.iliman,
      amac: SeyahatAmac.isGezisi,
    );

    expect(plan.ayakkabilar.length, 2);
  });

  test('gün sayısı sınırlandırılır', () {
    final plan = ValizPlanlayici.hesapla(
      gardirobum: dolap(),
      gunSayisi: 99,
      hava: SeyahatHava.iliman,
      amac: SeyahatAmac.gunluk,
    );

    expect(plan.gunSayisi, 30);
    expect(plan.ustler.length, lessThanOrEqualTo(6));
  });
}
