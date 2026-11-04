import io

p = r'D:\indirilenler\Yeni klasor43\test\ui_inceleme_test.dart'
s = io.open(p, encoding='utf-8', newline='').read()
nl = '\r\n' if '\r\n' in s else '\n'


def r(a, b, say=1):
    global s
    a = a.replace('\n', nl)
    b = b.replace('\n', nl)
    if a not in s:
        raise SystemExit('bulunamadi: ' + a[:70])
    s = s.replace(a, b, say)


# main.dart importu (gerçek uygulama kabuğu için)
r("import 'package:fitcheck/l10n/app_localizations.dart';",
  "import 'package:fitcheck/l10n/app_localizations.dart';\n"
  "import 'package:fitcheck/main.dart';")

# Ayarlar'ı gerçek kabuktan aç (KombinDanismaniApp atası gerekiyor).
r("""    await tester.pumpWidget(_uygulama(const AyarlarEkrani()));
    await _bekle(tester);
    await _ekranGorusu(tester, '32_ayarlar');
    _yerlesimHatasiniBildir(tester, 'Ayarlar');
""",
  """    // Ayarlar ekranı KombinDanismaniApp atasına ihtiyaç duyuyor; gerçek
    // uygulama kabuğunu kurup üstüne Ayarlar'ı açıyoruz.
    await tester.pumpWidget(
      KombinDanismaniApp(
        onboardingTamamlandi: true,
        baslangicTemaModuStr: 'light',
        baslatmaIslemi: Future<UygulamaBaslatmaSonucu>.value(
          const UygulamaBaslatmaSonucu(firebaseHazir: false),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1200));
    await _bekle(tester);
    await _ekranGorusu(tester, '34_kabuk');
    _yerlesimHatasiniBildir(tester, 'Kabuk');

    final kabuk = tester.element(find.byType(Scaffold).first);
    Navigator.of(kabuk).push(
      MaterialPageRoute<void>(builder: (_) => const AyarlarEkrani()),
    );
    await _bekle(tester);
    await _ekranGorusu(tester, '32_ayarlar');
    _yerlesimHatasiniBildir(tester, 'Ayarlar');
""")

# Yerleşim dışı hataları da logla (Firebase/MissingPlugin beklenen).
r("""    if (metin.contains('overflowed') || metin.contains('RenderFlex')) {
      fail('$ekran: yerleşim hatası -> $metin');
    }""",
  """    if (metin.contains('overflowed') || metin.contains('RenderFlex')) {
      fail('$ekran: yerleşim hatası -> $metin');
    }
    // ignore: avoid_print
    print('[ATLANDI/$ekran] ${metin.split('\\n').first}');""")

io.open(p, 'w', encoding='utf-8', newline='').write(s)
print('ok')
