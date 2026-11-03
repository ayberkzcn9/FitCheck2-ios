import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fitcheck/l10n/app_localizations.dart';
import 'package:fitcheck/models/kiyafet.dart';
import 'package:fitcheck/screens/profil_bilesenleri/profil_widgets.dart';

Kiyafet _kiyafet({required int giyilme, required double fiyat}) => Kiyafet(
      id: 'test-kiyafet',
      baslik: 'Lacivert Ceket',
      kategori: 'ust',
      resimBytes: Uint8List(0),
      renk: 'Lacivert',
      stil: 'Klasik',
      giyilmeSayisi: giyilme,
      fiyat: fiyat,
      eklenmeTarihi: DateTime(2026, 1, 1),
    );

Widget _uygulama(Kiyafet kiyafet) => MaterialApp(
      locale: const Locale('tr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: KiyafetKartcigi(kiyafet: kiyafet, isSoluk: false),
      ),
    );

void main() {
  testWidgets('giyilmiş ve fiyatı bilinen parçada giyim başı maliyet gösterilir',
      (tester) async {
    await tester.pumpWidget(_uygulama(_kiyafet(giyilme: 4, fiyat: 80)));

    expect(find.textContaining('Maliyet:'), findsOneWidget);
    expect(find.textContaining('₺'), findsOneWidget);
  });

  testWidgets('giyilme veya fiyat bilgisi yoksa maliyet uydurulmaz',
      (tester) async {
    await tester.pumpWidget(_uygulama(_kiyafet(giyilme: 0, fiyat: 80)));
    expect(find.textContaining('Maliyet:'), findsNothing);

    await tester.pumpWidget(_uygulama(_kiyafet(giyilme: 4, fiyat: 0)));
    expect(find.textContaining('Maliyet:'), findsNothing);
  });
}
