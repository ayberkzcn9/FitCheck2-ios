import io
p = r'D:\indirilenler\Yeni klasor43\test\ui_inceleme_test.dart'
s = io.open(p, encoding='utf-8', newline='').read()
nl = '\r\n' if '\r\n' in s else '\n'

ek = """
  testWidgets('Koyu tema - ana ekranlar taramasi', (tester) async {
    _parlaklik = Brightness.dark;
    addTearDown(() => _parlaklik = Brightness.light);
    dotenv.testLoad(fileInput: 'REMOVE_BG_API_KEY=test');
    SharedPreferences.setMockInitialValues(<String, Object>{});
    await telefon(tester);

    await tester.pumpWidget(
      _uygulama(
        ProfilVeAnalizEkrani(
          gardirobum: dolap,
          favoriKombinler: const <FavoriKombin>[],
          gecmisKombinler: gecmis,
          gunlukHava: 'İstanbul 21°C · Parçalı Bulutlu',
          anaRenk: Colors.indigo,
        ),
      ),
    );
    await bekle(tester);
    await goruntu(tester, '39_koyu_profil');
    _yerlesimHatasiniBildir(tester, 'Koyu profil');

    await tester.pumpWidget(
      _uygulama(StilGunluguEkrani(gardirobum: dolap, gecmisKombinler: gecmis)),
    );
    await bekle(tester);
    await tester.tap(find.text('Rapor'));
    await bekle(tester);
    await goruntu(tester, '40_koyu_rapor');
    _yerlesimHatasiniBildir(tester, 'Koyu rapor');

    await tester.pumpWidget(_uygulama(SeyahatEkrani(gardirobum: dolap)));
    await bekle(tester);
    await goruntu(tester, '41_koyu_seyahat');
    _yerlesimHatasiniBildir(tester, 'Koyu seyahat');

    await tester.pumpWidget(
      _uygulama(
        KendiKombinimEkrani(
          gardirobum: dolap,
          anaRenk: const Color(0xFF0F5F4A),
          onFavoriEkle: (_) {},
          onFavoriCikar: (_) {},
          onGecmiseEkle: (_, __) {},
        ),
      ),
    );
    await bekle(tester);
    await goruntu(tester, '42_koyu_kendi_kombinim');
    _yerlesimHatasiniBildir(tester, 'Koyu kendi kombinim');

    await tester.pumpWidget(_uygulama(const GirisEkrani()));
    await bekle(tester);
    await goruntu(tester, '43_koyu_giris');
    _yerlesimHatasiniBildir(tester, 'Koyu giriş');
  });
""".replace('\n', nl)
i = s.rstrip().rfind('}')
s = s[:i].rstrip() + nl + ek + '}' + nl
io.open(p, 'w', encoding='utf-8', newline='').write(s)
print('ok')
