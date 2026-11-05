import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fitcheck/services/satin_alma_servisi.dart';

void main() {
  test('premium yalnızca Android mağazasında sunulur', () {
    expect(
      SatinAlmaServisi.premiumSunuluyorKarari(TargetPlatform.android),
      isTrue,
    );

    for (final platform in <TargetPlatform>[
      TargetPlatform.iOS,
      TargetPlatform.macOS,
      TargetPlatform.windows,
      TargetPlatform.linux,
      TargetPlatform.fuchsia,
    ]) {
      expect(
        SatinAlmaServisi.premiumSunuluyorKarari(platform),
        isFalse,
        reason: '$platform',
      );
    }
  });

  test('Apple girişi ve AI onayı metinleri 12 dilde tanımlı', () {
    const diller = [
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
    const anahtarlar = [
      'girisYapApple',
      'aiOnayBaslik',
      'aiOnayIcerik',
      'aiOnayKabul',
      'aiOnayVazgec',
      'aiYanitBildir',
      'aiBildirimBaslik',
      'aiBildirimIcerik',
      'aiBildirimGonder',
      'aiBildirimTesekkur',
    ];
    for (final dil in diller) {
      final arb = jsonDecode(
        File('lib/l10n/app_$dil.arb').readAsStringSync(),
      ) as Map<String, dynamic>;
      for (final anahtar in anahtarlar) {
        expect(arb[anahtar], isA<String>(), reason: '$dil:$anahtar');
        expect((arb[anahtar] as String).trim(), isNotEmpty,
            reason: '$dil:$anahtar');
      }
    }
  });
}
