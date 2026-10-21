// Dolap rafları ve arama/filtre kuralları.
//
// Ekrandan ayrı tutuluyor: hem arama davranışı hem de "hangi parça hangi
// rafta" kuralı saf fonksiyon olarak test edilebilsin.

import '../models/kiyafet.dart';
import 'kategori_utils.dart';

/// Rafların sırası ve kodları.
const List<String> dolapRaflari = <String>['ust', 'alt', 'ayakkabi', 'aksesuar'];

/// Aksesuar sayılan kelimeler. `kategoriModeldenCikar` dış giyim ile aksesuarı
/// aynı koda ('dis') indirdiği için burada ayrıca bakılıyor.
const List<String> _aksesuarKelimeleri = <String>[
  'aksesuar',
  'accessor',
  'çanta',
  'canta',
  'bag',
  'kemer',
  'belt',
  'şapka',
  'sapka',
  'hat',
  'gözlük',
  'gozluk',
  'glasses',
  'atkı',
  'atki',
  'scarf',
  'eldiven',
  'glove',
  'takı',
  'taki',
  'kolye',
  'küpe',
  'kupe',
  'bileklik',
  'saat',
  'watch',
];

/// Kayıtlı kategori ne olursa olsun parçayı doğru rafa yerleştirir.
///
/// AI bazen 'ceket', 'üst', 'pantolon', 'shoes' gibi serbest metin döndürüyor;
/// bu değerler doğrudan karşılaştırıldığında parça hiçbir rafta görünmüyordu.
/// 'dis' (ceket/mont) üst rafına, tanınmayan değerler de üst rafına düşer ki
/// parça kaybolmasın.
String dolapRafKategorisi(Kiyafet kiyafet) {
  final ham = kiyafet.kategori.toLowerCase().trim();
  if (_aksesuarKelimeleri.any(ham.contains)) {
    return 'aksesuar';
  }
  switch (kategoriModeldenCikar(ham)) {
    case 'alt':
      return 'alt';
    case 'ayakkabi':
      return 'ayakkabi';
    default:
      return 'ust';
  }
}

/// Arama metni + kategori filtresi uygular.
///
/// [kategori] `'tumu'` ise kategori filtresi yok sayılır. Arama; başlık, renk,
/// stil ve kayıtlı kategori metninde büyük/küçük harf duyarsız çalışır.
List<Kiyafet> dolapFiltrele(
  List<Kiyafet> parcalar, {
  String sorgu = '',
  String kategori = 'tumu',
}) {
  final aranan = sorgu.trim().toLowerCase();
  return parcalar.where((kiyafet) {
    if (kategori != 'tumu' && dolapRafKategorisi(kiyafet) != kategori) {
      return false;
    }
    if (aranan.isEmpty) return true;
    final metin =
        '${kiyafet.baslik} ${kiyafet.renk} ${kiyafet.stil} ${kiyafet.kategori}'
            .toLowerCase();
    return metin.contains(aranan);
  }).toList();
}
