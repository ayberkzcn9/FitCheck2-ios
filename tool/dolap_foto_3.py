import io
p = r'D:\indirilenler\Yeni klasor43\lib\screens\gardirobum_ekrani.dart'
s = io.open(p, encoding='utf-8', newline='').read()
nl = '\r\n' if '\r\n' in s else '\n'

# Onceki deneme (Align/topCenter) resmi sıkıştırıp görünmez yapmıştı.
# Bu kez güvenli yol: fotoğraf alanı kartın belirli bir yüksekliğini alır,
# kalan yer etiket şeridine ve aradaki boşluğa gider.
eski = """              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [""".replace('\n', nl)
yeni = """              Expanded(
                flex: 7,
                child: Stack(
                  fit: StackFit.expand,
                  children: [""".replace('\n', nl)
if s.count(eski) != 1:
    raise SystemExit('eslesme: %d' % s.count(eski))
s = s.replace(eski, yeni)
io.open(p, 'w', encoding='utf-8', newline='').write(s)
print('ok')
