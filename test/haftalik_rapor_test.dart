// Haftalık rapor: pencere, kullanım yüzdesi, seri ve önceki hafta karşılaştırması.

import 'dart:typed_data';

import 'package:fitcheck/models/kiyafet.dart';
import 'package:fitcheck/services/haftalik_rapor.dart';
import 'package:flutter_test/flutter_test.dart';

Kiyafet kiyafet(String id, {int giyilme = 0}) => Kiyafet(
      id: id,
      baslik: 'Parça $id',
      kategori: 'ust',
      resimBytes: Uint8List(4),
      renk: 'Siyah',
      stil: 'Regular',
      giyilmeSayisi: giyilme,
    );

void main() {
  final simdi = DateTime(2026, 10, 20, 21);

  Map<String, String> kayit(String tarih, String detay) =>
      {'tarih': tarih, 'baslik': 'Kombin $tarih', 'detay': detay};

  test('son 7 gün sayılır, eski kayıtlar sayılmaz', () {
    final rapor = HaftalikRaporVerisi.hesapla(
      gecmis: [
        kayit('2026-10-14', 'A, B'), // tam 6 gün önce → pencere içinde
        kayit('2026-10-13', 'A, B'), // 7 gün önce → dışarıda (önceki hafta)
        kayit('2026-10-19', 'C'), // dün
        kayit('2026-10-20', 'A, D'), // bugün
      ],
      gardirobum: [kiyafet('1'), kiyafet('2'), kiyafet('3', giyilme: 2)],
      simdi: simdi,
    );

    expect(rapor.kombinSayisi, 3);
    expect(rapor.oncekiHaftaKombinSayisi, 1);
    expect(rapor.degisim, 2);
    expect(rapor.farkliParcaSayisi, 4); // A, B, C, D
    expect(rapor.enCokParca, 'A');
    expect(rapor.enCokParcaAdet, 2);
    expect(rapor.toplamParcaSayisi, 3);
    expect(rapor.hicGiyilmemis, 2);
    expect(rapor.kullanimYuzdesi, 100); // 4 farklı parça / 3 dolap → sınırlandı
  });

  test('kullanım yüzdesi dolaba göre hesaplanır', () {
    final rapor = HaftalikRaporVerisi.hesapla(
      gecmis: [kayit('2026-10-20', 'A')],
      gardirobum: List.generate(10, (i) => kiyafet('$i')),
      simdi: simdi,
    );

    expect(rapor.farkliParcaSayisi, 1);
    expect(rapor.kullanimYuzdesi, 10);
  });

  test('seri bugünden geriye sayılır, boşlukta durur', () {
    final rapor = HaftalikRaporVerisi.hesapla(
      gecmis: [
        kayit('2026-10-20', 'A'),
        kayit('2026-10-19', 'A'),
        kayit('2026-10-18', 'A'),
        kayit('2026-10-16', 'A'), // 17 boş → seri 3'te durur
      ],
      gardirobum: const [],
      simdi: simdi,
    );

    expect(rapor.seriGun, 3);
    expect(rapor.gunler.length, 7);
    // 14 Ekim pencerenin ilk günü; 18, 19, 20 işaretli.
    expect(rapor.gunler, [false, false, true, false, true, true, true]);
  });

  test('bugün kayıt yoksa seri sıfırdır', () {
    final rapor = HaftalikRaporVerisi.hesapla(
      gecmis: [kayit('2026-10-19', 'A')],
      gardirobum: const [],
      simdi: simdi,
    );

    expect(rapor.seriGun, 0);
  });

  test('boş geçmişte rapor boş döner', () {
    final rapor = HaftalikRaporVerisi.hesapla(
      gecmis: const [],
      gardirobum: [kiyafet('1')],
      simdi: simdi,
    );

    expect(rapor.bos, isTrue);
    expect(rapor.kombinSayisi, 0);
    expect(rapor.enCokParca, isNull);
    expect(rapor.kullanimYuzdesi, 0);
  });

  test('bozuk tarihli kayıt çökertmez', () {
    final rapor = HaftalikRaporVerisi.hesapla(
      gecmis: [
        {'tarih': 'bozuk', 'baslik': 'x', 'detay': 'A'},
        kayit('2026-10-20', 'B'),
      ],
      gardirobum: const [],
      simdi: simdi,
    );

    expect(rapor.kombinSayisi, 1);
  });
}
