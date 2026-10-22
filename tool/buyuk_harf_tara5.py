import io, os, re, sys
sys.stdout.reconfigure(encoding='utf-8', errors='replace')

L10N = r'D:\indirilenler\Yeni klasor43\lib\l10n'

# Turkce title case'i elle yap (Python'un .lower()/.upper() Turkce i/I kuralini bozuyor).
turkce_degerler = {
    'stilistTitle': 'Anlık Kombin Stilisti',
    'gunlukKombinTitle': 'Günlük Kombin',
    'profilAnalizTitle': 'Profil & Analiz',
}

p = os.path.join(L10N, 'app_tr.arb')
s = io.open(p, encoding='utf-8', newline='').read()
for k, v in turkce_degerler.items():
    m = re.search(r'("' + k + r'":\s*")([^"]*)(")', s)
    if not m:
        print('BULUNAMADI:', k)
        continue
    s = s[:m.start(2)] + v + s[m.end(2):]
    print('tr %-24s -> %s' % (k, v))
io.open(p, 'w', encoding='utf-8', newline='').write(s)

# Almanca ve Ingilizce'de yanlis turkce karakter var mi kontrol et.
for dil in ['en', 'de']:
    s = io.open(os.path.join(L10N, 'app_%s.arb' % dil), encoding='utf-8', newline='').read()
    for k in turkce_degerler:
        m = re.search(r'"' + k + r'":\s*"([^"]*)"', s)
        print('%-3s %-24s %s' % (dil, k, m.group(1) if m else 'NA'))
