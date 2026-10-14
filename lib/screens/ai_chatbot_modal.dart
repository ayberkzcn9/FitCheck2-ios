import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../models/kiyafet.dart';
import '../models/chat_mesaj.dart';
import '../services/ai_service.dart';
import '../services/analytics_servisi.dart';
import '../ai/ai_dil.dart';
import '../utils/hava_uygunlugu.dart';
import '../utils/helpers.dart';
import '../l10n/app_localizations.dart';

class AiChatbotPenceresi extends StatefulWidget {
  final List<Kiyafet> gardirobum;
  final String gunlukHava;
  final String? ilkMesaj;

  /// Chat ekranında görünmeyen, yapay zekâya sistem bağlamı olarak iletilen
  /// gizli metin (ör. seçili kombin parçaları). Görsel kirlilik yaratmaz.
  final String? gizliBaglam;
  final Color anaRenk;

  const AiChatbotPenceresi({
    super.key,
    required this.gardirobum,
    required this.gunlukHava,
    this.ilkMesaj,
    this.gizliBaglam,
    required this.anaRenk,
  });

  @override
  State<AiChatbotPenceresi> createState() => _AiChatbotPenceresiState();
}

class _AiChatbotPenceresiState extends State<AiChatbotPenceresi> {
  final List<ChatMesaj> _mesajlar = [];
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();

  final stt.SpeechToText _speechToText = stt.SpeechToText();
  bool _isListening = false;

  Uint8List? _secilenResimBytes;

  bool _aiIslemde = false;
  bool _tekrarDeneHazir = false;
  String? _sonMesaj;
  Uint8List? _sonResim;
  bool _kombinModuBekleniyor = false;
  String _aktifCinsiyet = 'Kadın';
  String _aktifTarz = 'Genel';
  String _aktifRenk = 'Karışık';
  String _aktifTenRengi = 'Buğday';

  @override
  void initState() {
    super.initState();
    _speechInit();
    _kullaniciVerileriniYukleVeBaslat();
  }

  Future<void> _kullaniciVerileriniYukleVeBaslat() async {
    final prefs = await SharedPreferences.getInstance();

    if (mounted) {
      setState(() {
        _aktifCinsiyet = prefs.getString('kullanici_cinsiyet') ?? 'Kadın';
        _aktifTarz = prefs.getString('kullanici_tarzi') ?? 'Genel';
        _aktifRenk = prefs.getString('kullanici_renk_paleti') ?? 'Karışık';
        _aktifTenRengi = prefs.getString('kullanici_ten_rengi') ?? 'Buğday';
      });
    }

    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    final bool havaDurumuVar =
        havaDurumuKullanilabilirMi(widget.gunlukHava, l10n);

    if (mounted) {
      setState(() {
        _mesajlar.add(
          ChatMesaj(
            mesaj: havaDurumuVar
                ? l10n.chatKarsilama(widget.gunlukHava)
                : l10n.chatKarsilamaHavaYok,
            isUser: false,
          ),
        );
      });
    }

    if (widget.ilkMesaj != null && widget.ilkMesaj!.trim().isNotEmpty) {
      if (!widget.ilkMesaj!.startsWith(" [Stil")) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _textController.text = widget.ilkMesaj!;
          _mesajGonder();
        });
      }
    }
  }

  Future<void> _speechInit() async {
    await _speechToText.initialize();
    if (!mounted) return;
  }

  String _speechLocale(String languageCode) {
    return konusmaDiliKodu(languageCode);
  }

  Future<void> _sesliDinlemeTetikle() async {
    if (_aiIslemde) return;
    HapticFeedback.lightImpact();
    if (_isListening) {
      await _speechToText.stop();
      if (!mounted) return;
      setState(() => _isListening = false);
    } else {
      bool available = await _speechToText.initialize();
      if (!mounted) return;
      if (available) {
        setState(() => _isListening = true);
        _speechToText.listen(
          listenOptions: stt.SpeechListenOptions(
            localeId:
                _speechLocale(Localizations.localeOf(context).languageCode),
          ),
          onResult: (result) {
            if (!mounted || _aiIslemde) return;
            setState(() {
              _textController.text = result.recognizedWords;
            });
            if (result.finalResult) {
              if (!mounted) return;
              setState(() => _isListening = false);
              _mesajGonder();
            }
          },
        );
      }
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  Future<void> _fotoSec(ImageSource source) async {
    HapticFeedback.selectionClick();
    try {
      final XFile? file = await _picker.pickImage(
        source: source,
        maxWidth: 300,
        maxHeight: 300,
        imageQuality: 50,
      );
      if (file != null) {
        final bytes = await file.readAsBytes();
        if (!mounted) return;
        setState(() {
          _secilenResimBytes = bytes;
        });
      }
    } catch (e) {
      debugPrint("Görsel hatası: $e");
    }
  }

  /// Kirli sepetteki parçaları yapay zekaya sormadan doğrudan raporlar.
  void _kirliSepetiRaporunuGoster() {
    if (_aiIslemde || !mounted) return;

    final l10n = AppLocalizations.of(context)!;
    final kirliParcalar = widget.gardirobum.where((k) => k.sepetteMi).toList();

    final String rapor;
    if (kirliParcalar.isEmpty) {
      rapor = l10n.chatKirliSepetiBos;
    } else {
      final parcaListesi = kirliParcalar
          .map((k) => "- ${k.gorunenBaslik} (${k.kategori}, ${k.renk})")
          .join("\n");
      rapor = "${l10n.chatKirliSepetiDoluBaslik(kirliParcalar.length)}\n\n"
          "$parcaListesi\n\n${l10n.chatKirliSepetiDoluNot}";
    }

    setState(() {
      _mesajlar.add(ChatMesaj(mesaj: l10n.chatOneriKirliSepeti, isUser: true));
      _mesajlar.add(ChatMesaj(mesaj: rapor, isUser: false));
      _tekrarDeneHazir = false;
    });
    _scrollToBottom();
  }

  Future<void> _mesajGonder({String? mesaj, Uint8List? resimBytes}) async {
    if (_aiIslemde || !mounted) return;
    final text = (mesaj ?? _textController.text).trim();
    final resim = resimBytes ?? _secilenResimBytes;

    if (text.isEmpty && resim == null) return;

    HapticFeedback.mediumImpact();
    final l10n = AppLocalizations.of(context)!;
    _sonMesaj = text;
    _sonResim = resim;

    final String dilKodu = Localizations.localeOf(context).languageCode;
    final String hedefDil = aiHedefDil(dilKodu);

    final String kucukMetin = text.toLowerCase();
    final List<String> kombinAnahtarKelimeleri = kombinIstegiAnahtarKelimeleri;

    bool merkezParcaIsteniyor = text.contains('[ZORUNLU_PARCA:');
    bool kombinIsteniyor = merkezParcaIsteniyor ||
        resim != null ||
        kombinAnahtarKelimeleri.any((kelime) => kucukMetin.contains(kelime));

    String uiMesaji = text;
    String aiMesaji = text;

    if (merkezParcaIsteniyor) {
      final RegExp regExp = RegExp(r'\[ZORUNLU_PARCA:\s*(.*?)\]');
      final match = regExp.firstMatch(text);
      if (match != null && match.group(1) != null) {
        final parcaAdi = match.group(1)!.trim();
        uiMesaji = l10n.chatZorunluParcaMesaji(parcaAdi);
      }
    }

    _textController.clear();
    setState(() {
      _mesajlar.add(ChatMesaj(
        mesaj: uiMesaji.isEmpty ? l10n.chatGorselGonderildi : uiMesaji,
        isUser: true,
        resimBytes: resim,
      ));
      _secilenResimBytes = null;
      _aiIslemde = true;
      _tekrarDeneHazir = false;
      _kombinModuBekleniyor = kombinIsteniyor;
    });
    _scrollToBottom();

    final temizler = widget.gardirobum.where((k) => !k.sepetteMi).toList();
    final bool dolapBos = temizler.isEmpty;

    final kirliParcalar = widget.gardirobum.where((k) => k.sepetteMi).toList();
    final String kirliSepetiDurumu = kirliParcalar.isEmpty
        ? "[LAUNDRY BASKET]: empty, there are no dirty items."
        : "[LAUNDRY BASKET - DIRTY ITEMS]:\n${kirliParcalar.map((k) => "- ${k.baslik} (${k.kategori}, ${k.renk})").join("\n")}";

    final String envanter = dolapBos
        ? "[WARDROBE STATUS: EMPTY]: The user's digital wardrobe is currently EMPTY or all items are in laundry basket."
        : "[USER'S AVAILABLE INVENTORY]:\n${temizler.map((k) => "- ID: ${k.id} | Title: ${k.baslik} | Category: ${k.kategori} | Color: ${k.renk} | Season: ${kiyafetMevsimEtiketi(k)}").join("\n")}";

    final String sohbetGecmisi =
        _mesajlar.take(_mesajlar.length - 1).take(4).map((m) {
      return "${m.isUser ? 'User' : 'Stylist'}: ${m.mesaj}";
    }).join("\n");

    final bool havaDurumuVar =
        havaDurumuKullanilabilirMi(widget.gunlukHava, l10n);
    final String havaDurumuSatiri = havaDurumuVar
        ? widget.gunlukHava
        : 'UNKNOWN (location service off, permission not granted or data still loading) — never mention or guess the weather';

    final String sistemPromptu = """
You are "FitCheck AI", an elite, polite, and highly conversational personal stylist.

[CRITICAL DIRECTIVE - STRICT LANGUAGE ENFORCEMENT]
You MUST write your ENTIRE response in **$hedefDil**!

[CONTEXT & VARIABLES]
- Gender Target: ${aiCinsiyet(_aktifCinsiyet)}
- Style Preference: $_aktifTarz
- Color Palette: $_aktifRenk
- Skin Complexion: $_aktifTenRengi
- Real-Time Weather: $havaDurumuSatiri
- Wardrobe Empty: $dolapBos
- Dirty Items in Laundry Basket: ${kirliParcalar.length}

[COLOR THEORY & SKIN COMPLEXION ADVICE]
- Keep in mind the user's Skin Complexion ($_aktifTenRengi) when evaluating contrast and outfit harmony.
- Fair/Light Skin: Soft contrasts, jewel tones, navy, emerald green, pastel colors, avoid overly washed-out tones.
- Wheat/Medium/Warm Skin: Earthy colors, warm tones, mustard, beige, coral, olive green, warm browns.
- Dark/Tan Skin: High contrast bright colors, white, pastel pinks, vivid yellows, bold primary colors look stunning.

[HOW TO RESPOND - DUAL MODE SYSTEM]

🟢 MODE 1: CASUAL CHAT & GREETING (DEFAULT MODE)
- If the user just says hello, asks how you are, or makes general small talk, ACT HUMAN.
- Greet them warmly, ask how their day is going, or mention the weather gently.
- WAIT for them to explicitly ask for an outfit. 
- NEVER generate an outfit or use the [KOMBIN_HAZIR] tag in this mode. Let them speak first.

🔵 MODE 2: OUTFIT GENERATOR (ONLY if user explicitly asks for an outfit, what to wear, etc.)
- If Wardrobe Empty is TRUE: Politely inform them that their wardrobe is empty or clothes are dirty. DO NOT use tags.
- If Wardrobe Empty is FALSE: Give a brief, stylish recommendation based on the weather, their style ($_aktifTarz), color palette ($_aktifRenk), and skin tone ($_aktifTenRengi).
- [CENTERPIECE RULE]: If the user's message contains the [ZORUNLU_PARCA: Item Name] tag, you MUST build the entire outfit around this specific item. Find the best matching top/bottom/shoes/accessories from the inventory to complete the look. Briefly explain why they match and compliment their skin tone.
- ALWAYS end your response with the [KOMBIN_HAZIR:OCCASION] tag!
- Occasions: Casual, Ofis, Davet, Spor, Gece, Romantik, Hafta Sonu.
- Example: [KOMBIN_HAZIR:Casual]
- [WEATHER MATCH RULE - CRITICAL]: The outfit MUST fit the weather above. NEVER suggest summer pieces (shorts, linen, sleeveless tops, sandals) in cold weather (max 12°C or below) and NEVER winter pieces (wool, cashmere, coat, parka, down, thick knits, boots) in hot weather (max 28°C or above). If the clean inventory has nothing suitable for that weather, say so in one short sentence and offer the closest weather-appropriate alternative or layering idea.

🔴 MODE 3: LAUNDRY BASKET REPORT (if the user asks what is in their laundry basket, which clothes are dirty, or taps the laundry basket button)
- Answer using ONLY the [LAUNDRY BASKET - DIRTY ITEMS] section below. List every dirty item by name with the total count.
- If the section says the basket is empty, say it is empty and that everything is ready to wear.
- NEVER invent or guess items. NEVER use the [KOMBIN_HAZIR] tag in this mode.
- Remind the user that dirty items are not used in outfit suggestions until they are washed, then offer to build a look from the clean inventory.
""";

    try {
      final String gizliBaglamEki =
          (widget.gizliBaglam != null && widget.gizliBaglam!.trim().isNotEmpty)
              ? "\n\n[CURRENT OUTFIT CONTEXT - The user just opened this chat from the outfit below and wants your expert feedback on it. Evaluate color harmony, style, weather suitability and skin tone, then suggest improvements. Do NOT repeat this context block back to the user.]\n${widget.gizliBaglam}"
              : "";
      final cevap = await AiService().hibritAiSorgula(
        sistemPromptu:
            "$sistemPromptu\n\n📜 CHAT HISTORY:\n$sohbetGecmisi\n\n$envanter\n\n$kirliSepetiDurumu$gizliBaglamEki",
        kullaniciMesaji: aiMesaji.isEmpty ? l10n.chatGorselIncele : aiMesaji,
        resimBytes: resim,
      );
      if (!mounted) return;
      final guvenliCevap = metniGuvenliYap(cevap);
      if (guvenliCevap.isEmpty) throw const AiServiceException();
      setState(
          () => _mesajlar.add(ChatMesaj(mesaj: guvenliCevap, isUser: false)));
      await AnalyticsServisi().olay('ai_chat_message', {
        'source': 'main',
        'with_image': resim != null ? 1 : 0,
      });
      HapticFeedback.lightImpact();
      _scrollToBottom();
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _mesajlar.add(ChatMesaj(mesaj: l10n.stilistHata, isUser: false));
        _tekrarDeneHazir = true;
      });
    } finally {
      if (mounted) {
        setState(() => _aiIslemde = false);
        _scrollToBottom();
      }
    }
  }

  Widget _buildTemizMesajKarti(String text) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    bool kombinVar = text.contains('[KOMBIN_HAZIR');

    String hedefOrtam = "Casual";
    if (kombinVar) {
      final regExp = RegExp(r'\[KOMBIN_HAZIR:?(.*?)\]');
      final match = regExp.firstMatch(text);
      if (match != null &&
          match.group(1) != null &&
          match.group(1)!.isNotEmpty) {
        hedefOrtam = match.group(1)!.trim();
      }
    }

    String temizMetin =
        text.replaceAll(RegExp(r'\[KOMBIN_HAZIR:?.*?\]'), '').trim();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        MarkdownBody(
          data: temizMetin,
          selectable: true,
          styleSheet: MarkdownStyleSheet(
            p: TextStyle(
              fontSize: 14.5,
              letterSpacing: -0.1,
              color: Colors.black,
              height: 1.45,
              fontWeight: FontWeight.w400,
            ),
            strong: TextStyle(
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
            em: TextStyle(
              fontStyle: FontStyle.italic,
              color: Colors.black,
            ),
            h1: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
            h2: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
            h3: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
            listBullet: TextStyle(
              fontSize: 14.5,
              color: Colors.black,
            ),
            listIndent: 16.0,
            blockquoteDecoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
              border: Border(
                left: BorderSide(color: widget.anaRenk, width: 3),
              ),
            ),
            blockquotePadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
        if (kombinVar) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.tertiaryContainer.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: colorScheme.tertiary.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.auto_awesome_rounded,
                      color: colorScheme.tertiary,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.chatKombinHazirBaslik(hedefOrtam),
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13.5,
                          color: Colors.black,
                        ),
                        maxLines: 2,
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: colorScheme.surfaceContainerHighest,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                      Navigator.pop(context, hedefOrtam);
                    },
                    child: Text(
                      l10n.chatKombiniGorButon,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]
      ],
    );
  }

  Widget _hizliOneriCipi(String etiket, {bool kirliSepeti = false}) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Semantics(
        button: true,
        label: etiket,
        enabled: !_aiIslemde,
        child: InkWell(
          canRequestFocus: !_aiIslemde,
          excludeFromSemantics: true,
          onTap: () {
            if (_aiIslemde) return;
            HapticFeedback.selectionClick();
            if (kirliSepeti) {
              _kirliSepetiRaporunuGoster();
              return;
            }
            _textController.text = etiket;
            _mesajGonder();
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: colorScheme.outlineVariant.withValues(alpha: 0.5),
              ),
            ),
            child: Text(
              etiket,
              style: TextStyle(
                fontSize: 12.5,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _speechToText.stop();
    _speechToText.cancel();
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return DraggableScrollableSheet(
      initialChildSize: 0.88,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerLow,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          clipBehavior: Clip.hardEdge,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: true,
            body: Column(
              children: [
                // ÜST BAR (APPBAR)
                Container(
                  padding: const EdgeInsets.only(
                      top: 10, bottom: 12, left: 16, right: 12),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainer,
                    border: Border(
                      bottom: BorderSide(
                        color:
                            colorScheme.outlineVariant.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                  child: Column(
                    children: [
                      Center(
                        child: Container(
                          width: 36,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: colorScheme.outline.withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.auto_awesome_rounded,
                            color: Color(0xFFA78BFA),
                            size: 22,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.chatAsistanSohbeti,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 15.5,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  l10n.chatModHavaDuyarli,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: Colors.black,
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          IconButton.filledTonal(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            style: IconButton.styleFrom(
                              backgroundColor:
                                  colorScheme.surfaceContainerHighest,
                              foregroundColor: colorScheme.onSurfaceVariant,
                            ),
                            icon: const Icon(
                              Icons.close_rounded,
                              size: 20,
                            ),
                            onPressed: () {
                              HapticFeedback.lightImpact();
                              Navigator.pop(context);
                            },
                          )
                        ],
                      ),
                    ],
                  ),
                ),

                // MESAJLAR BÖLÜMÜ
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    itemCount: _mesajlar.length,
                    itemBuilder: (context, index) {
                      final m = _mesajlar[index];

                      return Align(
                        alignment: m.isUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.85),
                          decoration: BoxDecoration(
                            color: m.isUser
                                ? colorScheme.surfaceContainerHighest
                                : colorScheme.surfaceContainerHigh,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(18),
                              topRight: const Radius.circular(18),
                              bottomLeft: Radius.circular(m.isUser ? 18 : 4),
                              bottomRight: Radius.circular(m.isUser ? 4 : 18),
                            ),
                            border: m.isUser
                                ? null
                                : Border.all(
                                    color: colorScheme.outlineVariant
                                        .withValues(alpha: 0.4),
                                  ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (m.resimBytes != null) ...[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.memory(
                                    m.resimBytes!,
                                    height: 160,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            SizedBox(
                                      height: 160,
                                      width: double.infinity,
                                      child: Center(
                                        child: Icon(
                                          Icons.broken_image_outlined,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                              ],
                              m.isUser
                                  ? Text(
                                      m.mesaj,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14.5,
                                        fontWeight: FontWeight.w500,
                                        height: 1.4,
                                      ),
                                    )
                                  : _buildTemizMesajKarti(m.mesaj),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // AI İŞLEMDE GÖSTERGESİ
                if (_aiIslemde)
                  Padding(
                    padding: const EdgeInsets.only(left: 20, bottom: 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: widget.anaRenk,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            _kombinModuBekleniyor
                                ? l10n.chatStilistKombinTasarlayor
                                : l10n.chatStilistYaziyor,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                if (_tekrarDeneHazir && !_aiIslemde)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16, bottom: 6),
                      child: TextButton.icon(
                        onPressed: () => _mesajGonder(
                          mesaj: _sonMesaj,
                          resimBytes: _sonResim,
                        ),
                        icon: const Icon(Icons.refresh_rounded,
                            color: Colors.black),
                        label: Text(
                          l10n.chatTekrarDene,
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ),

                // RESİM ÖNİZLEME
                if (_secilenResimBytes != null)
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color:
                            colorScheme.outlineVariant.withValues(alpha: 0.5),
                      ),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.memory(
                            _secilenResimBytes!,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                SizedBox(
                              width: 40,
                              height: 40,
                              child: Center(
                                child: Icon(
                                  Icons.broken_image_outlined,
                                  size: 18,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            l10n.chatGorselEklendi,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Tooltip(
                          message: l10n.chatGorselEklendi,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: Icon(
                              Icons.close_rounded,
                              color: Colors.black,
                              size: 18,
                            ),
                            onPressed: () {
                              HapticFeedback.selectionClick();
                              setState(() => _secilenResimBytes = null);
                            },
                          ),
                        )
                      ],
                    ),
                  ),

                // HIZLI ÖNERİ ÇİPLERİ
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(left: 16, right: 8, bottom: 8),
                  child: Row(
                    children: [
                      _hizliOneriCipi(l10n.chatOneriYagmur),
                      _hizliOneriCipi(l10n.chatOneriOfis),
                      _hizliOneriCipi(l10n.chatOneriHaftaSonu),
                      _hizliOneriCipi(l10n.chatOneriKirliSepeti, kirliSepeti: true),
                    ],
                  ),
                ),

                // MESAJ YAZMA ALANI
                SafeArea(
                  top: false,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainer,
                      border: Border(
                        top: BorderSide(
                          color:
                              colorScheme.outlineVariant.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Tooltip(
                          message: l10n.chatKamera,
                          child: IconButton(
                            padding: const EdgeInsets.all(6),
                            constraints: const BoxConstraints(),
                            icon: Icon(
                              Icons.camera_alt_rounded,
                              color: widget.anaRenk,
                              size: 21,
                            ),
                            onPressed: _aiIslemde
                                ? null
                                : () => _fotoSec(ImageSource.camera),
                          ),
                        ),
                        Tooltip(
                          message: l10n.chatGaleri,
                          child: IconButton(
                            padding: const EdgeInsets.all(6),
                            constraints: const BoxConstraints(),
                            icon: Icon(
                              Icons.photo_library_rounded,
                              color: widget.anaRenk,
                              size: 21,
                            ),
                            onPressed: _aiIslemde
                                ? null
                                : () => _fotoSec(ImageSource.gallery),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _textController,
                                    enabled: !_aiIslemde,
                                    onSubmitted: (_) => _mesajGonder(),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: _isListening
                                          ? l10n.chatDinleniyor
                                          : l10n.chatBirSeylerYazin,
                                      hintStyle: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                      ),
                                      border: InputBorder.none,
                                      isDense: true,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 10),
                                    ),
                                  ),
                                ),
                                Tooltip(
                                  message: _isListening
                                      ? l10n.chatDinleniyor
                                      : l10n.chatMikrofon,
                                  child: IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    icon: Icon(
                                      _isListening
                                          ? Icons.mic_rounded
                                          : Icons.mic_none_rounded,
                                      color: _isListening
                                          ? colorScheme.error
                                          : widget.anaRenk,
                                      size: 20,
                                    ),
                                    onPressed: _aiIslemde
                                        ? null
                                        : _sesliDinlemeTetikle,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Semantics(
                          button: true,
                          label: l10n.chatGonder,
                          enabled: !_aiIslemde,
                          child: InkWell(
                            onTap: _aiIslemde ? null : _mesajGonder,
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.all(9),
                              decoration: BoxDecoration(
                                color: _aiIslemde
                                    ? colorScheme.outline
                                    : widget.anaRenk,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.send_rounded,
                                color: Colors.white,
                                size: 17,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
