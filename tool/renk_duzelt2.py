import io

def duzenle(yol, degisimler):
    s = io.open(yol, encoding='utf-8', newline='').read()
    nl = '\r\n' if '\r\n' in s else '\n'
    for eski, yeni in degisimler:
        eski = eski.replace('\n', nl)
        yeni = yeni.replace('\n', nl)
        if eski not in s:
            raise SystemExit('bulunamadi: ' + eski[:70])
        s = s.replace(eski, yeni, 1)
    io.open(yol, 'w', encoding='utf-8', newline='').write(s)

duzenle(r'D:\indirilenler\Yeni klasor43\lib\screens\gardirobum_ekrani.dart', [
    ("                selectedColor: colors.onSurface,\n",
     "                selectedColor: colors.primary,\n"),
    ("                  color: secili ? colors.surface : colors.onSurfaceVariant,\n",
     "                  color: secili ? colors.onPrimary : colors.onSurfaceVariant,\n"),
    ("""                                      : colors.onSurface,
                                  foregroundColor: item.sepetteMi
                                      ? colors.onErrorContainer
                                      : colors.surface,""",
     """                                      : colors.primary,
                                  foregroundColor: item.sepetteMi
                                      ? colors.onErrorContainer
                                      : colors.onPrimary,"""),
    ("""                                          : colors.surface,
                                    ),
                                    const SizedBox(width: 4),""",
     """                                          : colors.onPrimary,
                                    ),
                                    const SizedBox(width: 4),"""),
    ("""                                                : colors.surface,
                                          ),""",
     """                                                : colors.onPrimary,
                                          ),"""),
])

duzenle(r'D:\indirilenler\Yeni klasor43\lib\screens\kombin_duellosu_ekrani.dart', [
    ("""                  Color.lerp(colors.primary, colors.tertiary, 0.45) ??
                      colors.primary,""",
     """                  Color.lerp(colors.primary, colors.onPrimaryContainer, 0.4) ??
                      colors.primary,"""),
])

duzenle(r'D:\indirilenler\Yeni klasor43\lib\screens\profil_analiz_ekrani.dart', [
    ("""                          bgRenk: analiz.sepette == 0
                              ? AppMiscColors.greenPale
                              : AppMiscColors.roseBg,
                          ikonRenk: analiz.sepette == 0
                              ? AppAccents.success
                              : AppMiscColors.rose,""",
     """                          bgRenk: analiz.sepette == 0
                              ? colors.primaryContainer
                              : AppMiscColors.roseBg,
                          ikonRenk: analiz.sepette == 0
                              ? colors.primary
                              : AppMiscColors.rose,"""),
    ("""                                  color: analiz.sepette == 0
                                      ? AppAccents.success
                                      : AppMiscColors.rose,""",
     """                                  color: analiz.sepette == 0
                                      ? colors.primary
                                      : AppMiscColors.rose,"""),
])
print('ok')
