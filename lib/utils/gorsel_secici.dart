// Sohbette hangi parçaların FOTOĞRAFI gönderilmeli?
//
// Vision'ın maliyetini sınırlamak için sohbete her mesajda tüm gardırop
// gönderilemez (40 parça x ~200 token + saniyeler). Bunun yerine kullanıcının
// mesajında geçen kelimelere göre en fazla 3 parça seçilir:
//   • "mavi gömlekle ne giyerim?" -> mavi gömlek(lar)
//   • "siyah bot" -> siyah bot
//   • "bugün ne giysem?" (parça adı yok) -> hiç fotoğraf gönderilmez, sohbet
//     eskisi gibi metinle çalışır.
//
// Türkçe ekler ve büyük/küçük harf farkları için metin sadeleştirilir:
// "GÖMLEKLE" ile "Gömlek" eşleşir. Uzun kelimelerde kısmi eşleşme de sayılır
// ("gomlek" ⊂ "gomlekli"), ama zayıf eşleşmeler tek başına yeterli değildir.

import '../models/kiyafet.dart';

/// Kullanıcı mesajıyla eşleşen parçaları, gardıroptaki sırayı koruyarak döner.
///
/// [enFazla] sınırına takılırsa en yüksek puanlılar seçilir. Hiçbir parça
/// eşleşmezse boş liste döner (çağıran taraf görselsiz devam eder).
List<Kiyafet> ilgiliParcalariSec({
  required String mesaj,
  required List<Kiyafet> parcalar,
  int enFazla = 3,
}) {
  if (parcalar.isEmpty || enFazla <= 0) return const <Kiyafet>[];

  final mesajKelimeleri = _kelimelereAyir(mesaj);
  if (mesajKelimeleri.isEmpty) return const <Kiyafet>[];

  final puanlar = <String, int>{};
  for (final parca in parcalar) {
    final parcaKelimeleri = _kelimelereAyir(
      '${parca.gorunenBaslik} ${parca.kategori} ${parca.renk} ${parca.stil}',
    );
    if (parcaKelimeleri.isEmpty) continue;
    final puan = _puanla(mesajKelimeleri, parcaKelimeleri);
    if (puan >= _enAzPuan) puanlar[parca.id] = puan;
  }

  if (puanlar.isEmpty) return const <Kiyafet>[];

  // En yüksek puanlı [enFazla] parça belirlenir; eşit puanda gardırop sırası
  // belirleyici olur (sonuç her seferinde aynı olsun).
  final sirali = puanlar.entries.toList()
    ..sort((a, b) {
      final fark = b.value.compareTo(a.value);
      if (fark != 0) return fark;
      return parcalar.indexWhere((k) => k.id == a.key) -
          parcalar.indexWhere((k) => k.id == b.key);
    });
  final secilenler = <String>{};
  for (final giris in sirali) {
    if (secilenler.length >= enFazla) break;
    secilenler.add(giris.key);
  }

  // ...ve gardıroptaki sıraya göre döndürülür (promptta sıra tahmin edilemez
  // olmasın, karışık görünmesin).
  return parcalar.where((k) => secilenler.contains(k.id)).toList();
}

/// Tek bir parçanın mesajla ne kadar eşleştiğini ölçer.
///
/// +2: kelime birebir geçiyor ("mavi" -> "Mavi") ya da kullanıcı parçanın
///     kelimesini ekle uzatmış ("botum" -> "bot", "gömlekle" -> "gömlek").
/// +1: zayıf eşleşme (parçanın kelimesi kullanıcının kelimesini içeriyor:
///     "pant" -> "pantolon"). Tek başına görsel göndermeye yetmez.
int _puanla(Set<String> mesajKelimeleri, Set<String> parcaKelimeleri) {
  var puan = 0;
  for (final kelime in mesajKelimeleri) {
    if (parcaKelimeleri.contains(kelime)) {
      puan += 2;
      continue;
    }
    if (kelime.length < _enAzKelimeUzunlugu) continue;

    var kismiPuan = 0;
    for (final parcaKelimesi in parcaKelimeleri) {
      if (parcaKelimesi.length < _enAzKelimeUzunlugu) continue;
      if (kelime.startsWith(parcaKelimesi)) {
        kismiPuan = 2; // Türkçe ek: "botum" -> "bot"
        break;
      }
      if (parcaKelimesi.length >= _enAzKismiEslesmeUzunlugu &&
          (parcaKelimesi.contains(kelime) || kelime.contains(parcaKelimesi)) &&
          kismiPuan < 1) {
        kismiPuan = 1;
      }
    }
    puan += kismiPuan;
  }
  return puan;
}

/// Görsel göndermek için gereken en az puan. Tek bir tam kelime eşleşmesi (2)
/// yeter; yalnızca kısmi eşleşme (1) tek başına yetmez.
const int _enAzPuan = 2;

/// Metni küçük harfli, Türkçe karakterleri sadeleştirilmiş kelimelere ayırır.
Set<String> _kelimelereAyir(String metin) {
  final sade = _sadelestir(metin);
  return sade
      .split(RegExp(r'[^a-z0-9]+'))
      .where((k) => k.length >= _enAzKelimeUzunlugu)
      .toSet();
}

/// Türkçe karakterleri ASCII karşılıklarına indirger ve küçük harfe çevirir.
///
/// Dart'ın `toLowerCase`'i 'İ' harfini "i̇" (i + birleşen nokta) yaptığı için
/// önce elle dönüştürülür; aksi hâlde "GÖMLEK" ile "gömlek" eşleşmezdi.
String _sadelestir(String metin) {
  const degisim = <String, String>{
    'İ': 'i', 'I': 'i', 'ı': 'i',
    'Ş': 's', 'ş': 's',
    'Ğ': 'g', 'ğ': 'g',
    'Ü': 'u', 'ü': 'u',
    'Ö': 'o', 'ö': 'o',
    'Ç': 'c', 'ç': 'c',
  };
  final tampon = StringBuffer();
  for (final karakter in metin.split('')) {
    tampon.write(degisim[karakter] ?? karakter);
  }
  return tampon.toString().toLowerCase();
}

const int _enAzKelimeUzunlugu = 3;

/// Kısmi (içerme) eşleşme için gereken en az uzunluk; kısa kelimelerde
/// yanlış eşleşmeyi önler ("bot" ⊂ "botanik" gibi durumlar için).
const int _enAzKismiEslesmeUzunlugu = 4;
