import io, os, re, colorsys, sys
sys.stdout.reconfigure(encoding='utf-8', errors='replace')

KOK = r'D:\indirilenler\Yeni klasor43\lib'
TOKEN = os.path.join(KOK, 'theme', 'design_tokens.dart')
TEMA = os.path.join(KOK, 'theme', 'app_tema.dart')

HEX = re.compile(r'Color\(0x([0-9A-Fa-f]{8})\)')
NAMED = re.compile(r'Colors\.([a-zA-Z]+)(?:\.shade(\d+))?')

# Token dosyalarinda tanimli degerler (tekrar kullanim tespiti icin)
token_degerleri = {}
for yol, ad in ((TOKEN, 'design_tokens'), (TEMA, 'app_tema')):
    s = io.open(yol, encoding='utf-8').read()
    for m in HEX.finditer(s):
        token_degerleri.setdefault(m.group(1).upper(), ad)


def sinif(h8):
    a = int(h8[0:2], 16)
    r, g, b = [int(h8[i:i + 2], 16) / 255.0 for i in (2, 4, 6)]
    h, s, v = colorsys.rgb_to_hsv(r, g, b)
    d = h * 360
    if a < 255:
        return 'saydam', d, s, v
    if s < 0.12:
        if 25 <= d <= 70:
            return 'sicak-notr', d, s, v
        if 130 <= d <= 200:
            return 'zumrut-notr', d, s, v
        if d >= 340 or d <= 20:
            return 'kirmizi-ton', d, s, v
        return 'SOGUK', d, s, v
    if 130 <= d <= 200:
        return 'zumrut', d, s, v
    if 25 <= d <= 70:
        return 'amber/sicak', d, s, v
    if d >= 335 or d <= 20:
        return 'kirmizi', d, s, v
    return 'MARKA-DISI', d, s, v


satirlar = []
for dizin, _, adlar in os.walk(KOK):
    for ad in adlar:
        if not ad.endswith('.dart') or ad.startswith('app_localizations') \
                or 'kombin_oyunu' in ad or 'moda_renk' in ad:
            continue
        p = os.path.join(dizin, ad)
        for i, satir in enumerate(io.open(p, encoding='utf-8', errors='replace'), 1):
            for m in HEX.finditer(satir):
                h8 = m.group(1).upper()
                k, d, s, v = sinif(h8)
                satirlar.append((ad, i, h8, k, d, s, v, satir.strip()[:90]))

print('=' * 86)
print('MARKA DISI / SOGUK RENKLER (opak)')
print('=' * 86)
n = 0
for ad, i, h8, k, d, s, v, satir in satirlar:
    if k in ('MARKA-DISI', 'SOGUK'):
        print('  %-38s:%-5d %s  %-10s h=%5.1f s=%.2f v=%.2f' % (ad, i, h8, k, d, s, v))
        print('      %s' % satir)
        n += 1
print('toplam: %d' % n)

print()
print('=' * 86)
print('TOKEN DISINDA TEKRAR EDEN RENKLER (ayni hex, token dosyasi haric)')
print('=' * 86)
tekrar = {}
for ad, i, h8, k, d, s, v, satir in satirlar:
    if h8 in token_degerleri:
        tekrar.setdefault(h8, []).append((ad, i))
for h8, yerler in sorted(tekrar.items(), key=lambda x: -len(x[1])):
    print('  %s  (%s icinde tanimli)  %d kez' % (h8, token_degerleri[h8], len(yerler)))
    for ad, i in yerler[:6]:
        print('      %s:%d' % (ad, i))
print('toplam farkli deger: %d' % len(tekrar))

print()
print('=' * 86)
print('ISIMLI MATERIAL RENKLERI')
print('=' * 86)
isimli = {}
for dizin, _, adlar in os.walk(KOK):
    for ad in adlar:
        if not ad.endswith('.dart') or ad.startswith('app_localizations') \
                or 'kombin_oyunu' in ad or 'moda_renk' in ad:
            continue
        for i, satir in enumerate(io.open(os.path.join(dizin, ad), encoding='utf-8', errors='replace'), 1):
            for m in NAMED.finditer(satir):
                isimli.setdefault(m.group(0), []).append((ad, i))
for ad, yerler in sorted(isimli.items(), key=lambda x: -len(x[1])):
    print('  %-22s %3d kez   ornek: %s:%d' % (ad, len(yerler), yerler[0][0], yerler[0][1]))

print()
print('=' * 86)
print('SINIFLANDIRMA OZETI')
print('=' * 86)
ozet = {}
for _, _, _, k, _, _, _, _ in satirlar:
    ozet[k] = ozet.get(k, 0) + 1
for k, v in sorted(ozet.items(), key=lambda x: -x[1]):
    print('  %-14s %d' % (k, v))
