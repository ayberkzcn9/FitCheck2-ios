// FitCheck Design System — Ortak Widget'lar
//
// Tüm ekranlarda tutarlı görünen buton, kart, chip ve etiketler.
// Design token'ları kullanır.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'design_tokens.dart';

// ===========================================================================
// ORTAK BUTON — Birincil aksiyon (yeşil, dolu)
// ===========================================================================
class AppPrimaryButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool loading;
  final bool expand;

  const AppPrimaryButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.loading = false,
    this.expand = true,
  });

  @override
  Widget build(BuildContext context) {
    final btn = SizedBox(
      height: 52,
      child: FilledButton.icon(
        onPressed: loading ? null : onPressed,
        icon: loading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white),
              )
            : Icon(icon ?? Icons.check_rounded, size: 20),
        label: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.2,
            ),
          ),
        ),
        style: FilledButton.styleFrom(
          backgroundColor: AppAccents.success,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.lgRadius),
        ),
      ),
    );
    return expand ? SizedBox(width: double.infinity, child: btn) : btn;
  }
}

// ===========================================================================
// İKİNCİL BUTON — Yıkıcı olmayan aksiyon (çerçeveli)
// ===========================================================================
class AppSecondaryButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final Color? color;

  const AppSecondaryButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? Theme.of(context).colorScheme.onSurfaceVariant;
    return SizedBox(
      height: 52,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: icon != null ? Icon(icon, size: 20, color: c) : const SizedBox.shrink(),
        label: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w700, color: c),
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: c.withValues(alpha: 0.4)),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.lgRadius),
        ),
      ),
    );
  }
}

// ===========================================================================
// TEHLİKELİ BUTON — Yıkıcı aksiyon (kırmızı)
// ===========================================================================
class AppDangerButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;

  const AppDangerButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon ?? Icons.delete_outline_rounded,
            size: 20, color: AppAccents.error),
        label: Text(
          label,
          style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppAccents.error),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: AppAccents.error.withValues(alpha: 0.4)),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.lgRadius),
        ),
      ),
    );
  }
}

// ===========================================================================
// ORTAK KART — Tutarlı kart (gölgesiz, sınırlı)
// ===========================================================================
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final VoidCallback? onTap;
  final Color? color;
  final Color? borderColor;
  final double? radius;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.color,
    this.borderColor,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final r = radius ?? AppRadius.xxl;
    final content = Padding(
      padding: padding ?? AppSpacing.kartIci,
      child: child,
    );

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: color ?? cs.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(r),
        side: BorderSide(
          color: borderColor ?? cs.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: onTap != null
          ? InkWell(
              onTap: () {
                HapticFeedback.selectionClick();
                onTap!();
              },
              child: content,
            )
          : content,
    );
  }
}

// ===========================================================================
// ORTAK CHIP — Seçim etiketi
// ===========================================================================
class AppChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final IconData? icon;

  const AppChip({
    super.key,
    required this.label,
    this.selected = false,
    this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: GestureDetector(
        onTap: onTap != null
            ? () {
                HapticFeedback.selectionClick();
                onTap!();
              }
            : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          constraints: const BoxConstraints(minHeight: 44),
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          decoration: BoxDecoration(
            color: selected ? cs.primary : cs.surfaceContainerHighest,
            borderRadius: AppRadius.mdRadius,
            border: Border.all(
              color: selected
                  ? cs.primary
                  : cs.outlineVariant.withValues(alpha: 0.5),
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon,
                    size: 16,
                    color: selected ? cs.onPrimary : cs.onSurfaceVariant),
                const SizedBox(width: AppSpacing.sm),
              ],
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: selected ? cs.onPrimary : cs.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ===========================================================================
// ROZET — Küçük bilgi etiketi (ikon + metin)
// ===========================================================================
class AppBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;

  const AppBadge({
    super.key,
    required this.icon,
    required this.label,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: AppRadius.mdRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color ?? cs.onSurface),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppText.labelSmall.copyWith(color: cs.onSurface),
          ),
        ],
      ),
    );
  }
}

// ===========================================================================
// BÖLÜM BAŞLIĞI — Ayarlar ve listeler için
// ===========================================================================
class AppSectionHeader extends StatelessWidget {
  final String title;

  const AppSectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: AppSpacing.lg, bottom: AppSpacing.sm, top: AppSpacing.lg),
      child: Text(
        title.toUpperCase(),
        style: AppText.labelMicro.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
