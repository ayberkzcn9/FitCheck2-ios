import io
p = r'D:\indirilenler\Yeni klasor43\test\ui_inceleme_test.dart'
s = io.open(p, encoding='utf-8', newline='').read()
nl = '\r\n' if '\r\n' in s else '\n'
bas = s.index('ColorScheme _acikSemas() {')
son = s.index('Widget _uygulama(Widget child) {')
yeni = nl.join([
    'ThemeData _tema({Brightness parlaklik = Brightness.light}) {',
    '  final sema = AppTema.renkSemasi(parlaklik);',
    '  final koyu = parlaklik == Brightness.dark;',
    '  final taban = koyu',
    '      ? Typography.material2021().white',
    '      : Typography.material2021().black;',
    '  return ThemeData(',
    '    useMaterial3: true,',
    '    colorScheme: sema,',
    '    fontFamily: _yaziTipi,',
    '    scaffoldBackgroundColor: sema.surface,',
    '    textTheme: taban.apply(fontFamily: _yaziTipi),',
    '    appBarTheme: AppBarTheme(',
    '      backgroundColor: sema.surface,',
    '      foregroundColor: sema.onSurface,',
    '      elevation: 0,',
    '      centerTitle: false,',
    '    ),',
    '  );',
    '}',
    '',
    ''])
s = s[:bas] + yeni + s[son:]
s = s.replace("    theme: _tema(),", "    theme: _tema(parlaklik: _parlaklik),")
s = s.replace("const String _yaziTipi = 'ReviewFont';",
              "const String _yaziTipi = 'ReviewFont';" + nl + nl +
              "/// Koyu tema görüntüleri için testlerde değiştirilir." + nl +
              "Brightness _parlaklik = Brightness.light;")
s = s.replace("import 'package:fitcheck/models/kiyafet.dart';",
              "import 'package:fitcheck/models/kiyafet.dart';" + nl +
              "import 'package:fitcheck/theme/app_tema.dart';", 1)
io.open(p, 'w', encoding='utf-8', newline='').write(s)
print('ok')
