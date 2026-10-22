import io, os, re, sys
sys.stdout.reconfigure(encoding='utf-8', errors='replace')

KOK = r'D:\indirilenler\Yeni klasor43\lib'

# 1) AppRadius'a xxs (2) ekle
tok = os.path.join(KOK, 'theme', 'design_tokens.dart')
s = io.open(tok, encoding='utf-8', newline='').read()
if 'static const double xxs' not in s:
    s = s.replace("""  /// 4 — mikro (nokta, küçük işaret)
  static const double xs = 4;""",
"""  /// 2 — çok mikro (nokta göstergesi)
  static const double xxs = 2;

  /// 4 — mikro (nokta, küçük işaret)
  static const double xs = 4;""")
    s = s.replace("""  static const BorderRadius xsRadius = BorderRadius.all(Radius.circular(xs));""",
"""  static const BorderRadius xxsRadius = BorderRadius.all(Radius.circular(xxs));
  static const BorderRadius xsRadius = BorderRadius.all(Radius.circular(xs));""")
    io.open(tok, 'w', encoding='utf-8', newline='').write(s)
    print('AppRadius.xxs eklendi')

# 2) Kalan yaricap degerlerini olcege bagla
HARITA = {
    '2': 'xxsRadius', '3': 'xxsRadius',
    '5': 'xsRadius', '6': 'xsRadius',
    '10': 'mdRadius', '14': 'mdRadius', '18': 'lgRadius',
}

toplam = 0
for dizin, _, adlar in os.walk(KOK):
    for ad in adlar:
        if not ad.endswith('.dart') or ad == 'design_tokens.dart':
            continue
        if ad.startswith('app_localizations') or 'kombin_oyunu' in ad or 'moda_renk' in ad:
            continue
        yol = os.path.join(dizin, ad)
        t = io.open(yol, encoding='utf-8', newline='').read()
        once = t
        for sayi, token in HARITA.items():
            t = re.sub(r'BorderRadius\.circular\(' + sayi + r'\)', 'AppRadius.' + token, t)
        if t != once:
            io.open(yol, 'w', encoding='utf-8', newline='').write(t)
            n = len(re.findall(r'AppRadius\.', t)) - len(re.findall(r'AppRadius\.', once))
            toplam += n
            print('  %-32s +%d' % (ad, n))
print('toplam %d yaricap tokena baglandi' % toplam)

# 3) Dokunma hedefleri 44 px
for ad, eski in [('giris_ekrani.dart', 'minimumSize: const Size(0, 36),'),
                 ('ai_oneri_kutusu.dart', 'minimumSize: const Size(0, 32),')]:
    for dizin, _, adlar in os.walk(KOK):
        if ad in adlar:
            yol = os.path.join(dizin, ad)
            t = io.open(yol, encoding='utf-8', newline='').read()
            if eski in t:
                t = t.replace(eski, eski.replace('Size(0, 36)', 'Size(0, 44)')
                                       .replace('Size(0, 32)', 'Size(0, 44)'))
                io.open(yol, 'w', encoding='utf-8', newline='').write(t)
                print('dokunma hedefi 44: ' + ad)
            break

# 4) Kalite kapisi yanlis pozitiflerini duzelt
kap = r'D:\indirilenler\Yeni klasor43\tool\tasarim_kapisi.py'
k = io.open(kap, encoding='utf-8', newline='').read()
k = k.replace("r'Colors\\.(purple|indigo|deepPurple|teal|cyan|blue)\\b'",
              "r'(?<![\\w.])Colors\\.(purple|indigo|deepPurple|teal|cyan|blue)\\b'")
# Token dosyasi kendi tanimlarini icermez.
k = k.replace("""def dosyalar():
    for dizin, _, adlar in os.walk(KOK):
        for ad in adlar:
            if not ad.endswith('.dart'):
                continue
            if ad.startswith('app_localizations') or 'kombin_oyunu' in ad or 'moda_renk' in ad:
                continue
            yield os.path.join(dizin, ad)""",
"""def dosyalar():
    for dizin, _, adlar in os.walk(KOK):
        for ad in adlar:
            if not ad.endswith('.dart'):
                continue
            if ad.startswith('app_localizations') or 'kombin_oyunu' in ad or 'moda_renk' in ad:
                continue
            # Token dosyasi kendi tanimlarini icermez.
            if ad == 'design_tokens.dart':
                continue
            yield os.path.join(dizin, ad)""")
io.open(kap, 'w', encoding='utf-8', newline='').write(k)
print('kalite kapisi duzeltildi')
