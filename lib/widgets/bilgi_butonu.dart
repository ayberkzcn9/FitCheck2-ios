// Küçük "bilgi" butonu ve açtığı açıklama sayfası.
//
// Profil & Analiz ekranındaki ölçütler (verimlilik, seri, renk paleti...)
// kullanıcı için ne anlama geldiği açık değildi. Başlığın yanına konan bu
// küçük düğme, dokununca o metriği kendi dilimizle anlatır.

import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/design_tokens.dart';

/// Başlıkların yanında görünen bilgi düğmesi.
class BilgiButonu extends StatelessWidget {
  const BilgiButonu({
    super.key,
    required this.baslik,
    required this.aciklama,
    this.ikon = Icons.info_outline_rounded,
    this.renk,
  });

  /// Açılacak sayfanın başlığı (ölçütün adı).
  final String baslik;

  /// Açılacak sayfanın metni.
  final String aciklama;

  final IconData ikon;

  /// Simgenin rengi; verilmezse kartın ikincil metin rengi kullanılır.
  final Color? renk;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Tooltip(
      message: baslik,
      child: Material(
        // Bazı ekranlarda düğme, Material olmayan bir Container içinde
        // duruyor; InkResponse için Material atası şart.
        type: MaterialType.transparency,
        child: InkResponse(
          onTap: () => BilgiSayfasi.goster(
            context,
            baslik: baslik,
            aciklama: aciklama,
          ),
          radius: 18,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xs),
            child: Icon(
              ikon,
              size: 16,
              color: renk ?? colors.onSurfaceVariant.withValues(alpha: 0.8),
            ),
          ),
        ),
      ),
    );
  }
}

/// Ölçütün ne anlama geldiğini anlatan alt sayfa.
class BilgiSayfasi {
  const BilgiSayfasi._();

  static Future<void> goster(
    BuildContext context, {
    required String baslik,
    required String aciklama,
  }) {
    final colors = Theme.of(context).colorScheme;

    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.lg),
            child: ClipRRect(
              borderRadius: AppRadius.xxlRadius,
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: AppBlur.cam,
                  sigmaY: AppBlur.cam,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: colors.surfaceContainerHigh.withValues(alpha: 0.92),
                    borderRadius: AppRadius.xxlRadius,
                  ),
                  padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.md, AppSpacing.xl, AppSpacing.lg),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 36,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: colors.onSurfaceVariant.withValues(alpha: 0.3),
                            borderRadius: AppRadius.xxsRadius,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            decoration: BoxDecoration(
                              color: colors.primary.withValues(alpha: 0.08),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.info_outline_rounded,
                              size: 22,
                              color: colors.primary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              baslik,
                              style: TextStyle(
                                fontSize: AppText.sizeTitleSmall,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.3,
                                color: colors.onSurface,
                              ),
                            ),
                          ),
                          IconButton(
                            tooltip: MaterialLocalizations.of(sheetContext)
                                .closeButtonTooltip,
                            onPressed: () => Navigator.of(sheetContext).pop(),
                            icon: const Icon(Icons.close_rounded),
                            visualDensity: VisualDensity.compact,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        aciklama,
                        style: TextStyle(
                          fontSize: AppText.sizeBodySmall,
                          height: 1.45,
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () => Navigator.of(sheetContext).pop(),
                          child: Text(
                            MaterialLocalizations.of(sheetContext).okButtonLabel,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
