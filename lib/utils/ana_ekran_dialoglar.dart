import 'dart:ui';
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../services/reklam_servisi.dart';
import '../services/satin_alma_servisi.dart';
import '../screens/reklamsiz_premium_ekrani.dart';
import '../../theme/design_tokens.dart';
import '../../theme/tema_yardimcilari.dart';

class AnaEkranDialoglar {
  static void _premiumEkraniniAc(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ReklamsizPremiumEkrani()),
    );
  }

  // 1. KUPON KODU GİRME DİYALOGU
  static void kuponKoduDiyaloguGoster({
    required BuildContext context,
    required Color anaRenk,
    required VoidCallback onHakGuncelle,
  }) {
    final l10n = AppLocalizations.of(context)!;
    final TextEditingController kuponController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final colors = Theme.of(ctx).colorScheme;

        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: AppBlur.cam, sigmaY: AppBlur.cam),
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: colors.surfaceContainerHigh,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.xl, AppSpacing.lg, AppSpacing.xl, AppSpacing.xxl),
              child: SafeArea(
                top: false,
                bottom: true,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 32,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: colors.outlineVariant,
                          borderRadius: AppRadius.xxsRadius,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.card_giftcard_rounded,
                          color: anaRenk,
                          size: 26,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            l10n.kuponKoduKullanTitle,
                            style: TextStyle(
                              fontSize: AppText.sizeTitleSmall,
                              fontWeight: FontWeight.w600,
                              color: context.uygunMetin,
                              letterSpacing: 0,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.kuponKoduAciklama,
                      style: TextStyle(
                        fontSize: AppText.sizeBodySmall,
                        color: context.uygunAltMetin,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: kuponController,
                      autofocus: true,
                      textCapitalization: TextCapitalization.characters,
                      style: TextStyle(color: context.uygunMetin),
                      decoration: InputDecoration(
                        hintText: l10n.kuponKoduHint,
                        hintStyle: TextStyle(color: context.uygunAltMetin),
                        prefixIcon: Icon(
                          Icons.confirmation_number_outlined,
                          color: anaRenk,
                        ),
                        filled: true,
                        fillColor: colors.surfaceContainerHighest,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                          vertical: AppSpacing.md,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: AppRadius.lgRadius,
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: Text(
                            l10n.vazgec,
                            style: TextStyle(
                              color: context.uygunMetin,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: AppAccents.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: AppRadius.lgRadius,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.xl,
                              vertical: AppSpacing.md,
                            ),
                          ),
                          onPressed: () async {
                            final kod = kuponController.text.trim();
                            if (kod.isEmpty) return;
                            final sonuc =
                                await ReklamServisi().kuponKoduKullan(kod);
                            if (!ctx.mounted) return;
                            Navigator.pop(ctx);

                            if (sonuc == 1) {
                              onHakGuncelle();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    l10n.kuponBasariliMesaji,
                                    style: TextStyle(
                                      color: colors.onPrimaryContainer,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  backgroundColor: colors.primaryContainer,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: AppRadius.lgRadius,
                                  ),
                                ),
                              );
                            } else if (sonuc == -1) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    l10n.kuponKullanilmisUyari,
                                    style: TextStyle(
                                      color: colors.onTertiaryContainer,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  backgroundColor: colors.tertiaryContainer,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: AppRadius.lgRadius,
                                  ),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    l10n.kuponGecersizUyari,
                                    style: TextStyle(
                                      color: colors.onErrorContainer,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  backgroundColor: colors.errorContainer,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: AppRadius.lgRadius,
                                  ),
                                ),
                              );
                            }
                          },
                          child: Text(
                            l10n.kuponKullanButon,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
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
      },
    );
  }

  // 2. ENERJİ/HAK DETAY MODALI
  static void hakDetayVeKuponModalGoster({
    required BuildContext context,
    required Color anaRenk,
    required int kalanHak,
    required VoidCallback onHakGuncelle,
  }) {
    final l10n = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final colors = Theme.of(ctx).colorScheme;

        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: AppBlur.cam, sigmaY: AppBlur.cam),
          child: Container(
            decoration: BoxDecoration(
              color: colors.surfaceContainerHigh,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(28),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl, AppSpacing.lg, AppSpacing.xl, AppSpacing.xxl),
            child: SafeArea(
              top: false,
              bottom: true,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 32,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: colors.outlineVariant,
                      borderRadius: AppRadius.xxsRadius,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.bolt_rounded,
                        color: AppAccents.warning,
                        size: 28,
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          kalanHak >= 99999
                              ? l10n.sinirsizIslemHakkiBaslik
                              : l10n.kalanHakkinizBaslik(kalanHak),
                          style: TextStyle(
                            fontSize: AppText.sizeTitleSmall,
                            fontWeight: FontWeight.w600,
                            color: context.uygunMetin,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    kalanHak >= 99999
                        ? (ReklamServisi.lansmanUcretsizMi
                            ? l10n.lansmanSinirsizAciklama
                            : l10n.sinirsizHakAciklama)
                        : l10n.gunlukHakAciklama,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: AppText.sizeBodySmall,
                      color: context.uygunAltMetin,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      if (ReklamServisi.kuponAktifMi) ...[
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                vertical: AppSpacing.md,
                                horizontal: AppSpacing.xs,
                              ),
                              side: BorderSide(color: context.uygunMetin),
                              shape: RoundedRectangleBorder(
                                borderRadius: AppRadius.lgRadius,
                              ),
                            ),
                            icon: Icon(
                              Icons.confirmation_number_outlined,
                              color: context.uygunMetin,
                              size: 18,
                            ),
                            label: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                l10n.kuponKullan,
                                style: TextStyle(
                                  color: context.uygunMetin,
                                  fontWeight: FontWeight.w600,
                                  fontSize: AppText.sizeBodySmall,
                                ),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(ctx);
                              kuponKoduDiyaloguGoster(
                                context: context,
                                anaRenk: anaRenk,
                                onHakGuncelle: onHakGuncelle,
                              );
                            },
                          ),
                        ),
                      ],
                      if (ReklamServisi.reklamlarEtkinMi) ...[
                        if (ReklamServisi.kuponAktifMi)
                          const SizedBox(width: 8),
                        Expanded(
                          child: FilledButton.icon(
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                vertical: AppSpacing.md,
                                horizontal: AppSpacing.xs,
                              ),
                              backgroundColor: AppAccents.warning,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: AppRadius.lgRadius,
                              ),
                            ),
                            icon: const Icon(
                              Icons.play_circle_fill_rounded,
                              size: 18,
                              color: Colors.white,
                            ),
                            label: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                l10n.reklamIzleHakKazan(
                                    ReklamServisi.reklamOduluKredi),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: AppText.sizeBodySmall,
                                  color: Colors.white,
                                ),
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
                                  onHakGuncelle();
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          l10n.hakEklendiTebrikler(
                                              ReklamServisi.reklamOduluKredi),
                                          style: TextStyle(
                                            color: colors.onSurface,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        backgroundColor:
                                            colors.surfaceContainerHigh,
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: AppRadius.lgRadius,
                                        ),
                                      ),
                                    );
                                  }
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
                  // Premium teklifi: hakların sınırlı olduğu en doğal anda
                  // gösterilir. Reklamsız (premium) kullanıcıda yeniden teklif
                  // edilmez.
                  if (SatinAlmaServisi.premiumSunuluyor &&
                      ReklamServisi.reklamlarEtkinMi &&
                      kalanHak < 99999) ...[
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: AppSpacing.md),
                          backgroundColor: anaRenk,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: AppRadius.lgRadius,
                          ),
                        ),
                        icon: const Icon(
                          Icons.workspace_premium_rounded,
                          size: 18,
                          color: Colors.white,
                        ),
                        label: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            l10n.premiumGec(
                              SatinAlmaServisi.ornek.aylikFiyat,
                            ),
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: AppText.sizeBodySmall,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(ctx);
                          _premiumEkraniniAc(context);
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // 3. GARDIROP LİMİTİ DOLDU DİYALOGU
  static void gardiropLimitiDolduDiyaloguGoster({
    required BuildContext context,
    required Color anaRenk,
    required int maxLimit,
  }) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      useRootNavigator: true,
      builder: (ctx) {
        final colors = Theme.of(ctx).colorScheme;

        return AlertDialog(
          backgroundColor: colors.surfaceContainerHigh,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.dialogRadius,
          ),
          title: Row(
            children: [
              Icon(Icons.checkroom_rounded, color: anaRenk, size: 26),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.gardirobunDolduTitle,
                  style: TextStyle(
                    fontSize: AppText.sizeTitleSmall,
                    fontWeight: FontWeight.w600,
                    color: context.uygunMetin,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.gardirobunDolduIcerik(
                    maxLimit, ReklamServisi.reklamOduluSlot),
                style: TextStyle(
                    fontSize: AppText.sizeBodySmall,
                    color: context.uygunAltMetin),
              ),
              const SizedBox(height: 20),
              // Birincil teklif: sınırsız gardırop. Ödüllü reklam ikincil.
              if (SatinAlmaServisi.premiumSunuluyor)
                FilledButton.icon(
                  icon: const Icon(Icons.workspace_premium_rounded, size: 18),
                  label: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      l10n.premiumGec(SatinAlmaServisi.ornek.aylikFiyat),
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  style: FilledButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(vertical: AppSpacing.md),
                    backgroundColor: AppAccents.successDark,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.mdRadius,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(ctx);
                    _premiumEkraniniAc(context);
                  },
                ),
              if (ReklamServisi.reklamlarEtkinMi) ...[
                if (SatinAlmaServisi.premiumSunuluyor)
                  const SizedBox(height: 8),
                OutlinedButton.icon(
                  icon: Icon(
                    Icons.play_circle_fill_rounded,
                    size: 18,
                    color: context.uygunMetin,
                  ),
                  label: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      l10n.reklamIzleSlotEkle(ReklamServisi.reklamOduluSlot),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: context.uygunMetin,
                      ),
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(vertical: AppSpacing.md),
                    side: BorderSide(color: context.uygunMetin),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.mdRadius,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(ctx);
                    ReklamServisi().odulluReklamGoster(
                      context: context,
                      onReward: (reward) async {
                        await ReklamServisi().reklamIzleyerekKiyafetLimitiEkle(
                            ReklamServisi.reklamOduluSlot);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                l10n.yeniSlotEklendiTebrikler(
                                    ReklamServisi.reklamOduluSlot),
                                style: TextStyle(
                                  color: colors.onSurface,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              backgroundColor: colors.surfaceContainerHigh,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: AppRadius.lgRadius,
                              ),
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
              ],
            ],
          ),
          actionsPadding: const EdgeInsets.fromLTRB(
              AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.lg),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                l10n.vazgec,
                style: TextStyle(
                  color: context.uygunMetin,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // 4. GÜNLÜK HAK BİTTİ DİYALOGU
  static void kombinHakkiBittiDiyaloguGoster({
    required BuildContext context,
    required Color anaRenk,
    required VoidCallback onHakGuncelle,
  }) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      useRootNavigator: true,
      builder: (ctx) {
        final colors = Theme.of(ctx).colorScheme;

        return AlertDialog(
          backgroundColor: colors.surfaceContainerHigh,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.dialogRadius,
          ),
          title: Row(
            children: [
              Icon(Icons.bolt_rounded, color: AppAccents.warning, size: 26),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.gunlukHakBittiTitle,
                  style: TextStyle(
                    fontSize: AppText.sizeTitleSmall,
                    fontWeight: FontWeight.w600,
                    color: context.uygunMetin,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.gunlukHakBittiIcerik,
                style: TextStyle(
                    fontSize: AppText.sizeBodySmall,
                    color: context.uygunAltMetin),
              ),
              const SizedBox(height: 20),
              // Birincil teklif: sınırsız kullanım. Ödüllü reklam premium'un
              // yerine geçmesin diye ikincil (çerçeveli) görünümde sunulur.
              if (SatinAlmaServisi.premiumSunuluyor)
                FilledButton.icon(
                  icon: const Icon(Icons.workspace_premium_rounded, size: 18),
                  label: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      l10n.premiumGec(SatinAlmaServisi.ornek.aylikFiyat),
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  style: FilledButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(vertical: AppSpacing.md),
                    backgroundColor: AppAccents.successDark,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.mdRadius,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(ctx);
                    _premiumEkraniniAc(context);
                  },
                ),
              if (ReklamServisi.reklamlarEtkinMi) ...[
                if (SatinAlmaServisi.premiumSunuluyor)
                  const SizedBox(height: 8),
                OutlinedButton.icon(
                  icon: Icon(
                    Icons.play_circle_fill_rounded,
                    size: 18,
                    color: context.uygunMetin,
                  ),
                  label: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      l10n.reklamIzleHakKazan(ReklamServisi.reklamOduluKredi),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: context.uygunMetin,
                      ),
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(vertical: AppSpacing.md),
                    side: BorderSide(color: context.uygunMetin),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.mdRadius,
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
                        onHakGuncelle();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                l10n.hakEklendiTebrikler(
                                    ReklamServisi.reklamOduluKredi),
                                style: TextStyle(
                                  color: colors.onSurface,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              backgroundColor: colors.surfaceContainerHigh,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: AppRadius.lgRadius,
                              ),
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
              ],
            ],
          ),
          actionsPadding: const EdgeInsets.fromLTRB(
              AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.lg),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                l10n.dahaSonra,
                style: TextStyle(
                  color: context.uygunMetin,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
