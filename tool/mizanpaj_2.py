import io, os, re

# 1) Seyahat: kategori grupları iki sütunlu ızgara.
yol = r'D:\indirilenler\Yeni klasor43\lib\screens\seyahat_ekrani.dart'
s = io.open(yol, encoding='utf-8', newline='').read()
nl = '\r\n' if '\r\n' in s else '\n'

eski = """          _grup(
            l10n.gardirobumKategoriUst,
            plan.ustler,
            colors,
          ),
          _grup(
            l10n.gardirobumKategoriAlt,
            plan.altlar,
            colors,
          ),
          _grup(
            l10n.seyahatDiger,
            plan.disGiyim,
            colors,
          ),
          _grup(
            l10n.gardirobumKategoriAyakkabi,
            plan.ayakkabilar,
            colors,
          ),""".replace('\n', nl)
yeni = """          _grupIzgarasi(colors, [
            (l10n.gardirobumKategoriUst, plan.ustler),
            (l10n.gardirobumKategoriAlt, plan.altlar),
            (l10n.seyahatDiger, plan.disGiyim),
            (l10n.gardirobumKategoriAyakkabi, plan.ayakkabilar),
          ]),""".replace('\n', nl)
if s.count(eski) != 1:
    raise SystemExit('seyahat: eslesme %d' % s.count(eski))
s = s.replace(eski, yeni)

ekle = """  /// Kategori gruplarını iki sütunlu ızgarada dizer; tek satırlık kısa
  /// gruplar yüzünden kartın yarısı boş kalmasın.
  Widget _grupIzgarasi(
    ColorScheme colors,
    List<(String, List<Kiyafet>)> gruplar,
  ) {
    return LayoutBuilder(
      builder: (context, kisit) {
        final genislik = (kisit.maxWidth - 16) / 2;
        return Wrap(
          spacing: 16,
          children: [
            for (final (baslik, parcalar) in gruplar)
              SizedBox(
                width: genislik,
                child: _grup(baslik, parcalar, colors),
              ),
          ],
        );
      },
    );
  }

""".replace('\n', nl)
anchor = '  Widget _grup(String baslik, List<Kiyafet> parcalar, ColorScheme colors) {'
if s.count(anchor) != 1:
    raise SystemExit('seyahat: _grup bulunamadi')
s = s.replace(anchor, ekle + anchor)
io.open(yol, 'w', encoding='utf-8', newline='').write(s)
print('seyahat ok')

# 2) Başlık metinleri: büyük harf yerine normal yazım (7 dil).
yeniBasliklar = {
    'app_tr.arb': ('Sanal Gardırobum', 'Haftalık Stil Ajandası'),
    'app_en.arb': ('My Virtual Wardrobe', 'Weekly Style Planner'),
    'app_de.arb': ('Virtueller Kleiderschrank', 'Wöchentliche Stil-Agenda'),
    'app_es.arb': ('Mi armario virtual', 'Planificador de estilo semanal'),
    'app_fr.arb': ('Mon dressing virtuel', 'Planificateur de style hebdomadaire'),
    'app_it.arb': ('Guardaroba virtuale', 'Agenda stile settimanale'),
    'app_pt.arb': ('Guarda-roupa virtual', 'Planejador de estilo semanal'),
}
for dosya, (gard, hafta) in yeniBasliklar.items():
    p = os.path.join(r'D:\indirilenler\Yeni klasor43\lib\l10n', dosya)
    t = io.open(p, encoding='utf-8', newline='').read()
    t, n1 = re.subn(r'("gardirobumTitle":\s*")[^"]*(")', lambda m: m.group(1) + gard + m.group(2), t)
    t, n2 = re.subn(r'("haftalikAjandaTitle":\s*")[^"]*(")', lambda m: m.group(1) + hafta + m.group(2), t)
    if n1 != 1 or n2 != 1:
        raise SystemExit('%s: %d %d' % (dosya, n1, n2))
    io.open(p, 'w', encoding='utf-8', newline='').write(t)
    print('arb ok', dosya)
