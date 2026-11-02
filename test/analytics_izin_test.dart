import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fitcheck/services/analytics_servisi.dart';

void main() {
  setUp(() {
    AnalyticsServisi.firebaseHazir = false;
    AnalyticsServisi.veriToplamaIzinli = false;
  });

  test('ilk kurulumda analitik izni varsayılan olarak kapalı', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{});

    await AnalyticsServisi().izniYukle();

    expect(AnalyticsServisi.veriToplamaIzinli, isFalse);
  });

  test('kullanıcının daha önce açıkça kaydettiği tercih korunur', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      AnalyticsServisi.izinAnahtari: true,
    });

    await AnalyticsServisi().izniYukle();

    expect(AnalyticsServisi.veriToplamaIzinli, isTrue);
  });

  test('tercih okunamazsa güvenli varsayılan kapalı kalır', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    AnalyticsServisi.veriToplamaIzinli = true;

    await AnalyticsServisi().izniYukle();

    expect(AnalyticsServisi.veriToplamaIzinli, isFalse);
  });
}
