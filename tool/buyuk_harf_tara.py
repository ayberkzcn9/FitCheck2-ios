import io, re, sys
sys.stdout.reconfigure(encoding='utf-8', errors='replace')

s = io.open(r'D:\indirilenler\Yeni klasor43\lib\l10n\app_tr.arb', encoding='utf-8').read()

print('=== TAMAMEN BUYUK HARFLE YAZILMIS degerler (app_tr.arb)')
n = 0
for m in re.finditer(r'"([^"]+)":\s*"([^"]*)"', s):
    k, v = m.group(1), m.group(2)
    if not v:
        continue
    harf = re.sub(r'[^A-Za-z]', '', v)
    if len(harf) >= 3 and harf.isupper():
        print('  %-36s %s' % (k, v[:55]))
        n += 1
print('toplam:', n)

print()
print('=== gunluk kombin ile ilgili anahtarlar')
for m in re.finditer(r'"(gunlukKombin[^"]*|zarAtKaristir|yenidenZarAt|stilGunluguGunluk[^"]*)":\s*"([^"]*)"', s):
    print('  %-36s %s' % (m.group(1), m.group(2)[:60]))
