// Gardırop ekranı: arama + kategori filtresi davranışı (widget testi).

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fitcheck/l10n/app_localizations.dart';
import 'package:fitcheck/models/kiyafet.dart';
import 'package:fitcheck/screens/gardirobum_ekrani.dart';

final Uint8List _png = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8B'
  'QDwAEhQGAhKmMIQAAAABJRU5ErkJggg==',
);

Kiyafet _kiyafet(String id, String kategori, {String renk = 'Siyah'}) {
  return Kiyafet(
    id: id,
    baslik: id,
    kategori: kategori,
    resimBytes: _png,
    renk: renk,
    stil: 'Regular',
    eklenmeTarihi: DateTime(2026, 1, 1),
  );
}

void main() {
  setUpAll(() {
    // Ekran açılışta .env okuyor; testte sahte anahtar yeterli.
    dotenv.testLoad(fileInput: 'REMOVE_BG_API_KEY=test\nGEMINI_API_KEY=test');
  });

  final dolap = [
    _kiyafet('Beyaz Tişört', 'ust', renk: 'Beyaz'),
    _kiyafet('Siyah Pantolon', 'alt'),
    _kiyafet('Deri Ceket', 'ceket'),
    _kiyafet('Beyaz Sneaker', 'ayakkabi', renk: 'Beyaz'),
    _kiyafet('Hasır Çanta', 'aksesuar', renk: 'Bej'),
  ];

  Future<void> kur(WidgetTester tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    tester.view.physicalSize = const Size(390 * 3, 844 * 3);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('tr'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: GardirobumEkrani(
          gardirobum: dolap,
          onKiyafetEkle: (_) {},
          onKiyafetSil: (_) {},
          onGardirobuTemizle: () {},
          onSepetToggle: (_) {},
          onKombinIstegi: (_) {},
          anaRenk: Colors.indigo,
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 400));
  }

  testWidgets('arama kutusu ve kategori çipleri görünür', (tester) async {
    await kur(tester);

    expect(find.text('Dolabında ara'), findsOneWidget);
    for (final cip in ['Tümü', 'Üst', 'Alt', 'Ayakkabı', 'Aksesuar']) {
      expect(find.text(cip), findsWidgets, reason: '$cip çipi yok');
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('arama rafları süzer ve sonuç sayısını gösterir', (tester) async {
    await kur(tester);

    await tester.enterText(find.byType(TextField), 'beyaz');
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('2 Ürün'), findsOneWidget);
    expect(find.text('Beyaz Tişört'), findsWidgets);
    expect(find.text('Beyaz Sneaker'), findsWidgets);
    // Eşleşmeyen parça ve boşalan raflar gizlenir.
    expect(find.text('Siyah Pantolon'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('kategori çipi yalnız o rafı gösterir', (tester) async {
    await kur(tester);

    await tester.tap(find.text('Alt').first);
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('1 Ürün'), findsOneWidget);
    expect(find.text('Siyah Pantolon'), findsWidgets);
    expect(find.text('Beyaz Tişört'), findsNothing);
  });

  testWidgets('eşleşme yoksa mesaj ve temizle düğmesi çıkar', (tester) async {
    await kur(tester);

    await tester.enterText(find.byType(TextField), 'palto');
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Aramanla eşleşen parça yok.'), findsOneWidget);

    await tester.tap(find.text('Aramayı temizle'));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Beyaz Tişört'), findsWidgets);
    expect(find.text('Aramanla eşleşen parça yok.'), findsNothing);
  });
}
