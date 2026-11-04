import io

p = r'D:\indirilenler\Yeni klasor43\lib\screens\bugun_ekrani.dart'
s = io.open(p, encoding='utf-8', newline='').read()
nl = '\r\n' if '\r\n' in s else '\n'
eski = """    ColorScheme colors,
  ) {
    return SizedBox(
      height: 190,
      child: Center(""".replace('\n', nl)
yeni = """    ColorScheme colors,
  ) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 190),
      child: Center(""".replace('\n', nl)
if s.count(eski) != 1:
    raise SystemExit('beklenmeyen eslesme: %d' % s.count(eski))
s = s.replace(eski, yeni, 1)
io.open(p, 'w', encoding='utf-8', newline='').write(s)
print('ok')
