// Alt menü çubuğu — 6 sekme, simge + etiket.
//
// `AnaEkran`den ayrıldı: tek başına test edilebilsin (etiketler, taşma,
// erişilebilirlik) ve ekran dosyası kısalsın diye.

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../l10n/app_localizations.dart';
import '../theme/design_tokens.dart';

/// Sekme indeksleri. Sıra `AnaEkran.ekranlar` listesiyle birebir aynı olmalı.
///
/// 4 (`kendi`) bilinçli olarak boş bırakıldı: "Kendin Kombin Yap" kapalı,
/// ama mevcut indeksler kaymasın diye yer tutucu korunuyor.
class Sekmeler {
  const Sekmeler._();

  static const int bugun = 0;
  static const int dolap = 1;
  static const int plan = 2;
  static const int kombin = 3;
  static const int kendi = 4;
  static const int profil = 5;
  static const int oyun = 6;
}

/// Cam efektli alt menü. Gövde bu çubuğun altına uzandığı için yükseklik
/// güvenli alan kadar artırılıyor.
class AltMenuCubugu extends StatelessWidget {
  const AltMenuCubugu({
    super.key,
    required this.seciliSekme,
    required this.gorunur,
    required this.onSec,
    required this.anahtarlar,
  });

  /// Seçili sekme indeksi.
  final int seciliSekme;

  /// Çubuk görünür mü (aşağı kaydırınca gizleniyor).
  final bool gorunur;

  /// Sekmeye dokunulduğunda çağrılır.
  final ValueChanged<int> onSec;

  /// Testlerin ve rehberin eriştiği anahtarlar (sekme indeksi → anahtar).
  final Map<int, Key> anahtarlar;

  /// Simge + etiket için gereken yükseklik (güvenli alan hariç).
  static const double icerikYuksekligi = 72;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final double altBosluk = MediaQuery.of(context).padding.bottom;
    final double normalYukseklik = icerikYuksekligi + altBosluk;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeInOut,
      height: gorunur ? normalYukseklik : 0.0,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: gorunur ? 1.0 : 0.0,
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppRadius.xxl),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: AppBlur.cam,
                sigmaY: AppBlur.cam,
              ),
              child: Container(
                height: normalYukseklik,
                padding: EdgeInsets.fromLTRB(
                    8, 8, 8, altBosluk > 0 ? altBosluk : 8),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerLow.withValues(alpha: 0.90),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppRadius.xxl),
                  ),
                  border: Border(
                    top: BorderSide(
                      color: colorScheme.outlineVariant.withValues(alpha: 0.4),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _oge(context, Sekmeler.bugun, Icons.wb_sunny_outlined,
                        Icons.wb_sunny_rounded),
                    _oge(context, Sekmeler.dolap, Icons.door_sliding_outlined,
                        Icons.door_sliding_rounded),
                    _oge(context, Sekmeler.plan, Icons.calendar_month_outlined,
                        Icons.calendar_month_rounded),
                    _oge(context, Sekmeler.kombin, Icons.casino_outlined,
                        Icons.casino_rounded),
                    // Sekmeler.kendi (4) bilinçli olarak kapalı.
                    _oge(context, Sekmeler.profil, Icons.insights_outlined,
                        Icons.insights_rounded),
                    _oge(context, Sekmeler.oyun, Icons.style_outlined,
                        Icons.style_rounded),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _oge(
    BuildContext context,
    int index,
    IconData unselectedIcon,
    IconData selectedIcon,
  ) {
    final isSelected = seciliSekme == index;
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final labels = [
      l10n.bugunSekmesi,
      l10n.anaSekmeGardirop,
      l10n.anaSekmeHaftalik,
      // Menüde kısa etiket: tam başlıklar 53 dp'ye sığmıyor.
      l10n.navKombin,
      l10n.kendiKombininiTasarlaTitle,
      l10n.navProfil,
      l10n.duelloSekmesi,
    ];

    final iconColor =
        isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant;

    return Expanded(
      child: Semantics(
        label: labels[index],
        selected: isSelected,
        button: true,
        child: InkWell(
          key: anahtarlar[index],
          onTap: () {
            if (seciliSekme != index) {
              HapticFeedback.selectionClick();
              onSec(index);
            }
          },
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  transform: isSelected
                      ? Matrix4.diagonal3Values(1.1, 1.1, 1.0)
                      : Matrix4.identity(),
                  child: Icon(
                    isSelected ? selectedIcon : unselectedIcon,
                    color: iconColor,
                    size: 25,
                  ),
                ),
                const SizedBox(height: 4),
                // Etiket hem keşfedilebilirliği hem seçim göstergesini taşır;
                // ayrı nokta göstergesine gerek yok.
                Text(
                  labels[index],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: AppText.sizeMicro,
                    height: 1.15,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
