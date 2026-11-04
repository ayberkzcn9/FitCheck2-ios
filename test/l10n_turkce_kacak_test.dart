import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> _arb(String locale) =>
    jsonDecode(File('lib/l10n/app_$locale.arb').readAsStringSync())
        as Map<String, dynamic>;

void main() {
  test('quiz and outfit-game copy is localized in every supported language',
      () {
    const locales = [
      'ar',
      'de',
      'en',
      'es',
      'fr',
      'it',
      'ja',
      'ko',
      'pt',
      'ru',
      'zh',
    ];
    const singleKeys = {
      'kombinMevcutKombin',
      'kombinParcaUst',
      'kombinParcaAlt',
      'kombinOyunBitti',
      'kombinToplamPuan',
      'kombinBasariOrani',
      'kombinTekrarOyna',
      'kombinAnaSayfa',
    };
    const prefixes = [
      'kombinEksik_',
      'kombinSoru_',
      'kombinKategori',
      'kombinOrtam',
      'kombinHava',
      'kombinRenk',
      'kombinSecenek',
      'kombinSonuc',
    ];

    final turkish = _arb('tr');
    final keys = turkish.keys.where((key) {
      return !key.startsWith('@') &&
          (key.startsWith('triviaQ') ||
              singleKeys.contains(key) ||
              prefixes.any(key.startsWith));
    }).toList();
    expect(keys, hasLength(130));

    // These are Turkish-specific letters, unlike umlauts and accents used by
    // German, French, Portuguese and other supported locales.
    final turkishOnlyLetters =
        RegExp('[\\u011f\\u0131\\u015f\\u011e\\u0130\\u015e]');
    expect(turkishOnlyLetters.hasMatch('ışık'), isTrue);
    for (final locale in locales) {
      final localized = _arb(locale);
      for (final key in keys) {
        final text = localized[key] as String;
        expect(text, isNot(turkish[key]),
            reason: '$locale/$key copied from Turkish');
        expect(
          turkishOnlyLetters.hasMatch(text),
          isFalse,
          reason: '$locale/$key contains Turkish-specific characters: $text',
        );
      }
    }
  });
}
