// Hava Bar Widget - Haftalık Planlayıcı Ekranı için ayrı bileşen
// Weather bar with location refresh, settings, and condition icon

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HavaBar extends StatelessWidget {
  final String havaEtiketi;
  final String havaSicaklikMetni;
  final String havaDurumMetni;
  final bool havaYukleniyor;
  final bool havaHatasi;
  final VoidCallback onKonumuYenile;
  final VoidCallback? onKonumAyarlariniAc;
  final IconData Function(String) havaDurumuIkonu;
  final String yukleniyorMetni;
  final String ayarlarTooltip;

  const HavaBar({
    super.key,
    required this.havaEtiketi,
    required this.havaSicaklikMetni,
    required this.havaDurumMetni,
    required this.havaYukleniyor,
    required this.havaHatasi,
    required this.onKonumuYenile,
    this.onKonumAyarlariniAc,
    required this.havaDurumuIkonu,
    this.yukleniyorMetni = 'Yükleniyor...',
    this.ayarlarTooltip = 'Ayarlar',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Card(
        elevation: 0,
        color: colorScheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: havaHatasi
                ? colorScheme.error.withValues(alpha: 0.3)
                : colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            HapticFeedback.lightImpact();
            onKonumuYenile();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                // Location Icon
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: havaHatasi
                        ? colorScheme.errorContainer
                        : colorScheme.surfaceContainerHighest,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    havaHatasi ? Icons.location_off_rounded : Icons.my_location_rounded,
                    color: havaHatasi ? colorScheme.onErrorContainer : Colors.black,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 14),
                // Weather Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        havaEtiketi.toUpperCase(),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        havaYukleniyor || havaSicaklikMetni.isEmpty
                            ? yukleniyorMetni
                            : havaSicaklikMetni,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: havaHatasi ? colorScheme.error : colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // Settings Button (only when error)
                if (havaHatasi && onKonumAyarlariniAc != null) ...[
                  IconButton.filledTonal(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      onKonumAyarlariniAc?.call();
                    },
                    icon: const Icon(Icons.settings_rounded, size: 18),
                    tooltip: ayarlarTooltip,
                    style: IconButton.styleFrom(
                      backgroundColor: colorScheme.errorContainer,
                      foregroundColor: colorScheme.onErrorContainer,
                      padding: const EdgeInsets.all(8),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                // Weather Condition Icon
                if (havaDurumMetni.isNotEmpty) ...[
                  Tooltip(
                    message: havaDurumMetni,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        havaDurumuIkonu(havaDurumMetni),
                        size: 18,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                // Refresh Icon
                const Icon(
                  Icons.refresh_rounded,
                  size: 20,
                  color: Colors.black,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}