import io
p = r'D:\indirilenler\Yeni klasor43\lib\screens\profil_analiz_ekrani.dart'
s = io.open(p, encoding='utf-8', newline='').read()
nl = '\r\n' if '\r\n' in s else '\n'

def r(eski, yeni):
    global s
    eski = eski.replace('\n', nl)
    yeni = yeni.replace('\n', nl)
    if eski not in s:
        raise SystemExit('bulunamadi: ' + eski[:60])
    s = s.replace(eski, yeni, 1)

r("""                      bgRenk: const Color(0xFFFFEDD5),
                      ikonRenk: const Color(0xFFEA580C),""",
  """                      bgRenk: colors.tertiaryContainer,
                      ikonRenk: colors.tertiary,""")
r("""                    bgRenk: const Color(0xFFE0F2FE),
                    ikonRenk: const Color(0xFF0284C7),""",
  """                    bgRenk: colors.primaryContainer,
                    ikonRenk: colors.primary,""")
r("""                      bgRenk: AppMiscColors.lightPurpleBg,
                      ikonRenk: const Color(0xFF7C3AED),""",
  """                      bgRenk: colors.primaryContainer,
                      ikonRenk: colors.primary,""")
r("""                      bgRenk: const Color(0xFFD1FAE5),
                      ikonRenk: AppAccents.success,""",
  """                      bgRenk: colors.primaryContainer,
                      ikonRenk: colors.primary,""")
r("""                      iconColor: AppAccents.info,""",
  """                      iconColor: colors.primary,""")
r("""                      iconColor: AppAccents.warning,
                      onTap: () => _favorileriAc(),""",
  """                      iconColor: colors.tertiary,
                      onTap: () => _favorileriAc(),""")
r("// IKILI OZET KARTLAR (Mor & Zümrüt Yeşili)", "// IKILI OZET KARTLAR (marka zümrütü)")
r("// IKILI ISTATISTIK KUTULARI (Kraliyet Mavisi & Altın Sarısı)",
  "// IKILI ISTATISTIK KUTULARI (zümrüt & altın)")
io.open(p, 'w', encoding='utf-8', newline='').write(s)
print('ok')
