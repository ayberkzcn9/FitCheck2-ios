// Seyahat / valiz modu: dolaptan minimum parçayla maksimum kombin.
//
// Mantık tamamen yerel ve deterministik: ağ yok, yapay zekâ yok. Aynı dolap +
// aynı seçimler her zaman aynı listeyi üretir (testlerde doğrulanabilir).
//
// Kapsül kuralı:
//  - 2-3 alt, ceil(gün / alt) kadar üst → gün sayısı kadar kombin çıkar
//  - hava sıcaksa dış giyim yok, ılımansa 1, soğuksa 2
//  - 1-2 ayakkabı (uzun yolculukta 2)
//  - kirli (sepette) parçalar ve mevsime uymayanlar hiç seçilmez

import '../models/kiyafet.dart';
import '../utils/kategori_utils.dart';

enum SeyahatHava { sicak, iliman, soguk }

enum SeyahatAmac { gunluk, isGezisi, ozel }

/// Valiz sonucu.
class ValizPlani {
  const ValizPlani({
    required this.gunSayisi,
    required this.ustler,
    required this.altlar,
    required this.disGiyim,
    required this.ayakkabilar,
    required this.eksikler,
  });

  final int gunSayisi;
  final List<Kiyafet> ustler;
  final List<Kiyafet> altlar;
  final List<Kiyafet> disGiyim;
  final List<Kiyafet> ayakkabilar;

  /// Eksik kategoriler: `ust`, `alt`, `ayakkabi`, `kombin`.
  final List<String> eksikler;

  List<Kiyafet> get parcalar => <Kiyafet>[
        ...ustler,
        ...altlar,
        ...disGiyim,
        ...ayakkabilar,
      ];

  int get parcaSayisi => parcalar.length;

  /// Kaç farklı kombin çıkar (üst × alt).
  int get kombinSayisi => ustler.length * altlar.length;

  bool get yeterli => kombinSayisi >= gunSayisi;

  bool get bos => parcalar.isEmpty;
}

class ValizPlanlayici {
  ValizPlanlayici._();

  static ValizPlani hesapla({
    required List<Kiyafet> gardirobum,
    required int gunSayisi,
    required SeyahatHava hava,
    required SeyahatAmac amac,
  }) {
    final gun = gunSayisi.clamp(1, 30);

    final uygun = gardirobum
        .where((k) => !k.sepetteMi)
        .where((k) => _mevsimeUygun(k, hava))
        .toList();

    final ustler = uygun.where((k) => kategoriModeldenCikar(k.kategori) == 'ust');
    final altlar = uygun.where((k) => kategoriModeldenCikar(k.kategori) == 'alt');
    final disler = uygun.where((k) => kategoriModeldenCikar(k.kategori) == 'dis');
    final ayakkabilar =
        uygun.where((k) => kategoriModeldenCikar(k.kategori) == 'ayakkabi');

    final altHedef = gun <= 6 ? 2 : 3;
    final secilenAltlar = _sec(altlar, altHedef, renkCesitli: true);

    final altSayisi = secilenAltlar.isEmpty ? 1 : secilenAltlar.length;
    final hesaplananUst = (gun / altSayisi).ceil();
    // Tek günlük gezide tek üst yeter; daha uzun gezide en az 2 üst
    // (kullanıcı aynı üstü iki gün üst üste giymesin).
    final ustHedef =
        (gun == 1 ? 1 : (hesaplananUst < 2 ? 2 : hesaplananUst)).clamp(1, 6);
    final secilenUstler = _sec(ustler, ustHedef, renkCesitli: true);

    var disHedef = switch (hava) {
      SeyahatHava.sicak => 0,
      SeyahatHava.iliman => 1,
      SeyahatHava.soguk => 2,
    };
    if (amac != SeyahatAmac.gunluk && disHedef > 0) disHedef += 1;
    final secilenDisler = _sec(disler, disHedef, renkCesitli: false);

    final ayakkabiHedef = (gun >= 5 || amac != SeyahatAmac.gunluk) ? 2 : 1;
    final secilenAyakkabilar =
        _sec(ayakkabilar, ayakkabiHedef, renkCesitli: true);

    final eksikler = <String>[];
    if (secilenUstler.isEmpty) eksikler.add('ust');
    if (secilenAltlar.isEmpty) eksikler.add('alt');
    if (secilenAyakkabilar.isEmpty) eksikler.add('ayakkabi');

    final kombin = secilenUstler.length * secilenAltlar.length;
    if (secilenUstler.isNotEmpty &&
        secilenAltlar.isNotEmpty &&
        kombin < gun) {
      eksikler.add('kombin');
    }

    return ValizPlani(
      gunSayisi: gun,
      ustler: secilenUstler,
      altlar: secilenAltlar,
      disGiyim: secilenDisler,
      ayakkabilar: secilenAyakkabilar,
      eksikler: eksikler,
    );
  }

  /// En az giyilenler önce gelir (dolabı gerçekten kullan), sonra renk çeşitliliği.
  static List<Kiyafet> _sec(
    Iterable<Kiyafet> adaylar,
    int adet, {
    required bool renkCesitli,
  }) {
    if (adet <= 0) return const <Kiyafet>[];

    final sirali = adaylar.toList()
      ..sort((a, b) {
        final aTarih = a.sonGiyilmeTarihi;
        final bTarih = b.sonGiyilmeTarihi;
        if (aTarih == null && bTarih != null) return -1;
        if (aTarih != null && bTarih == null) return 1;
        if (aTarih != null && bTarih != null) {
          final karsilastir = aTarih.compareTo(bTarih);
          if (karsilastir != 0) return karsilastir;
        }
        final sayi = a.giyilmeSayisi.compareTo(b.giyilmeSayisi);
        if (sayi != 0) return sayi;
        return a.id.compareTo(b.id);
      });

    if (!renkCesitli) return sirali.take(adet).toList();

    // Önce farklı renklerden birer tane, sonra kalanlar.
    final secilen = <Kiyafet>[];
    final renkler = <String>{};
    for (final parca in sirali) {
      if (secilen.length >= adet) break;
      if (renkler.add(parca.renk.trim().toLowerCase())) secilen.add(parca);
    }
    for (final parca in sirali) {
      if (secilen.length >= adet) break;
      if (!secilen.contains(parca)) secilen.add(parca);
    }
    return secilen;
  }

  static bool _mevsimeUygun(Kiyafet kiyafet, SeyahatHava hava) {
    final mevsim = (kiyafet.mevsim ?? '').toLowerCase().trim();
    if (mevsim.isEmpty || mevsim == 'dort_mevsim') return true;
    return switch (hava) {
      SeyahatHava.sicak => mevsim != 'kislik',
      SeyahatHava.soguk => mevsim != 'yazlik',
      SeyahatHava.iliman => true,
    };
  }
}
