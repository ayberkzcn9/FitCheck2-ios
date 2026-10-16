// Tema yardımcıları — dark mode uyumlu renkler.
//
// Kullanım:
//   color: context.uygunMetin          // metin rengi (dark'ta beyaz)
//   color: context.uygunIkon           // ikon rengi
//   color: context.uygunYuzey          // kart arka planı
//   color: context.uygunVurgu          // aksan rengi

import 'package:flutter/material.dart';

extension TemaRenkleri on BuildContext {
  bool get koyuMu => Theme.of(this).brightness == Brightness.dark;

  ColorScheme get _cs => Theme.of(this).colorScheme;

  /// Ana metin rengi (dark'ta açık, light'ta koyu).
  Color get uygunMetin => _cs.onSurface;

  /// İkincil metin rengi.
  Color get uygunAltMetin => _cs.onSurfaceVariant;

  /// İkon rengi.
  Color get uygunIkon => _cs.onSurfaceVariant;

  /// Yüzey (kart) rengi.
  Color get uygunYuzey => _cs.surfaceContainerHigh;

  /// Vurgu (aksans) rengi.
  Color get uygunVurgu => _cs.primary;

  /// Diyalog arka planı.
  Color get uygunDiyalogArka => _cs.surfaceContainerHigh;

  /// Görsel/dialog üstü metin (her zaman beyaz/siyah uygun).
  /// Overlay (fotoğraf üstü) metinler için.
  Color get overlayMetin => Colors.white;
}
