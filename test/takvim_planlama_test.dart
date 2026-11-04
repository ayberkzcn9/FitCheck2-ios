// Takvimde güne kombin atama: model, depo, takvim birleşimi ve arayüz.

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fitcheck/l10n/app_localizations.dart';
import 'package:fitcheck/models/favori_kombin.dart';
import 'package:fitcheck/models/kiyafet.dart';
import 'package:fitcheck/models/planli_kombin.dart';
import 'package:fitcheck/screens/stil_gunlugu_ekrani.dart';
import 'package:fitcheck/services/bildirim_metinleri.dart';
import 'package:fitcheck/services/kombin_takvimi.dart';
import 'package:fitcheck/services/planli_kombin_deposu.dart';
import 'package:fitcheck/utils/takvim_gunleri.dart';

final Uint8List _png = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8B'
  'QDwAEhQGAhKmMIQAAAABJRU5ErkJggg==',
);

Kiyafet _kiyafet(String id, String kategori) {
  return Kiyafet(
    id: id,
    baslik: id,
    kategori: kategori,
    resimBytes: _png,
    renk: 'Siyah',
    stil: 'Regular',
    eklenmeTarihi: DateTime(2026, 1, 1),
  );
}

void main() {
  group('PlanliKombin', () {
    test('JSON gidiş-dönüş', () {
      const plan = PlanliKombin(
        tarih: '2026-10-25',
        baslik: 'Klasik Kombin',
        parcalar: ['Beyaz Gömlek', 'Siyah Pantolon'],
      );

      final geri = PlanliKombin.fromJson(plan.toJson());

      expect(geri, plan);
      expect(geri.baslik, 'Klasik Kombin');
      expect(geri.parcalar, ['Beyaz Gömlek', 'Siyah Pantolon']);
    });

    test('eksik alanlar çökmeye yol açmaz', () {
      final plan = PlanliKombin.fromJson(<String, dynamic>{});
      expect(plan.tarih, '');
      expect(plan.baslik, '');
      expect(plan.parcalar, isEmpty);
    });
  });

  group('PlanliKombinDeposu.coz', () {
    test('boş ve bozuk girdi boş harita', () {
      expect(PlanliKombinDeposu.coz(null), isEmpty);
      expect(PlanliKombinDeposu.coz('   '), isEmpty);
      expect(PlanliKombinDeposu.coz('bu json değil'), isEmpty);
    });

    test('geçerli kayıtlar tarih anahtarıyla toplanır', () {
      final ham = jsonEncode([
        {
          'tarih': '2026-10-25',
          'baslik': 'Klasik Kombin',
          'parcalar': ['Beyaz Gömlek'],
        },
        {
          'tarih': '2026-10-26',
          'baslik': 'Spor Kombin',
          'parcalar': <String>[],
        },
      ]);

      final planlar = PlanliKombinDeposu.coz(ham);
      expect(planlar.keys, containsAll(<String>['2026-10-25', '2026-10-26']));
      expect(planlar['2026-10-25']!.baslik, 'Klasik Kombin');
    });

    test('tarihi veya başlığı olmayan kayıt atlanır', () {
      final ham = jsonEncode([
        {'tarih': '', 'baslik': 'Boş tarih'},
        {'tarih': '2026-10-25', 'baslik': ''},
        {'tarih': '2026-10-27', 'baslik': 'Geçerli'},
      ]);

      final planlar = PlanliKombinDeposu.coz(ham);
      expect(planlar.length, 1);
      expect(planlar['2026-10-27']!.baslik, 'Geçerli');
    });
  });

  group('depo yazma', () {
    setUp(() {
      SharedPreferences.setMockInitialValues(<String, Object>{});
    });

    test('ata, yukle ve kaldir', () async {
      final depo = PlanliKombinDeposu();

      await depo.ata(
        const PlanliKombin(
          tarih: '2026-10-25',
          baslik: 'Klasik Kombin',
          parcalar: ['Beyaz Gömlek'],
        ),
      );

      var planlar = await depo.yukle();
      expect(planlar['2026-10-25']!.baslik, 'Klasik Kombin');

      // Aynı güne ikinci atama üzerine yazar.
      await depo.ata(
        const PlanliKombin(
          tarih: '2026-10-25',
          baslik: 'Yeni Kombin',
          parcalar: ['Siyah Pantolon'],
        ),
      );
      planlar = await depo.yukle();
      expect(planlar.length, 1);
      expect(planlar['2026-10-25']!.baslik, 'Yeni Kombin');

      await depo.kaldir('2026-10-25');
      planlar = await depo.yukle();
      expect(planlar, isEmpty);
    });
  });

  group('takvim birleşimi', () {
    final simdi = DateTime(2026, 10, 20, 9);

    test('tarihe özel plan güne düşer ve planVar true olur', () {
      final gunler = KombinTakvimi.ay(
        ay: DateTime(2026, 10),
        gecmis: const [],
        program: null,
        simdi: simdi,
        planliKombinler: const {
          '2026-10-25': PlanliKombin(
            tarih: '2026-10-25',
            baslik: 'Klasik Kombin',
            parcalar: ['Beyaz Gömlek'],
          ),
        },
      );

      final gun = gunler
          .whereType<TakvimGunu>()
          .firstWhere((g) => g.tarih.day == 25);
      expect(gun.planliKombin?.baslik, 'Klasik Kombin');
      expect(gun.planVar, isTrue);
      expect(gun.bos, isFalse);
      expect(gun.planlanan, isEmpty);
    });

    test('tarihe özel plan haftalık programı silmez, ikisi birlikte görünür', () {
      final program = <String, dynamic>{
        'hafta': [
          {'gun': 'Sunday', 'kombin_adi': 'Pazar kombini'},
        ],
      };

      final gunler = KombinTakvimi.ay(
        ay: DateTime(2026, 10),
        gecmis: const [],
        program: program,
        simdi: simdi,
        planliKombinler: const {
          '2026-10-25': PlanliKombin(
            tarih: '2026-10-25',
            baslik: 'Klasik Kombin',
            parcalar: <String>[],
          ),
        },
      );

      final pazar = gunler
          .whereType<TakvimGunu>()
          .firstWhere((g) => g.tarih.day == 25);
      expect(pazar.planliKombin?.baslik, 'Klasik Kombin');
      expect(pazar.planlanan, ['Pazar kombini']);
    });
  });

  group('bildirim metni', () {
    test('tarihe özel plan haftalık programın önüne geçer', () {
      final gunler = BildirimMetinleri.gunler(
        program: const <String, dynamic>{
          'hafta': [
            {'gun': 'Wednesday', 'kombin_adi': 'Haftalık kombini'},
          ],
        },
        simdi: DateTime(2026, 10, 20, 9), // salı
        planliKombinler: const {
          '2026-10-21': PlanliKombin(
            tarih: '2026-10-21',
            baslik: 'Özel Kombin',
            parcalar: <String>[],
          ),
        },
      );

      // 21 Ekim Çarşamba: hem program hem tarihe özel plan var → özel kazanır.
      expect(gunler[1].kombinAdi, 'Özel Kombin');
      // 20 Ekim Salı: ikisi de yok.
      expect(gunler[0].kombinAdi, isNull);
    });

    test('tarihe özel plan yoksa haftalık program kullanılır', () {
      final gunler = BildirimMetinleri.gunler(
        program: const <String, dynamic>{
          'hafta': [
            {'gun': 'Wednesday', 'kombin_adi': 'Haftalık kombini'},
          ],
        },
        simdi: DateTime(2026, 10, 21, 9), // çarşamba
      );

      expect(gunler[0].kombinAdi, 'Haftalık kombini');
    });

    test('boş başlıklı plan programı ezmez', () {
      final gunler = BildirimMetinleri.gunler(
        program: const <String, dynamic>{
          'hafta': [
            {'gun': 'Wednesday', 'kombin_adi': 'Haftalık kombini'},
          ],
        },
        simdi: DateTime(2026, 10, 21, 9),
        planliKombinler: const {
          '2026-10-21': PlanliKombin(
            tarih: '2026-10-21',
            baslik: '   ',
            parcalar: <String>[],
          ),
        },
      );

      expect(gunler[0].kombinAdi, 'Haftalık kombini');
    });
  });

  group('arayüz', () {
    final dolap = [
      _kiyafet('Beyaz Gömlek', 'ust'),
      _kiyafet('Siyah Pantolon', 'alt'),
    ];
    final favoriler = <FavoriKombin>[
      FavoriKombin(
        id: 'f1',
        baslik: 'Klasik Kombin',
        parcalar: ['Beyaz Gömlek', 'Siyah Pantolon'],
        tuyo: 'Zamansız',
        renkUyumuPuani: 92,
      ),
    ];

    Future<void> kur(
      WidgetTester tester, {
      List<Kiyafet>? dolapListesi,
      List<FavoriKombin>? favoriListesi,
      VoidCallback? kombinSekmesi,
      List<Map<String, String>> gecmis = const <Map<String, String>>[],
    }) async {
      // Telefon boyutu: 800×600 varsayılanında takvimin alt satırları ekran
      // dışında kalıyor.
      tester.view.physicalSize = const Size(390 * 3, 844 * 3);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('tr'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          // Ekran gerçek uygulamada push ile açılıyor; "Kombin oluştur"
          // davranışı da ekranı kapatmayı gerektirdiği için aynı düzen kurulur.
          home: Builder(
            builder: (baglam) => Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.of(baglam).push(
                    MaterialPageRoute<void>(
                      builder: (_) => StilGunluguEkrani(
                        gardirobum: dolapListesi ?? dolap,
                        gecmisKombinler: gecmis,
                        favoriKombinler: favoriListesi ?? favoriler,
                        onKombinSekmesineGit: kombinSekmesi,
                      ),
                    ),
                  ),
                  child: const Text('aç'),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('aç'));
      await tester.pumpAndSettle();
    }

    /// Takvimde bugünün hücresine dokunur (ay her zaman bugünü içerir).
    Future<void> buguneDokun(WidgetTester tester) async {
      await tester.tap(find.text('${DateTime.now().day}').first);
      await tester.pumpAndSettle();
    }

    testWidgets('bugüne kombin atanır ve depoya yazılır', (tester) async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      await kur(tester);

      await buguneDokun(tester);
      expect(find.text('Bu güne kombin seç'), findsOneWidget);

      await tester.tap(find.text('Bu güne kombin seç'));
      await tester.pumpAndSettle();
      expect(find.text('Kombin seç'), findsOneWidget);

      await tester.tap(find.text('Klasik Kombin'));
      await tester.pumpAndSettle();

      expect(find.text('Kombin güne eklendi'), findsOneWidget);

      final prefs = await SharedPreferences.getInstance();
      final planlar = PlanliKombinDeposu.coz(
        prefs.getString(PlanliKombinDeposu.anahtar),
      );
      final bugun = gunAnahtari(DateTime.now());
      expect(planlar[bugun]?.baslik, 'Klasik Kombin');
      expect(planlar[bugun]?.parcalar, ['Beyaz Gömlek', 'Siyah Pantolon']);
    });

    testWidgets('planlı gün detayında değiştir ve kaldır görünür', (tester) async {
      final bugun = gunAnahtari(DateTime.now());
      SharedPreferences.setMockInitialValues(<String, Object>{
        PlanliKombinDeposu.anahtar: jsonEncode([
          {
            'tarih': bugun,
            'baslik': 'Klasik Kombin',
            'parcalar': ['Beyaz Gömlek', 'Siyah Pantolon'],
          }
        ]),
      });
      await kur(tester);

      await buguneDokun(tester);

      expect(find.text('Klasik Kombin'), findsOneWidget);
      expect(find.text('2 parça'), findsOneWidget);
      expect(find.text('Değiştir'), findsOneWidget);
      expect(find.text('Kaldır'), findsOneWidget);
      expect(find.text('Bu güne kombin seç'), findsNothing);
    });

    testWidgets('kaldır planı siler, geri al ile geri gelir', (tester) async {
      final bugun = gunAnahtari(DateTime.now());
      SharedPreferences.setMockInitialValues(<String, Object>{
        PlanliKombinDeposu.anahtar: jsonEncode([
          {
            'tarih': bugun,
            'baslik': 'Klasik Kombin',
            'parcalar': ['Beyaz Gömlek'],
          }
        ]),
      });
      await kur(tester);

      await buguneDokun(tester);
      await tester.tap(find.text('Kaldır'));
      await tester.pumpAndSettle();

      expect(find.text('Plan kaldırıldı'), findsOneWidget);

      var planlar = PlanliKombinDeposu.coz(
        (await SharedPreferences.getInstance())
            .getString(PlanliKombinDeposu.anahtar),
      );
      expect(planlar, isEmpty);

      // "Geri al" planı yeniden yazar.
      await tester.tap(find.text('Geri al'));
      await tester.pumpAndSettle();

      planlar = PlanliKombinDeposu.coz(
        (await SharedPreferences.getInstance())
            .getString(PlanliKombinDeposu.anahtar),
      );
      expect(planlar[bugun]?.baslik, 'Klasik Kombin');
    });

    testWidgets('son giyilenler de seçilebilir', (tester) async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      await kur(
        tester,
        favoriListesi: const <FavoriKombin>[],
        gecmis: const [
          {
            'tarih': '2026-10-18',
            'baslik': 'Ofis kombini',
            'detay': 'Beyaz Gömlek, Siyah Pantolon',
          },
        ],
      );

      await buguneDokun(tester);
      await tester.tap(find.text('Bu güne kombin seç'));
      await tester.pumpAndSettle();

      expect(find.text('Son giyilenler'), findsOneWidget);
      expect(find.text('Ofis kombini'), findsOneWidget);

      await tester.tap(find.text('Ofis kombini'));
      await tester.pumpAndSettle();

      final prefs = await SharedPreferences.getInstance();
      final planlar = PlanliKombinDeposu.coz(
        prefs.getString(PlanliKombinDeposu.anahtar),
      );
      final bugun = gunAnahtari(DateTime.now());
      expect(planlar[bugun]?.baslik, 'Ofis kombini');
      expect(planlar[bugun]?.parcalar, ['Beyaz Gömlek', 'Siyah Pantolon']);
    });

    testWidgets('öneriler bölümü kural bazlı kombini önerir', (tester) async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      await kur(
        tester,
        favoriListesi: const <FavoriKombin>[],
      );

      await buguneDokun(tester);
      await tester.tap(find.text('Bu güne kombin seç'));
      await tester.pumpAndSettle();

      expect(find.text('Öneriler'), findsOneWidget);

      // Öneri satırı seçilip güne atanmalı.
      await tester.tap(find.text('Beyaz Gömlek + Siyah Pantolon'));
      await tester.pumpAndSettle();

      final prefs = await SharedPreferences.getInstance();
      final planlar = PlanliKombinDeposu.coz(
        prefs.getString(PlanliKombinDeposu.anahtar),
      );
      final bugun = gunAnahtari(DateTime.now());
      expect(planlar[bugun], isNotNull);
      expect(planlar[bugun]!.parcalar, isNotEmpty);
    });

    testWidgets('favori yoksa kombin oluştur sekmesine yönlendirir', (tester) async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      var yonlendirildi = false;
      await kur(
        tester,
        // Boş dolap: öneri de üretilemiyor, tek yol "Kombin oluştur".
        dolapListesi: const <Kiyafet>[],
        favoriListesi: const <FavoriKombin>[],
        kombinSekmesi: () => yonlendirildi = true,
      );

      await buguneDokun(tester);
      await tester.tap(find.text('Bu güne kombin seç'));
      await tester.pumpAndSettle();

      expect(find.text('Henüz favori kombinin yok.'), findsOneWidget);
      await tester.tap(find.text('Kombin oluştur'));
      await tester.pumpAndSettle();

      expect(yonlendirildi, isTrue);
      expect(find.text('Stil Günlüğüm'), findsNothing);
      expect(tester.takeException(), isNull);
    });
  });
}
