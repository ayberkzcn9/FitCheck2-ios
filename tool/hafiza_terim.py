import io, re, sys
sys.stdout.reconfigure(encoding='utf-8', errors='replace')

anahtarlar = ['arkaPlan', 'tekrarCek', 'kesim', 'gercek', 'goruyor', 'fotograf']
for dil, yol in [('tr', 'app_tr.arb'), ('en', 'app_en.arb')]:
    s = io.open(r'D:\indirilenler\Yeni klasor43\lib\l10n' + '\\' + yol, encoding='utf-8').read()
    print('===', dil)
    for m in re.finditer(r'"([A-Za-z0-9_]*)":\s*"([^"]*)"', s):
        k, v = m.group(1), m.group(2)
        kl = k.lower()
        if any(a.lower() in kl for a in anahtarlar) and len(v) < 100:
            print('  %-44s = %s' % (k, v))
