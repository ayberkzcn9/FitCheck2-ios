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

  // Mağazadan gelen hata metinleri olduğu gibi gösterilir; servisin kendi
  // hata kodları ise yerelleştirilmiş mesaja çevrilir.
  String? _hataMetni(AppLocalizations l10n) {
    final hata = _satinAlma.hata;
    if (hata == null) return null;
    if (hata == SatinAlmaServisi.hataSatinAlmaBaslatilamadi) {
      return l10n.premiumSatinAlmaBaslatilamadi;
    }
    if (hata == SatinAlmaServisi.hataSatinAlmaBasarisiz) {
      return l10n.premiumSatinAlmaBasarisiz;
    }
    return hata;
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
    final satinAlinabilir =
        _urunVar && _satinAlma.magazaHazir && !mesgul && !_satinAlma.hazirlaniyor;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.premiumEkranBaslik)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        children: [
          _kahraman(l10n, colors),
          const SizedBox(height: AppSpacing.xxl),
          _ozellikler(l10n, colors),
          const SizedBox(height: AppSpacing.xxl),

          if (_satinAlma.premiumAktif)
            _aktifKarti(l10n, colors)
          else ...[
            if (_urunVar || _satinAlma.hazirlaniyor) ...[
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
                  fontSize: 12.5,
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
                    !_satinAlma.magazaHazir
                ? null
                : _satinAlma.satinAlmalariGeriYukle,
            child: Text(l10n.premiumGeriYukle),
          ),

          if (hataMetni != null) ...[
            const SizedBox(height: AppSpacing.md),
            Text(hataMetni,
                textAlign: TextAlign.center,
                style: TextStyle(color: colors.error)),
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
          if (!_satinAlma.hazirlaniyor && _satinAlma.tani != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              _satinAlma.tani!,
              textAlign: TextAlign.center,
              style: TextStyle(color: colors.onSurfaceVariant, fontSize: 12),
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
        color: colors.primaryContainer,
        borderRadius: AppRadius.dialogRadius,
      ),
      child: Column(
        children: [
          Icon(Icons.workspace_premium_rounded,
              size: 64, color: colors.onPrimaryContainer),
          const SizedBox(height: AppSpacing.md),
          if (_satinAlma.denemeSunuluyor)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: AppAccents.success,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                l10n.premiumDenemeRozeti(SatinAlmaServisi.denemeGunSayisi),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          const SizedBox(height: AppSpacing.md),
          Text(
            l10n.premiumBaslik,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.4,
              color: colors.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l10n.premiumAciklama,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              height: 1.4,
              color: colors.onPrimaryContainer.withValues(alpha: 0.8),
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
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: colors.onSurface,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        _OzellikSatiri(
          ikon: Icons.auto_awesome_rounded,
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
        color: colors.primaryContainer,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Text(
        l10n.premiumAktifMesaji,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: colors.onPrimaryContainer,
          fontWeight: FontWeight.w700,
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
          color: secili ? colors.primaryContainer : colors.surfaceContainerHigh,
          borderRadius: AppRadius.lgRadius,
          border: Border.all(
            color: secili ? colors.primary : colors.outlineVariant,
            width: secili ? 2 : 1,
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
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      if (enAvantajli)
                        _rozet(
                          metin: l10n.premiumEnAvantajli,
                          arka: AppAccents.success,
                          onArka: Colors.white,
                        ),
                      if (denemeVar)
                        _rozet(
                          metin: l10n.premiumDenemeRozeti(
                              SatinAlmaServisi.denemeGunSayisi),
                          arka: AppAccents.successDark,
                          onArka: Colors.white,
                        ),
                    ],
                  ),
                  if (tasarrufYuzde > 0) ...[
                    const SizedBox(height: 4),
                    Text(
                      l10n.premiumTasarrufYuzde(tasarrufYuzde),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
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
                fontSize: 15,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _rozet({
    required String metin,
    required Color arka,
    required Color onArka,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: arka,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        metin,
        style: TextStyle(
          color: onArka,
          fontSize: 10.5,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.4,
        ),
      ),
    );
  }

  Widget _aboneOlDugmesi(
    AppLocalizations l10n,
    ColorScheme colors, {
    required bool satinAlinabilir,
  }) {
    return SizedBox(
      height: 56,
      width: double.infinity,
      child: FilledButton(
        onPressed: satinAlinabilir ? _satinAlma.satinAl : null,
        child: _satinAlma.yukleniyor
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2.4),
              )
            : Text(
                l10n.premiumAboneOlFiyatli(_seciliFiyat),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
      ),
    );
  }

  Widget _altBilgi(AppLocalizations l10n, ColorScheme colors) {
    final stil = TextStyle(
      fontSize: 12,
      height: 1.4,
      color: colors.onSurfaceVariant,
    );
    return Column(
      children: [
        Text(l10n.premiumYenilemeNotu, textAlign: TextAlign.center, style: stil),
        const SizedBox(height: 6),
        Text(l10n.premiumOzellikMagaza, textAlign: TextAlign.center, style: stil),
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
              style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
