import io
p = r'D:\indirilenler\Yeni klasor43\test\ui_inceleme_test.dart'
s = io.open(p, encoding='utf-8', newline='').read()
nl = '\r\n' if '\r\n' in s else '\n'
eski = "    final metin = '$hata';"
yeni = ("    final metin = '$hata';" + nl +
        "    // ignore: avoid_print" + nl +
        "    print('[YAKALANAN] ${metin.split('\\n').first}');")
if eski not in s:
    raise SystemExit('bulunamadi')
s = s.replace(eski, yeni, 1)
io.open(p, 'w', encoding='utf-8', newline='').write(s)
print('ok')
