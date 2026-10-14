// Gün Seçici Widget - Haftalık Planlayıcı Ekranı için ayrı bileşen
// Horizontal scrollable day selector with selection and "worn" states

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GunSecici extends StatelessWidget {
  final List<dynamic> hafta;
  final int seciliGunIndex;
  final Set<int> giyilmisGunler;
  final Color anaRenk;
  final String Function(String) gunIsminiCevir;
  final ValueChanged<int> onGunSecildi;

  const GunSecici({
    super.key,
    required this.hafta,
    required this.seciliGunIndex,
    required this.giyilmisGunler,
    required this.anaRenk,
    required this.gunIsminiCevir,
    required this.onGunSecildi,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: hafta.length,
        itemBuilder: (context, index) {
          final gunItem = hafta[index];
          final rawGun = gunItem['gun']?.toString() ?? '';
          final gunAdi = gunIsminiCevir(rawGun);

          final bool seciliMi = seciliGunIndex == index;
          final bool giyildiMi = giyilmisGunler.contains(index);

          final bg = seciliMi
              ? (giyildiMi ? Colors.green : anaRenk)
              : giyildiMi
                  ? Colors.green.shade100
                  : colorScheme.surfaceContainerHigh;

          final fg = seciliMi
              ? Colors.white
              : giyildiMi
                  ? Colors.green.shade900
                  : colorScheme.onSurfaceVariant;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: () {
                HapticFeedback.selectionClick();
                onGunSecildi(index);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                    horizontal: 18, vertical: 0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: giyildiMi && !seciliMi
                        ? Colors.green.withValues(alpha: 0.4)
                        : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (giyildiMi) ...[
                      Icon(
                        Icons.check_circle_rounded,
                        size: 14,
                        color: fg,
                      ),
                      const SizedBox(width: 6),
                    ],
                    Text(
                      gunAdi,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: fg,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}