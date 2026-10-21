// Sistem izin penceresinden önce gösterilen gerekçe sayfası.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fitcheck/l10n/app_localizations.dart';
import 'package:fitcheck/widgets/izin_gerekce_sayfasi.dart';

void main() {
  /// Gerekçe sayfasını açan bir düğme kurar; dönen değer sonuc değişkenine yazılır.
  Future<void> kur(WidgetTester tester, ValueChanged<bool?> sonuc) async {
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
                  sonuc(
                    await IzinGerekce.goster(
                      context,
                      baslik: 'Kamerayla kıyafet ekle',
                      aciklama: 'Kıyafetlerini fotoğraf olarak eklemek için.',
                      butonMetni: 'İzin Ver',
                      vazgecMetni: 'Şimdi değil',
                    ),
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
  }

  testWidgets('gerekçe açılır, birincil düğme kabul döndürür', (tester) async {
    bool? sonuc;
    await kur(tester, (deger) => sonuc = deger);

    await tester.tap(find.text('ac'));
    await tester.pumpAndSettle();

    expect(find.text('Kamerayla kıyafet ekle'), findsOneWidget);
    expect(find.text('İzin Ver'), findsOneWidget);
    expect(find.text('Şimdi değil'), findsOneWidget);

    await tester.tap(find.text('İzin Ver'));
    await tester.pumpAndSettle();

    expect(sonuc, isTrue);
    expect(find.text('Kamerayla kıyafet ekle'), findsNothing);
  });

  testWidgets('ikincil düğme reddedildi döndürür', (tester) async {
    bool? sonuc;
    await kur(tester, (deger) => sonuc = deger);

    await tester.tap(find.text('ac'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Şimdi değil'));
    await tester.pumpAndSettle();

    expect(sonuc, isFalse);
  });
}
