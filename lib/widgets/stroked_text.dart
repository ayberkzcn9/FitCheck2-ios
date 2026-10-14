// StrokedText - Görsel üzerinde okunabilir yazı
// Çok yönlü koyu gölge (outline/stroke etkisi) uygular.
// Görselin rengi ne olursa olsun yazıyı okunur kılar.

import 'package:flutter/material.dart';

class StrokedText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final Color strokeColor;
  final double strokeBlur;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? textAlign;

  const StrokedText(
    this.text, {
    super.key,
    this.style,
    this.strokeColor = Colors.black,
    this.strokeBlur = 2.5,
    this.maxLines,
    this.overflow,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    final base = style ?? const TextStyle();

    // 8 yönde koyu gölge → stroke/outline efekti (ellipsis ile uyumlu)
    final outlines = <Shadow>[
      Shadow(color: strokeColor, blurRadius: strokeBlur, offset: const Offset(-1, -1)),
      Shadow(color: strokeColor, blurRadius: strokeBlur, offset: const Offset(0, -1)),
      Shadow(color: strokeColor, blurRadius: strokeBlur, offset: const Offset(1, -1)),
      Shadow(color: strokeColor, blurRadius: strokeBlur, offset: const Offset(-1, 0)),
      Shadow(color: strokeColor, blurRadius: strokeBlur, offset: const Offset(1, 0)),
      Shadow(color: strokeColor, blurRadius: strokeBlur, offset: const Offset(-1, 1)),
      Shadow(color: strokeColor, blurRadius: strokeBlur, offset: const Offset(0, 1)),
      Shadow(color: strokeColor, blurRadius: strokeBlur, offset: const Offset(1, 1)),
    ];

    return Text(
      text,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
      style: base.copyWith(shadows: outlines),
    );
  }
}