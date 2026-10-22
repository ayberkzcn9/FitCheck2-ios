import io
p = r'D:\indirilenler\Yeni klasor43\test\ui_inceleme_test.dart'
s = io.open(p, encoding='utf-8', newline='').read()
nl = '\r\n' if '\r\n' in s else '\n'
if '30_giris' in s:
    raise SystemExit('zaten ekli')

# importlar
s = s.replace(
    "import 'package:fitcheck/screens/seyahat_ekrani.dart';",
    "import 'package:fitcheck/screens/ayarlar_ekrani.dart';" + nl +
    "import 'package:fitcheck/screens/giris_ekrani.dart';" + nl +
    "import 'package:fitcheck/screens/onboarding_ekrani.dart';" + nl +
    "import 'package:fitcheck/screens/seyahat_ekrani.dart';", 1)

ek = """
  testWidgets('Giris, Onboarding ve Ayarlar cizilir', (tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    dotenv.testLoad(fileInput: 'REMOVE_BG_API_KEY=test');

    await telefon(tester);
    await tester.pumpWidget(_uygulama(const GirisEkrani()));
    await _bekle(tester);
    await _ekranGorusu(tester, '30_giris');
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(_uygulama(const OnboardingEkrani()));
    await _bekle(tester);
    await _ekranGorusu(tester, '31_onboarding');
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(_uygulama(const AyarlarEkrani()));
    await _bekle(tester);
    await _ekranGorusu(tester, '32_ayarlar');
    expect(tester.takeException(), isNull);

    // Dar ekran: 320 pt genişlikte taşma olmamalı.
    tester.view.physicalSize = const Size(320 * 2, 700 * 2);
    await tester.pumpWidget(_uygulama(const GirisEkrani()));
    await _bekle(tester);
    await _ekranGorusu(tester, '33_giris_dar');
    expect(tester.takeException(), isNull);
  });
}
""".replace('\n', nl)
i = s.rstrip().rfind('}')
s = s[:i].rstrip() + nl + ek
io.open(p, 'w', encoding='utf-8', newline='').write(s)
print('ok')
