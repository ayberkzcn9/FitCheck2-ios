import io
p = r'D:\indirilenler\Yeni klasor43\test\ui_inceleme_test.dart'
s = io.open(p, encoding='utf-8', newline='').read()
nl = '\r\n' if '\r\n' in s else '\n'

for imp in ["import 'package:fitcheck/screens/kendi_kombinim_ekrani.dart';",
            "import 'package:fitcheck/screens/dolaptan_kombin_ekrani.dart';"]:
    if imp not in s:
        anchor = "import 'package:fitcheck/screens/seyahat_ekrani.dart';"
        s = s.replace(anchor, imp + nl + anchor, 1)

ek = """
  testWidgets('Alt ekranlar: kendi kombinim ve dolaptan kombin cizilir', (tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    dotenv.testLoad(fileInput: 'REMOVE_BG_API_KEY=test');
    await telefon(tester);

    await tester.pumpWidget(
      _uygulama(
        KendiKombinimEkrani(
          gardirobum: dolap,
          anaRenk: const Color(0xFF0F5F4A),
          onFavoriEkle: (_) {},
          onFavoriCikar: (_) {},
          onGecmiseEkle: (_) {},
        ),
      ),
    );
    await bekle(tester);
    await goruntu(tester, '37_kendi_kombinim');
    _yerlesimHatasiniBildir(tester, 'Kendi kombinim');

    await tester.pumpWidget(
      _uygulama(
        DolaptanKombinStilistiEkrani(
          gardirobum: dolap,
          favoriKombinler: const <FavoriKombin>[],
          gunlukHava: 'İstanbul 21°C · Parçalı Bulutlu',
          havaYukleniyor: false,
          onFavoriEkle: (_) {},
          onGecmiseEkle: (_) {},
          onKonumuYenile: () {},
          anaRenk: const Color(0xFF0F5F4A),
        ),
      ),
    );
    await bekle(tester);
    await goruntu(tester, '38_dolaptan_kombin');
    _yerlesimHatasiniBildir(tester, 'Dolaptan kombin');
  });
""".replace('\n', nl)
i = s.rstrip().rfind('}')
s = s[:i].rstrip() + nl + ek + '}' + nl
io.open(p, 'w', encoding='utf-8', newline='').write(s)
print('ok')
