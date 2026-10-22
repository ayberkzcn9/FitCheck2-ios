// "Bugün" — uygulamanın ilk sayfası.
//
// Üç şeyi tek yerde toplar:
//  1. Bugünün kombini (akışın ilk kartı, büyük).
//  2. Hızlı aksiyonlar: fotoğraf ekle, kombin üret, stiliste sor, haftayı planla.
//  3. Akıllı raflar: 2 haftadır giyilmeyenler, yeni eklenenler, bugüne uygun.
//
// Veri akışı:
//  - Kombinler [BugunFeedServisi]'nden gelir (günde 1 yapay zekâ çağrısı,
//    ardından cihazdaki önbellek).
//  - Raflar tamamen yereldir ([AkilliRaflar]); ağ çağrısı yapmaz.
//
// Bu ekran hiçbir şeyi "sahiplenmez": dolap listesi ve favori/geçmiş kayıtları
// AnaEkran'da tutulur, buradan callback ile bildirilir.

import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../l10n/app_localizations.dart';
import '../models/bugun_kombin.dart';
import '../models/favori_kombin.dart';
import '../models/kiyafet.dart';
import '../models/planli_kombin.dart';
import '../services/akilli_raflar.dart';
import '../services/analytics_servisi.dart';
import '../services/bugun_feed_servisi.dart';
import '../services/planli_kombin_deposu.dart';
import '../theme/design_tokens.dart';
import '../utils/helpers.dart';
import '../widgets/bilgi_butonu.dart';

class BugunEkrani extends StatefulWidget {
  const BugunEkrani({
    super.key,
    required this.gardirobum,
    required this.gunlukHava,
    required this.havaYukleniyor,
    required this.isAktifSekme,
    required this.onSekmeSec,
    required this.onFotografEkle,
    required this.onFavoriEkle,
    required this.onGecmiseEkle,
    required this.onStilistAc,
    required this.anaRenk,
    this.onKiyafetGiyildi,
    this.onKombinIstegi,
    this.onStilGunluguAc,
    this.onSeyahatAc,
    this.feedServisi,
    this.planJetonu = 0,
    this.favoriKombinler = const <FavoriKombin>[],
    this.gecmisKombinler = const <Map<String, String>>[],
    this.sepetJetonu = 0,
  });

  final List<Kiyafet> gardirobum;
  final String gunlukHava;
  final bool havaYukleniyor;
  final bool isAktifSekme;

  /// 1 = Dolap, 2 = Haftalık plan, 3 = Kombin, 4 = Kendi kombinim.
  final ValueChanged<int> onSekmeSec;

  final Future<void> Function() onFotografEkle;
  final Future<void> Function(FavoriKombin) onFavoriEkle;
  final Future<void> Function(String, List<Kiyafet>) onGecmiseEkle;
  final VoidCallback onStilistAc;
  final Color anaRenk;

  /// Raftan tek parça için "bugün giydim" işaretlemesi.
  ///
  /// Opsiyonel: verilmezse bu aksiyon gizlenir (testler/önizleme).
  final Future<void> Function(Kiyafet)? onKiyafetGiyildi;

  /// Raftaki parçayla kombin kurma isteği (Kombin sekmesine odakla gider).
  final void Function(Kiyafet)? onKombinIstegi;

  /// "Stil Günlüğüm" ekranını açar (takvim + günlük + haftalık rapor).
  final VoidCallback? onStilGunluguAc;

  /// "Seyahat Modu" ekranını açar (valiz planı).
  final VoidCallback? onSeyahatAc;

  /// Testlerde sahte akış servisi vermek için; varsayılan gerçek servis.
  final BugunFeedServisi? feedServisi;

  /// Takvimde plan değiştiğinde artan sayaç: kartın tazelenmesini sağlar.
  final int planJetonu;

  /// Daha önce kaydedilmiş favoriler; "Kaydet" düğmesinin dolu görünmesi
  /// için kullanılır.
  final List<FavoriKombin> favoriKombinler;

  /// Giyilme geçmişi (`tarih`, `baslik`, `detay`); "Giydim" düğmesinin dolu
  /// görünmesi için bugünün kayıtları kullanılır.
  final List<Map<String, String>> gecmisKombinler;

  /// Çamaşır sepeti her değiştiğinde (temizle / tekli çıkar) artan sayaç.
  ///
  /// Bugün ekranı bu sayacı izleyerek iyimser "giydildi" işaretlerini bırakır:
  /// parçalar yıkandıysa düğme yeniden "Giydim" olur.
  final int sepetJetonu;

  @override
  State<BugunEkrani> createState() => _BugunEkraniState();
}

class _BugunEkraniState extends State<BugunEkrani> {
  List<BugunKombin> _kombinler = const <BugunKombin>[];
  bool _yukleniyor = true;

  /// Hangi gün için yüklendi (gün değişince akış yenilenir).
  String _yuklenenGun = '';

  /// Dolap/hava imzası: değişirse akış kendini yeniler.
  String _imza = '';

  /// Bugünün kombin kartını görsele çevirip paylaşmak için.
  final GlobalKey _paylasKey = GlobalKey();
  bool _paylasiliyor = false;

  /// Takvimde bugüne atanmış kombin (varsa).
  PlanliKombin? _bugunPlani;

  /// Bu oturumda kaydedilen kombin anahtarları (düğmenin dolu görünmesi için).
  final Set<String> _kaydedilenler = <String>{};

  /// Bu oturumda "giydim" denilen kombin anahtarları.
  final Set<String> _giyilenler = <String>{};

  @override
  void initState() {
    super.initState();
    _imza = _imzaHesapla();
    // Dil bilgisi Localizations'tan geliyor; initState sırasında inherited
    // widget okunamaz, bu yüzden ilk kareden sonra yükleniyor.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _yukle();
    });
    _planiYukle();
  }

  Future<void> _planiYukle() async {
    final planlar = await PlanliKombinDeposu().yukle();
    if (!mounted) return;
    setState(() => _bugunPlani = planlar[_bugun()]);
  }

  @override
  void didUpdateWidget(covariant BugunEkrani eski) {
    super.didUpdateWidget(eski);

    if (eski.planJetonu != widget.planJetonu) {
      _planiYukle();
    }

    // Sepet temizlendi ya da bir parça sepetten çıkarıldı: iyimser "giydildi"
    // işaretleri bırakılır, durum yeniden gerçek veriden (geçmiş + sepet)
    // hesaplanır. Böylece yıkanan kombin tekrar "Giydim" görünür.
    if (eski.sepetJetonu != widget.sepetJetonu) {
      _giyilenler.clear();
    }

    final yeniImza = _imzaHesapla();
    final gunDegisti =
        _yuklenenGun.isNotEmpty && _yuklenenGun != _bugun();
    final sekmeyeGirildi = widget.isAktifSekme && !eski.isAktifSekme;

    if (yeniImza != _imza || (sekmeyeGirildi && gunDegisti)) {
      _imza = yeniImza;
      _yukle();
    }
  }

  String _bugun() => BugunFeedServisi.gunAnahtari(DateTime.now());

  /// Ucuz imza: her derlemede tam parmak izi hesaplamaya gerek yok.
  String _imzaHesapla() {
    var toplam = 0;
    for (final k in widget.gardirobum) {
      toplam = (toplam + k.id.hashCode + k.gorunenBaslik.length) & 0x7fffffff;
    }
    final dil = WidgetsBinding.instance.platformDispatcher.locale.languageCode;
    return '${widget.gardirobum.length}|$toplam|'
        '${widget.gunlukHava}|$dil';
  }

  Future<void> _yukle({bool zorla = false}) async {
    if (!mounted) return;

    final gun = _bugun();
    if (widget.gardirobum.isEmpty) {
      setState(() {
        _kombinler = const <BugunKombin>[];
        _yukleniyor = false;
        _yuklenenGun = gun;
      });
      return;
    }

    if (_kombinler.isEmpty) {
      setState(() => _yukleniyor = true);
    }

    final dil = Localizations.localeOf(context).languageCode;
    final sonuc = await (widget.feedServisi ?? BugunFeedServisi()).getir(
      dolap: widget.gardirobum,
      hava: widget.gunlukHava,
      dil: dil,
      zorla: zorla,
    );

    if (!mounted) return;
    setState(() {
      _kombinler = sonuc.kombinler;
      _yukleniyor = false;
      _yuklenenGun = gun;
    });

    if (sonuc.kombinler.isNotEmpty) {
      AnalyticsServisi().olay('today_feed_loaded', {
        'source': sonuc.kaynak.name,
        'count': sonuc.kombinler.length,
      });
    }
  }

  /// Dolaptaki id → kıyafet eşlemesi (silinen parçalar akıştan düşsün).
  Map<String, Kiyafet> get _indeks =>
      {for (final k in widget.gardirobum) k.id: k};

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;

    final indeks = _indeks;
    final gecerli =
        _kombinler.where((k) => k.parcalar(indeks).length >= 2).toList();
    final kahraman = gecerli.isEmpty ? null : gecerli.first;
    final digerleri = gecerli.length > 1 ? gecerli.sublist(1) : <BugunKombin>[];

    // Aynı parça iki rafta birden görünmesin: raflar yukarıdan aşağıya
    // öncelikli, üstteki rafta duran parça alttakilerde tekrarlanmaz.
    final giyilmedi = AkilliRaflar.ikiHaftadirGiymedikler(widget.gardirobum);
    final giyilmediIdler = giyilmedi.map((k) => k.id).toSet();

    final yeniler = AkilliRaflar.yeniEklenenler(widget.gardirobum)
        .where((k) => !giyilmediIdler.contains(k.id))
        .toList();
    final yenilerIdler = giyilmediIdler..addAll(yeniler.map((k) => k.id));

    final havayaUygunTum = AkilliRaflar.havayaUygunlar(
      widget.gardirobum,
      widget.gunlukHava,
    );
    // Aynı parça iki rafta birden görünmesin. Küçük dolapta "bugüne uygun"
    // rafı tamamen boşalıyorsa raf gizlenir (üstteki rafta zaten görünüyor).
    final havayaUygun =
        havayaUygunTum.where((k) => !yenilerIdler.contains(k.id)).toList();

    return RefreshIndicator(
      color: widget.anaRenk,
      onRefresh: () => _yukle(zorla: true),
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        slivers: [
          SliverToBoxAdapter(child: _baslik(context, l10n)),
          SliverToBoxAdapter(
            child: _hizliAksiyonlar(context, l10n, colors),
          ),
          if (_bugunPlani != null)
            SliverToBoxAdapter(
              child: _planKarti(
                context,
                l10n,
                colors,
                _bugunPlani!,
                widget.gardirobum,
              ),
            ),
          SliverToBoxAdapter(
            child: _heroKart(context, l10n, colors, kahraman, indeks),
          ),
          if (digerleri.isNotEmpty)
            SliverToBoxAdapter(
              child: _seninIcin(context, l10n, colors, digerleri, indeks),
            ),
          if (giyilmedi.isNotEmpty)
            SliverToBoxAdapter(
              child: _raf(
                context,
                l10n,
                baslik: l10n.bugunGiyilmediRafi,
                parcalar: giyilmedi,
                altYazi: l10n.bugunRafIpucu,
              ),
            ),
          if (yeniler.isNotEmpty)
            SliverToBoxAdapter(
              child: _raf(
                context,
                l10n,
                baslik: l10n.bugunYeniRafi,
                parcalar: yeniler,
              ),
            ),
          if (havayaUygun.isNotEmpty)
            SliverToBoxAdapter(
              child: _raf(
                context,
                l10n,
                baslik: l10n.bugunHavaRafi,
                parcalar: havayaUygun,
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Üst bölüm
  // ---------------------------------------------------------------------------

  Widget _baslik(BuildContext context, AppLocalizations l10n) {
    final colors = Theme.of(context).colorScheme;
    final saat = DateTime.now().hour;
    final selam = saat < 12
        ? l10n.bugunGunaydin
        : saat < 18
            ? l10n.bugunIyiGunler
            : l10n.bugunIyiAksamlar;

    final hava = widget.gunlukHava.trim();
    final havaVar = hava.isNotEmpty && !widget.havaYukleniyor;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            selam,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
              color: colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            l10n.bugunBaslik,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: colors.onSurface,
            ),
          ),
          if (havaVar) ...[
            const SizedBox(height: 8),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: colors.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.wb_cloudy_outlined,
                      size: 14, color: colors.onSurfaceVariant),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      hava,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: colors.onSurfaceVariant,
                      ),
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

  Widget _hizliAksiyonlar(
    BuildContext context,
    AppLocalizations l10n,
    ColorScheme colors,
  ) {
    // Tek ızgara: 4 hızlı işlem + 2 araç (günlük, seyahat). Daha önce araçlar
    // sayfanın en altında ayrı bir kart ikilisiydi; artık aynı dil.
    final aksiyonlar = <_HizliAksiyon>[
      _HizliAksiyon(
        ikon: Icons.add_photo_alternate_outlined,
        etiket: l10n.bugunHizliFotograf,
        renk: colors.primary,
        onTap: () => widget.onFotografEkle(),
      ),
      _HizliAksiyon(
        ikon: Icons.casino_outlined,
        etiket: l10n.bugunHizliKombin,
        renk: colors.primary,
        onTap: () => widget.onSekmeSec(3),
      ),
      _HizliAksiyon(
        ikon: Icons.auto_awesome_rounded,
        etiket: l10n.bugunHizliStilist,
        renk: colors.primary,
        onTap: widget.onStilistAc,
      ),
      _HizliAksiyon(
        ikon: Icons.calendar_month_outlined,
        etiket: l10n.bugunHizliPlan,
        renk: colors.primary,
        onTap: () => widget.onSekmeSec(2),
      ),
      if (widget.onStilGunluguAc != null)
        _HizliAksiyon(
          ikon: Icons.auto_stories_rounded,
          etiket: l10n.stilGunluguBaslik,
          renk: colors.primary,
          onTap: widget.onStilGunluguAc!,
        ),
      if (widget.onSeyahatAc != null)
        _HizliAksiyon(
          ikon: Icons.luggage_rounded,
          etiket: l10n.seyahatBaslik,
          renk: colors.primary,
          onTap: widget.onSeyahatAc!,
        ),
    ];

    const sutun = 3;
    final satirlar = <List<_HizliAksiyon>>[];
    for (var i = 0; i < aksiyonlar.length; i += sutun) {
      satirlar.add(
        aksiyonlar.sublist(
          i,
          i + sutun > aksiyonlar.length ? aksiyonlar.length : i + sutun,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        children: [
          for (var s = 0; s < satirlar.length; s++) ...[
            if (s > 0) const SizedBox(height: 8),
            Row(
              children: [
                for (var i = 0; i < sutun; i++) ...[
                  if (i > 0) const SizedBox(width: 8),
                  Expanded(
                    child: i < satirlar[s].length
                        ? _aksiyonKutusu(context, satirlar[s][i])
                        : const SizedBox.shrink(),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }

  /// Takvimde bugüne atanmış kombin kartı.
  Widget _planKarti(
    BuildContext context,
    AppLocalizations l10n,
    ColorScheme colors,
    PlanliKombin plan,
    List<Kiyafet> gardirobum,
  ) {
    final indeks = <String, Kiyafet>{
      for (final k in gardirobum) k.gorunenBaslik.trim().toLowerCase(): k,
    };
    final parcalar = plan.parcalar
        .map((ad) => indeks[ad.trim().toLowerCase()])
        .whereType<Kiyafet>()
        .take(5)
        .toList();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
      child: Material(
        color: colors.surfaceContainerHighest.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(18),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: widget.onStilGunluguAc,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        turkceBuyukHarf(l10n.planBugun),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        plan.baslik,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.3,
                          color: colors.onSurface,
                        ),
                      ),
                      if (parcalar.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 54,
                          child: Row(
                            children: [
                              for (final parca in parcalar)
                                Padding(
                                  padding: const EdgeInsets.only(right: 6),
                                  child: SizedBox(
                                    width: 42,
                                    child: _planParcaGorseli(parca, colors),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_month_rounded,
                            size: 13,
                            color: colors.onSurfaceVariant,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            l10n.planTakvimdenDegistir,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: colors.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _planParcaGorseli(Kiyafet kiyafet, ColorScheme colors) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        color: colors.surface,
        child: Image.memory(
          kiyafet.resimBytes,
          fit: BoxFit.contain,
          gaplessPlayback: true,
        ),
      ),
    );
  }

  Widget _aksiyonKutusu(BuildContext context, _HizliAksiyon aksiyon) {
    final colors = Theme.of(context).colorScheme;
    return Material(
      color: colors.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: colors.outlineVariant),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          HapticFeedback.lightImpact();
          aksiyon.onTap();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          child: Column(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: colors.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(aksiyon.ikon, size: 20, color: aksiyon.renk),
              ),
              const SizedBox(height: 8),
              Text(
                aksiyon.etiket,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  height: 1.15,
                  fontWeight: FontWeight.w700,
                  color: colors.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Bugünün kombini
  // ---------------------------------------------------------------------------

  /// Bugünün kombin kartını PNG'ye çevirip sistem paylaşım sayfasını açar.
  Future<void> _kombiniPaylas() async {
    if (_paylasiliyor) return;
    final l10n = AppLocalizations.of(context)!;

    setState(() => _paylasiliyor = true);

    try {
      final sinir = _paylasKey.currentContext?.findRenderObject();
      if (sinir is! RenderRepaintBoundary) return;

      final gorsel = await sinir.toImage(pixelRatio: 3);
      final veri = await gorsel.toByteData(format: ui.ImageByteFormat.png);
      if (veri == null) return;

      final klasor = await getTemporaryDirectory();
      final dosya = File(
        '${klasor.path}/fitcheck-kombin-'
        '${DateTime.now().millisecondsSinceEpoch}.png',
      );
      await dosya.writeAsBytes(veri.buffer.asUint8List(), flush: true);

      if (!mounted) return;

      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(dosya.path, mimeType: 'image/png')],
          text: l10n.bugunPaylasMetni,
          subject: l10n.bugunBugununKombini,
          sharePositionOrigin:
              sinir.localToGlobal(Offset.zero) & sinir.size,
        ),
      );
    } catch (e) {
      debugPrint('Kombin paylaşılamadı: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.bugunPaylasHata)),
      );
    } finally {
      if (mounted) setState(() => _paylasiliyor = false);
    }
  }

  Widget _heroKart(
    BuildContext context,
    AppLocalizations l10n,
    ColorScheme colors,
    BugunKombin? kombin,
    Map<String, Kiyafet> indeks,
  ) {
    return RepaintBoundary(
      key: _paylasKey,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
        child: Container(
          padding: const EdgeInsets.all(16),
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
            border: Border.all(
              color: colors.outlineVariant.withValues(alpha: 0.35),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.wb_sunny_outlined,
                      size: 16, color: colors.onPrimaryContainer),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      l10n.bugunBugununKombini,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.4,
                        color: colors.onPrimaryContainer,
                      ),
                    ),
                  ),
                  BilgiButonu(
                    baslik: l10n.bugunBugununKombini,
                    aciklama: l10n.bilgiBugunKombini,
                    ikon: Icons.info_outline_rounded,
                    renk: colors.onPrimaryContainer.withValues(alpha: 0.75),
                  ),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    tooltip: l10n.bugunPaylas,
                    onPressed:
                        (kombin == null || _paylasiliyor) ? null : _kombiniPaylas,
                    icon: _paylasiliyor
                        ? SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: colors.onPrimaryContainer,
                            ),
                          )
                        : Icon(Icons.ios_share_rounded,
                            size: 19, color: colors.onPrimaryContainer),
                  ),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    tooltip: l10n.bugunYenile,
                    onPressed: _yukleniyor ? null : () => _yukle(zorla: true),
                    icon: _yukleniyor
                        ? SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: colors.onPrimaryContainer,
                            ),
                          )
                        : Icon(Icons.refresh_rounded,
                            size: 20, color: colors.onPrimaryContainer),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              if (_yukleniyor && kombin == null)
                _iskelet(context, colors)
              else if (kombin == null)
                _bosDurum(context, l10n, colors)
              else
                _kombinIcerik(context, l10n, colors, kombin, indeks, buyuk: true),
            ],
          ),
        ),
      ),
    );
  }

  Widget _iskelet(BuildContext context, ColorScheme colors) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 190),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                  strokeWidth: 2.5, color: colors.primary),
            ),
            const SizedBox(height: 12),
            Text(
              AppLocalizations.of(context)!.bugunHazirlaniyor,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bosDurum(
    BuildContext context,
    AppLocalizations l10n,
    ColorScheme colors,
  ) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 190),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.checkroom_outlined,
                size: 40, color: colors.onSurfaceVariant),
            const SizedBox(height: 10),
            Text(
              l10n.bugunBosBaslik,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w900,
                color: colors.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.bugunBosAciklama,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                height: 1.35,
                color: colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 14),
            FilledButton.icon(
              onPressed: () {
                HapticFeedback.mediumImpact();
                widget.onFotografEkle();
              },
              icon: const Icon(Icons.add_a_photo_outlined, size: 18),
              label: Text(l10n.bugunHizliFotograf),
            ),
          ],
        ),
      ),
    );
  }

  Widget _kombinIcerik(
    BuildContext context,
    AppLocalizations l10n,
    ColorScheme colors,
    BugunKombin kombin,
    Map<String, Kiyafet> indeks, {
    bool buyuk = false,
  }) {
    final parcalar = kombin.parcalar(indeks);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: buyuk ? 96 : 76,
          child: Row(
            children: [
              for (final parca in parcalar.take(4)) ...[
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: colors.surface.withValues(alpha: 0.65),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Image.memory(
                        parca.resimBytes,
                        fit: BoxFit.contain,
                        filterQuality: FilterQuality.medium,
                        gaplessPlayback: true,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          kombin.baslik,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: buyuk ? 17 : 14,
            fontWeight: FontWeight.w900,
            color: colors.onSurface,
          ),
        ),
        if (kombin.aciklama.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            kombin.aciklama,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              height: 1.3,
              color: colors.onSurfaceVariant,
            ),
          ),
        ],
        if (buyuk) ...[
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _giydimButonu(l10n, kombin, parcalar),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _kaydetButonu(l10n, kombin, parcalar),
              ),
            ],
          ),
        ],
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // "Senin için" akışı
  // ---------------------------------------------------------------------------

  Widget _seninIcin(
    BuildContext context,
    AppLocalizations l10n,
    ColorScheme colors,
    List<BugunKombin> kombinler,
    Map<String, Kiyafet> indeks,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _bolumBasligi(context, l10n.bugunSeninIcin),
        SizedBox(
          height: 250,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: kombinler.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, i) {
              final kombin = kombinler[i];
              final parcalar = kombin.parcalar(indeks);
              return SizedBox(
                width: 172,
                child: Material(
                  color: colors.surfaceContainerHighest.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(24),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(24),
                    onTap: () =>
                        _detayPenceresi(context, l10n, kombin, parcalar),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: [
                              for (final parca in parcalar.take(4))
                                Container(
                                  width: 66,
                                  height: 66,
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color:
                                        colors.surface.withValues(alpha: 0.7),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Image.memory(
                                    parca.resimBytes,
                                    fit: BoxFit.contain,
                                    filterQuality: FilterQuality.medium,
                                    gaplessPlayback: true,
                                  ),
                                ),
                            ],
                          ),
                          const Spacer(),
                          Text(
                            kombin.baslik,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              height: 1.2,
                              fontWeight: FontWeight.w800,
                              color: colors.onSurface,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '${parcalar.length}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: colors.onSurfaceVariant,
                                  ),
                                ),
                              ),
                              Icon(Icons.chevron_right_rounded,
                                  size: 18, color: colors.onSurfaceVariant),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _detayPenceresi(
    BuildContext context,
    AppLocalizations l10n,
    BugunKombin kombin,
    List<Kiyafet> parcalar,
  ) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) {
        final colors = Theme.of(sheetContext).colorScheme;
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  kombin.baslik,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: colors.onSurface,
                  ),
                ),
                if (kombin.aciklama.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    kombin.aciklama,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.35,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    for (final parca in parcalar)
                      SizedBox(
                        width: 88,
                        child: Column(
                          children: [
                            Container(
                              width: 88,
                              height: 88,
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: colors.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Image.memory(
                                parca.resimBytes,
                                fit: BoxFit.contain,
                                filterQuality: FilterQuality.medium,
                                gaplessPlayback: true,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              parca.gorunenBaslik,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 10,
                                color: colors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () {
                          Navigator.of(sheetContext).pop();
                          _giydim(kombin, parcalar);
                        },
                        icon: const Icon(Icons.check_rounded, size: 18),
                        label: Text(l10n.bugunGiydim),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.of(sheetContext).pop();
                          _kaydet(kombin, parcalar);
                        },
                        icon: const Icon(Icons.bookmark_add_outlined, size: 18),
                        label: Text(l10n.bugunKaydet),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Raflar
  // ---------------------------------------------------------------------------

  /// Raftaki bir parçaya dokununca hızlı aksiyonlar.
  ///
  /// "Bugün giydim" parçayı sepete taşır (model: giyildiOlarakIsaretle), böylece
  /// "2 haftadır giymediklerin" rafından düşer.
  Future<void> _parcaMenusu(
    BuildContext context,
    AppLocalizations l10n,
    Kiyafet parca,
  ) async {
    final colors = Theme.of(context).colorScheme;

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: colors.surfaceContainerHigh,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 6),
                child: Text(
                  parca.gorunenBaslik,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: colors.onSurface,
                  ),
                ),
              ),
              if (widget.onKiyafetGiyildi != null)
                ListTile(
                  leading: Icon(
                    Icons.check_circle_outline_rounded,
                    color: colors.primary,
                  ),
                  title: Text(l10n.bugunParcaGiydim),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    widget.onKiyafetGiyildi!.call(parca);
                  },
                ),
              if (widget.onKombinIstegi != null)
                ListTile(
                  leading: Icon(
                    Icons.auto_awesome_rounded,
                    color: colors.primary,
                  ),
                  title: Text(l10n.bugunParcaKombin),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    widget.onKombinIstegi!(parca);
                  },
                ),
              ListTile(
                leading: Icon(Icons.checkroom_rounded, color: colors.primary),
                title: Text(l10n.bugunParcaDolapta),
                onTap: () {
                  Navigator.pop(sheetContext);
                  widget.onSekmeSec(1);
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Widget _raf(
    BuildContext context,
    AppLocalizations l10n, {
    required String baslik,
    required List<Kiyafet> parcalar,
    String? altYazi,
  }) {
    if (parcalar.isEmpty) return const SizedBox.shrink();
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _bolumBasligi(context, baslik, altYazi: altYazi),
        SizedBox(
          height: 106,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: parcalar.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, i) {
              final parca = parcalar[i];
              return SizedBox(
                width: 82,
                child: GestureDetector(
                  onTap: () => _parcaMenusu(context, l10n, parca),
                  child: Column(
                    children: [
                      Container(
                        width: 82,
                        height: 82,
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color:
                              colors.surfaceContainerHighest.withValues(alpha: 0.55),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Image.memory(
                          parca.resimBytes,
                          fit: BoxFit.contain,
                          filterQuality: FilterQuality.medium,
                          gaplessPlayback: true,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        parca.gorunenBaslik,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 10,
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _bolumBasligi(BuildContext context, String metin, {String? altYazi}) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            metin,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.4,
              color: colors.onSurface,
            ),
          ),
          if (altYazi != null) ...[
            const SizedBox(height: 2),
            Text(
              altYazi,
              style: TextStyle(
                fontSize: 11,
                color: colors.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Aksiyonlar
  // ---------------------------------------------------------------------------

  /// "Kaydet" düğmesi: kombin kaydedildiyse **dolu** (tonal) ve "Kaydedildi"
  /// yazır; kaydedilmediyse kontur (outlined) görünür.
  Widget _kaydetButonu(
    AppLocalizations l10n,
    BugunKombin kombin,
    List<Kiyafet> parcalar,
  ) {
    final kaydedildi = _kaydedildiMi(kombin, parcalar);

    if (kaydedildi) {
      return FilledButton.tonalIcon(
        onPressed: null,
        icon: const Icon(Icons.bookmark_rounded, size: 18),
        label: Text(l10n.bugunKaydedildi),
      );
    }

    return OutlinedButton.icon(
      onPressed: () => _kaydet(kombin, parcalar),
      icon: const Icon(Icons.bookmark_add_outlined, size: 18),
      label: Text(l10n.bugunKaydet),
    );
  }

  /// Kombin favorilere kaydedilmiş mi?
  ///
  /// Hem bu oturumda kaydedilenler hem de daha önce kaydedilmiş favoriler
  /// (parça başlıkları eşleşir) kontrol edilir.
  bool _kaydedildiMi(BugunKombin kombin, List<Kiyafet> parcalar) {
    if (_kaydedilenler.contains(kombin.anahtar)) return true;

    final hedef = parcalar
        .map((k) => k.gorunenBaslik.trim().toLowerCase())
        .toList()
      ..sort();
    if (hedef.isEmpty) return false;

    for (final favori in widget.favoriKombinler) {
      final mevcut = favori.parcalar
          .map((p) => p.trim().toLowerCase())
          .toList()
        ..sort();
      if (mevcut.length != hedef.length) continue;
      var ayni = true;
      for (var i = 0; i < hedef.length; i++) {
        if (mevcut[i] != hedef[i]) {
          ayni = false;
          break;
        }
      }
      if (ayni) return true;
    }
    return false;
  }

  /// "Giydim" düğmesi: kombin bugün giyildiyse **dolu** (yeşil tonlu) ve
  /// "Giydildi" yazar; giyilmediyse normal dolu düğme görünür.
  Widget _giydimButonu(
    AppLocalizations l10n,
    BugunKombin kombin,
    List<Kiyafet> parcalar,
  ) {
    if (_giyildiMi(kombin, parcalar)) {
      final koyuMu = Theme.of(context).brightness == Brightness.dark;
      return FilledButton.icon(
        onPressed: null,
        icon: const Icon(Icons.check_rounded, size: 18),
        label: Text(l10n.bugunGiydildi),
        style: FilledButton.styleFrom(
          disabledBackgroundColor:
              AppAccents.success.withValues(alpha: koyuMu ? 0.24 : 0.14),
          disabledForegroundColor:
              koyuMu ? AppAccents.success : AppAccents.successDark,
        ),
      );
    }

    return FilledButton.icon(
      onPressed: () => _giydim(kombin, parcalar),
      icon: const Icon(Icons.check_rounded, size: 18),
      label: Text(l10n.bugunGiydim),
    );
  }

  /// Kombin bugün giyildi mi?
  ///
  /// Üç kaynak birlikte değerlendirilir:
  /// 1. Bu oturumda "Giydim"e basıldıysa (anında geri bildirim),
  /// 2. Geçmişte bugünün tarihiyle kayıtlıysa (başlık veya parça eşleşmesi),
  /// 3. Parçalar hâlâ çamaşır sepetindeyse.
  ///
  /// Sepet temizlendiğinde parçalar "yıkanmış" sayılır ve düğme yeniden
  /// "Giydim" olur; giyilme geçmişi/rapor ise olduğu gibi kalır.
  bool _giyildiMi(BugunKombin kombin, List<Kiyafet> parcalar) {
    if (_giyilenler.contains(kombin.anahtar)) return true;
    if (!_bugunGiyildi(kombin, parcalar)) return false;

    final cozulenler = _kombinParcalari(kombin);
    if (cozulenler.isEmpty) return true; // parçalar silinmiş: geçmişe güven
    return cozulenler.any((k) => k.sepetteMi);
  }

  /// Kombinin parçaları (dolapta bulunanlar).
  List<Kiyafet> _kombinParcalari(BugunKombin kombin) {
    final idler = kombin.kiyafetIdleri.toSet();
    return widget.gardirobum.where((k) => idler.contains(k.id)).toList();
  }

  /// Geçmişte bugünün tarihiyle bu kombine ait bir kayıt var mı?
  bool _bugunGiyildi(BugunKombin kombin, List<Kiyafet> parcalar) {
    final bugun = DateTime.now().toIso8601String().substring(0, 10);
    final hedefBaslik = kombin.baslik.trim().toLowerCase();
    final hedefParcalar = parcalar
        .map((k) => k.gorunenBaslik.trim().toLowerCase())
        .toList()
      ..sort();

    for (final kayit in widget.gecmisKombinler) {
      if ((kayit['tarih'] ?? '').trim() != bugun) continue;

      final baslik = (kayit['baslik'] ?? '').trim().toLowerCase();
      if (baslik.isNotEmpty && baslik == hedefBaslik) return true;

      final detay = (kayit['detay'] ?? '').trim();
      if (detay.isEmpty || hedefParcalar.isEmpty) continue;

      final kayitParcalar = detay
          .split(',')
          .map((e) => e.trim().toLowerCase())
          .where((e) => e.isNotEmpty)
          .toList()
        ..sort();
      if (kayitParcalar.length != hedefParcalar.length) continue;

      var ayni = true;
      for (var i = 0; i < hedefParcalar.length; i++) {
        if (kayitParcalar[i] != hedefParcalar[i]) {
          ayni = false;
          break;
        }
      }
      if (ayni) return true;
    }
    return false;
  }

  void _giydim(BugunKombin kombin, List<Kiyafet> parcalar) {
    if (parcalar.isEmpty) return;
    HapticFeedback.mediumImpact();
    setState(() => _giyilenler.add(kombin.anahtar));
    widget.onGecmiseEkle(kombin.baslik, parcalar);
    AnalyticsServisi().olay('today_feed_worn', {'items': parcalar.length});
  }

  void _kaydet(BugunKombin kombin, List<Kiyafet> parcalar) {
    if (parcalar.isEmpty) return;
    HapticFeedback.lightImpact();

    // Not: uygulamada gerçek bir renk uyumu hesaplayıcısı yok; diğer ekranlar
    // da 70–99 arası tahmini puan üretiyor. Burada kombinin kendisinden türeyen
    // sabit bir değer kullanılıyor ki aynı kombin her açılışta aynı puanı
    // göstersin (rastgele her seferinde değişmesin).
    final puan = _uyumTahmini(kombin);

    // Düğme "dolu" görünsün diye kaydedildi bilgisi hemen işaretlenir.
    setState(() => _kaydedilenler.add(kombin.anahtar));

    widget.onFavoriEkle(
      FavoriKombin(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        baslik: kombin.baslik,
        parcalar: parcalar.map((k) => k.gorunenBaslik).toList(),
        tuyo: kombin.aciklama,
        renkUyumuPuani: puan,
      ),
    );
    AnalyticsServisi().olay('today_feed_saved', {'items': parcalar.length});
  }

  int _uyumTahmini(BugunKombin kombin) {
    var hash = 0;
    for (final birim in kombin.anahtar.codeUnits) {
      hash = (hash * 31 + birim) & 0x7fffffff;
    }
    return 85 + (hash % 13); // 85–97
  }
}

class _HizliAksiyon {
  final IconData ikon;
  final String etiket;
  final Color renk;
  final VoidCallback onTap;

  const _HizliAksiyon({
    required this.ikon,
    required this.etiket,
    required this.renk,
    required this.onTap,
  });
}
