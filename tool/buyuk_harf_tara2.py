import io, re, sys
sys.stdout.reconfigure(encoding='utf-8', errors='replace')

s = io.open(r'D:\indirilenler\Yeni klasor43\lib\l10n\app_tr.arb', encoding='utf-8').read()

for m in re.finditer(r'"([^"]*Title[^"]*)":\s*"([^"]*)"', s):
    k, v = m.group(1), m.group(2)
    harf = re.sub(r'[^A-Za-z]', '', v)
    iscaps = len(harf) >= 3 and harf.isupper()
    print(('CAPS' if iscaps else 'norm'), '%-34s %s' % (k, v))
