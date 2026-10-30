// Günlük hak sıfırlaması reklamla kazanılan hakları silmemeli.
//
// Geçmişte tek sayaç vardı: gece yarısı `reklam_kalan_hak` doğrudan 3'e
// yazılıyordu. Böylece reklam izleyerek 3'ün üzerine çıkan kullanıcının
// kazandığı haklar siliniyordu. Artık günlük hak ile ekstra hak ayrı tutulur;
// sıfırlama yalnızca günlük hakkı 3'e tamamlar.

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fitcheck/services/reklam_servisi.dart';

String _gun(int fark) => DateTime.now()
    .subtract(Duration(days: fark))
    .toIso8601String()
    .substring(0, 10);

void main() {
  setUp(() {
    ReklamServisi.reklamlarEtkinMi = true;
    ReklamServisi.onbellegiSifirla();
  });

  test('gece yarısı reklamla kazanılan haklar korunur', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'reklam_hak_tarihi': _gun(1),
      'reklam_kalan_hak': 7,
      'reklam_gunluk_hak': 0,
      'reklam_ekstra_hak': 7,
    });
    final prefs = await SharedPreferences.getInstance();

    expect(await ReklamServisi().kalanHakGetir(), 10,
        reason: 'Günlük 3 hak eklenmeli, 7 ekstra hak silinmemeli.');
    expect(prefs.getInt('reklam_ekstra_hak'), 7);
    expect(prefs.getInt('reklam_gunluk_hak'), 3);
  });

  test('eski tek sayaçlı kayıttan geçişte hak kaybı olmaz', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'reklam_hak_tarihi': _gun(0),
      'reklam_kalan_hak': 7,
    });
    final prefs = await SharedPreferences.getInstance();

    expect(await ReklamServisi().kalanHakGetir(), 7);
    expect(prefs.getInt('reklam_ekstra_hak'), 7,
        reason: 'Eski bakiye ekstra hak olarak korunmalı.');

    // Ertesi gün: günlük hak eklenir, ekstra hak yine silinmez.
    await prefs.setString('reklam_hak_tarihi', _gun(1));
    ReklamServisi.onbellegiSifirla();
    expect(await ReklamServisi().kalanHakGetir(), greaterThanOrEqualTo(7));
    expect(prefs.getInt('reklam_ekstra_hak'), 7);
  });

  test('reklam ödülü günlük hakkı değiştirmez', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'reklam_hak_tarihi': _gun(0),
      'reklam_kalan_hak': 1,
      'reklam_gunluk_hak': 1,
      'reklam_ekstra_hak': 0,
    });
    final prefs = await SharedPreferences.getInstance();

    await ReklamServisi().reklamIzleyerekHakEkle(2);

    expect(prefs.getInt('reklam_gunluk_hak'), 1);
    expect(prefs.getInt('reklam_ekstra_hak'), 2);
    expect(await ReklamServisi().kalanHakGetir(), 3);
  });

  test('hak önce günlük sayaçtan, sonra ekstra haklardan düşer', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'reklam_hak_tarihi': _gun(0),
      'reklam_kalan_hak': 3,
      'reklam_gunluk_hak': 2,
      'reklam_ekstra_hak': 1,
    });
    final prefs = await SharedPreferences.getInstance();
    final servis = ReklamServisi();

    await servis.hakDusur();
    expect(prefs.getInt('reklam_gunluk_hak'), 1);
    expect(prefs.getInt('reklam_ekstra_hak'), 1);

    await servis.hakDusur();
    expect(prefs.getInt('reklam_gunluk_hak'), 0);
    expect(prefs.getInt('reklam_ekstra_hak'), 1);

    await servis.hakDusur();
    expect(prefs.getInt('reklam_gunluk_hak'), 0);
    expect(prefs.getInt('reklam_ekstra_hak'), 0);
    expect(await servis.kalanHakGetir(), 0);

    // Sıfırın altına düşmez.
    await servis.hakDusur();
    expect(await servis.kalanHakGetir(), 0);
  });

  test('iade edilen hak süresizdir ve ertesi gün korunur', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'reklam_hak_tarihi': _gun(0),
      'reklam_kalan_hak': 0,
      'reklam_gunluk_hak': 0,
      'reklam_ekstra_hak': 0,
    });
    final prefs = await SharedPreferences.getInstance();
    final servis = ReklamServisi();

    await servis.hakIadeEt();
    expect(await servis.kalanHakGetir(), 1);

    await prefs.setString('reklam_hak_tarihi', _gun(1));
    ReklamServisi.onbellegiSifirla();
    expect(await servis.kalanHakGetir(), 4,
        reason: '3 günlük + 1 iade hakkı korunmalı.');
  });

  test('ekstra hak yokken günlük sıfırlama 3 verir', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'reklam_hak_tarihi': _gun(1),
      'reklam_kalan_hak': 0,
      'reklam_gunluk_hak': 0,
      'reklam_ekstra_hak': 0,
    });

    expect(await ReklamServisi().kalanHakGetir(), 3);
  });
}
