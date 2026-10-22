"""Renk uyumu denetimi: WCAG kontrast + ton (hue) uyumu.

Tum renkleri koddan okur, sonra:
  1) kritik renk ciftleri icin WCAG kontrast oranini hesaplar
  2) vurgu paletinin ton dagilimini (hue) olcer
  3) yuzey (surface) rampasinin aydinlik adimlarini olcer
"""
import io, os, re, sys, colorsys
sys.stdout.reconfigure(encoding='utf-8', errors='replace')

KOK = r'D:\indirilenler\Yeni klasor43\lib'

# Flutter hex: 0xAARRGGBB (8 hane)
HEX = re.compile(r'(\w+)\s*=\s*(?:const\s+)?Color\(0x([0-9A-Fa-f]{8})\)')
HEX_IN = re.compile(r'(\w+):\s*(?:const\s+)?Color\(0x([0-9A-Fa-f]{8})\)')


def rgb(h8):
    """0xAARRGGBB -> #RRGGBB"""
    return '#' + h8[2:].upper()


def hex_to_rgb(h):
    h = h.lstrip('#')
    return tuple(int(h[i:i + 2], 16) for i in (0, 2, 4))


def lum(rgbv):
    def f(c):
        c = c / 255.0
        return c / 12.92 if c <= 0.03928 else ((c + 0.055) / 1.055) ** 2.4
    r, g, b = [f(x) for x in rgbv]
    return 0.2126 * r + 0.7152 * g + 0.0722 * b


def kontrast(a, b):
    la, lb = lum(hex_to_rgb(a)), lum(hex_to_rgb(b))
    hi, lo = max(la, lb), min(la, lb)
    return (hi + 0.05) / (lo + 0.05)


def hsl(h):
    r, g, b = [c / 255.0 for c in hex_to_rgb(h)]
    hh, ll, ss = colorsys.rgb_to_hls(r, g, b)
    return round(hh * 360), round(ss * 100), round(ll * 100)


tema = io.open(os.path.join(KOK, 'theme', 'app_tema.dart'), encoding='utf-8').read()
token = io.open(os.path.join(KOK, 'theme', 'design_tokens.dart'), encoding='utf-8').read()

# Koyu blok: 'if (brightness == Brightness.dark)' sonrasi
i_koyu = tema.index('if (brightness == Brightness.dark)')
# Acik blok: sonuncu 'return base.copyWith('
i_acik = tema.rindex('return base.copyWith(')
koyu_blok = tema[i_koyu:i_acik]
acik_blok = tema[i_acik:]


def sema_oku(blok):
    out = {}
    for m in HEX_IN.finditer(blok):
        out[m.group(1)] = rgb(m.group(2))
    return out


koyu = sema_oku(koyu_blok)
acik = sema_oku(acik_blok)


def token_renkleri(metin, sinif_adi):
    i = metin.index('class %s {' % sinif_adi)
    j = metin.find('\nclass ', i + 10)
    if j == -1:
        j = len(metin)
    out = {}
    for m in HEX.finditer(metin[i:j]):
        out[m.group(1)] = rgb(m.group(2))
    return out


akcent = token_renkleri(token, 'AppAccents')
durum = token_renkleri(token, 'AppStatusColors')
tint = token_renkleri(token, 'AppTints')

print('Acik sema: %d renk, Koyu sema: %d renk' % (len(acik), len(koyu)))

ciftler_acik = [
    ('onSurface / surface', 'onSurface', 'surface', 4.5),
    ('onSurface / surfaceContainerLow', 'onSurface', 'surfaceContainerLow', 4.5),
    ('onSurface / surfaceContainer', 'onSurface', 'surfaceContainer', 4.5),
    ('onSurfaceVariant / surface', 'onSurfaceVariant', 'surface', 4.5),
    ('onSurfaceVariant / surfaceContainerLow', 'onSurfaceVariant', 'surfaceContainerLow', 4.5),
    ('onPrimary / primary (dolu dugme)', 'onPrimary', 'primary', 4.5),
    ('onPrimaryContainer / primaryContainer', 'onPrimaryContainer', 'primaryContainer', 4.5),
    ('onSecondaryContainer / secondaryContainer', 'onSecondaryContainer', 'secondaryContainer', 4.5),
    ('onTertiaryContainer / tertiaryContainer', 'onTertiaryContainer', 'tertiaryContainer', 4.5),
    ('primary / surface (vurgu metni)', 'primary', 'surface', 4.5),
    ('primary / surfaceContainer (ikincil eylem)', 'primary', 'surfaceContainer', 4.5),
    ('outline / surface (kenarlik)', 'outline', 'surface', 3.0),
]
ciftler_koyu = [
    ('onSurface / surface', 'onSurface', 'surface', 4.5),
    ('onSurface / surfaceContainerLow', 'onSurface', 'surfaceContainerLow', 4.5),
    ('onSurfaceVariant / surface', 'onSurfaceVariant', 'surface', 4.5),
    ('onPrimary / primary (dolu dugme)', 'onPrimary', 'primary', 4.5),
    ('onPrimaryContainer / primaryContainer', 'onPrimaryContainer', 'primaryContainer', 4.5),
    ('primary / surface (vurgu metni)', 'primary', 'surface', 4.5),
    ('tertiary / surface', 'tertiary', 'surface', 4.5),
]

basarisiz = []

print()
print('=' * 78)
print('ACIK TEMA - KRITIK KONTRASTLAR (WCAG AA: metin 4.5, kenar 3.0)')
print('=' * 78)
for ad, a, b, hedef in ciftler_acik:
    if a not in acik or b not in acik:
        print('  (atlandi) %s' % ad)
        continue
    k = kontrast(acik[a], acik[b])
    ok = k >= hedef
    if not ok:
        basarisiz.append(('ACIK', ad, k, hedef))
    print('%-42s %5.2f  (hedef %.1f)  %-6s %s / %s' %
          (ad, k, hedef, 'OK' if ok else 'DUSUK', acik[a], acik[b]))

print()
print('=' * 78)
print('KOYU TEMA - KRITIK KONTRASTLAR')
print('=' * 78)
for ad, a, b, hedef in ciftler_koyu:
    if a not in koyu or b not in koyu:
        print('  (atlandi) %s' % ad)
        continue
    k = kontrast(koyu[a], koyu[b])
    ok = k >= hedef
    if not ok:
        basarisiz.append(('KOYU', ad, k, hedef))
    print('%-42s %5.2f  (hedef %.1f)  %-6s %s / %s' %
          (ad, k, hedef, 'OK' if ok else 'DUSUK', koyu[a], koyu[b]))

print()
print('=' * 78)
print('VURGU PALETI - TON (HUE) DAGILIMI')
print('=' * 78)
print('%-24s %-9s %6s %5s %5s' % ('renk', 'hex', 'hue', 'sat', 'light'))
palet = []
for kaynak, sozluk in (('AppAccents', akcent), ('AppStatusColors', durum), ('AppTints', tint)):
    for ad, hx in sozluk.items():
        h, s, l = hsl(hx)
        palet.append((kaynak + '.' + ad, hx, h, s, l))
        print('%-24s %-9s %6d %4d%% %4d%%' % (kaynak + '.' + ad, hx, h, s, l))

doygun = [p for p in palet if p[3] >= 15]
if doygun:
    hues = [p[2] for p in doygun]
    print()
    print('doygun vurgu renklerinde hue araligi: %d..%d (aciklik %d derece)' %
          (min(hues), max(hues), max(hues) - min(hues)))

print()
print('=' * 78)
print('YUZEY RAMPI - AYDINLIK ADIMLARI (monoton olmali)')
print('=' * 78)
for ad, sema in (('ACIK', acik), ('KOYU', koyu)):
    ramp = ['surfaceContainerLowest', 'surfaceContainerLow', 'surfaceContainer',
            'surfaceContainerHigh', 'surfaceContainerHighest']
    adimlar = [(r, sema[r], hsl(sema[r])[2]) for r in ramp if r in sema]
    print('%s:' % ad)
    for r, hx, l in adimlar:
        print('   %-24s %-9s L=%d%%' % (r, hx, l))
    ls = [l for _, _, l in adimlar]
    artan = all(ls[i] <= ls[i + 1] for i in range(len(ls) - 1))
    print('   monoton artan: %s' % ('EVET' if artan else 'HAYIR'))
    if len(ls) > 1:
        print('   adim farklari: %s' % [ls[i + 1] - ls[i] for i in range(len(ls) - 1)])

print()
print('=' * 78)
print('SONUC')
print('=' * 78)
if basarisiz:
    for tema_, ad, k, hedef in basarisiz:
        print('  [!] %s: %s -> %.2f (hedef %.1f)' % (tema_, ad, k, hedef))
else:
    print('  Kritik kontrast ciftlerinin tamami gecerli.')
