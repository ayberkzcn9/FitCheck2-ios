import 'package:flutter/material.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import '../l10n/app_localizations.dart';
import '../../theme/design_tokens.dart';

class AnaEkranRehber {
  static void rehberiBaslat({
    required BuildContext context,
    required GlobalKey gardirobaEkleKey,
    required GlobalKey aiStilistKey,
    required GlobalKey yikamaTakipKey,
    required GlobalKey havaDurumuKey,
    GlobalKey? gardirobumNavKey,
    GlobalKey? haftalikNavKey,
    GlobalKey? dolaptanNavKey,
    GlobalKey? kendiNavKey,
    GlobalKey? profilNavKey,
    VoidCallback? onFinish,
  }) {
    final l10n = AppLocalizations.of(context)!;

    List<TargetFocus> targets = [
      // 1. BUTON: Toplu Kıyafet Ekleme
      TargetFocus(
        identify: "gardirobaEkle",
        keyTarget: gardirobaEkleKey,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return _buildRehberBalonu(
                context: context,
                baslik: l10n.rehberGardirobuDijitallestirBaslik,
                aciklama: l10n.rehberGardirobuDijitallestirAciklama,
                onNext: () => controller.next(),
              );
            },
          ),
        ],
      ),

      // 2. BUTON: Sesli Asistan
      TargetFocus(
        identify: "yikamaTakip",
        keyTarget: yikamaTakipKey,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return _buildRehberBalonu(
                context: context,
                baslik: l10n.rehberSesliAsistanBaslik,
                aciklama: l10n.rehberSesliAsistanAciklama,
                onNext: () => controller.next(),
              );
            },
          ),
        ],
      ),

      // 3. BUTON: AI Stilist & Kombin Önerisi
      TargetFocus(
        identify: "aiStilist",
        keyTarget: aiStilistKey,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return _buildRehberBalonu(
                context: context,
                baslik: l10n.rehberAiStilistBaslik,
                aciklama: l10n.rehberAiStilistAciklama,
                onNext: () => controller.next(),
              );
            },
          ),
        ],
      ),

      // 4. BUTON: Ayarlar
      TargetFocus(
        identify: "havaDurumu",
        keyTarget: havaDurumuKey,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return _buildRehberBalonu(
                context: context,
                baslik: l10n.rehberAyarlarBaslik,
                aciklama: l10n.rehberAyarlarAciklama,
                onNext: () => controller.next(),
              );
            },
          ),
        ],
      ),
    ];

    // 🔻 ALT NAVİGASYON SEKMELERİ
    if (gardirobumNavKey != null) {
      targets.add(
        TargetFocus(
          identify: "navGardirobum",
          keyTarget: gardirobumNavKey,
          alignSkip: Alignment.topRight,
          contents: [
            TargetContent(
              align: ContentAlign.top,
              builder: (context, controller) {
                return _buildRehberBalonu(
                  context: context,
                  baslik: l10n.rehberNavGardirobumBaslik,
                  aciklama: l10n.rehberNavGardirobumAciklama,
                  onNext: () => controller.next(),
                );
              },
            ),
          ],
        ),
      );
    }

    if (haftalikNavKey != null) {
      targets.add(
        TargetFocus(
          identify: "navHaftalik",
          keyTarget: haftalikNavKey,
          alignSkip: Alignment.topRight,
          contents: [
            TargetContent(
              align: ContentAlign.top,
              builder: (context, controller) {
                return _buildRehberBalonu(
                  context: context,
                  baslik: l10n.rehberNavHaftalikBaslik,
                  aciklama: l10n.rehberNavHaftalikAciklama,
                  onNext: () => controller.next(),
                );
              },
            ),
          ],
        ),
      );
    }

    if (dolaptanNavKey != null) {
      targets.add(
        TargetFocus(
          identify: "navDolaptan",
          keyTarget: dolaptanNavKey,
          alignSkip: Alignment.topRight,
          contents: [
            TargetContent(
              align: ContentAlign.top,
              builder: (context, controller) {
                return _buildRehberBalonu(
                  context: context,
                  baslik: l10n.rehberNavDolaptanBaslik,
                  aciklama: l10n.rehberNavDolaptanAciklama,
                  onNext: () => controller.next(),
                );
              },
            ),
          ],
        ),
      );
    }

    if (kendiNavKey != null) {
      targets.add(
        TargetFocus(
          identify: "navKendi",
          keyTarget: kendiNavKey,
          alignSkip: Alignment.topRight,
          contents: [
            TargetContent(
              align: ContentAlign.top,
              builder: (context, controller) {
                return _buildRehberBalonu(
                  context: context,
                  baslik: l10n.rehberNavKendiBaslik,
                  aciklama: l10n.rehberNavKendiAciklama,
                  onNext: () => controller.next(),
                );
              },
            ),
          ],
        ),
      );
    }

    if (profilNavKey != null) {
      targets.add(
        TargetFocus(
          identify: "navProfil",
          keyTarget: profilNavKey,
          alignSkip: Alignment.topRight,
          contents: [
            TargetContent(
              align: ContentAlign.top,
              builder: (context, controller) {
                return _buildRehberBalonu(
                  context: context,
                  baslik: l10n.rehberNavProfilBaslik,
                  aciklama: l10n.rehberNavProfilAciklama,
                  onNext: () => controller.next(),
                  sonAdimMi: true,
                );
              },
            ),
          ],
        ),
      );
    }

    TutorialCoachMark(
      targets: targets,
      colorShadow: Colors.black,
      opacityShadow: 0.82,
      paddingFocus: 8,
      hideSkip: false,
      textSkip: l10n.rehberiAtla,
      textStyleSkip: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 14,
        shadows: [
          Shadow(
            color: Colors.black54,
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      onFinish: () {
        debugPrint("Rehber tamamlandı");
        onFinish?.call();
      },
      onSkip: () {
        debugPrint("Rehber atlandı");
        onFinish?.call();
        return true;
      },
    ).show(context: context);
  }

  static Widget _buildRehberBalonu({
    required BuildContext context,
    required String baslik,
    required String aciklama,
    required VoidCallback onNext,
    bool sonAdimMi = false,
  }) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHigh,
        borderRadius: AppRadius.xxlRadius,
        border: Border.all(
          color: colors.outlineVariant.withValues(alpha: 0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: 0.15),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            baslik,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: colors.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            aciklama,
            style: TextStyle(
              fontSize: 14,
              color: colors.onSurfaceVariant,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: colors.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
              ),
              onPressed: onNext,
              child: Text(
                sonAdimMi ? l10n.rehberAnladimBasla : l10n.rehberSonrakiAdim,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
