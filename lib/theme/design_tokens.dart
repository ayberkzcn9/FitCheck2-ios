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
/// ANİMASYON — süre ve eğri ölçeği.
///
/// Material 3 hareket kurallarına göre üç kademe: kısa (200 ms), orta
/// (400 ms), uzun (600 ms). Eğriler de aynı mantıkla: ekrana girerken
/// yavaşlayan (decelerate), çıkarken hızlanan (accelerate), ekranda
/// kalırken standart.
class AppMotion {
  const AppMotion._();

  // Süreler
  /// 150 ms — anlık geri bildirim (basma, rozet)
  static const Duration hizli = Duration(milliseconds: 150);

  /// 200 ms — küçük durum değişimi (seçim, vurgu)
  static const Duration kisa = Duration(milliseconds: 200);

  /// 300 ms — liste/kart geçişi
  static const Duration normal = Duration(milliseconds: 300);

  /// 400 ms — kart/liste geçişi, panel açılışı
  static const Duration orta = Duration(milliseconds: 400);

  /// 600 ms — büyük geçiş (sayfa, açılır pencere)
  static const Duration uzun = Duration(milliseconds: 600);

  // Eğriler
  /// Ekrana girerken (yavaşlayan)
  static const Curve giris = Curves.easeOutCubic;

  /// Ekrandan çıkarken (hızlanan)
  static const Curve cikis = Curves.easeInCubic;

  /// Ekranda kalırken (standart)
  static const Curve standart = Curves.easeInOutCubic;

  /// Geri tepki (hafif aşma) — vurgu rozetleri
  static const Curve tepki = Curves.elasticOut;

  /// Geri tepki (yumuşak aşma) — kart açılışı
  static const Curve standartBack = Curves.easeOutBack;
}

class AppSpacing {
  const AppSpacing._();

  /// 2
  static const double xxs = 2;

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

  /// 4 — mikro (nokta, küçük işaret)
  static const double xs = 4;

  /// 2 — çok mikro (nokta göstergesi)
  static const double xxs = 2;

  /// 999 — tam yuvarlak (daire, rozet)
  static const double full = 999;

  // BorderRadius yardımcıları
  static const BorderRadius smRadius = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius mdRadius = BorderRadius.all(Radius.circular(md));
  static const BorderRadius lgRadius = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius xlRadius = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius xxlRadius = BorderRadius.all(Radius.circular(xxl));
  static const BorderRadius dialogRadius =
      BorderRadius.all(Radius.circular(dialog));
  static const BorderRadius modalRadius =
      BorderRadius.all(Radius.circular(modal));
  static const BorderRadius xxsRadius = BorderRadius.all(Radius.circular(xxs));
  static const BorderRadius xsRadius = BorderRadius.all(Radius.circular(xs));
  static const BorderRadius fullRadius =
      BorderRadius.all(Radius.circular(full));
}

// ===========================================================================
// BULANIKLIK (BLUR) — cam yüzeyler için tek değer
// ===========================================================================
class AppBlur {
  const AppBlur._();

  /// Cam yüzeyler (alt menü, sayfa altlığı, diyalog arkası) — tek değer.
  static const double cam = 12;

  /// Uygulama arka planındaki yumuşak degrade.
  static const double arkaPlan = 70;
}

// ===========================================================================
// TİPOGRAFİ — Metin stilleri (az sayıda, tutarlı)
// ===========================================================================
class AppText {
  const AppText._();

  // ---------------------------------------------------------------------
  // PUNTO ÖLÇEĞİ
  // Ekranda kullanılabilecek her punto burada tanımlıdır. Erişilebilirlik
  // için en küçük punto 12'dir (WCAG AA ve okunabilirlik).
  // ---------------------------------------------------------------------

  /// 12 — mikro etiket (all-caps), alt bilgi
  static const double sizeMicro = 12;

  /// 12 — küçük etiket
  static const double sizeCaption = 12;

  /// 13 — gövde küçük
  static const double sizeSmall = 13;

  /// 14 — gövde küçük (en sık kullanılan)
  static const double sizeBodySmall = 14;

  /// 15 — gövde
  static const double sizeBody = 15;

  /// 16 — gövde büyük
  static const double sizeBodyLarge = 16;

  /// 18 — başlık küçük
  static const double sizeTitleSmall = 18;

  /// 20 — başlık
  static const double sizeTitle = 20;

  /// 22 — başlık büyük
  static const double sizeTitleLarge = 22;

  /// 24 — başlık en büyük
  static const double sizeHeadline = 24;

  /// 26 — display
  static const double sizeDisplay = 26;

  /// 32 — display büyük (rakamlar)
  static const double sizeDisplayLarge = 32;

  /// 42 — emoji boyutu
  static const double sizeEmoji = 42;

  /// 44 — dev rakam (takvim ayı)
  static const double sizeDisplayHuge = 44;

  // ---------------------------------------------------------------------
  // HAZIR METİN STİLLERİ
  // ---------------------------------------------------------------------
  /// 12 — çok küçük etiket (all-caps)
  static const TextStyle labelMicro = TextStyle(
    fontSize: sizeMicro,
    fontWeight: FontWeight.w800,
    letterSpacing: 1.2,
  );

  /// 12 — küçük etiket
  static const TextStyle labelSmall = TextStyle(
    fontSize: sizeCaption,
    fontWeight: FontWeight.w600,
  );

  /// 13 — gövde küçük
  static const TextStyle bodySmall = TextStyle(
    fontSize: sizeSmall,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  /// 15 — gövde (varsayılan)
  static const TextStyle body = TextStyle(
    fontSize: sizeBody,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  /// 15 — vurgulu gövde
  static const TextStyle bodyStrong = TextStyle(
    fontSize: sizeBody,
    fontWeight: FontWeight.w700,
  );

  /// 18 — başlık küçük
  static const TextStyle titleSmall = TextStyle(
    fontSize: sizeTitleSmall,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.3,
  );

  /// 22 — başlık orta
  static const TextStyle title = TextStyle(
    fontSize: sizeTitleLarge,
    fontWeight: FontWeight.w900,
    letterSpacing: -0.5,
  );

  /// 26 — başlık büyük
  static const TextStyle headline = TextStyle(
    fontSize: sizeDisplay,
    fontWeight: FontWeight.w900,
    letterSpacing: -0.6,
  );
}


// ===========================================================================
// AKSAN RENKLERİ — Sadece 2 ana aksan (sadeleştirme)
// ===========================================================================
class AppAccents {
  const AppAccents._();

  /// Ana aksan — marka rengi (derin zümrüt)
  static const Color primary = Color(0xFF0F5F4A);

  /// İkincil aksan — başarı/onay (yeşil)
  static const Color success = Color(0xFF1F7A5A);

  /// Koyu yeşil (buton metni, vurgular)
  static const Color successDark = Color(0xFF0F5F4A);

  /// Uyarı (amber)
  static const Color warning = Color(0xFFD97706);

  /// Hata (kırmızı)
  static const Color error = Color(0xFFDC2626);

  /// Bilgi / stilist (mor — az kullanılır)
  static const Color styleist = Color(0xFF2E6E5E);

  /// Onboarding/kutlama mor (canlı)
  static const Color celebration = Color(0xFF0F5F4A);

  /// Mavi vurgu (bilgi, uyum puanı)
  static const Color info = Color(0xFF30827D);

  /// "Doğru cevap" yeşili (Kombin Düellosu sonuç ekranı).
  /// [success]'ten daha koyu; aynı değer 8 yerde tekrar ediyordu.
  static const Color successDeep = Color(0xFF2E6E5E);
}

// ===========================================================================
// İZİN EKRANI RENKLERİ — Faz kategorileri
// ===========================================================================
class AppPermissionColors {
  const AppPermissionColors._();

  static const Color camera = Color(0xFFA8743F);
  static const Color location = Color(0xFF30827D);
  static const Color notification = Color(0xFFD9A441);
}

// ===========================================================================
// ONBOARDING RENKLERİ — Sayfa paletleri
// ===========================================================================
class AppOnboardingColors {
  const AppOnboardingColors._();

  static const Color green = Color(0xFF1F7A5A);
  static const Color orange = Color(0xFFB98A2E);
  static const Color yellow = Color(0xFFD9A441);
  static const Color deepOrange = Color(0xFF9A6B1F);
  static const Color purple = Color(0xFF2E6E5E);
  static const Color darkGreen = Color(0xFF0F5F4A);
}

// ===========================================================================
// YARDIMCI RENKLER
// ===========================================================================
class AppMiscColors {
  const AppMiscColors._();

  static const Color purple = Color(0xFF2E6E5E);
  static const Color lightPurpleBg = Color(0xFFE6EFEA);
  static const Color lightPurpleBorder = Color(0xFFC9DDD3);
  static const Color rose = Color(0xFFB3413A);
  static const Color roseBg = Color(0xFFF6E3E0);
  static const Color pink = Color(0xFFA8743F);
  static const Color orangeLight = Color(0xFFB98A2E);
  static const Color greenLight = Color(0xFF1F7A5A);
  static const Color greenPale = Color(0xFFDDEEE6);
  static const Color greenDark = Color(0xFF0F5F4A);

  // Amber metin tonları (AI öneri kutusu)
  static const Color amberText = Color(0xFFB26A00);
  static const Color amberTextDark = Color(0xFF8A5300);
  static const Color amberTextBody = Color(0xFF6B4A20);

  // Stilist kutusu metin tonları
  static const Color styleistTextDark = Color(0xFF1F4A3E);
  static const Color styleistText = Color(0xFF2E5F50);

  // Dark mode metin tonları (açık renkli, koyu arka plan üstünde okunur)
  static const Color styleistTextDarkKoyu = Color(0xFFDCEEE6);
  static const Color styleistTextKoyu = Color(0xFFBFD9CD);

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
// VERİ RENKLERİ — Kıyafet renk adlarının gerçek karşılıkları
// ===========================================================================
// Bu palet marka paletinin DIŞINDADIR ve bilinçli istisnadır: kullanıcı
// "lacivert" yazdığında grafikte lacivert görünmelidir. Burada marka uyumu
// değil, adın doğru gösterilmesi esastır. Yalnızca veri görselleştirmede
// (Profil > Renk Paletin) kullanılır, arayüz rengi olarak kullanılmaz.
class AppDataColors {
  const AppDataColors._();

  static const Color navy = Color(0xFF1E3A8A);
  static const Color blue = Color(0xFF3B82F6);
  static const Color red = Color(0xFFEF4444);
  static const Color burgundy = Color(0xFF800020); // Bordo/Burgundy - koyu mor-msı kırmızı
  static const Color grey = Color(0xFF8C8C88);
  static const Color brown = Color(0xFF92400E);
  static const Color pink = Color(0xFFEC4899);
  static const Color purple = Color(0xFF8B5CF6);
  static const Color orange = Color(0xFFE07A2F);
  static const Color yellow = Color(0xFFEAB308);
  static const Color beige = Color(0xFFE5D5C5);
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
  static const Color wornBg = Color(0xFFDBF0E7);
  static const Color wornFg = Color(0xFF1F5C48);
  static const Color wornBgDark = Color(0xFF14271F);
  static const Color wornFgDark = Color(0xFFB4D9C8);

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

  static const Color successBg = Color(0xFFE3F0EA);
  // Uyari zemini kart zeminine cok yakindi (dE 2.8): kutu bos/gri
  // gorunuyordu. Amber tonu belirgin ama yumusak tutuldu (dE 9.6).
  static const Color warningBg = Color(0xFFFDF0DC);
  static const Color errorBg = Color(0xFFFEE2E2);
  static const Color styleistBg = Color(0xFFE9F3EE);

  static const Color successBorder = Color(0xFFB4D9C8);
  static const Color warningBorder = Color(0xFFE7CFAE);
  static const Color styleistBorder = Color(0xFFD5E4DC);

  // ---- Dark-mode uyumlu varyantlar ----
  static const Color styleistBgDark = Color(0xFF1E2A25);
  static const Color styleistBorderDark = Color(0xFF3A4C44);
  static const Color warningBgDark = Color(0xFF2E2416);
  static const Color warningBorderDark = Color(0xFF5A4420);
  static const Color successBgDark = Color(0xFF14271F);
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
