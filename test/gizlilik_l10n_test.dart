// Gizlilik politikasının "Yapay Zekâ ile Görsel Analizi" maddesinin 12 dilin
// hepsinde tanımlı olduğunu doğrular.
//
// Neden: vision özelliği kıyafet fotoğraflarını Gemini/Groq'a gönderiyor.
// Metin bir dilde eksik kalırsa kullanıcı veri akışını göremez; Play tarafında
// da eksik/yanlış beyan riski doğar.
//
// Çalıştırma: flutter test test/gizlilik_l10n_test.dart
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

const List<String> diller = [
  'en', 'tr', 'it', 'es', 'zh', 'ar', 'fr', 'de', 'pt', 'ja', 'ko', 'ru',
];

const List<String> anahtarlar = [
  'gizlilikMadde5Baslik',
  'gizlilikMadde5Icerik',
];

void main() {
  group('gizlilik: yapay zekâ maddesi', () {
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

    test('metin hangi servislerin kullanıldığını söylüyor', () {
      final tr = json.decode(File('lib/l10n/app_tr.arb').readAsStringSync())
          as Map<String, dynamic>;
      final metin = tr['gizlilikMadde5Icerik'] as String;
      expect(metin, contains('Gemini'));
      expect(metin, contains('Groq'));
      // Kullanıcıya "kalıcı saklanmıyor" bilgisi verilmeli.
      expect(metin.toLowerCase(), contains('saklanmaz'));
    });

    test('son güncelleme tarihi 2026 olarak yenilendi', () {
      for (final dil in diller) {
        final tablo = json.decode(
          File('lib/l10n/app_$dil.arb').readAsStringSync(),
        ) as Map<String, dynamic>;
        expect(tablo['sonGuncellemeTarihi'] as String, contains('2026'),
            reason: '$dil tarih güncellenmemiş');
      }
    });
  });
}
