import 'dart:convert';
import 'dart:io';

import 'package:fitcheck/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

// Reklam ödülü metinleri tek kaynaktan beslenmeli.
//
// Geçmişte ödül 3'ten 2'ye düşürülünce sadece Türkçe metin güncellenmiş,
// 11 dilde "+3" kalmıştı. Kullanıcı reklamı izleyip 2 kredi alınca
// "eksik verdi" algısı oluşuyordu. Artık sayı metne gömülmüyor: {adet}
// yer tutucusu çağrı anında ReklamServisi sabitinden doldurulur.
// Bu test, sayının metne geri gömülmesini ve parametre sırasının
// bozulmasını engeller.

const List<String> _odulAnahtarlari = <String>[
  'reklamIzleHakKazan',
  'tebriklerHakEklendi',
  'hakEklendiTebrikler',
  'gardirobunDolduIcerik',
  'reklamIzleSlotEkle',
  'yeniSlotEklendiTebrikler',
];

const List<String> _diller = <String>[
  'tr', 'en', 'it', 'es', 'zh', 'ar', 'fr', 'de', 'pt', 'ja', 'ko', 'ru',
];

void main() {
  group('Reklam ödülü metinleri', () {
    test('hiçbir dilde sabit sayı yok, {adet} yer tutucusu var', () {
      for (final dil in _diller) {
        final dosya = File('lib/l10n/app_$dil.arb');
        expect(dosya.existsSync(), isTrue, reason: '$dil ARB dosyası yok');
        final Map<String, dynamic> veri =
            jsonDecode(dosya.readAsStringSync()) as Map<String, dynamic>;

        for (final anahtar in _odulAnahtarlari) {
          final deger = veri[anahtar];
          expect(deger, isA<String>(),
              reason: '$dil/$anahtar metni bulunamadı');
          final metin = deger as String;
          expect(metin.contains('{adet}'), isTrue,
              reason: '$dil/$anahtar içinde {adet} yok: $metin');
          expect(RegExp(r'\+\s*\d').hasMatch(metin), isFalse,
              reason: '$dil/$anahtar içinde sabit sayı var: $metin');
        }
      }
    });

    test('ödül sayısı ekranda doğru görünür', () {
      final tr = lookupAppLocalizations(const Locale('tr'));
      final en = lookupAppLocalizations(const Locale('en'));

      expect(tr.reklamIzleHakKazan(2), contains('+2'));
      expect(en.reklamIzleHakKazan(2), contains('+2'));
      expect(tr.tebriklerHakEklendi(2), contains('+2'));
      expect(tr.hakEklendiTebrikler(2), contains('+2'));
    });

    test('gardırop metninde limit ve ödül sırası doğru', () {
      final tr = lookupAppLocalizations(const Locale('tr'));
      // İmza: gardirobunDolduIcerik(limit, adet)
      final metin = tr.gardirobunDolduIcerik(21, 2);

      expect(metin, contains('21'));
      expect(metin, contains('+2'));
      // Sıra bozulursa "+21" ve "2 kıyafete" gibi anlamsız bir cümle çıkar.
      expect(metin, isNot(contains('+21')));
      expect(metin, isNot(contains('2 kıyafete')));
    });

    test('yorum isteğinde ödül vaadi yok (Play politikası)', () {
      for (final dil in _diller) {
        final dosya = File('lib/l10n/app_$dil.arb');
        final Map<String, dynamic> veri =
            jsonDecode(dosya.readAsStringSync()) as Map<String, dynamic>;
        final metin = veri['degerlendirmeIcerik'] as String;

        // Play: yorum/puan karşılığında ödül teklif edilemez.
        expect(RegExp(r'\+\s*\d').hasMatch(metin), isFalse,
            reason: '$dil: yorum metni ödül vaat ediyor: $metin');
        expect(RegExp(r'credit|kredi|rصيد|Guthaben|crédito|crédit|credito|'
                r'クレジット|크레딧|кредит|积分|hak ', caseSensitive: false)
            .hasMatch(metin), isFalse,
            reason: '$dil: yorum metni hâlâ kredi vaat ediyor: $metin');
      }
    });
  });
}
