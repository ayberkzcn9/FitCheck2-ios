import io

p = r'D:\indirilenler\Yeni klasor43\test\ui_inceleme_test.dart'
s = io.open(p, encoding='utf-8', newline='').read()
nl = '\r\n' if '\r\n' in s else '\n'

# Her _uygulama cagrisi icin benzersiz anahtar: ayni MaterialApp tipi
# geri donuldugunde Flutter ağaci yeniden kullanir ve Navigator'da acik
# kalan modal (orn. "Sihirli Zarlar") yeni ekrana sizar.
eski = """Widget _uygulama(Widget child, {Locale? dil}) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,"""
yeni = """int _uygulamaSayaci = 0;

Widget _uygulama(Widget child, {Locale? dil}) {
  return MaterialApp(
    // Her cagri icin benzersiz anahtar: Navigator durumu (acik modal, rota)
    // bir sonraki ekrana tasmasin.
    key: ValueKey('uygulama-${_uygulamaSayaci++}'),
    debugShowCheckedModeBanner: false,"""
if s.count(eski) != 1:
    raise SystemExit('eslesme: %d' % s.count(eski))
s = s.replace(eski, yeni)
io.open(p, 'w', encoding='utf-8', newline='').write(s)
print('ok')
