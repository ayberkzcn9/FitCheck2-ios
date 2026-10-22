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
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../l10n/app_localizations.dart';
import '../models/bugun_kombin.dart';
import '../models/favori_kombin.dart';
import '../models/kiyafet.dart';
import '../models/planli_kombin.dart';
import '../services/akilli_raflar.dart';
import '../services/haftalik_rapor.dart';
import '../services/kombin_takvimi.dart';
import '../services/planli_kombin_deposu.dart';
import '../theme/design_tokens.dart';
import '../utils/helpers.dart';
import '../utils/takvim_gunleri.dart';
import '../widgets/bilgi_butonu.dart';

class StilGunluguEkrani extends StatefulWidget {
  const StilGunluguEkrani({
    super.key,
    required this.gardirobum,
    required this.gecmisKombinler,
    this.favoriKombinler = const <FavoriKombin>[],
    this.onKombinSekmesineGit,
  });

  final List<Kiyafet> gardirobum;
  final List<Map<String, String>> gecmisKombinler;

  /// Takvimde güne kombin atarken seçilebilecek favori kombinler.
  final List<FavoriKombin> favoriKombinler;

  /// Favori kombin yoksa "Kombin oluştur" düğmesinin gideceği sekme.
  final VoidCallback? onKombinSekmesineGit;

  @override
  State<StilGunluguEkrani> createState() => _StilGunluguEkraniState();
}

class _StilGunluguEkraniState extends State<StilGunluguEkrani>
    with SingleTickerProviderStateMixin {
  /// Kombin seçicide "Kombin oluştur" seçildiğini taşıyan işaret.
  static const Object _kombinOlusturSinyali = Object();

  late final TabController _tabController;

  /// Takvimde gösterilen ay.
  DateTime _ay = DateTime(DateTime.now().year, DateTime.now().month);

  /// Haftalık plan (hafta → gün adı → kombin adı).
  Map<String, dynamic>? _program;

  /// Tarihe özel planlar: `YYYY-MM-DD` → kombin.
  Map<String, PlanliKombin> _planlar = <String, PlanliKombin>{};

  /// Rapor kartının görsele çevrilmesi için.
  final GlobalKey _raporKey = GlobalKey();
  bool _paylasiliyor = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _programiYukle();
    _planlariYukle();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _planlariYukle() async {
    final planlar = await PlanliKombinDeposu().yukle();
    if (!mounted || planlar.isEmpty) return;
    setState(() => _planlar = planlar);
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
    // Türkçede tek harflik kısaltmalar üç günü de "P" yapıyor; haftalık
    // ızgarada okunur kısaltmalar kullanılıyor (Pzt, Sal, Çar...).
    final gunAdlari = Localizations.localeOf(context).languageCode == 'tr'
        ? const ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz']
        : _haftaEtiketleri(yerel);
    final indeks = _parcaIndeksi();
    final gunler = KombinTakvimi.ay(
      ay: _ay,
      gecmis: widget.gecmisKombinler,
      program: _program,
      simdi: DateTime.now(),
      planliKombinler: _planlar,
    );

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
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
            for (final gun in gunAdlari)
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
                  : _takvimGunu(context, l10n, colors, gun, indeks),
          ],
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            _noktaGostergesi(colors, colors.primary, l10n.stilGunluguGiyildi),
            const SizedBox(width: 14),
            _noktaGostergesi(colors, colors.tertiary, l10n.stilGunluguPlanli),
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
    // Tek harflik kısaltmalar Türkçede üç günü de "P" yapıyordu (Pzt/Per/Paz).
    // Dar adların ilk üç harfi hem okunur hem sığıyor: Pzt, Sal, Çar.
    final dar = yerel.narrowWeekdays;
    if (dar.length != 7) return dar;
    final ilkGun = yerel.firstDayOfWeekIndex; // 0 = Pazar
    return List<String>.generate(7, (i) => dar[(ilkGun + i) % 7]);
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
    Map<String, Kiyafet> indeks,
  ) {
    final bugun = DateTime.now();
    final bugunMu = gun.tarih.year == bugun.year &&
        gun.tarih.month == bugun.month &&
        gun.tarih.day == bugun.day;
    final planliParca = _plandanParca(gun.planliKombin, indeks);

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
            if (planliParca != null)
              // Tarihe özel planı olan gün, ilk parçanın küçük görselini taşır.
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  width: 18,
                  height: 18,
                  color: colors.surfaceContainerHighest,
                  child: Image.memory(
                    planliParca.resimBytes,
                    fit: BoxFit.cover,
                    gaplessPlayback: true,
                    errorBuilder: (_, __, ___) => Icon(
                      Icons.event_note_rounded,
                      size: 12,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ),
              )
            else
              SizedBox(
                height: 6,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (gun.giyildi)
                      _nokta(colors, colors.primary)
                    else
                      const SizedBox(width: 6),
                    if (gun.planVar) ...[
                      const SizedBox(width: 3),
                      _nokta(colors, colors.tertiary),
                    ],
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Planın parçalarından dolapta bulunan ilk parçayı döndürür.
  Kiyafet? _plandanParca(PlanliKombin? plan, Map<String, Kiyafet> indeks) {
    if (plan == null) return null;
    for (final ad in plan.parcalar) {
      final parca = indeks[ad.trim().toLowerCase()];
      if (parca != null) return parca;
    }
    return null;
  }

  Widget _nokta(ColorScheme colors, Color renk) {
    return Container(
      width: 5,
      height: 5,
      decoration: BoxDecoration(color: renk, shape: BoxShape.circle),
    );
  }

  Future<void> _gunDetayi(
    TakvimGunu gun,
    AppLocalizations l10n,
    ColorScheme colors,
  ) async {
    final yerel = MaterialLocalizations.of(context);
    final indeks = _parcaIndeksi();
    final bugun = DateTime.now();
    final gecmisGun = gun.tarih
        .isBefore(DateTime(bugun.year, bugun.month, bugun.day));
    final plan = gun.planliKombin;

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: colors.surfaceContainerHigh,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
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
                if (plan != null) ...[
                  _planKarti(plan, indeks, colors, l10n),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      FilledButton.icon(
                        onPressed: () {
                          HapticFeedback.selectionClick();
                          Navigator.of(sheetContext).pop();
                          _kombinSec(gun, l10n, colors);
                        },
                        icon: const Icon(Icons.swap_horiz_rounded, size: 18),
                        label: Text(l10n.planDegistir),
                      ),
                      const SizedBox(width: 8),
                      TextButton.icon(
                        onPressed: () async {
                          Navigator.of(sheetContext).pop();
                          final tarih = gunAnahtari(gun.tarih);
                          final silinen = plan;
                          final yeni = await PlanliKombinDeposu().kaldir(tarih);
                          if (!mounted) return;
                          setState(() => _planlar = yeni);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(l10n.planKaldirildi),
                              behavior: SnackBarBehavior.floating,
                              // Yanlışlıkla silinen plan geri alınabilsin.
                              action: SnackBarAction(
                                label: l10n.geriAl,
                                onPressed: () async {
                                  if (silinen == null) return;
                                  final geri =
                                      await PlanliKombinDeposu().ata(silinen);
                                  if (!mounted) return;
                                  setState(() => _planlar = geri);
                                },
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.event_busy_rounded, size: 18),
                        label: Text(l10n.planKaldir),
                      ),
                    ],
                  ),
                ] else if (!gecmisGun) ...[
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () {
                        HapticFeedback.selectionClick();
                        Navigator.of(sheetContext).pop();
                        _kombinSec(gun, l10n, colors);
                      },
                      icon: const Icon(Icons.add_rounded, size: 18),
                      label: Text(l10n.planGuneKombinSec),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
                for (final kombin in gun.planlanan)
                  _satir(
                    icons: Icons.repeat_rounded,
                    renk: colors.tertiary,
                    baslik: l10n.planHaftalikProgram,
                    metin: kombin,
                  ),
                for (final kombin in gun.giyilen)
                  _satir(
                    icons: Icons.check_circle_rounded,
                    renk: colors.primary,
                    baslik: l10n.stilGunluguGiyildi,
                    metin: kombin,
                  ),
                if (gun.bos)
                  Text(
                    l10n.stilGunluguGunBos,
                    style: TextStyle(color: colors.onSurfaceVariant),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Seçili günün plan kartı: başlık, parça sayısı ve parça görselleri.
  Widget _planKarti(
    PlanliKombin plan,
    Map<String, Kiyafet> indeks,
    ColorScheme colors,
    AppLocalizations l10n,
  ) {
    final parcalar = plan.parcalar
        .map((ad) => indeks[ad.trim().toLowerCase()])
        .whereType<Kiyafet>()
        .toList();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  plan.baslik,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: colors.onSurface,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                l10n.planParcaSayisi(plan.parcalar.length),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
          if (parcalar.isNotEmpty) ...[
            const SizedBox(height: 10),
            SizedBox(
              height: 58,
              child: Row(
                children: [
                  for (final parca in parcalar.take(4))
                    Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: SizedBox(
                        width: 46,
                        child: _parcaGorseli(parca),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Favori kombinlerden birini seçip güne atar.
  Future<void> _kombinSec(
    TakvimGunu gun,
    AppLocalizations l10n,
    ColorScheme colors,
  ) async {
    final indeks = _parcaIndeksi();
    final secim = await showModalBottomSheet<Object>(
      context: context,
      isScrollControlled: true,
      backgroundColor: colors.surfaceContainerHigh,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (secimContext) {
        final favoriler = widget.favoriKombinler;
        final sonGiyilenler = _sonGiyilenler();
        final oneriler = _oneriler(gun.tarih);
        return SafeArea(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(secimContext).size.height * 0.72,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          l10n.planKombinSec,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: colors.onSurface,
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: MaterialLocalizations.of(secimContext)
                            .closeButtonTooltip,
                        onPressed: () => Navigator.of(secimContext).pop(),
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ],
                  ),
                ),
                if (favoriler.isEmpty && sonGiyilenler.isEmpty && oneriler.isEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.planFavoriYok,
                          style: TextStyle(color: colors.onSurfaceVariant),
                        ),
                        const SizedBox(height: 12),
                        FilledButton.icon(
                          onPressed: () => Navigator.of(secimContext)
                              .pop(_kombinOlusturSinyali),
                          icon: const Icon(Icons.auto_awesome_rounded, size: 18),
                          label: Text(l10n.planKombinOlustur),
                        ),
                      ],
                    ),
                  )
                else
                  Flexible(
                    child: ListView(
                      shrinkWrap: true,
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      children: [
                        if (oneriler.isNotEmpty) ...[
                          _secimBasligi(l10n.planOneriler, colors),
                          const SizedBox(height: 8),
                          for (final oneri in oneriler)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: _kombinSatiri(
                                baslik: oneri.baslik,
                                altBaslik: null,
                                parcalar: oneri.parcalar,
                                indeks: indeks,
                                colors: colors,
                                onTap: () => Navigator.of(secimContext).pop(oneri),
                              ),
                            ),
                        ],
                        if (favoriler.isNotEmpty) ...[
                          _secimBasligi(l10n.planFavorilerim, colors),
                          const SizedBox(height: 8),
                          for (final favori in favoriler)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: _kombinSatiri(
                                baslik: favori.baslik,
                                altBaslik: favori.tuyo,
                                parcalar: favori.parcalar,
                                indeks: indeks,
                                colors: colors,
                                onTap: () => Navigator.of(secimContext).pop(
                                  PlanliKombin(
                                    tarih: '',
                                    baslik: favori.baslik,
                                    parcalar: favori.parcalar,
                                  ),
                                ),
                              ),
                            ),
                        ],
                        if (sonGiyilenler.isNotEmpty) ...[
                          _secimBasligi(l10n.planSonGiyilenler, colors),
                          const SizedBox(height: 8),
                          for (final gecmis in sonGiyilenler)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: _kombinSatiri(
                                baslik: gecmis.baslik,
                                altBaslik: null,
                                parcalar: gecmis.parcalar,
                                indeks: indeks,
                                colors: colors,
                                onTap: () => Navigator.of(secimContext).pop(gecmis),
                              ),
                            ),
                        ],
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );

    if (!mounted || secim == null) return;

    if (identical(secim, _kombinOlusturSinyali)) {
      Navigator.of(context).maybePop();
      widget.onKombinSekmesineGit?.call();
      return;
    }

    final secilen = secim as PlanliKombin;
    final yeni = await PlanliKombinDeposu().ata(
      secilen.kopya(tarih: gunAnahtari(gun.tarih)),
    );
    if (!mounted) return;
    HapticFeedback.lightImpact();
    setState(() => _planlar = yeni);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.planGuneEklendi)),
    );
  }

  /// Kural bazlı öneriler (çevrimdışı ve anında): o güne uygun kombiler.
  ///
  /// Aynı üretici Bugün akışının yedek yolu; böylece seçim sayfası ağ
  /// çağrısı yapmadan da dolu görünür.
  List<PlanliKombin> _oneriler(DateTime tarih) {
    final idIndeks = {for (final k in widget.gardirobum) k.id: k};
    final kombinler = AkilliRaflar.kurallIleKombinler(
      widget.gardirobum,
      adet: 2,
      gun: tarih,
    );
    return kombinler
        .where((k) => k.gecerliMi)
        .map(
          (k) => PlanliKombin(
            tarih: '',
            baslik: k.baslik,
            parcalar: k
                .parcalar(idIndeks)
                .map((p) => p.gorunenBaslik)
                .toList(),
          ),
        )
        .toList();
  }

  /// Seçim sayfasındaki bölüm başlığı.
  Widget _secimBasligi(String metin, ColorScheme colors) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Text(
        turkceBuyukHarf(metin),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.8,
          color: colors.onSurfaceVariant,
        ),
      ),
    );
  }

  /// Geçmişten türetilen, son giyilen kombinler (en fazla 5, tekrarsız).
  ///
  /// Geçmiş kaydında parçalar virgülle birleşik yazılır; burada tekrar ayrılır.
  List<PlanliKombin> _sonGiyilenler() {
    final sonuc = <PlanliKombin>[];
    final gorulenler = <String>{};
    for (final kayit in widget.gecmisKombinler) {
      final baslik = (kayit['baslik'] ?? '').trim();
      if (baslik.isEmpty) continue;
      if (!gorulenler.add(baslik.toLowerCase())) continue;
      final detay = (kayit['detay'] ?? '').trim();
      final parcalar = detay.isEmpty
          ? const <String>[]
          : detay
              .split(',')
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .toList();
      sonuc.add(
        PlanliKombin(tarih: '', baslik: baslik, parcalar: parcalar),
      );
      if (sonuc.length >= 5) break;
    }
    return sonuc;
  }

  /// Seçim listesindeki tek kombin satırı.
  Widget _kombinSatiri({
    required String baslik,
    required String? altBaslik,
    required List<String> parcalar,
    required Map<String, Kiyafet> indeks,
    required ColorScheme colors,
    required VoidCallback onTap,
  }) {
    final gorseller = parcalar
        .map((ad) => indeks[ad.trim().toLowerCase()])
        .whereType<Kiyafet>()
        .take(3)
        .toList();

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: colors.surfaceContainerHighest.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            for (final parca in gorseller)
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: SizedBox(width: 34, height: 44, child: _parcaGorseli(parca)),
              ),
            if (gorseller.isEmpty)
              Icon(Icons.checkroom_rounded, color: colors.onSurfaceVariant),
            const SizedBox(width: 6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    baslik,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: colors.onSurface,
                    ),
                  ),
                  if (altBaslik != null && altBaslik.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      altBaslik,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: colors.onSurfaceVariant),
          ],
        ),
      ),
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
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
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
        borderRadius: BorderRadius.circular(12),
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
    final farkRengi = rapor.degisim > 0
        ? colors.primary
        : rapor.degisim < 0
            ? AppAccents.error
            : colors.onPrimaryContainer;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
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
              borderRadius: BorderRadius.circular(AppRadius.xxl),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Büyük sayı: haftanın tek bakışta okunan değeri.
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${rapor.kombinSayisi}',
                      style: TextStyle(
                        fontSize: 44,
                        height: 1.0,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1.5,
                        color: colors.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                l10n.stilGunluguRaporSayiEtiketi,
                                style: TextStyle(
                                  fontSize: AppText.body.fontSize,
                                  height: 1.25,
                                  fontWeight: FontWeight.w600,
                                  color: colors.onPrimaryContainer
                                      .withValues(alpha: 0.85),
                                ),
                              ),
                            ),
                            BilgiButonu(
                              baslik: l10n.stilGunluguRaporSayiEtiketi,
                              aciklama: l10n.bilgiRaporHafta,
                              renk: colors.onPrimaryContainer.withValues(alpha: 0.7),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                if (rapor.kombinSayisi > 0) ...[
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: farkRengi.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                      child: Text(
                        l10n.stilGunluguRaporGecenHafta(fark),
                        style: TextStyle(
                          fontSize: AppText.labelSmall.fontSize,
                          fontWeight: FontWeight.w700,
                          color: farkRengi,
                        ),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 18),
                _haftaSeridi(rapor, colors),
                const SizedBox(height: 20),
                _dortHaftaGrafik(rapor, l10n, colors),
                if (rapor.enCokParcalar.isNotEmpty) ...[
                  const SizedBox(height: 18),
                  _enCokParcalar(rapor, l10n, colors),
                ],
                const SizedBox(height: 16),
                _raporSatiri(
                  l10n.stilGunluguRaporKullanim,
                  '%${rapor.kullanimYuzdesi}',
                  colors,
                  oran: rapor.kullanimYuzdesi / 100,
                  bilgiBaslik: l10n.stilGunluguRaporKullanim,
                  bilgiAciklama: l10n.bilgiRaporKullanim,
                ),
                // Sıfır değerli satırlar gösterilmez: bilgi taşımıyor.
                if (rapor.seriGun > 0)
                  _raporSatiri(
                    l10n.stilGunluguRaporSeri,
                    '${rapor.seriGun}',
                    colors,
                    bilgiBaslik: l10n.stilGunluguRaporSeri,
                    bilgiAciklama: l10n.bilgiRaporSeri,
                  ),
                if (rapor.hicGiyilmemis > 0)
                  _raporSatiri(
                    l10n.stilGunluguRaporHicGiyilmemis,
                    '${rapor.hicGiyilmemis}',
                    colors,
                    bilgiBaslik: l10n.stilGunluguRaporHicGiyilmemis,
                    bilgiAciklama: l10n.bilgiRaporHicGiyilmemis,
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

  /// Son 4 haftanın mini çubuk grafiği (sayılar dile bağlı değil).
  Widget _dortHaftaGrafik(
    HaftalikRaporVerisi rapor,
    AppLocalizations l10n,
    ColorScheme colors,
  ) {
    final zirve = rapor.haftalikZirve;
    final haftalar = rapor.sonDortHafta;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.stilGunluguRaporDortHafta,
                style: TextStyle(
                  fontSize: AppText.labelSmall.fontSize,
                  fontWeight: FontWeight.w700,
                  color: colors.onPrimaryContainer.withValues(alpha: 0.75),
                ),
              ),
            ),
            BilgiButonu(
              baslik: l10n.stilGunluguRaporDortHafta,
              aciklama: l10n.bilgiRaporDortHafta,
              renk: colors.onPrimaryContainer.withValues(alpha: 0.7),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 74,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (var i = 0; i < haftalar.length; i++)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '${haftalar[i]}',
                          style: TextStyle(
                            fontSize: AppText.labelSmall.fontSize,
                            fontWeight: FontWeight.w800,
                            color: colors.onPrimaryContainer,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          height: zirve == 0
                              ? 4
                              : 6 + (34 * (haftalar[i] / zirve)).clamp(0, 34),
                          decoration: BoxDecoration(
                            color: i == haftalar.length - 1
                                ? colors.primary
                                : colors.onPrimaryContainer
                                    .withValues(alpha: 0.22),
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  /// Haftanın en çok giyilen 3 parçası (görsel + adet).
  Widget _enCokParcalar(
    HaftalikRaporVerisi rapor,
    AppLocalizations l10n,
    ColorScheme colors,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.stilGunluguRaporEnCokParcalar,
                style: TextStyle(
                  fontSize: AppText.labelSmall.fontSize,
                  fontWeight: FontWeight.w700,
                  color: colors.onPrimaryContainer.withValues(alpha: 0.75),
                ),
              ),
            ),
            BilgiButonu(
              baslik: l10n.stilGunluguRaporEnCokParcalar,
              aciklama: l10n.bilgiRaporEnCokParcalar,
              renk: colors.onPrimaryContainer.withValues(alpha: 0.7),
            ),
          ],
        ),
        const SizedBox(height: 8),
        for (final parca in rapor.enCokParcalar)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              children: [
                SizedBox(
                  width: 32,
                  height: 32,
                  child: _parcaGorseli(_parcaBul(parca.ad)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    parca.ad,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: AppText.bodySmall.fontSize,
                      fontWeight: FontWeight.w600,
                      color: colors.onPrimaryContainer,
                    ),
                  ),
                ),
                Text(
                  '×${parca.adet}',
                  style: TextStyle(
                    fontSize: AppText.bodySmall.fontSize,
                    fontWeight: FontWeight.w800,
                    color: colors.onPrimaryContainer.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  /// Parça adından dolap kaydını bulur (rapor görselleri için).
  Kiyafet? _parcaBul(String ad) {
    for (final parca in widget.gardirobum) {
      if (parca.gorunenBaslik == ad) return parca;
    }
    return null;
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
                        ? colors.primary.withValues(alpha: 0.9)
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

  Widget _raporSatiri(
    String etiket,
    String deger,
    ColorScheme colors, {
    double? oran,
    String? bilgiBaslik,
    String? bilgiAciklama,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  etiket,
                  style: TextStyle(
                    fontSize: AppText.bodySmall.fontSize,
                    color: colors.onPrimaryContainer.withValues(alpha: 0.8),
                  ),
                ),
              ),
              if (bilgiBaslik != null && bilgiAciklama != null)
                BilgiButonu(
                  baslik: bilgiBaslik,
                  aciklama: bilgiAciklama,
                  renk: colors.onPrimaryContainer.withValues(alpha: 0.7),
                ),
              Text(
                deger,
                style: TextStyle(
                  fontSize: AppText.body.fontSize,
                  fontWeight: FontWeight.w900,
                  color: colors.onPrimaryContainer,
                ),
              ),
            ],
          ),
          if (oran != null) ...[
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              child: LinearProgressIndicator(
                value: oran.clamp(0.0, 1.0),
                minHeight: 6,
                backgroundColor:
                    colors.onPrimaryContainer.withValues(alpha: 0.14),
                valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
              ),
            ),
          ],
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
