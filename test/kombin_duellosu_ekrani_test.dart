// "Kombin Düellosu" ekran testleri.
//
// Amaç: lobi → tur → geri bildirim → sonuç akışının gerçekten çizildiğini
// ve doğru cevabın motordan gelen tarafla aynı olduğunu görmek.
// Ağ yok, SharedPreferences sahte.

import 'package:fitcheck/l10n/app_localizations.dart';
import 'package:fitcheck/models/kiyafet.dart';
import 'package:fitcheck/screens/kombin_duellosu_ekrani.dart';
import 'package:fitcheck/services/kombin_duellosu_motoru.dart';
import 'package:fitcheck/services/kombin_duellosu_servisi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  Future<void> kur(
    WidgetTester tester, {
    List<Kiyafet> dolap = const <Kiyafet>[],
    int tohum = 7,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('tr'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: KombinDuellosuEkrani(
            gardirobum: dolap,
            motor: DuelMotoru(),
            servisi: KombinDuellosuServisi(),
            tohum: tohum,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('lobi başlık, kural ve başlat düğmesini gösterir', (tester) async {
    await kur(tester);

    expect(find.text('Kombin Düellosu'), findsOneWidget);
    expect(find.text('Düelloya başla'), findsOneWidget);
    expect(find.text('Nasıl oynanır?'), findsOneWidget);
    expect(find.text('Her turda iki kombin görürsün.'), findsOneWidget);
  });

  testWidgets('boş dolapta renk kartı notu ve dolap düğmesi görünür',
      (tester) async {
    await kur(tester);

    expect(find.text('Dolaba parça ekle'), findsOneWidget);

    await tester.tap(find.text('Düelloya başla'));
    await tester.pumpAndSettle();

    expect(find.text('Tur 1/10'), findsOneWidget);
    expect(
      find.textContaining('Bu turda renk kartları var'),
      findsOneWidget,
    );
  });

  testWidgets('doğru karta dokununca Doğru! ve XP gösterilir', (tester) async {
    await kur(tester, tohum: 7);

    final beklenen = DuelMotoru()
        .uret(gardirobum: const <Kiyafet>[], adet: 10, tohum: 7)
        .sorular
        .first;

    await tester.tap(find.text('Düelloya başla'));
    await tester.pumpAndSettle();

    await tester.tap(find.text(beklenen.solDogru ? 'A' : 'B'));
    await tester.pumpAndSettle();

    expect(find.text('Doğru!'), findsOneWidget);
    expect(find.text('+10 XP'), findsOneWidget);
    expect(find.text('Devam'), findsOneWidget);
  });

  testWidgets('yanlış karta dokununca Olmadı gösterilir', (tester) async {
    await kur(tester, tohum: 7);

    final beklenen = DuelMotoru()
        .uret(gardirobum: const <Kiyafet>[], adet: 10, tohum: 7)
        .sorular
        .first;

    await tester.tap(find.text('Düelloya başla'));
    await tester.pumpAndSettle();

    await tester.tap(find.text(beklenen.solDogru ? 'B' : 'A'));
    await tester.pumpAndSettle();

    expect(find.text('Olmadı'), findsOneWidget);
    expect(find.text('+0 XP'), findsOneWidget);
  });

  testWidgets('on tur sonunda sonuç ekranı açılır', (tester) async {
    await kur(tester);

    await tester.tap(find.text('Düelloya başla'));
    await tester.pumpAndSettle();

    for (var tur = 0; tur < 10; tur++) {
      await tester.tap(find.text('A'));
      await tester.pumpAndSettle();

      final sonTur = tur == 9;
      await tester.tap(find.text(sonTur ? 'Sonucu gör' : 'Devam'));
      await tester.pumpAndSettle();
    }

    expect(find.text('Tekrar oyna'), findsOneWidget);
    expect(find.text('Düello bitti'), findsOneWidget);
    expect(find.textContaining('/10 doğru'), findsOneWidget);
  });

  testWidgets('tekrar oyna lobiye değil yeni tura götürür', (tester) async {
    await kur(tester);

    await tester.tap(find.text('Düelloya başla'));
    await tester.pumpAndSettle();
    for (var tur = 0; tur < 10; tur++) {
      await tester.tap(find.text('A'));
      await tester.pumpAndSettle();
      await tester.tap(find.text(tur == 9 ? 'Sonucu gör' : 'Devam'));
      await tester.pumpAndSettle();
    }

    await tester.tap(find.text('Tekrar oyna'));
    await tester.pumpAndSettle();

    expect(find.text('Tur 1/10'), findsOneWidget);
  });
}
