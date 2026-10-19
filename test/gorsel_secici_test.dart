// Sohbette hangi parçaların fotoğrafının gönderileceğini seçen yardımcının
// testleri.
//
// Kritik davranışlar:
//  • Kullanıcı bir parçadan söz ettiyse (renk, tür, ad) o parça seçilir;
//    Türkçe ekler ve büyük/küçük harf farkları eşleşmeyi bozmaz.
//  • Parça adı geçmiyorsa hiç görsel gönderilmez (maliyet boşa gitmesin).
//  • En fazla 3 parça seçilir ve sıra gardıroptaki sıradır (prompt tutarlı olsun).
//
// Çalıştırma: flutter test test/gorsel_secici_test.dart
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';

import 'package:fitcheck/models/kiyafet.dart';
import 'package:fitcheck/utils/gorsel_secici.dart';

Kiyafet parca({
  required String id,
  required String baslik,
  required String kategori,
  required String renk,
  String stil = 'Casual',
}) {
  return Kiyafet(
    id: id,
    baslik: baslik,
    kategori: kategori,
    resimBytes: Uint8List.fromList(<int>[1, 2, 3]),
    renk: renk,
    stil: stil,
  );
}

void main() {
  final gomlek = parca(
    id: 'gomlek',
    baslik: 'Mavi Çizgili Gömlek',
    kategori: 'ust',
    renk: 'Mavi',
  );
  final pantolon = parca(
    id: 'pantolon',
    baslik: 'Siyah Kot Pantolon',
    kategori: 'alt',
    renk: 'Siyah',
  );
  final bot = parca(
    id: 'bot',
    baslik: 'Kahverengi Deri Bot',
    kategori: 'ayakkabi',
    renk: 'Kahverengi',
  );
  final dolap = <Kiyafet>[gomlek, pantolon, bot];

  test('renk ve tür geçen mesajda doğru parça seçilir', () {
    final secilen = ilgiliParcalariSec(
      mesaj: 'mavi gömlekle ne giyerim?',
      parcalar: dolap,
    );

    expect(secilen.map((k) => k.id), contains('gomlek'));
    expect(secilen.map((k) => k.id), isNot(contains('pantolon')));
  });

  test('büyük harf ve Türkçe ekler eşleşmeyi bozmaz', () {
    final secilen = ilgiliParcalariSec(
      mesaj: 'BOTUM İÇİN ne önerirsin',
      parcalar: dolap,
    );

    expect(secilen.map((k) => k.id), contains('bot'));
  });

  test('kıyafet adı geçmiyorsa görsel gönderilmez', () {
    final secilen = ilgiliParcalariSec(
      mesaj: 'bugün hava nasıl, ne yapsam?',
      parcalar: dolap,
    );

    expect(secilen, isEmpty);
  });

  test('yalnızca zayıf kısmi eşleşme varsa yeterli sayılmaz', () {
    // "kırmızı" hiçbir parçada yok; tek harf benzerliği görsel göndermeye değmez.
    final secilen = ilgiliParcalariSec(
      mesaj: 'kırmızı bir şey',
      parcalar: dolap,
    );

    expect(secilen, isEmpty);
  });

  test('en fazla 3 parça seçilir ve sıra gardırop sırasıdır', () {
    final genisDolap = <Kiyafet>[
      gomlek,
      pantolon,
      bot,
      parca(
          id: 'sapka',
          baslik: 'Mavi Şapka',
          kategori: 'aksesuar',
          renk: 'Mavi'),
      parca(id: 'atki', baslik: 'Mavi Atkı', kategori: 'aksesuar', renk: 'Mavi'),
    ];

    final secilen = ilgiliParcalariSec(
      mesaj: 'mavi parçalarla kombin yapar mısın',
      parcalar: genisDolap,
    );

    expect(secilen.length, 3);
    // Gardırop sırası korunur: gomlek (0) -> sapka (3) -> atki (4)
    expect(secilen.map((k) => k.id).toList(), <String>['gomlek', 'sapka', 'atki']);
  });

  test('boş gardırop ve enFazla=0 güvenli', () {
    expect(ilgiliParcalariSec(mesaj: 'mavi gömlek', parcalar: <Kiyafet>[]),
        isEmpty);
    expect(
      ilgiliParcalariSec(mesaj: 'mavi gömlek', parcalar: dolap, enFazla: 0),
      isEmpty,
    );
  });
}
