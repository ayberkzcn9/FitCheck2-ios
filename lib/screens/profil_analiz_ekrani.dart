import 'profil_bilesenleri/profil_modals.dart';
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/kiyafet.dart';
import '../models/favori_kombin.dart';
import '../l10n/app_localizations.dart';

import 'profil_bilesenleri/profil_widgets.dart';
import '../../theme/design_tokens.dart';

class ProfilVeAnalizEkrani extends StatefulWidget {
  final List<Kiyafet> gardirobum;
  final List<FavoriKombin> favoriKombinler;
  final List<Map<String, String>> gecmisKombinler;
  final String gunlukHava;
  final Color anaRenk;

  final FutureOr<void> Function(int)? onFavoriSil;
  final FutureOr<void> Function()? onSepetiTemizle;
  final FutureOr<void> Function(String)? onTekliSepettenCikar;
  final FutureOr<void> Function()? onGecmisiTemizle;
  final FutureOr<void> Function(int)? onTekliGecmisSil;

  const ProfilVeAnalizEkrani({
    super.key,
    required this.gardirobum,
    required this.favoriKombinler,
    required this.gecmisKombinler,
    required this.gunlukHava,
    required this.anaRenk,
    this.onFavoriSil,
    this.onSepetiTemizle,
    this.onTekliSepettenCikar,
    this.onGecmisiTemizle,
    this.onTekliGecmisSil,
  });

  @override
  State<ProfilVeAnalizEkrani> createState() => _ProfilVeAnalizEkraniState();
}

class _ProfilVeAnalizEkraniState extends State<ProfilVeAnalizEkrani> {
  late List<Map<String, String>> _gecmis;
  late List<Map<String, String>> _sonGelenGecmis;
  List<Map<String, String>>? _beklenenGecmis;

  bool _gecmisIslemiSuruyor = false;

  @override
  void initState() {
    super.initState();
    _gecmisiUstWidgettanAl();
  }

  @override
  void didUpdateWidget(covariant ProfilVeAnalizEkrani oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (_beklenenGecmis != null) {
      if (_gecmislerEsit(widget.gecmisKombinler, _beklenenGecmis!)) {
        _beklenenGecmis = null;
        _gecmisiUstWidgettanAl();
      } else if (_gecmislerEsit(widget.gecmisKombinler, _sonGelenGecmis)) {
        return;
      } else {
        _beklenenGecmis = null;
        _gecmisiUstWidgettanAl();
      }
      return;
    }

    if (!_gecmislerEsit(widget.gecmisKombinler, _sonGelenGecmis)) {
      _gecmisiUstWidgettanAl();
    }
  }

  List<Map<String, String>> _gecmisKopyasi(
    List<Map<String, String>> kaynak,
  ) {
    return kaynak.map((item) => Map<String, String>.from(item)).toList();
  }

  bool _kayitlarEsit(
    Map<String, String> a,
    Map<String, String> b,
  ) {
    if (a.length != b.length) return false;

    for (final entry in a.entries) {
      if (!b.containsKey(entry.key) || b[entry.key] != entry.value) {
        return false;
      }
    }

    return true;
  }

  bool _gecmislerEsit(
    List<Map<String, String>> a,
    List<Map<String, String>> b,
  ) {
    if (a.length != b.length) return false;

    for (var i = 0; i < a.length; i++) {
      if (!_kayitlarEsit(a[i], b[i])) return false;
    }

    return true;
  }

  void _gecmisiUstWidgettanAl() {
    _gecmis = _gecmisKopyasi(widget.gecmisKombinler);
    _sonGelenGecmis = _gecmisKopyasi(widget.gecmisKombinler);
  }

  String _normalize(String value) {
    return value
        .trim()
        .replaceAll('İ', 'i')
        .replaceAll('I', 'ı')
        .toLowerCase()
        .replaceAll('ı', 'i')
        .replaceAll('ş', 's')
        .replaceAll('ğ', 'g')
        .replaceAll('ü', 'u')
        .replaceAll('ö', 'o')
        .replaceAll('ç', 'c');
  }

  bool _bilinmeyenDeger(String value) {
    final normalized = _normalize(value);

    return normalized.isEmpty ||
        normalized == 'bilinmiyor' ||
        normalized == 'unknown';
  }

  String _kategoriyiModeldenCikar(String kategori) {
    final s = _normalize(kategori);

    bool iceriyor(List<String> kelimeler) {
      return kelimeler.any(s.contains);
    }

    if (iceriyor([
          'ayakkab',
          'sneaker',
          'cizme',
          'shoe',
          'boot',
        ]) ||
        s == 'bot') {
      return 'ayakkabi';
    }

    if (iceriyor([
      'aksesuar',
      'accessor',
      'kemer',
      'belt',
      'canta',
      'bag',
      'sapka',
      'hat',
      'takı',
      'taki',
      'jewelry',
      'jewellery',
    ])) {
      return 'aksesuar';
    }

    if (iceriyor([
          'pantolon',
          'sort',
          'short',
          'etek',
          'skirt',
          'jean',
          'trouser',
          'pants',
          'bottom',
          'alt giyim',
        ]) ||
        s == 'alt') {
      return 'alt';
    }

    if (iceriyor([
          'ust',
          't-shirt',
          'tshirt',
          'shirt',
          'gomlek',
          'kazak',
          'sweat',
          'swat',
          'hoodie',
          'sweater',
          'bluz',
          'blouse',
          'ceket',
          'jacket',
          'mont',
          'coat',
          'dis giyim',
          'outerwear',
        ]) ||
        s == 'dis' ||
        s == 'top') {
      return 'ust';
    }

    return '';
  }

  _ProfilAnalizi _analiziHesapla() {
    var ust = 0;
    var alt = 0;
    var ayakkabi = 0;
    var aksesuar = 0;
    var sepette = 0;
    var giyilen = 0;

    final stilSayilari = <String, int>{};
    final stilEtiketleri = <String, String>{};
    final renkSayilari = <String, int>{};
    final renkEtiketleri = <String, String>{};

    for (final k in widget.gardirobum) {
      switch (_kategoriyiModeldenCikar(k.kategori)) {
        case 'ust':
          ust++;
          break;
        case 'alt':
          alt++;
          break;
        case 'ayakkabi':
          ayakkabi++;
          break;
        case 'aksesuar':
          aksesuar++;
          break;
      }

      if (k.sepetteMi) sepette++;
      if (k.giyilmeSayisi > 0) giyilen++;

      if (!_bilinmeyenDeger(k.stil)) {
        final key = _normalize(k.stil);
        stilSayilari[key] = (stilSayilari[key] ?? 0) + 1;
        stilEtiketleri.putIfAbsent(key, () => k.stil.trim());
      }

      if (!_bilinmeyenDeger(k.renk)) {
        final key = _normalize(k.renk);
        renkSayilari[key] = (renkSayilari[key] ?? 0) + 1;
        renkEtiketleri.putIfAbsent(key, () => k.renk.trim());
      }
    }

    final siraliStiller = stilSayilari.entries.toList()
      ..sort((a, b) {
        final sayiSirasi = b.value.compareTo(a.value);
        return sayiSirasi != 0 ? sayiSirasi : a.key.compareTo(b.key);
      });

    final siraliRenkler = renkSayilari.entries.toList()
      ..sort((a, b) {
        final sayiSirasi = b.value.compareTo(a.value);
        return sayiSirasi != 0 ? sayiSirasi : a.key.compareTo(b.key);
      });

    final siraliKiyafetler = List<Kiyafet>.from(widget.gardirobum)
      ..sort((a, b) {
        final sayiSirasi = b.giyilmeSayisi.compareTo(a.giyilmeSayisi);

        return sayiSirasi != 0
            ? sayiSirasi
            : a.gorunenBaslik.compareTo(b.gorunenBaslik);
      });

    final String stil;
    if (widget.gardirobum.isEmpty) {
      stil = 'BILINMIYOR';
    } else if (siraliStiller.isEmpty) {
      stil = 'KARMASIK';
    } else {
      stil = stilEtiketleri[siraliStiller.first.key]!;
    }

    return _ProfilAnalizi(
      ust: ust,
      alt: alt,
      ayakkabi: ayakkabi,
      aksesuar: aksesuar,
      sepette: sepette,
      stil: stil,
      verimlilik:
          widget.gardirobum.isEmpty ? 0 : giyilen / widget.gardirobum.length,
      seri: _kombinSerisiHesapla(),
      renkler: siraliRenkler
          .take(4)
          .map(
            (entry) => MapEntry(
              renkEtiketleri[entry.key]!,
              entry.value,
            ),
          )
          .toList(),
      kahramanlar:
          siraliKiyafetler.where((k) => k.giyilmeSayisi > 0).take(5).toList(),
      unutulanlar:
          siraliKiyafetler.where((k) => k.giyilmeSayisi == 0).take(5).toList(),
    );
  }

  DateTime? _takvimGununuCikar(String raw) {
    final value = raw.trim();
    if (value.isEmpty) return null;

    final iso = DateTime.tryParse(value);
    if (iso != null) {
      final local = iso.toLocal();
      return DateTime.utc(local.year, local.month, local.day);
    }

    final match = RegExp(
      r'^(\d{1,2})[./](\d{1,2})[./](\d{4})$',
    ).firstMatch(value);

    if (match == null) return null;

    final day = int.parse(match.group(1)!);
    final month = int.parse(match.group(2)!);
    final year = int.parse(match.group(3)!);
    final date = DateTime.utc(year, month, day);

    if (date.year != year || date.month != month || date.day != day) {
      return null;
    }

    return date;
  }

  int _kombinSerisiHesapla() {
    final gunler = <DateTime>{};

    for (final item in _gecmis) {
      final gun = _takvimGununuCikar(item['tarih'] ?? '');
      if (gun != null) gunler.add(gun);
    }

    final simdi = DateTime.now();
    var kontrolGunu = DateTime.utc(simdi.year, simdi.month, simdi.day);

    if (!gunler.contains(kontrolGunu)) {
      kontrolGunu = kontrolGunu.subtract(const Duration(days: 1));
    }

    var seri = 0;

    while (gunler.contains(kontrolGunu)) {
      seri++;
      kontrolGunu = kontrolGunu.subtract(const Duration(days: 1));
    }

    return seri;
  }

  Color _metindenRenkAyarla(String renkAdi) {
    final r = _normalize(renkAdi);

    if (r.contains('siyah') || r.contains('black')) {
      return Colors.black;
    }
    if (r.contains('beyaz') || r.contains('white')) {
      return Colors.white;
    }
    if (r.contains('lacivert') || r.contains('navy')) {
      return const Color(0xFF1E3A8A);
    }
    if (r.contains('mavi') || r.contains('blue')) {
      return const Color(0xFF3B82F6);
    }
    if (r.contains('kirmizi') || r.contains('red')) {
      return const Color(0xFFEF4444);
    }
    if (r.contains('yesil') || r.contains('green')) {
      return AppMiscColors.greenLight;
    }
    if (r.contains('sari') || r.contains('yellow')) {
      return AppAccents.warning;
    }
    if (r.contains('gri') || r.contains('grey') || r.contains('gray')) {
      return const Color(0xFF6B7280);
    }
    if (r.contains('kahve') || r.contains('taba') || r.contains('brown')) {
      return const Color(0xFF92400E);
    }
    if (r.contains('pembe') || r.contains('pink')) {
      return const Color(0xFFEC4899);
    }
    if (r.contains('mor') || r.contains('purple')) {
      return AppAccents.styleist;
    }
    if (r.contains('turuncu') || r.contains('orange')) {
      return AppMiscColors.orangeLight;
    }
    if (r.contains('bej') ||
        r.contains('krem') ||
        r.contains('beige') ||
        r.contains('cream')) {
      return const Color(0xFFE5D5C5);
    }

    return widget.anaRenk;
  }

  String _havayiFormatla(AppLocalizations l10n) {
    final raw = widget.gunlukHava.trim();
    final normalized = _normalize(raw);

    if (raw.isEmpty ||
        [
          'reddedildi',
          'kapali',
          'alinamadi',
          'denied',
          'unavailable',
          'disabled',
        ].any(normalized.contains)) {
      return l10n.gunlukHavaMevcutDegil;
    }

    final formatted = raw
        .replaceAll(
          RegExp(
            r'Konum Bugün:|Location Today:|Bugün:|Today:|Konum|Location',
            caseSensitive: false,
          ),
          '',
        )
        .replaceFirst(RegExp(r'^[\s•:]+'), '')
        .trim();

    return formatted.isEmpty ? l10n.gunlukHavaMevcutDegil : formatted;
  }

  void _mesajGoster(String message) {
    if (!mounted) return;
    final colors = Theme.of(context).colorScheme;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style:
              TextStyle(fontWeight: FontWeight.w700, color: colors.onSurface),
        ),
        backgroundColor: colors.surfaceContainerHigh,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  void _hataGoster() {
    if (!mounted) return;

    _mesajGoster(AppLocalizations.of(context)!.islemTamamlanamadi);
  }

  Future<void> _ustWidgetGuncellemesiniBekle() async {
    await WidgetsBinding.instance.endOfFrame;

    if (!mounted) return;
    setState(() {});
  }

  Future<void> _gecmisiDiskeKaydet(
    List<Map<String, String>> veri,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    final bool basarili;
    if (veri.isEmpty) {
      basarili = await prefs.remove('gecmis_data');
    } else {
      basarili = await prefs.setString(
        'gecmis_data',
        jsonEncode(veri),
      );
    }

    if (!basarili) {
      throw StateError('History could not be persisted.');
    }
  }

  Future<void> _tekliGecmisSil(
    Map<String, String> item,
  ) async {
    if (_gecmisIslemiSuruyor) {
      throw StateError('Another history operation is in progress.');
    }

    final index = _gecmis.indexWhere(
      (entry) => identical(entry, item),
    );

    if (index == -1) {
      throw StateError('The history entry is no longer available.');
    }

    final l10n = AppLocalizations.of(context)!;

    setState(() => _gecmisIslemiSuruyor = true);

    try {
      final callback = widget.onTekliGecmisSil;

      if (callback != null) {
        await Future<void>.sync(() => callback(index));
        await WidgetsBinding.instance.endOfFrame;

        if (!mounted) return;
        final yeniGecmis = List<Map<String, String>>.from(_gecmis)
          ..removeAt(index);

        _beklenenGecmis = yeniGecmis;
        setState(() => _gecmis = yeniGecmis);
      } else {
        final yeniGecmis = List<Map<String, String>>.from(_gecmis)
          ..removeAt(index);

        await _gecmisiDiskeKaydet(yeniGecmis);

        if (!mounted) return;
        setState(() => _gecmis = yeniGecmis);
      }

      _mesajGoster(l10n.kayitGecmistenSilindi);
    } finally {
      if (mounted) {
        setState(() => _gecmisIslemiSuruyor = false);
      }
    }
  }

  Future<void> _gecmisiTemizleOnayi() async {
    if (_gecmisIslemiSuruyor || _gecmis.isEmpty) return;

    HapticFeedback.mediumImpact();
    final l10n = AppLocalizations.of(context)!;

    final onay = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        final colors = Theme.of(dialogContext).colorScheme;
        return AlertDialog(
          backgroundColor: colors.surfaceContainerHigh,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.dialogRadius,
          ),
          title: Text(
            l10n.gecmisiTemizleTitle,
            style:
                TextStyle(color: colors.onSurface, fontWeight: FontWeight.bold),
          ),
          content: Text(
            l10n.gecmisiTemizleOnayIcerik,
            style: TextStyle(color: colors.onSurfaceVariant),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(
                l10n.iptal,
                style: TextStyle(color: colors.onSurface),
              ),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: colors.error,
                foregroundColor: colors.onError,
              ),
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text(l10n.temizle),
            ),
          ],
        );
      },
    );

    if (!mounted || onay != true || _gecmisIslemiSuruyor) return;

    HapticFeedback.heavyImpact();
    setState(() => _gecmisIslemiSuruyor = true);

    try {
      final callback = widget.onGecmisiTemizle;

      if (callback != null) {
        await Future<void>.sync(callback);
        await WidgetsBinding.instance.endOfFrame;

        if (!mounted) return;
        setState(_gecmisiUstWidgettanAl);
      } else {
        await _gecmisiDiskeKaydet(
          <Map<String, String>>[],
        );

        if (!mounted) return;
        setState(() => _gecmis = []);
      }

      _mesajGoster(l10n.gecmisBasariylaTemizlendi);
    } catch (error, stackTrace) {
      debugPrint('Geçmiş temizleme hatası: $error\n$stackTrace');
      _hataGoster();
    } finally {
      if (mounted) {
        setState(() => _gecmisIslemiSuruyor = false);
      }
    }
  }

  Future<void> _favorileriAc() async {
    await ProfilModals.favorileriGoster(
      context: context,
      favoriKombinler: widget.favoriKombinler,
      gardirobum: widget.gardirobum,
      favorileriGetir: () => widget.favoriKombinler,
      gardirobuGetir: () => widget.gardirobum,
      onFavoriSil: widget.onFavoriSil == null
          ? null
          : (index) async {
              final callback = widget.onFavoriSil;
              if (callback == null) {
                throw StateError('Favorite deletion is unavailable.');
              }

              await Future<void>.sync(() => callback(index));
              await _ustWidgetGuncellemesiniBekle();
            },
    );

    if (mounted) setState(() {});
  }

  Future<void> _sepetiAc() async {
    final l10n = AppLocalizations.of(context)!;

    await ProfilModals.sepetiGoster(
      context: context,
      gardirobum: widget.gardirobum,
      gardirobuGetir: () => widget.gardirobum,
      anaRenk: widget.anaRenk,
      onSepetiTemizle: widget.onSepetiTemizle == null
          ? null
          : () async {
              final callback = widget.onSepetiTemizle;
              if (callback == null) {
                throw StateError('Basket cleaning is unavailable.');
              }

              await Future<void>.sync(callback);
              await _ustWidgetGuncellemesiniBekle();

              _mesajGoster(l10n.tumKiyafetlerTemizlendi);
            },
      onTekliSepettenCikar: widget.onTekliSepettenCikar == null
          ? null
          : (id) async {
              final callback = widget.onTekliSepettenCikar;
              if (callback == null) {
                throw StateError('Basket update is unavailable.');
              }

              await Future<void>.sync(() => callback(id));
              await _ustWidgetGuncellemesiniBekle();
            },
    );

    if (mounted) setState(() {});
  }

  Widget _bolumBasligi(String text, {String? emoji}) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 14),
      child: Row(
        children: [
          if (emoji != null) ...[
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Text(
              text,
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
    );
  }

  Widget _kiyafetSeridi(
    List<Kiyafet> kiyafetler, {
    required bool soluk,
  }) {
    return SizedBox(
      height: 160,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: kiyafetler.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) => KiyafetKartcigi(
          kiyafet: kiyafetler[index],
          isSoluk: soluk,
        ),
      ),
    );
  }

  Widget _gecmisKarti(Map<String, String> item) {
    final colors = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final baslik = item['baslik'] ?? l10n.kombin;
    final detay = item['detay'] ?? '';
    final tarih = item['tarih'] ?? '';

    final parcalar = detay
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: _ProfilKart(
        onTap: _gecmisIslemiSuruyor
            ? null
            : () {
                ProfilModals.gecmisDetayGoster(
                  context: context,
                  item: item,
                  gardirobum: widget.gardirobum,
                  onSil: () => _tekliGecmisSil(item),
                );
              },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _ProfilIkon(
                  icon: Icons.check_circle_rounded,
                  bgRenk: AppMiscColors.greenPale,
                  ikonRenk: AppMiscColors.greenDark,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        baslik,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                          color: colors.onSurface,
                        ),
                      ),
                      if (tarih.isNotEmpty) ...[
                        const SizedBox(height: 5),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: colors.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            tarih,
                            style: TextStyle(
                              color: colors.onSurfaceVariant,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: colors.onSurfaceVariant,
                ),
              ],
            ),
            if (detay.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                detay,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: colors.onSurfaceVariant,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ],
            if (parcalar.isNotEmpty) ...[
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (final parca in parcalar)
                      if (ProfilModals.kiyafetiBul(
                        widget.gardirobum,
                        parca,
                      )
                          case final Kiyafet k)
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: ProfilKiyafetGorseli(
                            kiyafet: k,
                            boyut: 44,
                            radius: 12,
                          ),
                        ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final analiz = _analiziHesapla();
    final toplam = widget.gardirobum.length;

    final stil = switch (analiz.stil) {
      'BILINMIYOR' => l10n.bilinmiyor,
      'KARMASIK' => l10n.karmasikSiklik,
      _ => analiz.stil,
    };

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                l10n.profilVeAnalizTitle,
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
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // STREAK SERI KARTI (Alev Turuncusu Vurgulu)
                  if (analiz.seri > 0) ...[
                    _ProfilBilgiKarti(
                      icon: Icons.local_fire_department_rounded,
                      bgRenk: const Color(0xFFFFEDD5),
                      ikonRenk: const Color(0xFFEA580C),
                      baslik: l10n.harikaGidiyorsun,
                      deger: l10n.gundurSeridesin(analiz.seri),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // ANLIK HAVA DURUMU KARTI (Gökyüzü Mavisi Vurgulu)
                  _ProfilBilgiKarti(
                    icon: Icons.wb_sunny_rounded,
                    bgRenk: const Color(0xFFE0F2FE),
                    ikonRenk: const Color(0xFF0284C7),
                    baslik: l10n.anlikDurum,
                    deger: _havayiFormatla(l10n),
                  ),
                  const SizedBox(height: 16),

                  // CAMASIR SEPETI KARTI (Dinamik Gül Kırmızı / Nane Yeşili)
                  _ProfilKart(
                    onTap: () => _sepetiAc(),
                    child: Row(
                      children: [
                        _ProfilIkon(
                          icon: Icons.local_laundry_service_rounded,
                          bgRenk: analiz.sepette == 0
                              ? AppMiscColors.greenPale
                              : AppMiscColors.roseBg,
                          ikonRenk: analiz.sepette == 0
                              ? AppAccents.success
                              : AppMiscColors.rose,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.camasirSepetiTitle,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  color: colors.onSurface,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                analiz.sepette == 0
                                    ? l10n.tumuTemiz
                                    : l10n.kirliParcaSayisi(
                                        analiz.sepette,
                                      ),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: analiz.sepette == 0
                                      ? AppAccents.success
                                      : AppMiscColors.rose,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (analiz.sepette > 0)
                          Chip(
                            label: Text('${analiz.sepette}'),
                            visualDensity: VisualDensity.compact,
                            backgroundColor: AppMiscColors.roseBg,
                            labelStyle: const TextStyle(
                              color: AppMiscColors.rose,
                              fontWeight: FontWeight.bold,
                            ),
                            side: BorderSide.none,
                          ),
                        Icon(
                          Icons.chevron_right_rounded,
                          color: colors.onSurfaceVariant,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // IKILI OZET KARTLAR (Mor & Zümrüt Yeşili)
                  _ProfilIkili(
                    sol: _ProfilOzetKarti(
                      icon: Icons.psychology_rounded,
                      bgRenk: AppMiscColors.lightPurpleBg,
                      ikonRenk: const Color(0xFF7C3AED),
                      deger: stil,
                      baslik: l10n.stilKimligin,
                    ),
                    sag: _ProfilOzetKarti(
                      icon: Icons.eco_rounded,
                      bgRenk: const Color(0xFFD1FAE5),
                      ikonRenk: AppAccents.success,
                      deger: '%${(analiz.verimlilik * 100).toStringAsFixed(0)}',
                      baslik: l10n.dolapVerimliligi,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // IKILI ISTATISTIK KUTULARI (Kraliyet Mavisi & Altın Sarısı)
                  _ProfilIkili(
                    sol: IstatistikKutusu(
                      baslik: l10n.toplamParca,
                      deger: '$toplam',
                      icon: Icons.checkroom_rounded,
                      iconColor: AppAccents.info,
                    ),
                    sag: IstatistikKutusu(
                      baslik: l10n.favoriKombin,
                      deger: '${widget.favoriKombinler.length}',
                      icon: Icons.star_rounded,
                      iconColor: AppAccents.warning,
                      onTap: () => _favorileriAc(),
                    ),
                  ),

                  // RENK PALETI BOLUMU
                  if (analiz.renkler.isNotEmpty) ...[
                    _bolumBasligi(l10n.renkPaletin, emoji: '🎨'),
                    _ProfilKart(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final sutun = constraints.maxWidth < 260
                              ? (analiz.renkler.length == 1 ? 1 : 2)
                              : analiz.renkler.length;

                          final genislik =
                              (constraints.maxWidth - (sutun - 1) * 12) / sutun;

                          return Wrap(
                            spacing: 12,
                            runSpacing: 20,
                            children: analiz.renkler.map((renk) {
                              final oran =
                                  toplam == 0 ? 0 : renk.value / toplam * 100;
                              final renkObj = _metindenRenkAyarla(renk.key);
                              final isBeyaz = renkObj == Colors.white;

                              return SizedBox(
                                width: genislik,
                                child: Column(
                                  children: [
                                    Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: renkObj,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: isBeyaz
                                              ? Colors.black.withValues(alpha: 0.25)
                                              : Colors.white,
                                          width: isBeyaz ? 2 : 3,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: isBeyaz
                                                ? Colors.black.withValues(alpha: 0.08)
                                                : renkObj.withValues(alpha: 0.35),
                                            blurRadius: 8,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      renk.key,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 12,
                                        color: colors.onSurface,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: colors.surfaceContainerHighest,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        '%${oran.toStringAsFixed(0)}',
                                        style: TextStyle(
                                          color: colors.onSurfaceVariant,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ),
                  ],

                  // DOLABIN KAHRAMANLARI
                  if (analiz.kahramanlar.isNotEmpty) ...[
                    _bolumBasligi(
                      l10n.dolabinKahramanlari,
                      emoji: '🦸‍♂️',
                    ),
                    _kiyafetSeridi(
                      analiz.kahramanlar,
                      soluk: false,
                    ),
                  ],

                  // DERINLERDE UNUTULANLAR
                  if (analiz.unutulanlar.isNotEmpty) ...[
                    _bolumBasligi(
                      l10n.derinlerdeUnutulanlar,
                      emoji: '👻',
                    ),
                    _kiyafetSeridi(
                      analiz.unutulanlar,
                      soluk: true,
                    ),
                  ],

                  // KATEGORI DAGILIMI
                  _bolumBasligi(l10n.kategoriDagilimi, emoji: '📊'),
                  _ProfilKart(
                    child: Column(
                      children: [
                        KategoriSatiri(
                          etiket: l10n.ustGiyim,
                          adet: analiz.ust,
                          toplam: toplam == 0 ? 1 : toplam,
                        ),
                        const SizedBox(height: 20),
                        KategoriSatiri(
                          etiket: l10n.altGiyim,
                          adet: analiz.alt,
                          toplam: toplam == 0 ? 1 : toplam,
                        ),
                        const SizedBox(height: 20),
                        KategoriSatiri(
                          etiket: l10n.ayakkabi,
                          adet: analiz.ayakkabi,
                          toplam: toplam == 0 ? 1 : toplam,
                        ),
                        const SizedBox(height: 20),
                        KategoriSatiri(
                          etiket: l10n.aksesuar,
                          adet: analiz.aksesuar,
                          toplam: toplam == 0 ? 1 : toplam,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // SON GIYILENLER BASLIK VE AKSIYONLAR
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      Text(
                        '${l10n.sonGiyilenler} (${_gecmis.length})',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: colors.onSurface,
                        ),
                      ),
                      if (_gecmis.isNotEmpty)
                        TextButton.icon(
                          onPressed: _gecmisIslemiSuruyor
                              ? null
                              : _gecmisiTemizleOnayi,
                          icon: _gecmisIslemiSuruyor
                              ? SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: colors.onSurfaceVariant,
                                  ),
                                )
                              : Icon(
                                  Icons.delete_sweep_rounded,
                                  color: colors.error,
                                ),
                          label: Text(
                            l10n.tumunuTemizle,
                            style: TextStyle(
                                color: colors.error,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  if (_gecmis.isEmpty)
                    _ProfilKart(
                      child: Column(
                        children: [
                          Icon(
                            Icons.history_toggle_off_rounded,
                            size: 48,
                            color: colors.onSurfaceVariant,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            l10n.henuzGecmisKaydiYok,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: colors.onSurfaceVariant,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (_gecmis.isNotEmpty)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _gecmisKarti(_gecmis[index]),
                  childCount: _gecmis.length,
                ),
              ),
            ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 140 + MediaQuery.paddingOf(context).bottom,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfilAnalizi {
  final int ust;
  final int alt;
  final int ayakkabi;
  final int aksesuar;
  final int sepette;
  final int seri;
  final String stil;
  final double verimlilik;
  final List<MapEntry<String, int>> renkler;
  final List<Kiyafet> kahramanlar;
  final List<Kiyafet> unutulanlar;

  const _ProfilAnalizi({
    required this.ust,
    required this.alt,
    required this.ayakkabi,
    required this.aksesuar,
    required this.sepette,
    required this.seri,
    required this.stil,
    required this.verimlilik,
    required this.renkler,
    required this.kahramanlar,
    required this.unutulanlar,
  });
}

class _ProfilKart extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;

  const _ProfilKart({
    required this.child,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Material(
      color: colors.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.xxlRadius,
        side: BorderSide(
          color: colors.outlineVariant.withValues(alpha: 0.4),
          width: 1.5,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: child,
        ),
      ),
    );
  }
}

class _ProfilIkon extends StatelessWidget {
  final IconData icon;
  final Color? bgRenk;
  final Color? ikonRenk;

  const _ProfilIkon({
    required this.icon,
    this.bgRenk,
    this.ikonRenk,
  });

  @override
  Widget build(BuildContext context) {
    final defaultAccent = Theme.of(context).colorScheme.onSurfaceVariant;
    final bg = bgRenk ?? defaultAccent.withValues(alpha: 0.15);
    final fg = ikonRenk ?? defaultAccent;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: fg, size: 24),
    );
  }
}

class _ProfilBilgiKarti extends StatelessWidget {
  final IconData icon;
  final Color? bgRenk;
  final Color? ikonRenk;
  final String baslik;
  final String deger;

  const _ProfilBilgiKarti({
    required this.icon,
    this.bgRenk,
    this.ikonRenk,
    required this.baslik,
    required this.deger,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return _ProfilKart(
      child: Row(
        children: [
          _ProfilIkon(
            icon: icon,
            bgRenk: bgRenk,
            ikonRenk: ikonRenk,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  baslik,
                  style: TextStyle(
                    color: colors.onSurfaceVariant,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  deger,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    height: 1.25,
                    color: colors.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfilOzetKarti extends StatelessWidget {
  final IconData icon;
  final Color? bgRenk;
  final Color? ikonRenk;
  final String deger;
  final String baslik;

  const _ProfilOzetKarti({
    required this.icon,
    this.bgRenk,
    this.ikonRenk,
    required this.deger,
    required this.baslik,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return _ProfilKart(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ProfilIkon(
            icon: icon,
            bgRenk: bgRenk,
            ikonRenk: ikonRenk,
          ),
          const SizedBox(height: 16),
          Text(
            deger,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: colors.onSurface,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            baslik,
            style: TextStyle(
              color: colors.onSurfaceVariant,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfilIkili extends StatelessWidget {
  final Widget sol;
  final Widget sag;

  const _ProfilIkili({
    required this.sol,
    required this.sag,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final buyukYazi = MediaQuery.textScalerOf(context).scale(14) > 20;

        if (constraints.maxWidth < 320 || buyukYazi) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              sol,
              const SizedBox(height: 16),
              sag,
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: sol),
            const SizedBox(width: 16),
            Expanded(child: sag),
          ],
        );
      },
    );
  }
}