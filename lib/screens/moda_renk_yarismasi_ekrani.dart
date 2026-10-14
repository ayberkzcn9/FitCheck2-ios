import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

import '../l10n/app_localizations.dart';

// Global nav bar visibility notifier for trivia screen
final ValueNotifier<bool> triviaNavBarVisible = ValueNotifier<bool>(true);

class ModaRenkYarismasiEkrani extends StatefulWidget {
  const ModaRenkYarismasiEkrani({super.key, this.onReturnToHome});
  final VoidCallback? onReturnToHome;
  @override
  State<ModaRenkYarismasiEkrani> createState() => _ModaRenkYarismasiEkraniState();
}

class _Soru {
  final String soru;
  final List<String> secenekler;
  final int dogruIndex;

  const _Soru({
    required this.soru,
    required this.secenekler,
    required this.dogruIndex,
  });
}

class _ModaRenkYarismasiEkraniState extends State<ModaRenkYarismasiEkrani> with SingleTickerProviderStateMixin {
  late List<_Soru> _gunlukSorular;
  int _indeks = 0;
  int _skor = 0;
  int? _secilen;
  bool _bitis = false;
  bool _yukleniyor = true;
  bool _gunlukKilit = false;

  late final ScrollController _scrollController;
  late final AnimationController _skorAnimController;
  late final Animation<double> _skorScaleAnim;
  Timer? _scrollDebounce;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _skorAnimController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _skorScaleAnim = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _skorAnimController, curve: Curves.elasticOut),
    );
    _baslat();
  }

  void _onScroll() {
    _scrollDebounce?.cancel();
    _scrollDebounce = Timer(const Duration(milliseconds: 100), () {
      if (!_scrollController.hasClients) return;
      final dir = _scrollController.position.userScrollDirection;
      if (dir == ScrollDirection.forward) {
        triviaNavBarVisible.value = false;
      } else if (dir == ScrollDirection.reverse) {
        triviaNavBarVisible.value = true;
      }
    });
  }

  @override
  void dispose() {
    _scrollDebounce?.cancel();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _skorAnimController.dispose();
    super.dispose();
  }

  List<_Soru> _sorulariOlustur(AppLocalizations l10n) {
    // Easy questions (Turkish) - 12 samples, we will take first 10 each day
    return [
      _Soru(
        soru: "Türkiye'nin başkenti neresidir?",
        secenekler: ["İstanbul", "Ankara", "İzmir", "Bursa"],
        dogruIndex: 1,
      ),
      _Soru(
        soru: "Dünya'nın en büyük okyanusu hangisidir?",
        secenekler: ["Atlas", "Hint", "Pasifik", "Kuzey Kutup"],
        dogruIndex: 2,
      ),
      _Soru(
        soru: "İlk olarak ağaçtan yapılmış yazılım cihazı hangisidir?",
        secenekler: ["Abaküs", "Mikrodenge", "Analog bilgisayar", "ENIAC"],
        dogruIndex: 0,
      ),
      _Soru(
        soru: "Bir üçgenin iç açılar toplamı kaç derecedir?",
        secenekler: ["180°", "360°", "90°", "270°"],
        dogruIndex: 0,
      ),
      _Soru(
        soru: "Türk bayrağındaki ayın şekli nedir?",
        secenekler: ["Yıldız", "Ay", "Yarım Ay", "Tam Ay"],
        dogruIndex: 2,
      ),
      _Soru(
        soru: "Hangisi bir memeli hayvandır?",
        secenekler: ["Kunduz", "Balık", "Kuş", "Kertenkele"],
        dogruIndex: 0,
      ),
      _Soru(
        soru: "İnternet'te 'WWW' kısaltması ne anlama gelir?",
        secenekler: ["World Wide Web", "World Wide Wrestling", "World Weather Watch", "World Water Week"],
        dogruIndex: 0,
      ),
      _Soru(
        soru: "Bir gün kaç saat eder?",
        secenekler: ["12", "24", "36", "48"],
        dogruIndex: 1,
      ),
      _Soru(
        soru: "Türkçe alfabesinde kaç harf vardır?",
        secenekler: ["26", "28", "29", "30"],
        dogruIndex: 2,
      ),
      _Soru(
        soru: "Hangisi bir meyvedir?",
        secenekler: ["Elma", "Soğan", "Patates", "Marul"],
        dogruIndex: 0,
      ),
      _Soru(
        soru: "Dünya'nın en uzun nehri hangisidir?",
        secenekler: ["Amazon", "Nil", "Yangtze", "Mississippi"],
        dogruIndex: 1,
      ),
      _Soru(
        soru: "Atatürk'ün doğum yılı nedir?",
        secenekler: ["1881", "1890", "1900", "1912"],
        dogruIndex: 0,
      ),
    ];
  }

  Future<void> _baslat() async {
    // Reset game state at start
    _skor = 0;
    _indeks = 0;
    _secilen = null;
    _bitis = false;
    _gunlukKilit = false;

    final prefs = await SharedPreferences.getInstance();
    final bugun = DateTime.now().toIso8601String().substring(0, 10);
    final sonOyun = prefs.getString('moda_trivia_son_tarih') ?? '';
    if (sonOyun == bugun) {
      if (mounted) {
        setState(() {
          _gunlukKilit = true;
          _yukleniyor = false;
        });
      }
      return;
    }
    final l10n = AppLocalizations.of(context)!;
    _gunlukSorular = _sorulariOlustur(l10n);
    if (mounted) {
      setState(() {
        _yukleniyor = false;
      });
    }
  }

  Future<void> _hapticLight() async {
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 10);
    }
  }

  Future<void> _hapticHeavy() async {
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 60);
    }
  }

  Future<void> _hapticSuccess() async {
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(pattern: [0, 30, 20, 30]);
    }
  }

  Future<void> _hapticError() async {
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(pattern: [0, 50, 30, 50, 30, 50]);
    }
  }

  void _sec(int index) {
    if (_secilen != null) return;
    _hapticLight();
    setState(() {
      _secilen = index;
    });
    final dogru = index == _gunlukSorular[_indeks].dogruIndex;
    if (dogru) {
      _skor++;
      _skorAnimController.forward(from: 0);
      _hapticSuccess();
    } else {
      _hapticError();
    }
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      if (_indeks + 1 >= _gunlukSorular.length) {
        _bitir();
      } else {
        setState(() {
          _indeks++;
          _secilen = null;
        });
      }
    });
  }

  Future<void> _bitir() async {
    _hapticHeavy();
    final prefs = await SharedPreferences.getInstance();
    final bugun = DateTime.now().toIso8601String().substring(0, 10);
    await prefs.setString('moda_trivia_son_tarih', bugun);
    final oncekiEnIyi = prefs.getInt('moda_trivia_en_iyi') ?? 0;
    await prefs.setInt('moda_trivia_en_iyi', _skor > oncekiEnIyi ? _skor : oncekiEnIyi);
    if (mounted) {
      setState(() {
        _bitis = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;

    Widget _wrap(Widget child) => PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (!didPop) widget.onReturnToHome?.call();
          },
          child: child,
        );

    // Ortak header (AppBar yerine)
    Widget _buildHeader() => SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.modaYarismasiBaslik,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                ScaleTransition(
                  scale: _skorScaleAnim,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: colors.primaryContainer,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      '$_skor / 10',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: colors.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );

    // Ortak body padding (avoid system gesture bar at bottom)
    const _bodyPadding = EdgeInsets.fromLTRB(20, 20, 20, 20);

    if (_yukleniyor) {
      return _wrap(
        SafeArea(
          bottom: true,
          child: const Center(child: CircularProgressIndicator()),
        ),
      );
    }
    if (_gunlukKilit) {
      return _wrap(
        Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SafeArea(
                bottom: true,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: _bodyPadding,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.lock_outline, size: 64, color: colors.primary),
                          const SizedBox(height: 16),
                          Text(l10n.modaYarismasiGunlukTamamlandi,
                              style: Theme.of(context).textTheme.headlineSmall, textAlign: TextAlign.center),
                          const SizedBox(height: 8),
                          Text(l10n.modaYarismasiYeniYarin, textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium),
                          const SizedBox(height: 24),
                          _HapticButton(
                            onPressed: widget.onReturnToHome ?? () => Navigator.of(context).pop(),
                            child: Text(l10n.modaYarismasiGeri),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
    if (_bitis) {
      return _wrap(
        Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SafeArea(
                bottom: true,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: _bodyPadding,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.emoji_events, size: 72, color: colors.primary),
                          const SizedBox(height: 16),
                          Text(l10n.modaYarismasiSonuc, style: Theme.of(context).textTheme.headlineMedium),
                          const SizedBox(height: 8),
                          Text(l10n.modaYarismasiSkor(_skor), style: Theme.of(context).textTheme.titleLarge),
                          const SizedBox(height: 24),
                          _HapticButton(
                            onPressed: widget.onReturnToHome ?? () => Navigator.of(context).pop(),
                            child: Text(l10n.modaYarismasiAnaEkrana),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    final soru = _gunlukSorular[_indeks];
    return _wrap(
      Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SafeArea(
              bottom: true,
              child: SingleChildScrollView(
                padding: _bodyPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: LinearProgressIndicator(
                        value: (_indeks + (_secilen != null ? 1 : 0)) / 10,
                        minHeight: 8,
                        backgroundColor: colors.surfaceContainerHighest,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(l10n.modaYarismasiSoru(_indeks + 1),
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(color: colors.primary)),
                    const SizedBox(height: 12),
                    Card(
                      color: colors.surfaceContainerLow,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(soru.soru, style: Theme.of(context).textTheme.headlineSmall),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ...List.generate(
                      soru.secenekler.length,
                      (i) {
                        final secili = _secilen == i;
                        final dogru = _secilen != null && i == soru.dogruIndex;
                        final yanlis = _secilen != null && secili && i != soru.dogruIndex;
                        Color fill = colors.surfaceContainerHighest;
                        if (dogru) fill = colors.primaryContainer;
                        if (yanlis) fill = colors.errorContainer;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Semantics(
                            button: true,
                            selected: secili,
                            label: '${soru.secenekler[i]}${dogru ? ', doğru cevap' : yanlis ? ', yanlış cevap' : ''}',
                            child: Material(
                              color: fill,
                              borderRadius: BorderRadius.circular(16),
                              child: InkWell(
                                onTap: () => _sec(i),
                                borderRadius: BorderRadius.circular(16),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: secili ? colors.primary : (dogru ? colors.primary : yanlis ? colors.error : colors.outlineVariant),
                                      width: secili || dogru || yanlis ? 2.5 : 1.5),
                                    color: fill,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          soru.secenekler[i],
                                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                            color: dogru ? colors.onPrimaryContainer : yanlis ? colors.onErrorContainer : colors.onSurface,
                                            fontWeight: secili ? FontWeight.w600 : FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                      Icon(
                                        dogru ? Icons.check_circle : yanlis ? Icons.cancel : Icons.radio_button_unchecked,
                                        color: dogru ? colors.primary : yanlis ? colors.error : colors.onSurfaceVariant,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Basit haptic feedback wrapper for ElevatedButton/TextButton
class _HapticButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;

  const _HapticButton({required this.onPressed, required this.child});

  Future<void> _hapticLight() async {
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 10);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await _hapticLight();
        if (context.mounted) onPressed();
      },
      child: child,
    );
  }
}