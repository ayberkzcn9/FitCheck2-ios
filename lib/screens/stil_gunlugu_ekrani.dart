// "Stil Günlüğüm" — geçmiş, plan ve haftalık özet tek ekranda.
//
// Üç sekme:
//  1. Takvim: ay ızgarası; giyilenler ve planlananlar noktayla işaretli.
//  2. Günlük: giyilen kombinlerin zaman akışı (görsellerle).
//  3. Rapor: son 7 günün özeti; görsel olarak paylaşılabilir.
//
// Veriler tamamen yerel: geçmiş kayıtları AnaEkran'dan, haftalık plan
// SharedPreferences'tan gelir.

import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../l10n/app_localizations.dart';
import '../models/kiyafet.dart';
import '../services/haftalik_rapor.dart';
import '../services/kombin_takvimi.dart';
import '../theme/design_tokens.dart';
import '../utils/helpers.dart';

class StilGunluguEkrani extends StatefulWidget {
  const StilGunluguEkrani({
    super.key,
    required this.gardirobum,
    required this.gecmisKombinler,
  });

  final List<Kiyafet> gardirobum;
  final List<Map<String, String>> gecmisKombinler;

  @override
  State<StilGunluguEkrani> createState() => _StilGunluguEkraniState();
}

class _StilGunluguEkraniState extends State<StilGunluguEkrani>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  /// Takvimde gösterilen ay.
  DateTime _ay = DateTime(DateTime.now().year, DateTime.now().month);

  /// Haftalık plan (hafta → gün adı → kombin adı).
  Map<String, dynamic>? _program;

  /// Rapor kartının görsele çevrilmesi için.
  final GlobalKey _raporKey = GlobalKey();
  bool _paylasiliyor = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _programiYukle();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _programiYukle() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final ham = prefs.getString('haftalik_program_json');
      if (ham == null || ham.isEmpty) return;
      final cozulen = safeJsonDecodeMap(ham, tag: 'stil_gunlugu_plani');
      if (!mounted || cozulen.isEmpty) return;
      setState(() => _program = cozulen);
    } catch (_) {
      // Plan okunamazsa takvim yalnızca geçmişi gösterir.
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        title: Text(l10n.stilGunluguBaslik),
        backgroundColor: colors.surface,
        surfaceTintColor: Colors.transparent,
        bottom: TabBar(
          controller: _tabController,
          labelColor: colors.primary,
          unselectedLabelColor: colors.onSurfaceVariant,
          indicatorColor: colors.primary,
          tabs: [
            Tab(text: l10n.stilGunluguTakvim),
            Tab(text: l10n.stilGunluguGunluk),
            Tab(text: l10n.stilGunluguRapor),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _takvimSekmesi(context, l10n, colors),
          _gunlukSekmesi(context, l10n, colors),
          _raporSekmesi(context, l10n, colors),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------- takvim

  Widget _takvimSekmesi(
    BuildContext context,
    AppLocalizations l10n,
    ColorScheme colors,
  ) {
    final yerel = MaterialLocalizations.of(context);
    final gunler = KombinTakvimi.ay(
      ay: _ay,
      gecmis: widget.gecmisKombinler,
      program: _program,
      simdi: DateTime.now(),
    );

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        Row(
          children: [
            IconButton(
              tooltip: yerel.previousMonthTooltip,
              onPressed: () => setState(() {
                _ay = DateTime(_ay.year, _ay.month - 1);
              }),
              icon: const Icon(Icons.chevron_left_rounded),
            ),
            Expanded(
              child: Text(
                yerel.formatMonthYear(_ay),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: colors.onSurface,
                ),
              ),
            ),
            IconButton(
              tooltip: yerel.nextMonthTooltip,
              onPressed: () => setState(() {
                _ay = DateTime(_ay.year, _ay.month + 1);
              }),
              icon: const Icon(Icons.chevron_right_rounded),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            for (final gun in _haftaEtiketleri(yerel))
              Expanded(
                child: Center(
                  child: Text(
                    gun,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        GridView.count(
          crossAxisCount: 7,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 0.82,
          children: [
            for (final gun in gunler)
              gun == null
                  ? const SizedBox.shrink()
                  : _takvimGunu(context, l10n, colors, gun),
          ],
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            _noktaGostergesi(colors, AppAccents.success, l10n.stilGunluguGiyildi),
            const SizedBox(width: 14),
            _noktaGostergesi(colors, AppAccents.info, l10n.stilGunluguPlanli),
          ],
        ),
        if (widget.gecmisKombinler.isEmpty && _program == null) ...[
          const SizedBox(height: 18),
          Text(
            l10n.gecmisKombinYok,
            textAlign: TextAlign.center,
            style: TextStyle(color: colors.onSurfaceVariant),
          ),
        ],
      ],
    );
  }

  /// Hafta günü başlıkları (pazartesi ile başlar).
  ///
  /// Flutter'ın [MaterialLocalizations.narrowWeekdays] listesi **pazar** günüyle
  /// başlar; bizim ızgara ve plan eşlemesi pazartesi ile başladığı için liste
  /// bir kaydırılır. Aksi halde her gün yanlış sütunda görünür.
  static List<String> _haftaEtiketleri(MaterialLocalizations yerel) {
    final dar = yerel.narrowWeekdays;
    if (dar.length != 7) return dar;
    return <String>[...dar.sublist(1), dar.first];
  }

  Widget _noktaGostergesi(
    ColorScheme colors,
    Color renk,
    String etiket,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: renk, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          etiket,
          style: TextStyle(fontSize: 11, color: colors.onSurfaceVariant),
        ),
      ],
    );
  }

  Widget _takvimGunu(
    BuildContext context,
    AppLocalizations l10n,
    ColorScheme colors,
    TakvimGunu gun,
  ) {
    final bugun = DateTime.now();
    final bugunMu = gun.tarih.year == bugun.year &&
        gun.tarih.month == bugun.month &&
        gun.tarih.day == bugun.day;

    return GestureDetector(
      onTap: () => _gunDetayi(gun, l10n, colors),
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: bugunMu
              ? colors.primaryContainer.withValues(alpha: 0.55)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${gun.tarih.day}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: bugunMu ? FontWeight.w900 : FontWeight.w600,
                color: colors.onSurface,
              ),
            ),
            const SizedBox(height: 3),
            SizedBox(
              height: 6,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (gun.giyildi)
                    _nokta(colors, AppAccents.success)
                  else
                    const SizedBox(width: 6),
                  if (gun.planVar) ...[
                    const SizedBox(width: 3),
                    _nokta(colors, AppAccents.info),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _nokta(ColorScheme colors, Color renk) {
    return Container(
      width: 5,
      height: 5,
      decoration: BoxDecoration(color: renk, shape: BoxShape.circle),
    );
  }

  void _gunDetayi(
    TakvimGunu gun,
    AppLocalizations l10n,
    ColorScheme colors,
  ) {
    final yerel = MaterialLocalizations.of(context);

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: colors.surfaceContainerHigh,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  yerel.formatMediumDate(gun.tarih),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: colors.onSurface,
                  ),
                ),
                const SizedBox(height: 12),
                if (gun.planlanan.isEmpty && gun.giyilen.isEmpty)
                  Text(
                    l10n.stilGunluguGunBos,
                    style: TextStyle(color: colors.onSurfaceVariant),
                  ),
                for (final kombin in gun.planlanan)
                  _satir(
                    icons: Icons.event_note_rounded,
                    renk: AppAccents.info,
                    baslik: l10n.stilGunluguPlanli,
                    metin: kombin,
                  ),
                for (final kombin in gun.giyilen)
                  _satir(
                    icons: Icons.check_circle_rounded,
                    renk: AppAccents.success,
                    baslik: l10n.stilGunluguGiyildi,
                    metin: kombin,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _satir({
    required IconData icons,
    required Color renk,
    required String baslik,
    required String metin,
  }) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icons, size: 18, color: renk),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  baslik,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: colors.onSurfaceVariant,
                  ),
                ),
                Text(
                  metin,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
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

  // ---------------------------------------------------------------- günlük

  Widget _gunlukSekmesi(
    BuildContext context,
    AppLocalizations l10n,
    ColorScheme colors,
  ) {
    final gecmis = widget.gecmisKombinler;
    if (gecmis.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.auto_stories_rounded,
                  size: 46, color: colors.onSurfaceVariant),
              const SizedBox(height: 12),
              Text(
                l10n.gecmisKombinYok,
                textAlign: TextAlign.center,
                style: TextStyle(color: colors.onSurfaceVariant),
              ),
            ],
          ),
        ),
      );
    }

    final indeks = _parcaIndeksi();

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      itemCount: gecmis.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, i) {
        final kayit = gecmis[i];
        final tarih = _tarihCoz(kayit['tarih'] ?? '');
        final parcalar = (kayit['detay'] ?? '')
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();

        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: colors.surfaceContainerHighest.withValues(alpha: 0.45),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: colors.outlineVariant.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      kayit['baslik'] ?? '',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: colors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      tarih == null
                          ? (kayit['tarih'] ?? '')
                          : MaterialLocalizations.of(context)
                              .formatMediumDate(tarih),
                      style: TextStyle(
                        fontSize: 11,
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                    if (parcalar.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        parcalar.join(', '),
                        style: TextStyle(
                          fontSize: 12,
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (parcalar.isNotEmpty)
                SizedBox(
                  width: 96,
                  height: 52,
                  child: Row(
                    children: [
                      for (final ad in parcalar.take(3))
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: _parcaGorseli(indeks[ad.toLowerCase()]),
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _parcaGorseli(Kiyafet? kiyafet) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(10),
      ),
      clipBehavior: Clip.antiAlias,
      child: kiyafet == null
          ? const SizedBox.shrink()
          : Image.memory(
              kiyafet.resimBytes,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.medium,
              gaplessPlayback: true,
            ),
    );
  }

  /// Kombin adı → kıyafet (küçük harf karşılaştırma).
  Map<String, Kiyafet> _parcaIndeksi() {
    final sonuc = <String, Kiyafet>{};
    for (final k in widget.gardirobum) {
      sonuc[k.gorunenBaslik.trim().toLowerCase()] = k;
      sonuc[k.baslik.trim().toLowerCase()] = k;
    }
    return sonuc;
  }

  // ---------------------------------------------------------------- rapor

  Widget _raporSekmesi(
    BuildContext context,
    AppLocalizations l10n,
    ColorScheme colors,
  ) {
    final rapor = HaftalikRaporVerisi.hesapla(
      gecmis: widget.gecmisKombinler,
      gardirobum: widget.gardirobum,
      simdi: DateTime.now(),
    );

    final fark = rapor.degisim > 0
        ? '+${rapor.degisim}'
        : rapor.degisim < 0
            ? '${rapor.degisim}'
            : '0';

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        RepaintBoundary(
          key: _raporKey,
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  colors.primaryContainer.withValues(alpha: 0.85),
                  colors.surfaceContainerHighest.withValues(alpha: 0.75),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.stilGunluguRaporOzet('${rapor.kombinSayisi}'),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: colors.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.stilGunluguRaporGecenHafta(fark),
                  style: TextStyle(
                    fontSize: 12,
                    color: colors.onPrimaryContainer
                        .withValues(alpha: 0.75),
                  ),
                ),
                const SizedBox(height: 16),
                _haftaSeridi(rapor, colors),
                const SizedBox(height: 18),
                _raporSatiri(
                  l10n.stilGunluguRaporKullanim,
                  '%${rapor.kullanimYuzdesi}',
                  colors,
                ),
                _raporSatiri(
                  l10n.stilGunluguRaporEnCok,
                  rapor.enCokParca ?? '-',
                  colors,
                ),
                _raporSatiri(
                  l10n.stilGunluguRaporSeri,
                  '${rapor.seriGun}',
                  colors,
                ),
                _raporSatiri(
                  l10n.stilGunluguRaporHicGiyilmemis,
                  '${rapor.hicGiyilmemis}',
                  colors,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        if (rapor.bos)
          Text(
            l10n.stilGunluguRaporBos,
            textAlign: TextAlign.center,
            style: TextStyle(color: colors.onSurfaceVariant),
          ),
        const SizedBox(height: 10),
        FilledButton.icon(
          onPressed: (_paylasiliyor || rapor.bos) ? null : _raporuPaylas,
          icon: _paylasiliyor
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.ios_share_rounded, size: 18),
          label: Text(l10n.stilGunluguRaporPaylas),
        ),
      ],
    );
  }

  Widget _haftaSeridi(HaftalikRaporVerisi rapor, ColorScheme colors) {
    final baslangic = rapor.baslangic;
    return Row(
      children: [
        for (var i = 0; i < rapor.gunler.length; i++)
          Expanded(
            child: Column(
              children: [
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: rapor.gunler[i]
                        ? AppAccents.success.withValues(alpha: 0.85)
                        : colors.surface.withValues(alpha: 0.6),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${baslangic.add(Duration(days: i)).day}',
                  style: TextStyle(
                    fontSize: 10,
                    color: colors.onPrimaryContainer
                        .withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _raporSatiri(String etiket, String deger, ColorScheme colors) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              etiket,
              style: TextStyle(
                fontSize: 13,
                color: colors.onPrimaryContainer.withValues(alpha: 0.8),
              ),
            ),
          ),
          Text(
            deger,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: colors.onPrimaryContainer,
            ),
          ),
        ],
      ),
    );
  }

  /// Raporu PNG'ye çevirip paylaşır.
  Future<void> _raporuPaylas() async {
    final l10n = AppLocalizations.of(context)!;
    if (_paylasiliyor) return;
    setState(() => _paylasiliyor = true);

    try {
      final sinir = _raporKey.currentContext?.findRenderObject();
      if (sinir is! RenderRepaintBoundary) return;

      final gorsel = await sinir.toImage(pixelRatio: 3);
      final veri = await gorsel.toByteData(format: ui.ImageByteFormat.png);
      if (veri == null) return;

      final klasor = await getTemporaryDirectory();
      final dosya = File(
        '${klasor.path}/fitcheck-rapor-'
        '${DateTime.now().millisecondsSinceEpoch}.png',
      );
      await dosya.writeAsBytes(veri.buffer.asUint8List(), flush: true);

      if (!mounted) return;

      final rapor = HaftalikRaporVerisi.hesapla(
        gecmis: widget.gecmisKombinler,
        gardirobum: widget.gardirobum,
        simdi: DateTime.now(),
      );

      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(dosya.path, mimeType: 'image/png')],
          text: l10n.stilGunluguRaporPaylasMetni(
            l10n.stilGunluguRaporOzet('${rapor.kombinSayisi}'),
          ),
          subject: l10n.stilGunluguRapor,
          sharePositionOrigin: sinir.localToGlobal(Offset.zero) & sinir.size,
        ),
      );
    } catch (e) {
      debugPrint('Rapor paylaşılamadı: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.bugunPaylasHata)),
      );
    } finally {
      if (mounted) setState(() => _paylasiliyor = false);
    }
  }

  static DateTime? _tarihCoz(String metin) {
    final parcalar = metin.split('-');
    if (parcalar.length != 3) return null;
    final yil = int.tryParse(parcalar[0]);
    final ay = int.tryParse(parcalar[1]);
    final gun = int.tryParse(parcalar[2]);
    if (yil == null || ay == null || gun == null) return null;
    return DateTime(yil, ay, gun);
  }
}
