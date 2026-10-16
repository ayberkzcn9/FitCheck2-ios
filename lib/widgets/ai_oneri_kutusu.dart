// AI Öneri Kutusu Widget - Haftalık Planlayıcı için stilist önerisi kartı
// Eksik parça veya boş günlerde gösterilen amber tonlı öneri kutusu

import 'package:flutter/material.dart';
import '../../theme/design_tokens.dart';
import '../l10n/app_localizations.dart';

class AiOneriKutusu extends StatelessWidget {
  final String baslik;
  final String metin;
  final bool yukleniyor;
  final VoidCallback? onTekrarDene;

  /// Boş bırakılırsa yerelleştirilmiş varsayılan kullanılır.
  final String? yukleniyorMetni;
  final String? tekrarDenemetni;

  const AiOneriKutusu({
    super.key,
    required this.baslik,
    required this.metin,
    required this.yukleniyor,
    this.onTekrarDene,
    this.yukleniyorMetni,
    this.tekrarDenemetni,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final koyu = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final yukleniyorMetni = this.yukleniyorMetni ?? l10n.aiOneriHazirlaniyor;
    final tekrarDenemetni = this.tekrarDenemetni ?? l10n.chatTekrarDene;

    // Dark mode'da koyu amber tonları, açık modda pastel
    final bg = koyu ? AppTints.warningBgDark : AppTints.warningBg;
    final border = koyu ? AppTints.warningBorderDark : AppTints.warningBorder;
    final baslikRenk = koyu ? const Color(0xFFFFD699) : AppMiscColors.amberTextDark;
    final govdeRenk = koyu ? const Color(0xFFE8C99A) : AppMiscColors.amberTextBody;
    final ikonRenk = koyu ? const Color(0xFFFFC56B) : AppMiscColors.amberText;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppRadius.xlRadius,
        border: Border.all(color: border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.checkroom_rounded,
            size: 18,
            color: ikonRenk,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  baslik,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: baslikRenk,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                if (yukleniyor)
                  Row(
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: ikonRenk,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          yukleniyorMetni,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontSize: 14,
                            height: 1.4,
                            color: govdeRenk,
                          ),
                        ),
                      ),
                    ],
                  )
                else ...[
                  Text(
                    metin,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 14,
                      height: 1.4,
                      color: govdeRenk,
                    ),
                  ),
                  if (onTekrarDene != null)
                    TextButton(
                      onPressed: onTekrarDene,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 32),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        foregroundColor: baslikRenk,
                      ),
                      child: Text(
                        tekrarDenemetni,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}