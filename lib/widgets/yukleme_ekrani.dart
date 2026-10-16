import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// Uygulama açılırken arka plandaki hazırlıklar (Firebase, reklamlar,
/// bildirimler) tamamlanana kadar gösterilen animasyonlu yükleme ekranı.
///
/// Nefes alan logo ve altındaki ince ilerleme çubuğundan oluşur. Arka planı
/// saydamdır; uygulamanın genel gradient zemini üzerinde görünür.
class YuklemeEkrani extends StatefulWidget {
  const YuklemeEkrani({super.key, this.animasyonluGiris = true});

  /// Ekrana yumuşak bir giriş animasyonuyla gelinip gelinmeyeceği. Uygulama
  /// açılışında `true`, ardından gelen kısa süreli beklemelerde `false`
  /// kullanılır; böylece ekran görünürken yeniden solmaz.
  final bool animasyonluGiris;

  @override
  State<YuklemeEkrani> createState() => _YuklemeEkraniState();
}

class _YuklemeEkraniState extends State<YuklemeEkrani>
    with TickerProviderStateMixin {
  static const double _logoBoyutu = 116;
  static const double _logoKoseYaricapi = 30;
  static const String _logoYolu = 'assets/images/logo.png';

  /// Ekrana ilk giriş animasyonu (solma + hafif yukarı kayma).
  late final AnimationController _girisKontrolcusu;

  /// Logonun sürekli tekrarlayan "nefes alma" animasyonu.
  late final AnimationController _nefesKontrolcusu;

  late final Animation<double> _girisOpaklik;
  late final Animation<double> _icerikOpaklik;
  late final Animation<Offset> _girisKayma;
  late final Animation<double> _logoOlcek;
  late final Animation<double> _logoParlaklik;

  @override
  void initState() {
    super.initState();

    _girisKontrolcusu = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _nefesKontrolcusu = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );

    _girisOpaklik = CurvedAnimation(
      parent: _girisKontrolcusu,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
    );

    _icerikOpaklik = CurvedAnimation(
      parent: _girisKontrolcusu,
      curve: const Interval(0.35, 1.0, curve: Curves.easeOut),
    );

    _girisKayma = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _girisKontrolcusu, curve: Curves.easeOutCubic),
    );

    final nefesEgrisi = CurvedAnimation(
      parent: _nefesKontrolcusu,
      curve: Curves.easeInOut,
    );
    _logoOlcek = Tween<double>(begin: 0.94, end: 1.03).animate(nefesEgrisi);
    _logoParlaklik = Tween<double>(begin: 0.0, end: 1.0).animate(nefesEgrisi);

    if (widget.animasyonluGiris) {
      _girisKontrolcusu.forward();
    } else {
      _girisKontrolcusu.value = 1;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // "Hareketi azalt" tercihinde nabız yerine sabit logo gösterilir.
    if (MediaQuery.disableAnimationsOf(context)) {
      _nefesKontrolcusu.stop();
      _nefesKontrolcusu.value = 1;
    } else if (!_nefesKontrolcusu.isAnimating) {
      _nefesKontrolcusu.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _girisKontrolcusu.dispose();
    _nefesKontrolcusu.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: FadeTransition(
          opacity: _girisOpaklik,
          child: SlideTransition(
            position: _girisKayma,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _logo(colors),
                const SizedBox(height: 26),
                FadeTransition(
                  opacity: _icerikOpaklik,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'FitCheck',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                          color: colors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _ilerlemeCubugu(colors),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Nefes alma efektiyle büyüyüp küçülen ve yumuşak bir gölge yayan logo.
  Widget _logo(ColorScheme colors) {
    return AnimatedBuilder(
      animation: _nefesKontrolcusu,
      builder: (context, child) {
        final parlama = _logoParlaklik.value;

        return Transform.scale(
          scale: _logoOlcek.value,
          child: Container(
            width: _logoBoyutu,
            height: _logoBoyutu,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(_logoKoseYaricapi),
              boxShadow: [
                BoxShadow(
                  color: colors.primary.withValues(
                    alpha: lerpDouble(0.10, 0.26, parlama)!,
                  ),
                  blurRadius: lerpDouble(20, 38, parlama)!,
                  offset: Offset(0, lerpDouble(10, 16, parlama)!),
                ),
              ],
            ),
            child: child,
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_logoKoseYaricapi),
        child: Image.asset(
          _logoYolu,
          width: _logoBoyutu,
          height: _logoBoyutu,
          fit: BoxFit.cover,
          filterQuality: FilterQuality.medium,
          gaplessPlayback: true,
        ),
      ),
    );
  }

  /// İnce, yuvarlatılmış ve sürekli akan ilerleme çubuğu.
  Widget _ilerlemeCubugu(ColorScheme colors) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(99),
      child: SizedBox(
        width: 132,
        height: 4,
        child: LinearProgressIndicator(
          minHeight: 4,
          backgroundColor: colors.surfaceContainerHighest,
          color: colors.primary,
        ),
      ),
    );
  }
}
