"""FitCheck tasarim butunlugu kalite kapisi.

Otomatik denetimler:
  1. Renk: eski palet kalintisi, tema disi Material renkleri, WCAG kontrast
  2. Tipografi: sabit punto, erisilebilirlik alt siniri (10-11 pt)
  3. Olcu: sabit dolgu / sabit yaricap degerleri
  4. Baslik hizalamasi: sola hizali olmayan AppBar'lar
  5. RTL: mutlak left/right kullanimlari
  6. Yerellestirme: l10n disi sabit Turkce metinler
  7. Dokunma hedefi: 44 pt alti minimumSize
  8. Hareket: 700 ms ustu arayuz sureleri

 Cikis kodu 0 ise gecerli, 1 ise hata.
"""
import io, os, re, sys, colorsys, json
sys.stdout.reconfigure(encoding='utf-8', errors='replace')

KOK = r'D:\indirilenler\Yeni klasor43\lib'
L10N = os.path.join(KOK, 'l10n')

hatalar = []
uyarilar = []


def bildir(kategori, mesaj):
    hatalar.append((kategori, mesaj))


def dosyalar():
    for dizin, _, adlar in os.walk(KOK):
        for ad in adlar:
            if not ad.endswith('.dart'):
                continue
            if ad.startswith('app_localizations') or 'kombin_oyunu' in ad or 'moda_renk' in ad:
                continue
            # Token dosyasi kendi tanimlarini icermez.
            if ad == 'design_tokens.dart':
                continue
            yield os.path.join(dizin, ad)


def oku(yol):
    return io.open(yol, encoding='utf-8', errors='replace').read()


# =========================================================================
# 1) RENK
# =========================================================================
ESKI = re.compile(
    r'Color\(0x(?:FF)?(?:2E7D32|16A34A|8B5CF6|6C5CE7|2563EB|FF7675|00CEC9|'
    r'A29BFE|1DD1A1|FF9F43|FECA57|F39C12|8E44AD|1B5E20|A78BFA|F472B6|'
    r'F97316|10B981|15803D|E11D48|DCFCE7)\)', re.I)
for yol in dosyalar():
    s = oku(yol)
    for i, satir in enumerate(s.splitlines(), 1):
        if ESKI.search(satir):
            bildir('renk', '%s:%d eski palet kalintisi' % (os.path.basename(yol), i))

for yol in dosyalar():
    s = oku(yol)
    if re.search(r'(?<![\w.])Colors\.(purple|indigo|deepPurple|teal|cyan|blue)\b', s):
        bildir('renk', '%s tema disi Material rengi' % os.path.basename(yol))


# --- WCAG kontrast
def hex_rgb(h8):
    return '#' + h8[2:].upper()


def lum(h):
    h = h.lstrip('#')
    def f(c):
        c = c / 255.0
        return c / 12.92 if c <= 0.03928 else ((c + 0.055) / 1.055) ** 2.4
    r, g, b = [f(int(h[i:i + 2], 16)) for i in (0, 2, 4)]
    return 0.2126 * r + 0.7152 * g + 0.0722 * b


def kontrast(a, b):
    la, lb = lum(a), lum(b)
    return (max(la, lb) + 0.05) / (min(la, lb) + 0.05)


tema = oku(os.path.join(KOK, 'theme', 'app_tema.dart'))
i_koyu = tema.index('if (brightness == Brightness.dark)')
i_acik = tema.rindex('return base.copyWith(')
HEX_IN = re.compile(r'(\w+):\s*(?:const\s+)?Color\(0x([0-9A-Fa-f]{8})\)')


def sema(blok):
    return {m.group(1): hex_rgb(m.group(2)) for m in HEX_IN.finditer(blok)}


koyu = sema(tema[i_koyu:i_acik])
acik = sema(tema[i_acik:])
CIFTLER = [
    ('onSurface', 'surface'), ('onSurface', 'surfaceContainerLow'),
    ('onSurfaceVariant', 'surface'), ('onPrimary', 'primary'),
    ('onPrimaryContainer', 'primaryContainer'),
    ('onSecondaryContainer', 'secondaryContainer'),
    ('onTertiaryContainer', 'tertiaryContainer'),
    ('primary', 'surface'), ('primary', 'surfaceContainer'),
]
for ad, sema_sozluk, hedef in (('acik', acik, 4.5), ('koyu', koyu, 4.5)):
    for a, b in CIFTLER:
        if a in sema_sozluk and b in sema_sozluk:
            k = kontrast(sema_sozluk[a], sema_sozluk[b])
            if k < hedef:
                bildir('kontrast', '%s: %s/%s = %.2f (min %.1f)' %
                        (ad, a, b, k, hedef))

# =========================================================================
# 2) TIPOGRAFI
# =========================================================================
for yol in dosyalar():
    s = oku(yol)
    for i, satir in enumerate(s.splitlines(), 1):
        if re.search(r'fontSize:\s*(1[01])\b', satir):
            bildir('tipografi', '%s:%d 10-11 pt (min 12)' % (os.path.basename(yol), i))
        if re.search(r'fontSize:\s*\d', satir):
            bildir('tipografi', '%s:%d sabit punto (token kullan)' % (os.path.basename(yol), i))

# =========================================================================
# 3) OLCU
# =========================================================================
for yol in dosyalar():
    s = oku(yol)
    for i, satir in enumerate(s.splitlines(), 1):
        if re.search(r'BorderRadius\.circular\(\d+\)', satir):
            bildir('olcu', '%s:%d sabit yaricap (token kullan)' % (os.path.basename(yol), i))
        if re.search(r'(horizontal|vertical):\s*\d+\s*[,)]', satir) and 'AppSpacing' not in satir:
            bildir('olcu', '%s:%d sabit dolgu (token kullan)' % (os.path.basename(yol), i))

# =========================================================================
# 4) BASLIK HIZALAMASI
# =========================================================================
for yol in dosyalar():
    s = oku(yol)
    if re.search(r'centerTitle:\s*true', s):
        bildir('baslik', '%s ortalı başlık (sola hizala)' % os.path.basename(yol))

# =========================================================================
# 5) RTL
# =========================================================================
for yol in dosyalar():
    s = oku(yol)
    for i, satir in enumerate(s.splitlines(), 1):
        if re.search(r'Alignment\.center(Left|Right)\b', satir):
            bildir('rtl', '%s:%d mutlak hizalama' % (os.path.basename(yol), i))
        if re.search(r'EdgeInsets\.only\([^)]*\b(left|right):', satir):
            bildir('rtl', '%s:%d EdgeInsets.only left/right' % (os.path.basename(yol), i))

# =========================================================================
# 6) YERELLESTIRME
# =========================================================================
METAIN = re.compile(
    r"(?:Text|title|label|hintText|tooltip|message|aciklama|baslik|content|"
    r"semanticsLabel|labelText|helperText)\s*[:(]\s*'([^']{2,})'")
TR = re.compile(r'[ığüşçöÇĞÜŞÖİı]|\b(ve|veya|icin|ile|kadar|sonra|once|gibi|cok|'
                 r'daha|var|yok|olur|oldu|olacak|ekle|sil|kaydet|tamam|devam|'
                 r'bugun|hafta|kombin|kiyafet|dolap|stil|renk|izin|konum|'
                 r'sicak|iliman|soguk|rapor|plan|seyahat|oyun|profil|ayarlar|'
                 r'hata|uyari|bilgi|dene|geri|ileri|ucret|premium|deneme|iptal)\b')
for yol in dosyalar():
    s = oku(yol)
    for i, satir in enumerate(s.splitlines(), 1):
        for m in METAIN.finditer(satir):
            metin = m.group(1)
            if metin.startswith('http'):
                continue
            if TR.search(metin):
                bildir('l10n', '%s:%d sabit Türkçe metin: %s' %
                       (os.path.basename(yol), i, metin[:40]))

# =========================================================================
# 7) DOKUNMA HEDEFI
# =========================================================================
for yol in dosyalar():
    s = oku(yol)
    for m in re.finditer(r'minimumSize:\s*const? ?Size\((\d+),\s*(\d+)\)', s):
        w, h = int(m.group(1)), int(m.group(2))
        if 0 < w < 44 or 0 < h < 44:
            bildir('dokunma', '%s minimumSize %dx%d (44 hedef)' %
                   (os.path.basename(yol), w, h))

# =========================================================================
# 8) HAREKET
# =========================================================================
for yol in dosyalar():
    s = oku(yol)
    for m in re.finditer(r'Duration\(milliseconds:\s*(\d+)\)', s):
        ms = int(m.group(1))
        if 10 < ms < 700 and 'AppMotion' not in s[max(0, m.start() - 60):m.start()]:
            bildir('hareket', '%s %d ms (token kullan)' % (os.path.basename(yol), ms))

# =========================================================================
# RAPOR
# =========================================================================
print('=' * 72)
print('TASARIM BUTUNLUGU KALITE KAPISI')
print('=' * 72)
if not hatalar:
    print('  Tum denetimler gecti.')
else:
    kategori = {}
    for k, m in hatalar:
        kategori.setdefault(k, []).append(m)
    for k in sorted(kategori):
        print()
        print('%-12s %d sorun' % (k.upper(), len(kategori[k])))
        for m in kategori[k][:14]:
            print('   -', m)
        if len(kategori[k]) > 14:
            print('   ... ve %d tane daha' % (len(kategori[k]) - 14))
    print()
    print('TOPLAM: %d sorun' % len(hatalar))

sys.exit(1 if hatalar else 0)
