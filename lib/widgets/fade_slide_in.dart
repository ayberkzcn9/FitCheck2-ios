// FitCheck Design System — Animasyonlu görünüm
//
// Liste öğelerinin kademeli (staggered) olarak belirmesi için.
// Kullanım:
//   FadeSlideIn(
//     index: i,
//     child: Kart(...),
//   )

import 'package:flutter/material.dart';

class FadeSlideIn extends StatefulWidget {
  final Widget child;

  /// Listenin kaçıncı öğesi (kademeli gecikme için).
  final int index;

  /// Taban gecikme (ms).
  final int baseDelayMs;

  /// Öğe başına ek gecikme (ms).
  final int staggerMs;

  final Duration duration;

  const FadeSlideIn({
    super.key,
    required this.child,
    this.index = 0,
    this.baseDelayMs = 0,
    this.staggerMs = 45,
    this.duration = const Duration(milliseconds: 350),
  });

  @override
  State<FadeSlideIn> createState() => _FadeSlideInState();
}

class _FadeSlideInState extends State<FadeSlideIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;
  bool _basladi = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(_fade);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_basladi) {
      _basladi = true;
      // Hareket azaltma açıksa beklemeden göster.
      if (MediaQuery.of(context).disableAnimations) {
        _controller.value = 1.0;
      } else {
        final gecikme = widget.baseDelayMs +
            (widget.index.clamp(0, 12) * widget.staggerMs);
        Future.delayed(Duration(milliseconds: gecikme), () {
          if (mounted) _controller.forward();
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(position: _slide, child: widget.child),
    );
  }
}