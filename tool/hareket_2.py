import io, os, re, sys
sys.stdout.reconfigure(encoding='utf-8', errors='replace')

KOK = r'D:\indirilenler\Yeni klasor43\lib'

# 1) Sure kademelerini genislet
tok = os.path.join(KOK, 'theme', 'design_tokens.dart')
s = io.open(tok, encoding='utf-8', newline='').read()
if 'static const Duration normal' not in s:
    s = s.replace("""  /// 200 ms — küçük durum değişimi (seçim, vurgu)
  static const Duration kisa = Duration(milliseconds: 200);""",
"""  /// 150 ms — anlık geri bildirim (basma, rozet)
  static const Duration hizli = Duration(milliseconds: 150);

  /// 200 ms — küçük durum değişimi (seçim, vurgu)
  static const Duration kisa = Duration(milliseconds: 200);

  /// 300 ms — liste/kart geçişi
  static const Duration normal = Duration(milliseconds: 300);""")
    io.open(tok, 'w', encoding='utf-8', newline='').write(s)
    print('AppMotion: normal kademesi eklendi')

# 2) Sureleri tokena bagla (yalnizca 700 ms ve alti = arayuz animasyonu;
#    uzun sureler is mantik/gecikme oldugu icin dokunulmaz)
SURE = {
    '200': 'kisa', '220': 'kisa', '240': 'kisa', '250': 'kisa',
    '260': 'kisa', '280': 'kisa',
    '300': 'normal', '350': 'normal',
    '400': 'orta', '450': 'orta', '500': 'orta',
    '600': 'uzun', '700': 'uzun',
}

# 3) Egrileri tokena bagla
EGRI = {
    'easeOutCubic': 'giris',
    'easeInCubic': 'cikis',
    'easeInOutCubic': 'standart',
    'easeInOut': 'standart',
    'easeOut': 'standart',
    'fastOutSlowIn': 'standart',
    'easeOutBack': 'giris',
    'elasticOut': 'tepki',
}


def dosyalar():
    for dizin, _, adlar in os.walk(KOK):
        for ad in adlar:
            if not ad.endswith('.dart'):
                continue
            if ad.startswith('app_localizations') or 'kombin_oyunu' in ad or 'moda_renk' in ad:
                continue
            if ad == 'design_tokens.dart':
                continue
            yield os.path.join(dizin, ad)


toplam_sure = 0
toplam_egri = 0
for yol in dosyalar():
    s = io.open(yol, encoding='utf-8', newline='').read()
    once = s

    for ms, token in SURE.items():
        s = re.sub(r'Duration\(milliseconds:\s*' + ms + r'\)',
                   'AppMotion.' + token, s)

    for egri, token in EGRI.items():
        s = s.replace('Curves.' + egri, 'AppMotion.' + token)

    if s == once:
        continue

    if 'design_tokens.dart' not in s:
        m = re.search(r"^import '[^']+';\s*$", s, re.M)
        yol_imp = os.path.relpath(os.path.join(KOK, 'theme', 'design_tokens.dart'),
                                  os.path.dirname(yol)).replace('\\', '/')
        s = s[:m.start()] + "import '%s';" % yol_imp + '\n' + s[m.start():]

    io.open(yol, 'w', encoding='utf-8', newline='').write(s)
    ns = len(re.findall(r'AppMotion\.', s)) - len(re.findall(r'AppMotion\.', once))
    toplam_sure += ns
    print('  %-32s +%d' % (os.path.basename(yol), ns))

print('toplam %d animasyon referansı tokena bağlandı' % toplam_sure)
