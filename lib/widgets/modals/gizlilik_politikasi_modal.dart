import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../l10n/app_localizations.dart';
import '../../../theme/design_tokens.dart';

class GizlilikPolitikasiModal extends StatelessWidget {
  const GizlilikPolitikasiModal({super.key});

  /// Modal'ı kolayca çağırmak için statik metot
  static void goster(BuildContext context) {
    HapticFeedback.lightImpact();
    showDialog<void>(
      context: context,
      builder: (ctx) => const GizlilikPolitikasiModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: AppRadius.dialogRadius),
      backgroundColor: colors.surfaceContainerHigh,
      elevation: 0,
      title: Row(
        children: [
          Icon(Icons.privacy_tip_rounded, color: colors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              l10n.gizlilikPolitikasiTitle,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: AppText.sizeTitleSmall,
                color: colors.onSurface,
              ),
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.sonGuncellemeTarihi,
                style: TextStyle(
                  fontSize: AppText.sizeCaption,
                  fontWeight: FontWeight.w600,
                  color: colors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              _politikaParagraf(
                context,
                l10n.gizlilikMadde1Baslik,
                l10n.gizlilikMadde1Icerik,
              ),
              _politikaParagraf(
                context,
                l10n.gizlilikMadde2Baslik,
                l10n.gizlilikMadde2Icerik,
              ),
              _politikaParagraf(
                context,
                l10n.gizlilikMadde3Baslik,
                l10n.gizlilikMadde3Icerik,
              ),
              _politikaParagraf(
                context,
                l10n.gizlilikMadde4Baslik,
                l10n.gizlilikMadde4Icerik,
              ),
              _politikaParagraf(
                context,
                l10n.gizlilikMadde5Baslik,
                l10n.gizlilikMadde5Icerik,
              ),
            ],
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(
          AppSpacing.xl, 0, AppSpacing.xl, AppSpacing.xl),
      actions: [
        // Tam politika HTTPS üzerinde yayınlanır; mağaza denetimi için
        // uygulama içinden tıklanabilir bir bağlantı gerekir.
        TextButton(
          onPressed: () async {
            final uri = Uri.parse(
              'https://ayberkzcn9.github.io/fitcheck-privacy/',
            );
            try {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            } catch (e) {
              debugPrint('Gizlilik politikası açılamadı: $e');
            }
          },
          child: Text(l10n.gizlilikPolitikasiTamamiAc),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: AppAccents.successDark,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: AppRadius.mdRadius,
            ),
          ),
          onPressed: () => Navigator.pop(context),
          child: Text(
            l10n.anladim,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _politikaParagraf(
    BuildContext context,
    String baslik,
    String icerik,
  ) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            baslik,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: AppText.sizeBodySmall,
              color: colors.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            icerik,
            style: TextStyle(
              fontSize: AppText.sizeCaption,
              height: 1.4,
              color: colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
