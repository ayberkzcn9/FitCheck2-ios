import io, math, colorsys, sys
sys.stdout.reconfigure(encoding='utf-8', errors='replace')

def hexrenk(h):
    h = h.replace('#', '').replace('0x', '').replace('FF', '', 1) if len(h) >= 10 else h.replace('#', '')
    return tuple(int(h[i:i + 2], 16) for i in (0, 2, 4))

def lab(rgb):
    def f(c):
        c = c / 255.0
        return c / 12.92 if c <= 0.04045 else ((c + 0.055) / 1.055) ** 2.4
    r, g, b = (f(x) for x in rgb)
    x = (r * 0.4124 + g * 0.3576 + b * 0.1805) / 0.95047
    y = (r * 0.2126 + g * 0.7152 + b * 0.0722)
    z = (r * 0.0193 + g * 0.1192 + b * 0.9505) / 1.08883
    def g2(t):
        return t ** (1 / 3) if t > 0.008856 else 7.787 * t + 16 / 116
    fx, fy, fz = g2(x), g2(y), g2(z)
    return (116 * fy - 16, 500 * (fx - fy), 200 * (fy - fz))

def de(a, b):
    la, lb = lab(a), lab(b)
    return math.sqrt(sum((x - y) ** 2 for x, y in zip(la, lb)))

def hsv(rgb):
    h, s, v = colorsys.rgb_to_hsv(*[c / 255.0 for c in rgb])
    return h * 360, s, v

ZEMIN_ACIK = hexrenk('#FBF7EF')   # colorScheme.surface (acik)
ZEMIN_KOYU = hexrenk('#0F1512')   # colorScheme.surface (koyu)
KART_ACIK = hexrenk('#FFFDF8')    # surfaceContainerLow
KART_KOYU = hexrenk('#1B231F')    # surfaceContainer (koyu)

print('=' * 78)
print('UYARI KUTUSU ZEMINE NE KADAR YAKIN? (dE < 5 = fark edilmez)')
print('=' * 78)
for ad, renk, zemin in [
    ('warningBg  acik', '#FFF8F0', KART_ACIK),
    ('warningBg  koyu', '#2E2416', KART_KOYU),
    ('successBg  acik', '#E3F0EA', KART_ACIK),
    ('errorBg    acik', '#FEE2E2', KART_ACIK),
    ('styleistBg acik', '#F1F6F3', KART_ACIK),
    ('favoriteBg acik', '#FFF8E1', KART_ACIK),
    ('warningBorder acik', '#EAD7BE', KART_ACIK),
]:
    rgb = hexrenk(renk)
    h, s, v = hsv(rgb)
    print('  %-20s %s  dE(zemin)=%5.1f   h=%5.1f s=%.2f v=%.2f'
          % (ad, renk, de(rgb, zemin), h, s, v))

print()
print('=' * 78)
print('NOTR TOKENLER (metin, sinir, kontur) — doygunluk ve hue')
print('=' * 78)
for ad, renk in [
    ('onSurface        acik', '#1B1D1A'),
    ('onSurfaceVariant acik', '#4A4F49'),
    ('outline          acik', '#7A8078'),
    ('outlineVariant   acik', '#DDD7C8'),
    ('onSurface        koyu', '#E4E9E4'),
    ('onSurfaceVariant koyu', '#BCC5BE'),
    ('outline          koyu', '#86908A'),
    ('outlineVariant   koyu', '#3B4640'),
    ('AppBar fg        koyu', '#F2F2F2'),
    ('amberTextBody    acik', '#6B4A20'),
    ('amberText        acik', '#B26A00'),
    ('warning          aksan', '#D97706'),
]:
    rgb = hexrenk(renk)
    h, s, v = hsv(rgb)
    notr = 'GRI' if s < 0.10 else ('notr' if s < 0.18 else 'renkli')
    print('  %-22s %s  h=%5.1f s=%.2f v=%.2f   %s'
          % (ad, renk, h, s, v, notr))

print()
print('=' * 78)
print('MARKA HUE REFERANSI: 159-165 derece')
print('=' * 78)
for ad, renk in [('primary acik', '#0F5F4A'), ('primary koyu', '#7FD4B4'),
                 ('success', '#1F7A5A'), ('info', '#30827D')]:
    h, s, v = hsv(hexrenk(renk))
    print('  %-16s %s  h=%5.1f s=%.2f v=%.2f' % (ad, renk, h, s, v))
