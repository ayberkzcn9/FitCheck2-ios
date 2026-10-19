// Çekim ipucu metinlerinin 12 dilin hepsinde tanımlı olduğunu doğrular.
//
// Neden: yeni bir anahtar eklendiğinde ARB dosyalarından biri atlanırsa
// Flutter derleme anında hata verir; ama metnin *boş* ya da yanlış dile
// yazılmış olması derlemeyi durdurmaz. Bu test onu yakalar.
//
// Çalıştırma: flutter test test/cekim_ipucu_l10n_test.dart
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Uygulamanın desteklediği 12 dil.
const List<String> diller = [
  'en', 'tr', 'it', 'es', 'zh', 'ar', 'fr', 'de', 'pt', 'ja', 'ko', 'ru',
];

/// Fotoğraf kaynağı penceresindeki çekim ipuçları.
const List<String> anahtarlar = [
  'cekimIpucuBaslik',
  'cekimIpucu1',
  'cekimIpucu2',
  'cekimIpucu3',
];

void main() {
  group('çekim ipucu metinleri', () {
    test('12 dilin hepsinde tanımlı ve boş değil', () {
      for (final dil in diller) {
        final dosya = File('lib/l10n/app_$dil.arb');
        expect(dosya.existsSync(), isTrue, reason: '$dil için ARB dosyası yok');

        final tablo = json.decode(dosya.readAsStringSync()) as Map<String, dynamic>;

        for (final anahtar in anahtarlar) {
          expect(tablo.containsKey(anahtar), isTrue,
              reason: '$dil/$anahtar eksik');
          expect((tablo[anahtar] as String).trim(), isNotEmpty,
              reason: '$dil/$anahtar boş');
        }
      }
    });

    test('ipucu metinleri birbirinin kopyası değil', () {
      final tablo = json.decode(File('lib/l10n/app_tr.arb').readAsStringSync())
          as Map<String, dynamic>;
      final metinler = anahtarlar.map((a) => tablo[a] as String).toSet();
      expect(metinler.length, anahtarlar.length,
          reason: 'İki ipucu aynı metni taşıyor');
    });
  });
}
