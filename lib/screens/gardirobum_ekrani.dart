import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../l10n/app_localizations.dart';
import '../models/kiyafet.dart';
import '../services/ai_service.dart';
import '../services/arka_plan_silme_yardimcisi.dart';
import '../services/background_removal_service.dart';
import '../services/background_remover_service.dart';
import '../services/gorsel_yon_service.dart';
import '../services/kesim_kalite_denetimi.dart';
import '../services/kiyafet_analiz_servisi.dart';
import '../services/kilyafet_yukleme_servisi.dart';
import '../services/reklam_servisi.dart';
import '../services/satin_alma_servisi.dart';
import '../utils/ana_ekran_dialoglar.dart';
import '../utils/hava_uygunlugu.dart';
import '../utils/helpers.dart';
import '../utils/dolap_filtresi.dart';
import '../ai/ai_dil.dart';
import '../widgets/bilgi_butonu.dart';
import '../widgets/izin_gerekce_sayfasi.dart';
import '../widgets/kiyafet_duzenleyici.dart';
import '../widgets/stroked_text.dart';
import '../../theme/design_tokens.dart';

import 'reklamsiz_premium_ekrani.dart';

/// Arka plan silinemediğinde kullanıcının verdiği karar.
enum ArkaPlanKarari {
  /// Yerel sunucu/bulut yeniden denenecek.
  tekrarDene,

  /// Fotoğraf, arka planı silinmeden (olduğu gibi) kaydedilecek.
  arkaPlaniylaKaydet,

  /// Bu fotoğraf hiç eklenmeyecek.
  atla,
}

class GardirobumEkrani extends StatefulWidget {
  final List<Kiyafet> gardirobum;
  final Function(Kiyafet) onKiyafetEkle;
  final Function(String) onKiyafetSil;
  final VoidCallback onGardirobuTemizle;
  final Function(String) onSepetToggle;
  final Function(Kiyafet)? onKombinIstegi;
  final Color anaRenk;

  const GardirobumEkrani({
    super.key,
    required this.gardirobum,
    required this.onKiyafetEkle,
    required this.onKiyafetSil,
    required this.onGardirobuTemizle,
    required this.onSepetToggle,
    this.onKombinIstegi,
    required this.anaRenk,
  });

  @override
  State<GardirobumEkrani> createState() => GardirobumEkraniState();
}

class GardirobumEkraniState extends State<GardirobumEkrani> with SingleTickerProviderStateMixin {
  static int _idCounter = 0;
  final ImagePicker _picker = ImagePicker();
  bool _otomatikYukleniyor = false;
  bool _gizlendi = false;

  /// Dolap araması ve kategori filtresi (rafların üstünde).
  final TextEditingController _aramaDenetleyici = TextEditingController();
  String _aramaMetni = '';
  String _kategoriFiltresi = 'tumu';

  bool get _filtreAktif =>
      _aramaMetni.trim().isNotEmpty || _kategoriFiltresi != 'tumu';

  /// Kullanıcı "kesim hatalı olabilir → tekrar çek" dediyse, fotoğraf ekleme
  /// turu bittiğinde kamera yeniden açılır.
  bool _yenidenCekIstendi = false;
  String _yuklemeDurumMesaji = '';
  String? _acikKartId;

  Timer? _aiMesajTimer;
  int _aiMesajIndex = 0;
  List<String> _aiIslemMesajlari = [];

  // 🎨 Yeni loading state
  String _currentStep = ''; // 'bg_removal' | 'ai_analysis' | 'saving'
  int _currentPhotoIndex = 0;
  int _totalPhotos = 0;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final l10n = AppLocalizations.of(context)!;
    if (_yuklemeDurumMesaji.isEmpty) {
      _yuklemeDurumMesaji = l10n.gardirobumYukleniyor;
    }
    _aiIslemMesajlari = [
      l10n.gardirobumAiIslem1,
      l10n.gardirobumAiIslem2,
      l10n.gardirobumAiIslem3,
      l10n.gardirobumAiIslem4,
      l10n.gardirobumAiIslem5,
    ];
  }

  @override
  void dispose() {
    _aiMesajTimer?.cancel();
    _pulseController.dispose();
    _aramaDenetleyici.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    BackgroundRemovalService().initialize();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: AppMotion.standart),
    );
  }

  String _kategoriEtiketiGetir(String katCode, AppLocalizations l10n) {
    switch (katCode.toLowerCase().trim()) {
      case 'ust':
        return l10n.kategoriUst;
      case 'alt':
        return l10n.kategoriAlt;
      case 'ayakkabi':
        return l10n.kategoriAyakkabi;
      case 'aksesuar':
        return l10n.kategoriAksesuar;
      default:
        return katCode.toUpperCase();
    }
  }

  void topluFotografEkle() {
    _fotoEklemeSecenegiGoster();
  }

  void _yuklemeAnimasyonunuBaslat() {
    _aiMesajIndex = 0;
    _aiMesajTimer?.cancel();
    _aiMesajTimer = Timer.periodic(const Duration(milliseconds: 2000), (timer) {
      if (mounted && _aiIslemMesajlari.isNotEmpty) {
        setState(() {
          _aiMesajIndex = (_aiMesajIndex + 1) % _aiIslemMesajlari.length;
        });
      }
    });
  }

  void _yuklemeAnimasyonunuDurdur() {
    _aiMesajTimer?.cancel();
  }

  /// Arka plan silinemediğinde kullanıcıya sorar.
  ///
  /// Neden: sessizce arka planıyla kaydetmek, kullanıcının "arka plan
  /// silinmiyor" sanmasına yol açıyordu. Kullanıcı tekrar deneyebilir, fotoğrafı
  /// olduğu gibi kaydedebilir ya da o fotoğrafı atlayabilir.
  ///
  /// Dışarı dokunarak kapatılırsa güvenli seçenek uygulanır: fotoğraf atlanır.
  Future<ArkaPlanKarari> _arkaPlanSilinemediKarari(
    int sira,
    int toplam,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;

    final karar = await showDialog<ArkaPlanKarari>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      builder: (ctx) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: AppBlur.cam, sigmaY: AppBlur.cam),
        child: AlertDialog(
          backgroundColor: colors.surfaceContainerHigh,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.dialogRadius,
            side: BorderSide(
              color: colors.outlineVariant.withValues(alpha: 0.4),
            ),
          ),
          title: Text(l10n.gardirobumArkaPlanSilinemediBaslik),
          content: Text(
            toplam > 1
                ? '${l10n.gardirobumArkaPlanSilinemediAciklama}  ($sira/$toplam)'
                : l10n.gardirobumArkaPlanSilinemediAciklama,
            style: TextStyle(color: colors.onSurfaceVariant, height: 1.4),
          ),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.of(ctx).pop(ArkaPlanKarari.atla),
              child: Text(l10n.simdilikAtla),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.of(ctx).pop(ArkaPlanKarari.arkaPlaniylaKaydet),
              child: Text(l10n.gardirobumArkaPlanliKaydet),
            ),
            FilledButton(
              onPressed: () =>
                  Navigator.of(ctx).pop(ArkaPlanKarari.tekrarDene),
              child: Text(l10n.chatTekrarDene),
            ),
          ],
        ),
      ),
    );

    return karar ?? ArkaPlanKarari.atla;
  }

  /// Kıyafet zemine çok yakın renkteyse (kesim zorlanır) kullanıcıya
  /// "tekrar çek" seçeneği sunar.
  ///
  /// Neden: bu durumda görüntüde sınır bilgisi yoktur — hangi model kullanılırsa
  /// kullanılsın arka plandan parça kalır ya da kıyafetten parça kesilir. Sorun
  /// girdide olduğu için tek çözüm yeni fotoğraftır; kullanıcı bunu sonucu
  /// gördükten çok sonra değil, tam şimdi öğrenmeli.
  ///
  /// `true` → kullanıcı yeniden çekmek istiyor.
  Future<bool> _zeminBenzerKarari(int sira, int toplam) async {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;

    final tekrarCek = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      builder: (ctx) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: AppBlur.cam, sigmaY: AppBlur.cam),
        child: AlertDialog(
          backgroundColor: colors.surfaceContainerHigh,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.dialogRadius,
            side: BorderSide(
              color: colors.outlineVariant.withValues(alpha: 0.4),
            ),
          ),
          title: Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: colors.tertiary,
                size: 22,
              ),
              const SizedBox(width: 8),
              Expanded(child: Text(l10n.kesimUyarisiBaslik)),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  toplam > 1
                      ? '${l10n.kesimUyarisiAciklama}  ($sira/$toplam)'
                      : l10n.kesimUyarisiAciklama,
                  style: TextStyle(
                    color: colors.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                _cekimIpucuSatiri(colors, l10n.cekimIpucu1),
                _cekimIpucuSatiri(colors, l10n.cekimIpucu2),
                _cekimIpucuSatiri(colors, l10n.cekimIpucu3),
              ],
            ),
          ),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(l10n.kesimUyarisiYineDeKaydet),
            ),
            FilledButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: Text(l10n.kesimUyarisiTekrarCek),
            ),
          ],
        ),
      ),
    );

    // Dışarı dokunarak kapatılırsa güvenli seçenek: fotoğrafı kaydet.
    return tekrarCek ?? false;
  }

  void _kombinHakkiBittiDiyaloguGoster() {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      builder: (ctx) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: AppBlur.cam, sigmaY: AppBlur.cam),
        child: AlertDialog(
          backgroundColor: colors.surfaceContainerHigh,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.dialogRadius,
            side: BorderSide(color: colors.outlineVariant.withValues(alpha: 0.4)),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: const BoxDecoration(
                  color: AppMiscColors.lightPurpleBg,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.auto_awesome_rounded, color: AppAccents.styleist, size: 22),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.gardirobumHakBittiBaslik,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: AppText.sizeTitleSmall,
                    letterSpacing: -0.5,
                    color: colors.onSurface,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.gardirobumHakBittiAciklama,
                style: TextStyle(
                  fontSize: AppText.sizeBodySmall,
                  height: 1.4,
                  color: colors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 20),
              // Birincil teklif: sınırsız kullanım. Ödüllü reklam ikincil.
              FilledButton.icon(
                icon: const Icon(Icons.workspace_premium_rounded, size: 20),
                label: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    l10n.premiumGec(SatinAlmaServisi.ornek.aylikFiyat),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  backgroundColor: AppAccents.successDark,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.lgRadius,
                  ),
                ),
                onPressed: () {
                  HapticFeedback.selectionClick();
                  Navigator.pop(ctx);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const ReklamsizPremiumEkrani(),
                    ),
                  );
                },
              ),
              if (ReklamServisi.reklamlarEtkinMi) ...[
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  icon: Icon(Icons.play_circle_fill_rounded,
                      color: colors.onSurfaceVariant, size: 20),
                  label: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      l10n.reklamIzleHakKazan,
                      style: TextStyle(
                          fontSize: AppText.sizeBodySmall,
                          fontWeight: FontWeight.bold,
                          color: colors.onSurfaceVariant),
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                    side: BorderSide(color: colors.onSurfaceVariant),
                    shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.lgRadius),
                  ),
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    Navigator.pop(ctx);
                    ReklamServisi().odulluReklamGoster(
                      context: context,
                      onReward: (reward) async {
                        await ReklamServisi().reklamIzleyerekHakEkle(
                          ReklamServisi.reklamOduluKredi,
                        );
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(l10n.gardirobumHakEklendiMesaj,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              backgroundColor: AppAccents.success,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                  borderRadius: AppRadius.lgRadius),
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                HapticFeedback.selectionClick();
                Navigator.pop(ctx);
              },
              child: Text(
                l10n.dahaSonra,
                style: TextStyle(color: colors.onSurfaceVariant, fontSize: AppText.sizeBodySmall, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _tamEkranGaleriyiGoster(int baslangicIndex, List<Kiyafet> liste) {
    HapticFeedback.lightImpact();
    final PageController pageController = PageController(initialPage: baslangicIndex);
    final colors = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      useSafeArea: false,
      builder: (dialogContext) {
        final l10n = AppLocalizations.of(context)!;

        return StatefulBuilder(
          builder: (context, setModalState) {
            final altGuvenliAlan = MediaQuery.of(context).padding.bottom;

            return Scaffold(
              backgroundColor: Colors.black,
              body: Stack(
                children: [
                  PageView.builder(
                    controller: pageController,
                    itemCount: liste.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      final kiyafet = liste[index];
                      return InteractiveViewer(
                        minScale: 1.0,
                        maxScale: 3.5,
                        child: Center(
                          child: Image.memory(
                            kiyafet.resimBytes,
                            fit: BoxFit.contain,
                            width: double.infinity,
                            errorBuilder: (_, __, ___) => Center(
                              child: Icon(Icons.broken_image_outlined, color: colors.onSurfaceVariant),
                            ),
                            height: double.infinity,
                          ),
                        ),
                      );
                    },
                  ),
                  Positioned(
                    top: MediaQuery.of(context).padding.top + 10,
                    left: 16,
                    child: CircleAvatar(
                      backgroundColor: Colors.black.withValues(alpha: 0.5),
                      child: IconButton(
                        icon: const Icon(Icons.close_rounded, color: Colors.white),
                        onPressed: () {
                          HapticFeedback.selectionClick();
                          Navigator.pop(dialogContext);
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: AnimatedBuilder(
                      animation: pageController,
                      builder: (context, child) {
                        int currentIndex = pageController.hasClients
                            ? (pageController.page?.round() ?? baslangicIndex)
                            : baslangicIndex;
                        final suAnkiKiyafet = liste[currentIndex];

                        return Container(
                          padding: EdgeInsets.fromLTRB(20, 32, 20, 20 + altGuvenliAlan),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withValues(alpha: 0.95),
                                Colors.black.withValues(alpha: 0.6),
                                Colors.transparent,
                              ],
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          suAnkiKiyafet.gorunenBaslik,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: AppText.sizeTitle,
                                            fontWeight: FontWeight.w900,
                                            letterSpacing: -0.5,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "${suAnkiKiyafet.renk} • ${_kategoriEtiketiGetir(suAnkiKiyafet.kategori, l10n)}",
                                          style: TextStyle(
                                            color: Colors.white.withValues(alpha: 0.7),
                                            fontSize: AppText.sizeBodySmall,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.2),
                                      borderRadius: AppRadius.mdRadius,
                                    ),
                                    child: Text(
                                      "${currentIndex + 1} / ${liste.length}",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: AppText.sizeCaption,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        HapticFeedback.selectionClick();
                                        widget.onSepetToggle(suAnkiKiyafet.id);
                                        setState(() {});
                                        setModalState(() {});
                                      },
                                      icon: Icon(
                                        suAnkiKiyafet.sepetteMi ? Icons.refresh_rounded : Icons.local_laundry_service_rounded,
                                        size: 18,
                                        color: suAnkiKiyafet.sepetteMi ? colors.onErrorContainer : Colors.black,
                                      ),
                                      label: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          suAnkiKiyafet.sepetteMi ? l10n.gardirobumDolabaAl : l10n.gardirobumSepeteAt,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: suAnkiKiyafet.sepetteMi ? colors.onErrorContainer : Colors.black,
                                          ),
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: suAnkiKiyafet.sepetteMi ? colors.errorContainer : Colors.white,
                                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: AppRadius.lgRadius,
                                          side: suAnkiKiyafet.sepetteMi
                                              ? BorderSide(color: colors.error.withValues(alpha: 0.4), width: 1.2)
                                              : BorderSide.none,
                                        ),
                                        elevation: 0,
                                      ),
                                    ),
                                  ),
                                  if (widget.onKombinIstegi != null && !suAnkiKiyafet.sepetteMi) ...[
                                    const SizedBox(width: 12),
                                    ElevatedButton(
                                      onPressed: () async {
                                        HapticFeedback.selectionClick();
                                        final kalan = await ReklamServisi().kalanHakGetir();
                                        if (kalan <= 0) {
                                          if (mounted) _kombinHakkiBittiDiyaloguGoster();
                                          return;
                                        }
                                        if (dialogContext.mounted) {
                                          Navigator.pop(dialogContext);
                                          widget.onKombinIstegi!(suAnkiKiyafet);
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppMiscColors.lightPurpleBg,
                                        padding: const EdgeInsets.all(AppSpacing.lg),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: AppRadius.lgRadius,
                                          side: const BorderSide(color: AppMiscColors.lightPurpleBorder, width: 1.2),
                                        ),
                                        elevation: 0,
                                      ),
                                      child: const Icon(Icons.auto_awesome_rounded, color: AppAccents.styleist, size: 20),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _izinUyarisiGoster(String baslik, String aciklama) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: AppBlur.cam, sigmaY: AppBlur.cam),
        child: AlertDialog(
          backgroundColor: colors.surfaceContainerHigh,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.dialogRadius,
            side: BorderSide(color: colors.outlineVariant.withValues(alpha: 0.4)),
          ),
          title: Text(
            baslik,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: AppText.sizeTitleSmall,
              letterSpacing: -0.5,
              color: colors.onSurface,
            ),
          ),
          content: Text(
            aciklama,
            style: TextStyle(
              fontSize: AppText.sizeBodySmall,
              color: colors.onSurfaceVariant,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                HapticFeedback.selectionClick();
                Navigator.pop(context);
              },
              child: Text(l10n.iptal, style: TextStyle(color: colors.onSurfaceVariant, fontSize: AppText.sizeBodySmall, fontWeight: FontWeight.bold)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: colors.onPrimary,
                shape: RoundedRectangleBorder(borderRadius: AppRadius.lgRadius),
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
              ),
              onPressed: () {
                HapticFeedback.selectionClick();
                Navigator.pop(context);
                openAppSettings();
              },
              child: Text(l10n.ayarlariAc, style: TextStyle(color: colors.onPrimary, fontSize: AppText.sizeBodySmall, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  void _fotoEklemeSecenegiGoster() {
    HapticFeedback.lightImpact();
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (bottomContext) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: AppBlur.cam, sigmaY: AppBlur.cam),
          child: Container(
            padding: const EdgeInsets.only(top: 16, bottom: 24),
            decoration: BoxDecoration(
              color: colors.surfaceContainerHigh,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              border: Border.all(color: colors.outlineVariant.withValues(alpha: 0.4)),
            ),
            child: SafeArea(
              // İçerik küçük ekran/yatay modda taşmasın: çekim ipuçları
              // pencereye eklendiği için kaydırma gerekli.
              child: SingleChildScrollView(
                child: // ListTile'lar kendi zeminini çizer; aralarında
                    // Material olmazsa mürekkep sıçramaları görünmez.
                    Material(
                      type: MaterialType.transparency,
                      child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 48,
                        height: 5,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: colors.outlineVariant,
                          borderRadius: AppRadius.mdRadius,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl, vertical: AppSpacing.sm),
                      child: Text(
                        l10n.kiyafetEkle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: AppText.sizeTitle,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                          color: colors.onSurface,
                        ),
                      ),
                    ),
                    // Çekim ipuçları: kesim kalitesini en çok zemin belirliyor;
                    // kullanıcı tam çekim anında görsün.
                    Padding(
                      padding: const EdgeInsets.fromLTRB(AppSpacing.xxl, 0, AppSpacing.xxl, AppSpacing.xs),
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.md, AppSpacing.md),
                        decoration: BoxDecoration(
                          color: colors.primaryContainer.withValues(alpha: 0.35),
                          borderRadius: AppRadius.lgRadius,
                          border: Border.all(color: colors.primary.withValues(alpha: 0.25)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.tips_and_updates_rounded, size: 17, color: colors.primary),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    l10n.cekimIpucuBaslik,
                                    style: TextStyle(
                                      fontSize: AppText.sizeBodySmall,
                                      fontWeight: FontWeight.bold,
                                      color: colors.onSurface,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            _cekimIpucuSatiri(colors, l10n.cekimIpucu1),
                            _cekimIpucuSatiri(colors, l10n.cekimIpucu2),
                            _cekimIpucuSatiri(colors, l10n.cekimIpucu3),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl, vertical: AppSpacing.xs),
                      leading: Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: colors.surfaceContainerHighest,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.camera_alt_rounded, color: colors.onSurface, size: 22),
                      ),
                      title: Text(
                        l10n.kameraIleCek,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: AppText.sizeBodyLarge,
                          color: colors.onSurface,
                        ),
                      ),
                      onTap: () {
                        HapticFeedback.selectionClick();
                        Navigator.pop(bottomContext);
                        _kiyafetEkleIslemi(ImageSource.camera);
                      },
                    ),
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl, vertical: AppSpacing.xs),
                      leading: Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: colors.surfaceContainerHighest,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.photo_library_rounded, color: colors.onSurface, size: 22),
                      ),
                      title: Text(
                        l10n.galeridenSecToplu,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: AppText.sizeBodyLarge,
                          color: colors.onSurface,
                        ),
                      ),
                      onTap: () {
                        HapticFeedback.selectionClick();
                        Navigator.pop(bottomContext);
                        _kiyafetEkleIslemi(ImageSource.gallery);
                      },
                    ),
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl, vertical: AppSpacing.xs),
                      leading: Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: colors.surfaceContainerHighest,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.cloud_upload_outlined, color: colors.onSurface, size: 22),
                      ),
                      title: Text(
                        l10n.arkaPlandaEkle,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: AppText.sizeBodyLarge,
                          color: colors.onSurface,
                        ),
                      ),
                      subtitle: Text(
                        l10n.arkaPlandaEkleAciklama,
                        style: TextStyle(
                          fontSize: AppText.sizeCaption,
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                      onTap: () {
                        HapticFeedback.selectionClick();
                        Navigator.pop(bottomContext);
                        _arkaPlandaEkleIslemi();
                      },
                    ),
                  ],
                      ),
                    ),
                ),
              ),
            ),
        );
      },
    );
  }

  /// Çekim ipucu satırı: küçük madde işareti + açıklama.
  Widget _cekimIpucuSatiri(ColorScheme colors, String metin) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.only(top: 6, end: 8),
            child: Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(color: colors.primary, shape: BoxShape.circle),
            ),
          ),
          Expanded(
            child: Text(
              metin,
              style: TextStyle(fontSize: AppText.sizeCaption, height: 1.35, color: colors.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }

  /// Fotoğrafları **arka planda** ekler: ekran kilitlenmez, kullanıcı
  /// uygulamayı kullanmaya devam eder. İlerleme uygulamanın her yerinde
  /// ince bir çubuk olarak görünür.
  Future<void> _arkaPlandaEkleIslemi() async {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;

    final maxLimit = await ReklamServisi().maxKiyafetLimitiniGetir();
    if (!mounted) return;

    final kalanSlot = maxLimit - widget.gardirobum.length;
    if (kalanSlot <= 0) {
      AnaEkranDialoglar.gardiropLimitiDolduDiyaloguGoster(
        context: context,
        anaRenk: widget.anaRenk,
        maxLimit: maxLimit,
      );
      return;
    }

    final files = await _picker.pickMultiImage(
      maxWidth: 1600,
      maxHeight: 1600,
      imageQuality: 90,
    );
    if (files.isEmpty || !mounted) return;

    final dil = aiHedefDil(Localizations.localeOf(context).languageCode);

    // İş ekrandan bağımsız sürer; ekran kapansa da parçalar eklenir.
    await KilyafetYuklemeServisi().baslat(
      dosyalar: files,
      dil: dil,
      parcaEklendi: (kiyafet) async => widget.onKiyafetEkle(kiyafet),
    );

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.arkaPlandaBasladi(files.length)),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.lgRadius),
        backgroundColor: colors.primary,
      ),
    );
  }

  Future<void> _kiyafetEkleIslemi(ImageSource source) async {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;

    // Kıyafet yüklemek günlük hak harcamaz; sadece gardırop kapasitesi
    // (21 + reklamla eklenen slotlar) geçerlidir. Reklam yalnızca
    // kombin oluştururken gösterilir.
    final int maxLimit = await ReklamServisi().maxKiyafetLimitiniGetir();
    if (!mounted) return;

    final int kalanSlot = maxLimit - widget.gardirobum.length;
    if (kalanSlot <= 0) {
      AnaEkranDialoglar.gardiropLimitiDolduDiyaloguGoster(
        context: context,
        anaRenk: widget.anaRenk,
        maxLimit: maxLimit,
      );
      return;
    }

    final aiDili = aiHedefDil(Localizations.localeOf(context).languageCode);
    final random = Random();

    try {
      List<XFile> files = [];

      if (source == ImageSource.camera) {
        var cameraStatus = await Permission.camera.status;
        if (cameraStatus.isDenied) {
          // Önce neden istediğimizi anlat, sonra sistem penceresini aç.
          final kabul = await IzinGerekce.goster(
            context,
            baslik: l10n.izinGerekceKameraBaslik,
            aciklama: l10n.izinGerekceKameraAciklama,
            butonMetni: l10n.anaIzinVer,
            vazgecMetni: l10n.izinGerekceSimdiDegil,
          );
          if (!kabul || !mounted) return;
          cameraStatus = await Permission.camera.request();
        }

        if (cameraStatus.isPermanentlyDenied) {
          if (!mounted) return;
          _izinUyarisiGoster(l10n.kameraIzniGerekliBaslik, l10n.kameraIzniGerekliAciklama);
          return;
        }

        if (!cameraStatus.isGranted) return;

        // 1600 px / q90: kesim kalitesi doğrudan girdi çözünürlüğüne bağlı.
        // 800 px/q75'te ince parçalar (bağcık, toka, ince askı) maskede
        // kayboluyor ve kenarlar bulanık kalıyordu; 1600 px'te sunucu süresi
        // yalnızca ~0,2 sn artıyor (bkz. sunucu/KURULUM.md ölçümleri).
        final XFile? singleFile = await _picker.pickImage(
          source: ImageSource.camera,
          maxWidth: 1600,
          maxHeight: 1600,
          imageQuality: 90,
        );
        if (singleFile != null) files.add(singleFile);
      } else {
        files = await _picker.pickMultiImage(
          maxWidth: 1600,
          maxHeight: 1600,
          imageQuality: 90,
        );
      }

      if (files.isEmpty) return;

      // Gardıropta kalan slot sayısından fazla fotoğraf seçildiyse
      // yükleme kapasiteye göre sınırlandırılır (hak harcanmaz).
      if (files.length > kalanSlot) {
        files = files.take(kalanSlot).toList();
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.gardirobumMaksFotografUyari(kalanSlot)),
            backgroundColor: AppAccents.warning,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: AppRadius.lgRadius),
          ),
        );
      }

      await WakelockPlus.enable();

      setState(() {
        _otomatikYukleniyor = true;
        _totalPhotos = files.length;
        _currentPhotoIndex = 0;
        _currentStep = 'bg_removal';
      });
      _yuklemeAnimasyonunuBaslat();

      int basarisizFotografSayisi = 0;
      for (int i = 0; i < files.length; i++) {
        if (!mounted) return;

        try {
          if (!mounted) return;
          setState(() {
            _yuklemeDurumMesaji = l10n.gardirobumInceleniyor((i + 1).toString(), files.length.toString());
          });

          final currentFile = files[i];
          final orijinalBytes = await currentFile.readAsBytes();

          // 🎯 Arkaplanı sil — önce YEREL sunucu (rembg, gerekirse tekrar),
          // olmazsa bulut (remove.bg). İkisi de olmazsa kullanıcıya sorulur;
          // sessizce arka planlı kaydetmek "arka plan silinmiyor" izlenimi
          // veriyordu.
          if (!mounted) return;
          setState(() {
            _currentStep = 'bg_removal';
            _currentPhotoIndex = i + 1;
          });

          Uint8List? bgRemoved;
          var fotografAtlandi = false;

          while (true) {
            bgRemoved = await ArkaPlanSilmeYardimcisi.dene(
              orijinalBytes,
              yerel: BackgroundRemoverService.removeBackground,
              bulut: (baytlar) => BackgroundRemovalService().removeBackground(
                imageBytes: baytlar,
                size: 'auto',
                format: 'png',
              ),
            );
            if (bgRemoved != null) break;

            if (!mounted) return;
            final karar = await _arkaPlanSilinemediKarari(i + 1, files.length);
            if (karar == ArkaPlanKarari.tekrarDene) continue;
            if (karar == ArkaPlanKarari.atla) fotografAtlandi = true;
            break;
          }

          // Kullanıcı "bu fotoğrafı atla" dediyse hiç ekleme.
          if (fotografAtlandi) {
            basarisizFotografSayisi++;
            continue;
          }

          // Temiz kesim: AI analizi ve kalite denetimi bunu görür.
          Uint8List kesimBytes = orijinalBytes;
          if (bgRemoved != null) {
            // 🧭 Yön + çerçeve standardı: arka planı silinmiş görsel hâlâ
            // YATAYSA dikeyleştir (EXIF yönünü sunucu zaten uygular; burada
            // yalnızca gerçekten yatay kalan fotoğraflar düzeltilir → çift
            // döndürme olmaz), ardından çevresindeki boş alanı kırp ki kıyafet
            // ızgarada tüm kutuyu doldursun. Maske temizliği (leke/delik) da
            // aynı turda yapılır.
            kesimBytes = await GorselYonService.duzenle(bgRemoved) ?? bgRemoved;
          }

          // Kaydedilecek görsel: başta temiz kesim, kullanıcı yerleştirme
          // yaparsa zeminli hâli.
          Uint8List kaydedilecekBytes = kesimBytes;

          // 🎛️ Yerleşim: kullanıcı parçanın arka planını ve konumunu seçer.
          // (AI analizi daima temiz kesimi görür; düzenleme yalnızca kaydedilen
          //  görseli etkiler.)
          if (bgRemoved != null && mounted) {
            final duzenlenmis = await KiyafetDuzenleyici.ac(
              context,
              kesim: kesimBytes,
            );
            if (!mounted) return;
            if (duzenlenmis != null) kaydedilecekBytes = duzenlenmis;
          }

          // 🎨 Zemin denetimi: kıyafet zemine çok yakın renkteyse hiçbir model
          // sınırı bulamaz (arka plandan parça kalır / kıyafetten parça kesilir).
          // Bunu kaydettikten çok sonra değil, tam şimdi söyle ki kullanıcı
          // yeni bir fotoğrafla düzeltebilsin.
          if (bgRemoved != null && mounted) {
            final zeminBenzer = await KesimKaliteDenetimi.zeminBenzerMi(
              orijinalBytes,
              kesimBytes,
            );
            if (!mounted) return;
            if (zeminBenzer) {
              final tekrarCek = await _zeminBenzerKarari(i + 1, files.length);
              if (tekrarCek) {
                _yenidenCekIstendi = true;
                continue;
              }
            }
          }

          // 🤖 AI Analiz
          if (!mounted) return;
          setState(() {
            _currentStep = 'ai_analysis';
          });

          final analiz = await KiyafetAnalizServisi.analizEt(
            resim: kesimBytes,
            dil: aiDili,
          );

          // 🔧 Benzersiz ID: timestamp + static counter + random + bytes length
          _idCounter++;
          final uniqueId = "${DateTime.now().microsecondsSinceEpoch}_${_idCounter}_${random.nextInt(999999999)}_${kaydedilecekBytes.length}";

          if (!mounted) return;
          setState(() {
            _currentStep = 'saving';
          });

          widget.onKiyafetEkle(
            Kiyafet(
              id: uniqueId,
              baslik: analiz.baslik,
              kategori: analiz.kategori,
              resimBytes: kaydedilecekBytes,
              renk: analiz.renk,
              stil: analiz.stil,
              mevsim: analiz.mevsim,
              fiyat: 0.0,
            ),
          );
        } catch (e) {
          basarisizFotografSayisi++;
          debugPrint("${i + 1}. fotoğraf analiz edilemedi, işleme devam ediliyor: $e");
        }
      }

      if (basarisizFotografSayisi > 0 && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.gardirobumHataMesaji),
            backgroundColor: AppAccents.warning,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: AppRadius.lgRadius),
          ),
        );
      }
    } catch (e) {
      debugPrint("Görsel Analiz Hatası: $e");
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.gardirobumHataMesaji),
          backgroundColor: colors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.lgRadius),
        ),
      );
    } finally {
      await WakelockPlus.disable();

      if (mounted) {
        _yuklemeAnimasyonunuDurdur();
        setState(() {
          _otomatikYukleniyor = false;
          _yuklemeDurumMesaji = l10n.gardirobumYukleniyor;
        });
      }
    }

    // Kullanıcı "tekrar çek" dediyse, tur bittiğinde kamerayı yeniden aç.
    if (_yenidenCekIstendi) {
      _yenidenCekIstendi = false;
      if (mounted) {
        await _kiyafetEkleIslemi(ImageSource.camera);
      }
    }
  }

  Future<String> _gorselAnaliziniTekrarDene({
    required String sistemPromptu,
    required String kullaniciMesaji,
    required Uint8List resimBytes,
  }) async {
    Object? sonHata;

    for (int deneme = 1; deneme <= 3; deneme++) {
      try {
        return await AiService().hibritAiSorgula(
          sistemPromptu: sistemPromptu,
          kullaniciMesaji: kullaniciMesaji,
          resimler: <Uint8List>[resimBytes],
        );
      } catch (e) {
        sonHata = e;
        if (deneme < 3) {
          await Future.delayed(Duration(seconds: deneme * 2));
        }
      }
    }

    throw sonHata ?? const AiServiceException();
  }

  void _kiyafetDuzenle(Kiyafet item) {
    HapticFeedback.lightImpact();
    final controller = TextEditingController(text: item.gorunenBaslik);
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    String secilenKategori = item.kategori.toLowerCase();

    // 🧭 Görsel yönü: döndürme yalnızca "Kaydet"e basılırsa kalıcı olur;
    // "İptal" edilirse hiçbir şey değişmez.
    var guncelResim = item.resimBytes;
    var donduruluyor = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: AppBlur.cam, sigmaY: AppBlur.cam),
        child: StatefulBuilder(
          builder: (context, setDialogState) => Container(
            decoration: BoxDecoration(
              color: colors.surfaceContainerHigh,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
              border: Border.all(color: colors.outlineVariant.withValues(alpha: 0.4)),
            ),
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: 12, bottom: 8),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: colors.onSurfaceVariant.withValues(alpha: 0.4),
                        borderRadius: AppRadius.xxsRadius,
                      ),
                    ),
                  ),
                  // Title
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.sm),
                          decoration: BoxDecoration(color: colors.surfaceContainerHighest, shape: BoxShape.circle),
                          child: Icon(
                            Icons.edit_note_rounded,
                            color: colors.onSurface,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            l10n.kiyafetDuzenleBaslik,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: AppText.sizeTitleSmall,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.5,
                              color: colors.onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // 🧭 Görsel önizleme + döndürme (yan görünen kıyafetler)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                    child: Row(
                      children: [
                        Container(
                          width: 78,
                          height: 98,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            color: colors.surfaceContainerHighest,
                            borderRadius: AppRadius.lgRadius,
                            border: Border.all(
                              color: colors.outlineVariant.withValues(alpha: 0.4),
                            ),
                          ),
                          child: Image.memory(
                            guncelResim,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => Icon(
                              Icons.broken_image_outlined,
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: donduruluyor
                                  ? null
                                  : () async {
                                      HapticFeedback.selectionClick();
                                      setDialogState(() => donduruluyor = true);
                                      final donuk = await GorselYonService
                                          .saatYonundeDondur(guncelResim);
                                      if (!context.mounted) return;
                                      setDialogState(() {
                                        if (donuk != null) guncelResim = donuk;
                                        donduruluyor = false;
                                      });
                                    },
                              icon: donduruluyor
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    )
                                  : const Icon(Icons.rotate_90_degrees_cw_rounded, size: 18),
                              label: Text(
                                l10n.kiyafetDondur,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                                side: BorderSide(color: colors.outlineVariant),
                                shape: RoundedRectangleBorder(
                                  borderRadius: AppRadius.lgRadius,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Content
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: controller,
                          autofocus: true,
                          style: TextStyle(color: colors.onSurface, fontSize: AppText.sizeBodySmall),
                          decoration: InputDecoration(
                            labelText: l10n.kiyafetAdiEtiketi,
                            labelStyle: TextStyle(color: colors.onSurfaceVariant),
                            filled: true,
                            fillColor: colors.surfaceContainerHighest,
                            border: OutlineInputBorder(borderRadius: AppRadius.lgRadius, borderSide: BorderSide.none),
                            focusedBorder: OutlineInputBorder(borderRadius: AppRadius.lgRadius, borderSide: BorderSide(color: colors.onSurface, width: 2)),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.kategori,
                          style: TextStyle(fontSize: AppText.sizeBodySmall, fontWeight: FontWeight.bold, color: colors.onSurfaceVariant),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                          decoration: BoxDecoration(
                            color: colors.surfaceContainerHighest,
                            borderRadius: AppRadius.lgRadius,
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: ['ust', 'alt', 'ayakkabi', 'aksesuar'].contains(secilenKategori) ? secilenKategori : 'ust',
                              isExpanded: true,
                              dropdownColor: colors.surfaceContainerHigh,
                              style: TextStyle(color: colors.onSurface, fontSize: AppText.sizeBodySmall, fontWeight: FontWeight.w600),
                              items: [
                                DropdownMenuItem(value: 'ust', child: Text(l10n.gardirobumKategoriUst)),
                                DropdownMenuItem(value: 'alt', child: Text(l10n.gardirobumKategoriAlt)),
                                DropdownMenuItem(value: 'ayakkabi', child: Text(l10n.gardirobumKategoriAyakkabi)),
                                DropdownMenuItem(value: 'aksesuar', child: Text(l10n.gardirobumKategoriAksesuar)),
                              ],
                              onChanged: (val) {
                                if (val != null) {
                                  setDialogState(() {
                                    secilenKategori = val;
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Actions
                  Padding(
                    padding: const EdgeInsets.fromLTRB(AppSpacing.xl, 0, AppSpacing.xl, AppSpacing.xxl),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              HapticFeedback.selectionClick();
                              Navigator.pop(sheetContext);
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                              shape: RoundedRectangleBorder(borderRadius: AppRadius.lgRadius),
                            ),
                            child: Text(l10n.iptal, style: TextStyle(color: colors.onSurfaceVariant, fontSize: AppText.sizeBodySmall, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colors.primary,
                              foregroundColor: colors.onPrimary,
                              shape: RoundedRectangleBorder(borderRadius: AppRadius.lgRadius),
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                            ),
                            onPressed: () {
                              HapticFeedback.selectionClick();
                              final yeniIsim = controller.text.trim();
                              setState(() {
                                if (yeniIsim.isNotEmpty) {
                                  item.kullaniciBasligi = yeniIsim;
                                }
                                item.kategori = secilenKategori;
                                // 🧭 Döndürme yalnızca burada kalıcılaşır.
                                item.resimBytes = guncelResim;
                              });
                              widget.onKiyafetEkle(item);
                              Navigator.pop(sheetContext);
                            },
                            child: Text(l10n.kaydet, style: TextStyle(color: colors.onPrimary, fontWeight: FontWeight.bold, fontSize: AppText.sizeBodySmall)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _temizlemeOnayiAl() {
    HapticFeedback.mediumImpact();
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: AppBlur.cam, sigmaY: AppBlur.cam),
        child: AlertDialog(
          backgroundColor: colors.surfaceContainerHigh,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.dialogRadius,
            side: BorderSide(color: colors.outlineVariant.withValues(alpha: 0.4)),
          ),
          title: Text(
            l10n.gardirobumTemizleBaslik,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: AppText.sizeTitleSmall,
              letterSpacing: -0.5,
              color: colors.onSurface,
            ),
          ),
          content: Text(
            l10n.gardirobumTemizleOnay,
            style: TextStyle(
              fontSize: AppText.sizeBodySmall,
              color: colors.onSurfaceVariant,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                HapticFeedback.selectionClick();
                Navigator.pop(context);
              },
              child: Text(l10n.iptal, style: TextStyle(color: colors.onSurfaceVariant, fontSize: AppText.sizeBodySmall, fontWeight: FontWeight.bold)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.error,
                shape: RoundedRectangleBorder(borderRadius: AppRadius.lgRadius),
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.md),
              ),
              onPressed: () {
                HapticFeedback.selectionClick();
                Navigator.pop(context);
                widget.onGardirobuTemizle();
              },
              child: Text(l10n.evetSil, style: TextStyle(color: colors.onError, fontWeight: FontWeight.bold, fontSize: AppText.sizeBodySmall)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _kiyafetKartiOlustur(Kiyafet item, int index, List<Kiyafet> kategoriListesi, AppLocalizations l10n) {
    final colors = Theme.of(context).colorScheme;
    final bool acik = _acikKartId == item.id;

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() {
          _acikKartId = acik ? null : item.id;
        });
      },
      child: AnimatedContainer(
        width: 155,
        duration: AppMotion.normal,
        curve: AppMotion.standart,
        key: ValueKey(item.id),
        decoration: BoxDecoration(
          color: colors.surfaceContainerLow,
          borderRadius: AppRadius.lgRadius,
          border: Border.all(
            color: colors.outlineVariant,
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: AppRadius.lgRadius,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Positioned.fill(
                      child: ColoredBox(color: colors.surfaceContainer),
                    ),
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0, end: item.sepetteMi ? 1 : 0),
                      duration: AppMotion.orta,
                      builder: (context, value, child) {
                        return ColorFiltered(
                          colorFilter: ColorFilter.matrix(<double>[
                            0.2126 + 0.7874 * (1 - value), 0.7152 - 0.7152 * (1 - value), 0.0722 - 0.0722 * (1 - value), 0, 0,
                            0.2126 - 0.2126 * (1 - value), 0.7152 + 0.2848 * (1 - value), 0.0722 - 0.0722 * (1 - value), 0, 0,
                            0.2126 - 0.2126 * (1 - value), 0.7152 - 0.7152 * (1 - value), 0.0722 + 0.9278 * (1 - value), 0, 0,
                            0, 0, 0, 1, 0,
                          ]),
                          child: Padding(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            child: Image.memory(
                              item.resimBytes,
                              // 🔍 contain: yatay kalan görsellerde kıyafetin
                              // kenarları kırpılmasın (cover kırpıyordu).
                              fit: BoxFit.contain,
                              // Sığmayan görsel kartın üstüne yaslanır; ortalı
                              // bırakıldığında üstte boş bir bant kalıyordu.
                              alignment: Alignment.topCenter,
                              errorBuilder: (_, __, ___) => Center(
                                child: Icon(Icons.broken_image_outlined, color: colors.onSurfaceVariant),
                              ),
                            ),
                          ),
                        );
                      },
                    ),

// Tam ekran galeri, düzenle ve sil butonları
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Row(
                        children: [
                          if (acik) ...[
                            GestureDetector(
                              onTap: () => _tamEkranGaleriyiGoster(index, kategoriListesi),
                              child: Container(
                                padding: const EdgeInsets.all(AppSpacing.sm),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.5),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                                ),
                                child: const Icon(Icons.fullscreen_rounded, color: Colors.white, size: 14),
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () => _kiyafetDuzenle(item),
                              child: Container(
                                padding: const EdgeInsets.all(AppSpacing.sm),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.5),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                                ),
                                child: const Icon(Icons.edit_rounded, color: Colors.white, size: 14),
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () {
                                HapticFeedback.heavyImpact();
                                widget.onKiyafetSil(item.id);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(AppSpacing.sm),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.5),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                                ),
                                child: const Icon(Icons.delete_rounded, color: Colors.white, size: 14),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    // Sepette Mi Rozeti (Kırmızı Devre Dışı/Kirli Vurgusu)
                    AnimatedPositioned(
                      duration: AppMotion.normal,
                      curve: AppMotion.tepki,
                      top: item.sepetteMi ? 8 : -30,
                      left: 8,
                      child: AnimatedOpacity(
                        duration: AppMotion.kisa,
                        opacity: item.sepetteMi ? 1.0 : 0.0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                          decoration: BoxDecoration(
                            color: colors.error,
                            borderRadius: AppRadius.smRadius,
                          ),
                          child: const Icon(Icons.local_laundry_service_rounded, color: Colors.white, size: 14),
                        ),
                      ),
                    ),

                  ],
                ),
              ),

              // Kapalı durumda ad etiketi: fotoğrafın üstüne binmez, kart
              // yüzeyinde okunur (açık/koyu temada aynı kontrast).
              if (!acik)
                Padding(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.sm, AppSpacing.md),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.gorunenBaslik,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: item.sepetteMi
                                ? colors.onSurfaceVariant.withValues(alpha: 0.6)
                                : colors.onSurface,
                            fontSize: AppText.sizeSmall,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.xs),
                        decoration: BoxDecoration(
                          color: colors.primaryContainer,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.keyboard_arrow_up_rounded,
                          color: colors.onPrimaryContainer,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                ),

              // Açık Durumdaki Alt Detay Paneli
              AnimatedCrossFade(
                firstChild: const SizedBox(width: double.infinity, height: 0),
                secondChild: Padding(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        item.gorunenBaslik,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: AppText.sizeBodySmall,
                          height: 1.1,
                          letterSpacing: -0.3,
                          color: item.sepetteMi ? colors.onSurfaceVariant.withValues(alpha: 0.5) : colors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${item.renk} • ${_kategoriEtiketiGetir(item.kategori, l10n)}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: AppText.sizeCaption,
                          color: colors.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 32,
                              child: ElevatedButton(
                                onPressed: () {
                                  HapticFeedback.selectionClick();
                                  widget.onSepetToggle(item.id);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: item.sepetteMi
                                      ? colors.errorContainer
                                      : colors.primary,
                                  foregroundColor: item.sepetteMi
                                      ? colors.onErrorContainer
                                      : colors.onPrimary,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: AppRadius.mdRadius,
                                    side: item.sepetteMi
                                        ? BorderSide(color: colors.error.withValues(alpha: 0.4), width: 1.2)
                                        : BorderSide.none,
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      item.sepetteMi ? Icons.refresh_rounded : Icons.local_laundry_service_rounded,
                                      size: 14,
                                      color: item.sepetteMi
                                          ? colors.onErrorContainer
                                          : colors.onPrimary,
                                    ),
                                    const SizedBox(width: 4),
                                    Flexible(
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        alignment: AlignmentDirectional.centerStart,
                                        child: Text(
                                          item.sepetteMi ? l10n.gardirobumDolabaAl : l10n.gardirobumSepeteAt,
                                          style: TextStyle(
                                            fontSize: AppText.sizeCaption,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: 0.1,
                                            color: item.sepetteMi
                                                ? colors.onErrorContainer
                                                : colors.onPrimary,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          if (!item.sepetteMi && widget.onKombinIstegi != null) ...[
                            const SizedBox(width: 4),
                            SizedBox(
                              height: 32,
                              width: 32,
                              child: ElevatedButton(
                                onPressed: () async {
                                  HapticFeedback.lightImpact();
                                  final kalan = await ReklamServisi().kalanHakGetir();
                                  if (!mounted) return;
                                  if (kalan <= 0) {
                                    _kombinHakkiBittiDiyaloguGoster();
                                    return;
                                  }
                                  widget.onKombinIstegi!(item);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTints.successBg,
                                  foregroundColor: AppAccents.styleist,
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: AppRadius.mdRadius,
                                    side: const BorderSide(color: AppMiscColors.lightPurpleBorder, width: 1.0),
                                  ),
                                  elevation: 0,
                                ),
                                child: const Icon(Icons.auto_awesome_rounded, color: AppAccents.styleist, size: 14),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                crossFadeState: acik ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                duration: AppMotion.kisa,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Arama + kategori filtresi
  // ---------------------------------------------------------------------------

  /// Kayıtlı kategori ne olursa olsun parçayı doğru rafa yerleştirir.
  /// AI bazen 'ceket', 'üst', 'pantolon' gibi serbest metin döndürüyor;
  /// bunlar eskiden hiçbir rafta görünmüyordu (kayıp parça).
  String _rafKategorisi(Kiyafet kiyafet) => dolapRafKategorisi(kiyafet);

  List<Kiyafet> _gorunenParcalar() {
    return dolapFiltrele(
      widget.gardirobum,
      sorgu: _aramaMetni,
      kategori: _kategoriFiltresi,
    );
  }

  void _aramayiTemizle() {
    _aramaDenetleyici.clear();
    setState(() {
      _aramaMetni = '';
      _kategoriFiltresi = 'tumu';
    });
  }

  Widget _aramaVeFiltre(AppLocalizations l10n, ColorScheme colors) {
    final cipler = <MapEntry<String, String>>[
      MapEntry('tumu', l10n.gardirobumKategoriTumu),
      MapEntry('ust', l10n.gardirobumKategoriUst),
      MapEntry('alt', l10n.gardirobumKategoriAlt),
      MapEntry('ayakkabi', l10n.gardirobumKategoriAyakkabi),
      MapEntry('aksesuar', l10n.gardirobumKategoriAksesuar),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, 0),
          child: TextField(
            controller: _aramaDenetleyici,
            onChanged: (deger) => setState(() => _aramaMetni = deger),
            textInputAction: TextInputAction.search,
            style: const TextStyle(fontSize: AppText.sizeBodySmall),
            decoration: InputDecoration(
              hintText: l10n.dolapAra,
              isDense: true,
              filled: true,
              fillColor: colors.surfaceContainerHighest.withValues(alpha: 0.55),
              prefixIcon: Icon(
                Icons.search_rounded,
                size: 20,
                color: colors.onSurfaceVariant,
              ),
              suffixIcon: _aramaMetni.isEmpty
                  ? null
                  : IconButton(
                      tooltip: l10n.dolapAramayiTemizle,
                      icon: Icon(
                        Icons.close_rounded,
                        size: 18,
                        color: colors.onSurfaceVariant,
                      ),
                      onPressed: _aramayiTemizle,
                    ),
              hintStyle: TextStyle(
                fontSize: AppText.sizeBodySmall,
                color: colors.onSurfaceVariant,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.lg),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            ),
          ),
        ),
        SizedBox(
          height: 56,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.sm),
            itemCount: cipler.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, i) {
              final cip = cipler[i];
              final secili = _kategoriFiltresi == cip.key;
              return ChoiceChip(
                label: Text(cip.value),
                selected: secili,
                onSelected: (_) {
                  HapticFeedback.selectionClick();
                  setState(() => _kategoriFiltresi = cip.key);
                },
                showCheckmark: false,
                visualDensity: VisualDensity.compact,
                backgroundColor:
                    colors.surfaceContainerHighest.withValues(alpha: 0.55),
                selectedColor: colors.primary,
                side: BorderSide.none,
                labelStyle: TextStyle(
                  fontSize: AppText.sizeCaption,
                  fontWeight: FontWeight.w700,
                  color: secili ? colors.onPrimary : colors.onSurfaceVariant,
                ),
              );
            },
          ),
        ),
        if (_filtreAktif)
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.xs),
            child: Text(
              l10n.gardirobumUrunSayisi(_gorunenParcalar().length),
              style: TextStyle(
                fontSize: AppText.sizeCaption,
                fontWeight: FontWeight.bold,
                color: colors.onSurfaceVariant,
              ),
            ),
          ),
      ],
    );
  }

  Widget _eslesmeYok(AppLocalizations l10n, ColorScheme colors) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.xxxl, 40, AppSpacing.xxxl, AppSpacing.lg),
      child: Column(
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 40,
            color: colors.onSurfaceVariant.withValues(alpha: 0.6),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.dolapEslesmeYok,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: AppText.sizeBodySmall, color: colors.onSurfaceVariant),
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: _aramayiTemizle,
            icon: const Icon(Icons.close_rounded, size: 16),
            label: Text(l10n.dolapAramayiTemizle),
          ),
        ],
      ),
    );
  }

  /// Arama kutusu + raflar. Filtre açıkken boş raflar gizlenir.
  List<Widget> _dolapIcerigi(AppLocalizations l10n, ColorScheme colors) {
    final parcalar = _gorunenParcalar();
    final raflar = <MapEntry<String, String>>[
      MapEntry('ust', l10n.gardirobumKategoriUst),
      MapEntry('alt', l10n.gardirobumKategoriAlt),
      MapEntry('ayakkabi', l10n.gardirobumKategoriAyakkabi),
      MapEntry('aksesuar', l10n.gardirobumKategoriAksesuar),
    ];

    final icerik = <Widget>[_aramaVeFiltre(l10n, colors)];
    var gosterilenRaf = 0;

    for (final raf in raflar) {
      final rafParcalari =
          parcalar.where((k) => _rafKategorisi(k) == raf.key).toList();
      if (_filtreAktif && rafParcalari.isEmpty) continue;
      gosterilenRaf++;
      icerik.add(_yatayKategoriRafi(
        raf.key,
        raf.value,
        l10n,
        rafParcalari,
        sayiGoster: !_filtreAktif,
      ));
    }

    if (_filtreAktif && gosterilenRaf == 0) {
      icerik.add(_eslesmeYok(l10n, colors));
    }

    return icerik;
  }

  Widget _yatayKategoriRafi(
    String kategoriAnahtari,
    String kategoriBasligi,
    AppLocalizations l10n,
    List<Kiyafet> kategoriListesi, {
    /// Filtre açıkken toplam sayı zaten üstte yazıyor; raf başlığındaki
    /// sayıyı tekrarlamıyoruz.
    bool sayiGoster = true,
  }) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    kategoriBasligi,
                    style: TextStyle(
                      fontSize: AppText.sizeTitleSmall,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                      color: colors.onSurface,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              if (sayiGoster)
                Text(
                  l10n.gardirobumUrunSayisi(kategoriListesi.length),
                  style: TextStyle(
                    fontSize: AppText.sizeCaption,
                    fontWeight: FontWeight.bold,
                    color: colors.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ),
        SizedBox(
          height: 265,
          child: kategoriListesi.isEmpty
              ? ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    GestureDetector(
                      onTap: _fotoEklemeSecenegiGoster,
                      child: Container(
                        width: 155,
                        decoration: BoxDecoration(
                          color: colors.surfaceContainerLow,
                          borderRadius: AppRadius.xxlRadius,
                          border: Border.all(
                            color: colors.outlineVariant.withValues(alpha: 0.5),
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_circle_outline_rounded, size: 36, color: colors.onSurfaceVariant),
                            const SizedBox(height: 12),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                              child: Text(
                                l10n.gardirobumHenuzYokEkle,
                                textAlign: TextAlign.center,
                                style: TextStyle(color: colors.onSurfaceVariant, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  itemCount: kategoriListesi.length,
                  itemBuilder: (context, index) {
                    final item = kategoriListesi[index];
                    return Padding(
                      padding: const EdgeInsetsDirectional.only(end: 16),
                      child: _kiyafetKartiOlustur(item, index, kategoriListesi, l10n),
                    );
                  },
                ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                pinned: false,
                floating: false,
                snap: false,
                backgroundColor: theme.scaffoldBackgroundColor,
                surfaceTintColor: Colors.transparent,
                elevation: 0,
                centerTitle: false,
                title: Row(
                  children: [
                    Flexible(
                      child: Text(
                        l10n.gardirobumTitle,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                          fontSize: AppText.sizeTitleSmall,
                          color: colors.onSurface,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    BilgiButonu(
                      baslik: l10n.gardirobumTitle,
                      aciklama: l10n.bilgiDolapCalisma,
                    ),
                  ],
                ),
                actions: [
                  IconButton(
                    icon: Icon(
                      _gizlendi ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                      color: colors.onSurfaceVariant,
                    ),
                    onPressed: () {
                      HapticFeedback.selectionClick();
                      setState(() {
                        _gizlendi = !_gizlendi;
                      });
                    },
                    tooltip: _gizlendi ? l10n.gardirobumGoster : l10n.gardirobumGizle,
                  ),
                  if (widget.gardirobum.isNotEmpty && !_gizlendi)
                    IconButton(
                      icon: Icon(
                        Icons.delete_sweep_rounded,
                        color: colors.error,
                      ),
                      onPressed: _temizlemeOnayiAl,
                      tooltip: l10n.gardirobumTemizleBaslik,
                    ),
                  const SizedBox(width: 8),
                ],
              ),
              if (_gizlendi)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.lock_outline_rounded,
                          size: 64,
                          color: colors.onSurfaceVariant.withValues(alpha: 0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.gardirobumGizlendiBaslik,
                          style: TextStyle(
                            fontSize: AppText.sizeTitleSmall,
                            fontWeight: FontWeight.bold,
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.gardirobumGizlendiAciklama,
                          style: TextStyle(
                            fontSize: AppText.sizeBodySmall,
                            color: colors.onSurfaceVariant.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else if (widget.gardirobum.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: GestureDetector(
                      onTap: _fotoEklemeSecenegiGoster,
                      child: Container(
                        margin: const EdgeInsets.all(AppSpacing.xxxl),
                        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: AppSpacing.xxl),
                        decoration: BoxDecoration(
                          color: colors.surfaceContainerLow,
                          borderRadius: AppRadius.xxlRadius,
                          border: Border.all(color: colors.outlineVariant.withValues(alpha: 0.5), width: 1.5),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(AppSpacing.lg),
                              decoration: BoxDecoration(color: colors.surfaceContainerHighest, shape: BoxShape.circle),
                              child: Icon(Icons.add_a_photo_outlined, size: 48, color: colors.onSurface),
                            ),
                            const SizedBox(height: 16),
                            Text(l10n.gardirobumBosBaslik, style: TextStyle(fontSize: AppText.sizeTitleSmall, fontWeight: FontWeight.w900, color: colors.onSurface)),
                            const SizedBox(height: 8),
                            Text(l10n.gardirobumBosAciklama, textAlign: TextAlign.center, style: TextStyle(fontSize: AppText.sizeBodySmall, color: colors.onSurfaceVariant, height: 1.4)),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              else
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 100),
                    child: Column(
                      children: _dolapIcerigi(l10n, colors),
                    ),
                  ),
                ),
            ],
          ),
          if (_otomatikYukleniyor)
            Positioned.fill(
              child: _YuklemeOverlay(
                currentStep: _currentStep,
                currentPhotoIndex: _currentPhotoIndex,
                totalPhotos: _totalPhotos,
                pulseAnimation: _pulseAnimation,
                aiMessages: _aiIslemMesajlari,
                aiMessageIndex: _aiMesajIndex,
                anaRenk: widget.anaRenk,
              ),
            ),
        ],
      ),
    );
  }
}

class _YuklemeOverlay extends StatelessWidget {
  final String currentStep; // 'bg_removal' | 'ai_analysis' | 'saving'
  final int currentPhotoIndex;
  final int totalPhotos;
  final Animation<double> pulseAnimation;
  final List<String> aiMessages;
  final int aiMessageIndex;
  final Color anaRenk;

  const _YuklemeOverlay({
    required this.currentStep,
    required this.currentPhotoIndex,
    required this.totalPhotos,
    required this.pulseAnimation,
    required this.aiMessages,
    required this.aiMessageIndex,
    required this.anaRenk,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    // Step bilgileri
    final stepInfo = _getStepInfo(context);

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: AppBlur.cam, sigmaY: AppBlur.cam),
      child: Container(
        color: Colors.black.withValues(alpha: 0.4),
        child: Center(
          child: AnimatedContainer(
            duration: AppMotion.orta,
            curve: AppMotion.giris,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl, vertical: 36),
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
            decoration: BoxDecoration(
              color: colors.surfaceContainerHigh,
              borderRadius: AppRadius.dialogRadius,
              border: Border.all(color: colors.outlineVariant.withValues(alpha: 0.3)),
              boxShadow: [
                BoxShadow(
                  color: anaRenk.withValues(alpha: 0.15),
                  blurRadius: 40,
                  offset: const Offset(0, 16),
                  spreadRadius: -8,
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 🎯 Ana ikon + pulse animasyonu
                AnimatedBuilder(
                  animation: pulseAnimation,
                  builder: (context, child) => Transform.scale(
                    scale: pulseAnimation.value,
                    child: child,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          anaRenk.withValues(alpha: 0.15),
                          anaRenk.withValues(alpha: 0.05),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: anaRenk.withValues(alpha: 0.25),
                          blurRadius: 30,
                          offset: const Offset(0, 12),
                          spreadRadius: -6,
                        ),
                      ],
                    ),
                    child: Icon(
                      stepInfo.icon,
                      color: anaRenk,
                      size: 42,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // 📝 Ana başlık
                Text(
                  stepInfo.title,
                  style: TextStyle(
                    fontSize: AppText.sizeTitle,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                    color: colors.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                // 📊 Progress bar (fotoğraf sayacı)
                if (totalPhotos > 0) ...[
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
                            decoration: BoxDecoration(
                              color: anaRenk.withValues(alpha: 0.12),
                              borderRadius: AppRadius.mdRadius,
                              border: Border.all(color: anaRenk.withValues(alpha: 0.3)),
                            ),
                            child: Text(
                              '$currentPhotoIndex / $totalPhotos',
                              style: TextStyle(
                                fontSize: AppText.sizeBodySmall,
                                fontWeight: FontWeight.w800,
                                color: anaRenk,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: 200,
                        child: Stack(
                          children: [
                            Container(
                              height: 6,
                              decoration: BoxDecoration(
                                color: colors.surfaceContainerHighest,
                                borderRadius: AppRadius.xxsRadius,
                              ),
                            ),
                            AnimatedContainer(
                              duration: AppMotion.uzun,
                              curve: AppMotion.giris,
                              width: (currentPhotoIndex / totalPhotos.clamp(1, 999)) * 200,
                              height: 6,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [anaRenk, anaRenk.withValues(alpha: 0.7)],
                                ),
                                borderRadius: AppRadius.xxsRadius,
                                boxShadow: [
                                  BoxShadow(
                                    color: anaRenk.withValues(alpha: 0.4),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                ],

                // 🔄 Step indicator dots
                _StepIndicator(
                  currentStep: currentStep,
                  anaRenk: anaRenk,
                  colors: colors,
                ),

                const SizedBox(height: 20),

                // 💬 AI mesajları (alt kısım)
                AnimatedSwitcher(
                  duration: AppMotion.orta,
                  switchInCurve: AppMotion.giris,
                  switchOutCurve: AppMotion.cikis,
                  child: aiMessages.isNotEmpty
                      ? Text(
                          aiMessages[aiMessageIndex % aiMessages.length],
                          key: ValueKey<int>(aiMessageIndex),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: AppText.sizeBodySmall,
                            fontWeight: FontWeight.w600,
                            color: colors.onSurfaceVariant,
                            height: 1.4,
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _StepInfo _getStepInfo(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (currentStep) {
      case 'bg_removal':
        return _StepInfo(
          title: l10n.gardirobumAdimArkaplan,
          subtitle: l10n.gardirobumAdimArkaplanAlt,
          icon: Icons.cut_rounded,
        );
      case 'ai_analysis':
        return _StepInfo(
          title: l10n.gardirobumAdimAnaliz,
          subtitle: l10n.gardirobumAdimAnalizAlt,
          icon: Icons.psychology_rounded,
        );
      case 'saving':
        return _StepInfo(
          title: l10n.gardirobumAdimKaydet,
          subtitle: l10n.gardirobumAdimKaydetAlt,
          icon: Icons.save_rounded,
        );
      default:
        return _StepInfo(
          title: l10n.gardirobumYukleniyor,
          subtitle: l10n.gardirobumLutfenBekleyin,
          icon: Icons.auto_awesome_rounded,
        );
    }
  }
}

class _StepInfo {
  final String title;
  final String subtitle;
  final IconData icon;

  const _StepInfo({
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}

class _StepIndicator extends StatelessWidget {
  final String currentStep;
  final Color anaRenk;
  final ColorScheme colors;

  const _StepIndicator({
    required this.currentStep,
    required this.anaRenk,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    final steps = ['bg_removal', 'ai_analysis', 'saving'];
    final currentIndex = steps.indexOf(currentStep).clamp(0, 2);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        final isActive = index <= currentIndex;
        final isCurrent = index == currentIndex;

        return Row(
          children: [
            AnimatedContainer(
              duration: AppMotion.orta,
              curve: AppMotion.giris,
              width: isCurrent ? 28 : 12,
              height: 12,
              decoration: BoxDecoration(
                color: isActive ? anaRenk : colors.outlineVariant.withValues(alpha: 0.4),
                borderRadius: AppRadius.xsRadius,
                boxShadow: isCurrent && isActive
                    ? [
                        BoxShadow(
                          color: anaRenk.withValues(alpha: 0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
            ),
            if (index < 2) const SizedBox(width: 8),
          ],
        );
      }),
    );
  }
}