import io, re, os, sys
sys.stdout.reconfigure(encoding='utf-8', errors='replace')

KOK = r'D:\indirilenler\Yeni klasor43\lib'

# ---------------------------------------------------------------------------
# 1) Token dosyasina gercek bir punto olcegi ekle.
# ---------------------------------------------------------------------------
tok_yol = os.path.join(KOK, 'theme', 'design_tokens.dart')
s = io.open(tok_yol, encoding='utf-8', newline='').read()

olcek = """class AppText {
  const AppText._();

  // ---------------------------------------------------------------------
  // PUNTO ÖLÇEĞİ
  // Ekranda kullanılabilecek her punto burada tanımlıdır. Erişilebilirlik
  // için en küçük punto 12'dir (WCAG AA ve okunabilirlik).
  // ---------------------------------------------------------------------

  /// 12 — mikro etiket (all-caps), alt bilgi
  static const double sizeMicro = 12;

  /// 12 — küçük etiket
  static const double sizeCaption = 12;

  /// 13 — gövde küçük
  static const double sizeSmall = 13;

  /// 14 — gövde küçük (en sık kullanılan)
  static const double sizeBodySmall = 14;

  /// 15 — gövde
  static const double sizeBody = 15;

  /// 16 — gövde büyük
  static const double sizeBodyLarge = 16;

  /// 18 — başlık küçük
  static const double sizeTitleSmall = 18;

  /// 20 — başlık
  static const double sizeTitle = 20;

  /// 22 — başlık büyük
  static const double sizeTitleLarge = 22;

  /// 24 — başlık en büyük
  static const double sizeHeadline = 24;

  /// 26 — display
  static const double sizeDisplay = 26;

  /// 32 — display büyük (rakamlar)
  static const double sizeDisplayLarge = 32;

  /// 42 — emoji boyutu
  static const double sizeEmoji = 42;

  /// 44 — dev rakam (takvim ayı)
  static const double sizeDisplayHuge = 44;

  // ---------------------------------------------------------------------
  // HAZIR METİN STİLLERİ
  // ---------------------------------------------------------------------
"""

eski_bas = s.index('class AppText {')
eski_son = s.index('\r\n}\r\n', eski_bas) + 4 if '\r\n}\r\n' in s else s.index('\n}\n', eski_bas) + 3
s = s[:eski_bas] + olcek + """  /// 12 — çok küçük etiket (all-caps)
  static const TextStyle labelMicro = TextStyle(
    fontSize: sizeMicro,
    fontWeight: FontWeight.w800,
    letterSpacing: 1.2,
  );

  /// 12 — küçük etiket
  static const TextStyle labelSmall = TextStyle(
    fontSize: sizeCaption,
    fontWeight: FontWeight.w600,
  );

  /// 13 — gövde küçük
  static const TextStyle bodySmall = TextStyle(
    fontSize: sizeSmall,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  /// 15 — gövde (varsayılan)
  static const TextStyle body = TextStyle(
    fontSize: sizeBody,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  /// 15 — vurgulu gövde
  static const TextStyle bodyStrong = TextStyle(
    fontSize: sizeBody,
    fontWeight: FontWeight.w700,
  );

  /// 18 — başlık küçük
  static const TextStyle titleSmall = TextStyle(
    fontSize: sizeTitleSmall,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.3,
  );

  /// 22 — başlık orta
  static const TextStyle title = TextStyle(
    fontSize: sizeTitleLarge,
    fontWeight: FontWeight.w900,
    letterSpacing: -0.5,
  );

  /// 26 — başlık büyük
  static const TextStyle headline = TextStyle(
    fontSize: sizeDisplay,
    fontWeight: FontWeight.w900,
    letterSpacing: -0.6,
  );
}
""" + s[eski_son:]
io.open(tok_yol, 'w', encoding='utf-8', newline='').write(s)
print('1) token olcegi yazildi')

# ---------------------------------------------------------------------------
# 2) Eski punto -> token eslemesi.
#    10 ve 11 (erisilebilirlik alt sinirinin altinda) 12'ye cikarilir.
# ---------------------------------------------------------------------------
esleme = {
    '10': 'sizeMicro',
    '11': 'sizeMicro',
    '12': 'sizeCaption',
    '13': 'sizeSmall',
    '14': 'sizeBodySmall',
    '15': 'sizeBody',
    '16': 'sizeBodyLarge',
    '17': 'sizeTitleSmall',
    '18': 'sizeTitleSmall',
    '20': 'sizeTitle',
    '22': 'sizeTitleLarge',
    '24': 'sizeHeadline',
    '26': 'sizeDisplay',
    '32': 'sizeDisplayLarge',
    '42': 'sizeEmoji',
    '44': 'sizeDisplayHuge',
}

def dosyalar():
    for dizin, _, adlar in os.walk(KOK):
        for ad in adlar:
            if not ad.endswith('.dart'):
                continue
            if ad in ('design_tokens.dart', 'app_tema.dart'):
                continue
            if 'app_localizations' in ad or 'kombin_oyunu' in ad or 'moda_renk' in ad:
                continue
            yield os.path.join(dizin, ad)

toplam = 0
for yol in dosyalar():
    s = io.open(yol, encoding='utf-8', newline='').read()
    if 'fontSize:' not in s:
        continue
    degisti = False
    for sayi, token in esleme.items():
        # fontSize: 14  /  fontSize: 14.0  /  fontSize: 14,
        desen = r'(fontSize:\s*)' + sayi + r'(\.0)?\b'
        yeni, n = re.subn(desen, lambda m: m.group(1) + 'AppText.' + token, s)
        if n:
            s = yeni
            degisti = True
            toplam += n
    if degisti and 'design_tokens.dart' not in s:
        # token dosyasini ice aktar
        m = re.search(r"^import '[^']+';\s*$", s, re.M)
        yol_imp = os.path.relpath(os.path.join(KOK, 'theme', 'design_tokens.dart'),
                                  os.path.dirname(yol)).replace('\\', '/')
        s = s[:m.start()] + "import '%s';" % yol_imp + '\n' + s[m.start():]
        print('   import eklendi:', os.path.basename(yol))
    if degisti:
        io.open(yol, 'w', encoding='utf-8', newline='').write(s)
print('2) %d punto tokena baglandi' % toplam)
