// Gerçek uygulama kabuğunun (Onboarding, ana kabuk, Ayarlar) görsel
// incelemesi. Bu ekranlar satın alma, konuşma, sensör gibi cihaz eklentilerine
// dokunuyor; widget testinde bu kanallar yok ve test sonunda hata bildiriyorlar.
//
// Görüntüleri yenilemek için:
//   flutter test test/ui_kabuk_inceleme_test.dart --run-skipped
// (Komut, eklenti hataları yüzünden kırmızı bitebilir; build/ui-review
// klasöründeki PNG'ler yine de üretilir.)

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fitcheck/main.dart';
import 'package:fitcheck/screens/ayarlar_ekrani.dart';

import 'ui_inceleme_test.dart' as inceleme;

void main() {
  testWidgets(
    'kabuk, onboarding ve ayarlar cizilir',
    // Cihaz eklentisi kanalları gerektiriyor; --run-skipped ile çalıştırın.
    skip: true,
    (tester) async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      dotenv.testLoad(fileInput: 'REMOVE_BG_API_KEY=test');

      tester.view.physicalSize = const Size(390 * 2, 844 * 2);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      Future<void> kabuguAc({required bool onboarding}) async {
        await tester.pumpWidget(
          KombinDanismaniApp(
            onboardingTamamlandi: onboarding,
            baslangicTemaModuStr: 'light',
            baslatmaIslemi: Future<UygulamaBaslatmaSonucu>.value(
              const UygulamaBaslatmaSonucu(firebaseHazir: false),
            ),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 1200));
        await inceleme.bekle(tester);
      }

      await kabuguAc(onboarding: false);
      await inceleme.goruntu(tester, '31_onboarding');

      await kabuguAc(onboarding: true);
      await inceleme.goruntu(tester, '34_kabuk');

      final kabuk = tester.element(find.byType(Scaffold).first);
      Navigator.of(kabuk).push(
        MaterialPageRoute<void>(builder: (_) => const AyarlarEkrani()),
      );
      await inceleme.bekle(tester);
      await inceleme.goruntu(tester, '32_ayarlar');

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
    },
  );
}
