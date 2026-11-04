import io, os, sys
sys.stdout.reconfigure(encoding='utf-8', errors='replace')

KOK = r'D:\indirilenler\Yeni klasor43\lib'

# Başlık hizalaması: uygulamada standart sola hizalı (9 ekran). Bu üç ekran
# ortalı kalmıştı; aynı standarda getiriliyor.
dosyalar = ['ayarlar_ekrani.dart', 'dolaptan_kombin_ekrani.dart', 'kendi_kombinim_ekrani.dart']

for ad in dosyalar:
    for dizin, _, adlar in os.walk(KOK):
        if ad in adlar:
            yol = os.path.join(dizin, ad)
            break
    else:
        print('BULUNAMADI:', ad)
        continue
    s = io.open(yol, encoding='utf-8', newline='').read()
    n = s.count('centerTitle: true,')
    s = s.replace('centerTitle: true,', 'centerTitle: false,')
    io.open(yol, 'w', encoding='utf-8', newline='').write(s)
    print('%s: %d baslik sola hizalandi' % (ad, n))
