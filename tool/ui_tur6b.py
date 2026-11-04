import io

p = r'D:\indirilenler\Yeni klasor43\lib\screens\stil_gunlugu_ekrani.dart'
s = io.open(p, encoding='utf-8', newline='').read()
nl = '\r\n' if '\r\n' in s else '\n'


def r(a, b):
    global s
    a = a.replace('\n', nl)
    b = b.replace('\n', nl)
    if a not in s:
        raise SystemExit('bulunamadi: ' + a[:70])
    s = s.replace(a, b, 1)


r("""    final yerel = MaterialLocalizations.of(context);
    final indeks = _parcaIndeksi();
    final gunler = KombinTakvimi.ay(""",
  """    final yerel = MaterialLocalizations.of(context);
    // Türkçede tek harflik kısaltmalar üç günü de "P" yapıyor; haftalık
    // ızgarada okunur kısaltmalar kullanılıyor (Pzt, Sal, Çar...).
    final gunAdlari = yerel.languageCode == 'tr'
        ? const ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz']
        : _haftaEtiketleri(yerel);
    final indeks = _parcaIndeksi();
    final gunler = KombinTakvimi.ay(""")

r("""            for (final gun in _haftaEtiketleri(yerel))""",
  """            for (final gun in gunAdlari)""")

io.open(p, 'w', encoding='utf-8', newline='').write(s)
print('ok')
