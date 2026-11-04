import io, os, sys
sys.stdout.reconfigure(encoding='utf-8', errors='replace')

# Bugun ekranindaki yatay raf: ogeler 82 px genislikteydi, 12 pt etiket
# ("Siyah Pantolon", "Beyaz Sneaker") sigmiyor ve kirpiliyordu. Genislik
# 96 px'e cikarildi, gorsel alani biraz kisaltildi.
yol = r'D:\indirilenler\Yeni klasor43\lib\screens\bugun_ekrani.dart'
s = io.open(yol, encoding='utf-8', newline='').read()

eski = """              return SizedBox(
                width: 82,
                child: GestureDetector(
                  onTap: () => _parcaMenusu(context, l10n, parca),
                  child: Column(
                    children: [
                      Container(
                        width: 82,
                        height: 82,"""
yeni = """              return SizedBox(
                width: 96,
                child: GestureDetector(
                  onTap: () => _parcaMenusu(context, l10n, parca),
                  child: Column(
                    children: [
                      Container(
                        width: 96,
                        height: 76,"""
if s.count(eski) != 1:
    raise SystemExit('eslesme: %d' % s.count(eski))
s = s.replace(eski, yeni)
io.open(yol, 'w', encoding='utf-8', newline='').write(s)
print('bugun rafi genisletildi')

# Seyahat valiz plani: 76 px genislikteki ogelerde de 12 pt etiket sigmiyor.
yol2 = r'D:\indirilenler\Yeni klasor43\lib\screens\seyahat_ekrani.dart'
s2 = io.open(yol2, encoding='utf-8', newline='').read()
eski2 = """                SizedBox(
                  width: 76,
                  child: Column(
                    children: [
                      Container(
                        width: 76,
                        height: 54,"""
yeni2 = """                SizedBox(
                  width: 88,
                  child: Column(
                    children: [
                      Container(
                        width: 88,
                        height: 54,"""
if s2.count(eski2) != 1:
    raise SystemExit('seyahat eslesme: %d' % s2.count(eski2))
s2 = s2.replace(eski2, yeni2)
io.open(yol2, 'w', encoding='utf-8', newline='').write(s2)
print('seyahat ogeleri genisletildi')
