import io, os, re, sys
sys.stdout.reconfigure(encoding='utf-8', errors='replace')

KOK = r'D:\indirilenler\Yeni klasor43\lib'

# Sayı -> token. Ölçek: 4, 8, 12, 16, 20, 24, 32.
# 10 ve 22 ölçeğe yuvarlanır, 3 ve 18 bir üste/altta yuvarlanır.
HARITA = {
    '3': 'xs', '4': 'xs',
    '8': 'sm',
    '10': 'md', '12': 'md', '14': 'md',
    '16': 'lg', '18': 'lg',
    '20': 'xl', '22': 'xl',
    '24': 'xxl', '28': 'xxl',
    '32': 'xxxl',
}

def token(sayi):
    # "14" ve "14.0" ayni
    if '.' in sayi:
        sayi = sayi.rstrip('0').rstrip('.')
    return HARITA.get(sayi)


def donustur(s):
    """Dolgu degerlerini AppSpacing tokenina baglar."""
    def ftlr(m):
        g = m.groups()
        out = []
        for v in g:
            t = token(v)
            out.append('AppSpacing.' + t if t else v)
        return 'EdgeInsets.fromLTRB(%s, %s, %s, %s)' % tuple(out)

    s = re.sub(r'EdgeInsets\.fromLTRB\(\s*([\d.]+)\s*,\s*([\d.]+)\s*,\s*([\d.]+)\s*,\s*([\d.]+)\s*\)',
               ftlr, s)

    def tall(m):
        v = m.group(1)
        t = token(v)
        return 'EdgeInsets.all(AppSpacing.%s)' % t if t else m.group(0)

    s = re.sub(r'EdgeInsets\.all\(\s*([\d.]+)\s*\)', tall, s)

    def sym(m):
        h, v = m.group(1), m.group(2)
        th, tv = token(h), token(v)
        hh = 'AppSpacing.' + th if th else h
        vv = 'AppSpacing.' + tv if tv else v
        return 'EdgeInsets.symmetric(horizontal: %s, vertical: %s)' % (hh, vv)

    s = re.sub(r'EdgeInsets\.symmetric\(\s*horizontal:\s*([\d.]+)\s*,\s*vertical:\s*([\d.]+)\s*\)',
               sym, s)

    def symh(m):
        h = m.group(1)
        th = token(h)
        return 'EdgeInsets.symmetric(horizontal: %s)' % ('AppSpacing.' + th if th else h)

    s = re.sub(r'EdgeInsets\.symmetric\(\s*horizontal:\s*([\d.]+)\s*\)', symh, s)

    def symv(m):
        v = m.group(1)
        tv = token(v)
        return 'EdgeInsets.symmetric(vertical: %s)' % ('AppSpacing.' + tv if tv else v)

    s = re.sub(r'EdgeInsets\.symmetric\(\s*vertical:\s*([\d.]+)\s*\)', symv, s)

    # Kalan horizontal/vertical (EdgeInsets.only, Padding vb.)
    def tek(m):
        on = m.group(1)
        v = m.group(2)
        t = token(v)
        return '%s: %s' % (on, ('AppSpacing.' + t if t else v))

    s = re.sub(r'\b(horizontal|vertical):\s*([\d.]+)\b', tek, s)

    return s


toplam = 0
for dizin, _, adlar in os.walk(KOK):
    for ad in adlar:
        if not ad.endswith('.dart'):
            continue
        if ad in ('design_tokens.dart', 'app_tema.dart'):
            continue
        if 'app_localizations' in ad or 'kombin_oyunu' in ad or 'moda_renk' in ad:
            continue
        yol = os.path.join(dizin, ad)
        s = io.open(yol, encoding='utf-8', newline='').read()
        if 'EdgeInsets' not in s:
            continue
        yeni = donustur(s)
        if yeni != s:
            # const olmayan EdgeInsets'a AppSpacing girerse const kalkar
            io.open(yol, 'w', encoding='utf-8', newline='').write(yeni)
            n = len(re.findall(r'AppSpacing\.', yeni)) - len(re.findall(r'AppSpacing\.', s))
            toplam += n
            print('  %-34s +%d' % (ad, n))
print('toplam %d dolgu degeri tokena baglandi' % toplam)
