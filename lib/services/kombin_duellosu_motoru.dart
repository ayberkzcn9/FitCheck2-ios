// "Kombin Düellosu" soru üreticisi.
//
// Oyunun kalbi burası: iki kombini yan yana koyup "hangisi daha uyumlu?"
// diye soruyoruz. Doğru cevap öznel değil, iki ölçütten birine göre
// hesaplanıyor:
//
//  1. Renk uyumu  — parçaların renk aileleri arasındaki ilişki.
//  2. Hava uyumu  — parçaların bugünkü sıcaklığa uygunluğu.
//
// Ölçüt her turda ekranda yazdığı için oyuncu neye göre seçim yaptığını
// bilir; geri bildirim de "neden" sorusunu yanıtlar.
//
// Dosya bilerek saf Dart: Flutter widget'ı yok, bu yüzden testte hızlı
// çalışıyor ve tek bir yerde doğrulanabiliyor.

import 'dart:math';
import 'dart:typed_data';

import '../models/kiyafet.dart';
import '../utils/hava_uygunlugu.dart';

/// Bir düellonun hangi ölçüte göre kazanıldığı.
enum DuelOlcusu { renk, hava }

/// Geri bildirimde gösterilen kısa gerekçe.
///
/// Metinler 12 dilde ARB dosyalarında; burada yalnızca anahtar var.
enum DuelSebebi {
  notr,
  monokrom,
  analog,
  vurgu,
  zit,
  dagink,
  cokRenk,
  havaUygun,
  havaAgir,
  havaHafif,
}

/// Kaba renk aileleri. Moda renk çarkı 6 dilim + temel tonlar.
enum RenkAilesi {
  notr,
  kahve,
  metalik,
  mavi,
  yesil,
  kirmizi,
  pembe,
  turuncu,
  sari,
  mor,
  bilinmiyor,
}

/// Kombindeki tek bir parça. Dolaplı düellolarda [kiyafet] dolu,
/// renk kartı düellolarında [paletRengi] dolu olur.
class DuelParca {
  const DuelParca({
    required this.kategori,
    required this.renk,
    this.resim,
    this.paletRengi,
    this.kiyafet,
  });

  final String kategori;
  final String renk;
  final Uint8List? resim;

  /// Renk kartı düellosunda parçanın ARGB rengi.
  final int? paletRengi;

  final Kiyafet? kiyafet;

  bool get paletMi => paletRengi != null;

  String get anahtar =>
      kiyafet?.id ?? 'palet:$kategori:$renk:${paletRengi ?? 0}';
}

/// Bir kombinin görsel kartı: üst, alt, ayakkabı.
class DuelKarti {
  const DuelKarti(this.parcalar);

  final List<DuelParca> parcalar;

  bool get paletMi => parcalar.any((p) => p.paletMi);

  String get anahtar => parcalar.map((p) => p.anahtar).join('|');
}

/// Ekrana basılmaya hazır tek bir tur.
class DuelSorusu {
  const DuelSorusu({
    required this.id,
    required this.olcu,
    required this.sol,
    required this.sag,
    required this.solDogru,
    required this.kazananSebep,
    required this.kaybedenSebep,
    required this.solPuan,
    required this.sagPuan,
  });

  final String id;
  final DuelOlcusu olcu;
  final DuelKarti sol;
  final DuelKarti sag;

  /// Doğru cevap sol kart mı?
  final bool solDogru;

  /// Kazanan kombinin güçlü yanı.
  final DuelSebebi kazananSebep;

  /// Kaybeden kombinin zayıf yanı.
  final DuelSebebi kaybedenSebep;

  final int solPuan;
  final int sagPuan;
}

/// Üretilen tur listesi + oyunun hangi modda oynandığı.
class DuelSeti {
  const DuelSeti({required this.sorular, required this.paletKullanildi});

  final List<DuelSorusu> sorular;

  /// Dolap yetersiz olduğu için renk kartlarına düşüldü mü?
  final bool paletKullanildi;

  bool get bosMu => sorular.isEmpty;
}

/// Renk uyumu sonucu: puan + kısa gerekçe.
class RenkDegerlendirme {
  const RenkDegerlendirme(this.puan, this.sebep);

  final int puan;
  final DuelSebebi sebep;
}

const Set<String> _gecerliKategoriler = <String>{'ust', 'alt', 'ayakkabi'};

/// Düelloda kullanılacak renk adlarının kökleri.
///
/// Sıra önemli: "altın" sarıdan önce, "gümüş" griden önce eşleşmeli.
/// Renkler yapay zekâ tarafından Türkçe üretildiği için Türkçe kökler
/// birincil; İngilizce karşılıklar da yedek olarak duruyor.
const List<(String, RenkAilesi)> _renkKokleri = <(String, RenkAilesi)>[
  ('antrasit', RenkAilesi.notr),
  ('fildişi', RenkAilesi.notr),
  ('fildisi', RenkAilesi.notr),
  ('beyaz', RenkAilesi.notr),
  ('siyah', RenkAilesi.notr),
  ('ekru', RenkAilesi.notr),
  ('krem', RenkAilesi.notr),
  ('vizon', RenkAilesi.notr),
  ('gri', RenkAilesi.notr),
  ('bej', RenkAilesi.notr),
  ('taş', RenkAilesi.notr),
  ('ivory', RenkAilesi.notr),
  ('white', RenkAilesi.notr),
  ('black', RenkAilesi.notr),
  ('grey', RenkAilesi.notr),
  ('gray', RenkAilesi.notr),
  ('beige', RenkAilesi.notr),
  ('altın', RenkAilesi.metalik),
  ('altin', RenkAilesi.metalik),
  ('gümüş', RenkAilesi.metalik),
  ('gumus', RenkAilesi.metalik),
  ('metalik', RenkAilesi.metalik),
  ('bronz', RenkAilesi.metalik),
  ('bakır', RenkAilesi.metalik),
  ('gold', RenkAilesi.metalik),
  ('silver', RenkAilesi.metalik),
  ('kahve', RenkAilesi.kahve),
  ('taba', RenkAilesi.kahve),
  ('kestane', RenkAilesi.kahve),
  ('camel', RenkAilesi.kahve),
  ('tütün', RenkAilesi.kahve),
  ('tutun', RenkAilesi.kahve),
  ('çikolata', RenkAilesi.kahve),
  ('cikolata', RenkAilesi.kahve),
  ('brown', RenkAilesi.kahve),
  ('lacivert', RenkAilesi.mavi),
  ('turkuaz', RenkAilesi.mavi),
  ('indigo', RenkAilesi.mavi),
  ('petrol', RenkAilesi.mavi),
  ('mavi', RenkAilesi.mavi),
  ('kot', RenkAilesi.mavi),
  ('denim', RenkAilesi.mavi),
  ('blue', RenkAilesi.mavi),
  ('navy', RenkAilesi.mavi),
  ('haki', RenkAilesi.yesil),
  ('zeytin', RenkAilesi.yesil),
  ('adaçayı', RenkAilesi.yesil),
  ('adacayi', RenkAilesi.yesil),
  ('nefti', RenkAilesi.yesil),
  ('mint', RenkAilesi.yesil),
  ('yeşil', RenkAilesi.yesil),
  ('yesil', RenkAilesi.yesil),
  ('green', RenkAilesi.yesil),
  ('bordo', RenkAilesi.kirmizi),
  ('vişne', RenkAilesi.kirmizi),
  ('visne', RenkAilesi.kirmizi),
  ('kızıl', RenkAilesi.kirmizi),
  ('kizil', RenkAilesi.kirmizi),
  ('kırmızı', RenkAilesi.kirmizi),
  ('kirmizi', RenkAilesi.kirmizi),
  ('red', RenkAilesi.kirmizi),
  ('fuşya', RenkAilesi.pembe),
  ('fusya', RenkAilesi.pembe),
  ('pudra', RenkAilesi.pembe),
  ('pembe', RenkAilesi.pembe),
  ('gül', RenkAilesi.pembe),
  ('pink', RenkAilesi.pembe),
  ('kiremit', RenkAilesi.turuncu),
  ('somon', RenkAilesi.turuncu),
  ('mercan', RenkAilesi.turuncu),
  ('turuncu', RenkAilesi.turuncu),
  ('orange', RenkAilesi.turuncu),
  ('hardal', RenkAilesi.sari),
  ('sarı', RenkAilesi.sari),
  ('sari', RenkAilesi.sari),
  ('yellow', RenkAilesi.sari),
  ('lila', RenkAilesi.mor),
  ('eflatun', RenkAilesi.mor),
  ('patlıcan', RenkAilesi.mor),
  ('patlican', RenkAilesi.mor),
  ('mor', RenkAilesi.mor),
  ('purple', RenkAilesi.mor),
];

String _kucult(String metin) =>
    metin.replaceAll('İ', 'i').replaceAll('I', 'ı').toLowerCase();

/// Serbest metin renk adını kaba bir aileye indirger.
/// Tanınmayan renkler (desenli, çok renkli, boş) [RenkAilesi.bilinmiyor] döner.
RenkAilesi renkAilesi(String hamRenk) {
  final metin = _kucult(hamRenk.trim());
  if (metin.isEmpty) return RenkAilesi.bilinmiyor;
  for (final kok in _renkKokleri) {
    if (metin.contains(kok.$1)) return kok.$2;
  }
  return RenkAilesi.bilinmiyor;
}

bool _renkliMi(RenkAilesi aile) => switch (aile) {
      RenkAilesi.mavi ||
      RenkAilesi.yesil ||
      RenkAilesi.kirmizi ||
      RenkAilesi.pembe ||
      RenkAilesi.turuncu ||
      RenkAilesi.sari ||
      RenkAilesi.mor =>
        true,
      _ => false,
    };

/// Renk çarkı: komşu ve karşıt ilişkileri bu sıraya göre kuruluyor.
const List<RenkAilesi> _cark = <RenkAilesi>[
  RenkAilesi.kirmizi,
  RenkAilesi.turuncu,
  RenkAilesi.sari,
  RenkAilesi.yesil,
  RenkAilesi.mavi,
  RenkAilesi.mor,
];

RenkAilesi _carkKonumu(RenkAilesi aile) =>
    aile == RenkAilesi.pembe ? RenkAilesi.kirmizi : aile;

bool _komsuMu(RenkAilesi a, RenkAilesi b) {
  final i = _cark.indexOf(_carkKonumu(a));
  final j = _cark.indexOf(_carkKonumu(b));
  if (i < 0 || j < 0) return false;
  final fark = (i - j).abs();
  return fark == 1 || fark == _cark.length - 1;
}

bool _zitMi(RenkAilesi a, RenkAilesi b) {
  final i = _cark.indexOf(_carkKonumu(a));
  final j = _cark.indexOf(_carkKonumu(b));
  if (i < 0 || j < 0) return false;
  return (i - j).abs() == _cark.length ~/ 2;
}

/// Bir kombinin renk uyumunu 0-100 arası puanlar.
///
/// Kural seti bilerek küçük ve açıklanabilir:
///  - Nötr / toprak / metalik tonlar zemin sayılır, her şeyle uyumludur.
///  - Tek renkli kombinler (monokrom) bütünlük verir.
///  - Nötr zemin + tek vurgu rengi en güvenli kombinasyondur.
///  - Komşu renkler yumuşak, karşıt renkler dengelenmişse iyi;
///    üç ayrı canlı renk birbirini bastırır.
RenkDegerlendirme renkDegerlendir(Iterable<String> renkler) {
  final aileler = renkler
      .map(renkAilesi)
      .where((aile) => aile != RenkAilesi.bilinmiyor)
      .toList();

  if (aileler.isEmpty) {
    // Hiçbir rengi tanıyamadık: ne övelim ne yerelim.
    return const RenkDegerlendirme(70, DuelSebebi.notr);
  }

  final zemin = aileler.where((aile) => !_renkliMi(aile)).length;
  final renkli = aileler.where(_renkliMi).toList();

  if (renkli.isEmpty) {
    return const RenkDegerlendirme(88, DuelSebebi.notr);
  }

  if (renkli.length == 1) {
    return RenkDegerlendirme(
      zemin >= 1 ? 92 : 84,
      zemin >= 1 ? DuelSebebi.vurgu : DuelSebebi.monokrom,
    );
  }

  if (renkli.length == 2) {
    final a = renkli[0];
    final b = renkli[1];
    if (a == b) return const RenkDegerlendirme(86, DuelSebebi.monokrom);
    if (_komsuMu(a, b)) {
      return RenkDegerlendirme(
        82 + (zemin >= 1 ? 4 : 0),
        DuelSebebi.analog,
      );
    }
    if (_zitMi(a, b)) {
      return RenkDegerlendirme(
        72 + (zemin >= 1 ? 4 : 0),
        DuelSebebi.zit,
      );
    }
    return const RenkDegerlendirme(52, DuelSebebi.dagink);
  }

  final tekRenk = renkli.toSet().length == 1;
  if (tekRenk) return const RenkDegerlendirme(78, DuelSebebi.monokrom);
  return RenkDegerlendirme(
    renkli.length >= 4 ? 28 : 38,
    DuelSebebi.cokRenk,
  );
}

/// Kombinin hava puanı. Yüksek puan = hava koşuluna daha uygun.
int havaPuani(List<Kiyafet> parcalar, HavaKosulu hava) {
  var puan = 0;
  for (final parca in parcalar) {
    final seviye = kiyafetSicaklikSeviyesi(parca);
    if (hava == HavaKosulu.soguk) {
      puan += switch (seviye) {
        KiyafetSicaklikSeviyesi.kislik => 2,
        KiyafetSicaklikSeviyesi.herMevsim => 1,
        KiyafetSicaklikSeviyesi.yazlik => -3,
      };
    } else {
      puan += switch (seviye) {
        KiyafetSicaklikSeviyesi.yazlik => 2,
        KiyafetSicaklikSeviyesi.herMevsim => 1,
        KiyafetSicaklikSeviyesi.kislik => -3,
      };
    }
  }
  return puan;
}

class _Aday {
  const _Aday(this.parcalar, this.deger);

  final List<Kiyafet> parcalar;
  final RenkDegerlendirme deger;

  int get puan => deger.puan;
  String get anahtar => parcalar.map((p) => p.id).join('|');
}

/// Düello turlarını üretir.
///
/// [tohum] verilirse sonuç deterministik olur (testler ve "günün düellosu"
/// için); verilmezse her oyunda farklı sıralama gelir.
class DuelMotoru {
  DuelMotoru({Random? rastgele}) : _rastgele = rastgele ?? Random();

  final Random _rastgele;

  DuelSeti uret({
    required List<Kiyafet> gardirobum,
    String gunlukHava = '',
    int adet = 10,
    int? tohum,
  }) {
    final rastgele = tohum == null ? _rastgele : Random(tohum);
    final sorular = <DuelSorusu>[];
    final gorulen = <String>{};
    var paletKullanildi = false;

    final uygunlar = gardirobum
        .where((kiyafet) => _gecerliKategoriler.contains(kiyafet.kategori))
        .toList();

    if (uygunlar.length >= 4) {
      final kombinler = _kombinler(uygunlar, rastgele);
      if (kombinler.length >= 2) {
        _renkSorulari(sorular, gorulen, kombinler, rastgele, adet);
        final hava = havaKosuluCikar(gunlukHava);
        if (hava != null &&
            (hava == HavaKosulu.soguk || hava == HavaKosulu.sicak)) {
          _havaSorulari(sorular, gorulen, kombinler, hava, rastgele,
              max(2, adet ~/ 3));
        }
      }
    }

    // Dolap yetersizse ya da renk düellosu çıkaramadıysa renk kartlarına düş.
    if (sorular.isEmpty) {
      _paletSorulari(sorular, gorulen, rastgele, adet);
      paletKullanildi = sorular.isNotEmpty;
    } else if (sorular.length < adet) {
      final oncekiSayi = sorular.length;
      _paletSorulari(sorular, gorulen, rastgele, adet - oncekiSayi);
      paletKullanildi = sorular.length > oncekiSayi;
    }

    // Hava turları kısa listede kaybolmasın: onları önce ayır, sonra
    // renk turlarıyla karıştır.
    final havaSorulari =
        sorular.where((s) => s.olcu == DuelOlcusu.hava).toList()
          ..shuffle(rastgele);
    final renkSorulari =
        sorular.where((s) => s.olcu == DuelOlcusu.renk).toList()
          ..shuffle(rastgele);

    final secilen = <DuelSorusu>[
      ...havaSorulari.take(min(3, adet)),
      ...renkSorulari,
    ]..shuffle(rastgele);

    return DuelSeti(
      sorular: secilen.take(adet).toList(),
      paletKullanildi: paletKullanildi,
    );
  }

  /// Dolaptan en fazla 6 üst × 6 alt × 4 ayakkabı ile aday kombinler.
  List<_Aday> _kombinler(List<Kiyafet> kiyafetler, Random rastgele) {
    final gruplar = <List<Kiyafet>>[
      _ornek(kiyafetler.where((k) => k.kategori == 'ust').toList(), 6,
          rastgele),
      _ornek(kiyafetler.where((k) => k.kategori == 'alt').toList(), 6,
          rastgele),
      _ornek(kiyafetler.where((k) => k.kategori == 'ayakkabi').toList(), 4,
          rastgele),
    ].where((grup) => grup.isNotEmpty).toList();

    if (gruplar.isEmpty) return const <_Aday>[];

    final adaylar = <_Aday>[];
    for (final parcalar in _kartezyen(gruplar)) {
      adaylar.add(
        _Aday(parcalar, renkDegerlendir(parcalar.map((p) => p.renk))),
      );
      if (adaylar.length >= 400) break;
    }
    return adaylar;
  }

  List<Kiyafet> _ornek(List<Kiyafet> liste, int adet, Random rastgele) {
    if (liste.length <= adet) return List<Kiyafet>.of(liste);
    final kopya = List<Kiyafet>.of(liste)..shuffle(rastgele);
    return kopya.take(adet).toList();
  }

  Iterable<List<Kiyafet>> _kartezyen(List<List<Kiyafet>> gruplar) sync* {
    if (gruplar.isEmpty) {
      yield const <Kiyafet>[];
      return;
    }
    for (final parca in gruplar.first) {
      for (final kalan in _kartezyen(gruplar.skip(1).toList())) {
        yield <Kiyafet>[parca, ...kalan];
      }
    }
  }

  void _renkSorulari(
    List<DuelSorusu> hedef,
    Set<String> gorulen,
    List<_Aday> adaylar,
    Random rastgele,
    int adet,
  ) {
    final iyiler = adaylar.where((a) => a.puan >= 82).toList()
      ..shuffle(rastgele);
    final kotuler = adaylar.where((a) => a.puan <= 62).toList()
      ..shuffle(rastgele);
    if (iyiler.isEmpty || kotuler.isEmpty) return;

    var eklenen = 0;
    for (final iyi in iyiler) {
      for (final kotu in kotuler) {
        if (eklenen >= adet) return;
        if (iyi.anahtar == kotu.anahtar) continue;
        if (iyi.puan - kotu.puan < 18) continue;

        final anahtar = (['renk', iyi.anahtar, kotu.anahtar]..sort()).join('~');
        if (!gorulen.add(anahtar)) continue;

        final solDogru = rastgele.nextBool();
        hedef.add(
          DuelSorusu(
            id: anahtar,
            olcu: DuelOlcusu.renk,
            sol: _kart( solDogru ? iyi.parcalar : kotu.parcalar),
            sag: _kart(!solDogru ? iyi.parcalar : kotu.parcalar),
            solDogru: solDogru,
            kazananSebep: iyi.deger.sebep,
            kaybedenSebep: kotu.deger.sebep,
            solPuan: solDogru ? iyi.puan : kotu.puan,
            sagPuan: solDogru ? kotu.puan : iyi.puan,
          ),
        );
        eklenen++;
      }
    }
  }

  void _havaSorulari(
    List<DuelSorusu> hedef,
    Set<String> gorulen,
    List<_Aday> adaylar,
    HavaKosulu hava,
    Random rastgele,
    int adet,
  ) {
    final puanli = adaylar
        .map((a) => (a, havaPuani(a.parcalar, hava)))
        .toList();
    final iyiler = puanli.where((e) => e.$2 >= 2).toList()..shuffle(rastgele);
    final kotuler = puanli.where((e) => e.$2 <= 0).toList()..shuffle(rastgele);
    if (iyiler.isEmpty || kotuler.isEmpty) return;

    var eklenen = 0;
    for (final iyi in iyiler) {
      for (final kotu in kotuler) {
        if (eklenen >= adet) return;
        if (iyi.$1.anahtar == kotu.$1.anahtar) continue;
        if (iyi.$2 - kotu.$2 < 3) continue;

        final anahtar = (['hava', iyi.$1.anahtar, kotu.$1.anahtar]..sort())
            .join('~');
        if (!gorulen.add(anahtar)) continue;

        final solDogru = rastgele.nextBool();
        hedef.add(
          DuelSorusu(
            id: anahtar,
            olcu: DuelOlcusu.hava,
            sol: _kart(solDogru ? iyi.$1.parcalar : kotu.$1.parcalar),
            sag: _kart(!solDogru ? iyi.$1.parcalar : kotu.$1.parcalar),
            solDogru: solDogru,
            kazananSebep: DuelSebebi.havaUygun,
            kaybedenSebep: hava == HavaKosulu.soguk
                ? DuelSebebi.havaHafif
                : DuelSebebi.havaAgir,
            solPuan: solDogru ? iyi.$2 : kotu.$2,
            sagPuan: solDogru ? kotu.$2 : iyi.$2,
          ),
        );
        eklenen++;
      }
    }
  }

  /// Dolap boşken oyunun tamamen kilitlenmemesi için renk kartı turları.
  /// Renkler ve kategori sırası sabit; puan yine [renkDegerlendir] ile
  /// hesaplandığı için açıklama ile doğru cevap her zaman tutarlı.
  void _paletSorulari(
    List<DuelSorusu> hedef,
    Set<String> gorulen,
    Random rastgele,
    int adet,
  ) {
    if (adet <= 0) return;

    final adaylar = <({List<String> renkler, RenkDegerlendirme deger})>[];
    for (var i = 0; i < paletRenkAdlari.length; i++) {
      for (var j = i + 1; j < paletRenkAdlari.length; j++) {
        for (var k = j + 1; k < paletRenkAdlari.length; k++) {
          final renkler = <String>[
            paletRenkAdlari[i],
            paletRenkAdlari[j],
            paletRenkAdlari[k],
          ];
          adaylar.add((renkler: renkler, deger: renkDegerlendir(renkler)));
        }
      }
    }

    final iyiler = adaylar.where((a) => a.deger.puan >= 88).toList()
      ..shuffle(rastgele);
    final kotuler = adaylar.where((a) => a.deger.puan <= 52).toList()
      ..shuffle(rastgele);
    if (iyiler.isEmpty || kotuler.isEmpty) return;

    var eklenen = 0;
    for (final iyi in iyiler) {
      for (final kotu in kotuler) {
        if (eklenen >= adet) return;
        if (iyi.deger.puan - kotu.deger.puan < 25) continue;

        final iyiMetin = iyi.renkler.join('+');
        final kotuMetin = kotu.renkler.join('+');
        if (iyiMetin == kotuMetin) continue;

        final anahtar = (['palet', iyiMetin, kotuMetin]..sort()).join('~');
        if (!gorulen.add(anahtar)) continue;

        final solDogru = rastgele.nextBool();
        hedef.add(
          DuelSorusu(
            id: anahtar,
            olcu: DuelOlcusu.renk,
            sol: _paletKarti(solDogru ? iyi.renkler : kotu.renkler),
            sag: _paletKarti(!solDogru ? iyi.renkler : kotu.renkler),
            solDogru: solDogru,
            kazananSebep: iyi.deger.sebep,
            kaybedenSebep: kotu.deger.sebep,
            solPuan: solDogru ? iyi.deger.puan : kotu.deger.puan,
            sagPuan: solDogru ? kotu.deger.puan : iyi.deger.puan,
          ),
        );
        eklenen++;
      }
    }
  }

  DuelKarti _kart(List<Kiyafet> parcalar) {
    return DuelKarti(
      parcalar
          .map(
            (kiyafet) => DuelParca(
              kategori: kiyafet.kategori,
              renk: kiyafet.renk,
              resim: kiyafet.resimBytes,
              kiyafet: kiyafet,
            ),
          )
          .toList(),
    );
  }

  DuelKarti _paletKarti(List<String> renkler) {
    const kategoriler = <String>['ust', 'alt', 'ayakkabi'];
    return DuelKarti(
      List<DuelParca>.generate(
        renkler.length,
        (index) => DuelParca(
          kategori: kategoriler[index % kategoriler.length],
          renk: renkler[index],
          paletRengi: paletRengi(renkler[index]),
        ),
      ),
    );
  }
}

/// Renk kartı düellosunda kullanılan renk adları.
const List<String> paletRenkAdlari = <String>[
  'Lacivert',
  'Beyaz',
  'Kahverengi',
  'Siyah',
  'Bej',
  'Gri',
  'Yeşil',
  'Kırmızı',
  'Turuncu',
  'Sarı',
  'Mor',
  'Pembe',
  'Mavi',
  'Haki',
  'Ekru',
  'Bordo',
];

/// Renk adından kart rengi. Tanınmayan renkler için nötr gri.
int paletRengi(String renk) => switch (renkAilesi(renk)) {
      RenkAilesi.notr => 0xFFE8E2D6,
      RenkAilesi.kahve => 0xFF6B4B33,
      RenkAilesi.metalik => 0xFFB9B3A7,
      RenkAilesi.mavi => 0xFF2E5C8A,
      RenkAilesi.yesil => 0xFF3F5D3A,
      RenkAilesi.kirmizi => 0xFF9E2B25,
      RenkAilesi.pembe => 0xFFD98C99,
      RenkAilesi.turuncu => 0xFFD2703A,
      RenkAilesi.sari => 0xFFE0B341,
      RenkAilesi.mor => 0xFF5B3A6E,
      RenkAilesi.bilinmiyor => 0xFF9A9A9A,
    };
