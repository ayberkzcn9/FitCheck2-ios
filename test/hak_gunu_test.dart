// Günlük kombin hakkı gün değişiminde doğru sıfırlanmalı.
//
// Sorun: kalanHakGetir önbellekteki değeri tarih kontrolünden önce döndürüyordu.
// Uygulama gece yarısını aşarak açık kalırsa dünün değeri (ör. 0) yeni günde de
// görünüyor, reklam kararı yanlış veriliyordu. Bu test o durumu yeniden üretir.

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fitcheck/services/reklam_servisi.dart';

void main() {
  test('gün değişince önbellekteki eski hak değeri kullanılmaz', () async {
    ReklamServisi.reklamlarEtkinMi = true;
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final prefs = await SharedPreferences.getInstance();

    final bugun = DateTime.now().toIso8601String().substring(0, 10);
    final dun = DateTime.now()
        .subtract(const Duration(days: 1))
        .toIso8601String()
        .substring(0, 10);
    final servis = ReklamServisi();

    // Bugün hakları bitmiş: önbellek 0 olur.
    await prefs.setString('reklam_hak_tarihi', bugun);
    await prefs.setInt('reklam_kalan_hak', 0);
    expect(await servis.kalanHakGetir(), 0);

    // Uygulama açık kalırken gün değişti; kayıtlı tarih dün.
    await prefs.setString('reklam_hak_tarihi', dun);
    expect(
      await servis.kalanHakGetir(),
      ReklamServisi.ucretsizGunlukHak,
      reason: 'Yeni günde hak sıfırlanmalı; önbellekteki 0 kullanılmamalı.',
    );
  });
}
