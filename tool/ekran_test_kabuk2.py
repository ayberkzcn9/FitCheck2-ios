import io

p = r'D:\indirilenler\Yeni klasor43\test\ui_inceleme_test.dart'
s = io.open(p, encoding='utf-8', newline='').read()
nl = '\r\n' if '\r\n' in s else '\n'

bas = s.index("  testWidgets('Giris, Onboarding ve Ayarlar cizilir'")
son = s.rindex('}')          # dosya sonundaki kapanış
govde = """  // Gerçek uygulama kabuğunu (tema, dil, sağlayıcı) kurar. Firebase testte
  // olmadığı için başlatma sonucu "firebaseHazir: false" veriliyor; bu yol
  // zaten uygulamanın çevrimdışı senaryosu.
  Widget kabuk({required bool onboarding}) {
    return KombinDanismaniApp(
      onboardingTamamlandi: onboarding,
      baslangicTemaModuStr: 'light',
      baslatmaIslemi: Future<UygulamaBaslatmaSonucu>.value(
        const UygulamaBaslatmaSonucu(firebaseHazir: false),
      ),
    );
  }

  Future<void> kabuguAc(WidgetTester tester, {required bool onboarding}) async {
    await tester.pumpWidget(kabuk(onboarding: onboarding));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1200));
    await _bekle(tester);
  }

  testWidgets('Giris, Onboarding, kabuk ve Ayarlar cizilir', (tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    dotenv.testLoad(fileInput: 'REMOVE_BG_API_KEY=test');
    await telefon(tester);

    await kabuguAc(tester, onboarding: true);
    await _ekranGorusu(tester, '30_giris');
    _yerlesimHatasiniBildir(tester, 'Giriş');

    await kabuguAc(tester, onboarding: false);
    await _ekranGorusu(tester, '31_onboarding');
    _yerlesimHatasiniBildir(tester, 'Onboarding');

    // Ana kabuk: alt menü + Bugün.
    await kabuguAc(tester, onboarding: true);
    await _ekranGorusu(tester, '34_kabuk');
    _yerlesimHatasiniBildir(tester, 'Kabuk');

    final kabuk = tester.element(find.byType(Scaffold).first);
    Navigator.of(kabuk).push(
      MaterialPageRoute<void>(builder: (_) => const AyarlarEkrani()),
    );
    await _bekle(tester);
    await _ekranGorusu(tester, '32_ayarlar');
    _yerlesimHatasiniBildir(tester, 'Ayarlar');

    // Dar ekran: 320 pt genişlikte taşma olmamalı.
    tester.view.physicalSize = const Size(320 * 2, 700 * 2);
    await kabuguAc(tester, onboarding: true);
    await _ekranGorusu(tester, '33_giris_dar');
    _yerlesimHatasiniBildir(tester, 'Giriş (dar)');

    // Ağır eklentilerin (satın alma, konuşma, paket bilgisi) geç dönen
    // hataları test bittikten sonra düşmesin: ağacı kapat, hataları topla.
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 2));
    _yerlesimHatasiniBildir(tester, 'Kapanış');
  });
""".replace('\n', nl)

s = s[:bas] + govde + s[son:]
io.open(p, 'w', encoding='utf-8', newline='').write(s)
print('ok')
