// Zar Salla Dialog - İlk açılışta gösterilen "telefonu salla" tutorial popup'ı
// Haftalık ve günlük kombin ekranlarında paylaşılır.

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';

import '../l10n/app_localizations.dart';
import '../../theme/design_tokens.dart';

class ZarSallaDialog extends StatelessWidget {
  final VoidCallback onZarAtildi;

  const ZarSallaDialog({super.key, required this.onZarAtildi});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: AppBlur.cam, sigmaY: AppBlur.cam),
      child: Dialog(
        backgroundColor: colors.surfaceContainerHigh,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.modalRadius,
          side: BorderSide(color: colors.outlineVariant.withValues(alpha: 0.4)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: AppAccents.success.withValues(alpha: 0.15),
                      borderRadius: AppRadius.xlRadius,
                      border: Border.all(
                        color: AppAccents.success.withValues(alpha: 0.4),
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.casino_rounded,
                      size: 40,
                      color: AppAccents.success,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: colors.primary.withValues(alpha: 0.15),
                      borderRadius: AppRadius.xlRadius,
                      border: Border.all(
                        color: colors.primary.withValues(alpha: 0.4),
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.casino_rounded,
                      size: 40,
                      color: colors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                l10n.zarPopupBaslik,
                style: TextStyle(
                  fontSize: AppText.sizeTitle,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                  color: colors.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.zarPopupAciklama,
                style: TextStyle(
                  fontSize: AppText.sizeBodySmall,
                  height: 1.4,
                  fontWeight: FontWeight.w500,
                  color: colors.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        HapticFeedback.selectionClick();
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                        shape: RoundedRectangleBorder(
                          borderRadius: AppRadius.lgRadius,
                        ),
                      ),
                      child: Text(
                        l10n.iptal,
                        style: TextStyle(
                          color: colors.onSurfaceVariant,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        HapticFeedback.heavyImpact();
                        Vibration.vibrate(duration: 120);
                        Navigator.pop(context);
                        onZarAtildi();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppAccents.success,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                        shape: RoundedRectangleBorder(
                          borderRadius: AppRadius.lgRadius,
                        ),
                      ),
                      icon: const Icon(Icons.casino_rounded, size: 20),
                      label: Text(
                        l10n.zarlariAt,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: AppText.sizeBodySmall,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}