import io, os

kok = r'D:\indirilenler\Yeni klasor43\lib'

def bul(ad):
    for dizin, _, dosyalar in os.walk(kok):
        if ad in dosyalar:
            return os.path.join(dizin, ad)
    raise SystemExit('dosya yok: ' + ad)

degisimler = [
    ('ana_ekran.dart', 'Colors.amber[700]', 'AppAccents.warning'),
    ('ana_ekran.dart', 'Colors.amber[800]', 'AppAccents.warning'),
    ('ana_ekran.dart', 'Colors.amber.withValues', 'AppAccents.warning.withValues'),
    ('ana_ekran.dart', 'Colors.amber', 'AppAccents.warning'),
    ('ana_ekran_dialoglar.dart', 'Colors.amber[700]', 'AppAccents.warning'),
    ('ana_ekran_dialoglar.dart', 'Colors.orange', 'AppAccents.warning'),
    ('ana_ekran_dialoglar.dart', 'Colors.green', 'AppAccents.primary'),
    ('bildirim_servisi.dart', 'Colors.orange', 'AppAccents.warning'),
    ('haftalik_dialoglar.dart', 'Colors.orange', 'AppAccents.warning'),
    ('gunluk_kombin_ekrani.dart', 'Colors.green', 'AppAccents.primary'),
    ('gunluk_kombin_ekrani.dart', 'Color(0xFF22C55E)', 'AppAccents.primary'),
    ('gunluk_kombin_ekrani.dart', 'Colors.grey.shade700', 'Color(0xFF4A4F49)'),
    ('dolaptan_kombin_ekrani.dart', 'Colors.grey.shade700', 'Color(0xFF4A4F49)'),
    ('kendi_kombinim_ekrani.dart', 'Colors.green', 'AppAccents.primary'),
    ('gardirobum_ekrani.dart', 'Color(0xFFE9D5FF)', 'AppTints.successBg'),
    ('gun_secici.dart', 'Colors.green.shade100', 'AppTints.successBg'),
    ('gun_secici.dart', 'Colors.green.shade900', 'AppAccents.primary'),
    ('gun_secici.dart', 'Colors.green.withValues', 'AppAccents.primary.withValues'),
    ('gun_secici.dart', 'Colors.green', 'AppAccents.primary'),
]

for ad, eski, yeni in degisimler:
    yol = bul(ad)
    s = io.open(yol, encoding='utf-8', newline='').read()
    n = s.count(eski)
    if n == 0:
        print('YOK:', ad, eski)
        continue
    s = s.replace(eski, yeni)
    io.open(yol, 'w', encoding='utf-8', newline='').write(s)
    print('%d x %s: %s -> %s' % (n, ad, eski, yeni))
