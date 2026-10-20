// "Bugün" ekranının metinlerinin 12 dilin hepsinde tanımlı olduğunu doğrular.
//
// Neden: yeni sekme uygulamanın ilk sayfası; bir dilde anahtar eksik kalırsa
// kullanıcı boş metin ya da İngilizce metin görür. gen-l10n eksik anahtarı
// hata olarak vermez (şablon diline düşer), bu yüzden ayrı test gerekiyor.
//
// Çalıştırma: flutter test test/bugun_l10n_test.dart
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

const List<String> diller = [
  'en', 'tr', 'it', 'es', 'zh', 'ar', 'fr', 'de', 'pt', 'ja', 'ko', 'ru',
];

const List<String> anahtarlar = [
  'bugunSekmesi',
  'bugunBaslik',
  'bugunGunaydin',
  'bugunIyiGunler',
  'bugunIyiAksamlar',
  'bugunBugununKombini',
  'bugunHizliFotograf',
  'bugunHizliKombin',
  'bugunHizliStilist',
  'bugunHizliPlan',
  'bugunHazirlaniyor',
  'bugunBosBaslik',
  'bugunBosAciklama',
  'bugunYenile',
  'bugunGiydim',
  'bugunKaydet',
  'bugunSeninIcin',
  'bugunGiyilmediRafi',
  'bugunYeniRafi',
  'bugunHavaRafi',
  'bugunRafIpucu',
];

void main() {
  group('bugün ekranı: yerelleştirme', () {
    test('21 anahtar 12 dilde de tanımlı ve boş değil', () {
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

    test('türkçe metinler kullanıcıya doğru şeyi söylüyor', () {
      final tr = json.decode(File('lib/l10n/app_tr.arb').readAsStringSync())
          as Map<String, dynamic>;

      expect(tr['bugunSekmesi'], 'Bugün');
      expect(tr['bugunBugununKombini'], contains('Bugünün'));
      expect(tr['bugunGiydim'], 'Giydim');
      expect(tr['bugunKaydet'], 'Kaydet');
    });

    test('aynı anahtar iki kez eklenmemiş (JSON tekrarı yok)', () {
      for (final dil in diller) {
        final ham = File('lib/l10n/app_$dil.arb').readAsStringSync();
        for (final anahtar in anahtarlar) {
          final adet = RegExp('"${RegExp.escape(anahtar)}":').allMatches(ham).length;
          expect(adet, 1, reason: '$dil/$anahtar $adet kez geçiyor');
        }
      }
    });
  });
}
