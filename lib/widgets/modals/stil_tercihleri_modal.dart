import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../l10n/app_localizations.dart';

class StilTercihleriModal extends StatefulWidget {
  final String ilkStil;
  final String ilkFit;
  final Function(String yeniStil, String yeniFit) onKaydet;

  const StilTercihleriModal({
    super.key,
    required this.ilkStil,
    required this.ilkFit,
    required this.onKaydet,
  });

  /// Modal'ı kolayca çağırmak için pratik statik metot
  static void goster({
    required BuildContext context,
    required String ilkStil,
    required String ilkFit,
    required Function(String, String) onKaydet,
  }) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StilTercihleriModal(
        ilkStil: ilkStil,
        ilkFit: ilkFit,
        onKaydet: onKaydet,
      ),
    );
  }

  @override
  State<StilTercihleriModal> createState() => _StilTercihleriModalState();
}

class _StilTercihleriModalState extends State<StilTercihleriModal> {
  late String _seciliStil;
  late String _seciliFit;

  @override
  void initState() {
    super.initState();
    _seciliStil = widget.ilkStil;
    _seciliFit = widget.ilkFit;
  }

  List<Map<String, String>> _getStilListesi(AppLocalizations l10n) {
    return [
      {'key': 'Streetwear / Casual', 'label': l10n.stilStreetwear},
      {'key': 'Klasik / Ofis', 'label': l10n.stilKlasik},
      {'key': 'Minimalist', 'label': l10n.stilMinimalist},
      {'key': 'Spor / Athleisure', 'label': l10n.stilSpor},
      {'key': 'Vintage / Retro', 'label': l10n.stilVintage},
    ];
  }

  List<Map<String, String>> _getFitListesi(AppLocalizations l10n) {
    return [
      {'key': 'Slim Fit', 'label': l10n.fitSlim},
      {'key': 'Regular Fit', 'label': l10n.fitRegular},
      {'key': 'Oversize / Relaxed', 'label': l10n.fitOversize},
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final double altGuvenliBosluk = MediaQuery.of(context).padding.bottom;
    final stilListesi = _getStilListesi(l10n);
    final fitListesi = _getFitListesi(l10n);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.80,
      ),
      padding: EdgeInsets.fromLTRB(
        24,
        24,
        24,
        altGuvenliBosluk > 0 ? altGuvenliBosluk + 20 : 24,
      ),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHigh,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 32,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.stilVeModaTercihleriniz,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: colors.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.stilModalAciklama,
              style: TextStyle(
                fontSize: 14,
                color: colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.favoriTarzinizUst,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: colors.onSurfaceVariant,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: stilListesi.map((item) {
                final key = item['key']!;
                return _buildChip(
                  context: context,
                  label: item['label']!,
                  isSelected: _seciliStil == key,
                  onTap: () {
                    setState(() => _seciliStil = key);
                    widget.onKaydet(_seciliStil, _seciliFit);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.giyimKesimiFitUst,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: colors.onSurfaceVariant,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: fitListesi.map((item) {
                final key = item['key']!;
                return _buildChip(
                  context: context,
                  label: item['label']!,
                  isSelected: _seciliFit == key,
                  onTap: () {
                    setState(() => _seciliFit = key);
                    widget.onKaydet(_seciliStil, _seciliFit);
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip({
    required BuildContext context,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final colors = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? colors.secondaryContainer
              : colors.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? colors.secondary
                : colors.outlineVariant.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            color: isSelected
                ? colors.onSecondaryContainer
                : colors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}