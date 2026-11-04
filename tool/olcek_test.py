import io

p = r'D:\indirilenler\Yeni klasor43\test\ui_inceleme_test.dart'
s = io.open(p, encoding='utf-8', newline='').read()
nl = '\r\n' if '\r\n' in s else '\n'

ek = """
  testWidgets('Erisilebilirlik: yazi boyutu %200 - tasma denetimi', (tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    dotenv.testLoad(fileInput: 'REMOVE_BG_API_KEY=test');
    await telefon(tester);

    // WCAG 1.4.4: metin %200 buyutulebilmeli.
    tester.platformDispatcher.textScaleFactorTestValue = 2.0;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    await tester.pumpWidget(_uygulama(bugunEkrani()));
    await bekle(tester);
    await goruntu(tester, '48_olcek_bugun');
    _yerlesimHatasiniBildir(tester, 'Bugun x2');

    await tester.pumpWidget(
      _uygulama(
        GardirobumEkrani(
          gardirobum: dolap,
          onKiyafetEkle: (_) {},
          onKiyafetSil: (_) {},
          onGardirobuTemizle: () {},
          onSepetToggle: (_) {},
          onKombinIstegi: (_) {},
          anaRenk: const Color(0xFF0F5F4A),
        ),
      ),
    );
    await bekle(tester);
    await goruntu(tester, '49_olcek_dolap');
    _yerlesimHatasiniBildir(tester, 'Dolap x2');

    await tester.pumpWidget(_uygulama(const GirisEkrani()));
    await bekle(tester);
    await goruntu(tester, '50_olcek_giris');
    _yerlesimHatasiniBildir(tester, 'Giris x2');

    await tester.pumpWidget(
      _uygulama(
        ProfilVeAnalizEkrani(
          gardirobum: dolap,
          favoriKombinler: const <FavoriKombin>[],
          gecmisKombinler: gecmis,
          gunlukHava: 'İstanbul 21°C',
          anaRenk: const Color(0xFF0F5F4A),
        ),
      ),
    );
    await bekle(tester);
    await goruntu(tester, '51_olcek_profil');
    _yerlesimHatasiniBildir(tester, 'Profil x2');
  });
""".replace('\n', nl)
i = s.rstrip().rfind('}')
s = s[:i].rstrip() + nl + ek + '}' + nl
io.open(p, 'w', encoding='utf-8', newline='').write(s)
print('ok')
