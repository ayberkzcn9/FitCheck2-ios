// FitCheck Design System — Token'lar
//
// Tek merkezden yönetilen tasarım değerleri:
//   • Renkler (semantik)
//   • Boşluklar (spacing)
//   • Yarıçaplar (radius)
//   • Tipografi (metin stilleri)
//   • Gölgeler
//
// Kullanım: `FitCheckTokens.spacing.lg`, `FitCheckTokens.colors.success`

import 'package:flutter/material.dart';

// ===========================================================================
// SPACING — 4'ün katları (tutarlı boşluk ölçeği)
// ===========================================================================
class AppSpacing {
  const AppSpacing._();

  /// 4
  static const double xs = 4;

  /// 8
  static const double sm = 8;

  /// 12
  static const double md = 12;

  /// 16
  static const double lg = 16;

  /// 20
  static const double xl = 20;

  /// 24
  static const double xxl = 24;

  /// 32
  static const double xxxl = 32;

  /// Yatay sayfa kenarı (varsayılan)
  static const EdgeInsets sayfaKenari = EdgeInsets.symmetric(horizontal: lg);

  /// Kart içi boşluk
  static const EdgeInsets kartIci = EdgeInsets.all(xl);
}

// ===========================================================================
// RADIUS — Yuvarlak köşe değerleri
// ===========================================================================
class AppRadius {
  const AppRadius._();

  /// 8 — küçük (chip, badge)
  static const double sm = 8;

  /// 12 — buton, input
  static const double md = 12;

  /// 16 — kart küçük
  static const double lg = 16;

  /// 20 — kart orta
  static const double xl = 20;

  /// 24 — kart büyük
  static const double xxl = 24;

  /// 28 — diyalog
  static const double dialog = 28;

  /// 32 — modal
  static const double modal = 32;

  // BorderRadius yardımcıları
  static const BorderRadius smRadius = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius mdRadius = BorderRadius.all(Radius.circular(md));
  static const BorderRadius lgRadius = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius xlRadius = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius xxlRadius = BorderRadius.all(Radius.circular(xxl));
  static const BorderRadius dialogRadius =
      BorderRadius.all(Radius.circular(dialog));
}

// ===========================================================================
// TİPOGRAFİ — Metin stilleri (az sayıda, tutarlı)
// ===========================================================================
class AppText {
  const AppText._();

  /// 11 — çok küçük etiket (all-caps)
  static const TextStyle labelMicro = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w800,
    letterSpacing: 1.2,
  );

  /// 12 — küçük etiket
  static const TextStyle labelSmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
  );

  /// 13 — gövde küçük
  static const TextStyle bodySmall = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  /// 15 — gövde (varsayılan)
  static const TextStyle body = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  /// 16 — vurgulu gövde
  static const TextStyle bodyStrong = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
  );

  /// 20 — başlık küçük
  static const TextStyle titleSmall = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.3,
  );

  /// 24 — başlık orta
  static const TextStyle title = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w900,
    letterSpacing: -0.5,
  );

  /// 28 — başlık büyük
  static const TextStyle headline = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w900,
    letterSpacing: -0.6,
  );
}

// ===========================================================================
// AKSAN RENKLERİ — Sadece 2 ana aksan (sadeleştirme)
// ===========================================================================
class AppAccents {
  const AppAccents._();

  /// Ana aksan — marka rengi (koyu gri/siyah)
  static const Color primary = Color(0xFF3B3B3B);

  /// İkincil aksan — başarı/onay (yeşil)
  static const Color success = Color(0xFF16A34A);

  /// Koyu yeşil (buton metni, vurgular)
  static const Color successDark = Color(0xFF2E7D32);

  /// Uyarı (amber)
  static const Color warning = Color(0xFFD97706);

  /// Hata (kırmızı)
  static const Color error = Color(0xFFDC2626);

  /// Bilgi / stilist (mor — az kullanılır)
  static const Color styleist = Color(0xFF8B5CF6);

  /// Onboarding/kutlama mor (canlı)
  static const Color celebration = Color(0xFF6C5CE7);

  /// Mavi vurgu (bilgi, uyum puanı)
  static const Color info = Color(0xFF2563EB);
}

// ===========================================================================
// İZİN EKRANI RENKLERİ — Faz kategorileri
// ===========================================================================
class AppPermissionColors {
  const AppPermissionColors._();

  static const Color camera = Color(0xFFFF7675);
  static const Color location = Color(0xFF00CEC9);
  static const Color notification = Color(0xFFA29BFE);
}

// ===========================================================================
// ONBOARDING RENKLERİ — Sayfa paletleri
// ===========================================================================
class AppOnboardingColors {
  const AppOnboardingColors._();

  static const Color green = Color(0xFF1DD1A1);
  static const Color orange = Color(0xFFFF9F43);
  static const Color yellow = Color(0xFFFECA57);
  static const Color deepOrange = Color(0xFFF39C12);
  static const Color purple = Color(0xFF8E44AD);
  static const Color darkGreen = Color(0xFF1B5E20);
}

// ===========================================================================
// YARDIMCI RENKLER
// ===========================================================================
class AppMiscColors {
  const AppMiscColors._();

  static const Color purple = Color(0xFFA78BFA);
  static const Color lightPurpleBg = Color(0xFFF3E8FF);
  static const Color lightPurpleBorder = Color(0xFFDDD6FE);
  static const Color rose = Color(0xFFE11D48);
  static const Color roseBg = Color(0xFFFFE4E6);
  static const Color pink = Color(0xFFF472B6);
  static const Color orangeLight = Color(0xFFF97316);
  static const Color greenLight = Color(0xFF10B981);
  static const Color greenPale = Color(0xFFDCFCE7);
  static const Color greenDark = Color(0xFF15803D);

  // Amber metin tonları (AI öneri kutusu)
  static const Color amberText = Color(0xFFB26A00);
  static const Color amberTextDark = Color(0xFF8A5300);
  static const Color amberTextBody = Color(0xFF6B4A20);

  // Stilist kutusu metin tonları
  static const Color styleistTextDark = Color(0xFF4A3B5A);
  static const Color styleistText = Color(0xFF6B5382);

  // Dark mode metin tonları (açık renkli, koyu arka plan üstünde okunur)
  static const Color styleistTextDarkKoyu = Color(0xFFE8DDF5);
  static const Color styleistTextKoyu = Color(0xFFC9B8E0);

  /// Stilist kutusu ana metni (dark mode'a duyarlı).
  static Color styleistTextDinamik(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? styleistTextDarkKoyu
          : styleistTextDark;

  /// Stilist kutusu ikincil metni (dark mode'a duyarlı).
  static Color styleistAltTextDinamik(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? styleistTextKoyu
          : styleistText;

  // Google marka renkleri
  static const Color googleBlue = Color(0xFF4285F4);
}

// ===========================================================================
// ROZET RENKLERİ — Favori ve "giydim" durumları (dark mode'a duyarlı)
// ===========================================================================
class AppStatusColors {
  const AppStatusColors._();

  // Favori (amber)
  static const Color favoriteBg = Color(0xFFFFF8E1);
  static const Color favoriteFg = Color(0xFF8A5300);
  static const Color favoriteBgDark = Color(0xFF3D3014);
  static const Color favoriteFgDark = Color(0xFFFFD699);

  // Giydim (yeşil)
  static const Color wornBg = Color(0xFFDCFCE7);
  static const Color wornFg = Color(0xFF166534);
  static const Color wornBgDark = Color(0xFF17301C);
  static const Color wornFgDark = Color(0xFFA5D6A7);

  static Color favoriteBgDinamik(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? favoriteBgDark
          : favoriteBg;

  static Color favoriteFgDinamik(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? favoriteFgDark
          : favoriteFg;

  static Color wornBgDinamik(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? wornBgDark : wornBg;

  static Color wornFgDinamik(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? wornFgDark : wornFg;
}

// ===========================================================================
// DURUM RENKLERİ — Açık tonlar (kart arka planları için)
// ===========================================================================
class AppTints {
  const AppTints._();

  static const Color successBg = Color(0xFFE8F5E9);
  static const Color warningBg = Color(0xFFFFF8F0);
  static const Color errorBg = Color(0xFFFEE2E2);
  static const Color styleistBg = Color(0xFFF7F2FA);

  static const Color successBorder = Color(0xFFA5D6A7);
  static const Color warningBorder = Color(0xFFEAD7BE);
  static const Color styleistBorder = Color(0xFFE8DEF8);

  // ---- Dark-mode uyumlu varyantlar ----
  static const Color styleistBgDark = Color(0xFF2A2438);
  static const Color styleistBorderDark = Color(0xFF4A3D63);
  static const Color warningBgDark = Color(0xFF2E2416);
  static const Color warningBorderDark = Color(0xFF5A4420);
  static const Color successBgDark = Color(0xFF1B2E1E);
  static const Color errorBgDark = Color(0xFF3A1F1F);

  /// Stilist kutusu arka planı (dark mode'a duyarlı).
  static Color styleistBgDinamik(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? styleistBgDark
          : styleistBg;

  /// Stilist kutusu sınırı (dark mode'a duyarlı).
  static Color styleistBorderDinamik(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? styleistBorderDark
          : styleistBorder;

  /// Uyarı kutusu arka planı (dark mode'a duyarlı).
  static Color warningBgDinamik(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? warningBgDark
          : warningBg;

  /// Uyarı kutusu sınırı (dark mode'a duyarlı).
  static Color warningBorderDinamik(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? warningBorderDark
          : warningBorder;
}
