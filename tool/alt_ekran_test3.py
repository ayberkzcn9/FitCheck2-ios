import io
p = r'D:\indirilenler\Yeni klasor43\test\ui_inceleme_test.dart'
s = io.open(p, encoding='utf-8', newline='').read()
nl = '\r\n' if '\r\n' in s else '\n'

helper = """/// Testte olmayan donanım kanallarını (sensör, titreşim) boş yanıtla susturur.
void _donanimKanallariniSustur() {
  final haberci = TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  for (final kanal in <String>[
    'dev.fluttercommunity.plus/sensors/method',
    'dev.fluttercommunity.plus/sensors/accelerometer',
    'dev.fluttercommunity.plus/sensors/gyroscope',
    'dev.fluttercommunity.plus/sensors/magnetometer',
    'vibration',
  ]) {
    haberci.setMockMethodCallHandler(MethodChannel(kanal), (_) async => null);
  }
}

""".replace('\n', nl)
anchor = 'Widget _uygulama(Widget child) {'
if s.count(anchor) != 1:
    raise SystemExit('anchor')
s = s.replace(anchor, helper + anchor, 1)

eski = "testWidgets('Alt ekranlar: kendi kombinim ve dolaptan kombin cizilir', (tester) async {" + nl + "    SharedPreferences.setMockInitialValues(<String, Object>{});" + nl + "    dotenv.testLoad(fileInput: 'REMOVE_BG_API_KEY=test');" + nl + "    await telefon(tester);"
yeni = eski + nl + "    _donanimKanallariniSustur();"
if s.count(eski) != 1:
    raise SystemExit('test govdesi: %d' % s.count(eski))
s = s.replace(eski, yeni)
io.open(p, 'w', encoding='utf-8', newline='').write(s)
print('ok')
