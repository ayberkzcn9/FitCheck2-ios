import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../l10n/app_localizations.dart';

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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      backgroundColor: colors.surfaceContainerHigh,
      elevation: 0,
      title: Row(
        children: [
          Icon(Icons.privacy_tip_rounded, color: colors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              l10n.gizlilikPolitikasiTitle,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 18,
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
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: colors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 14),
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
            ],
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      actions: [
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF2E7D32),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () => Navigator.pop(context),
          child: Text(
            l10n.anladim,
            style: const TextStyle(fontWeight: FontWeight.bold),
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
              fontWeight: FontWeight.w800,
              fontSize: 13,
              color: colors.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            icerik,
            style: TextStyle(
              fontSize: 12.5,
              height: 1.4,
              color: colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
