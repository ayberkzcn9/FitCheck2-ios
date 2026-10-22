// FitCheck marka teması: derin zümrüt + sıcak krem (altın ikincil vurgu).
//
// Renk şeması tek yerde tanımlanır; hem uygulama (`main.dart`) hem de ekran
// inceleme testleri aynı kaynağı kullanır, böylece görüntüler gerçek görünümle
// birebir aynı olur.

import 'package:flutter/material.dart';

class AppTema {
  const AppTema._();

  /// Marka tohum rengi.
  static const Color tohum = Color(0xFF0F5F4A);

  static ColorScheme renkSemasi(Brightness brightness) {
    final base = ColorScheme.fromSeed(
      seedColor: tohum,
      brightness: brightness,
    );

    if (brightness == Brightness.dark) {
      return base.copyWith(
        primary: const Color(0xFF7FD4B4),
        onPrimary: const Color(0xFF00382A),
        primaryContainer: const Color(0xFF1F4D3F),
        onPrimaryContainer: const Color(0xFFCDEFE1),
        secondary: const Color(0xFFB4CCC0),
        onSecondary: const Color(0xFF1F342B),
        secondaryContainer: const Color(0xFF2F4A3F),
        onSecondaryContainer: const Color(0xFFD0E8DC),
        tertiary: const Color(0xFFE3C07A),
        onTertiary: const Color(0xFF3F2E00),
        tertiaryContainer: const Color(0xFF5A4410),
        onTertiaryContainer: const Color(0xFFFFE9B8),
        surface: const Color(0xFF0F1512),
        onSurface: const Color(0xFFE4E9E4),
        onSurfaceVariant: const Color(0xFFBCC5BE),
        surfaceContainerLowest: const Color(0xFF0A0F0D),
        surfaceContainerLow: const Color(0xFF161D19),
        surfaceContainer: const Color(0xFF1B231F),
        surfaceContainerHigh: const Color(0xFF222B26),
        surfaceContainerHighest: const Color(0xFF2B352F),
        outline: const Color(0xFF86908A),
        outlineVariant: const Color(0xFF3B4640),
        surfaceTint: const Color(0xFF7FD4B4),
      );
    }

    return base.copyWith(
      primary: const Color(0xFF0F5F4A),
      onPrimary: const Color(0xFFFFFDF8),
      primaryContainer: const Color(0xFFCFE8DD),
      onPrimaryContainer: const Color(0xFF05281F),
      secondary: const Color(0xFF4F6B60),
      onSecondary: Colors.white,
      secondaryContainer: const Color(0xFFDDE8E1),
      onSecondaryContainer: const Color(0xFF1A2A23),
      tertiary: const Color(0xFF9A6B1F),
      onTertiary: Colors.white,
      tertiaryContainer: const Color(0xFFF6E7C8),
      onTertiaryContainer: const Color(0xFF2E1F00),
      surface: const Color(0xFFFBF7EF),
      onSurface: const Color(0xFF1B1D1A),
      onSurfaceVariant: const Color(0xFF4A4F49),
      surfaceContainerLowest: const Color(0xFFFFFFFF),
      surfaceContainerLow: const Color(0xFFFFFDF8),
      surfaceContainer: const Color(0xFFF6F1E6),
      surfaceContainerHigh: const Color(0xFFF0EADD),
      surfaceContainerHighest: const Color(0xFFEAE3D4),
      outline: const Color(0xFF7A8078),
      outlineVariant: const Color(0xFFDDD7C8),
      surfaceTint: const Color(0xFF0F5F4A),
    );
  }
}
