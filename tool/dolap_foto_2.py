import io
p = r'D:\indirilenler\Yeni klasor43\lib\screens\gardirobum_ekrani.dart'
s = io.open(p, encoding='utf-8', newline='').read()
nl = '\r\n' if '\r\n' in s else '\n'

# Fotoğraf alanı kartın tamamını dolduruyordu (Expanded). Sabit yüksekliğe
# çekilince kıyafet görseli kartın üstünde kalıyor, altında sade etiket
# şeridi ve boş yüzey kalıyor; boşluk fotoğrafın etrafında değil, altında
# toplanıyor.
eski = """              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [""".replace('\n', nl)
yeni = """              SizedBox(
                height: 168,
                child: Stack(
                  fit: StackFit.expand,
                  children: [""".replace('\n', nl)
if s.count(eski) != 1:
    raise SystemExit('eslesme: %d' % s.count(eski))
s = s.replace(eski, yeni)
io.open(p, 'w', encoding='utf-8', newline='').write(s)
print('ok')
