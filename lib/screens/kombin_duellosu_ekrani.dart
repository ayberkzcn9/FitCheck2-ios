// "Kombin Düellosu" — iki kombin, tek dokunuş.
//
// Oyunun döngüsü bilerek çok kısa:
//   soru → dokun → 1 saniyede geri bildirim → devam.
// Tur 10 soru sürüyor, sonunda skor + XP + günlük seri kaydediliyor.
//
// Doğru cevap [DuelMotoru] tarafından hesaplanıyor; bu ekran yalnızca
// gösteriyor. Böylece oyun kuralları test edilebilir kalıyor.
//
// Sekme olarak AnaEkran'ın gövdesinde yaşıyor: kendi Scaffold'u yok,
// üstteki uygulama çubuğu ve alttaki menü AnaEkran'a ait.

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../l10n/app_localizations.dart';
import '../models/kiyafet.dart';
import '../services/analytics_servisi.dart';
import '../services/kombin_duellosu_motoru.dart';
import '../services/kombin_duellosu_servisi.dart';

class KombinDuellosuEkrani extends StatefulWidget {
  const KombinDuellosuEkrani({
    super.key,
    required this.gardirobum,
    this.gunlukHava = '',
    this.onReturnToHome,
    this.onDolapAc,
    this.motor,
    this.servisi,
    this.tohum,
  });

  final List<Kiyafet> gardirobum;
  final String gunlukHava;
  final VoidCallback? onReturnToHome;
  final VoidCallback? onDolapAc;

  /// Testlerde sabit soru seti vermek için.
  final DuelMotoru? motor;
  final KombinDuellosuServisi? servisi;
  final int? tohum;

  @override
  State<KombinDuellosuEkrani> createState() => _KombinDuellosuEkraniState();
}

enum _Asama { lobi, oyun, sonuc }

class _KombinDuellosuEkraniState extends State<KombinDuellosuEkrani> {
  static const int _turSayisi = 10;

  final KombinDuellosuServisi _varsayilanServis = KombinDuellosuServisi();

  _Asama _asama = _Asama.lobi;
  DuelloDurumu _durum = const DuelloDurumu();

  List<DuelSorusu> _sorular = const <DuelSorusu>[];
  bool _paletKullanildi = false;
  int _soruIndex = 0;

  /// Hangi karta dokunuldu: true = sol, false = sağ, null = henüz yok.
  bool? _secim;
  int _dogru = 0;
  int _seri = 0;
  int _enIyiSeri = 0;
  int _xp = 0;

  KombinDuellosuServisi get _servis =>
      widget.servisi ?? _varsayilanServis;

  @override
  void initState() {
    super.initState();
    _durumYukle();
  }

  Future<void> _durumYukle() async {
    final durum = await _servis.yukle();
    if (!mounted) return;
    setState(() => _durum = durum);
  }

  bool get _cevaplandi => _secim != null;

  DuelSorusu get _soru => _sorular[_soruIndex];

  void _baslat() {
    final seti = (widget.motor ?? DuelMotoru()).uret(
      gardirobum: widget.gardirobum,
      gunlukHava: widget.gunlukHava,
      adet: _turSayisi,
      tohum: widget.tohum,
    );

    if (seti.bosMu) {
      // Teoride imkânsız: renk kartları her zaman üretilebiliyor.
      return;
    }

    AnalyticsServisi().olay(
      'duello_basladi',
      <String, Object>{
        'soru_sayisi': seti.sorular.length,
        'palet': seti.paletKullanildi ? 1 : 0,
      },
    );

    setState(() {
      _asama = _Asama.oyun;
      _sorular = seti.sorular;
      _paletKullanildi = seti.paletKullanildi;
      _soruIndex = 0;
      _secim = null;
      _dogru = 0;
      _seri = 0;
      _enIyiSeri = 0;
      _xp = 0;
    });
  }

  void _sec(bool solSecildi) {
    if (_cevaplandi || _asama != _Asama.oyun) return;

    final dogruMu = solSecildi == _soru.solDogru;
    setState(() {
      _secim = solSecildi;
      if (dogruMu) {
        _dogru += 1;
        _seri += 1;
        _enIyiSeri = max(_enIyiSeri, _seri);
        // Seri çarpanı: +0, +2, +4, sonra +6'da sabitlenir.
        _xp += 10 + min(_seri - 1, 3) * 2;
      } else {
        _seri = 0;
      }
    });

    if (dogruMu) {
      HapticFeedback.mediumImpact();
    } else {
      HapticFeedback.heavyImpact();
    }
  }

  void _devam() {
    if (_soruIndex + 1 >= _sorular.length) {
      _bitir();
      return;
    }
    setState(() {
      _soruIndex += 1;
      _secim = null;
    });
  }

  Future<void> _bitir() async {
    setState(() => _asama = _Asama.sonuc);

    AnalyticsServisi().olay(
      'duello_bitti',
      <String, Object>{
        'dogru': _dogru,
        'toplam': _sorular.length,
        'xp': _xp,
        'seri': _enIyiSeri,
      },
    );

    final durum = await _servis.turuKaydet(
      dogru: _dogru,
      toplam: _sorular.length,
      xp: _xp,
      enIyiSeri: _enIyiSeri,
    );
    if (!mounted) return;
    setState(() => _durum = durum);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 260),
        switchInCurve: Curves.easeOutCubic,
        child: switch (_asama) {
          _Asama.lobi => _lobi(context),
          _Asama.oyun => _oyun(context),
          _Asama.sonuc => _sonuc(context),
        },
      ),
    );
  }

  // ---------------------------------------------------------------- lobi

  Widget _lobi(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return SingleChildScrollView(
      key: const ValueKey<String>('duello-lobi'),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(22, 20, 22, 22),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  colors.primary,
                  Color.lerp(colors.primary, colors.tertiary, 0.45) ??
                      colors.primary,
                ],
              ),
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: colors.primary.withValues(alpha: 0.25),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: colors.onPrimary.withValues(alpha: 0.16),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.style_rounded,
                        color: colors.onPrimary,
                        size: 22,
                      ),
                    ),
                    const Spacer(),
                    if (_durum.gunlukSeri > 0)
                      _pill(
                        context,
                        icon: Icons.local_fire_department_rounded,
                        metin: l10n.duelloGunSerisi(_durum.gunlukSeri),
                        renk: colors.onPrimary,
                        zemin: colors.onPrimary.withValues(alpha: 0.16),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.duelloBaslik,
                  style: text.headlineMedium?.copyWith(
                    color: colors.onPrimary,
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.duelloAltBaslik,
                  style: text.bodyMedium?.copyWith(
                    color: colors.onPrimary.withValues(alpha: 0.85),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _istatistik(
                        context,
                        deger: '${_durum.enIyiSkor}',
                        etiket: l10n.duelloEnIyi,
                      ),
                    ),
                    _dikeyAyrac(colors),
                    Expanded(
                      child: _istatistik(
                        context,
                        deger: '${_durum.seviye}',
                        etiket: l10n.duelloSeviye,
                      ),
                    ),
                    _dikeyAyrac(colors),
                    Expanded(
                      child: _istatistik(
                        context,
                        deger: '${_durum.toplamXp}',
                        etiket: 'XP',
                      ),
                    ),
                  ],
                ),
                if (_durum.bugunOynandi) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        size: 16,
                        color: colors.onPrimary.withValues(alpha: 0.9),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          l10n.duelloBugunOynadi,
                          style: text.bodySmall?.copyWith(
                            color: colors.onPrimary.withValues(alpha: 0.9),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 56,
            child: FilledButton.icon(
              onPressed: _baslat,
              icon: const Icon(Icons.play_arrow_rounded),
              label: Text(
                l10n.duelloBaslat,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
            decoration: BoxDecoration(
              color: colors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: colors.outlineVariant.withValues(alpha: 0.4),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.duelloNasilOynanir,
                  style: text.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                _kural(context, 1, l10n.duelloKural1),
                _kural(context, 2, l10n.duelloKural2),
                _kural(context, 3, l10n.duelloKural3),
              ],
            ),
          ),
          if (widget.gardirobum.length < 4) ...[
            const SizedBox(height: 14),
            TextButton.icon(
              onPressed: widget.onDolapAc,
              icon: const Icon(Icons.add_rounded),
              label: Text(l10n.duelloDolapEkle),
            ),
          ],
        ],
      ),
    );
  }

  Widget _dikeyAyrac(ColorScheme colors) => Container(
        width: 1,
        height: 30,
        color: colors.onPrimary.withValues(alpha: 0.18),
      );

  Widget _istatistik(
    BuildContext context, {
    required String deger,
    required String etiket,
  }) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Column(
      children: [
        Text(
          deger,
          style: text.titleLarge?.copyWith(
            color: colors.onPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          etiket,
          textAlign: TextAlign.center,
          style: text.labelSmall?.copyWith(
            color: colors.onPrimary.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }

  Widget _pill(
    BuildContext context, {
    required IconData icon,
    required String metin,
    required Color renk,
    required Color zemin,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: zemin,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: renk),
          const SizedBox(width: 5),
          Text(
            metin,
            style: TextStyle(
              color: renk,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _kural(BuildContext context, int sira, String metin) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 22,
            height: 22,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Text(
              '$sira',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: colors.primary,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              metin,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------- oyun

  Widget _oyun(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final soru = _soru;

    return Padding(
      key: const ValueKey<String>('duello-oyun'),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                l10n.duelloTur(_soruIndex + 1, _sorular.length),
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const Spacer(),
              if (_seri > 0)
                _pill(
                  context,
                  icon: Icons.local_fire_department_rounded,
                  metin: 'x$_seri',
                  renk: colors.error,
                  zemin: colors.error.withValues(alpha: 0.1),
                ),
              const SizedBox(width: 8),
              _pill(
                context,
                icon: Icons.bolt_rounded,
                metin: l10n.duelloXp(_xp),
                renk: colors.primary,
                zemin: colors.primary.withValues(alpha: 0.1),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _ilerleme(context),
          const SizedBox(height: 12),
          _olcuSeridi(context, soru.olcu),
          const SizedBox(height: 12),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: _kart(
                    context,
                    kart: soru.sol,
                    etiket: 'A',
                    dogruKart: soru.solDogru,
                    secildi: _secim == true,
                  ),
                ),
                const SizedBox(width: 8),
                _vs(context),
                const SizedBox(width: 8),
                Expanded(
                  child: _kart(
                    context,
                    kart: soru.sag,
                    etiket: 'B',
                    dogruKart: !soru.solDogru,
                    secildi: _secim == false,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            child: _cevaplandi
                ? _geriBildirim(context, soru)
                : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.touch_app_outlined,
                          size: 18,
                          color: colors.onSurfaceVariant,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          l10n.duelloDokun,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: colors.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
          ),
          if (_paletKullanildi && _soruIndex == 0) ...[
            const SizedBox(height: 8),
            Text(
              l10n.duelloPaletNotu,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _ilerleme(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      children: List<Widget>.generate(_sorular.length, (index) {
        final gecti = index < _soruIndex;
        final simdiki = index == _soruIndex;
        return Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            height: 5,
            margin: EdgeInsets.only(right: index == _sorular.length - 1 ? 0 : 4),
            decoration: BoxDecoration(
              color: gecti
                  ? colors.primary
                  : simdiki
                      ? colors.primary.withValues(alpha: 0.5)
                      : colors.outlineVariant.withValues(alpha: 0.45),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        );
      }),
    );
  }

  Widget _olcuSeridi(BuildContext context, DuelOlcusu olcu) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final renk = olcu == DuelOlcusu.renk;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(
            renk ? Icons.palette_outlined : Icons.thermostat_rounded,
            size: 18,
            color: colors.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              renk ? l10n.duelloOlcuRenk : l10n.duelloOlcuHava,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colors.onSurface,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _vs(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: 30,
      height: 30,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        shape: BoxShape.circle,
        border: Border.all(
          color: colors.outlineVariant.withValues(alpha: 0.6),
        ),
      ),
      child: Text(
        'VS',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w900,
          color: colors.onSurfaceVariant,
        ),
      ),
    );
  }

  Widget _kart(
    BuildContext context, {
    required DuelKarti kart,
    required String etiket,
    required bool dogruKart,
    required bool secildi,
  }) {
    final colors = Theme.of(context).colorScheme;
    final cevaplandi = _cevaplandi;

    const dogruRenk = Color(0xFF2E7D5B);
    final kenar = !cevaplandi
        ? colors.outlineVariant.withValues(alpha: 0.5)
        : dogruKart
            ? dogruRenk
            : secildi
                ? colors.error
                : colors.outlineVariant.withValues(alpha: 0.3);

    final zemin = !cevaplandi
        ? colors.surfaceContainerLow
        : dogruKart
            ? dogruRenk.withValues(alpha: 0.08)
            : secildi
                ? colors.error.withValues(alpha: 0.07)
                : colors.surfaceContainerLow;

    return Opacity(
      opacity: cevaplandi && !dogruKart && !secildi ? 0.45 : 1,
      child: Semantics(
        button: true,
        selected: secildi,
        label: etiket,
        child: GestureDetector(
          onTap: cevaplandi ? null : () => _sec(etiket == 'A'),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 10),
            decoration: BoxDecoration(
              color: zemin,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: kenar, width: 2),
            ),
            child: Stack(
              children: [
                Column(
                  children: [
                    for (var i = 0; i < kart.parcalar.length; i++)
                      Expanded(
                        flex: i == 0 ? 42 : (i == 1 ? 36 : 24),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: _parca(context, kart.parcalar[i]),
                        ),
                      ),
                  ],
                ),
                Positioned(
                  left: 0,
                  top: 0,
                  child: Container(
                    width: 24,
                    height: 24,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: colors.surface.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: colors.outlineVariant.withValues(alpha: 0.5),
                      ),
                    ),
                    child: Text(
                      etiket,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: colors.onSurface,
                      ),
                    ),
                  ),
                ),
                if (cevaplandi)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Icon(
                      dogruKart
                          ? Icons.check_circle_rounded
                          : Icons.cancel_rounded,
                      size: 22,
                      color: dogruKart
                          ? dogruRenk
                          : (secildi ? colors.error : Colors.transparent),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _parca(BuildContext context, DuelParca parca) {
    if (parca.paletMi) {
      final renk = Color(parca.paletRengi!);
      // Açık renkler kart zemininde kaybolmasın diye ince kenarlık.
      final acikMi = renk.computeLuminance() > 0.75;
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: renk,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: acikMi
                ? Colors.black.withValues(alpha: 0.12)
                : Colors.transparent,
          ),
        ),
      );
    }

    final resim = parca.resim;
    if (resim == null) return const SizedBox.shrink();
    return Image.memory(
      resim,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.medium,
      gaplessPlayback: true,
      cacheWidth: 420,
      errorBuilder: (context, error, stack) => Icon(
        Icons.checkroom_rounded,
        color: Theme.of(context).colorScheme.outline,
      ),
    );
  }

  Widget _geriBildirim(BuildContext context, DuelSorusu soru) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final dogruMu = _secim == soru.solDogru;
    final son = _soruIndex + 1 >= _sorular.length;
    final kazanilanXp = dogruMu ? 10 + min(_seri - 1, 3) * 2 : 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: dogruMu
            ? const Color(0xFF2E7D5B).withValues(alpha: 0.09)
            : colors.error.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: dogruMu
              ? const Color(0xFF2E7D5B).withValues(alpha: 0.4)
              : colors.error.withValues(alpha: 0.35),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                dogruMu ? Icons.check_circle_rounded : Icons.cancel_rounded,
                size: 20,
                color: dogruMu ? const Color(0xFF2E7D5B) : colors.error,
              ),
              const SizedBox(width: 8),
              Text(
                dogruMu ? l10n.duelloDogru : l10n.duelloYanlis,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: dogruMu
                          ? const Color(0xFF2E7D5B)
                          : colors.error,
                    ),
              ),
              const Spacer(),
              Text(
                '+$kazanilanXp XP',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: colors.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _sebepSatiri(
            context,
            metin: _sebepMetni(l10n, soru.kazananSebep),
            olumlu: true,
          ),
          const SizedBox(height: 4),
          _sebepSatiri(
            context,
            metin: _sebepMetni(l10n, soru.kaybedenSebep),
            olumlu: false,
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 42,
            child: FilledButton(
              onPressed: _devam,
              style: FilledButton.styleFrom(
                backgroundColor: dogruMu ? const Color(0xFF2E7D5B) : null,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                son ? l10n.duelloSonuc : l10n.duelloDevam,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sebepSatiri(
    BuildContext context, {
    required String metin,
    required bool olumlu,
  }) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Icon(
            olumlu ? Icons.check_rounded : Icons.close_rounded,
            size: 15,
            color: olumlu ? const Color(0xFF2E7D5B) : colors.error,
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            metin,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant,
                  height: 1.35,
                ),
          ),
        ),
      ],
    );
  }

  String _sebepMetni(AppLocalizations l10n, DuelSebebi sebep) {
    return switch (sebep) {
      DuelSebebi.notr => l10n.duelloSebepNotr,
      DuelSebebi.monokrom => l10n.duelloSebepMonokrom,
      DuelSebebi.analog => l10n.duelloSebepAnalog,
      DuelSebebi.vurgu => l10n.duelloSebepVurgu,
      DuelSebebi.zit => l10n.duelloSebepZit,
      DuelSebebi.dagink => l10n.duelloSebepDagink,
      DuelSebebi.cokRenk => l10n.duelloSebepCokRenk,
      DuelSebebi.havaUygun => l10n.duelloSebepHavaUygun,
      DuelSebebi.havaAgir => l10n.duelloSebepHavaAgir,
      DuelSebebi.havaHafif => l10n.duelloSebepHavaHafif,
    };
  }

  // --------------------------------------------------------------- sonuç

  Widget _sonuc(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final toplam = _sorular.length;
    final oran = toplam == 0 ? 0.0 : _dogru / toplam;
    final basarili = oran >= 0.6;

    return SingleChildScrollView(
      key: const ValueKey<String>('duello-sonuc'),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 12),
          Center(
            child: SizedBox(
              width: 168,
              height: 168,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 168,
                    height: 168,
                    child: CircularProgressIndicator(
                      value: oran,
                      strokeWidth: 10,
                      backgroundColor:
                          colors.outlineVariant.withValues(alpha: 0.35),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        basarili ? const Color(0xFF2E7D5B) : colors.primary,
                      ),
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$_dogru/$toplam',
                        style: text.displaySmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: -1,
                        ),
                      ),
                      Text(
                        l10n.duelloBitti,
                        style: text.labelMedium?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.duelloSkor(_dogru, toplam),
            textAlign: TextAlign.center,
            style: text.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.duelloEnIyiSeri(_enIyiSeri),
            textAlign: TextAlign.center,
            style: text.bodyMedium?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: colors.outlineVariant.withValues(alpha: 0.4),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      l10n.duelloSeviyeDegeri(_durum.seviye),
                      style: text.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      l10n.duelloXp(_durum.toplamXp),
                      style: text.labelLarge?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: _durum.seviyeIlerlemesi,
                    minHeight: 8,
                    backgroundColor:
                        colors.outlineVariant.withValues(alpha: 0.35),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _kucukIstatistik(
                        context,
                        l10n.duelloEnIyi,
                        '${_durum.enIyiSkor}/$toplam',
                      ),
                    ),
                    Expanded(
                      child: _kucukIstatistik(
                        context,
                        l10n.duelloSeri,
                        l10n.duelloGunSerisi(_durum.gunlukSeri),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          SizedBox(
            height: 54,
            child: FilledButton.icon(
              onPressed: _baslat,
              icon: const Icon(Icons.replay_rounded),
              label: Text(
                l10n.duelloYeniden,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: widget.onReturnToHome,
            child: Text(l10n.duelloBugune),
          ),
        ],
      ),
    );
  }

  Widget _kucukIstatistik(BuildContext context, String etiket, String deger) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          etiket,
          style: text.labelSmall?.copyWith(color: colors.onSurfaceVariant),
        ),
        const SizedBox(height: 2),
        Text(
          deger,
          style: text.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}
