import io, os, re, sys
sys.stdout.reconfigure(encoding='utf-8', errors='replace')

L10N = r'D:\indirilenler\Yeni klasor43\lib\l10n'
KEYS = ['stilistTitle', 'gunlukKombinTitle', 'profilAnalizTitle']

def title_case(text, dil):
    # Turkce i/I ozel kurali
    if dil == 'tr':
        kucuk = text.lower().replace('i', 'ı').replace('İ', 'i')
        # Turkce title case: her kelimenin ilk harfi buyuk
        sonuc = []
        for kelime in kucuk.split(' '):
            if not kelime:
                sonuc.append('')
                continue
            # tire ile ayri kelimeler
            parts = kelime.split('-')
            yeni_parts = []
            for p in parts:
                if p:
                    yeni_parts.append(p[0].upper() + p[1:])
                else:
                    yeni_parts.append(p)
            sonuc.append('-'.join(yeni_parts))
        return ' '.join(sonuc)
    # Diger diller: standart title case
    words = text.split(' ')
    out = []
    for w in words:
        parts = w.split('-')
        yeni = '-'.join(p[0].upper() + p[1:].lower() if p else p for p in parts)
        out.append(yeni)
    return ' '.join(out)

for dil in ['tr', 'en', 'de']:
    p = os.path.join(L10N, 'app_%s.arb' % dil)
    s = io.open(p, encoding='utf-8', newline='').read()
    for k in KEYS:
        m = re.search(r'("' + k + r'":\s*")([^"]*)(")', s)
        if not m:
            print('BULUNAMADI:', dil, k)
            continue
        eski = m.group(2)
        yeni = title_case(eski, dil)
        s = s[:m.start(2)] + yeni + s[m.end(2):]
        print('%-3s %-24s %s  ->  %s' % (dil, k, eski, yeni))
    io.open(p, 'w', encoding='utf-8', newline='').write(s)

print('tamam')
