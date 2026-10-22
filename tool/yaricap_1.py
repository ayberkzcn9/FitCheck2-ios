import io, os, re, sys
sys.stdout.reconfigure(encoding='utf-8', errors='replace')

KOK = r'D:\indirilenler\Yeni klasor43\lib'

# --- 1) Tam yuvarlak (999) icin token ekle ---------------------------------
tok = os.path.join(KOK, 'theme', 'design_tokens.dart')
s = io.open(tok, encoding='utf-8', newline='').read()
if 'fullRadius' not in s:
    s = s.replace("""  /// 32 — modal
  static const double modal = 32;
""",
"""  /// 32 — modal
  static const double modal = 32;

  /// 4 — mikro (nokta, küçük işaret)
  static const double xs = 4;

  /// 999 — tam yuvarlak (daire, rozet)
  static const double full = 999;
""")
    s = s.replace("""  static const BorderRadius dialogRadius =
      BorderRadius.all(Radius.circular(dialog));""",
"""  static const BorderRadius dialogRadius =
      BorderRadius.all(Radius.circular(dialog));
  static const BorderRadius xsRadius = BorderRadius.all(Radius.circular(xs));
  static const BorderRadius fullRadius =
      BorderRadius.all(Radius.circular(full));""")
    io.open(tok, 'w', encoding='utf-8', newline='').write(s)
    print('1) xs/full token eklendi')

# --- 2) Tam eslesen yaricap degerlerini tokena bagla -----------------------
esleme = {
    '4': 'xsRadius',
    '8': 'smRadius',
    '12': 'mdRadius',
    '16': 'lgRadius',
    '20': 'xlRadius',
    '24': 'xxlRadius',
    '28': 'dialogRadius',
    '32': 'modalRadius',
    '999': 'fullRadius',
}

# modalRadius da eklenmeli
s = io.open(tok, encoding='utf-8', newline='').read()
if 'modalRadius' not in s:
    s = s.replace("""  static const BorderRadius xsRadius = BorderRadius.all(Radius.circular(xs));""",
"""  static const BorderRadius xsRadius = BorderRadius.all(Radius.circular(xs));
  static const BorderRadius modalRadius =
      BorderRadius.all(Radius.circular(modal));""")
    io.open(tok, 'w', encoding='utf-8', newline='').write(s)

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
        t = io.open(yol, encoding='utf-8', newline='').read()
        if 'BorderRadius.circular(' not in t:
            continue
        degisti = False
        for sayi, token in esleme.items():
            desen = r'BorderRadius\.circular\(' + sayi + r'\)'
            t, n = re.subn(desen, 'AppRadius.' + token, t)
            if n:
                degisti = True
                toplam += n
        if degisti:
            io.open(yol, 'w', encoding='utf-8', newline='').write(t)
print('2) %d yaricap tokena baglandi' % toplam)
