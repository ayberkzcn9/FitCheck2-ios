// Alt menü çubuğunun testleri: 6 sekme, etiketler, 320 dp taşma kontrolü.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fitcheck/l10n/app_localizations.dart';
import 'package:fitcheck/widgets/alt_menu_cubugu.dart';

void main() {
  Future<void> kur(
    WidgetTester tester, {
    int secili = Sekmeler.bugun,
    bool gorunur = true,
    double genislik = 390,
    Size? olcum,
    ValueChanged<int>? onSec,
  }) async {
    tester.view.physicalSize = Size(genislik, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('tr'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: const SizedBox.expand(),
          bottomNavigationBar: AltMenuCubugu(
            seciliSekme: secili,
            gorunur: gorunur,
            onSec: onSec ?? (_) {},
            anahtarlar: const <int, Key>{
              Sekmeler.bugun: Key('nav_bugun'),
              Sekmeler.dolap: Key('nav_dolap'),
              Sekmeler.plan: Key('nav_plan'),
              Sekmeler.kombin: Key('nav_kombin'),
              Sekmeler.profil: Key('nav_profil'),
              Sekmeler.oyun: Key('nav_oyun'),
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('altı sekme ve kısa etiketler görünür', (tester) async {
    await kur(tester);

    for (final etiket in ['Bugün', 'Gardırop', 'Haftalık', 'Kombin', 'Profil', 'Düello']) {
      expect(find.text(etiket), findsOneWidget, reason: '$etiket eksik');
    }
    // Kapalı sekme ("Kendin Kombin Yap") menüde yok.
    expect(find.text('Kendi Kombinini Tasarla'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('dokunma doğru sekmeyi bildirir', (tester) async {
    int? secilen;
    await kur(tester, onSec: (i) => secilen = i);

    await tester.tap(find.byKey(const Key('nav_oyun')));
    await tester.pumpAndSettle();

    expect(secilen, Sekmeler.oyun);
  });

  testWidgets('seçili sekme yeniden seçilirse çağrı yapılmaz', (tester) async {
    var cagri = 0;
    await kur(tester, secili: Sekmeler.plan, onSec: (_) => cagri++);

    await tester.tap(find.byKey(const Key('nav_plan')));
    await tester.pumpAndSettle();

    expect(cagri, 0);
  });

  testWidgets('etiketler 320 dp genişlikte taşmaz', (tester) async {
    await kur(tester, genislik: 320);

    expect(tester.takeException(), isNull);

    // Her etiket kendi sekmesinin genişliğine sığmalı (kırpma sessiz kalmasın).
    final sekmeGenisligi = (320 - 16) / 6;
    for (final etiket in ['Bugün', 'Gardırop', 'Haftalık', 'Kombin', 'Profil', 'Düello']) {
      final kutu = tester.getSize(find.text(etiket));
      expect(
        kutu.width,
        lessThanOrEqualTo(sekmeGenisligi),
        reason: '$etiket ${kutu.width} dp, sekme ${sekmeGenisligi.toStringAsFixed(1)} dp',
      );
      expect(tester.widget<Text>(find.text(etiket)).overflow, TextOverflow.ellipsis);
    }
  });

  testWidgets('menü gizliyken yüksekliği sıfırlanır', (tester) async {
    await kur(tester, gorunur: false);

    final yukseklik = tester.getSize(find.byType(AltMenuCubugu)).height;
    expect(yukseklik, 0);
  });
}
