// "Bugün" ekranının kombin akışı.
//
// Kural: GÜNDE EN FAZLA BİR YAPAY ZEKÂ ÇAĞRISI. Üretilen kombinler tarih +
// dolap parmak izi ile cihazda saklanır; gün içinde ekran kaç kez açılırsa
// açılsın önbellekten gelir. Dolap değişirse (parça eklendi/silindi/adı
// değişti) parmak izi de değişir ve akış kendini yeniler.
//
// Yapay zekâ çalışmazsa (kota, ağ, bozuk JSON) sessizce kural bazlı üretime
// düşülür: kullanıcı boş ekran değil, mantıklı kombinler görür.

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/bugun_kombin.dart';
import '../models/kiyafet.dart';
import '../utils/helpers.dart';
import '../utils/kategori_utils.dart';
import 'ai_service.dart';
import 'akilli_raflar.dart';
import 'stilist_hafizasi.dart';

/// Kombinlerin nereden geldiği (analitik ve hata mesajı için).
enum FeedKaynagi { yapayZeka, kural, onbellek }

class FeedSonucu {
  final List<BugunKombin> kombinler;
  final FeedKaynagi kaynak;

  const FeedSonucu(this.kombinler, this.kaynak);

  bool get bos => kombinler.isEmpty;
}

class BugunFeedServisi {
  BugunFeedServisi._();

  /// Testlerde sahte (ağa çıkmayan) bir alt sınıf üretmek için.
  @visibleForTesting
  BugunFeedServisi.test();

  static final BugunFeedServisi _ornek = BugunFeedServisi._();
  factory BugunFeedServisi() => _ornek;

  /// SharedPreferences anahtarı. Şema değişirse sürüm eki artırılır.
  static const String onbellekAnahtari = 'bugun_feed_v1';

  /// Akışta gösterilecek en fazla kombin.
  static const int enFazlaKombin = 5;

  /// Yapay zekâya gönderilecek en fazla parça (jeton/maliyet koruması).
  static const int enFazlaParca = 80;

  /// Cevap bu sürede gelmezse kural bazlı üretime düşülür.
  static const Duration zamanAsimi = Duration(seconds: 25);

  /// Aynı anda iki istek gitmesin (ekran iki kez açılırsa).
  static bool _istekSuruyor = false;

  /// Akışı getirir. [zorla] true ise önbellek yok sayılır (kullanıcı "Yenile").
  Future<FeedSonucu> getir({
    required List<Kiyafet> dolap,
    required String hava,
    required String dil,
    bool zorla = false,
    DateTime? simdi,
  }) async {
    if (dolap.isEmpty) {
      return const FeedSonucu(<BugunKombin>[], FeedKaynagi.kural);
    }

    final an = simdi ?? DateTime.now();
    final gun = gunAnahtari(an);
    final iz = parmakIzi(dolap: dolap, hava: hava, dil: dil, gun: gun);

    if (!zorla) {
      final onbellek = await _onbellekOku();
      if (onbellek != null &&
          onbellek['tarih'] == gun &&
          onbellek['parmakIzi'] == iz) {
        final kombinler = _coz(onbellek['kombinler']);
        if (kombinler.isNotEmpty) {
          return FeedSonucu(kombinler, FeedKaynagi.onbellek);
        }
      }
    }

    final kuralKombinleri =
        AkilliRaflar.kurallIleKombinler(dolap, adet: enFazlaKombin, gun: an);

    // Yapay zekâya sadece gerçekten kombin kurulabiliyorsa gidilir.
    if (kuralKombinleri.isNotEmpty && !_istekSuruyor) {
      _istekSuruyor = true;
      try {
        final cevap = await AiService()
            .sadeceMetinSorgula(
              sistemPromptu: sistemPromptu(dil),
              kullaniciMesaji: _kullaniciMesaji(dolap, hava, dil),
            )
            .timeout(zamanAsimi);

        final indeks = {for (final k in dolap) k.id: k};
        var kombinler = ayikla(cevap: cevap, indeks: indeks);

        if (kombinler.isNotEmpty) {
          kombinler = _tamamla(kombinler, kuralKombinleri);
          await _onbellekYaz(gun, iz, kombinler);
          return FeedSonucu(kombinler, FeedKaynagi.yapayZeka);
        }
      } catch (e) {
        debugPrint('Bugün akışı: yapay zekâ kullanılamadı ($e)');
      } finally {
        _istekSuruyor = false;
      }
    }

    if (kuralKombinleri.isNotEmpty) {
      await _onbellekYaz(gun, iz, kuralKombinleri);
      return FeedSonucu(kuralKombinleri, FeedKaynagi.kural);
    }

    return const FeedSonucu(<BugunKombin>[], FeedKaynagi.kural);
  }

  /// Önbelleği temizler (dolap sıfırlandığında).
  Future<void> onbellegiTemizle() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(onbellekAnahtari);
    } catch (e) {
      debugPrint('Bugün akışı önbelleği silinemedi: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // Önbellek
  // ---------------------------------------------------------------------------

  Future<Map<String, dynamic>?> _onbellekOku() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final ham = prefs.getString(onbellekAnahtari);
      if (ham == null || ham.isEmpty) return null;
      return safeJsonDecodeMap(ham, tag: 'bugun_feed');
    } catch (e) {
      debugPrint('Bugün akışı önbelleği okunamadı: $e');
      return null;
    }
  }

  Future<void> _onbellekYaz(
    String gun,
    String iz,
    List<BugunKombin> kombinler,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        onbellekAnahtari,
        jsonEncode(<String, dynamic>{
          'surum': 1,
          'tarih': gun,
          'parmakIzi': iz,
          'kombinler': kombinler.map((k) => k.toJson()).toList(),
        }),
      );
    } catch (e) {
      debugPrint('Bugün akışı önbelleğe yazılamadı: $e');
    }
  }

  List<BugunKombin> _coz(Object? ham) {
    if (ham is! List) return const <BugunKombin>[];
    final sonuc = <BugunKombin>[];
    for (final oge in ham) {
      if (oge is! Map) continue;
      final kombin = BugunKombin.fromJson(Map<String, dynamic>.from(oge));
      if (kombin.gecerliMi) sonuc.add(kombin);
    }
    return sonuc.take(enFazlaKombin).toList(growable: false);
  }

  // ---------------------------------------------------------------------------
  // Yapay zekâ
  // ---------------------------------------------------------------------------

  /// Tarih anahtarı: yerel gün (YYYY-MM-DD).
  static String gunAnahtari(DateTime an) {
    final ay = an.month.toString().padLeft(2, '0');
    final gun = an.day.toString().padLeft(2, '0');
    return '${an.year}-$ay-$gun';
  }

  /// Dolabın + havanın + dilin kısa imzası.
  ///
  /// FNV-1a: Dart'ın String.hashCode'u çalıştırmalar arasında değişebilir;
  /// önbellek anahtarı kararlı olmalı.
  @visibleForTesting
  static String parmakIzi({
    required List<Kiyafet> dolap,
    required String hava,
    required String dil,
    required String gun,
  }) {
    final tampon = StringBuffer()
      ..write(gun)
      ..write('|')
      ..write(dil)
      ..write('|')
      ..write(hava.trim().toLowerCase());

    final parcalar = List<Kiyafet>.from(dolap)
      ..sort((a, b) => a.id.compareTo(b.id));
    for (final k in parcalar) {
      tampon
        ..write('|')
        ..write(k.id)
        ..write(k.gorunenBaslik)
        ..write(k.kategori)
        ..write(k.renk)
        ..write(k.mevsim ?? '')
        ..write(k.sepetteMi ? '1' : '0')
        ..write(k.sonGiyilmeTarihi?.toIso8601String() ?? '');
    }

    var hash = 0x811c9dc5;
    for (final birim in tampon.toString().codeUnits) {
      hash ^= birim;
      hash = (hash * 0x01000193) & 0xFFFFFFFF;
    }
    return hash.toRadixString(16);
  }

  /// Yapay zekâdan gelen cevabı doğrular.
  ///
  /// Geçersiz id'ler, iki parçadan az kombinler ve aynı kombinler atılır.
  /// Üst/alt varsa her kombin ikisini de içermek zorunda: yarım kombin
  /// "bugünün kombini" olarak gösterilemez.
  @visibleForTesting
  List<BugunKombin> ayikla({
    required String cevap,
    required Map<String, Kiyafet> indeks,
  }) {
    final veri = _jsonCikar(cevap);
    final hamListe = veri['kombinler'];
    if (hamListe is! List) return const <BugunKombin>[];

    final dolapKategorileri = indeks.values
        .map((k) => kategoriModeldenCikar(k.kategori))
        .toSet();
    final ustVar = dolapKategorileri.contains('ust');
    final altVar = dolapKategorileri.contains('alt');

    final sonuc = <BugunKombin>[];
    final gorulen = <String>{};

    for (final ham in hamListe) {
      if (ham is! Map) continue;
      final harita = Map<String, dynamic>.from(ham);

      final hamIdler = harita['idler'];
      if (hamIdler is! List) continue;

      final idler = <String>[];
      for (final id in hamIdler) {
        final metin = id.toString();
        if (!indeks.containsKey(metin)) continue;
        if (idler.contains(metin)) continue;
        idler.add(metin);
      }
      if (idler.length < 2) continue;

      final kombin = BugunKombin(
        baslik: (harita['baslik'] ?? '').toString().trim().isEmpty
            ? _varsayilanBaslik(indeks, idler)
            : harita['baslik'].toString().trim(),
        aciklama: (harita['aciklama'] ?? '').toString().trim(),
        kiyafetIdleri: idler,
      );

      if (ustVar && !kombin.kategoriKodlari(indeks).contains('ust')) continue;
      if (altVar && !kombin.kategoriKodlari(indeks).contains('alt')) continue;
      if (!gorulen.add(kombin.anahtar)) continue;

      sonuc.add(kombin);
      if (sonuc.length >= enFazlaKombin) break;
    }

    return List<BugunKombin>.unmodifiable(sonuc);
  }

  /// Yapay zekâ az sayıda kombin döndürdüyse kural bazlı olanlarla tamamlar.
  List<BugunKombin> _tamamla(
    List<BugunKombin> akilli,
    List<BugunKombin> kural,
  ) {
    final sonuc = <BugunKombin>[...akilli];
    final gorulen = akilli.map((k) => k.anahtar).toSet();

    for (final kombin in kural) {
      if (sonuc.length >= enFazlaKombin) break;
      if (gorulen.add(kombin.anahtar)) sonuc.add(kombin);
    }
    return List<BugunKombin>.unmodifiable(sonuc);
  }

  String _varsayilanBaslik(Map<String, Kiyafet> indeks, List<String> idler) {
    final parcalar = idler
        .map((id) => indeks[id])
        .whereType<Kiyafet>()
        .map((k) => k.gorunenBaslik)
        .toList();
    return parcalar.take(2).join(' + ');
  }

  Map<String, dynamic> _jsonCikar(String cevap) {
    final temiz = cevap.trim();
    if (temiz.isEmpty) return <String, dynamic>{};
    final bas = temiz.indexOf('{');
    final son = temiz.lastIndexOf('}');
    if (bas < 0 || son <= bas) return <String, dynamic>{};
    return safeJsonDecodeMap(
      temiz.substring(bas, son + 1),
      tag: 'bugun_feed_cevap',
    );
  }

  /// Yapay zekâya gönderilecek sistem promptu.
  @visibleForTesting
  String sistemPromptu(String dil) {
    final hafiza = StilistHafizasi().promptBlogu();
    return '''
You are the outfit engine of a personal wardrobe app. You receive the user's wardrobe as a list of items with ids, and today's weather.

Build complete outfits using ONLY the items in the list.

Rules:
- Every outfit must contain a top ('ust') and a bottom ('alt'). Add shoes ('ayakkabi') when the wardrobe has any. Add an outer layer ('dis') only when the weather is cold.
- Never invent items or ids. Never reuse the same combination twice.
- Respect the weather and the season of each item.
- Prefer items that were worn long ago (larger "gun_once" means longer ago) and items not in the laundry ('sepette=true').
- If a durable fact about the user's taste is given below, respect it.

${hafiza.isEmpty ? '' : hafiza}

Reply with ONLY this JSON, no markdown, no explanation:
{"kombinler":[{"baslik":"...","aciklama":"...","idler":["id1","id2"]}]}

- "baslik": short outfit name (max 5 words).
- "aciklama": one sentence about why it works (max 15 words).
- "baslik" and "aciklama" MUST be written in language code: $dil.
- At most $enFazlaKombin outfits.
''';
  }

  String _kullaniciMesaji(List<Kiyafet> dolap, String hava, String dil) {
    final an = DateTime.now();
    final sirali = List<Kiyafet>.from(dolap)
      ..sort((a, b) {
        final sa = a.sonGiyilmeTarihi ?? a.eklenmeTarihi;
        final sb = b.sonGiyilmeTarihi ?? b.eklenmeTarihi;
        return sa.compareTo(sb);
      });

    final satirlar = StringBuffer()
      ..writeln('TODAY: ${gunAnahtari(an)}')
      ..writeln('WEATHER: ${hava.trim().isEmpty ? 'unknown' : hava.trim()}')
      ..writeln('LANGUAGE: $dil')
      ..writeln('WARDROBE:');

    for (final k in sirali.take(enFazlaParca)) {
      final kod = kategoriModeldenCikar(k.kategori);
      if (kod.isEmpty) continue;
      final son = k.sonGiyilmeTarihi ?? k.eklenmeTarihi;
      final gunOnce = an.difference(son).inDays.clamp(0, 3650);
      satirlar.writeln(
        '- id=${k.id} | ${k.gorunenBaslik} | kategori=$kod | '
        'renk=${k.renk} | stil=${k.stil} | '
        'mevsim=${kiyafetMevsimEtiketi(k)} | '
        'gun_once=$gunOnce | sepette=${k.sepetteMi}',
      );
    }

    satirlar.writeln(
      'Build at most $enFazlaKombin outfits from these items. Json only.',
    );
    return satirlar.toString();
  }
}
