import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../l10n/app_localizations.dart';
import '../../../theme/design_tokens.dart';

class HesabiSilModal extends StatefulWidget {
  const HesabiSilModal({super.key});

  /// Modal'ı çağırmak için kolay statik metot (Geriye bool döndürür)
  static Future<bool?> goster(BuildContext context) {
    HapticFeedback.vibrate();
    return showDialog<bool>(
      context: context,
      builder: (ctx) => const HesabiSilModal(),
    );
  }

  @override
  State<HesabiSilModal> createState() => _HesabiSilModalState();
}

class _HesabiSilModalState extends State<HesabiSilModal> {
  final TextEditingController _controller = TextEditingController();
  bool _isValid = false; // "fitcheck" kelimesinin doğruluğunu tutar

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;

    return AlertDialog(
      backgroundColor: colors.surfaceContainerHigh,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.dialogRadius,
      ),
      title: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: colors.error,
            size: 26,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              l10n.hesabiKaliciSilTitle,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colors.onSurface,
              ),
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.hesabiSilGeriAlinamazUyari,
            style: TextStyle(
              fontSize: 14,
              color: colors.onSurfaceVariant,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.hesabiSilOnayKoduMetni,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _controller,
            autofocus: true,
            style: TextStyle(color: colors.onSurface),
            decoration: InputDecoration(
              hintText: 'fitcheck',
              hintStyle: TextStyle(color: colors.onSurfaceVariant),
              isDense: true,
              filled: true,
              fillColor: colors.surfaceContainerHighest,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: _isValid ? colors.error : colors.primary,
                  width: 1.5,
                ),
              ),
            ),
            onChanged: (val) {
              setState(() {
                _isValid = val.trim().toLowerCase() == 'fitcheck';
              });
            },
          ),
        ],
      ),
      actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(
            l10n.vazgec,
            style: TextStyle(
              color: colors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: colors.error,
            foregroundColor: colors.onError,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          onPressed: _isValid ? () => Navigator.pop(context, true) : null,
          child: Text(
            l10n.hesabimiSil,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}