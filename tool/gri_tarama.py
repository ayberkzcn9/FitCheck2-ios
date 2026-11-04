import io, os, re, colorsys, sys
sys.stdout.reconfigure(encoding='utf-8', errors='replace')

KOK = r'D:\indirilenler\Yeni klasor43\lib'

# 1) Ham Material gri / yari saydam siyah-beyaz kullanimlari
HAM = re.compile(r'Colors\.(grey|greyShade\d*|black\d*|white\d*|blueGrey)\b')

# 2) Hex renkler: gri mi (dusuk doygunluk)?
HEX = re.compile(r'Color\(0x([0-9a-fA-F]{8})\)')

def gri_mi(r, g, b):
    h, s, v = colorsys.rgb_to_hsv(r / 255.0, g / 255.0, b / 255.0)
    return s < 0.10, h * 360, s, v

ham = []
hexler = []
for kok, _, dosyalar in os.walk(KOK):
    for d in dosyalar:
        if not d.endswith('.dart'):
            continue
        p = os.path.join(kok, d)
        rel = os.path.relpath(p, os.path.dirname(KOK))
        for i, satir in enumerate(io.open(p, encoding='utf-8', errors='replace'), 1):
            for m in HAM.finditer(satir):
                ham.append((rel, i, m.group(0), satir.strip()[:100]))
            for m in HEX.finditer(satir):
                deger = m.group(1)
                a = int(deger[0:2], 16)
                r = int(deger[2:4], 16)
                g = int(deger[4:6], 16)
                b = int(deger[6:8], 16)
                gri, h, s, v = gri_mi(r, g, b)
                if gri:
                    hexler.append((rel, i, m.group(0), h, s, v, satir.strip()[:100]))

print('=' * 78)
print('1) HAM MATERIAL GRI / SIYAH-BEYAZ')
print('=' * 78)
print('toplam: %d' % len(ham))
gruplu = {}
for rel, i, ad, satir in ham:
    gruplu.setdefault(ad, []).append((rel, i, satir))
for ad in sorted(gruplu, key=lambda x: -len(gruplu[x])):
    print('\n  %s  (%d kez)' % (ad, len(gruplu[ad])))
    for rel, i, satir in gruplu[ad][:6]:
        print('    %s:%d  %s' % (rel, i, satir))

print()
print('=' * 78)
print('2) HEX RENKLERDEN GRI OLANLAR (doygunluk < 0.10)')
print('=' * 78)
print('toplam: %d' % len(hexler))
for rel, i, deger, h, s, v, satir in hexler:
    print('  %-46s:%-5d %s  h=%5.1f s=%.2f v=%.2f' % (rel, i, deger, h, s, v))
