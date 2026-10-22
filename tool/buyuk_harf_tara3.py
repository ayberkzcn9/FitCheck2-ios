import io, os, re, sys
sys.stdout.reconfigure(encoding='utf-8', errors='replace')

for dil in ['tr', 'en', 'de', 'es', 'fr', 'it', 'pt', 'ru', 'zh', 'ja', 'ko', 'ar']:
    s = io.open(os.path.join(r'D:\indirilenler\Yeni klasor43\lib\l10n', 'app_%s.arb' % dil), encoding='utf-8').read()
    for k in ['stilistTitle', 'gunlukKombinTitle', 'profilAnalizTitle']:
        m = re.search(r'"' + k + r'":\s*"([^"]*)"', s)
        print('%-3s %-24s %s' % (dil, k, m.group(1) if m else 'NA'))
    print()
