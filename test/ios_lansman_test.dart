// iOS lansman modu: yalnızca iOS'u sınırsız/reklamsız yapar, Android'e dokunmaz.

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fitcheck/services/reklam_servisi.dart';

void main() {
  test('lansman modu yalnızca iOS için geçerli', () {
    expect(
      ReklamServisi.lansmanUcretsizKarari(TargetPlatform.iOS),
      ReklamServisi.iosLansmanUcretsiz,
    );
    for (final platform in <TargetPlatform>[
      TargetPlatform.android,
      TargetPlatform.macOS,
      TargetPlatform.windows,
      TargetPlatform.linux,
      TargetPlatform.fuchsia,
    ]) {
      expect(ReklamServisi.lansmanUcretsizKarari(platform), isFalse,
          reason: '$platform');
    }
  });
}
