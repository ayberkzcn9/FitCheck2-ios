import io, os

kok = r'D:\indirilenler\Yeni klasor43\lib'

def bul(ad):
    for dizin, _, dosyalar in os.walk(kok):
        if ad in dosyalar:
            return os.path.join(dizin, ad)
    raise SystemExit('dosya yok: ' + ad)

def duzenle(ad, degisimler):
    yol = bul(ad)
    s = io.open(yol, encoding='utf-8', newline='').read()
    nl = '\r\n' if '\r\n' in s else '\n'
    for eski, yeni, beklenen in degisimler:
        eski = eski.replace('\n', nl)
        yeni = yeni.replace('\n', nl)
        n = s.count(eski)
        if n != beklenen:
            raise SystemExit('%s: %d eslesme (beklenen %d): %s' % (ad, n, beklenen, eski[:60]))
        s = s.replace(eski, yeni)
    io.open(yol, 'w', encoding='utf-8', newline='').write(s)
    print('ok', ad, len(degisimler))

# Ana sekme sayfalarında yatay boşluk 20 pt (Bugün/Dolap/Profil/Düello ile aynı).
duzenle('stil_gunlugu_ekrani.dart', [
    ('padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),', 'padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),', 2),
    ('padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),', 'padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),', 1),
])
duzenle('seyahat_ekrani.dart', [
    ('padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),', 'padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),', 1),
])

# Dolap kartı: Bugün kutularıyla aynı köşe yarıçapı (16).
duzenle('gardirobum_ekrani.dart', [
    ("""          color: colors.surfaceContainerLow,
          borderRadius: AppRadius.xxlRadius,
          border: Border.all(
            color: colors.outlineVariant,""",
     """          color: colors.surfaceContainerLow,
          borderRadius: AppRadius.lgRadius,
          border: Border.all(
            color: colors.outlineVariant,""", 1),
    ('child: ClipRRect(\n          borderRadius: BorderRadius.circular(24),',
     'child: ClipRRect(\n          borderRadius: BorderRadius.circular(16),', 1),
])

# Düello kahraman kartı: gölge daha yumuşak, alttaki açık katman görünmesin.
duzenle('kombin_duellosu_ekrani.dart', [
    ("""                  color: colors.primary.withValues(alpha: 0.25),
                  blurRadius: 24,
                  offset: const Offset(0, 10),""",
     """                  color: colors.primary.withValues(alpha: 0.18),
                  blurRadius: 24,
                  offset: const Offset(0, 6),""", 1),
])
