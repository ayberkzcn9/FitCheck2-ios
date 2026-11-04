import io
p = r'D:\indirilenler\Yeni klasor43\lib\screens\profil_analiz_ekrani.dart'
s = io.open(p, encoding='utf-8', newline='').read()
nl = '\r\n' if '\r\n' in s else '\n'
eski = """                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      l10n.camasirSepetiTitle,""".replace('\n', nl)
yeni = """                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      l10n.camasirSepetiTitle,""".replace('\n', nl)
if s.count(eski) != 1:
    raise SystemExit('eslesme: %d' % s.count(eski))
s = s.replace(eski, yeni)
io.open(p, 'w', encoding='utf-8', newline='').write(s)
print('ok')
