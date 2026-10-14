import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/kiyafet.dart';
import '../../models/favori_kombin.dart';
import '../../l10n/app_localizations.dart';

class ProfilModals {
  ProfilModals._();

  static String _normalize(String value) {
    return value
        .trim()
        .replaceAll('İ', 'i')
        .replaceAll('I', 'ı')
        .toLowerCase()
        .replaceAll('ı', 'i')
        .replaceAll('ş', 's')
        .replaceAll('ğ', 'g')
        .replaceAll('ü', 'u')
        .replaceAll('ö', 'o')
        .replaceAll('ç', 'c');
  }

  /// Önce tam eşleşme aranır.
  /// Birden fazla belirsiz eşleşme varsa yanlış görsel yerine null döner.
  static Kiyafet? kiyafetiBul(
    List<Kiyafet> gardirobum,
    String parcaAdi,
  ) {
    final aranan = _normalize(parcaAdi);
    if (aranan.isEmpty) return null;

    final tamEslesenler = <Kiyafet>[];

    for (final k in gardirobum) {
      final bas = _normalize(k.baslik);
      final gor = _normalize(k.gorunenBaslik);

      if ((bas.isNotEmpty && bas == aranan) ||
          (gor.isNotEmpty && gor == aranan)) {
        tamEslesenler.add(k);
      }
    }

    if (tamEslesenler.length == 1) return tamEslesenler.first;
    if (tamEslesenler.length > 1) return null;

    if (aranan.length < 3) return null;

    final kismiEslesenler = <Kiyafet>[];

    for (final k in gardirobum) {
      final bas = _normalize(k.baslik);
      final gor = _normalize(k.gorunenBaslik);

      final basEslesiyor =
          bas.length >= 3 && (bas.contains(aranan) || aranan.contains(bas));

      final gorEslesiyor =
          gor.length >= 3 && (gor.contains(aranan) || aranan.contains(gor));

      if (basEslesiyor || gorEslesiyor) {
        kismiEslesenler.add(k);
      }
    }

    return kismiEslesenler.length == 1 ? kismiEslesenler.first : null;
  }

  static Future<void> _modalAc(
    BuildContext context,
    Widget child,
  ) async {
    HapticFeedback.lightImpact();
    final theme = Theme.of(context);

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: theme.colorScheme.scrim.withValues(alpha: 0.6),
      builder: (_) => child,
    );
  }

  static Future<void> gecmisDetayGoster({
    required BuildContext context,
    required Map<String, String> item,
    required List<Kiyafet> gardirobum,
    required FutureOr<void> Function()? onSil,
  }) {
    return _modalAc(
      context,
      _GecmisDetaySheet(
        item: Map<String, String>.from(item),
        gardirobum: gardirobum,
        onSil: onSil,
      ),
    );
  }

  static Future<void> favorileriGoster({
    required BuildContext context,
    required List<FavoriKombin> favoriKombinler,
    required List<Kiyafet> gardirobum,
    required FutureOr<void> Function(int)? onFavoriSil,
    List<FavoriKombin> Function()? favorileriGetir,
    List<Kiyafet> Function()? gardirobuGetir,
  }) {
    return _modalAc(
      context,
      _FavorilerSheet(
        favorileriGetir: favorileriGetir ?? () => favoriKombinler,
        gardirobuGetir: gardirobuGetir ?? () => gardirobum,
        onFavoriSil: onFavoriSil,
      ),
    );
  }

  static Future<void> sepetiGoster({
    required BuildContext context,
    required List<Kiyafet> gardirobum,
    required Color anaRenk,
    required FutureOr<void> Function(String)? onTekliSepettenCikar,
    required FutureOr<void> Function()? onSepetiTemizle,
    List<Kiyafet> Function()? gardirobuGetir,
  }) {
    return _modalAc(
      context,
      _SepetSheet(
        gardirobuGetir: gardirobuGetir ?? () => gardirobum,
        anaRenk: anaRenk,
        onTekliSepettenCikar: onTekliSepettenCikar,
        onSepetiTemizle: onSepetiTemizle,
      ),
    );
  }
}

/// Bozuk/boş resim verilerinde M3 uyumlu güvenli yedek görünüm.
class ProfilKiyafetGorseli extends StatelessWidget {
  final Kiyafet kiyafet;
  final double boyut;
  final double radius;

  const ProfilKiyafetGorseli({
    super.key,
    required this.kiyafet,
    this.boyut = 64,
    this.radius = 14,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    Widget yedekGorsel() {
      return ColoredBox(
        color: colorScheme.surfaceContainerHighest,
        child: Center(
          child: Icon(
            Icons.broken_image_outlined,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    return Semantics(
      image: true,
      label: kiyafet.gorunenBaslik,
      child: Container(
        width: boyut,
        height: boyut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: kiyafet.resimBytes.isEmpty
            ? yedekGorsel()
            : Image.memory(
                kiyafet.resimBytes,
                fit: BoxFit.cover,
                gaplessPlayback: true,
                errorBuilder: (_, __, ___) => yedekGorsel(),
              ),
      ),
    );
  }
}

abstract class _IslemSheetState<T extends StatefulWidget> extends State<T> {
  bool islemSuruyor = false;

  Future<bool> islemYap(
    FutureOr<void> Function() action,
  ) async {
    if (islemSuruyor || !mounted) return false;

    setState(() => islemSuruyor = true);

    try {
      await Future<void>.sync(action);
      await WidgetsBinding.instance.endOfFrame;
      return mounted;
    } catch (error, stackTrace) {
      debugPrint('Profil modal işlemi hatası: $error\n$stackTrace');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.islemTamamlanamadi),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }

      return false;
    } finally {
      if (mounted) {
        setState(() => islemSuruyor = false);
      }
    }
  }

  void modaliKapat() {
    if (!mounted) return;
    if (ModalRoute.of(context)?.isCurrent != true) return;
    Navigator.of(context).pop();
  }
}

class _ModalCercevesi extends StatelessWidget {
  final String baslik;
  final IconData icon;
  final Color iconColor;
  final Widget child;
  final Widget? altAlan;
  final bool islemSuruyor;
  final double yukseklikOrani;

  const _ModalCercevesi({
    required this.baslik,
    required this.icon,
    required this.iconColor,
    required this.child,
    this.altAlan,
    this.islemSuruyor = false,
    this.yukseklikOrani = 0.82,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return FractionallySizedBox(
      heightFactor: yukseklikOrani,
      child: Material(
        color: colorScheme.surfaceContainerLow,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(28),
        ),
        clipBehavior: Clip.antiAlias,
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                child: Column(
                  children: [
                    Container(
                      width: 48,
                      height: 5,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: colorScheme.outline.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: iconColor.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            icon,
                            color: iconColor,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            baslik,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.4,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton.filledTonal(
                          tooltip: MaterialLocalizations.of(context)
                              .closeButtonTooltip,
                          style: IconButton.styleFrom(
                            backgroundColor: colorScheme.surfaceContainerHighest,
                            foregroundColor: colorScheme.onSurfaceVariant,
                          ),
                          onPressed: islemSuruyor
                              ? null
                              : () {
                                  HapticFeedback.selectionClick();
                                  Navigator.of(context).pop();
                                },
                          icon: const Icon(Icons.close_rounded, size: 20),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (islemSuruyor)
                LinearProgressIndicator(
                  minHeight: 2,
                  color: colorScheme.primary,
                  backgroundColor: colorScheme.surfaceContainerHighest,
                )
              else
                Divider(
                  height: 1,
                  thickness: 1,
                  color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                ),
              Expanded(child: child),
              if (altAlan != null) altAlan!,
            ],
          ),
        ),
      ),
    );
  }
}

class _ModalKart extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const _ModalKart({
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
          width: 1.0,
        ),
      ),
      child: child,
    );
  }
}

class _BosDurum extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String message;

  const _BosDurum({
    required this.icon,
    required this.color,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, size: 54, color: color),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ParcaGorunumu extends StatelessWidget {
  final List<Kiyafet> gardirobum;
  final String parcaAdi;
  final double boyut;

  const _ParcaGorunumu({
    required this.gardirobum,
    required this.parcaAdi,
    this.boyut = 65,
  });

  @override
  Widget build(BuildContext context) {
    final kiyafet = ProfilModals.kiyafetiBul(
      gardirobum,
      parcaAdi,
    );

    if (kiyafet != null) {
      return Tooltip(
        message: parcaAdi,
        child: ProfilKiyafetGorseli(
          kiyafet: kiyafet,
          boyut: boyut,
          radius: 16,
        ),
      );
    }

    final colorScheme = Theme.of(context).colorScheme;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 180),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
        child: Text(
          parcaAdi,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}

class _GecmisDetaySheet extends StatefulWidget {
  final Map<String, String> item;
  final List<Kiyafet> gardirobum;
  final FutureOr<void> Function()? onSil;

  const _GecmisDetaySheet({
    required this.item,
    required this.gardirobum,
    required this.onSil,
  });

  @override
  State<_GecmisDetaySheet> createState() => _GecmisDetaySheetState();
}

class _GecmisDetaySheetState extends _IslemSheetState<_GecmisDetaySheet> {
  Future<void> _sil() async {
    final callback = widget.onSil;
    if (callback == null || islemSuruyor) return;

    HapticFeedback.mediumImpact();

    final l10n = AppLocalizations.of(context)!;
    final onay = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        final colorScheme = Theme.of(dialogContext).colorScheme;
        return AlertDialog(
          title: Text(l10n.gecmisiTemizleTitle),
          content: Text(l10n.gecmisiTemizleOnayIcerik),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(l10n.iptal),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.error,
                foregroundColor: colorScheme.onError,
              ),
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text(l10n.temizle),
            ),
          ],
        );
      },
    );

    if (!mounted || onay != true || islemSuruyor) return;

    final basarili = await islemYap(callback);
    if (basarili) modaliKapat();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final baslik = widget.item['baslik'] ?? l10n.kombin;
    final tarih = widget.item['tarih'] ?? '';
    final detay = widget.item['detay'] ?? '';

    final parcalar = detay
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    return _ModalCercevesi(
      baslik: l10n.kombinDetayiUst,
      icon: Icons.history_rounded,
      iconColor: colorScheme.primary,
      islemSuruyor: islemSuruyor,
      yukseklikOrani: 0.78,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24),
        children: [
          if (tarih.isNotEmpty) ...[
            Text(
              tarih,
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
          ],
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  baslik,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    height: 1.2,
                    letterSpacing: -0.5,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              if (widget.onSil != null) ...[
                const SizedBox(width: 12),
                IconButton.filledTonal(
                  tooltip: l10n.temizle,
                  style: IconButton.styleFrom(
                    backgroundColor: colorScheme.errorContainer,
                    foregroundColor: colorScheme.onErrorContainer,
                  ),
                  onPressed: islemSuruyor ? null : _sil,
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    size: 22,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 24),
          Text(
            l10n.giyilenParcalarUst,
            style: TextStyle(
              color: colorScheme.primary,
              fontSize: 11,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          if (parcalar.isEmpty)
            Text(
              l10n.detayBulunamadi,
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            )
          else
            Wrap(
              spacing: 12,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                for (final parca in parcalar)
                  _ParcaGorunumu(
                    gardirobum: widget.gardirobum,
                    parcaAdi: parca,
                    boyut: 80,
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

class _FavorilerSheet extends StatefulWidget {
  final List<FavoriKombin> Function() favorileriGetir;
  final List<Kiyafet> Function() gardirobuGetir;
  final FutureOr<void> Function(int)? onFavoriSil;

  const _FavorilerSheet({
    required this.favorileriGetir,
    required this.gardirobuGetir,
    required this.onFavoriSil,
  });

  @override
  State<_FavorilerSheet> createState() => _FavorilerSheetState();
}

class _FavorilerSheetState extends _IslemSheetState<_FavorilerSheet> {
  Future<void> _favoriyiSil(FavoriKombin favori) async {
    final callback = widget.onFavoriSil;
    if (callback == null || islemSuruyor) return;

    HapticFeedback.mediumImpact();

    await islemYap(() async {
      final guncelListe = widget.favorileriGetir();
      final index = guncelListe.indexWhere(
        (item) => identical(item, favori),
      );

      if (index == -1) {
        throw StateError('The favorite is no longer available.');
      }

      await Future<void>.sync(() => callback(index));
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    final favoriler = List<FavoriKombin>.from(widget.favorileriGetir());
    final gardirobum = List<Kiyafet>.from(widget.gardirobuGetir());

    return _ModalCercevesi(
      baslik: '${l10n.favoriKombin} (${favoriler.length})',
      icon: Icons.star_rounded,
      iconColor: const Color(0xFFF59E0B),
      islemSuruyor: islemSuruyor,
      child: favoriler.isEmpty
          ? _BosDurum(
              icon: Icons.star_border_rounded,
              color: const Color(0xFFF59E0B),
              message: l10n.henuzFavoriEklemediniz,
            )
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              physics: const BouncingScrollPhysics(),
              itemCount: favoriler.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final favori = favoriler[index];

                final parcalar = favori.parcalar
                    .map((e) => e.trim())
                    .where((e) => e.isNotEmpty)
                    .toList();

                return _ModalKart(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  favori.baslik,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -0.4,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: colorScheme.tertiaryContainer,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    '★ ${l10n.stilistUyum(
                                      favori.renkUyumuPuani.toString(),
                                    )}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                      color: colorScheme.onTertiaryContainer,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (widget.onFavoriSil != null) ...[
                            const SizedBox(width: 8),
                            IconButton.filledTonal(
                              tooltip: l10n.temizle,
                              style: IconButton.styleFrom(
                                backgroundColor: colorScheme.errorContainer,
                                foregroundColor: colorScheme.onErrorContainer,
                              ),
                              onPressed: islemSuruyor
                                  ? null
                                  : () => _favoriyiSil(favori),
                              icon: const Icon(
                                Icons.delete_outline_rounded,
                                size: 20,
                              ),
                            ),
                          ],
                        ],
                      ),
                      if (parcalar.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          child: Row(
                            children: [
                              for (final parca in parcalar)
                                Padding(
                                  padding: const EdgeInsets.only(right: 12),
                                  child: _ParcaGorunumu(
                                    gardirobum: gardirobum,
                                    parcaAdi: parca,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                      if (favori.tuyo.trim().isNotEmpty) ...[
                        const SizedBox(height: 14),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.auto_awesome_rounded,
                                size: 17,
                                color: colorScheme.tertiary,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  favori.tuyo,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontSize: 13,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w600,
                                    height: 1.4,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
    );
  }
}

class _SepetSheet extends StatefulWidget {
  final List<Kiyafet> Function() gardirobuGetir;
  final Color anaRenk;
  final FutureOr<void> Function(String)? onTekliSepettenCikar;
  final FutureOr<void> Function()? onSepetiTemizle;

  const _SepetSheet({
    required this.gardirobuGetir,
    required this.anaRenk,
    required this.onTekliSepettenCikar,
    required this.onSepetiTemizle,
  });

  @override
  State<_SepetSheet> createState() => _SepetSheetState();
}

class _SepetSheetState extends _IslemSheetState<_SepetSheet> {
  Future<void> _tekliCikar(String id) async {
    final callback = widget.onTekliSepettenCikar;
    if (callback == null || islemSuruyor) return;

    HapticFeedback.mediumImpact();

    await islemYap(() async {
      final halaSepette = widget.gardirobuGetir().any(
            (k) => k.id == id && k.sepetteMi,
          );

      if (!halaSepette) return;

      await Future<void>.sync(() => callback(id));
    });
  }

  Future<void> _tumunuTemizle() async {
    final callback = widget.onSepetiTemizle;
    if (callback == null || islemSuruyor) return;

    HapticFeedback.heavyImpact();

    final basarili = await islemYap(callback);
    if (basarili) modaliKapat();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    const temizVurgu = Color(0xFF2E7D32);

    final sepettekiler =
        widget.gardirobuGetir().where((k) => k.sepetteMi).toList();

    return _ModalCercevesi(
      baslik: '${l10n.camasirSepetiTitle} (${sepettekiler.length})',
      icon: Icons.local_laundry_service_rounded,
      iconColor: temizVurgu,
      islemSuruyor: islemSuruyor,
      yukseklikOrani: 0.80,
      altAlan: sepettekiler.isEmpty
          ? null
          : Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                  ),
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: colorScheme.error,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: islemSuruyor || widget.onSepetiTemizle == null
                      ? null
                      : _tumunuTemizle,
                  icon: const Icon(Icons.done_all_rounded, size: 22),
                  label: Text(
                    l10n.tumunuTemizIsaretle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),
      child: sepettekiler.isEmpty
          ? _BosDurum(
              icon: Icons.check_circle_outline_rounded,
              color: temizVurgu,
              message: l10n.sepetBosTumKiyafetlerTemiz,
            )
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              physics: const BouncingScrollPhysics(),
              itemCount: sepettekiler.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final item = sepettekiler[index];

                return _ModalKart(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      ProfilKiyafetGorseli(
                        kiyafet: item,
                        boyut: 60,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.gorunenBaslik,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w900,
                                fontSize: 15,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              '${item.kategori} • ${item.renk}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: colorScheme.onSurfaceVariant,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                      IconButton.filledTonal(
                        onPressed:
                            islemSuruyor || widget.onTekliSepettenCikar == null
                                ? null
                                : () => _tekliCikar(item.id),
                        style: IconButton.styleFrom(
                          backgroundColor: const Color(0xFFDCFCE7),
                          foregroundColor: const Color(0xFF15803D),
                        ),
                        icon: const Icon(
                          Icons.check_circle_outline_rounded,
                          size: 22,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
