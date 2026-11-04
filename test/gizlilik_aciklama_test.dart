import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> _arb(String language) =>
    jsonDecode(File('lib/l10n/app_$language.arb').readAsStringSync())
        as Map<String, dynamic>;

void main() {
  const languages = <String>[
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
    'tr',
    'zh',
  ];

  test('konum açıklaması iki konum servisini de tüm dillerde bildiriyor', () {
    for (final language in languages) {
      final text = _arb(language)['gizlilikMadde2Icerik'] as String;
      expect(text, contains('Open-Meteo'), reason: language);
      expect(text, contains('BigDataCloud'), reason: language);
    }
  });

  test('analitik açıklaması Firebase Analytics gönderimini açıklıyor', () {
    for (final language in languages) {
      final text = _arb(language)['analitikVerileriPaylasAciklama'] as String;
      expect(text, contains('Firebase Analytics'), reason: language);
    }
  });

  test('hesap silme başarısızlığı için çeviri her dilde mevcut', () {
    for (final language in languages) {
      final text = _arb(language)['hesapSilmeBasarisiz'];
      expect(text, isA<String>(), reason: language);
      expect((text as String).trim(), isNotEmpty, reason: language);
    }
  });

  test('Firebase Analytics platform başlangıcında varsayılan kapalı', () {
    final android = File(
      'android/app/src/main/res/values/analytics.xml',
    ).readAsStringSync();
    final ios = File('ios/Runner/Info.plist')
        .readAsStringSync()
        .replaceAll('\r\n', '\n');
    expect(
        android,
        contains(
            '<bool name="firebase_analytics_collection_enabled">false</bool>'));
    expect(
        ios,
        contains(
            '<key>FIREBASE_ANALYTICS_COLLECTION_ENABLED</key>\n\t<false/>'));
  });
}
