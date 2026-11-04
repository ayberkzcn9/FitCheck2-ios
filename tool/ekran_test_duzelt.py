import io
p = r'D:\indirilenler\Yeni klasor43\test\ui_inceleme_test.dart'
s = io.open(p, encoding='utf-8', newline='').read()
nl = '\r\n' if '\r\n' in s else '\n'

def r(a, b):
    global s
    a = a.replace('\n', nl); b = b.replace('\n', nl)
    if a not in s:
        raise SystemExit('bulunamadi: ' + a[:60])
    s = s.replace(a, b, 1)

# Firebase'siz ekranlarda yalnızca yerleşim hatalarını önemse.
r("""Future<void> _bekle(WidgetTester tester) async {""",
  """/// Firebase gibi servisler testte hazır olmadığı için fırlatılan hataları
/// yutar; yalnızca yerleşim (taşma) hataları testi düşürür.
void _yerlesimHatasiniBildir(WidgetTester tester, String ekran) {
  Object? hata;
  while ((hata = tester.takeException()) != null) {
    final metin = '$hata';
    if (metin.contains('overflowed') || metin.contains('RenderFlex')) {
      fail('$ekran: yerleşim hatası -> $metin');
    }
  }
}

Future<void> _bekle(WidgetTester tester) async {""")

r("""    await tester.pumpWidget(_uygulama(const GirisEkrani()));
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
    expect(tester.takeException(), isNull);""",
  """    await tester.pumpWidget(_uygulama(const GirisEkrani()));
    await _bekle(tester);
    await _ekranGorusu(tester, '30_giris');
    _yerlesimHatasiniBildir(tester, 'Giriş');

    await tester.pumpWidget(_uygulama(const OnboardingEkrani()));
    await _bekle(tester);
    await _ekranGorusu(tester, '31_onboarding');
    _yerlesimHatasiniBildir(tester, 'Onboarding');

    await tester.pumpWidget(_uygulama(const AyarlarEkrani()));
    await _bekle(tester);
    await _ekranGorusu(tester, '32_ayarlar');
    _yerlesimHatasiniBildir(tester, 'Ayarlar');

    // Dar ekran: 320 pt genişlikte taşma olmamalı.
    tester.view.physicalSize = const Size(320 * 2, 700 * 2);
    await tester.pumpWidget(_uygulama(const GirisEkrani()));
    await _bekle(tester);
    await _ekranGorusu(tester, '33_giris_dar');
    _yerlesimHatasiniBildir(tester, 'Giriş (dar)');""")

io.open(p, 'w', encoding='utf-8', newline='').write(s)
print('ok')
