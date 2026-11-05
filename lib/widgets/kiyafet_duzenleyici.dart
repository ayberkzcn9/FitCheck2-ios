// Kesilmiş kıyafeti tuvale yerleştirme ve arka plan seçme editörü.
//
// Kullanıcı, dolaba eklenen parçanın dolap ızgarasında nasıl görüneceğini
// burada belirler: zemin rengini seçer, parçayı sürükleyip büyüterek
// yerleştirir. "Varsayılan" derse hiçbir değişiklik yapılmaz.

import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../services/kiyafet_arka_plan_ozellestirici.dart';
import '../theme/design_tokens.dart';

class KiyafetDuzenleyici extends StatefulWidget {
  const KiyafetDuzenleyici({
    super.key,
    required this.kesim,
    this.birlestirici,
  });

  /// Arka planı silinmiş (şeffaf) PNG.
  final Uint8List kesim;

  /// Arayüz testlerinde izolasyon tabanlı görsel kodlamasını taklit eder.
  /// Üretimde verilmez; gerçek birleştirme servisi kullanılır.
  @visibleForTesting
  final Future<Uint8List> Function(Uint8List kesim)? birlestirici;

  /// Editörü açar; kullanıcı "Varsayılan" derse `null`, kaydederse birleşmiş
  /// görseli döndürür.
  static Future<Uint8List?> ac(
    BuildContext context, {
    required Uint8List kesim,
    @visibleForTesting
    Future<Uint8List> Function(Uint8List kesim)? birlestirici,
  }) {
    return showModalBottomSheet<Uint8List>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => KiyafetDuzenleyici(
        kesim: kesim,
        birlestirici: birlestirici,
      ),
    );
  }

  @override
  State<KiyafetDuzenleyici> createState() => _KiyafetDuzenleyiciState();
}

class _KiyafetDuzenleyiciState extends State<KiyafetDuzenleyici> {
  KirmaZemin _zemin = KirmaZemin.beyaz;

  /// Tuvâla sığdırma çarpanı (1 = tam sığdırılmış).
  double _olcek = 1;

  /// Kayma, tuval boyutunun oranı cinsinden.
  double _konumX = 0;
  double _konumY = 0;

  double _baslangicOlcek = 1;
  double _baslangicKonumX = 0;
  double _baslangicKonumY = 0;
  Offset _baslangicOdak = Offset.zero;

  bool _kaydediliyor = false;

  static const double _enKucukOlcek = 0.4;
  static const double _enBuyukOlcek = 2.5;

  void _olcekBaslat(ScaleStartDetails details) {
    _baslangicOlcek = _olcek;
    _baslangicKonumX = _konumX;
    _baslangicKonumY = _konumY;
    _baslangicOdak = details.localFocalPoint;
  }

  void _olcekGuncelle(ScaleUpdateDetails details) {
    final odakFarki = details.localFocalPoint - _baslangicOdak;

    setState(() {
      _olcek = (_baslangicOlcek * details.scale).clamp(
        _enKucukOlcek,
        _enBuyukOlcek,
      );
      _konumX = (_baslangicKonumX + odakFarki.dx / 240).clamp(-0.6, 0.6);
      _konumY = (_baslangicKonumY + odakFarki.dy / 240).clamp(-0.6, 0.6);
    });
  }

  Future<void> _kaydet() async {
    setState(() => _kaydediliyor = true);
    try {
      final birlestirici = widget.birlestirici;
      final sonuc = birlestirici != null
          ? await birlestirici(widget.kesim)
          : await KiyafetArkaPlanOzellestirici.birlestir(
              widget.kesim,
              zemin: _zemin,
              olcek: _olcek,
              konumX: _konumX,
              konumY: _konumY,
            );
      if (!mounted) return;
      Navigator.of(context).pop(sonuc);
    } catch (_) {
      if (!mounted) return;
      setState(() => _kaydediliyor = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final zeminRengi = KiyafetArkaPlanOzellestirici.zeminRengi(_zemin);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.lg),
        child: Container(
          decoration: BoxDecoration(
            color: colors.surfaceContainerHigh,
            borderRadius: AppRadius.xxlRadius,
          ),
          padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.md),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.duzenleArkaPlanBaslik,
                  style: TextStyle(
                    fontSize: AppText.sizeBodyLarge,
                    fontWeight: FontWeight.w600,
                    color: colors.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.duzenleIpucu,
                  style: TextStyle(
                    fontSize: AppText.sizeCaption,
                    color: colors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 14),
                Center(
                  child: LayoutBuilder(
                    builder: (context, kisit) {
                      // Tuval hem ekrana sığar hem kare kalır.
                      final boyut =
                          kisit.maxWidth > 320 ? 320.0 : kisit.maxWidth;
                      return GestureDetector(
                        key: const Key('kiyafet-duzenleyici-tuval'),
                        onScaleStart: _olcekBaslat,
                        onScaleUpdate: _olcekGuncelle,
                        child: Container(
                          width: boyut,
                          height: boyut,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            color: zeminRengi == null
                                ? colors.surfaceContainerHighest
                                : Color(zeminRengi),
                            borderRadius: BorderRadius.circular(AppRadius.xl),
                            border: Border.all(
                              color:
                                  colors.outlineVariant.withValues(alpha: 0.5),
                            ),
                          ),
                          child: Transform.translate(
                            offset: Offset(
                              _konumX * boyut,
                              _konumY * boyut,
                            ),
                            child: Transform.scale(
                              scale: _olcek,
                              child: Padding(
                                padding: const EdgeInsets.all(AppSpacing.sm),
                                child: Image.memory(
                                  widget.kesim,
                                  fit: BoxFit.contain,
                                  gaplessPlayback: true,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _zeminCipi(
                      l10n.duzenleZeminBeyaz,
                      KirmaZemin.beyaz,
                      colors,
                    ),
                    _zeminCipi(
                      l10n.duzenleZeminKirik,
                      KirmaZemin.kirikBeyaz,
                      colors,
                    ),
                    _zeminCipi(
                      l10n.duzenleZeminGri,
                      KirmaZemin.acikGri,
                      colors,
                    ),
                    _zeminCipi(
                      l10n.duzenleZeminSaydam,
                      KirmaZemin.saydam,
                      colors,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: _kaydediliyor
                            ? null
                            : () => Navigator.of(context).pop(),
                        child: Text(l10n.duzenleVarsayilan),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: FilledButton(
                        onPressed: _kaydediliyor ? null : _kaydet,
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(0, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: AppRadius.mdRadius,
                          ),
                        ),
                        child: _kaydediliyor
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(l10n.duzenleKaydet),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _zeminCipi(
    String etiket,
    KirmaZemin zemin,
    ColorScheme colors,
  ) {
    final secili = _zemin == zemin;
    final renk = KiyafetArkaPlanOzellestirici.zeminRengi(zemin);

    return ChoiceChip(
      label: Text(etiket),
      selected: secili,
      showCheckmark: false,
      visualDensity: VisualDensity.compact,
      side: BorderSide(
        color: secili ? colors.primary : colors.outlineVariant,
      ),
      avatar: Container(
        width: 14,
        height: 14,
        decoration: BoxDecoration(
          color: renk == null ? colors.surfaceContainerHighest : Color(renk),
          shape: BoxShape.circle,
          border: Border.all(
            color: colors.outlineVariant.withValues(alpha: 0.6),
          ),
        ),
      ),
      onSelected: (_) => setState(() => _zemin = zemin),
    );
  }
}
