import io, os, re, colorsys, sys
sys.stdout.reconfigure(encoding='utf-8', errors='replace')
KOK = r'D:\indirilenler\Yeni klasor43\lib'
for dizin, _, adlar in os.walk(KOK):
    for ad in adlar:
        if not ad.endswith('.dart') or ad.startswith('app_localizations') or 'kombin_oyunu' in ad or 'moda_renk' in ad:
            continue
        p = os.path.join(dizin, ad)
        for i, satir in enumerate(io.open(p, encoding='utf-8', errors='replace'), 1):
            for m in re.finditer(r'Color\(0x([0-9A-Fa-f]{8})\)', satir):
                h8 = m.group(1)
                if h8[:2].upper() != 'FF':
                    continue
                if h8.upper() in ('FFFFFFFF', 'FF000000'):
                    continue
                r, g, b = [int(h8[k:k + 2], 16) / 255 for k in (2, 4, 6)]
                h, s, v = colorsys.rgb_to_hsv(r, g, b)
                d = h * 360
                sicak = 30 <= d <= 65 or 135 <= d <= 185 or d >= 345 or d <= 15
                if s < 0.02:
                    print('GRI       %-34s:%-5d %s' % (ad, i, h8))
                elif s < 0.12 and not sicak:
                    print('SOGUK     %-34s:%-5d %s h=%.0f s=%.2f' % (ad, i, h8, d, s))
