import io

p = r'D:\indirilenler\Yeni klasor43\lib\screens\onboarding_ekrani.dart'
s = io.open(p, encoding='utf-8', newline='').read()
nl = '\r\n' if '\r\n' in s else '\n'


def r(a, b):
    global s
    a = a.replace('\n', nl)
    b = b.replace('\n', nl)
    if a not in s:
        raise SystemExit('bulunamadi: ' + a[:70])
    s = s.replace(a, b, 1)


# Sayfa paleti: marka ailesi (zümrüt, adaçayı, altın, su yeşili, kum).
r("""  List<Color> _getSayfaRenkPaleti(int index) {
    const paletler = [
      [AppAccents.celebration, AppPermissionColors.notification], // Hoş Geldin - Mor / Indigo
      [AppOnboardingColors.purple, Color(0xFFE056FD)], // Dolap - Eflatun / Pembe
      [
        AppOnboardingColors.orange,
        AppOnboardingColors.yellow
      ], // Hava Durumu - Sıcak Turuncu / Sarı
      [AppPermissionColors.location, Color(0xFF81ECEC)], // Yıkama - Turkuaz / Su Yeşili
      [AppPermissionColors.camera, Color(0xFFFF9FF3)], // Eksik Parça - Mercan / Roze
      [AppOnboardingColors.green, Color(0xFF10AC84)], // Analitik - Zümrüt Yeşili
      [AppOnboardingColors.deepOrange, Color(0xFFFFD32A)], // Stilist - Altın Sarı
      [AppAccents.celebration, AppPermissionColors.camera], // Giriş / Kayıt - Canlı Gradient
    ];
    return paletler[index % paletler.length];
  }""",
  """  // Sayfa paleti marka ailesinden seçilir: zümrüt, adaçayı, altın, su yeşili,
  // kum. Sayfalar arasında renk farkı kalsın ama uygulamanın kimliği bozulmasın.
  List<Color> _getSayfaRenkPaleti(int index) {
    const paletler = [
      [Color(0xFF0F5F4A), Color(0xFF2E8B6E)], // Hoş Geldin - derin zümrüt
      [Color(0xFF2E6E5E), Color(0xFF72B79C)], // Dolap - adaçayı
      [Color(0xFF9A6B1F), Color(0xFFD9A441)], // Hava Durumu - altın
      [Color(0xFF2F7E8F), Color(0xFF79C3CE)], // Yıkama - su yeşili
      [Color(0xFFA8743F), Color(0xFFDDB584)], // Eksik Parça - kum
      [Color(0xFF1F7A5A), Color(0xFF5CBA92)], // Analitik - açık zümrüt
      [Color(0xFFB98A2E), Color(0xFFEBD08A)], // Stilist - açık altın
      [Color(0xFF0F5F4A), Color(0xFF3E9E7E)], // Giriş / Kayıt - zümrüt geçişi
    ];
    return paletler[index % paletler.length];
  }""")

# Simge renkleri de aynı aileden.
r("""  Color _getIconColor(String iconName, ColorScheme colors) {
    switch (iconName) {
      case 'language':
        return AppAccents.celebration;
      case 'checkroom':
        return AppOnboardingColors.purple;
      case 'wb_sunny':
        return AppOnboardingColors.orange;
      case 'local_laundry_service':
        return AppPermissionColors.location;
      case 'shopping_bag':
        return AppPermissionColors.camera;
      case 'insights':
        return AppOnboardingColors.green;
      case 'auto_awesome':
        return AppOnboardingColors.deepOrange;
      default:
        return colors.primary;
    }
  }""",
  """  Color _getIconColor(String iconName, ColorScheme colors) {
    switch (iconName) {
      case 'language':
        return const Color(0xFF0F5F4A);
      case 'checkroom':
        return const Color(0xFF2E6E5E);
      case 'wb_sunny':
        return const Color(0xFF9A6B1F);
      case 'local_laundry_service':
        return const Color(0xFF2F7E8F);
      case 'shopping_bag':
        return const Color(0xFFA8743F);
      case 'insights':
        return const Color(0xFF1F7A5A);
      case 'auto_awesome':
        return const Color(0xFFB98A2E);
      default:
        return colors.primary;
    }
  }""")

# Sabit "antrasit" rengi koyu temada okunmuyordu; metin/simge rengi temadan gelsin.
r("""    final Color authGreenColor = AppAccents.successDark;
    final Color antrasitRenk = const Color(0xFF37474F);""",
  """    final Color authGreenColor = colors.primary;
    final Color antrasitRenk = colors.onSurface;""")

io.open(p, 'w', encoding='utf-8', newline='').write(s)
print('ok')
