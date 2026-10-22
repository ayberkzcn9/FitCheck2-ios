import io, re

yol = r'D:\indirilenler\Yeni klasor43\lib\theme\design_tokens.dart'
s = io.open(yol, encoding='utf-8', newline='').read()

# Sınıf -> {alan: yeni değer}. Anlam taşıyan error (kırmızı) ve warning (amber)
# bilerek korunuyor. Geri kalan her şey marka ailesinde: zümrüt, adaçayı,
# su yeşili, kum, altın.
harita = {
    'AppAccents': {
        'success': '1F7A5A', 'successDark': '0F5F4A', 'successDeep': '2E6E5E',
        'styleist': '2E6E5E', 'celebration': '0F5F4A', 'info': '2F7E8F',
    },
    'AppPermissionColors': {
        'camera': 'A8743F', 'location': '2F7E8F', 'notification': 'D9A441',
    },
    'AppOnboardingColors': {
        'green': '1F7A5A', 'orange': 'B98A2E', 'yellow': 'D9A441',
        'deepOrange': '9A6B1F', 'purple': '2E6E5E', 'darkGreen': '0F5F4A',
    },
    'AppMiscColors': {
        'purple': '2E6E5E', 'lightPurpleBg': 'E6EFEA', 'lightPurpleBorder': 'C9DDD3',
        'rose': 'B3413A', 'roseBg': 'F6E3E0', 'pink': 'A8743F', 'orangeLight': 'B98A2E',
        'greenLight': '1F7A5A', 'greenPale': 'DDEEE6', 'greenDark': '0F5F4A',
        'styleistTextDark': '1F4A3E', 'styleistText': '2E5F50',
        'styleistTextDarkKoyu': 'DCEEE6', 'styleistTextKoyu': 'BFD9CD',
    },
    'AppStatusColors': {
        'wornFg': '1F5C48', 'wornFgDark': 'B4D9C8', 'wornBgDark': '14271F',
    },
    'AppTints': {
        'successBg': 'E3F0EA', 'successBorder': 'B4D9C8', 'successBgDark': '14271F',
        'styleistBg': 'F1F6F3', 'styleistBorder': 'D5E4DC',
        'styleistBgDark': '1E2A25', 'styleistBorderDark': '3A4C44',
    },
}

toplam = 0
for sinif, alanlar in harita.items():
    bas = s.index('class %s {' % sinif)
    son = s.find('\nclass ', bas + 10)
    if son == -1:
        son = len(s)
    blok = s[bas:son]
    for alan, hex_ in alanlar.items():
        desen = re.compile(r'(static const Color %s = Color\(0xFF)[0-9A-Fa-f]{6}(\);)' % alan)
        blok, n = desen.subn(lambda m: m.group(1) + hex_.upper() + m.group(2), blok)
        if n != 1:
            raise SystemExit('bulunamadi: %s.%s (%d)' % (sinif, alan, n))
        toplam += 1
    s = s[:bas] + blok + s[son:]

io.open(yol, 'w', encoding='utf-8', newline='').write(s)
print('token guncellendi:', toplam)
