import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../l10n/app_localizations.dart';
import '../models/kiyafet.dart';
import '../services/reklam_servisi.dart';
import '../services/satin_alma_servisi.dart';
import '../screens/reklamsiz_premium_ekrani.dart';
import '../../theme/design_tokens.dart';
import '../../theme/tema_yardimcilari.dart';

class HaftalikDialoglar {
  static void _premiumEkraniniAc(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ReklamsizPremiumEkrani()),
    );
  }

  // 1. KOMBİN HAKKI BİTTİ (REKLAM) DİYALOGU
  static void kombinHakkiBittiGoster({
    required BuildContext context,
    required Color anaRenk,
    required VoidCallback onHakKazanildi,
  }) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (ctx) {
        final colors = Theme.of(ctx).colorScheme;

        return AlertDialog(
          backgroundColor: colors.surfaceContainerHigh,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.dialogRadius,
          ),
          title: Row(
            children: [
              const Icon(
                Icons.bolt_rounded,
                color: Colors.orange,
                size: 28,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.gunlukHakBittiBaslik,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: context.uygunMetin,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          content: Text(
            l10n.gunlukHakBittiIcerik,
            style: TextStyle(
              fontSize: 14,
              color: context.uygunAltMetin,
            ),
          ),
          actions: [
            FilledButton.icon(
              icon: const Icon(Icons.workspace_premium_rounded, size: 20),
              label: Text(
                l10n.premiumGec(SatinAlmaServisi.varsayilanFiyat),
              ),
              style: FilledButton.styleFrom(
                backgroundColor: AppAccents.successDark,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.pop(ctx);
                _premiumEkraniniAc(context);
              },
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                l10n.dahaSonra,
                style: TextStyle(
                  color: context.uygunAltMetin,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (ReklamServisi.reklamlarEtkinMi)
              FilledButton.icon(
                icon: const Icon(
                  Icons.play_circle_fill_rounded,
                  size: 20,
                  color: Colors.white,
                ),
                label: Text(
                  l10n.reklamIzleHakKazan,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(ctx);
                  ReklamServisi().odulluReklamGoster(
                    context: context,
                    onReward: (reward) async {
                      await ReklamServisi().reklamIzleyerekHakEkle(
                        ReklamServisi.reklamOduluKredi,
                      );
                      onHakKazanildi();
                    },
                  );
                },
              ),
          ],
        );
      },
    );
  }

  // 2. TATLI UYARI DİYALOGU (Hata / Bilgilendirme)
  static void tatliUyariGoster({
    required BuildContext context,
    required String baslik,
    required String mesaj,
    required Color anaRenk,
  }) {
    HapticFeedback.heavyImpact();
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      builder: (ctx) {
        final colors = Theme.of(ctx).colorScheme;

        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: AlertDialog(
            backgroundColor: colors.surfaceContainerHigh,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: AppRadius.dialogRadius,
            ),
            title: Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: colors.tertiary,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    baslik,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                      color: context.uygunMetin,
                    ),
                  ),
                ),
              ],
            ),
            content: Text(
              mesaj,
              style: TextStyle(
                fontSize: 16,
                color: context.uygunAltMetin,
                height: 1.4,
              ),
            ),
            actions: [
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: anaRenk,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                ),
                onPressed: () {
                  HapticFeedback.selectionClick();
                  Navigator.pop(ctx);
                },
                child: Text(
                  l10n.haftalikUyariButon,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // 3. NET GÖRSEL (DETAY) MODALI
  static Future<void> netGorselModalGoster({
    required BuildContext context,
    required Color anaRenk,
    required List<dynamic> tumParcalarMetinleri,
    required int baslangicIndex,
    required Map<String, String> Function(String, AppLocalizations) parcaBilgisiAyristir,
    required Uint8List? Function(String) gucluGorselBul,
  }) async {
    HapticFeedback.lightImpact();
    final l10n = AppLocalizations.of(context)!;

    await showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.7),
      builder: (ctx) {
        int mevcutIndex = baslangicIndex;
        final PageController pageController =
            PageController(initialPage: baslangicIndex);

        return StatefulBuilder(
          builder: (dialogContext, setModalState) {
            final colors = Theme.of(dialogContext).colorScheme;
            final mevcutMetin = tumParcalarMetinleri[mevcutIndex].toString();
            final bilgi = parcaBilgisiAyristir(mevcutMetin, l10n);

            return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Dialog(
                backgroundColor: colors.surfaceContainerHigh,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadius.dialogRadius,
                ),
                insetPadding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 24,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Stack(
                        alignment: Alignment.topRight,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(28),
                            ),
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(
                                maxHeight: 320,
                                minHeight: 200,
                              ),
                              child: PageView.builder(
                                controller: pageController,
                                physics: const BouncingScrollPhysics(),
                                itemCount: tumParcalarMetinleri.length,
                                onPageChanged: (idx) {
                                  HapticFeedback.selectionClick();
                                  setModalState(() {
                                    mevcutIndex = idx;
                                  });
                                },
                                itemBuilder: (context, pageIdx) {
                                  final pMetin =
                                      tumParcalarMetinleri[pageIdx].toString();
                                  final pBytes = gucluGorselBul(pMetin);

                                  return pBytes != null
                                      ? Image.memory(
                                          pBytes,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        )
                                      : Container(
                                          color: colors.surfaceContainerHighest,
                                          child: Icon(
                                            Icons.checkroom_rounded,
                                            size: 80,
                                            color: anaRenk,
                                          ),
                                        );
                                },
                              ),
                            ),
                          ),
                          Positioned(
                            top: 12,
                            right: 12,
                            child: ClipRRect(
                              borderRadius: AppRadius.xlRadius,
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: colors.surfaceContainerHighest
                                        .withValues(alpha: 0.7),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: colors.outlineVariant
                                          .withValues(alpha: 0.5),
                                    ),
                                  ),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.close_rounded,
                                      color: context.uygunMetin,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      HapticFeedback.selectionClick();
                                      Navigator.pop(ctx);
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (tumParcalarMetinleri.length > 1)
                            Positioned(
                              bottom: 12,
                              left: 0,
                              right: 0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  tumParcalarMetinleri.length,
                                  (dotIdx) {
                                    bool isActive = dotIdx == mevcutIndex;
                                    return AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 3,
                                      ),
                                      height: 6,
                                      width: isActive ? 20 : 6,
                                      decoration: BoxDecoration(
                                        color: isActive
                                            ? colors.primary
                                            : colors.outlineVariant,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: colors.surfaceContainerHigh,
                          borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(28),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    l10n.parcaDetayiBaslik,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 1.5,
                                      color: anaRenk,
                                    ),
                                  ),
                                ),
                                if (tumParcalarMetinleri.length > 1)
                                  Text(
                                    "${mevcutIndex + 1} / ${tumParcalarMetinleri.length}",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: context.uygunAltMetin,
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              bilgi['baslik']!,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.3,
                                color: context.uygunMetin,
                                height: 1.2,
                              ),
                            ),
                            if (bilgi['kategori']!.isNotEmpty ||
                                bilgi['renk']!.isNotEmpty ||
                                bilgi['stil']!.isNotEmpty) ...[
                              const SizedBox(height: 16),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  _etiketCipi(
                                    dialogContext,
                                    Icons.category_rounded,
                                    bilgi['kategori']!,
                                    colors.primary,
                                  ),
                                  _etiketCipi(
                                    dialogContext,
                                    Icons.color_lens_rounded,
                                    bilgi['renk']!,
                                    colors.secondary,
                                  ),
                                  _etiketCipi(
                                    dialogContext,
                                    Icons.style_rounded,
                                    bilgi['stil']!,
                                    colors.tertiary,
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  static Widget _etiketCipi(
    BuildContext context,
    IconData ikon,
    String metin,
    Color softRenk,
  ) {
    if (metin.isEmpty) return const SizedBox.shrink();
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colors.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(ikon, size: 16, color: softRenk),
          const SizedBox(width: 8),
          Text(
            metin,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: context.uygunMetin,
            ),
          ),
        ],
      ),
    );
  }

  // 4. PARÇA DEĞİŞTİR MODALI
  static void parcaDegistirModalGoster({
    required BuildContext context,
    required Color anaRenk,
    required String modalBaslik,
    required List<Kiyafet> secenekler,
    required List<Kiyafet> temizKiyafetler,
    required String Function(String) kategoriModeldenCikar,
    required Future<bool> Function()? onTekliKiyafetDegistir,
    required Function(String) onSecim,
  }) {
    HapticFeedback.lightImpact();
    final l10n = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        final colors = Theme.of(ctx).colorScheme;

        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            padding: const EdgeInsets.only(top: 20, left: 24, right: 24),
            height: MediaQuery.of(context).size.height * 0.65,
            decoration: BoxDecoration(
              color: colors.surfaceContainerHigh,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(32),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 48,
                    height: 5,
                    decoration: BoxDecoration(
                      color: colors.outlineVariant,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        modalBaslik,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.3,
                          color: context.uygunMetin,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.close_rounded,
                        size: 28,
                        color: context.uygunMetin,
                      ),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (secenekler.isEmpty)
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.style_outlined,
                            size: 64,
                            color: colors.outline,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            l10n.baskaTemizKiyafetYok,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: context.uygunAltMetin,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: secenekler.length,
                      itemBuilder: (context, index) {
                        final item = secenekler[index];
                        int gercekIndex =
                            temizKiyafetler.indexWhere((k) => k == item);
                        if (gercekIndex == -1) gercekIndex = 0;

                        final katGosterim =
                            kategoriModeldenCikar(item.kategori);
                        final yeniMetin =
                            "Clean Item #${gercekIndex + 1}: ${item.baslik} [Category: $katGosterim] (Color: ${item.renk}, Style: ${item.stil})";

                        return GestureDetector(
                          onTap: () async {
                            HapticFeedback.mediumImpact();

                            if (onTekliKiyafetDegistir != null) {
                              final bool izin = await onTekliKiyafetDegistir();
                              if (!izin) return;
                            }

                            if (ctx.mounted) {
                              Navigator.pop(ctx);
                            }
                            onSecim(yeniMetin);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: colors.outlineVariant
                                    .withValues(alpha: 0.5),
                                width: 1.5,
                              ),
                              color: colors.surfaceContainer,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(14.5),
                              child: Image.memory(
                                item.resimBytes,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
