import io

p = r'D:\indirilenler\Yeni klasor43\test\ui_inceleme_test.dart'
s = io.open(p, encoding='utf-8', newline='').read()
nl = '\r\n' if '\r\n' in s else '\n'

ek = """
  testWidgets('Kapsam: koyu tema ve RTL ile kalan ekranlar', (tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    dotenv.testLoad(fileInput: 'REMOVE_BG_API_KEY=test');
    await telefon(tester);

    // --- KOYU TEMA: daha önce kapsanmayan ekranlar
    _parlaklik = Brightness.dark;
    addTearDown(() => _parlaklik = Brightness.light);

    await tester.pumpWidget(
      _uygulama(HaftalikPlanlayiciEkrani(gardirobum: dolap, anaRenk: const Color(0xFF0F5F4A))),
    );
    await bekle(tester);
    await goruntu(tester, '58_koyu_haftalik');
    _yerlesimHatasiniBildir(tester, 'Koyu haftalik');

    await tester.pumpWidget(
      _uygulama(
        DolaptanKombinStilistiEkrani(
          gardirobum: dolap,
          favoriKombinler: const <FavoriKombin>[],
          gunlukHava: 'İstanbul 21°C',
          havaYukleniyor: false,
          onFavoriEkle: (_) {},
          onGecmiseEkle: (_, __) async {},
          onKonumuYenile: () {},
          anaRenk: const Color(0xFF0F5F4A),
        ),
      ),
    );
    await bekle(tester);
    await goruntu(tester, '59_koyu_dolaptan');
    _yerlesimHatasiniBildir(tester, 'Koyu dolaptan');

    await tester.pumpWidget(_uygulama(const OnboardingEkrani()));
    await bekle(tester);
    await goruntu(tester, '60_koyu_onboarding');
    _yerlesimHatasiniBildir(tester, 'Koyu onboarding');

    await tester.pumpWidget(_uygulama(const ReklamsizPremiumEkrani()));
    await bekle(tester);
    await goruntu(tester, '61_koyu_premium');
    _yerlesimHatasiniBildir(tester, 'Koyu premium');

    // --- RTL (ar): daha önce kapsanmayan ekranlar
    _parlaklik = Brightness.light;

    await tester.pumpWidget(
      _uygulama(
        StilGunluguEkrani(gardirobum: dolap, gecmisKombinler: gecmis),
        dil: const Locale('ar'),
      ),
    );
    await bekle(tester);
    await goruntu(tester, '62_dil_ar_stil');
    _yerlesimHatasiniBildir(tester, 'Ar stil');

    await tester.pumpWidget(
      _uygulama(
        ProfilVeAnalizEkrani(
          gardirobum: dolap,
          favoriKombinler: const <FavoriKombin>[],
          gecmisKombinler: gecmis,
          gunlukHava: 'İstanbul 21°C',
          anaRenk: const Color(0xFF0F5F4A),
        ),
        dil: const Locale('ar'),
      ),
    );
    await bekle(tester);
    await goruntu(tester, '63_dil_ar_profil');
    _yerlesimHatasiniBildir(tester, 'Ar profil');

    await tester.pumpWidget(
      _uygulama(
        KombinDuellosuEkrani(
          gardirobum: dolap,
          gunlukHava: 'İstanbul 21°C',
          motor: DuelMotoru(),
          servisi: KombinDuellosuServisi(),
          tohum: 7,
        ),
        dil: const Locale('ar'),
      ),
    );
    await bekle(tester);
    await goruntu(tester, '64_dil_ar_duello');
    _yerlesimHatasiniBildir(tester, 'Ar duello');

    await tester.pumpWidget(
      _uygulama(const OnboardingEkrani(), dil: const Locale('ar')),
    );
    await bekle(tester);
    await goruntu(tester, '65_dil_ar_onboarding');
    _yerlesimHatasiniBildir(tester, 'Ar onboarding');

    await tester.pumpWidget(
      _uygulama(
        KendiKombinimEkrani(
          gardirobum: dolap,
          anaRenk: const Color(0xFF0F5F4A),
          onFavoriEkle: (_) {},
          onFavoriCikar: (_) {},
          onGecmiseEkle: (_, __) {},
        ),
        dil: const Locale('ar'),
      ),
    );
    await bekle(tester);
    await goruntu(tester, '66_dil_ar_kendi_kombinim');
    _yerlesimHatasiniBildir(tester, 'Ar kendi kombinim');
  });
""".replace('\n', nl)
i = s.rstrip().rfind('}')
s = s[:i].rstrip() + nl + ek + '}' + nl
io.open(p, 'w', encoding='utf-8', newline='').write(s)
print('ok')
