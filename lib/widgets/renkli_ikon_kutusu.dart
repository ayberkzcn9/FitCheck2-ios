import 'package:flutter/material.dart';

class RenkliIkonKutusu extends StatelessWidget {
  final IconData ikon;
  final Color? acikTemaRengi;
  final double iconSize;
  final double padding;

  const RenkliIkonKutusu({
    super.key,
    required this.ikon,
    this.acikTemaRengi,
    this.iconSize = 20,
    this.padding = 10,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final Color etkinRenk = acikTemaRengi ?? colors.primary;

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: acikTemaRengi != null
            ? etkinRenk.withValues(alpha: 0.12)
            : colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        ikon,
        color: etkinRenk,
        size: iconSize,
      ),
    );
  }
}