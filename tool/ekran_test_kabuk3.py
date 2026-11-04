import io

p = r'D:\indirilenler\Yeni klasor43\test\ui_inceleme_test.dart'
s = io.open(p, encoding='utf-8', newline='').read()
nl = '\r\n' if '\r\n' in s else '\n'

bas = s.index("  testWidgets('Giris, Onboarding, kabuk ve Ayarlar cizilir'")
son = s.rindex('}')
govde = """  testWidgets('Giris, Onboarding, kabuk ve Ayarlar cizilir', (tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    dotenv.testLoad(fileInput: 'REMOVE_BG_API_KEY=test');
    await telefon(tester);

    // Giriş ekranı: kendi temasıyla çizilir (anaRenk verilmezse marka rengi).
    await tester.pumpWidget(_uygulama(const GirisEkrani()));
    await _bekle(tester);
    await _ekranGorusu(tester, '30_giris');
    _yerlesimHatasiniBildir(tester, 'Giriş');

    // Dar ekran (320 pt): giriş formu taşmamalı.
    tester.view.physicalSize = const Size(320 * 2, 700 * 2);
    await tester.pumpWidget(_uygulama(const GirisEkrani()));
    await _bekle(tester);
    await _ekranGorusu(tester, '33_giris_dar');
    _yerlesimHatasiniBildir(tester, 'Giriş (dar)');

    // Onboarding / kabuk / Ayarlar gerçek uygulama ağacını gerektiriyor
    // (dil ve tema için KombinDanismaniApp atası). Firebase testte yok;
    // uygulamanın çevrimdışı yolu kullanılıyor.
    tester.view.physicalSize = const Size(390 * 2, 844 * 2);

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
      await _bekle(tester);
    }

    await kabuguAc(onboarding: false);
    await _ekranGorusu(tester, '31_onboarding');
    _yerlesimHatasiniBildir(tester, 'Onboarding');

    await kabuguAc(onboarding: true);
    await _ekranGorusu(tester, '34_kabuk');
    _yerlesimHatasiniBildir(tester, 'Kabuk');

    final kabuk = tester.element(find.byType(Scaffold).first);
    Navigator.of(kabuk).push(
      MaterialPageRoute<void>(builder: (_) => const AyarlarEkrani()),
    );
    await _bekle(tester);
    await _ekranGorusu(tester, '32_ayarlar');
    _yerlesimHatasiniBildir(tester, 'Ayarlar');

    // Eklentilerin (satın alma, konuşma, paket bilgisi, sensör) gerçek async
    // hataları test bitmeden toplansın: ağacı kapat, gerçek zaman tanı.
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 400)),
    );
    await tester.pump(const Duration(seconds: 2));
    _yerlesimHatasiniBildir(tester, 'Kapanış');
  });
""".replace('\n', nl)

s = s[:bas] + govde + s[son:]
io.open(p, 'w', encoding='utf-8', newline='').write(s)
print('ok')
