// Profil & Analiz ekranındaki bilgi düğmeleri.

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fitcheck/l10n/app_localizations.dart';
import 'package:fitcheck/models/favori_kombin.dart';
import 'package:fitcheck/models/kiyafet.dart';
import 'package:fitcheck/screens/profil_analiz_ekrani.dart';

final Uint8List _png = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8B'
  'QDwAEhQGAhKmMIQAAAABJRU5ErkJggg==',
);

Kiyafet _kiyafet(String id, String kategori, {int giyilme = 0}) {
  return Kiyafet(
    id: id,
    baslik: id,
    kategori: kategori,
    resimBytes: _png,
    renk: 'Siyah',
    stil: 'Regular',
    giyilmeSayisi: giyilme,
    eklenmeTarihi: DateTime(2026, 1, 1),
  );
}

void main() {
  final dolap = [
    _kiyafet('Beyaz Tişört', 'ust', giyilme: 4),
    _kiyafet('Siyah Pantolon', 'alt', giyilme: 3),
    _kiyafet('Yün Kaban', 'ceket', giyilme: 1),
    _kiyafet('Beyaz Sneaker', 'ayakkabi', giyilme: 0),
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
        home: ProfilVeAnalizEkrani(
          gardirobum: dolap,
          favoriKombinler: const <FavoriKombin>[],
          gecmisKombinler: const <Map<String, String>>[],
          gunlukHava: 'İstanbul • 21°C • Parçalı Bulutlu',
          anaRenk: Colors.indigo,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  /// Belirli bir ölçütün bilgi düğmesi (tooltip = ölçüt adı).
  Finder bilgiDugmesi(String olcutAdi) {
    return find.descendant(
      of: find.byTooltip(olcutAdi),
      matching: find.byIcon(Icons.info_outline_rounded),
    );
  }

  testWidgets('dolap verimliliği bilgi düğmesi açıklamayı gösterir', (tester) async {
    await kur(tester);

    expect(bilgiDugmesi('Dolap Verimliliği'), findsOneWidget);

    await tester.tap(bilgiDugmesi('Dolap Verimliliği'));
    await tester.pumpAndSettle();

    expect(find.text('Dolap Verimliliği'), findsWidgets);
    expect(find.textContaining('en az bir kez giyildiğini'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('bilgi sayfası kapatılabilir', (tester) async {
    await kur(tester);

    await tester.tap(bilgiDugmesi('Dolap Verimliliği'));
    await tester.pumpAndSettle();

    expect(find.textContaining('en az bir kez giyildiğini'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.close_rounded).last);
    await tester.pumpAndSettle();

    expect(find.textContaining('en az bir kez giyildiğini'), findsNothing);
  });

  testWidgets('diğer ölçütlerde de bilgi düğmesi var', (tester) async {
    await kur(tester);

    for (final olcut in [
      'Stil Kimliğin',
      'Anlık Durum',
      'Çamaşır Sepeti',
    ]) {
      expect(bilgiDugmesi(olcut), findsOneWidget, reason: '$olcut bilgi düğmesi yok');
    }
  });
}
