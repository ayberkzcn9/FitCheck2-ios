import io

p = r'D:\indirilenler\Yeni klasor43\test\ui_inceleme_test.dart'
s = io.open(p, encoding='utf-8', newline='').read()
nl = '\r\n' if '\r\n' in s else '\n'

eski = nl.join([
    'Widget _uygulama(Widget child) {',
    '  return MaterialApp(',
    '    debugShowCheckedModeBanner: false,',
    "    locale: const Locale('tr'),",
])
yeni = nl.join([
    'Widget _uygulama(Widget child, {Locale? dil}) {',
    '  return MaterialApp(',
    '    debugShowCheckedModeBanner: false,',
    "    locale: dil ?? const Locale('tr'),",
])
if s.count(eski) != 1:
    raise SystemExit('uygulama: %d' % s.count(eski))
s = s.replace(eski, yeni)

ek = """
  testWidgets('Cok dilli kontrol: ar (RTL), de, ru - tasma ve yon denetimi', (tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    dotenv.testLoad(fileInput: 'REMOVE_BG_API_KEY=test');
    await telefon(tester);

    for (final dil in ['ar', 'de', 'ru']) {
      tester.view.physicalSize = const Size(390 * 2, 844 * 2);

      await tester.pumpWidget(_uygulama(bugunEkrani(), dil: Locale(dil)));
      await bekle(tester);
      await goruntu(tester, '44_dil_' + dil + '_bugun');
      _yerlesimHatasiniBildir(tester, 'Bugun/' + dil);

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
          dil: Locale(dil),
        ),
      );
      await bekle(tester);
      await goruntu(tester, '45_dil_' + dil + '_dolap');
      _yerlesimHatasiniBildir(tester, 'Dolap/' + dil);

      await tester.pumpWidget(_uygulama(const GirisEkrani(), dil: Locale(dil)));
      await bekle(tester);
      await goruntu(tester, '46_dil_' + dil + '_giris');
      _yerlesimHatasiniBildir(tester, 'Giris/' + dil);

      tester.view.physicalSize = const Size(320 * 2, 700 * 2);
      await tester.pumpWidget(_uygulama(const GirisEkrani(), dil: Locale(dil)));
      await bekle(tester);
      await goruntu(tester, '47_dil_' + dil + '_giris_dar');
      _yerlesimHatasiniBildir(tester, 'Giris dar/' + dil);
    }
  });
""".replace('\n', nl)
i = s.rstrip().rfind('}')
s = s[:i].rstrip() + nl + ek + '}' + nl
io.open(p, 'w', encoding='utf-8', newline='').write(s)
print('ok')
