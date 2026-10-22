import io, os, re, sys
sys.stdout.reconfigure(encoding='utf-8', errors='replace')

KOK = r'D:\indirilenler\Yeni klasor43\lib'

# Kullaniciya gosterilen sabit metinler (l10n disi).
# Once hepsini topla, sonra Turkce olup olmadiklarina bak.
DESEN = re.compile(r"""(?:Text|title|label|hintText|tooltip|message|aciklama|baslik|content|semanticsLabel|labelText|helperText)\s*[:(]\s*'([^']{2,})'""")
DIGER = re.compile(r"""'([^']{6,})'""")

TR = re.compile(r'[ığüşçöÇĞÜŞÖİı]|\b(ve|veya|icin|ile|olarak|kadar|sonra|once|gibi|'
                 r'cok|az|daha|en|var|yok|olur|oldu|olacak|ekle|sil|kaydet|'
                 r'giydim|giydildi|tamam|devam|bugun|hafta|ay|gun|kombin|'
                 r'kiyafet|dolap|gardirob|stil|renk|beden|foto|video|kamera|'
                 r'izin|konum|hava|sicak|iliman|soguk|stilist|rapor|plan|'
                 r'seyahat|duello|oyun|profil|ayarlar|hata|uyari|bilgi|'
                 r'dene|geri|ileri|adet|tutar|ucret|abonelik|premium|deneme|'
                 r'iptal|sadece|ancak|fakat|aciklama|baslik)\b')

toplam = []
for dizin, _, adlar in os.walk(KOK):
    for ad in adlar:
        if not ad.endswith('.dart') or ad.startswith('app_localizations'):
            continue
        if 'kombin_oyunu' in ad or 'moda_renk' in ad:
            continue
        yol = os.path.join(dizin, ad)
        s = io.open(yol, encoding='utf-8', errors='replace').read()
        for i, satir in enumerate(s.splitlines(), 1):
            for m in DESEN.finditer(satir):
                metin = m.group(1).strip()
                if not metin or metin.startswith('http'):
                    continue
                turkce = bool(TR.search(metin))
                toplam.append((ad, i, metin, turkce))

turkce_list = [t for t in toplam if t[3]]
print('L10N disi kullanici metni: %d (turkce olani %d)' % (len(toplam), len(turkce_list)))
print()
for ad, i, m, _ in turkce_list:
    print('  %-32s :%-5d %s' % (ad, i, m[:70]))
