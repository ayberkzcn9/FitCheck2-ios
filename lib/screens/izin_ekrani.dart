import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import '../l10n/app_localizations.dart';
import '../../theme/design_tokens.dart';

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
    if (_yukleniyor) return;
    setState(() => _yukleniyor = true);
    HapticFeedback.mediumImpact();

    final locationStatus = await _izinIste(Permission.location);
    final cameraStatus = await _izinIste(Permission.camera);

    if (!mounted) return;
    setState(() => _yukleniyor = false);

    // Yalnızca kullanıcı izni kalıcı olarak reddettiyse ayarlara yönlendir.
    // Zaman aşımı veya ilk reddetme gibi durumlarda akış hata penceresiyle
    // bölünmez; ekran kapanır, uygulama izinsiz özellikleri kendi içinde
    // devre dışı bırakır.
    final kaliciRed = locationStatus.isPermanentlyDenied ||
        cameraStatus.isPermanentlyDenied ||
        locationStatus.isRestricted ||
        cameraStatus.isRestricted;
    if (kaliciRed) {
      await _reddedilenIzinleriGoster();
      return;
    }

    Navigator.pop(context);

    // Bildirim izni açılışta FCM ve flutter_local_notifications tarafından
    // zaten isteniyor. Burada sonucu beklemek iOS'ta üst üste binen
    // requestAuthorization çağrılarından birinin hiç yanıtlanmamasına yol
    // açabiliyor; bu yüzden istek beklenmeden gönderilir.
    unawaited(_izinIste(Permission.notification));
  }

  /// Tek bir izni ister. Native tarafta yanıt gelmezse (iOS'ta üst üste
  /// binen izin istekleri, uygulamanın arka plana atılması vb.) arayüzün
  /// sonsuza kadar spinner'da kalmaması için zaman aşımı ve hata yakalama
  /// uygular; son durum her hâlükârda okunur.
  Future<PermissionStatus> _izinIste(Permission izin) async {
    try {
      final status = await izin.request().timeout(const Duration(seconds: 60));
      debugPrint('İzin isteği (${izin.toString()}) → $status');
      return status;
    } catch (e) {
      debugPrint('İzin isteği (${izin.toString()}) tamamlanmadı → $e');
      try {
        final status = await izin.status.timeout(const Duration(seconds: 5));
        debugPrint('İzin isteği (${izin.toString()}) mevcut durum → $status');
        return status;
      } catch (e) {
        debugPrint('İzin durumu (${izin.toString()}) okunamadı → $e');
        return PermissionStatus.denied;
      }
    }
  }

  Future<void> _reddedilenIzinleriGoster() async {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;

    await showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: colors.surfaceContainerHigh.withValues(alpha: 0.95),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.dialogRadius,
          side: BorderSide(
            color: colors.outlineVariant,
            width: 1,
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
                  fontWeight: FontWeight.w600,
                  fontSize: AppText.sizeTitleSmall,
                  letterSpacing: 0,
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
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: colors.primary,
              foregroundColor: colors.onPrimary,
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
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHigh.withValues(alpha: 0.98),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        border: Border.all(color: colors.outlineVariant),
      ),
      padding: EdgeInsets.fromLTRB(
          AppSpacing.sayfaKenari.left,
          AppSpacing.lg,
          AppSpacing.sayfaKenari.right,
          AppSpacing.xxl),
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
                color: colors.primaryContainer,
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
                fontWeight: FontWeight.w600,
                letterSpacing: 0,
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
                      accentColor: colors.primary,
                    ),
                    const SizedBox(height: 12),
                    _buildIzinMadde(
                      icon: Icons.camera_alt_rounded,
                      baslik: l10n.kameraIzni,
                      aciklama: l10n.kameraIzniAciklama,
                      accentColor: colors.primary,
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
            SizedBox(
              height: 52,
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: colors.primary,
                  foregroundColor: colors.onPrimary,
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
                          fontWeight: FontWeight.w600,
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
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
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
      constraints: const BoxConstraints(minWidth: 0),
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
                    fontWeight: FontWeight.w600,
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
