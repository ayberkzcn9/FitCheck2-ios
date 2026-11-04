import io, os, re, sys
sys.stdout.reconfigure(encoding='utf-8', errors='replace')

KOK = r'D:\indirilenler\Yeni klasor43\lib'

def duzenle(yol, s):
    def all6(m):
        return 'EdgeInsets.all(AppSpacing.xs)'
    s = re.sub(r'EdgeInsets\.all\(6\)', all6, s)
    s = re.sub(r'EdgeInsets\.all\(5\)', 'EdgeInsets.all(AppSpacing.xs)', s)
    s = re.sub(r'\bvertical:\s*6(?=[,)])', 'vertical: AppSpacing.xs', s)
    s = re.sub(r'\bvertical:\s*6\.0(?=[,)])', 'vertical: AppSpacing.xs', s)
    s = re.sub(r'\bvertical:\s*5(?=[,)])', 'vertical: AppSpacing.xs', s)
    io.open(yol, 'w', encoding='utf-8', newline='').write(s)

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
        if not re.search(r'(EdgeInsets\.all\([56]\)|vertical:\s*[56](\.0)?\b)', s):
            continue
        once = s
        duzenle(yol, s)
        s2 = io.open(yol, encoding='utf-8', newline='').read()
        n = len(re.findall(r'AppSpacing\.', s2)) - len(re.findall(r'AppSpacing\.', once))
        toplam += n
        print('  %-30s +%d' % (ad, n))
print('toplam %d mikro deger tokena baglandi' % toplam)
