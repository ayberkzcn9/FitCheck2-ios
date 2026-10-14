// AI Öneri Kutusu Widget - Haftalık Planlayıcı için stilist önerisi kartı
// Eksik parça veya boş günlerde gösterilen amber tonlı öneri kutusu

import 'package:flutter/material.dart';

class AiOneriKutusu extends StatelessWidget {
  final String baslik;
  final String metin;
  final bool yukleniyor;
  final VoidCallback? onTekrarDene;
  final String yukleniyorMetni;
  final String tekrarDenemetni;

  const AiOneriKutusu({
    super.key,
    required this.baslik,
    required this.metin,
    required this.yukleniyor,
    this.onTekrarDene,
    this.yukleniyorMetni = 'Öneri hazırlanıyor...',
    this.tekrarDenemetni = 'Tekrar dene',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8F0),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEAD7BE)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.checkroom_rounded,
            size: 18,
            color: Color(0xFFB26A00),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  baslik,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: const Color(0xFF8A5300),
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                if (yukleniyor)
                  Row(
                    children: [
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(0xFFB26A00),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          yukleniyorMetni,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontSize: 13.5,
                            height: 1.4,
                            color: const Color(0xFF6B4A20),
                          ),
                        ),
                      ),
                    ],
                  )
                else ...[
                  Text(
                    metin,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 13.5,
                      height: 1.4,
                      color: const Color(0xFF6B4A20),
                    ),
                  ),
                  if (onTekrarDene != null)
                    TextButton(
                      onPressed: onTekrarDene,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 32),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        foregroundColor: const Color(0xFF8A5300),
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