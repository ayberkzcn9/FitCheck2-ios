import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fitcheck/services/ai_onay_servisi.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('AI onayı varsayılan kapalı, verilince açılır, kaldırılınca kapanır',
      () async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    expect(await AiOnayServisi.onayVarMi(), isFalse);

    await AiOnayServisi.onayVer();
    expect(await AiOnayServisi.onayVarMi(), isTrue);

    await AiOnayServisi.onayiKaldir();
    expect(await AiOnayServisi.onayVarMi(), isFalse);
  });
}
