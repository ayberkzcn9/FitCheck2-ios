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
}
