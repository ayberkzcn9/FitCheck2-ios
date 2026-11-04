import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../services/satin_alma_servisi.dart';
import '../../theme/design_tokens.dart';

/// Premium paywall'ı.
///
/// Odak: "reklamsız" değil, **sınırsızlık**. Kullanıcı premium ile ne
/// kazandığını (sınırsız kombin, sınırsız AI stil analizi, sınırsız gardırop)
/// net biçimde görür; aylık ve yıllık plan yan yana sunulur, ücretsiz deneme
/// varsa rozetle duyurulur.
class ReklamsizPremiumEkrani extends StatefulWidget {
  const ReklamsizPremiumEkrani({super.key});

  @override
  State<ReklamsizPremiumEkrani> createState() => _ReklamsizPremiumEkraniState();
}

class _ReklamsizPremiumEkraniState extends State<ReklamsizPremiumEkrani> {
  late final SatinAlmaServisi _satinAlma;

  @override
  void initState() {
    super.initState();
    // Servis uygulama genelinde tek örnek; ekran kapanınca satın alma
    // dinleyicisi açık kalır.
    _satinAlma = SatinAlmaServisi.ornek;
    _satinAlma.addListener(_yenile);
    _satinAlma.baslat();
  }

  void _yenile() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _satinAlma.removeListener(_yenile);
    super.dispose();
  }

  // Servisin bilinen hata kodları yerelleştirilmiş mesaja çevrilir. Mağazanın
  // ham hata metni yalnızca geliştirme derlemesinde gösterilir; yayında genel
  // bir mesaj verilir.
  String? _hataMetni(AppLocalizations l10n) {
    final hata = _satinAlma.hata;
    if (hata == null) return null;
    if (hata == SatinAlmaServisi.hataSatinAlmaBaslatilamadi) {
      return l10n.premiumSatinAlmaBaslatilamadi;
    }
    if (hata == SatinAlmaServisi.hataSatinAlmaBasarisiz) {
      return l10n.premiumSatinAlmaBasarisiz;
    }
    return kDebugMode ? hata : l10n.premiumSatinAlmaBasarisiz;
  }

  bool get _urunVar => _satinAlma.aylikVar || _satinAlma.yillikVar;

  String get _seciliFiyat => _satinAlma.seciliPlan == PremiumPlan.yillik
      ? _satinAlma.yillikFiyat
      : _satinAlma.aylikFiyat;

  bool get _seciliPlandaDeneme =>
      _satinAlma.planDenemesiVar(_satinAlma.seciliPlan);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;

    final hataMetni = _hataMetni(l10n);
    final mesgul = _satinAlma.yukleniyor;
    final satinAlinabilir = _urunVar &&
        _satinAlma.magazaHazir &&
        SatinAlmaServisi.satinAlmaDogrulanabilir &&
        !mesgul &&
        !_satinAlma.hazirlaniyor;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.premiumEkranBaslik)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.xl, AppSpacing.md, AppSpacing.xl, AppSpacing.xxxl),
        children: [
          _kahraman(l10n, colors),
          const SizedBox(height: AppSpacing.xxl),
          _ozellikler(l10n, colors),
          const SizedBox(height: AppSpacing.xxl),

          if (_satinAlma.premiumAktif)
            _aktifKarti(l10n, colors)
          else ...[
            if (_urunVar) ...[
              _planKartlari(l10n, colors),
              const SizedBox(height: AppSpacing.xl),
            ],
            _aboneOlDugmesi(l10n, colors, satinAlinabilir: satinAlinabilir),
            if (_seciliPlandaDeneme) ...[
              const SizedBox(height: 10),
              Text(
                l10n.premiumDenemeSonrasi(_seciliFiyat),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: AppText.sizeCaption,
                  color: colors.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],

          const SizedBox(height: AppSpacing.sm),
          TextButton(
            onPressed: _satinAlma.yukleniyor ||
                    _satinAlma.hazirlaniyor ||
                    !_satinAlma.magazaHazir ||
                    !SatinAlmaServisi.satinAlmaDogrulanabilir
                ? null
                : _satinAlma.satinAlmalariGeriYukle,
            child: Text(l10n.premiumGeriYukle),
          ),

          if (hataMetni != null) ...[
            const SizedBox(height: AppSpacing.md),
            Text(hataMetni,
                textAlign: TextAlign.center,
                style: TextStyle(color: colors.error)),
          ] else if (!SatinAlmaServisi.satinAlmaDogrulanabilir) ...[
            const SizedBox(height: AppSpacing.md),
            Text(l10n.premiumSatinAlmaDogrulamaHazirDegil,
                textAlign: TextAlign.center,
                style: TextStyle(color: colors.onSurfaceVariant)),
          ] else if (!_satinAlma.hazirlaniyor && !_satinAlma.magazaHazir) ...[
            const SizedBox(height: AppSpacing.md),
            Text(l10n.premiumMagazaHazirDegil,
                textAlign: TextAlign.center,
                style: TextStyle(color: colors.onSurfaceVariant)),
          ] else if (!_satinAlma.hazirlaniyor &&
              !_urunVar &&
              !_satinAlma.premiumAktif) ...[
            const SizedBox(height: AppSpacing.md),
            Text(l10n.premiumUrunBulunamadi,
                textAlign: TextAlign.center,
                style: TextStyle(color: colors.onSurfaceVariant)),
          ],

          // Mağazanın neden ürün döndürmediğini görünür kılar (ör. Play
          // Console'da etkin temel plan yok ya da ürün kimliği bulunamadı).
          // Yalnızca geliştirme derlemesinde gösterilir; yayında kullanıcıya
          // teknik metin gösterilmez.
          if (kDebugMode &&
              !_satinAlma.hazirlaniyor &&
              _satinAlma.tani != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              _satinAlma.tani!,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: colors.onSurfaceVariant,
                  fontSize: AppText.sizeCaption),
            ),
          ],

          const SizedBox(height: AppSpacing.lg),
          _altBilgi(l10n, colors),
        ],
      ),
    );
  }

  // --- BÖLÜMLER ---

  Widget _kahraman(AppLocalizations l10n, ColorScheme colors) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: AppRadius.dialogRadius,
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Column(
        children: [
          Icon(Icons.workspace_premium_rounded,
              size: 48, color: colors.primary),
          const SizedBox(height: AppSpacing.md),
          if (_satinAlma.denemeSunuluyor)
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md, vertical: AppSpacing.xs),
              decoration: BoxDecoration(
                color: colors.primary,
                borderRadius: AppRadius.fullRadius,
              ),
              child: Text(
                l10n.premiumDenemeRozeti(SatinAlmaServisi.denemeGunSayisi),
                style: TextStyle(
                  color: colors.onPrimary,
                  fontSize: AppText.sizeCaption,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0,
                ),
              ),
            ),
          const SizedBox(height: AppSpacing.md),
          Text(
            l10n.premiumBaslik,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppText.sizeTitleLarge,
              fontWeight: FontWeight.w600,
              letterSpacing: 0,
              color: colors.onSurface,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l10n.premiumAciklama,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppText.sizeBodySmall,
              height: 1.4,
              color: colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _ozellikler(AppLocalizations l10n, ColorScheme colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.premiumOzelliklerBaslik,
          style: TextStyle(
            fontSize: AppText.sizeBodyLarge,
            fontWeight: FontWeight.w600,
            color: colors.onSurface,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        _OzellikSatiri(
          ikon: Icons.style_outlined,
          metin: l10n.premiumOzellikSinirsizKombin,
        ),
        _OzellikSatiri(
          ikon: Icons.insights_rounded,
          metin: l10n.premiumOzellikSinirsizAnaliz,
        ),
        _OzellikSatiri(
          ikon: Icons.checkroom_rounded,
          metin: l10n.premiumOzellikSinirsizGardirob,
        ),
        _OzellikSatiri(
          ikon: Icons.block_rounded,
          metin: l10n.premiumOzellikReklamsiz,
        ),
      ],
    );
  }

  Widget _aktifKarti(AppLocalizations l10n, ColorScheme colors) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Text(
        l10n.premiumAktifMesaji,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: colors.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _planKartlari(AppLocalizations l10n, ColorScheme colors) {
    final tasarruf = _satinAlma.yillikTasarrufYuzde;
    return Column(
      children: [
        if (_satinAlma.yillikVar)
          _planKarti(
            l10n: l10n,
            colors: colors,
            plan: PremiumPlan.yillik,
            ad: l10n.premiumPlanYillik,
            fiyat: _satinAlma.yillikFiyat,
            enAvantajli: true,
            tasarrufYuzde: tasarruf,
          ),
        if (_satinAlma.yillikVar && _satinAlma.aylikVar)
          const SizedBox(height: AppSpacing.md),
        if (_satinAlma.aylikVar)
          _planKarti(
            l10n: l10n,
            colors: colors,
            plan: PremiumPlan.aylik,
            ad: l10n.premiumPlanAylik,
            fiyat: _satinAlma.aylikFiyat,
            enAvantajli: false,
            tasarrufYuzde: 0,
          ),
      ],
    );
  }

  Widget _planKarti({
    required AppLocalizations l10n,
    required ColorScheme colors,
    required PremiumPlan plan,
    required String ad,
    required String fiyat,
    required bool enAvantajli,
    required int tasarrufYuzde,
  }) {
    final secili = _satinAlma.seciliPlan == plan;
    final denemeVar = _satinAlma.planDenemesiVar(plan);

    return InkWell(
      onTap: _satinAlma.yukleniyor ? null : () => _satinAlma.planSec(plan),
      borderRadius: AppRadius.lgRadius,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: colors.surfaceContainerLow,
          borderRadius: AppRadius.lgRadius,
          border: Border.all(
            color: secili ? colors.primary : colors.outlineVariant,
            width: secili ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              secili
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_off_rounded,
              size: 22,
              color: secili ? colors.primary : colors.onSurfaceVariant,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.xs,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        ad,
                        style: const TextStyle(
                          fontSize: AppText.sizeBody,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (enAvantajli)
                        _rozet(
                          metin: l10n.premiumEnAvantajli,
                        ),
                      if (denemeVar)
                        _rozet(
                          metin: l10n.premiumDenemeRozeti(
                              SatinAlmaServisi.denemeGunSayisi),
                        ),
                    ],
                  ),
                  if (tasarrufYuzde > 0) ...[
                    const SizedBox(height: 4),
                    Text(
                      l10n.premiumTasarrufYuzde(tasarrufYuzde),
                      style: const TextStyle(
                        fontSize: AppText.sizeSmall,
                        fontWeight: FontWeight.w600,
                        color: AppAccents.successDark,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              fiyat,
              style: const TextStyle(
                fontSize: AppText.sizeBody,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _rozet({
    required String metin,
  }) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        borderRadius: AppRadius.smRadius,
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Text(
        metin,
        style: TextStyle(
          color: colors.onSurfaceVariant,
          fontSize: AppText.sizeMicro,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
        ),
      ),
    );
  }

  Widget _aboneOlDugmesi(
    AppLocalizations l10n,
    ColorScheme colors, {
    required bool satinAlinabilir,
  }) {
    // Mağaza ürünü gelmeden varsayılan fiyat gösterilmez: o fiyat gerçek
    // Play fiyatından farklı olabilir. Mağaza hazırlanırken yükleme göstergesi
    // çıkar; açıklama altta ilgili mesajla verilir.
    final yukleniyor = _satinAlma.yukleniyor || _satinAlma.hazirlaniyor;
    return SizedBox(
      height: 56,
      width: double.infinity,
      child: FilledButton(
        onPressed: satinAlinabilir ? _satinAlma.satinAl : null,
        child: yukleniyor
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2.4),
              )
            : Text(
                _urunVar
                    ? l10n.premiumAboneOlFiyatli(_seciliFiyat)
                    : l10n.premiumAboneOl,
                style: const TextStyle(
                  fontSize: AppText.sizeBody,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Widget _altBilgi(AppLocalizations l10n, ColorScheme colors) {
    final stil = TextStyle(
      fontSize: AppText.sizeCaption,
      height: 1.4,
      color: colors.onSurfaceVariant,
    );
    return Column(
      children: [
        Text(l10n.premiumYenilemeNotu,
            textAlign: TextAlign.center, style: stil),
        const SizedBox(height: 6),
        Text(l10n.premiumOzellikMagaza,
            textAlign: TextAlign.center, style: stil),
      ],
    );
  }
}

class _OzellikSatiri extends StatelessWidget {
  const _OzellikSatiri({required this.ikon, required this.metin});

  final IconData ikon;
  final String metin;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: colors.surfaceContainerHighest,
              shape: BoxShape.circle,
            ),
            child: Icon(ikon, size: 18, color: colors.onSurface),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              metin,
              style: const TextStyle(
                  fontSize: AppText.sizeBodySmall, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
