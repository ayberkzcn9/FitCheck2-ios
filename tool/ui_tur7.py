import io, re

def duzenle(yol, degisimler):
    s = io.open(yol, encoding='utf-8', newline='').read()
    for eski, yeni in degisimler:
        n = s.count(eski)
        if n == 0:
            raise SystemExit('bulunamadi: ' + eski)
        s = s.replace(eski, yeni)
        print(n, eski, '->', yeni)
    io.open(yol, 'w', encoding='utf-8', newline='').write(s)

izin = r'D:\indirilenler\Yeni klasor43\lib\screens\izin_ekrani.dart'
s = io.open(izin, encoding='utf-8', newline='').read()
nl = '\r\n' if '\r\n' in s else '\n'
sabitler = (
    "// İzin ekranı marka paletinde: zümrüt, su yeşili, kum, altın.\n"
    "const Color _izinMarka = Color(0xFF0F5F4A);\n"
    "const Color _izinMarkaAcik = Color(0xFF2E8B6E);\n"
    "const Color _izinSu = Color(0xFF2F7E8F);\n"
    "const Color _izinKum = Color(0xFFA8743F);\n"
    "const Color _izinAltin = Color(0xFFD9A441);\n"
).replace('\n', nl)
i = s.index('class IzinDiyalogu')
s = s[:i] + sabitler + nl + s[i:]
io.open(izin, 'w', encoding='utf-8', newline='').write(s)

duzenle(izin, [
    ('AppAccents.celebration.withValues(alpha: 0.3)', '_izinMarka.withValues(alpha: 0.3)'),
    ('AppPermissionColors.camera.withValues(alpha: 0.15)', '_izinKum.withValues(alpha: 0.15)'),
    ('color: AppPermissionColors.camera,', 'color: _izinKum,'),
    ('colors: [AppAccents.celebration, AppPermissionColors.location],', 'colors: [_izinMarka, _izinSu],'),
    ('colors: [AppAccents.celebration, AppPermissionColors.notification],', 'colors: [_izinMarka, _izinAltin],'),
    ('accentColor: const Color(0xFF0984E3),', 'accentColor: _izinSu,'),
    ('accentColor: const Color(0xFFE84393),', 'accentColor: _izinKum,'),
    ('accentColor: AppAccents.celebration,', 'accentColor: _izinMarka,'),
])

ayar = r'D:\indirilenler\Yeni klasor43\lib\screens\ayarlar_ekrani.dart'
duzenle(ayar, [
    ('iconColor: AppMiscColors.greenLight,', 'iconColor: const Color(0xFF1F7A5A),'),
    ('iconColor: AppMiscColors.purple,', 'iconColor: const Color(0xFF2E6E5E),'),
    ('iconColor: AppMiscColors.pink,', 'iconColor: const Color(0xFFA8743F),'),
    ('iconColor: AppMiscColors.orangeLight,', 'iconColor: const Color(0xFFB98A2E),'),
    ('iconColor: AppAccents.styleist,', 'iconColor: const Color(0xFF2E6E5E),'),
    ('iconColor: const Color(0xFF06B6D4),', 'iconColor: const Color(0xFF2F7E8F),'),
    ('iconColor: const Color(0xFF60A5FA),', 'iconColor: const Color(0xFF4F6B60),'),
])
print('ok')
