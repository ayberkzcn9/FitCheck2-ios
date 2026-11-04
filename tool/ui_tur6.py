import io

p = r'D:\indirilenler\Yeni klasor43\lib\screens\stil_gunlugu_ekrani.dart'
s = io.open(p, encoding='utf-8', newline='').read()
nl = '\r\n' if '\r\n' in s else '\n'
bas = s.index('  static List<String> _haftaEtiketleri(MaterialLocalizations yerel) {')
son = s.index('\n  }', bas) + 4
yeni = """  static List<String> _haftaEtiketleri(MaterialLocalizations yerel) {
    // Tek harflik kısaltmalar Türkçede üç günü de "P" yapıyordu (Pzt/Per/Paz).
    // Dar adların ilk üç harfi hem okunur hem sığıyor: Pzt, Sal, Çar.
    final dar = yerel.narrowWeekdays;
    if (dar.length != 7) return dar;
    final ilkGun = yerel.firstDayOfWeekIndex; // 0 = Pazar
    return List<String>.generate(7, (i) => dar[(ilkGun + i) % 7]);
  }""".replace('\n', nl)
s = s[:bas] + yeni + s[son:]
io.open(p, 'w', encoding='utf-8', newline='').write(s)
print('ok')
