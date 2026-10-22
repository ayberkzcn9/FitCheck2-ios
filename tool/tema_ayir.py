import re, io
p = r'D:\indirilenler\Yeni klasor43\lib\main.dart'
s = io.open(p, encoding='utf-8', newline='').read()
nl = '\r\n' if '\r\n' in s else '\n'
bas = s.index('  ColorScheme _buildColorScheme(Brightness brightness) {')
son = s.index('  Widget _oturumKapisi(bool firebaseHazir) {')
yeni = ('  ColorScheme _buildColorScheme(Brightness brightness) =>' + nl +
        '      AppTema.renkSemasi(brightness);' + nl + nl)
s = s[:bas] + yeni + s[son:]
s = s.replace("  static const Color _seedColor = Color(0xFF0F5F4A);" + nl, "")
if "theme/app_tema.dart" not in s:
    m = re.search(r"import '[^']*design_tokens\.dart';", s)
    ek = "import 'theme/app_tema.dart';"
    if m:
        s = s[:m.end()] + nl + ek + s[m.end():]
    else:
        raise SystemExit('design_tokens import bulunamadi')
io.open(p, 'w', encoding='utf-8', newline='').write(s)
print('ok')
