import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import 'package:shared_preferences/shared_preferences.dart';
import '../models/kiyafet.dart';
import '../models/favori_kombin.dart';
import '../l10n/app_localizations.dart';
import '../services/ai_service.dart';
import '../services/analytics_servisi.dart';
import '../services/reklam_servisi.dart';
import '../ai/ai_dil.dart';
import '../utils/helpers.dart';
import '../../theme/design_tokens.dart';

class KendiKombinimEkrani extends StatefulWidget {
  final List<Kiyafet> gardirobum;
  final Color anaRenk;
  final Function(FavoriKombin) onFavoriEkle;
  final Function(String) onFavoriCikar;
  final bool Function(List<String>)? isFavoriKontrol;
  final Function(String, String) onGecmiseEkle;

  const KendiKombinimEkrani({
    super.key,
    required this.gardirobum,
    required this.anaRenk,
    required this.onFavoriEkle,
    required this.onFavoriCikar,
    this.isFavoriKontrol,
    required this.onGecmiseEkle,
  });

  @override
  State<KendiKombinimEkrani> createState() => _KendiKombinimEkraniState();
}

class _KendiKombinimEkraniState extends State<KendiKombinimEkrani> {
  Kiyafet? _secilenUst;
  Kiyafet? _secilenAlt;
  Kiyafet? _secilenAyakkabi;
  Kiyafet? _secilenAksesuar;
  
  bool _tekParcaMi = false; 
  String _cinsiyet = 'Kadın';
  String _tenRengi = 'Buğday';
  String _tarz = 'Genel';

  bool _aiIslemde = false;
  int? _sonRenkPuani;
  String? _sonTuyo;

  bool _isLocalFavori = false;
  String? _sonFavoriKombinBasligi;

  @override
  void initState() {
    super.initState();
    _kullaniciVerileriniYukle();
  }

  Future<void> _kullaniciVerileriniYukle() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _cinsiyet = prefs.getString('kullanici_cinsiyet') ?? 'Kadın';
      _tenRengi = prefs.getString('kullanici_ten_rengi') ?? 'Buğday';
      _tarz = prefs.getString('kullanici_tarzi') ?? 'Genel';
    });
  }

  void _kombiniTemizle() {
    HapticFeedback.mediumImpact();
    setState(() {
      _secilenUst = null;
      _secilenAlt = null;
      _secilenAyakkabi = null;
      _secilenAksesuar = null;
      _sonRenkPuani = null;
      _sonTuyo = null;
      _isLocalFavori = false;
      _sonFavoriKombinBasligi = null;
    });
  }

  String _kategoriyiModeldenCikar(String dbKategori) {
    final s = dbKategori.toLowerCase().trim();
    if (s == 'ust' || s == 'üst' || s == 'üst giyim' || s == 'elbise') return 'ust';
    if (s == 'alt' || s == 'alt giyim') return 'alt';
    if (s == 'ayakkabi' || s == 'ayakkabı') return 'ayakkabi';
    if (s == 'dis' || s == 'dış' || s == 'dış giyim' || s == 'aksesuar') return 'aksesuar';
    return '';
  }

  List<String> _mevcutParcaBasliklariniGetir() {
    List<String> parcalar = [];
    if (_secilenUst != null) parcalar.add(_secilenUst!.gorunenBaslik);
    if (!_tekParcaMi && _secilenAlt != null) parcalar.add(_secilenAlt!.gorunenBaslik);
    if (_secilenAyakkabi != null) parcalar.add(_secilenAyakkabi!.gorunenBaslik);
    if (_secilenAksesuar != null) parcalar.add(_secilenAksesuar!.gorunenBaslik);
    return parcalar;
  }

  void _favoriToggle() {
    HapticFeedback.selectionClick();
    final parcaBasliklari = _mevcutParcaBasliklariniGetir();
    if (parcaBasliklari.isEmpty || !mounted) return;

    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final String kombinBasligi = _sonFavoriKombinBasligi ?? l10n.kendiTasarimimBaslik;

    if (_isLocalFavori) {
      widget.onFavoriCikar(kombinBasligi);
      setState(() {
        _isLocalFavori = false;
      });
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.favorilerdenCikarildi,
            style: TextStyle(color: colors.onSurface, fontWeight: FontWeight.w600),
          ),
          backgroundColor: colors.surfaceContainerHigh,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          duration: const Duration(seconds: 2),
        ),
      );
    } else {
      final favori = FavoriKombin(
        baslik: kombinBasligi,
        parcalar: parcaBasliklari,
        renkUyumuPuani: _sonRenkPuani ?? 85,
        tuyo: _sonTuyo ?? '',
      );
      
      widget.onFavoriEkle(favori);
      setState(() {
        _isLocalFavori = true;
        _sonFavoriKombinBasligi = kombinBasligi;
      });

      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.anaFavoriEklendi,
            style: TextStyle(color: colors.onPrimaryContainer, fontWeight: FontWeight.w600),
          ),
          backgroundColor: colors.primaryContainer,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  /// "AI ile Analiz Et" butonu: geçiş reklamı gösterildikten sonra AI analizi
  /// başlar. Premium kullanıcıda ve sıklık sınırında reklam atlanır, akış
  /// beklemeden devam eder.
  Future<void> _kombiniAiIleAnalizEtVeKaydet() async {
    ReklamServisi().gecisReklamiGoster(
      onAdClosed: () {
        if (!mounted) return;
        _kombiniAiIleAnalizEtVeKaydetGercek();
      },
    );
  }

  Future<void> _kombiniAiIleAnalizEtVeKaydetGercek() async {
    HapticFeedback.heavyImpact();
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;

    setState(() {
      _aiIslemde = true;
      _sonRenkPuani = null;
      _sonTuyo = null;
      _isLocalFavori = false;
      _sonFavoriKombinBasligi = null;
    });

    List<String> parcaDetaylari = [];
    if (_secilenUst != null) parcaDetaylari.add("${l10n.ustGiyim}: ${_secilenUst!.baslik} (Renk: ${_secilenUst!.renk}, Stil: ${_secilenUst!.stil})");
    if (!_tekParcaMi && _secilenAlt != null) parcaDetaylari.add("${l10n.altGiyim}: ${_secilenAlt!.baslik} (Renk: ${_secilenAlt!.renk}, Stil: ${_secilenAlt!.stil})");
    if (_secilenAyakkabi != null) parcaDetaylari.add("${l10n.ayakkabi}: ${_secilenAyakkabi!.baslik} (Renk: ${_secilenAyakkabi!.renk}, Stil: ${_secilenAyakkabi!.stil})");
    if (_secilenAksesuar != null) parcaDetaylari.add("${l10n.disGiyim}: ${_secilenAksesuar!.baslik} (Renk: ${_secilenAksesuar!.renk}, Stil: ${_secilenAksesuar!.stil})");

    try {
      final aiDili = aiHedefDil(Localizations.localeOf(context).languageCode);

      final rawRes = await AiService().hibritAiSorgula(
        sistemPromptu: "Sadece geçerli bir JSON yanıt ver. You MUST answer in $aiDili language.",
        kullaniciMesaji: """
Sen profesyonel bir stil danışmanısın. Kullanıcı kendi kombinini oluşturdu. Parçaların birbiriyle renk/stil uyumunu ve kullanıcının TEN RENGİNE (${aiTenRengi(_tenRengi)}) uyumunu değerlendir.

Kullanıcı Profili:
- Cinsiyet: ${aiCinsiyet(_cinsiyet)}
- Tarz: ${aiTarz(_tarz)}
- Ten Rengi: ${aiTenRengi(_tenRengi)}

Kombin Parçaları:
${parcaDetaylari.join("\n")}

TALİMATLAR:
1. UYUM VE TEN RENGİ KONTRASTI: Parçaların uyumunu ve renklerin ${aiTenRengi(_tenRengi)} ten rengiyle oluşturduğu kontrastı incele.
2. PUANLAMA: 100 üzerinden dürüst bir renk & stil uyum puanı hesapla (60-98 arası).
3. TÜYO: 2 cümlelik samimi stil önerisi ver (Ten rengine olan uyumuna da değin).

SADECE bu JSON formatında dön:
{
  "renk_uyumu_puani": 88,
  "tuyo": "Stil tüyosu..."
}
""",
      );

      String clean = rawRes.replaceAll(RegExp(r'```json\s*|```\s*'), '').trim();
      final int firstBrace = clean.indexOf('{');
      final int lastBrace = clean.lastIndexOf('}');
      if (firstBrace != -1 && lastBrace != -1) {
        clean = clean.substring(firstBrace, lastBrace + 1);
      }

      final Map<String, dynamic> parsed = safeJsonDecodeMap(clean, tag: 'kendi_kombin_ai');
      final int puan = parsed['renk_uyumu_puani'] ?? 85;
      final String tuyo = parsed['tuyo'] ?? l10n.varsayilanKendiAnalizYorumu;

      if (mounted) {
        setState(() {
          _sonRenkPuani = puan;
          _sonTuyo = tuyo;
          _aiIslemde = false;
        });

        List<String> kayitParcalari = [];
        if (_secilenUst != null) kayitParcalari.add(_secilenUst!.baslik);
        if (!_tekParcaMi && _secilenAlt != null) kayitParcalari.add(_secilenAlt!.baslik);
        if (_secilenAyakkabi != null) kayitParcalari.add(_secilenAyakkabi!.baslik);
        if (_secilenAksesuar != null) kayitParcalari.add(_secilenAksesuar!.baslik);

        widget.onGecmiseEkle(l10n.kendiTasarimimBaslik, kayitParcalari.join(", "));
        await AnalyticsServisi().olay('outfit_generated', {'source': 'custom_design'});
      }
    } catch (e) {
      debugPrint("Kendi Kombinim AI Analiz Hatası: $e");
      if (mounted) {
        setState(() {
          _aiIslemde = false;
          _sonRenkPuani = null;
          _sonTuyo = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              l10n.gardirobumHataMesaji,
              style: TextStyle(color: colors.onError, fontWeight: FontWeight.w600),
            ),
            backgroundColor: colors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        );
      }
    }
  }

  void _parcaSecimEkraniAc(String kategoriKodu, String baslik) {
    HapticFeedback.lightImpact(); 
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    
    final secenekler = widget.gardirobum.where((k) {
      return !k.sepetteMi && _kategoriyiModeldenCikar(k.kategori) == kategoriKodu;
    }).toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, 
      backgroundColor: Colors.transparent, 
      barrierColor: Colors.black.withValues(alpha: 0.6),
      builder: (bottomContext) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.75,
            decoration: BoxDecoration(
              color: colors.surfaceContainerHigh,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(28)), 
            ),
            child: SafeArea(
              top: false,
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Container(
                    width: 48, 
                    height: 5, 
                    decoration: BoxDecoration(
                      color: colors.onSurfaceVariant.withValues(alpha: 0.4), 
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            l10n.parcaSecModalBaslik(baslik), 
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 18, 
                              fontWeight: FontWeight.w900, 
                              color: colors.onSurface, 
                              letterSpacing: -0.4,
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: colors.surfaceContainerHighest,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.close_rounded, 
                              size: 20, 
                              color: colors.onSurfaceVariant,
                            ),
                            onPressed: () {
                              HapticFeedback.selectionClick();
                              Navigator.pop(bottomContext);
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  Expanded(
                    child: secenekler.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    color: colors.primaryContainer, 
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.local_laundry_service_rounded, 
                                    size: 48, 
                                    color: colors.onPrimaryContainer,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  l10n.baskaTemizKiyafetYok, 
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: colors.onSurfaceVariant, 
                                    fontSize: 14, 
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : GridView.builder(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 40),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 0.8, 
                            ),
                            itemCount: secenekler.length,
                            itemBuilder: (context, index) {
                              final item = secenekler[index];
                              return GestureDetector(
                                onTap: () {
                                  HapticFeedback.mediumImpact(); 
                                  setState(() {
                                    if (kategoriKodu == 'ust') _secilenUst = item;
                                    if (kategoriKodu == 'alt') _secilenAlt = item;
                                    if (kategoriKodu == 'ayakkabi') _secilenAyakkabi = item;
                                    if (kategoriKodu == 'aksesuar') _secilenAksesuar = item;
                                    _sonRenkPuani = null;
                                    _sonTuyo = null;
                                    _isLocalFavori = false;
                                    _sonFavoriKombinBasligi = null;
                                  });
                                  Navigator.pop(bottomContext);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: AppRadius.xlRadius,
                                    border: Border.all(
                                      color: colors.outlineVariant.withValues(alpha: 0.4), 
                                      width: 1.5,
                                    ),
                                    color: colors.surfaceContainerLow,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(18.5),
                                    child: Image.memory(
                                      item.resimBytes,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Center(
                                        child: Icon(Icons.broken_image_outlined, color: colors.onSurfaceVariant),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _secimYuvasi(String baslik, String kategoriKodu, Kiyafet? secilenKiyafet, String bosEmoji) {
    final bool doluMu = secilenKiyafet != null;
    final colors = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: () => _parcaSecimEkraniAc(kategoriKodu, baslik),
      child: AnimatedContainer( 
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        height: 110,
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: colors.surfaceContainerLow,
          borderRadius: AppRadius.xxlRadius,
          border: Border.all(
            color: colors.outlineVariant.withValues(alpha: 0.5),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 100,
              height: 110,
              decoration: BoxDecoration(
                color: colors.surfaceContainerHighest,
                borderRadius: const BorderRadius.horizontal(left: Radius.circular(22.5)),
              ),
              child: doluMu
                  ? ClipRRect(
                      borderRadius: const BorderRadius.horizontal(left: Radius.circular(22.5)),
                      child: Image.memory(
                        secilenKiyafet.resimBytes,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Center(
                          child: Icon(Icons.broken_image_outlined, color: colors.onSurfaceVariant),
                        ),
                      ),
                    )
                  : Center(
                      child: Text(
                        bosEmoji,
                        style: const TextStyle(fontSize: 42),
                      ),
                    ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      baslik.toUpperCase(), 
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        color: colors.onSurface, 
                        fontWeight: FontWeight.w900, 
                        fontSize: 12, 
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      doluMu ? secilenKiyafet.gorunenBaslik : l10n.parcaSecModalBaslik(baslik),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: doluMu ? FontWeight.w800 : FontWeight.w600,
                        color: doluMu ? colors.onSurface : colors.onSurfaceVariant,
                        letterSpacing: -0.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            if (doluMu)
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: IconButton(
                  icon: const Icon(
                    Icons.close_rounded, 
                    size: 18,
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: colors.errorContainer,
                    foregroundColor: colors.onErrorContainer,
                    padding: const EdgeInsets.all(8),
                    minimumSize: const Size(32, 32),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () {
                    HapticFeedback.lightImpact(); 
                    setState(() {
                      if (kategoriKodu == 'ust') _secilenUst = null;
                      if (kategoriKodu == 'alt') _secilenAlt = null;
                      if (kategoriKodu == 'ayakkabi') _secilenAyakkabi = null;
                      if (kategoriKodu == 'aksesuar') _secilenAksesuar = null;
                      _sonRenkPuani = null;
                      _sonTuyo = null;
                      _isLocalFavori = false;
                      _sonFavoriKombinBasligi = null;
                    });
                  },
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Icon(
                  Icons.add_circle_rounded, 
                  // Koyu modda görünür kalsın diye temaya duyarlı renk.
                  color: colors.onSurfaceVariant.withValues(alpha: 0.55), 
                  size: 30,
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    final bool enAzBirParcaSecili = _secilenUst != null || _secilenAlt != null || _secilenAyakkabi != null || _secilenAksesuar != null;

    final bool kombinHazirMi = _tekParcaMi 
        ? (_secilenUst != null && _secilenAyakkabi != null)
        : (_secilenUst != null && _secilenAlt != null && _secilenAyakkabi != null);

    final String ustEmoji = _tekParcaMi 
        ? "👗" 
        : (_cinsiyet.trim() == 'Erkek' ? "👕" : "👚");

    const String altEmoji = "👖"; 
    const String ayakkabiEmoji = "👟";
    const String aksesuarEmoji = "⌚";

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          l10n.kendiKombininiTasarlaTitle, 
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: FontWeight.w900, 
            fontSize: 18, 
            letterSpacing: -0.4,
            color: colors.onSurface,
          ),
        ),
        centerTitle: true,
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        actions: [
          if (enAzBirParcaSecili)
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: IconButton(
                tooltip: l10n.secimleriSifirla,
                icon: const Icon(
                  Icons.delete_sweep_rounded,
                  size: 20,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: colors.errorContainer,
                  foregroundColor: colors.onErrorContainer,
                ),
                onPressed: _kombiniTemizle,
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 140), 
        child: Column(
          children: [
            // İpucu Bilgilendirme Kartı (Yumuşak Pastel Lavanta Tonları)
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTints.styleistBgDinamik(context),
                borderRadius: AppRadius.xlRadius,
                border: Border.all(
                  color: AppTints.styleistBorderDinamik(context),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.auto_awesome_rounded, 
                    color: AppAccents.styleist, 
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      kombinHazirMi ? l10n.kombinHazirAiTavsiyesi : l10n.kombinBaslaIpucu,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppMiscColors.styleistTextDinamik(context),
                        height: 1.45,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Üst-Alt / Tek Parça Mod Switcher
            Container(
              margin: const EdgeInsets.only(bottom: 24),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colors.surfaceContainerHighest,
                borderRadius: AppRadius.xlRadius,
                border: Border.all(color: colors.outlineVariant.withValues(alpha: 0.4)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if (_tekParcaMi) HapticFeedback.selectionClick();
                        setState(() {
                          _tekParcaMi = false;
                          _sonRenkPuani = null;
                          _sonTuyo = null;
                          _isLocalFavori = false;
                          _sonFavoriKombinBasligi = null;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: !_tekParcaMi ? Colors.green : Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "${_cinsiyet.trim() == 'Erkek' ? '👕' : '👚'} ${l10n.ustAltModu}",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: !_tekParcaMi ? FontWeight.w800 : FontWeight.w600,
                            color: !_tekParcaMi ? Colors.white : colors.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if (!_tekParcaMi) HapticFeedback.selectionClick();
                        setState(() {
                          _tekParcaMi = true;
                          _secilenAlt = null;
                          _sonRenkPuani = null;
                          _sonTuyo = null;
                          _isLocalFavori = false;
                          _sonFavoriKombinBasligi = null;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _tekParcaMi ? Colors.green : Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "👗 ${l10n.tekParcaElbiseModu}",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: _tekParcaMi ? FontWeight.w800 : FontWeight.w600,
                            color: _tekParcaMi ? Colors.white : colors.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            _secimYuvasi(_tekParcaMi ? l10n.tekParcaElbise : l10n.ustGiyim, "ust", _secilenUst, ustEmoji), 
            
            if (!_tekParcaMi)
              _secimYuvasi(l10n.altGiyim, "alt", _secilenAlt, altEmoji), 
              
            _secimYuvasi(l10n.ayakkabi, "ayakkabi", _secilenAyakkabi, ayakkabiEmoji),
            _secimYuvasi(l10n.aksesuarOpsiyonel, "aksesuar", _secilenAksesuar, aksesuarEmoji),
            
            // Stilist AI Analiz Sonuç Kartı
            if (_sonRenkPuani != null && _sonTuyo != null) ...[
              const SizedBox(height: 8),
              AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutBack,
                padding: const EdgeInsets.all(24),
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: colors.surfaceContainerLow,
                  borderRadius: AppRadius.dialogRadius,
                  border: Border.all(color: colors.outlineVariant.withValues(alpha: 0.5), width: 1.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            l10n.stilistAnaliziBaslik,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.w900, 
                              fontSize: 16, 
                              letterSpacing: -0.5,
                              color: colors.onSurface,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Uyum rozeti — Haftalık Planlayıcı ve Günlük Kombin
                        // ekranlarıyla birebir aynı görünüm (tasarım devamlılığı).
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: colors.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.analytics_rounded,
                                size: 16,
                                color: colors.onSurface,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                l10n.kombinUyumYuzdesi(_sonRenkPuani.toString()),
                                style: theme.textTheme.labelMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colors.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // STİLİST İPUCU KUTUSU
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTints.styleistBgDinamik(context),
                        borderRadius: AppRadius.xlRadius,
                        border: Border.all(
                          color: AppTints.styleistBorderDinamik(context),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.auto_awesome_rounded,
                            size: 18,
                            color: AppAccents.styleist,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              metniGuvenliYap(_sonTuyo!),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppMiscColors.styleistTextDinamik(context),
                                height: 1.45,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
            
            const SizedBox(height: 12),

            // Aksiyon Butonları (AI Analiz & Favori)
            Row(
              children: [
                Expanded(
                  child: AnimatedOpacity( 
                    duration: const Duration(milliseconds: 300),
                    opacity: kombinHazirMi ? 1.0 : 0.5,
                    child: SizedBox(
                      height: 52, 
                      child: FilledButton.icon(
                        onPressed: kombinHazirMi && !_aiIslemde
                            ? _kombiniAiIleAnalizEtVeKaydet
                            : null,
                        icon: _aiIslemde 
                            ? const SizedBox(
                                width: 20, 
                                height: 20, 
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5, 
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.bolt_rounded, size: 22),
                        label: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            _aiIslemde ? l10n.stilistDegerlendiriyor : l10n.aiIleAnalizEtKaydet, 
                            style: const TextStyle(
                              fontSize: 14, 
                              fontWeight: FontWeight.bold, 
                              letterSpacing: -0.2,
                            ),
                          ),
                        ),
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: colors.surfaceContainerHighest,
                          disabledForegroundColor: colors.onSurfaceVariant.withValues(alpha: 0.38),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ),
                ),
                
                if (kombinHazirMi) ...[
                  const SizedBox(width: 12),
                  SizedBox(
                    height: 52,
                    width: 52,
                    child: IconButton.filledTonal(
                      onPressed: _favoriToggle,
                      icon: Icon(
                        _isLocalFavori ? Icons.star_rounded : Icons.star_outline_rounded,
                        size: 22,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: _isLocalFavori
                            ? AppStatusColors.favoriteBgDinamik(context)
                            : colors.surfaceContainerHighest,
                        foregroundColor: _isLocalFavori
                            ? AppStatusColors.favoriteFgDinamik(context)
                            : colors.onSurfaceVariant,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}