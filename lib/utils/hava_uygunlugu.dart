import 'dart:math';

import '../models/kiyafet.dart';

/// Kıyafet seçiminde kullanılan hava koşulu sınıfları.
enum HavaKosulu {
  /// Kışlık hava: kalın parçalar gerekir, yazlık parçalar giyilmemeli.
  soguk,

  /// Ne yazlık ne kışlık parçanın yasak olmadığı ılıman hava.
  iliman,

  /// Yaz havası: kalın/kışlık parçalar giyilmemeli.
  sicak,
}

/// Bir kıyafetin hangi hava koşullarında giyilebileceği.
enum KiyafetSicaklikSeviyesi {
  /// Sadece sıcak hava: şort, keten, askılı, sandalet gibi ince parçalar.
  yazlik,

  /// Her mevsim giyilebilir ya da kıyafet hakkında bilgi yok (varsayılan).
  herMevsim,

  /// Sadece soğuk hava: mont, kaban, yün, kalın triko, bot gibi parçalar.
  kislik,
}

/// Kıyafetin `mevsim` alanında tutulan etiket değerleri.
const String mevsimEtiketiKislik = 'kislik';
const String mevsimEtiketiYazlik = 'yazlik';
const String mevsimEtiketiDortMevsim = 'dort_mevsim';

/// En yüksek sıcaklık bu değerin (°C) altındaysa gün soğuk sayılır.
/// `ana_ekran.dart` içindeki "Soğuk" etiket eşiği ile aynıdır.
const double sogukHavaSiniri = 12;

/// En yüksek sıcaklık bu değere (°C) eşit veya üstündeyse gün sıcak sayılır.
/// `ana_ekran.dart` içindeki "Güneşli/Sıcak" etiket eşiği ile aynıdır.
const double sicakHavaSiniri = 28;

/// Sabah/akşam bu değerin (°C) altına düşen gün, gündüz sıcak olsa bile
/// kalın bir kat gerektirebilir.
const double serinSabahSiniri = 5;

/// `"İstanbul • 15°C / 24°C — Parçalı Bulutlu"` gibi bir günlük hava metninden
/// sıcaklıkları Celsius'a çevirerek çıkarır.
///
/// Hiç sıcaklık bulunamazsa (konum kapalı, izin verilmedi veya veri yükleniyor)
/// boş liste döner.
List<double> havaSicakliklariniCikar(String havaMetni) {
  final eslesmeler = RegExp(
    r'(-?\d+(?:[.,]\d+)?)\s*°\s*([CF])?',
    caseSensitive: false,
  ).allMatches(havaMetni);
  if (eslesmeler.isEmpty) return const <double>[];

  final fahrenheitMi = havaMetni.toUpperCase().contains('°F') ||
      eslesmeler
          .any((eslesme) => (eslesme.group(2) ?? '').toUpperCase() == 'F');

  final sonuclar = <double>[];
  for (final eslesme in eslesmeler) {
    final deger = double.tryParse(
      (eslesme.group(1) ?? '').replaceAll(',', '.'),
    );
    if (deger == null) continue;
    sonuclar.add(fahrenheitMi ? (deger - 32) * 5 / 9 : deger);
  }
  return sonuclar;
}

/// Günlük hava metninden hava koşulunu çıkarır.
///
/// Sıcaklık okunamıyorsa null döner; bu durumda mevsim filtresi uygulanmaz.
/// Haftalık planda gün adı olarak kullanılan kanonik (İngilizce) gün adları,
/// pazartesiden başlayarak.
const List<String> kanonikGunAdlari = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];

/// Haftalık tahmin satırlarından (`"Cumartesi: 12°C / 20°C, Güneşli"` gibi,
/// ilk satır bugüne ait) verilen günün hava metnini çıkarır.
///
/// [gunAdi] kanonik gün adı olmalıdır; eşleşme yoksa, ilgili satır
/// bulunamazsa veya satırda sıcaklık yoksa (ör. tahmin yüklenemedi metni)
/// boş dize döner.
String haftalikTahminGunHavasi({
  required String gunAdi,
  required List<String> tahminSatirlari,
  required int bugununHaftaGunu,
}) {
  final gunIndex = kanonikGunAdlari.indexOf(gunAdi.trim());
  if (gunIndex == -1) return '';

  final satirlar = tahminSatirlari
      .map((satir) => satir.trim())
      .where((satir) => satir.isNotEmpty)
      .toList();
  final fark = (gunIndex - (bugununHaftaGunu - 1) + 7) % 7;
  if (fark >= satirlar.length) return '';

  final satir = satirlar[fark];
  final ayirici = satir.indexOf(':');
  final hava = (ayirici == -1 ? satir : satir.substring(ayirici + 1)).trim();
  return RegExp(r'\d').hasMatch(hava) ? hava : '';
}

HavaKosulu? havaKosuluCikar(String havaMetni) {
  final sicakliklar = havaSicakliklariniCikar(havaMetni);
  if (sicakliklar.isEmpty) return null;

  final enYuksek = sicakliklar.reduce(max);
  final enDusuk = sicakliklar.reduce(min);

  if (enYuksek >= sicakHavaSiniri) return HavaKosulu.sicak;
  if (enYuksek <= sogukHavaSiniri || enDusuk <= serinSabahSiniri) {
    return HavaKosulu.soguk;
  }
  return HavaKosulu.iliman;
}

/// Kıyafetin sıcaklık seviyesi: önce yapay zekânın kaydettiği `mevsim`
/// etiketi, yoksa ürün adı/renk/stil/kategori içindeki anahtar kelimeler.
KiyafetSicaklikSeviyesi kiyafetSicaklikSeviyesi(Kiyafet kiyafet) {
  final etiket = kiyafet.mevsim?.trim().toLowerCase();
  if (etiket == mevsimEtiketiKislik) return KiyafetSicaklikSeviyesi.kislik;
  if (etiket == mevsimEtiketiYazlik) return KiyafetSicaklikSeviyesi.yazlik;
  if (etiket == mevsimEtiketiDortMevsim) {
    return KiyafetSicaklikSeviyesi.herMevsim;
  }

  final kelimeler = _kelimelereAyir(
    '${kiyafet.baslik} ${kiyafet.kullaniciBasligi ?? ''} '
    '${kiyafet.renk} ${kiyafet.stil} ${kiyafet.kategori}',
  );

  // Kışlık kelimeler önce kontrol edilir: "Yün Şort" gibi çelişkili adlarda
  // kumaş bilgisi kazanır.
  if (_eslesiyorMu(kelimeler, _kislikKelimeler)) {
    return KiyafetSicaklikSeviyesi.kislik;
  }
  if (_eslesiyorMu(kelimeler, _yazlikKelimeler)) {
    return KiyafetSicaklikSeviyesi.yazlik;
  }
  return KiyafetSicaklikSeviyesi.herMevsim;
}

/// Kıyafetin yapay zekâ istemlerinde gösterilecek mevsim etiketi.
String kiyafetMevsimEtiketi(Kiyafet kiyafet) {
  switch (kiyafetSicaklikSeviyesi(kiyafet)) {
    case KiyafetSicaklikSeviyesi.kislik:
      return mevsimEtiketiKislik;
    case KiyafetSicaklikSeviyesi.yazlik:
      return mevsimEtiketiYazlik;
    case KiyafetSicaklikSeviyesi.herMevsim:
      return mevsimEtiketiDortMevsim;
  }
}

/// [kiyafet] verilen hava koşulunda giyilebilir mi?
bool kiyafetHavayaUygunMu(Kiyafet kiyafet, HavaKosulu hava) {
  final seviye = kiyafetSicaklikSeviyesi(kiyafet);
  switch (hava) {
    case HavaKosulu.soguk:
      return seviye != KiyafetSicaklikSeviyesi.yazlik;
    case HavaKosulu.sicak:
      return seviye != KiyafetSicaklikSeviyesi.kislik;
    case HavaKosulu.iliman:
      return true;
  }
}

/// Listeyi hava koşuluna göre filtreler.
///
/// Uygun parça kalmadığında (dolap çok küçük olduğunda) filtre gevşetilir ve
/// orijinal liste döner, böylece kombin üretimi hiçbir zaman boş kalmaz.
List<Kiyafet> havayaUygunKiyafetler(
    List<Kiyafet> kiyafetler, HavaKosulu? hava) {
  if (hava == null || kiyafetler.length <= 1) return kiyafetler;
  final uygunlar = kiyafetler
      .where((kiyafet) => kiyafetHavayaUygunMu(kiyafet, hava))
      .toList();
  return uygunlar.isEmpty ? kiyafetler : uygunlar;
}

/// Yapay zekânın döndürdüğü mevsim değerini standart etikete çevirir.
///
/// Anlaşılmayan bir değer gelirse null döner; bu durumda kıyafetin mevsimi ürün
/// adındaki anahtar kelimelerden tahmin edilir.
String? mevsimEtiketiniNormallestir(Object? hamDeger) {
  final metin =
      (hamDeger ?? '').toString().toLowerCase().replaceAll('\u0130', 'i');
  if (metin.trim().isEmpty) return null;

  if (metin.contains('kis') ||
      metin.contains('kış') ||
      metin.contains('winter') ||
      metin.contains('cold') ||
      metin.contains('soguk') ||
      metin.contains('soğuk') ||
      metin.contains('hiver') ||
      metin.contains('invierno') ||
      metin.contains('inverno')) {
    return mevsimEtiketiKislik;
  }
  if (metin.contains('yaz') ||
      metin.contains('summer') ||
      metin.contains('sommer') ||
      metin.contains('verano') ||
      metin.contains('estate') ||
      metin.contains('hot') ||
      metin.contains('sicak') ||
      metin.contains('sıcak')) {
    return mevsimEtiketiYazlik;
  }
  if (metin.contains('dort') ||
      metin.contains('dört') ||
      metin.contains('four') ||
      metin.contains('all') ||
      metin.contains('her')) {
    return mevsimEtiketiDortMevsim;
  }
  return null;
}

/// Parça metnindeki dolap numarasını (1 tabanlı) çıkarır.
///
/// `"Clean Item #3: ..."` ve `"Temiz Parça 3: ..."` biçimlerini destekler.
int? kiyafetIndeksiniCikar(String metin) {
  final eslesme = RegExp(
    r'(?:Clean Item|Temiz Parça)\s*#?\s*(\d+)',
    caseSensitive: false,
  ).firstMatch(metin);
  return int.tryParse(eslesme?.group(1) ?? '');
}

/// Yapay zekânın ürettiği haftalık plandaki parçaları günlerin havasına göre
/// denetler ve uygun olmayan parçaları dolaptan aynı kategoride uygun bir
/// parçayla değiştirir (deterministik düzeltme).
///
/// - Değişim her zaman aynı kategori içinde yapıldığından günün üst/alt/
///   ayakkabı düzeni ve "aynı parça iki günde kullanılmaz" kuralı korunur.
/// - Uygun alternatif bulunamazsa parça olduğu gibi bırakılır; bu yüzden
///   fonksiyon planı asla bozmaz.
/// - Hava metni okunamayan günlere (konum kapalı vb.) dokunulmaz.
/// - [baslangicIndex]'ten önceki günler (kullanıcının giydiği bugün) sadece
///   "kullanılmış parça" olarak hesaba katılır, değiştirilmez.
///
/// [hafta] içindeki günlerin `{'parcalar': [...]}` yapısında olması beklenir.
/// [tahminSatirlari] satır sırası gün sırasıyla aynıdır: `i`. gün
/// `tahminSatirlari[i]` ile eşleşir.
///
/// Değiştirme yapılan günlerin indekslerini döndürür.
Set<int> haftalikPlaniHavayaUygunlastir({
  required List<dynamic> hafta,
  required List<Kiyafet> kiyafetler,
  required List<String> tahminSatirlari,
  required String Function(String kategori) kategoriCozucu,
  int baslangicIndex = 0,
}) {
  final degisenGunIndeksleri = <int>{};
  if (kiyafetler.isEmpty || hafta.isEmpty) return degisenGunIndeksleri;

  List<int> gununIndeksleri(dynamic gun) {
    if (gun is! Map || gun['parcalar'] is! List) return const <int>[];
    return (gun['parcalar'] as List)
        .map((parca) => kiyafetIndeksiniCikar(parca.toString()))
        .whereType<int>()
        .toList();
  }

  HavaKosulu? gununHavaKosulu(dynamic gun, int gunIndex) {
    if (gunIndex >= 0 && gunIndex < tahminSatirlari.length) {
      final kosul = havaKosuluCikar(tahminSatirlari[gunIndex]);
      if (kosul != null) return kosul;
    }
    if (gun is! Map) return null;
    return havaKosuluCikar((gun['gunluk_hava'] ?? '').toString());
  }

  Kiyafet? yedekParca(
    Kiyafet mevcut,
    HavaKosulu hava,
    Set<String> kullanilanIdler,
  ) {
    final kategori = kategoriCozucu(mevcut.kategori);
    if (kategori.isEmpty) return null;

    for (final aday in kiyafetler) {
      if (aday.id == mevcut.id) continue;
      if (kategoriCozucu(aday.kategori) != kategori) continue;
      if (!kiyafetHavayaUygunMu(aday, hava)) continue;
      if (kategori != 'ayakkabi' && kullanilanIdler.contains(aday.id)) {
        continue;
      }
      return aday;
    }
    return null;
  }

  final kullanilanIdler = <String>{};
  for (final gun in hafta) {
    for (final indeks in gununIndeksleri(gun)) {
      if (indeks < 1 || indeks > kiyafetler.length) continue;
      final parca = kiyafetler[indeks - 1];
      if (kategoriCozucu(parca.kategori) != 'ayakkabi') {
        kullanilanIdler.add(parca.id);
      }
    }
  }

  for (var i = baslangicIndex; i < hafta.length; i++) {
    final gun = hafta[i];
    if (gun is! Map) continue;
    final mevcutParcalar = gun['parcalar'];
    if (mevcutParcalar is! List || mevcutParcalar.isEmpty) continue;

    final havaKosulu = gununHavaKosulu(gun, i);
    if (havaKosulu == null) continue;

    var degistirildi = false;
    final yeniParcalar = <String>[];
    for (final hamParca in mevcutParcalar) {
      final metin = hamParca.toString();
      final indeks = kiyafetIndeksiniCikar(metin);
      if (indeks == null || indeks < 1 || indeks > kiyafetler.length) {
        yeniParcalar.add(metin);
        continue;
      }

      final mevcut = kiyafetler[indeks - 1];
      if (kiyafetHavayaUygunMu(mevcut, havaKosulu)) {
        yeniParcalar.add(metin);
        continue;
      }

      final yedek = yedekParca(mevcut, havaKosulu, kullanilanIdler);
      if (yedek == null) {
        yeniParcalar.add(metin);
        continue;
      }

      kullanilanIdler.remove(mevcut.id);
      kullanilanIdler.add(yedek.id);
      degistirildi = true;
      final yedekIndeks = kiyafetler.indexOf(yedek) + 1;
      final kategori = kategoriCozucu(yedek.kategori);
      yeniParcalar.add(
        'Clean Item #$yedekIndeks: ${yedek.baslik} [Category: $kategori] '
        '(Color: ${yedek.renk}, Style: ${yedek.stil})',
      );
    }

    gun['parcalar'] = yeniParcalar;
    if (degistirildi) degisenGunIndeksleri.add(i);
  }

  return degisenGunIndeksleri;
}

List<String> _kelimelereAyir(String metin) {
  final duzeltilmis =
      metin.toLowerCase().replaceAll('\u0130', 'i').replaceAll('\u0307', '');
  return duzeltilmis
      .split(RegExp(r'[^a-z0-9çğıöşü]+'))
      .where((kelime) => kelime.isNotEmpty)
      .toList();
}

bool _eslesiyorMu(List<String> kelimeler, List<String> anahtarlar) {
  for (final anahtar in anahtarlar) {
    for (final kelime in kelimeler) {
      if (kelime.startsWith(anahtar)) return true;
    }
  }
  return false;
}

/// Soğuk havada tercih edilen, sıcak havada önerilmemesi gereken parçalar.
const List<String> _kislikKelimeler = <String>[
  // Türkçe
  'mont', 'kaban', 'palto', 'parka', 'trençkot', 'kazak', 'kazağ', 'hırka',
  'hirka', 'triko', 'süveter', 'suveter', 'yün', 'yun', 'kaşmir', 'kasmir',
  'polar', 'şişme', 'sisme', 'yelek', 'bot', 'çizme', 'cizme', 'atkı', 'atki',
  'bere', 'eldiven', 'kalın', 'kalin', 'kışlık', 'kislik', 'kürk', 'kurk',
  'tüylü', 'tuylu', 'astarlı', 'astarli',
  // İngilizce
  'coat', 'overcoat', 'trench', 'puffer', 'quilted', 'sweater', 'pullover',
  'cardigan', 'knit', 'wool', 'cashmere', 'fleece', 'turtleneck', 'thermal',
  'down', 'boot', 'scarf', 'glove', 'beanie', 'winter', 'thick', 'warm',
  'snow', 'shearling', 'tweed', 'flannel', 'corduroy', 'hoodie', 'sweatshirt',
  // Almanca
  'mantel', 'jacke', 'stiefel', 'schal', 'mütze', 'mutze', 'wolle', 'dick',
  'gefüttert', 'gefuettert',
  // Fransızca
  'manteau', 'bottes', 'botte', 'laine', 'doudoune', 'écharpe', 'echarpe',
  'hiver',
  // İspanyolca
  'abrigo', 'bufanda', 'botas', 'bota', 'lana', 'jersey', 'invierno', 'plumas',
  // İtalyanca
  'cappotto', 'sciarpa', 'stivali', 'maglione', 'inverno', 'piumino',
  // Portekizce
  'casaco', 'cachecol', 'luva',
];

/// Sıcak havada tercih edilen, soğuk havada önerilmemesi gereken parçalar.
///
/// Etek/triko gibi hem kışın hem yazın giyilebilen parçalar bilinçli olarak
/// listeye alınmadı; yanlış eleme yapmamak için sadece net yazlık parçalar
/// burada yer alır.
const List<String> _yazlikKelimeler = <String>[
  // Türkçe
  'şort', 'sort', 'keten', 'askılı', 'askili', 'kolsuz', 'ince', 'sandalet',
  'terlik', 'mayo', 'bikini', 'yazlık', 'yazlik', 'plaj', 'şifon', 'sifon',
  // İngilizce
  'short', 'linen', 'sleeveless', 'tank', 'sandal', 'flip', 'swim', 'summer',
  'thin', 'lightweight', 'halter', 'chiffon',
  // Almanca
  'kurz', 'leinen', 'sandalen', 'sommer', 'dünn', 'dunn',
  // Fransızca
  'sandales',
  // İspanyolca
  'corto', 'lino', 'sandalias', 'verano',
  // İtalyanca
  'canotta', 'estate',
  // Portekizce
  'curto', 'linho', 'sandálias',
];
