import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:fitcheck/models/kiyafet.dart';
import 'package:fitcheck/utils/hava_uygunlugu.dart';

Kiyafet _k(String baslik, {String kategori = 'ust', String? mevsim}) {
  return Kiyafet(
    id: baslik,
    baslik: baslik,
    kategori: kategori,
    resimBytes: Uint8List(0),
    renk: 'Siyah',
    stil: 'Casual',
    mevsim: mevsim,
  );
}

void main() {
  test('sicaklik ayiklama Celsius', () {
    final s =
        havaSicakliklariniCikar('İstanbul • 15°C / 24°C — Parçalı Bulutlu');
    expect(s, [15.0, 24.0]);
  });

  test('sicaklik ayiklama Fahrenheit donusturur', () {
    final s = havaSicakliklariniCikar('Istanbul • 41°F / 68°F — Cloudy');
    expect(s[0], closeTo(5.0, 0.01));
    expect(s[1], closeTo(20.0, 0.01));
  });

  test('sicaklik ayiklama derecesiz haftalik format', () {
    final s = havaSicakliklariniCikar('Pazartesi: 5° / 20°, Parçalı Bulutlu');
    expect(s, [5.0, 20.0]);
  });

  test('hava kosulu esikleri', () {
    expect(havaKosuluCikar('Ankara • 2°C / 10°C — Kar'), HavaKosulu.soguk);
    expect(havaKosuluCikar('Ankara • 18°C / 24°C — Açık'), HavaKosulu.iliman);
    expect(
        havaKosuluCikar('Antalya • 26°C / 33°C — Güneşli'), HavaKosulu.sicak);
  });

  test('hava kosulu bilinmiyorsa null', () {
    expect(havaKosuluCikar('Konum kapalı'), isNull);
  });

  test('haftalik tahmin satirindan gun havasi', () {
    final satirlar = [
      'Perşembe: 12°C / 20°C, Güneşli',
      'Cuma: 14°C / 22°C, Parçalı Bulutlu',
      'Cumartesi: 16°C / 25°C, Açık',
      'Pazar: 17°C / 26°C, Açık',
    ];
    expect(
      haftalikTahminGunHavasi(
        gunAdi: 'Saturday',
        tahminSatirlari: satirlar,
        bugununHaftaGunu: 4,
      ),
      '16°C / 25°C, Açık',
    );
    expect(
      haftalikTahminGunHavasi(
        gunAdi: 'Thursday',
        tahminSatirlari: satirlar,
        bugununHaftaGunu: 4,
      ),
      '12°C / 20°C, Güneşli',
    );
  });

  test('haftalik tahmin gun havasi eslesmezse bos', () {
    final satirlar = ['Cumartesi: 16°C / 25°C, Açık'];
    expect(
      haftalikTahminGunHavasi(
        gunAdi: 'Sunday',
        tahminSatirlari: satirlar,
        bugununHaftaGunu: 1,
      ),
      '',
    );
    expect(
      haftalikTahminGunHavasi(
        gunAdi: 'Hava tahmini yüklenemedi',
        tahminSatirlari: satirlar,
        bugununHaftaGunu: 2,
      ),
      '',
    );
    expect(
      haftalikTahminGunHavasi(
        gunAdi: 'Monday',
        tahminSatirlari: ['Hava tahmini yüklenemedi'],
        bugununHaftaGunu: 1,
      ),
      '',
    );
  });

  test('mevsim etiketi oncelikli', () {
    expect(
      kiyafetSicaklikSeviyesi(_k('Keten Gömlek', mevsim: mevsimEtiketiKislik)),
      KiyafetSicaklikSeviyesi.kislik,
    );
  });

  test('anahtar kelimeden mevsim tahmini', () {
    expect(
      kiyafetSicaklikSeviyesi(_k('Siyah Yün Kazak')),
      KiyafetSicaklikSeviyesi.kislik,
    );
    expect(
      kiyafetSicaklikSeviyesi(_k('Mavi Keten Şort', kategori: 'alt')),
      KiyafetSicaklikSeviyesi.yazlik,
    );
    expect(
      kiyafetSicaklikSeviyesi(_k('Beyaz Pamuk Tişört')),
      KiyafetSicaklikSeviyesi.herMevsim,
    );
  });

  test('soguk havada yazlik parca elenir, kislik kalir', () {
    final liste = [
      _k('Mavi Keten Şort', kategori: 'alt'),
      _k('Siyah Yün Pantolon', kategori: 'alt'),
    ];
    final uygun = havayaUygunKiyafetler(liste, HavaKosulu.soguk);
    expect(uygun.map((k) => k.baslik), ['Siyah Yün Pantolon']);
  });

  test('sicak havada kislik parca elenir', () {
    final liste = [
      _k('Siyah Yün Kazak'),
      _k('Beyaz Pamuk Tişört'),
    ];
    final uygun = havayaUygunKiyafetler(liste, HavaKosulu.sicak);
    expect(uygun.map((k) => k.baslik), ['Beyaz Pamuk Tişört']);
  });

  test('hepsi elenirse orijinal liste doner', () {
    final liste = [
      _k('Siyah Yün Kazak'),
      _k('Kahverengi Yün Hırka'),
    ];
    expect(havayaUygunKiyafetler(liste, HavaKosulu.sicak).length, 2);
  });

  test('mevsim etiketi normalizasyonu', () {
    expect(mevsimEtiketiniNormallestir('Kışlık'), mevsimEtiketiKislik);
    expect(mevsimEtiketiniNormallestir('summer'), mevsimEtiketiYazlik);
    expect(mevsimEtiketiniNormallestir('dort_mevsim'), mevsimEtiketiDortMevsim);
    expect(mevsimEtiketiniNormallestir('bilinmiyor'), isNull);
    expect(mevsimEtiketiniNormallestir(null), isNull);
  });

  test('parca metninden dolap numarasi cikarilir', () {
    expect(kiyafetIndeksiniCikar('Clean Item #4: Yün Kazak'), 4);
    expect(kiyafetIndeksiniCikar('Temiz Parça 7: Bot'), 7);
    expect(kiyafetIndeksiniCikar('bilinmeyen metin'), isNull);
  });

  group('haftalik plan otomatik duzeltme', () {
    late List<Kiyafet> dolap;

    setUp(() {
      dolap = [
        _k('Mavi Keten Şort', kategori: 'alt', mevsim: mevsimEtiketiYazlik),
        _k('Siyah Yün Pantolon', kategori: 'alt', mevsim: mevsimEtiketiKislik),
        _k('Beyaz Keten Gömlek', kategori: 'ust', mevsim: mevsimEtiketiYazlik),
        _k('Lacivert Yün Kazak', kategori: 'ust', mevsim: mevsimEtiketiKislik),
        _k('Deri Sandalet', kategori: 'ayakkabi', mevsim: mevsimEtiketiYazlik),
        _k('Kahverengi Bot', kategori: 'ayakkabi', mevsim: mevsimEtiketiKislik),
        _k('Kalın Kot Pantolon', kategori: 'alt', mevsim: mevsimEtiketiKislik),
      ];
    });

    Map<String, dynamic> gun(List<int> indeksler, {String? hava}) {
      return {
        'gun': 'Pazartesi',
        'gunluk_hava': hava,
        'tuyo': 'Not',
        'parcalar': indeksler.map((i) => _parca(i)).toList(),
      };
    }

    List<String> parcalar(Map<String, dynamic> g) =>
        (g['parcalar'] as List).cast<String>();

    String kategoriCozucu(String kategori) => kategori;

    test('soguk gunde yazlik parcalar ayni kategoride degistirilir', () {
      final hafta = [
        gun([1, 3, 5]),
      ];
      final degisenler = haftalikPlaniHavayaUygunlastir(
        hafta: hafta,
        kiyafetler: dolap,
        tahminSatirlari: ['Pazartesi: 0° / 4°, Kar'],
        kategoriCozucu: kategoriCozucu,
      );

      expect(degisenler, {0});
      expect(parcalar(hafta[0]).first, contains('#2'));
      expect(parcalar(hafta[0])[1], contains('#4'));
      expect(parcalar(hafta[0])[2], contains('#6'));
    });

    test('sicak gunde kislik parcalar degistirilir', () {
      final hafta = [
        gun([2, 4, 6]),
      ];
      final degisenler = haftalikPlaniHavayaUygunlastir(
        hafta: hafta,
        kiyafetler: dolap,
        tahminSatirlari: ['Pazartesi: 26° / 33°, Güneşli'],
        kategoriCozucu: kategoriCozucu,
      );

      expect(degisenler, {0});
      expect(parcalar(hafta[0]).first, contains('#1'));
      expect(parcalar(hafta[0])[1], contains('#3'));
      expect(parcalar(hafta[0])[2], contains('#5'));
    });

    test('uygun alternatif yoksa parca degistirilmez', () {
      final darDolap = [
        _k('Siyah Yün Pantolon', kategori: 'alt', mevsim: mevsimEtiketiKislik),
        _k('Beyaz Keten Gömlek', kategori: 'ust', mevsim: mevsimEtiketiYazlik),
      ];
      final hafta = [
        gun([1]),
      ];
      final degisenler = haftalikPlaniHavayaUygunlastir(
        hafta: hafta,
        kiyafetler: darDolap,
        tahminSatirlari: ['Pazartesi: 26° / 33°, Güneşli'],
        kategoriCozucu: kategoriCozucu,
      );

      expect(degisenler, isEmpty);
      expect(parcalar(hafta[0]), [_parca(1)]);
    });

    test('ayni parca iki gunde kullanilmaz', () {
      final hafta = [
        gun([1]),
        gun([1]),
      ];
      haftalikPlaniHavayaUygunlastir(
        hafta: hafta,
        kiyafetler: dolap,
        tahminSatirlari: [
          'Pazartesi: 0° / 4°, Kar',
          'Salı: 1° / 5°, Kar',
        ],
        kategoriCozucu: kategoriCozucu,
      );

      expect(parcalar(hafta[0]).first, contains('#2'));
      expect(parcalar(hafta[1]).first, contains('#7'));
    });

    test('ayakkabi baska gunde tekrar kullanilabilir', () {
      final hafta = [
        gun([1, 3, 5]),
        gun([1, 3, 5]),
      ];
      haftalikPlaniHavayaUygunlastir(
        hafta: hafta,
        kiyafetler: dolap,
        tahminSatirlari: [
          'Pazartesi: 0° / 4°, Kar',
          'Salı: 1° / 5°, Kar',
        ],
        kategoriCozucu: kategoriCozucu,
      );

      // İki gün de aynı (tek uygun) kışlık ayakkabıyı kullanır.
      expect(parcalar(hafta[0])[2], contains('#6'));
      expect(parcalar(hafta[1])[2], contains('#6'));
    });

    test('baslangicIndex oncesi gunler degistirilmez', () {
      final hafta = [
        gun([1, 3, 5]),
        gun([1, 3, 5]),
      ];
      final degisenler = haftalikPlaniHavayaUygunlastir(
        hafta: hafta,
        kiyafetler: dolap,
        tahminSatirlari: [
          'Pazartesi: 0° / 4°, Kar',
          'Salı: 1° / 5°, Kar',
        ],
        kategoriCozucu: kategoriCozucu,
        baslangicIndex: 1,
      );

      expect(degisenler, {1});
      expect(parcalar(hafta[0]), [_parca(1), _parca(3), _parca(5)]);
    });

    test('hava okunamiyorsa plana dokunulmaz', () {
      final hafta = [
        gun([1, 3, 5]),
      ];
      final degisenler = haftalikPlaniHavayaUygunlastir(
        hafta: hafta,
        kiyafetler: dolap,
        tahminSatirlari: ['Konum kapalı'],
        kategoriCozucu: kategoriCozucu,
      );

      expect(degisenler, isEmpty);
      expect(parcalar(hafta[0]), [_parca(1), _parca(3), _parca(5)]);
    });

    test('tahmin satiri yoksa gunun kendi hava metni kullanilir', () {
      final hafta = [
        gun([1, 3, 5], hava: '0° / 4°'),
      ];
      final degisenler = haftalikPlaniHavayaUygunlastir(
        hafta: hafta,
        kiyafetler: dolap,
        tahminSatirlari: [],
        kategoriCozucu: kategoriCozucu,
      );

      expect(degisenler, {0});
      expect(parcalar(hafta[0]).first, contains('#2'));
    });
  });
}

String _parca(int indeks) =>
    'Clean Item #$indeks: parca [Category: ust] (Color: Siyah, Style: Casual)';
