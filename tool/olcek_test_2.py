import io

p = r'D:\indirilenler\Yeni klasor43\test\ui_inceleme_test.dart'
s = io.open(p, encoding='utf-8', newline='').read()
nl = '\r\n' if '\r\n' in s else '\n'

# Mevcut %200 testini genislet: daha fazla ekran.
eski = """    await tester.pumpWidget(
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
  });"""

yeni = """    await tester.pumpWidget(
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

    await tester.pumpWidget(
      _uygulama(StilGunluguEkrani(gardirobum: dolap, gecmisKombinler: gecmis)),
    );
    await bekle(tester);
    await goruntu(tester, '52_olcek_stil');
    _yerlesimHatasiniBildir(tester, 'Stil x2');

    await tester.pumpWidget(_uygulama(SeyahatEkrani(gardirobum: dolap)));
    await bekle(tester);
    await goruntu(tester, '53_olcek_seyahat');
    _yerlesimHatasiniBildir(tester, 'Seyahat x2');

    await tester.pumpWidget(
      _uygulama(
        KombinDuellosuEkrani(
          gardirobum: dolap,
          gunlukHava: 'İstanbul 21°C',
          motor: DuelMotoru(),
          servisi: KombinDuellosuServisi(),
          tohum: 7,
        ),
      ),
    );
    await bekle(tester);
    await goruntu(tester, '54_olcek_duello');
    _yerlesimHatasiniBildir(tester, 'Duello x2');

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
    await goruntu(tester, '55_olcek_kendi_kombinim');
    _yerlesimHatasiniBildir(tester, 'Kendi kombinim x2');

    await tester.pumpWidget(_uygulama(const OnboardingEkrani()));
    await bekle(tester);
    await goruntu(tester, '56_olcek_onboarding');
    _yerlesimHatasiniBildir(tester, 'Onboarding x2');

    await tester.pumpWidget(_uygulama(const ReklamsizPremiumEkrani()));
    await bekle(tester);
    await goruntu(tester, '57_olcek_premium');
    _yerlesimHatasiniBildir(tester, 'Premium x2');
  });"""

if s.count(eski) != 1:
    raise SystemExit('eslesme: %d' % s.count(eski))
s = s.replace(eski, yeni)
io.open(p, 'w', encoding='utf-8', newline='').write(s)
print('ok')
