import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import '../l10n/app_localizations.dart';
import '../../theme/design_tokens.dart';

// İzin ekranı temayı kullanır; sabit renk tanımı YOK.
// Vurgu renkleri (tema primary/tertiary'den türetilmiş HSV kaydırmaları):
// primary = #0F5F4A (h=160°) → teal h=180°
// tertiary = #D9A441 (h=43°) → orange h=73°
const Color _targetTeal = Color(0xFF00A87A);   // h≈180°
const Color _targetOrange = Color(0xFFE88C00); // h≈73°

// İzin Diyaloğu

class IzinDiyalogu extends StatefulWidget {
  const IzinDiyalogu({super.key});

  static Future<void> goster(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const IzinDiyalogu(),
    );
  }

  @override
  State<IzinDiyalogu> createState() => _IzinDiyaloguState();
}

class _IzinDiyaloguState extends State<IzinDiyalogu> {
  bool _yukleniyor = false;

  Future<void> _izinleriSiraIleIste() async {
    setState(() => _yukleniyor = true);
    HapticFeedback.mediumImpact();

    final locationStatus = await Permission.location.request();
    final cameraStatus = await Permission.camera.request();
    await Permission.notification.request();

    if (!locationStatus.isGranted || !cameraStatus.isGranted) {
      if (!mounted) return;
      setState(() => _yukleniyor = false);
      await _reddedilenIzinleriGoster();
      return;
    }

    if (!mounted) return;
    Navigator.pop(context);
  }

  Future<void> _reddedilenIzinleriGoster() async {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;

    await showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      barrierDismissible: false,
      builder: (dialogContext) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: AppBlur.cam, sigmaY: AppBlur.cam),
        child: AlertDialog(
          backgroundColor: colors.surfaceContainerHigh.withValues(alpha: 0.95),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.dialogRadius,
            side: BorderSide(
              color: colors.primary.withValues(alpha: 0.3),
              width: 1.5,
            ),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.shield_outlined,
                  color: colors.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.izinGerekliBaslik,
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: AppText.sizeTitleSmall,
                    letterSpacing: -0.5,
                    color: colors.onSurface,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            l10n.izinGerekliIcerik,
            style: TextStyle(
              fontSize: AppText.sizeBodySmall,
              color: colors.onSurfaceVariant,
              height: 1.45,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                HapticFeedback.selectionClick();
                Navigator.pop(dialogContext);
                Navigator.pop(context);
              },
              child: Text(
                l10n.dahaSonraAyarla,
                style: TextStyle(
                  color: colors.onSurfaceVariant,
                  fontSize: AppText.sizeBodySmall,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: AppRadius.lgRadius,
                gradient: LinearGradient(
                  colors: [colors.primary, _targetTeal],
                ),
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.lgRadius,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                ),
                onPressed: () async {
                  HapticFeedback.selectionClick();
                  Navigator.pop(dialogContext);
                  await openAppSettings();
                },
                child: Text(
                  l10n.ayarlaraGit,
                  style: TextStyle(
                    color: colors.onPrimary,
                    fontSize: AppText.sizeBodySmall,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: AppBlur.cam, sigmaY: AppBlur.cam),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        decoration: BoxDecoration(
          color: colors.surfaceContainerHigh.withValues(alpha: 0.98),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          border: Border.all(
            color: colors.primary.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        padding: const EdgeInsets.fromLTRB(AppSpacing.xxl, AppSpacing.lg, AppSpacing.xxl, AppSpacing.xxl),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: colors.outlineVariant.withValues(alpha: 0.6),
                  borderRadius: AppRadius.xxsRadius,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [colors.primary, _targetOrange],
                  ),
                ),
                child: const Icon(
                  Icons.security_rounded,
                  size: 40,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.uygulamaIzinleri,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: AppText.sizeHeadline,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                  color: colors.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.izinEkraniAciklama,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: AppText.sizeBodySmall,
                  color: colors.onSurfaceVariant,
                  height: 1.4,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              Flexible(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      _buildIzinMadde(
                        icon: Icons.location_on_rounded,
                        baslik: l10n.konumIzni,
                        aciklama: l10n.konumIzniAciklama,
                        accentColor: _targetTeal,
                      ),
                      const SizedBox(height: 12),
                      _buildIzinMadde(
                        icon: Icons.camera_alt_rounded,
                        baslik: l10n.kameraIzni,
                        aciklama: l10n.kameraIzniAciklama,
                        accentColor: _targetOrange,
                      ),
                      const SizedBox(height: 12),
                      _buildIzinMadde(
                        icon: Icons.notifications_active_rounded,
                        baslik: l10n.bildirimIzni,
                        aciklama: l10n.bildirimIzniAciklama,
                        accentColor: colors.primary,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: 52,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: AppRadius.lgRadius,
                  gradient: LinearGradient(
                    colors: [colors.primary, _targetTeal],
                  ),
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.lgRadius,
                    ),
                  ),
                  onPressed: _yukleniyor ? null : _izinleriSiraIleIste,
                  child: _yukleniyor
                      ? SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: colors.onPrimary,
                            strokeWidth: 2.5,
                          ),
                        )
                      : Text(
                          l10n.izinleriVerVeBasla,
                          style: TextStyle(
                            fontSize: AppText.sizeBodyLarge,
                            fontWeight: FontWeight.w800,
                            color: colors.onPrimary,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: _yukleniyor ? null : () => Navigator.pop(context),
                child: Text(
                  l10n.simdilikAtla,
                  style: TextStyle(
                    color: colors.onSurfaceVariant,
                    fontSize: AppText.sizeBodySmall,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIzinMadde({
    required IconData icon,
    required String baslik,
    required String aciklama,
    required Color accentColor,
  }) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: AppRadius.xlRadius,
        border: Border.all(
          color: accentColor.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: accentColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  baslik,
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: AppText.sizeBodySmall,
                    color: colors.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  aciklama,
                  style: TextStyle(
                    fontSize: AppText.sizeCaption,
                    color: colors.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}