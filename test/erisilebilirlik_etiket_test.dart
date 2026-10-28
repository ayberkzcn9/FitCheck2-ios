// İkon düğmeleri ekran okuyucuda (TalkBack/VoiceOver) anlamlı bir ad taşımalı.
//
// Tooltip, düğmenin erişilebilirlik etiketi olarak da kullanılır. Etiketsiz
// ikon düğmesi ekran okuyucuda yalnızca "düğme" olarak okunur; kullanıcı ne
// yaptığını bilemez.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fitcheck/l10n/app_localizations.dart';
import 'package:fitcheck/screens/giris_ekrani.dart';
import 'package:fitcheck/screens/seyahat_ekrani.dart';

Future<void> _pompala(WidgetTester tester, Widget ekran) async {
  await tester.pumpWidget(
    MaterialApp(
      locale: const Locale('tr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: ekran,
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 500));
}

void main() {
  final tr = lookupAppLocalizations(const Locale('tr'));

  testWidgets('seyahat gün sayısı düğmeleri etiketli', (tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    await _pompala(tester, SeyahatEkrani(gardirobum: const []));

    expect(find.byTooltip(tr.gunSayisiAzalt), findsOneWidget);
    expect(find.byTooltip(tr.gunSayisiArttir), findsOneWidget);
  });

  testWidgets('giriş şifre göster/gizle düğmesi etiketli', (tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    await _pompala(tester, const GirisEkrani());

    expect(find.byTooltip(tr.sifreGoster), findsOneWidget);
  });
}
