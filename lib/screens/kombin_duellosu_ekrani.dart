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
import '../theme/design_tokens.dart';
import '../widgets/bilgi_butonu.dart';

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

/// Tek bir soruya verilen cevap: hangi kart seçildi ve o an kaç XP kazanıldı.
///
/// XP cevapla birlikte saklanıyor; kullanıcı geri döndüğünde seri çarpanı
/// yeniden hesaplanmadığı için ekranda yanlış puan görünmüyor.
class _Cevap {
  const _Cevap({required this.solSecildi, required this.xp});

  final bool solSecildi;
  final int xp;
}

class _KombinDuellosuEkraniState extends State<KombinDuellosuEkrani> {
  static const int _turSayisi = 10;

  final KombinDuellosuServisi _varsayilanServis = KombinDuellosuServisi();

  _Asama _asama = _Asama.lobi;
  DuelloDurumu _durum = const DuelloDurumu();

  List<DuelSorusu> _sorular = const <DuelSorusu>[];
  bool _paletKullanildi = false;
  int _soruIndex = 0;

  /// Her sorunun cevabı (sırayla). null = henüz cevaplanmadı.
  ///
  /// Ayrı bir liste tutuluyor ki kullanıcı **önceki sorulara dönebilsin**;
  /// dönüşte o sorunun verdiği cevap, kazandığı XP ve gerekçesi aynen görünür.
  List<_Cevap?> _cevaplar = <_Cevap?>[];

  /// Hangi karta dokunuldu: true = sol, false = sağ, null = henüz yok.
  bool? get _secim =>
      _soruIndex < _cevaplar.length ? _cevaplar[_soruIndex]?.solSecildi : null;

  int _dogru = 0;
  int _seri = 0;
  int _enIyiSeri = 0;
  int _xp = 0;

  /// Turun sonucu yalnızca bir kez kaydedilsin (geri dönüp tekrar
  /// "Sonucu gör" denirse XP ikinci kez yazılmasın).
  bool _bitirildi = false;

  /// Kısa ekranda (yatay mod) panel açılınca "Devam" görünür olsun diye.
  final ScrollController _kaydirici = ScrollController();

  @override
  void dispose() {
    _kaydirici.dispose();
    super.dispose();
  }

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
      _cevaplar = List<_Cevap?>.filled(seti.sorular.length, null);
      _dogru = 0;
      _seri = 0;
      _enIyiSeri = 0;
      _xp = 0;
      _bitirildi = false;
    });
  }

  void _sec(bool solSecildi) {
    if (_cevaplandi || _asama != _Asama.oyun) return;

    final dogruMu = solSecildi == _soru.solDogru;
    var kazanilanXp = 0;
    setState(() {
      if (dogruMu) {
        _dogru += 1;
        _seri += 1;
        _enIyiSeri = max(_enIyiSeri, _seri);
        // Seri çarpanı: +0, +2, +4, sonra +6'da sabitlenir.
        kazanilanXp = 10 + min(_seri - 1, 3) * 2;
        _xp += kazanilanXp;
      } else {
        _seri = 0;
      }
      // Cevap, bulunduğu sorunun satırına yazılır (geri dönüşte bozulmasın).
      _cevaplar[_soruIndex] = _Cevap(solSecildi: solSecildi, xp: kazanilanXp);
    });

    if (dogruMu) {
      HapticFeedback.mediumImpact();
    } else {
      HapticFeedback.heavyImpact();
    }

    // Kısa ekranda panel ekranın altında kalabiliyor; cevaptan sonra
    // "Devam" düğmesi görünür olsun diye en alta kaydır.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_kaydirici.hasClients) return;
      final hedef = _kaydirici.position.maxScrollExtent;
      if (_kaydirici.offset >= hedef - 1) return;
      _kaydirici.animateTo(
        hedef,
        duration: AppMotion.kisa,
        curve: AppMotion.giris,
      );
    });
  }

  void _devam() {
    if (_soruIndex + 1 >= _sorular.length) {
      _bitir();
      return;
    }
    setState(() => _soruIndex += 1);
    // Yeni turda başa dön; kısa ekranda kaydırma altta kalmış olabilir.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _kaydirici.hasClients) {
        _kaydirici.jumpTo(0);
      }
    });
  }

  /// Önceki soruya döner. Cevaplar `_cevaplar` listesinde tutulduğu için
  /// dönülen soru, verilen cevap ve kazanılan XP ile birlikte görünür;
  /// puan yeniden hesaplanmaz.
  void _geri() {
    if (_asama != _Asama.oyun || _soruIndex == 0) return;
    HapticFeedback.selectionClick();
    setState(() => _soruIndex -= 1);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _kaydirici.hasClients) {
        _kaydirici.jumpTo(0);
      }
    });
  }

  Future<void> _bitir() async {
    // Aynı tur iki kez kaydedilmesin (geri dönüp "Sonucu gör" tekrar basılırsa).
    if (_bitirildi) {
      if (mounted && _asama != _Asama.sonuc) {
        setState(() => _asama = _Asama.sonuc);
      }
      return;
    }
    _bitirildi = true;

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
        duration: AppMotion.kisa,
        switchInCurve: AppMotion.giris,
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
      padding: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        28 + _altMenuBoslugu(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.xl, AppSpacing.xl, AppSpacing.xl),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  colors.primary,
                  Color.lerp(colors.primary, colors.onPrimaryContainer, 0.4) ??
                      colors.primary,
                ],
              ),
              borderRadius: AppRadius.dialogRadius,
              boxShadow: [
                BoxShadow(
                  color: colors.primary.withValues(alpha: 0.18),
                  blurRadius: 24,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
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
                  fontSize: AppText.sizeBodyLarge,
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadius.lgRadius,
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.lg),
            decoration: BoxDecoration(
              color: colors.surfaceContainerLow,
              borderRadius: AppRadius.xxlRadius,
              border: Border.all(
                color: colors.outlineVariant.withValues(alpha: 0.4),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.duelloNasilOynanir,
                        style: text.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    BilgiButonu(
                      baslik: l10n.duelloNasilOynanir,
                      aciklama: l10n.bilgiDueloPuan,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _kural(context, 1, l10n.duelloKural1),
                _kural(context, 2, l10n.duelloKural2),
                _kural(context, 3, l10n.duelloKural3),
              ],
            ),
          ),
          if (widget.gardirobum.length < 4 || _paletKullanildi) ...[
            const SizedBox(height: 14),
            Text(
              l10n.duelloPaletNotu,
              textAlign: TextAlign.center,
              style: text.labelSmall?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
            if (widget.gardirobum.length < 4) ...[
              const SizedBox(height: 4),
              TextButton.icon(
                onPressed: widget.onDolapAc,
                icon: const Icon(Icons.add_rounded),
                label: Text(l10n.duelloDolapEkle),
              ),
            ],
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
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: zemin,
        borderRadius: AppRadius.xlRadius,
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
              fontSize: AppText.sizeCaption,
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
                fontSize: AppText.sizeCaption,
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

  /// AnaEkran `extendBody: true` kullandığı için gövde, alt menünün altına
  /// uzanıyor. Scaffold bu durumda gövdenin alt boşluğunu menünün yüksekliği
  /// kadar bildiriyor; bu boşluk bırakılmazsa geri bildirim panelinin "Devam"
  /// düğmesi menünün arkasında kalır ve oyun ilk turdan sonra kilitlenmiş
  /// görünür.
  double _altMenuBoslugu(BuildContext context) {
    final media = MediaQuery.of(context);
    return media.padding.bottom > 0
        ? media.padding.bottom
        : media.viewPadding.bottom;
  }

  /// Cevap verildiğinde kartların altında panel için ayrılan yer.
  static const double _panelYuksekligi = 176;

  Widget _oyun(BuildContext context) {
    final altBosluk = _altMenuBoslugu(context);

    return LayoutBuilder(
      builder: (context, kisit) {
        // Yatay mod / çok kısa ekran: iki kartı yan yana sığdırmak imkânsız,
        // o yüzden sabit yükseklikte kartlar + kaydırılabilir panel.
        final kisaEkran = kisit.maxHeight - altBosluk < 400;
        if (kisaEkran) return _oyunKisa(context, altBosluk);

        return Stack(
          key: const ValueKey<String>('duello-oyun'),
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                16,
                8,
                16,
                altBosluk + 8 + (_cevaplandi ? _panelYuksekligi : 0),
              ),
              child: Column(
                children: [
                  _ustBilgi(context),
                  const SizedBox(height: 10),
                  _ilerleme(context),
                  const SizedBox(height: 12),
                  _olcuSeridi(context, _soru.olcu),
                  const SizedBox(height: 12),
                  Expanded(child: _kartlar(context, _soru)),
                  if (!_cevaplandi) _dokunmaIpucu(context),
                ],
              ),
            ),
            // Panel menünün üstünde sabit duruyor: yüksekliği metne göre
            // büyüse bile kırpılmıyor, taşma da yapmıyor.
            if (_cevaplandi)
              Positioned(
                left: 16,
                right: 16,
                bottom: altBosluk + 6,
                child: _geriBildirim(context, _soru),
              ),
          ],
        );
      },
    );
  }

  Widget _oyunKisa(BuildContext context, double altBosluk) {
    return SingleChildScrollView(
      key: const ValueKey<String>('duello-oyun'),
      controller: _kaydirici,
      padding: EdgeInsets.fromLTRB(16, 8, 16, altBosluk + 12),
      child: Column(
        children: [
          _ustBilgi(context),
          const SizedBox(height: 10),
          _ilerleme(context),
          const SizedBox(height: 12),
          _olcuSeridi(context, _soru.olcu),
          const SizedBox(height: 12),
          SizedBox(
            height: 210,
            child: _kartlar(context, _soru),
          ),
          const SizedBox(height: 12),
          _cevaplandi
              ? _geriBildirim(context, _soru)
              : _dokunmaIpucu(context),
        ],
      ),
    );
  }

  Widget _ustBilgi(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    return Row(
      children: [
        if (_soruIndex > 0) ...[
          IconButton(
            onPressed: _geri,
            tooltip: l10n.duelloGeri,
            icon: const Icon(Icons.chevron_left_rounded, size: 22),
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
          const SizedBox(width: 2),
        ],
        Text(
          l10n.duelloTur(_soruIndex + 1, _sorular.length),
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const Spacer(),
        if (_seri > 0) ...[
          _pill(
            context,
            icon: Icons.local_fire_department_rounded,
            metin: 'x$_seri',
            renk: colors.error,
            zemin: colors.error.withValues(alpha: 0.1),
          ),
          const SizedBox(width: 8),
        ],
        _pill(
          context,
          icon: Icons.bolt_rounded,
          metin: l10n.duelloXp(_xp),
          renk: colors.primary,
          zemin: colors.primary.withValues(alpha: 0.1),
        ),
      ],
    );
  }

  Widget _kartlar(BuildContext context, DuelSorusu soru) {
    return Row(
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
    );
  }

  Widget _dokunmaIpucu(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.touch_app_outlined,
            size: 18,
            color: colors.onSurfaceVariant,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              l10n.duelloDokun,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: colors.onSurfaceVariant),
            ),
          ),
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
            duration: AppMotion.kisa,
            height: 5,
            margin: EdgeInsetsDirectional.only(end: index == _sorular.length - 1 ? 0 : 4),
            decoration: BoxDecoration(
              color: gecti
                  ? colors.primary
                  : simdiki
                      ? colors.primary.withValues(alpha: 0.5)
                      : colors.outlineVariant.withValues(alpha: 0.45),
              borderRadius: AppRadius.xxsRadius,
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
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: 0.08),
        borderRadius: AppRadius.lgRadius,
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
          fontSize: AppText.sizeMicro,
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

    const dogruRenk = AppAccents.successDeep;
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
        label: _kartEtiketi(etiket, kart),
        child: GestureDetector(
          onTap: cevaplandi ? null : () => _sec(etiket == 'A'),
          child: AnimatedContainer(
            duration: AppMotion.kisa,
            curve: AppMotion.giris,
            padding: const EdgeInsets.fromLTRB(AppSpacing.sm, AppSpacing.sm, AppSpacing.sm, AppSpacing.md),
            decoration: BoxDecoration(
              color: zemin,
              borderRadius: AppRadius.xlRadius,
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
                          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
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
                        fontSize: AppText.sizeMicro,
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

  /// Ekran okuyucu için kart açıklaması: "A: Beyaz Tişört, Siyah Pantolon".
  ///
  /// Parça adı yoksa (renk kartı düellosu) rengi kullanılır.
  static String _kartEtiketi(String etiket, DuelKarti kart) {
    final parcalar = kart.parcalar
        .map((p) => p.kiyafet?.gorunenBaslik ?? p.renk)
        .where((ad) => ad.trim().isNotEmpty)
        .toList();
    if (parcalar.isEmpty) return etiket;
    return '$etiket: ${parcalar.join(', ')}';
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
          borderRadius: AppRadius.mdRadius,
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
    // XP cevapla birlikte saklandığı için geri dönüşte de doğru görünür.
    final kazanilanXp = _cevaplar[_soruIndex]?.xp ?? 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.md),
      decoration: BoxDecoration(
        color: dogruMu
            ? AppAccents.successDeep.withValues(alpha: 0.09)
            : colors.error.withValues(alpha: 0.07),
        borderRadius: AppRadius.lgRadius,
        border: Border.all(
          color: dogruMu
              ? AppAccents.successDeep.withValues(alpha: 0.4)
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
                color: dogruMu ? AppAccents.successDeep : colors.error,
              ),
              const SizedBox(width: 8),
              Text(
                dogruMu ? l10n.duelloDogru : l10n.duelloYanlis,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: dogruMu
                          ? AppAccents.successDeep
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
          Row(
            children: [
              if (_soruIndex > 0) ...[
                SizedBox(
                  height: 42,
                  child: OutlinedButton(
                    onPressed: _geri,
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.lgRadius,
                      ),
                    ),
                    child: Text(
                      l10n.duelloGeri,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: SizedBox(
                  height: 42,
                  child: FilledButton(
                    onPressed: _devam,
                    style: FilledButton.styleFrom(
                      backgroundColor: dogruMu ? AppAccents.successDeep : null,
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.lgRadius,
                      ),
                    ),
                    child: Text(
                      son ? l10n.duelloSonuc : l10n.duelloDevam,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
            ],
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
            color: olumlu ? AppAccents.successDeep : colors.error,
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
      padding: EdgeInsets.fromLTRB(
        24,
        16,
        24,
        28 + _altMenuBoslugu(context),
      ),
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
                        basarili ? AppAccents.successDeep : colors.primary,
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
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: colors.surfaceContainerLow,
              borderRadius: AppRadius.xlRadius,
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
                  borderRadius: AppRadius.xsRadius,
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
                  fontSize: AppText.sizeBodyLarge,
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadius.lgRadius,
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
