// "Kesim hatalı olabilir" (zemin kıyafete çok yakın) uyarısının metinlerinin
// 12 dilin hepsinde tanımlı olduğunu doğrular.
//
// Neden: yeni bir anahtar eklendiğinde ARB dosyalarından biri atlanırsa
// Flutter derleme anında hata verir; ama metnin *boş* ya da yanlış dile
// yazılmış olması derlemeyi durdurmaz. Bu test onu yakalar.
//
// Çalıştırma: flutter test test/kesim_uyarisi_l10n_test.dart
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Uygulamanın desteklediği 12 dil.
const List<String> diller = [
  'en', 'tr', 'it', 'es', 'zh', 'ar', 'fr', 'de', 'pt', 'ja', 'ko', 'ru',
];

/// Kesim uyarısı diyaloğundaki metinler.
const List<String> anahtarlar = [
  'kesimUyarisiBaslik',
  'kesimUyarisiAciklama',
  'kesimUyarisiTekrarCek',
  'kesimUyarisiYineDeKaydet',
];

void main() {
  group('kesim uyarısı metinleri', () {
    test('12 dilin hepsinde tanımlı ve boş değil', () {
      for (final dil in diller) {
        final dosya = File('lib/l10n/app_$dil.arb');
        expect(dosya.existsSync(), isTrue, reason: '$dil için ARB dosyası yok');

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

    test('Türkçe metinler diğer dillerden farklı (çeviri yapılmış)', () {
      final tr = json.decode(File('lib/l10n/app_tr.arb').readAsStringSync())
          as Map<String, dynamic>;
      final en = json.decode(File('lib/l10n/app_en.arb').readAsStringSync())
          as Map<String, dynamic>;
      for (final anahtar in anahtarlar) {
        expect(tr[anahtar], isNot(equals(en[anahtar])),
            reason: '$anahtar Türkçeye çevrilmemiş');
      }
    });

    test('metinler birbirinin kopyası değil', () {
      final tablo = json.decode(File('lib/l10n/app_tr.arb').readAsStringSync())
          as Map<String, dynamic>;
      final metinler = anahtarlar.map((a) => tablo[a] as String).toSet();
      expect(metinler.length, anahtarlar.length,
          reason: 'İki uyarı metni aynı');
    });
  });
}
