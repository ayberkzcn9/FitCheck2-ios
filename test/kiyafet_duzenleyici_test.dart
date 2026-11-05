// Kıyafet düzenleyici (arka plan + yerleşim) arayüz testi.

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;

import 'package:fitcheck/l10n/app_localizations.dart';
import 'package:fitcheck/widgets/kiyafet_duzenleyici.dart';

Uint8List _kesimUret() {
  final gorsel = img.Image(width: 200, height: 200, numChannels: 4);
  img.fill(gorsel, color: img.ColorRgba8(0, 0, 0, 0));
  img.fillRect(
    gorsel,
    x1: 50,
    y1: 50,
    x2: 150,
    y2: 150,
    color: img.ColorRgba8(220, 60, 60, 255),
  );
  return img.encodePng(gorsel);
}

void main() {
  Future<void> kur(WidgetTester tester) async {
    tester.view.physicalSize = const Size(390 * 3, 844 * 3);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('tr'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: KiyafetDuzenleyici(kesim: _kesimUret()),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('başlık, ipucu ve zemin çipleri görünür', (tester) async {
    await kur(tester);

    expect(find.text('Arka plan ve yerleşim'), findsOneWidget);
    expect(find.textContaining('sürükleyerek yerleştirebilir'), findsOneWidget);
    expect(find.text('Beyaz'), findsOneWidget);
    expect(find.text('Kırık beyaz'), findsOneWidget);
    expect(find.text('Açık gri'), findsOneWidget);
    expect(find.text('Saydam'), findsOneWidget);
    expect(find.text('Kaydet'), findsOneWidget);
    expect(find.text('Varsayılan'), findsOneWidget);
  });

  testWidgets('zemin değiştirilebilir', (tester) async {
    await kur(tester);

    await tester.tap(find.text('Açık gri'));
    await tester.pumpAndSettle();

    final cip = tester.widget<ChoiceChip>(find.ancestor(
      of: find.text('Açık gri'),
      matching: find.byType(ChoiceChip),
    ));
    expect(cip.selected, isTrue);
  });

  testWidgets('sürükleme parçayı kaydırır', (tester) async {
    await kur(tester);

    final onceki = tester.getRect(find.byType(Image).first);

    await tester.drag(
      find.byKey(const Key('kiyafet-duzenleyici-tuval')),
      const Offset(40, 30),
    );
    await tester.pumpAndSettle();

    final sonraki = tester.getRect(find.byType(Image).first);
    expect(
      (sonraki.left - onceki.left).abs() + (sonraki.top - onceki.top).abs(),
      greaterThan(1),
    );
  });

  testWidgets('kaydet birleştirme sonucunu döndürür', (tester) async {
    Uint8List? sonuc;
    tester.view.physicalSize = const Size(390 * 3, 844 * 3);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('tr'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Builder(
            builder: (context) => Center(
              child: ElevatedButton(
                onPressed: () async {
                  sonuc = await KiyafetDuzenleyici.ac(
                    context,
                    kesim: _kesimUret(),
                    // Birleştirme servisi ayrı testlerde doğrulanır; bu UI
                    // testi platform izolasyon zamanlamasına bağlanmaz.
                    birlestirici: (kesim) async => Uint8List.fromList(kesim),
                  );
                },
                child: const Text('ac'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('ac'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Kaydet'));
    await tester.pumpAndSettle();

    expect(sonuc, isNotNull);
    expect(sonuc!.isNotEmpty, isTrue);
    expect(tester.takeException(), isNull);
  });
}
