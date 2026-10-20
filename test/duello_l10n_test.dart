// "Kombin Düellosu" metinlerinin 12 dilin hepsinde tanımlı olduğunu doğrular.
//
// Neden: gen-l10n eksik anahtarı hata olarak vermez, şablon diline düşer.
// Bir dilde anahtar eksik kalırsa kullanıcı Türkçe metin görür; bunu
// yayından önce yakalamak gerekiyor.

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

const List<String> diller = [
  'en', 'tr', 'it', 'es', 'zh', 'ar', 'fr', 'de', 'pt', 'ja', 'ko', 'ru',
];

const List<String> anahtarlar = [
  'duelloSekmesi',
  'duelloBaslik',
  'duelloAltBaslik',
  'duelloBaslat',
  'duelloNasilOynanir',
  'duelloKural1',
  'duelloKural2',
  'duelloKural3',
  'duelloEnIyi',
  'duelloSeri',
  'duelloGunSerisi',
  'duelloSeviye',
  'duelloSeviyeDegeri',
  'duelloXp',
  'duelloTur',
  'duelloOlcuRenk',
  'duelloOlcuHava',
  'duelloDokun',
  'duelloDogru',
  'duelloYanlis',
  'duelloDevam',
  'duelloSonuc',
  'duelloBitti',
  'duelloSkor',
  'duelloYeniden',
  'duelloBugune',
  'duelloEnIyiSeri',
  'duelloPaletNotu',
  'duelloDolapEkle',
  'duelloBugunOynadi',
  'duelloSebepNotr',
  'duelloSebepMonokrom',
  'duelloSebepAnalog',
  'duelloSebepVurgu',
  'duelloSebepZit',
  'duelloSebepDagink',
  'duelloSebepCokRenk',
  'duelloSebepHavaUygun',
  'duelloSebepHavaAgir',
  'duelloSebepHavaHafif',
];

/// Yer tutucu bekleyen anahtarlar: ad → tip.
const Map<String, Map<String, String>> yerTutucular =
    <String, Map<String, String>>{
  'duelloGunSerisi': <String, String>{'gun': 'int'},
  'duelloSeviyeDegeri': <String, String>{'seviye': 'int'},
  'duelloXp': <String, String>{'xp': 'int'},
  'duelloTur': <String, String>{'tur': 'int', 'toplam': 'int'},
  'duelloSkor': <String, String>{'dogru': 'int', 'toplam': 'int'},
  'duelloEnIyiSeri': <String, String>{'seri': 'int'},
};

void main() {
  group('düello: yerelleştirme', () {
    test('40 anahtar 12 dilde de tanımlı ve boş değil', () {
      expect(diller, hasLength(12));

      for (final dil in diller) {
        final dosya = File('lib/l10n/app_$dil.arb');
        expect(dosya.existsSync(), isTrue, reason: '$dil için ARB yok');

        final tablo =
            json.decode(dosya.readAsStringSync()) as Map<String, dynamic>;

        for (final anahtar in anahtarlar) {
          expect(tablo.containsKey(anahtar), isTrue,
              reason: '$dil/$anahtar eksik');
          expect((tablo[anahtar] as String).trim(), isNotEmpty,
              reason: '$dil/$anahtar boş');
        }
      }
    });

    test('yer tutucular metinde ve ARB meta verisinde tutarlı', () {
      for (final dil in diller) {
        final tablo = json.decode(
          File('lib/l10n/app_$dil.arb').readAsStringSync(),
        ) as Map<String, dynamic>;

        yerTutucular.forEach((anahtar, tutucular) {
          final metin = tablo[anahtar] as String;
          for (final ad in tutucular.keys) {
            expect(metin.contains('{$ad}'), isTrue,
                reason: '$dil/$anahtar içinde {$ad} yok');
          }

          final meta = tablo['@$anahtar'] as Map<String, dynamic>?;
          expect(meta, isNotNull, reason: '$dil/$anahtar meta verisi yok');
          final tanimli =
              (meta!['placeholders'] as Map<String, dynamic>).keys.toSet();
          expect(tanimli, tutucular.keys.toSet(),
              reason: '$dil/$anahtar yer tutucu listesi uyuşmuyor');
        });
      }
    });

    test('Türkçe metinler boşlukla başlamaz veya bitmez', () {
      final tablo = json.decode(
        File('lib/l10n/app_tr.arb').readAsStringSync(),
      ) as Map<String, dynamic>;

      for (final anahtar in anahtarlar) {
        final metin = tablo[anahtar] as String;
        expect(metin, metin.trim(), reason: '$anahtar baş/son boşluklu');
      }
    });
  });
}
