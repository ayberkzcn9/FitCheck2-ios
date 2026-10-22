import io, os, re, json, sys
sys.stdout.reconfigure(encoding='utf-8', errors='replace')

KOK = r'D:\indirilenler\Yeni klasor43\lib'
GORSEL = r'D:\indirilenler\Yeni klasor43\build\ui-review'

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

def topla(desen):
    n = 0
    for yol in dosyalar():
        s = io.open(yol, encoding='utf-8', errors='replace').read()
        n += len(re.findall(desen, s))
    return n

olcumler = {}

# Renk
olcumler['eski_palet_kalinti'] = topla(r'Color\(0xFF(2E7D32|16A34A|8B5CF6|6C5CE7|2563EB|FF7675|00CEC9|A29BFE|1DD1A1|FF9F43|FECA57|F39C12|8E44AD|1B5E20|A78BFA|F472B6|F97316|10B981|15803D|E11D48)')
olcumler['tema_disi_material'] = topla(r'Colors\.(purple|indigo|deepPurple|teal|cyan|blue)\b')
olcumler['theme_renk_kullanimi'] = topla(r'colors\.primary|colorScheme\.primary|AppAccents\.primary')

# Tipografi
olcumler['punto_tokeni_kullanimi'] = topla(r'fontSize:\s*AppText\.')
olcumler['sabit_punto_kullanimi'] = topla(r'fontSize:\s*\d')
olcumler['kucuk_punto_10_11'] = topla(r'fontSize:\s*(1[01])\b')
olcumler['AppText_stil_kullanimi'] = topla(r'AppText\.(labelMicro|labelSmall|bodySmall|body|bodyStrong|titleSmall|title|headline)\b')

# Boşluk / yaricap
olcumler['AppSpacing_kullanimi'] = topla(r'AppSpacing\.')
olcumler['AppRadius_kullanimi'] = topla(r'AppRadius\.')
olcumler['sabit_yaricap'] = topla(r'BorderRadius\.circular\(\d+\)')

# Baslik hizalamasi
olcumler['centerTitle_true'] = topla(r'centerTitle:\s*true')
olcumler['appbar_toplam'] = topla(r'AppBar\(')

# Buton cesitliligi
olcumler['filled_button'] = topla(r'FilledButton')
olcumler['elevated_button'] = topla(r'ElevatedButton')
olcumler['outlined_button'] = topla(r'OutlinedButton')
olcumler['text_button'] = topla(r'TextButton')

# Bilgi butonu
olcumler['bilgi_butonu_kullanimi'] = topla(r'BilgiButonu\(')

olcumler['goruntu_sayi'] = len([f for f in os.listdir(GORSEL) if f.endswith('.png')]) if os.path.isdir(GORSEL) else 0

print(json.dumps(olcumler, ensure_ascii=False, indent=2))
