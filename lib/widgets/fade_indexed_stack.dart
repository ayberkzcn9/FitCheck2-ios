import 'package:flutter/material.dart';

/// Sekme/ekran geçişlerinde fade + hafif kayma animasyonu.
///
/// Önce sadece fade vardı; şimdi öğeler hafifçe yukarı kayarak da girer,
/// bu da geçişleri daha canlı ve modern gösterir.
class FadeIndexedStack extends StatefulWidget {
  final int index;
  final List<Widget> children;
  final Duration duration;
  final Curve curve;

  /// Giriş animasyonunda dikey kayma miktarı (px).
  final double slideOffset;

  const FadeIndexedStack({
    super.key,
    required this.index,
    required this.children,
    this.duration = const Duration(milliseconds: 260),
    this.curve = Curves.easeOutCubic,
    this.slideOffset = 8.0,
  });

  @override
  State<FadeIndexedStack> createState() => _FadeIndexedStackState();
}

class _FadeIndexedStackState extends State<FadeIndexedStack>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _kurAnimasyonlar();
    _controller.forward();
  }

  void _kurAnimasyonlar() {
    final curved = CurvedAnimation(parent: _controller, curve: widget.curve);
    _fade = curved;
    _slide = Tween<Offset>(
      begin: Offset(0, widget.slideOffset / 100),
      end: Offset.zero,
    ).animate(curved);
  }

  @override
  void didUpdateWidget(FadeIndexedStack oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.duration != oldWidget.duration ||
        widget.curve != oldWidget.curve ||
        widget.slideOffset != oldWidget.slideOffset) {
      _controller.duration = widget.duration;
      _kurAnimasyonlar();
    }

    if (widget.index != oldWidget.index) {
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Erişilebilirlik: hareket azaltma ayarı açıksa animasyonu sadeleştir.
    final reduceMotion = MediaQuery.of(context).disableAnimations;

    final child = IndexedStack(
      index: widget.index,
      children: widget.children,
    );

    if (reduceMotion) return child;

    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: child,
      ),
    );
  }
}