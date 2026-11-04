// "Bugün" ekranının kural bazlı beyni.
//
// İki iş yapar:
//  1. Akıllı raflar: giyilmeyenler, yeni eklenenler, bugünün havasına uygunlar.
//  2. Yapay zekâ çalışmadığında (kota, ağ, bozuk cevap) kombinleri kurallarla
//     üretir. Böylece ekran hiçbir zaman boş kalmaz.
//
// Tamamen yereldir: ağ çağrısı yapmaz, aynı gün için aynı sonucu üretir
// (günün tarihi tohum olarak kullanılır). Böylece kullanıcı ekranı her
// açtığında kartlar zıplamaz.

import 'dart:math';

import '../models/bugun_kombin.dart';
import '../models/kiyafet.dart';
import '../utils/hava_uygunlugu.dart';
import '../utils/kategori_utils.dart';

class AkilliRaflar {
  AkilliRaflar._();

  /// "2 haftadır giymediklerin" rafı için varsayılan eşik (gün).
  static const int varsayilanGiyilmediGunu = 14;

  /// "Yeni eklenenler" rafı için varsayılan eşik (gün).
  static const int varsayilanYeniGunu = 7;

  /// Bir rafta gösterilecek en fazla parça.
  static const int varsayilanRafSiniri = 10;

  /// Son [gun] gündür giyilmemiş parçalar; en uzun süre giyilmeyen başta.
  ///
  /// Hiç giyilmemiş bir parça için eklenme tarihi esas alınır: yeni alınmış bir
  /// ürün "aylardır giyilmiyor" diye işaretlenmemeli.
  static List<Kiyafet> ikiHaftadirGiymedikler(
    List<Kiyafet> dolap, {
    DateTime? simdi,
    int gun = varsayilanGiyilmediGunu,
    int enFazla = varsayilanRafSiniri,
  }) {
    final an = simdi ?? DateTime.now();
    final esik = an.subtract(Duration(days: gun));

    final secilen = <Kiyafet>[];
    for (final kiyafet in dolap) {
      final son = kiyafet.sonGiyilmeTarihi ?? kiyafet.eklenmeTarihi;
      if (son.isBefore(esik)) secilen.add(kiyafet);
    }

    secilen.sort((a, b) {
      final sa = a.sonGiyilmeTarihi ?? a.eklenmeTarihi;
      final sb = b.sonGiyilmeTarihi ?? b.eklenmeTarihi;
      return sa.compareTo(sb);
    });

    return secilen.take(enFazla).toList(growable: false);
  }

  /// Son [gun] günde eklenen parçalar; en yeni başta.
  static List<Kiyafet> yeniEklenenler(
    List<Kiyafet> dolap, {
    DateTime? simdi,
    int gun = varsayilanYeniGunu,
    int enFazla = varsayilanRafSiniri,
  }) {
    final an = simdi ?? DateTime.now();
    final esik = an.subtract(Duration(days: gun));

    final secilen =
        dolap.where((k) => k.eklenmeTarihi.isAfter(esik)).toList();
    secilen.sort((a, b) => b.eklenmeTarihi.compareTo(a.eklenmeTarihi));
    return secilen.take(enFazla).toList(growable: false);
  }

  /// Bugünün havasına uygun, sepette olmayan parçalar.
  ///
  /// Hava bilgisi yoksa boş liste döner: "bugüne uygun" başlığı altında
  /// rastgele parça göstermek yanıltıcı olur.
  static List<Kiyafet> havayaUygunlar(
    List<Kiyafet> dolap,
    String havaMetni, {
    int enFazla = varsayilanRafSiniri,
  }) {
    final kosul = havaKosuluCikar(havaMetni);
    if (kosul == null) return const <Kiyafet>[];

    final temiz = dolap.where((k) => !k.sepetteMi).toList();
    final uygun = havayaUygunKiyafetler(temiz, kosul);
    return uygun.take(enFazla).toList(growable: false);
  }

  /// Dolaptan kurallarla kombin üretir.
  ///
  /// Yapay zekâ cevap veremediğinde devreye girer; aynı gün + aynı dolap için
  /// her zaman aynı sonucu üretir. Üst ve alt yoksa boş liste döner: yarım
  /// kombin göstermek yerine "dolabını doldur" çağrısı daha doğru.
  static List<BugunKombin> kurallIleKombinler(
    List<Kiyafet> dolap, {
    int adet = 5,
    DateTime? gun,
    HavaKosulu? hava,
  }) {
    if (adet <= 0) return const <BugunKombin>[];

    // Sepetteki (yıkanmayı bekleyen) parçalar son tercih; yeterli temiz parça
    // varsa hiç kullanılmaz.
    final temiz = dolap.where((k) => !k.sepetteMi).toList();
    final havuz = temiz.length >= 3 ? temiz : dolap;
    if (havuz.isEmpty) return const <BugunKombin>[];

    final gruplar = <String, List<Kiyafet>>{};
    for (final kiyafet in havuz) {
      final kod = kategoriModeldenCikar(kiyafet.kategori);
      if (kod.isEmpty) continue;
      gruplar.putIfAbsent(kod, () => <Kiyafet>[]).add(kiyafet);
    }

    final ustler = _hazirla(gruplar['ust'], hava);
    final altlar = _hazirla(gruplar['alt'], hava);
    if (ustler.isEmpty || altlar.isEmpty) return const <BugunKombin>[];

    final ayakkabilar = _hazirla(gruplar['ayakkabi'], hava);
    final disGiyim = _hazirla(gruplar['dis'], hava);

    // Gün + dolap boyutu tohumu: gün içinde kararlı, günden güne çeşitli.
    final an = gun ?? DateTime.now();
    final tohum = an.year * 1000 +
        an.difference(DateTime(an.year)).inDays * 37 +
        dolap.length * 11 +
        (hava?.index ?? 0) +
        ustler.length * 3 +
        altlar.length * 5;
    final rastgele = Random(tohum);

    // En uzun süre giyilmeyenler önde; günlük döndürme ile ilk kart da değişir.
    final ustKaydir = rastgele.nextInt(ustler.length);
    final altKaydir = rastgele.nextInt(altlar.length);
    final ayakkabiKaydir =
        ayakkabilar.isEmpty ? 0 : rastgele.nextInt(ayakkabilar.length);

    // Sıcak havada ceket/mont önermek kullanıcıyı kaybettirir.
    final disEklenebilir =
        disGiyim.isNotEmpty && hava != HavaKosulu.sicak;

    final sonuc = <BugunKombin>[];
    final gorulen = <String>{};

    // Üst × alt sayısı yetmezse döngü kendini tekrar etmesin diye sınır var.
    final enFazlaDeneme = adet * 6;
    for (var i = 0; i < enFazlaDeneme && sonuc.length < adet; i++) {
      final ust = ustler[(ustKaydir + i) % ustler.length];
      final alt = altlar[(altKaydir + i) % altlar.length];
      if (ust.id == alt.id) continue;

      final idler = <String>[ust.id, alt.id];
      if (ayakkabilar.isNotEmpty) {
        idler.add(ayakkabilar[(ayakkabiKaydir + i) % ayakkabilar.length].id);
      }
      if (disEklenebilir && i.isEven) {
        idler.add(disGiyim[i % disGiyim.length].id);
      }

      final kombin = BugunKombin(
        baslik: '${ust.gorunenBaslik} + ${alt.gorunenBaslik}',
        kiyafetIdleri: idler,
      );
      if (!gorulen.add(kombin.anahtar)) continue;
      sonuc.add(kombin);
    }

    return List<BugunKombin>.unmodifiable(sonuc);
  }

  /// Kategori listesini hava filtresinden geçirir ve "en uzun süre
  /// giyilmeyen önde" olacak şekilde sıralar.
  static List<Kiyafet> _hazirla(List<Kiyafet>? liste, HavaKosulu? hava) {
    if (liste == null || liste.isEmpty) return const <Kiyafet>[];
    final uygun = havayaUygunKiyafetler(liste, hava);
    final sirali = List<Kiyafet>.from(uygun);
    sirali.sort((a, b) {
      final sa = a.sonGiyilmeTarihi ?? a.eklenmeTarihi;
      final sb = b.sonGiyilmeTarihi ?? b.eklenmeTarihi;
      return sa.compareTo(sb);
    });
    return sirali;
  }
}
