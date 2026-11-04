import io, math, colorsys, sys
sys.stdout.reconfigure(encoding='utf-8', errors='replace')

def rgb(h):
    h = h.lstrip('#')
    return tuple(int(h[i:i + 2], 16) for i in (0, 2, 4))

def lum(h):
    def f(c):
        c = c / 255.0
        return c / 12.92 if c <= 0.03928 else ((c + 0.055) / 1.055) ** 2.4
    r, g, b = [f(x) for x in rgb(h)]
    return 0.2126 * r + 0.7152 * g + 0.0722 * b

def kontrast(a, b):
    la, lb = lum(a), lum(b)
    return (max(la, lb) + 0.05) / (min(la, lb) + 0.05)

def lab(h):
    r, g, b = [x / 255.0 for x in rgb(h)]
    def f(c):
        return c / 12.92 if c <= 0.04045 else ((c + 0.055) / 1.055) ** 2.4
    r, g, b = f(r), f(g), f(b)
    x = (r * 0.4124 + g * 0.3576 + b * 0.1805) / 0.95047
    y = r * 0.2126 + g * 0.7152 + b * 0.0722
    z = (r * 0.0193 + g * 0.1192 + b * 0.9505) / 1.08883
    def g2(t):
        return t ** (1 / 3) if t > 0.008856 else 7.787 * t + 16 / 116
    fx, fy, fz = g2(x), g2(y), g2(z)
    return (116 * fy - 16, 500 * (fx - fy), 200 * (fy - fz))

def de(a, b):
    return math.sqrt(sum((x - y) ** 2 for x, y in zip(lab(a), lab(b))))

def hsv(h):
    x, y, z = colorsys.rgb_to_hsv(*[c / 255.0 for c in rgb(h)])
    return x * 360, y, z

ZEMIN_A = '#FBF7EF'
KART_A = '#FFFDF8'
ZEMIN_K = '#0F1512'
KART_K = '#1B231F'

ACIK = [
    ('onSurface',        '#1B1D1A', '#1E1C16'),
    ('onSurfaceVariant', '#4A4F49', '#4A4841'),
    ('outline',          '#7A8078', '#7C796F'),
]
KOYU = [
    ('onSurface',        '#E4E9E4', '#E8E6DE'),
    ('onSurfaceVariant', '#BCC5BE', '#C3C1B7'),
    ('outline',          '#86908A', '#8B8880'),
]
TINT = [
    ('warningBg',    '#FFF8F0', '#FDF0DC', KART_A),
    ('warningBorder','#EAD7BE', '#E7CFAE', KART_A),
    ('styleistBg',   '#F1F6F3', '#E9F3EE', KART_A),
]

print('=' * 82)
print('ACIK TEMA')
print('=' * 82)
for ad, eski, yeni in ACIK:
    h1 = hsv(eski)
    h2 = hsv(yeni)
    hedef = ZEMIN_A if ad != 'outline' else ZEMIN_A
    esik = 3.0 if ad == 'outline' else 4.5
    k = kontrast(yeni, ZEMIN_A)
    print('  %-18s %s -> %s   h %5.1f->%5.1f  s %.2f->%.2f  kontrast %.2f (min %.1f) %s'
          % (ad, eski, yeni, h1[0], h2[0], h1[1], h2[1], k, esik, 'OK' if k >= esik else 'HATA'))

print()
print('=' * 82)
print('KOYU TEMA')
print('=' * 82)
for ad, eski, yeni in KOYU:
    h1 = hsv(eski)
    h2 = hsv(yeni)
    esik = 3.0 if ad == 'outline' else 4.5
    k = kontrast(yeni, ZEMIN_K)
    print('  %-18s %s -> %s   h %5.1f->%5.1f  s %.2f->%.2f  kontrast %.2f (min %.1f) %s'
          % (ad, eski, yeni, h1[0], h2[0], h1[1], h2[1], k, esik, 'OK' if k >= esik else 'HATA'))

print()
print('=' * 82)
print('UYARI / STILIST ZEMINLERI — karta gore algilanabilirlik')
print('=' * 82)
for ad, eski, yeni, kart in TINT:
    print('  %-15s %s dE=%.1f  ->  %s dE=%.1f   %s'
          % (ad, eski, de(eski, kart), yeni, de(yeni, kart),
             'gorunur' if de(yeni, kart) >= 6 else 'zayif'))

print()
print('=' * 82)
print('UYARI KUTUSU METIN KONTRASTI (yeni zemin)')
print('=' * 82)
for ad, metin in [('amberTextBody #6B4A20', '#6B4A20'),
                  ('amberTextDark #8A5300', '#8A5300'),
                  ('amberText #B26A00', '#B26A00')]:
    print('  %-24s / #FDF0DC = %.2f (min 4.5)' % (ad, kontrast(metin, '#FDF0DC')))

print()
print('=' * 82)
print('STILIST KUTUSU METIN KONTRASTI (yeni zemin)')
print('=' * 82)
for ad, metin in [('styleistTextDark #1F4A3E', '#1F4A3E'),
                  ('styleistText #2E5F50', '#2E5F50')]:
    print('  %-28s / #E9F3EE = %.2f (min 4.5)' % (ad, kontrast(metin, '#E9F3EE')))
