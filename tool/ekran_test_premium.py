import io

p = r'D:\indirilenler\Yeni klasor43\test\ui_inceleme_test.dart'
s = io.open(p, encoding='utf-8', newline='').read()
nl = '\r\n' if '\r\n' in s else '\n'

if '35_premium' in s:
    raise SystemExit('zaten ekli')

imp_son = s.index("import 'package:fitcheck/screens/seyahat_ekrani.dart';")
s = (s[:imp_son]
     + "import 'package:fitcheck/screens/izin_ekrani.dart';" + nl
     + "import 'package:fitcheck/screens/reklamsiz_premium_ekrani.dart';" + nl
     + s[imp_son:])

ek = """
  testWidgets('Premium ve Izin ekranlari cizilir', (tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    dotenv.testLoad(fileInput: 'REMOVE_BG_API_KEY=test');
    await telefon(tester);

    await tester.pumpWidget(_uygulama(const ReklamsizPremiumEkrani()));
    await bekle(tester);
    await goruntu(tester, '35_premium');
    _yerlesimHatasiniBildir(tester, 'Premium');

    await tester.pumpWidget(
      _uygulama(
        Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () => IzinDiyalogu.goster(context),
                child: const Text('ac'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('ac'));
    await bekle(tester);
    await goruntu(tester, '36_izin');
    _yerlesimHatasiniBildir(tester, 'Izin');
  });
""".replace('\n', nl)
i = s.rstrip().rfind('}')
s = s[:i].rstrip() + nl + ek + '}' + nl
io.open(p, 'w', encoding='utf-8', newline='').write(s)
print('ok')
