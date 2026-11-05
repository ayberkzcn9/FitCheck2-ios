import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../theme/design_tokens.dart';

/// İlk AI kullanımından önce gösterilen açık rıza penceresi.
class AiOnayModal {
  AiOnayModal._();

  static Future<bool> goster(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;

    final sonuc = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: colors.surfaceContainerHigh,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.dialogRadius),
        title: Row(
          children: [
            Icon(Icons.auto_awesome_rounded, color: colors.primary, size: 24),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                l10n.aiOnayBaslik,
                style: TextStyle(
                  fontSize: AppText.sizeTitleSmall,
                  fontWeight: FontWeight.w600,
                  color: colors.onSurface,
                ),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Text(
            l10n.aiOnayIcerik,
            style: TextStyle(
              fontSize: AppText.sizeBodySmall,
              height: 1.5,
              color: colors.onSurfaceVariant,
            ),
          ),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          0,
          AppSpacing.lg,
          AppSpacing.lg,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(
              l10n.aiOnayVazgec,
              style: TextStyle(color: colors.onSurfaceVariant),
            ),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(l10n.aiOnayKabul),
          ),
        ],
      ),
    );

    return sonuc == true;
  }
}
