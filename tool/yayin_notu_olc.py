import io, re, sys
sys.stdout.reconfigure(encoding='utf-8', errors='replace')

p = r'D:\indirilenler\Yeni klasor43\SURUM_NOTU_1.0.30.md'
s = io.open(p, encoding='utf-8').read()

# Baslik + kod blogu ciftlerini topla
bloklar = re.findall(r'^## (.+?)\n\n```\n(.*?)\n```', s, re.S | re.M)
print('%-22s %6s %6s  %s' % ('dil', 'karakter', 'utf16', 'durum'))
for ad, metin in bloklar:
    cp = len(metin)
    u16 = len(metin.encode('utf-16-le')) // 2
    durum = 'TAMAM' if u16 <= 500 else 'SINIR ASIMI'
    print('%-22s %6d %6d  %s' % (ad, cp, u16, durum))
print()
print('toplam blok:', len(bloklar))
