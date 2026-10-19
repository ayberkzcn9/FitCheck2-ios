// Stilist Hafızası modalının (Ayarlar > Stilist Hafızası) arayüz davranışı.
//
// Kritik davranışlar:
//  • Hafıza boşken "henüz bir şey öğrenmedim" mesajı gösterilir, silme
//    düğmesi çıkmaz.
//  • Notlar ve özet kullanıcıya olduğu gibi listelenir.
//  • "Hafızayı temizle" yalnızca onaydan sonra siler; iptal edilirse hafıza
//    korunur.
//
// Çalıştırma: flutter test test/stilist_hafizasi_modal_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fitcheck/l10n/app_localizations.dart';
import 'package:fitcheck/services/stilist_hafizasi.dart';
import 'package:fitcheck/widgets/modals/stilist_hafizasi_modal.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final hafiza = StilistHafizasi();

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    await hafiza.acikAyarla(true);
    await hafiza.temizle();
  });

  Future<AppLocalizations> modal(
    WidgetTester tester, {
    VoidCallback? onDegisti,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('tr'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: StilistHafizasiModal(onDegisti: onDegisti),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return AppLocalizations.delegate.load(const Locale('tr'));
  }

  Future<void> notlariKaydet() async {
    hafiza.ogrenmeyiUygula(<String, dynamic>{
      'notlar': <String>['Oversize ust sever', 'Koyu renklerden kacinir'],
      'ozet': 'Ofis icin sade kombinler istiyor.',
    });
    await hafiza.kaydet();
  }

  testWidgets('hafıza boşken öğrenme mesajı görünür, silme düğmesi çıkmaz',
      (tester) async {
    final l10n = await modal(tester);

    expect(find.text(l10n.stilistHafizasiBos), findsOneWidget);
    expect(find.text(l10n.stilistHafizasiNelerBiliyor), findsNothing);
    expect(find.text(l10n.stilistHafizasiTemizle), findsNothing);
  });

  testWidgets('notlar ve özet listelenir', (tester) async {
    await notlariKaydet();
    final l10n = await modal(tester);

    expect(find.text(l10n.stilistHafizasiNelerBiliyor), findsOneWidget);
    expect(find.text('Oversize ust sever'), findsOneWidget);
    expect(find.text('Koyu renklerden kacinir'), findsOneWidget);
    expect(find.text(l10n.stilistHafizasiOzetBaslik), findsOneWidget);
    expect(find.text('Ofis icin sade kombinler istiyor.'), findsOneWidget);
    expect(find.text(l10n.stilistHafizasiBos), findsNothing);
  });

  testWidgets('onaylanan temizleme hafızayı siler ve haber verir',
      (tester) async {
    await notlariKaydet();
    var haberVerildi = false;
    final l10n = await modal(tester, onDegisti: () => haberVerildi = true);

    await tester.tap(
      find.widgetWithText(OutlinedButton, l10n.stilistHafizasiTemizle),
    );
    await tester.pumpAndSettle();
    expect(find.text(l10n.stilistHafizasiTemizleOnay), findsOneWidget);

    await tester.tap(find.widgetWithText(TextButton, l10n.tamam));
    await tester.pumpAndSettle();

    expect(haberVerildi, isTrue);
    expect(find.text('Oversize ust sever'), findsNothing);
    expect(find.text(l10n.stilistHafizasiBos), findsOneWidget);

    // Diskteki kayıt da temizlenmiş olmalı.
    final ikinciKopya = StilistHafizasi();
    await ikinciKopya.yukle(zorla: true);
    expect(ikinciKopya.notlar, isEmpty);
    expect(ikinciKopya.ozet, isEmpty);
  });

  testWidgets('iptal edilen temizleme hafızayı korur', (tester) async {
    await notlariKaydet();
    var haberVerildi = false;
    final l10n = await modal(tester, onDegisti: () => haberVerildi = true);

    await tester.tap(
      find.widgetWithText(OutlinedButton, l10n.stilistHafizasiTemizle),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, l10n.iptal));
    await tester.pumpAndSettle();

    expect(haberVerildi, isFalse);
    expect(find.text('Oversize ust sever'), findsOneWidget);
  });
}
