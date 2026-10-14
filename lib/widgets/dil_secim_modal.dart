import 'package:flutter/material.dart';
import '../main.dart'; // KombinDanismaniApp için

class DilSecimModal extends StatelessWidget {
  const DilSecimModal({super.key});

  // Desteklenen diller
  static const List<Map<String, String>> diller = [
    {
      'kod': 'system',
      'ad': '📱 Cihaz Dili (Otomatik)',
      'bayrak': '🌐',
    },
    {
      'kod': 'tr',
      'ad': 'Türkçe',
      'bayrak': '🇹🇷',
    },
    {
      'kod': 'en',
      'ad': 'English',
      'bayrak': '🇺🇸',
    },
    {
      'kod': 'es',
      'ad': 'Español',
      'bayrak': '🇪🇸',
    },
    {
      'kod': 'it',
      'ad': 'Italiano',
      'bayrak': '🇮🇹',
    },
    {
      'kod': 'zh',
      'ad': '中文 (Basitleştirilmiş)',
      'bayrak': '🇨🇳',
    },
    {
      'kod': 'ar',
      'ad': 'العربية',
      'bayrak': '🇸🇦',
    },
    {
      'kod': 'fr',
      'ad': 'Français',
      'bayrak': '🇫🇷',
    },
    {
      'kod': 'de',
      'ad': 'Deutsch',
      'bayrak': '🇩🇪',
    },
    {
      'kod': 'pt',
      'ad': 'Português',
      'bayrak': '🇧🇷',
    },
    {
      'kod': 'ja',
      'ad': '日本語',
      'bayrak': '🇯🇵',
    },
    {
      'kod': 'ko',
      'ad': '한국어',
      'bayrak': '🇰🇷',
    },
    {
      'kod': 'ru',
      'ad': 'Русский',
      'bayrak': '🇷🇺',
    },
  ];

  static void goster(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: colors.surfaceContainerHigh,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (modalContext) {
        return const DilSecimModal();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = KombinDanismaniApp.of(context);
    final currentLocale = appState.currentLocale;
    final colors = Theme.of(context).colorScheme;

    final currentCode = currentLocale?.languageCode ?? 'system';

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.75,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ÜST ÇUBUK (Drag Handle)
            Container(
              width: 32,
              height: 4,
              decoration: BoxDecoration(
                color: colors.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            const SizedBox(height: 18),

            // BAŞLIK
            Text(
              '🌐 Dil Seçimi / Select Language',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colors.onSurface,
              ),
            ),

            const SizedBox(height: 16),

            Divider(
              height: 1,
              color: colors.outlineVariant.withValues(alpha: 0.5),
            ),

            const SizedBox(height: 8),

            // DİL LİSTESİ
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: diller.length,
                separatorBuilder: (context, index) {
                  return Divider(
                    height: 1,
                    indent: 64,
                    endIndent: 8,
                    color: colors.outlineVariant.withValues(alpha: 0.3),
                  );
                },
                itemBuilder: (context, index) {
                  final dil = diller[index];

                  final dilKodu = dil['kod']!;
                  final dilAdi = dil['ad']!;
                  final bayrak = dil['bayrak']!;

                  final isSelected = currentCode == dilKodu;

                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),

                    // BAYRAK
                    leading: Container(
                      width: 44,
                      height: 44,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? colors.primaryContainer
                            : colors.surfaceContainerHighest,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        bayrak,
                        style: const TextStyle(
                          fontSize: 22,
                        ),
                      ),
                    ),

                    // DİL ADI
                    title: Text(
                      dilAdi,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? colors.primary : colors.onSurface,
                      ),
                    ),

                    // SEÇİLİ İKONU
                    trailing: AnimatedSwitcher(
                      duration: const Duration(
                        milliseconds: 200,
                      ),
                      child: isSelected
                          ? Icon(
                              Icons.check_circle_rounded,
                              key: const ValueKey('selected'),
                              color: colors.primary,
                            )
                          : const SizedBox(
                              key: ValueKey('not_selected'),
                              width: 24,
                              height: 24,
                            ),
                    ),

                    // DİL DEĞİŞTİRME İŞLEMİ
                    onTap: () {
                      if (dilKodu == 'system') {
                        appState.setLocale(null); // Sisteme dön
                      } else {
                        appState.setLocale(Locale(dilKodu)); // Yeni dile geç
                      }

                      if (!context.mounted) return;
                      Navigator.of(context).pop(); // Modalı kapat
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}