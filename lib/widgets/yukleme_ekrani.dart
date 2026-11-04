import '../theme/design_tokens.dart';
import 'package:flutter/material.dart';

/// Uygulama açılırken arka plandaki hazırlıklar (Firebase, reklamlar,
/// bildirimler) tamamlanana kadar gösterilen animasyonlu yükleme ekranı.
///
/// Logo ve altındaki ince ilerleme çubuğundan oluşur.
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
    with SingleTickerProviderStateMixin {
  static const double _logoBoyutu = 116;
  static const double _logoKoseYaricapi = 30;
  static const String _logoYolu = 'assets/images/logo.png';

  /// Ekrana ilk giriş animasyonu (solma + hafif yukarı kayma).
  late final AnimationController _girisKontrolcusu;

  late final Animation<double> _girisOpaklik;
  late final Animation<double> _icerikOpaklik;
  late final Animation<Offset> _girisKayma;

  @override
  void initState() {
    super.initState();

    _girisKontrolcusu = AnimationController(
      vsync: this,
      duration: AppMotion.uzun,
    );

    _girisOpaklik = CurvedAnimation(
      parent: _girisKontrolcusu,
      curve: const Interval(0.0, 0.8, curve: AppMotion.standart),
    );

    _icerikOpaklik = CurvedAnimation(
      parent: _girisKontrolcusu,
      curve: const Interval(0.35, 1.0, curve: AppMotion.standart),
    );

    _girisKayma = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _girisKontrolcusu, curve: AppMotion.giris),
    );

    if (widget.animasyonluGiris) {
      _girisKontrolcusu.forward();
    } else {
      _girisKontrolcusu.value = 1;
    }
  }

  @override
  void dispose() {
    _girisKontrolcusu.dispose();
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
                _logo(),
                const SizedBox(height: 26),
                FadeTransition(
                  opacity: _icerikOpaklik,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'FitCheck',
                        style: TextStyle(
                          fontSize: AppText.sizeHeadline,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0,
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

  /// Sabit boyutlu ürün logosu.
  Widget _logo() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(_logoKoseYaricapi),
      child: Image.asset(
        _logoYolu,
        width: _logoBoyutu,
        height: _logoBoyutu,
        fit: BoxFit.cover,
        filterQuality: FilterQuality.medium,
        gaplessPlayback: true,
      ),
    );
  }

  /// İnce, yuvarlatılmış ve sürekli akan ilerleme çubuğu.
  Widget _ilerlemeCubugu(ColorScheme colors) {
    return ClipRRect(
      borderRadius: AppRadius.fullRadius,
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
