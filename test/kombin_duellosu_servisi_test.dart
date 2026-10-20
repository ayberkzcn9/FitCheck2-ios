// "Kombin Düellosu" kalıcı durum testleri.
//
// En kritik kural günlük seri: aynı gün iki kez oynamak seriyi artırmamalı,
// bir gün atlamak seriyi sıfırlamalı.

import 'package:fitcheck/services/kombin_duellosu_servisi.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  var simdi = DateTime(2026, 10, 20, 10);
  late KombinDuellosuServisi servis;

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    simdi = DateTime(2026, 10, 20, 10);
    servis = KombinDuellosuServisi(simdi: () => simdi);
  });

  test('ilk yüklemede her şey sıfır', () async {
    final durum = await servis.yukle();
    expect(durum.enIyiSkor, 0);
    expect(durum.gunlukSeri, 0);
    expect(durum.toplamXp, 0);
    expect(durum.bugunOynandi, isFalse);
    expect(durum.seviye, 1);
  });

  test('ilk tur seriyi 1 yapar ve skoru kaydeder', () async {
    final durum = await servis.turuKaydet(
      dogru: 7,
      toplam: 10,
      xp: 70,
      enIyiSeri: 4,
    );

    expect(durum.gunlukSeri, 1);
    expect(durum.enIyiSkor, 7);
    expect(durum.enIyiSeri, 4);
    expect(durum.toplamXp, 70);
    expect(durum.toplamTur, 10);
    expect(durum.bugunOynandi, isTrue);
  });

  test('aynı gün ikinci tur seriyi artırmaz', () async {
    await servis.turuKaydet(dogru: 7, toplam: 10, xp: 70, enIyiSeri: 4);
    final durum =
        await servis.turuKaydet(dogru: 5, toplam: 10, xp: 50, enIyiSeri: 2);

    expect(durum.gunlukSeri, 1);
    expect(durum.toplamXp, 120);
    expect(durum.toplamTur, 20);
    // En iyi skor düşmez.
    expect(durum.enIyiSkor, 7);
  });

  test('ertesi gün oynanınca seri artar', () async {
    await servis.turuKaydet(dogru: 6, toplam: 10, xp: 60, enIyiSeri: 3);
    simdi = simdi.add(const Duration(days: 1));

    final durum =
        await servis.turuKaydet(dogru: 8, toplam: 10, xp: 80, enIyiSeri: 5);

    expect(durum.gunlukSeri, 2);
    expect(durum.enIyiSkor, 8);
  });

  test('bir gün atlanınca seri 1den başlar', () async {
    await servis.turuKaydet(dogru: 6, toplam: 10, xp: 60, enIyiSeri: 3);
    simdi = simdi.add(const Duration(days: 3));

    final durum =
        await servis.turuKaydet(dogru: 4, toplam: 10, xp: 40, enIyiSeri: 2);

    expect(durum.gunlukSeri, 1);
  });

  test('yükleme bugün oynandı bilgisini verir', () async {
    await servis.turuKaydet(dogru: 6, toplam: 10, xp: 60, enIyiSeri: 3);
    expect((await servis.yukle()).bugunOynandi, isTrue);

    simdi = simdi.add(const Duration(days: 1));
    expect((await servis.yukle()).bugunOynandi, isFalse);
  });

  test('seviye 500 XPde artar', () async {
    await servis.turuKaydet(dogru: 10, toplam: 10, xp: 500, enIyiSeri: 10);
    final durum = await servis.yukle();
    expect(durum.seviye, 2);
    expect(durum.seviyeIlerlemesi, 0);
    expect(durum.sonrakiSeviyeyeKalan, 500);
  });

  test('gunAnahtari iki haneli biçim üretir', () {
    expect(gunAnahtari(DateTime(2026, 1, 5)), '2026-01-05');
    expect(gunAnahtari(DateTime(2026, 12, 31)), '2026-12-31');
  });
}
