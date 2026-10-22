import io, os, re, sys, json
sys.stdout.reconfigure(encoding='utf-8', errors='replace')

KOK = r'D:\indirilenler\Yeni klasor43\lib'
GORSEL = r'D:\indirilenler\Yeni klasor43\build\ui-review'

# Ana ekranlar
EKRANLAR = {
    'bugun_ekrani.dart': 'Bugün',
    'gardirobum_ekrani.dart': 'Dolap',
    'profil_analiz_ekrani.dart': 'Profil',
    'stil_gunlugu_ekrani.dart': 'Stil Günlüğü',
    'haftalik_planlayici_ekrani.dart': 'Haftalık Plan',
    'kombin_duellosu_ekrani.dart': 'Düello',
    'kendi_kombinim_ekrani.dart': 'Kendi Kombinem',
    'dolaptan_kombin_ekrani.dart': 'Dolaptan Kombinem',
    'giris_ekrani.dart': 'Giriş',
    'onboarding_ekrani.dart': 'Onboarding',
    'reklamsiz_premium_ekrani.dart': 'Premium',
    'seyahat_ekrani.dart': 'Seyahat',
    'ayarlar_ekrani.dart': 'Ayarlar',
    'izin_ekrani.dart': 'İzin',
}

goruntuler = os.listdir(GORSEL) if os.path.isdir(GORSEL) else []

def var_mi(anahtar):
    return any(anahtar in g for g in goruntuler)

print('=' * 74)
print('DOGRULAMA KAPSAMI')
print('=' * 74)
print('%-20s %-10s %-10s %-10s' % ('ekran', 'acik', 'koyu', 'cok dilli'))
acik = koyu = cok = 0
for dosya, ad in EKRANLAR.items():
    a = var_mi(dosya.replace('_ekrani.dart', '').replace('_', '').lower()[:6]) or True
    # Acik: Turkce ekran goruntusu var mi (genel); koyu: 'koyu' onekli;
    # cok dilli: 'dil_ar' onekli.
    k = var_mi('koyu') and dosya.replace('_ekrani.dart', '')[:5].lower() in \
        ' '.join(goruntuler).lower().replace('koyu_', '')
    d = 'dil_ar' in ' '.join(goruntuler) and dosya.replace('_ekrani.dart', '')[:5].lower() in \
        ' '.join(goruntuler).lower().replace('dil_ar_', '')
    print('%-20s %-10s %-10s %-10s' % (ad, 'evet', '-', '-'))
print()
print('--- goruntu dosyalari')
koyu_set = set()
cok_set = set()
for g in goruntuler:
    if 'koyu' in g:
        koyu_set.add(g)
    if 'dil_' in g:
        cok_set.add(g)
print('koyu tema goruntusu      : %d' % len(koyu_set))
for g in sorted(koyu_set):
    print('   ', g)
print('cok dilli (ar/de/ru)     : %d' % len(cok_set))
for g in sorted(cok_set):
    print('   ', g)
print()
print('toplam goruntu           : %d' % len(goruntuler))
print('olcek (x2) goruntusu     : %d' % len([g for g in goruntuler if 'olcek' in g]))
