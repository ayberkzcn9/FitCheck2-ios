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
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
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
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
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
                          borderRadius: BorderRadius.circular(2),
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
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: context.uygunMetin,
                              letterSpacing: -0.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.kuponKoduAciklama,
                      style: TextStyle(
                        fontSize: 14,
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
                          horizontal: 16,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
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
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 22,
                              vertical: 12,
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
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  backgroundColor: colors.primaryContainer,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
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
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  backgroundColor: colors.tertiaryContainer,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
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
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  backgroundColor: colors.errorContainer,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                              );
                            }
                          },
                          child: Text(
                            l10n.kuponKullanButon,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
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
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            decoration: BoxDecoration(
              color: colors.surfaceContainerHigh,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(28),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
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
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.bolt_rounded,
                        color: Colors.amber[700],
                        size: 28,
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          kalanHak >= 99999
                              ? l10n.sinirsizIslemHakkiBaslik
                              : l10n.kalanHakkinizBaslik(kalanHak),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
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
                        ? l10n.sinirsizHakAciklama
                        : l10n.gunlukHakAciklama,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: context.uygunAltMetin,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 4,
                            ),
                            side: BorderSide(color: context.uygunMetin),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
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
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
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
                      if (ReklamServisi.reklamlarEtkinMi) ...[
                        const SizedBox(width: 8),
                        Expanded(
                          child: FilledButton.icon(
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 4,
                              ),
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
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
                                l10n.reklamIzleHakKazan,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
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
                                          l10n.hakEklendiTebrikler,
                                          style: TextStyle(
                                            color: colors.onSurface,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        backgroundColor:
                                            colors.surfaceContainerHigh,
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
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
                  if (ReklamServisi.reklamlarEtkinMi && kalanHak < 99999) ...[
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: anaRenk,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
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
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
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
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
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
                l10n.gardirobunDolduIcerik(maxLimit),
                style: TextStyle(fontSize: 14, color: context.uygunAltMetin),
              ),
              const SizedBox(height: 20),
              // Birincil teklif: sınırsız gardırop. Ödüllü reklam ikincil.
              FilledButton.icon(
                icon: const Icon(Icons.workspace_premium_rounded, size: 18),
                label: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    l10n.premiumGec(SatinAlmaServisi.ornek.aylikFiyat),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
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
              if (ReklamServisi.reklamlarEtkinMi) ...[
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
                      l10n.reklamIzleSlotEkle,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: context.uygunMetin,
                      ),
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(color: context.uygunMetin),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
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
                                l10n.yeniSlotEklendiTebrikler,
                                style: TextStyle(
                                  color: colors.onSurface,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              backgroundColor: colors.surfaceContainerHigh,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
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
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                l10n.vazgec,
                style: TextStyle(
                  color: context.uygunMetin,
                  fontWeight: FontWeight.bold,
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
              Icon(Icons.bolt_rounded, color: Colors.amber[700], size: 26),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.gunlukHakBittiTitle,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
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
                style: TextStyle(fontSize: 14, color: context.uygunAltMetin),
              ),
              const SizedBox(height: 20),
              // Birincil teklif: sınırsız kullanım. Ödüllü reklam premium'un
              // yerine geçmesin diye ikincil (çerçeveli) görünümde sunulur.
              FilledButton.icon(
                icon: const Icon(Icons.workspace_premium_rounded, size: 18),
                label: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    l10n.premiumGec(SatinAlmaServisi.ornek.aylikFiyat),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
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
              if (ReklamServisi.reklamlarEtkinMi) ...[
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
                      l10n.reklamIzleHakKazan,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: context.uygunMetin,
                      ),
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(color: context.uygunMetin),
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
                        onHakGuncelle();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                l10n.hakEklendiTebrikler,
                                style: TextStyle(
                                  color: colors.onSurface,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              backgroundColor: colors.surfaceContainerHigh,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
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
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                l10n.dahaSonra,
                style: TextStyle(
                  color: context.uygunMetin,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}