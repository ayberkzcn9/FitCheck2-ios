import io
p = r'D:\indirilenler\Yeni klasor43\test\ui_inceleme_test.dart'
s = io.open(p, encoding='utf-8', newline='').read()
nl = '\r\n' if '\r\n' in s else '\n'
if '27_koyu_bugun' in s:
    raise SystemExit('zaten ekli')
ek = """
  testWidgets('Koyu tema - Bugun, Dolap, Duello', (tester) async {
    _parlaklik = Brightness.dark;
    addTearDown(() => _parlaklik = Brightness.light);
    dotenv.testLoad(fileInput: 'REMOVE_BG_API_KEY=test');
    SharedPreferences.setMockInitialValues(<String, Object>{});

    await telefon(tester);
    await tester.pumpWidget(_uygulama(bugunEkrani()));
    await _bekle(tester);
    await _ekranGorusu(tester, '27_koyu_bugun');

    await tester.pumpWidget(
      _uygulama(
        GardirobumEkrani(
          gardirobum: dolap,
          onKiyafetEkle: (_) {},
          onKiyafetSil: (_) {},
          onGardirobuTemizle: () {},
          onSepetToggle: (_) {},
          onKombinIstegi: (_) {},
          anaRenk: Colors.indigo,
        ),
      ),
    );
    await _bekle(tester);
    await _ekranGorusu(tester, '28_koyu_dolap');

    await tester.pumpWidget(
      _uygulama(
        KombinDuellosuEkrani(
          gardirobum: dolap,
          gunlukHava: 'İstanbul 21°C · Parçalı Bulutlu',
          motor: DuelMotoru(),
          servisi: KombinDuellosuServisi(),
          tohum: 7,
        ),
      ),
    );
    await _bekle(tester);
    await _ekranGorusu(tester, '29_koyu_duello');
    expect(tester.takeException(), isNull);
  });
}
""".replace('\n', nl)
i = s.rstrip().rfind('}')
s = s[:i].rstrip() + nl + ek
io.open(p, 'w', encoding='utf-8', newline='').write(s)
print('ok')
