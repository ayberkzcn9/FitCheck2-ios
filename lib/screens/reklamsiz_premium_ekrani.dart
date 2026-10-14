import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../services/satin_alma_servisi.dart';

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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final fiyat = _satinAlma.urun?.price;
    final hataMetni = _hataMetni(l10n);

    return Scaffold(
      appBar: AppBar(title: const Text('FitCheck Premium')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: colors.primaryContainer,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Icon(Icons.workspace_premium_rounded,
                size: 72, color: colors.onPrimaryContainer),
          ),
          const SizedBox(height: 24),
          Text(l10n.premiumBaslik,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                  )),
          const SizedBox(height: 10),
          Text(
            l10n.premiumAciklama,
            style: TextStyle(color: colors.onSurfaceVariant, height: 1.45),
          ),
          const SizedBox(height: 22),
          _OzellikSatiri(metin: l10n.premiumOzellikReklamsiz),
          _OzellikSatiri(metin: l10n.premiumOzellikAylik),
          _OzellikSatiri(metin: l10n.premiumOzellikMagaza),
          const SizedBox(height: 28),
          if (_satinAlma.premiumAktif)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.primaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                l10n.premiumAktifMesaji,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: colors.onPrimaryContainer,
                  fontWeight: FontWeight.w700,
                ),
              ),
            )
          else
            SizedBox(
              height: 54,
              child: FilledButton(
                onPressed: _satinAlma.yukleniyor ||
                        !_satinAlma.magazaHazir ||
                        _satinAlma.urun == null
                    ? null
                    : _satinAlma.satinAl,
                child: _satinAlma.yukleniyor
                    ? const CircularProgressIndicator()
                    : Text(fiyat == null
                        ? l10n.premiumAboneOl
                        : l10n.premiumAboneOlFiyatli(fiyat)),
              ),
            ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: _satinAlma.yukleniyor ||
                    _satinAlma.hazirlaniyor ||
                    !_satinAlma.magazaHazir
                ? null
                : _satinAlma.satinAlmalariGeriYukle,
            child: Text(l10n.premiumGeriYukle),
          ),
          if (hataMetni != null) ...[
            const SizedBox(height: 12),
            Text(hataMetni,
                textAlign: TextAlign.center,
                style: TextStyle(color: colors.error)),
          ] else if (!_satinAlma.hazirlaniyor && !_satinAlma.magazaHazir) ...[
            const SizedBox(height: 12),
            Text(l10n.premiumMagazaHazirDegil,
                textAlign: TextAlign.center,
                style: TextStyle(color: colors.onSurfaceVariant)),
          ] else if (!_satinAlma.hazirlaniyor &&
              _satinAlma.urun == null &&
              !_satinAlma.premiumAktif) ...[
            const SizedBox(height: 12),
            Text(l10n.premiumUrunBulunamadi,
                textAlign: TextAlign.center,
                style: TextStyle(color: colors.onSurfaceVariant)),
          ],
          // Mağazanın neden ürün döndürmediğini görünür kılar (ör. Play
          // Console'da etkin temel plan yok ya da ürün kimliği bulunamadı).
          if (!_satinAlma.hazirlaniyor && _satinAlma.tani != null) ...[
            const SizedBox(height: 10),
            Text(
              _satinAlma.tani!,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colors.onSurfaceVariant,
                fontSize: 11,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _OzellikSatiri extends StatelessWidget {
  const _OzellikSatiri({required this.metin});

  final String metin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(Icons.check_circle_rounded,
              size: 22, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 10),
          Text(metin, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
