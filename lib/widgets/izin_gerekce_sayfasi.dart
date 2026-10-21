// Sistem izin penceresi açılmadan önce gösterilen gerekçe sayfası.
//
// Mobbin "Enabling & Disabling" deseni: kullanıcı izni neden istediğimizi
// önce kendi dilimizle anlatırız, sonra sistem penceresi açılır. Böylece
// kullanıcı "Neden kamera istiyor?" sorusunu cevapsız bırakmaz.

import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/design_tokens.dart';

class IzinGerekce {
  const IzinGerekce._();

  /// Gerekçe sayfasını gösterir.
  ///
  /// Kullanıcı birincil düğmeye basarsa `true`, kapatır/ikincil düğmeye basarsa
  /// `false` döner. `false` dönse bile sistem izni istenmez.
  static Future<bool> goster(
    BuildContext context, {
    required String baslik,
    required String aciklama,
    required String butonMetni,
    String? vazgecMetni,
    IconData ikon = Icons.photo_camera_rounded,
  }) async {
    final colors = Theme.of(context).colorScheme;

    final sonuc = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: AppBlur.cam,
                  sigmaY: AppBlur.cam,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: colors.surfaceContainerHigh.withValues(alpha: 0.92),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding: const EdgeInsets.fromLTRB(20, 22, 20, 18),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: colors.primary.withValues(alpha: 0.08),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(ikon, size: 26, color: colors.primary),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        baslik,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.4,
                          color: colors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        aciklama,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.35,
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () => Navigator.of(sheetContext).pop(true),
                          style: FilledButton.styleFrom(
                            minimumSize: const Size(0, 48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Text(butonMetni),
                        ),
                      ),
                      if (vazgecMetni != null) ...[
                        const SizedBox(height: 4),
                        SizedBox(
                          width: double.infinity,
                          child: TextButton(
                            onPressed: () => Navigator.of(sheetContext).pop(false),
                            child: Text(vazgecMetni),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    return sonuc ?? false;
  }
}
