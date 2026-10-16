import 'dart:async';
import 'dart:io';
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
import '../services/background_removal_service.dart';
import '../services/background_remover_service.dart';
import '../services/reklam_servisi.dart';
import '../services/satin_alma_servisi.dart';
import '../utils/ana_ekran_dialoglar.dart';
import '../utils/hava_uygunlugu.dart';
import '../utils/helpers.dart';
import '../ai/ai_dil.dart';
import '../widgets/stroked_text.dart';
import '../../theme/design_tokens.dart';

import 'reklamsiz_premium_ekrani.dart';

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
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
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

  void _kombinHakkiBittiDiyaloguGoster() {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      builder: (ctx) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
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
                padding: const EdgeInsets.all(8),
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
                    fontSize: 18,
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
                  fontSize: 14,
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
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: AppAccents.successDark,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
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
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: colors.onSurfaceVariant),
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(color: colors.onSurfaceVariant),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
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
                                  borderRadius: BorderRadius.circular(16)),
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
                style: TextStyle(color: colors.onSurfaceVariant, fontSize: 14, fontWeight: FontWeight.bold),
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
                                            fontSize: 20,
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
                                            fontSize: 14,
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
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      "${currentIndex + 1} / ${liste.length}",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
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
                                        padding: const EdgeInsets.symmetric(vertical: 14),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(16),
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
                                        padding: const EdgeInsets.all(16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(16),
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
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
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
              fontSize: 18,
              letterSpacing: -0.5,
              color: colors.onSurface,
            ),
          ),
          content: Text(
            aciklama,
            style: TextStyle(
              fontSize: 14,
              color: colors.onSurfaceVariant,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                HapticFeedback.selectionClick();
                Navigator.pop(context);
              },
              child: Text(l10n.iptal, style: TextStyle(color: colors.onSurfaceVariant, fontSize: 14, fontWeight: FontWeight.bold)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: colors.onPrimary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              onPressed: () {
                HapticFeedback.selectionClick();
                Navigator.pop(context);
                openAppSettings();
              },
              child: Text(l10n.ayarlariAc, style: TextStyle(color: colors.onPrimary, fontSize: 14, fontWeight: FontWeight.bold)),
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
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            padding: const EdgeInsets.only(top: 16, bottom: 24),
            decoration: BoxDecoration(
              color: colors.surfaceContainerHigh,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              border: Border.all(color: colors.outlineVariant.withValues(alpha: 0.4)),
            ),
            child: SafeArea(
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
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    child: Text(
                      l10n.kiyafetEkle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                        color: colors.onSurface,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                    leading: Container(
                      padding: const EdgeInsets.all(12),
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
                        fontSize: 16,
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
                    contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                    leading: Container(
                      padding: const EdgeInsets.all(12),
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
                        fontSize: 16,
                        color: colors.onSurface,
                      ),
                    ),
                    onTap: () {
                      HapticFeedback.selectionClick();
                      Navigator.pop(bottomContext);
                      _kiyafetEkleIslemi(ImageSource.gallery);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
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
          cameraStatus = await Permission.camera.request();
        }

        if (cameraStatus.isPermanentlyDenied) {
          if (!mounted) return;
          _izinUyarisiGoster(l10n.kameraIzniGerekliBaslik, l10n.kameraIzniGerekliAciklama);
          return;
        }

        if (!cameraStatus.isGranted) return;

        final XFile? singleFile = await _picker.pickImage(
          source: ImageSource.camera,
          maxWidth: 800,
          maxHeight: 800,
          imageQuality: 75,
        );
        if (singleFile != null) files.add(singleFile);
      } else {
        files = await _picker.pickMultiImage(
          maxWidth: 800,
          maxHeight: 800,
          imageQuality: 75,
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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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

          // 🎯 Arkaplanı sil — önce YEREL sunucu (rembg), olmazsa bulut (remove.bg)
          Uint8List kaydedilecekBytes = orijinalBytes;
          if (!mounted) return;
          setState(() {
            _currentStep = 'bg_removal';
            _currentPhotoIndex = i + 1;
          });

          Uint8List? bgRemoved;
          try {
            bgRemoved = await BackgroundRemoverService.removeBackground(
              File(currentFile.path),
            );
          } catch (e) {
            debugPrint('Yerel arka plan silme hatası: $e');
          }

          // Yerel sunucu sonuç vermezse bulut API'ye (remove.bg) düş
          if (bgRemoved == null || bgRemoved.length <= 100) {
            bgRemoved = await BackgroundRemovalService().removeBackground(
              imageBytes: orijinalBytes,
              size: 'auto',
              format: 'png',
            );
          }

          if (bgRemoved != null && bgRemoved.length > 100) {
            // Çok küçük dosya gelirse (hata durumu) orijinali kullan
            kaydedilecekBytes = bgRemoved;
          }

          // 🤖 AI Analiz
          if (!mounted) return;
          setState(() {
            _currentStep = 'ai_analysis';
          });

          final analiz = await _gorselAnaliziniTekrarDene(
            sistemPromptu: "Sen uzman bir moda analiz sistemisin. Görseli KUMAŞ KESİMİ, SİLÜETİ VE TÜRÜNE göre incele.\n"
                "ETEK vs PANTOLON: Bacak arası ağ dikişi VARSA 'alt' (pantolon/şort). Bacak ayrımı YOKSA ve tek parça aşağı iniyorsa ETEKtir ('alt').\n\n"
                "ÜRÜN İSİMLENDİRME KURALI (ÇOK ÖNEMLİ):\n"
                "Ürün adını ('baslik') KESİNLİKLE VE SADECE 3 KELİME olarak yaz. Ne eksik, ne fazla.\n"
                "Format: [Renk] [Desen veya Kumaş] [Tür].\n"
                "Doğru Örnekler: 'Mavi Kot Pantolon', 'Siyah Deri Ceket', 'Beyaz Spor Ayakkabı'.\n"
                "Yanlış Örnekler: 'Çok Şık Siyah Elbise' (4 kelime - YASAK), 'Kırmızı Tişört' (2 kelime - YASAK).\n"
                "ASLA 'Şık', 'Güzel', 'Modern' gibi sıfatlar kullanma!\n\n"
                "MEVSİM KURALI: Kıyafetin kalınlığına ve kumaşına göre 'mevsim' alanına SADECE şu üç değerden birini yaz: 'kislik' (mont, kaban, yün, kalın triko, bot gibi soğuk hava parçaları), 'yazlik' (şort, keten, askılı, sandalet gibi ince yaz parçaları), 'dort_mevsim' (tişört, kot, spor ayakkabı gibi her mevsim giyilebilen parçalar). Bu değerleri ÇEVİRME, aynen yaz.\n\n"
                "SADECE şu JSON formatında ver ($aiDili dilinde):\n"
                "{\n  \"baslik\": \"3 Kelimelik Ürün Adı\",\n  \"kategori\": \"ust veya alt veya ayakkabi veya aksesuar\",\n  \"renk\": \"Renk\",\n  \"stil\": \"Tarz\",\n  \"mevsim\": \"kislik veya yazlik veya dort_mevsim\"\n}",
            kullaniciMesaji: "Bu kıyafeti detaylı analiz et ve JSON ver.",
            resimBytes: kaydedilecekBytes,
          );

          String clean = analiz.replaceAll(RegExp(r'```json\s*|```\s*'), '').trim();
          final int firstBrace = clean.indexOf('{');
          final int lastBrace = clean.lastIndexOf('}');
          if (firstBrace != -1 && lastBrace != -1) {
            clean = clean.substring(firstBrace, lastBrace + 1);
          }

          final Map<String, dynamic> parsed = safeJsonDecodeMap(clean, tag: 'ai_analiz');

          String aiBaslik = metniGuvenliYap(parsed['baslik'] ?? 'Yeni Giyim Parçası');
          List<String> kelimeler = aiBaslik.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();

          if (kelimeler.length > 3) {
            aiBaslik = kelimeler.take(3).join(" ");
          }

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
              baslik: aiBaslik,
              kategori: (parsed['kategori'] ?? 'ust').toString().toLowerCase(),
              resimBytes: kaydedilecekBytes,
              renk: metniGuvenliYap(parsed['renk'] ?? 'Bilinmiyor'),
              stil: metniGuvenliYap(parsed['stil'] ?? 'Casual'),
              mevsim: mevsimEtiketiniNormallestir(parsed['mevsim']),
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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
          resimBytes: resimBytes,
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

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
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
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  // Title
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
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
                              fontSize: 18,
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
                  // Content
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: controller,
                          autofocus: true,
                          style: TextStyle(color: colors.onSurface, fontSize: 14),
                          decoration: InputDecoration(
                            labelText: l10n.kiyafetAdiEtiketi,
                            labelStyle: TextStyle(color: colors.onSurfaceVariant),
                            filled: true,
                            fillColor: colors.surfaceContainerHighest,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: colors.onSurface, width: 2)),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.kategori,
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: colors.onSurfaceVariant),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            color: colors.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: ['ust', 'alt', 'ayakkabi', 'aksesuar'].contains(secilenKategori) ? secilenKategori : 'ust',
                              isExpanded: true,
                              dropdownColor: colors.surfaceContainerHigh,
                              style: TextStyle(color: colors.onSurface, fontSize: 14, fontWeight: FontWeight.w600),
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
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              HapticFeedback.selectionClick();
                              Navigator.pop(sheetContext);
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                            child: Text(l10n.iptal, style: TextStyle(color: colors.onSurfaceVariant, fontSize: 14, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colors.primary,
                              foregroundColor: colors.onPrimary,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: () {
                              HapticFeedback.selectionClick();
                              final yeniIsim = controller.text.trim();
                              setState(() {
                                if (yeniIsim.isNotEmpty) {
                                  item.kullaniciBasligi = yeniIsim;
                                }
                                item.kategori = secilenKategori;
                              });
                              widget.onKiyafetEkle(item);
                              Navigator.pop(sheetContext);
                            },
                            child: Text(l10n.kaydet, style: TextStyle(color: colors.onPrimary, fontWeight: FontWeight.bold, fontSize: 14)),
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
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
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
              fontSize: 18,
              letterSpacing: -0.5,
              color: colors.onSurface,
            ),
          ),
          content: Text(
            l10n.gardirobumTemizleOnay,
            style: TextStyle(
              fontSize: 14,
              color: colors.onSurfaceVariant,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                HapticFeedback.selectionClick();
                Navigator.pop(context);
              },
              child: Text(l10n.iptal, style: TextStyle(color: colors.onSurfaceVariant, fontSize: 14, fontWeight: FontWeight.bold)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.error,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              onPressed: () {
                HapticFeedback.selectionClick();
                Navigator.pop(context);
                widget.onGardirobuTemizle();
              },
              child: Text(l10n.evetSil, style: TextStyle(color: colors.onError, fontWeight: FontWeight.bold, fontSize: 14)),
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
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn,
        key: ValueKey(item.id),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: AppRadius.xxlRadius,
          border: Border.all(
            color: Colors.transparent,
            width: 0,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(23),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0, end: item.sepetteMi ? 1 : 0),
                      duration: const Duration(milliseconds: 400),
                      builder: (context, value, child) {
                        return ColorFiltered(
                          colorFilter: ColorFilter.matrix(<double>[
                            0.2126 + 0.7874 * (1 - value), 0.7152 - 0.7152 * (1 - value), 0.0722 - 0.0722 * (1 - value), 0, 0,
                            0.2126 - 0.2126 * (1 - value), 0.7152 + 0.2848 * (1 - value), 0.0722 - 0.0722 * (1 - value), 0, 0,
                            0.2126 - 0.2126 * (1 - value), 0.7152 - 0.7152 * (1 - value), 0.0722 + 0.9278 * (1 - value), 0, 0,
                            0, 0, 0, 1, 0,
                          ]),
                          child: Image.memory(
                            item.resimBytes,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Center(
                              child: Icon(Icons.broken_image_outlined, color: colors.onSurfaceVariant),
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
                                padding: const EdgeInsets.all(8),
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
                                padding: const EdgeInsets.all(8),
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
                                padding: const EdgeInsets.all(8),
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
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.elasticOut,
                      top: item.sepetteMi ? 8 : -30,
                      left: 8,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 200),
                        opacity: item.sepetteMi ? 1.0 : 0.0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: colors.error,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.local_laundry_service_rounded, color: Colors.white, size: 14),
                        ),
                      ),
                    ),

                    // Kapalı Durumda Fotoğraf Üzerindeki İpuç/Başlık Yazısı
                    if (!acik)
                      Positioned(
                        bottom: 10,
                        left: 10,
                        right: 10,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: StrokedText(
                                item.gorunenBaslik,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                                strokeColor: Colors.black,
                                strokeBlur: 2.5,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                // Açık renkli fotoğraflarda beyaz ok kaybolmasın
                                // diye koyu yarı saydam zemin kullanılır.
                                color: Colors.black.withValues(alpha: 0.45),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.5),
                                ),
                              ),
                              child: const Icon(Icons.keyboard_arrow_up_rounded, color: Colors.white, size: 14),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),

              // Açık Durumdaki Alt Detay Paneli
              AnimatedCrossFade(
                firstChild: const SizedBox(width: double.infinity, height: 0),
                secondChild: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
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
                          fontSize: 14,
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
                          fontSize: 12,
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
                                      : colors.onSurface,
                                  foregroundColor: item.sepetteMi
                                      ? colors.onErrorContainer
                                      : colors.surface,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: item.sepetteMi
                                        ? BorderSide(color: colors.error.withValues(alpha: 0.4), width: 1.2)
                                        : BorderSide.none,
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 4),
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
                                          : colors.surface,
                                    ),
                                    const SizedBox(width: 4),
                                    Flexible(
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          item.sepetteMi ? l10n.gardirobumDolabaAl : l10n.gardirobumSepeteAt,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: 0.1,
                                            color: item.sepetteMi
                                                ? colors.onErrorContainer
                                                : colors.surface,
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
                                  backgroundColor: const Color(0xFFE9D5FF),
                                  foregroundColor: AppAccents.styleist,
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
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
                duration: const Duration(milliseconds: 250),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _yatayKategoriRafi(String kategoriAnahtari, String kategoriBasligi, AppLocalizations l10n) {
    final colors = Theme.of(context).colorScheme;
    final kategoriListesi = widget.gardirobum.where((k) => k.kategori.toLowerCase() == kategoriAnahtari).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    kategoriBasligi,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                      color: colors.onSurface,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                l10n.gardirobumUrunSayisi(kategoriListesi.length),
                style: TextStyle(
                  fontSize: 12,
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
                  padding: const EdgeInsets.symmetric(horizontal: 16),
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
                              padding: const EdgeInsets.symmetric(horizontal: 8),
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
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: kategoriListesi.length,
                  itemBuilder: (context, index) {
                    final item = kategoriListesi[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 16),
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
                title: Text(
                  l10n.gardirobumTitle,
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                    fontSize: 18,
                    color: colors.onSurface,
                  ),
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
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.gardirobumGizlendiAciklama,
                          style: TextStyle(
                            fontSize: 14,
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
                        margin: const EdgeInsets.all(32),
                        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
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
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(color: colors.surfaceContainerHighest, shape: BoxShape.circle),
                              child: Icon(Icons.add_a_photo_outlined, size: 48, color: colors.onSurface),
                            ),
                            const SizedBox(height: 16),
                            Text(l10n.gardirobumBosBaslik, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: colors.onSurface)),
                            const SizedBox(height: 8),
                            Text(l10n.gardirobumBosAciklama, textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: colors.onSurfaceVariant, height: 1.4)),
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
                      children: [
                        _yatayKategoriRafi('ust', l10n.gardirobumKategoriUst, l10n),
                        _yatayKategoriRafi('alt', l10n.gardirobumKategoriAlt, l10n),
                        _yatayKategoriRafi('ayakkabi', l10n.gardirobumKategoriAyakkabi, l10n),
                        _yatayKategoriRafi('aksesuar', l10n.gardirobumKategoriAksesuar, l10n),
                      ],
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
      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
      child: Container(
        color: Colors.black.withValues(alpha: 0.4),
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
            margin: const EdgeInsets.symmetric(horizontal: 24),
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
                    padding: const EdgeInsets.all(20),
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
                    fontSize: 20,
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
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: anaRenk.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: anaRenk.withValues(alpha: 0.3)),
                            ),
                            child: Text(
                              '$currentPhotoIndex / $totalPhotos',
                              style: TextStyle(
                                fontSize: 14,
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
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 600),
                              curve: Curves.easeOutCubic,
                              width: (currentPhotoIndex / totalPhotos.clamp(1, 999)) * 200,
                              height: 6,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [anaRenk, anaRenk.withValues(alpha: 0.7)],
                                ),
                                borderRadius: BorderRadius.circular(3),
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
                  duration: const Duration(milliseconds: 400),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  child: aiMessages.isNotEmpty
                      ? Text(
                          aiMessages[aiMessageIndex % aiMessages.length],
                          key: ValueKey<int>(aiMessageIndex),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
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
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOutCubic,
              width: isCurrent ? 28 : 12,
              height: 12,
              decoration: BoxDecoration(
                color: isActive ? anaRenk : colors.outlineVariant.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(6),
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