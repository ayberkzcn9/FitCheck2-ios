// "Seyahat Modu" — kısa geziler için valiz planı.
//
// Dolaptan temiz parçalar seçilir; kapsül mantığı ile gün sayısı kadar
// kombin çıkar. Tamamen yerel çalışır (ağ yok, yapay zekâ yok).

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../l10n/app_localizations.dart';
import '../models/kiyafet.dart';
import '../services/valiz_planlayici.dart';
import '../theme/design_tokens.dart';

class SeyahatEkrani extends StatefulWidget {
  const SeyahatEkrani({
    super.key,
    required this.gardirobum,
  });

  final List<Kiyafet> gardirobum;

  @override
  State<SeyahatEkrani> createState() => _SeyahatEkraniState();
}

class _SeyahatEkraniState extends State<SeyahatEkrani> {
  int _gunSayisi = 3;
  SeyahatHava _hava = SeyahatHava.iliman;
  SeyahatAmac _amac = SeyahatAmac.gunluk;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;

    final plan = ValizPlanlayici.hesapla(
      gardirobum: widget.gardirobum,
      gunSayisi: _gunSayisi,
      hava: _hava,
      amac: _amac,
    );

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        title: Text(l10n.seyahatBaslik),
        backgroundColor: colors.surface,
        surfaceTintColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          _secimKartlari(context, l10n, colors),
          const SizedBox(height: 14),
          _planKarti(context, l10n, colors, plan),
          const SizedBox(height: 14),
          OutlinedButton.icon(
            onPressed: plan.bos ? null : () => _paylas(plan, l10n),
            icon: const Icon(Icons.ios_share_rounded, size: 18),
            label: Text(l10n.seyahatPaylas),
          ),
        ],
      ),
    );
  }

  Widget _secimKartlari(
    BuildContext context,
    AppLocalizations l10n,
    ColorScheme colors,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.seyahatGunSayisi,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: colors.onSurface,
                  ),
                ),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                onPressed: _gunSayisi > 1
                    ? () => setState(() => _gunSayisi--)
                    : null,
                icon: const Icon(Icons.remove_circle_outline_rounded),
              ),
              Text(
                '$_gunSayisi',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: colors.onSurface,
                ),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                onPressed: _gunSayisi < 30
                    ? () => setState(() => _gunSayisi++)
                    : null,
                icon: const Icon(Icons.add_circle_outline_rounded),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            l10n.seyahatHava,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: colors.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              _secim(
                l10n.seyahatHavaSicak,
                _hava == SeyahatHava.sicak,
                () => setState(() => _hava = SeyahatHava.sicak),
                colors,
              ),
              _secim(
                l10n.seyahatHavaIliman,
                _hava == SeyahatHava.iliman,
                () => setState(() => _hava = SeyahatHava.iliman),
                colors,
              ),
              _secim(
                l10n.seyahatHavaSoguk,
                _hava == SeyahatHava.soguk,
                () => setState(() => _hava = SeyahatHava.soguk),
                colors,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            l10n.seyahatAmac,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: colors.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              _secim(
                l10n.seyahatAmacGunluk,
                _amac == SeyahatAmac.gunluk,
                () => setState(() => _amac = SeyahatAmac.gunluk),
                colors,
              ),
              _secim(
                l10n.seyahatAmacIs,
                _amac == SeyahatAmac.isGezisi,
                () => setState(() => _amac = SeyahatAmac.isGezisi),
                colors,
              ),
              _secim(
                l10n.seyahatAmacOzel,
                _amac == SeyahatAmac.ozel,
                () => setState(() => _amac = SeyahatAmac.ozel),
                colors,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _secim(
    String etiket,
    bool secili,
    VoidCallback onTap,
    ColorScheme colors,
  ) {
    return ChoiceChip(
      label: Text(etiket),
      selected: secili,
      onSelected: (_) => onTap(),
      showCheckmark: false,
      selectedColor: colors.primaryContainer,
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: secili ? colors.onPrimaryContainer : colors.onSurfaceVariant,
      ),
    );
  }

  Widget _planKarti(
    BuildContext context,
    AppLocalizations l10n,
    ColorScheme colors,
    ValizPlani plan,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colors.primaryContainer.withValues(alpha: 0.7),
            colors.surfaceContainerHighest.withValues(alpha: 0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.seyahatPlanBaslik,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: colors.onPrimaryContainer,
                  ),
                ),
              ),
              Text(
                l10n.seyahatKombine('${plan.kombinSayisi}'),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: colors.onPrimaryContainer.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (plan.bos)
            Text(
              l10n.seyahatEksikUst,
              style: TextStyle(
                color: colors.onPrimaryContainer.withValues(alpha: 0.85),
              ),
            ),
          _grup(
            l10n.gardirobumKategoriUst,
            plan.ustler,
            colors,
          ),
          _grup(
            l10n.gardirobumKategoriAlt,
            plan.altlar,
            colors,
          ),
          _grup(
            l10n.seyahatDiger,
            plan.disGiyim,
            colors,
          ),
          _grup(
            l10n.gardirobumKategoriAyakkabi,
            plan.ayakkabilar,
            colors,
          ),
          if (plan.eksikler.isNotEmpty) ...[
            const SizedBox(height: 8),
            for (final eksik in plan.eksikler)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      size: 15,
                      color: AppAccents.warning,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        _eksikMetni(l10n, eksik, plan.gunSayisi),
                        style: TextStyle(
                          fontSize: 12,
                          color: colors.onPrimaryContainer
                              .withValues(alpha: 0.9),
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

  String _eksikMetni(
    AppLocalizations l10n,
    String eksik,
    int gunSayisi,
  ) {
    switch (eksik) {
      case 'ust':
        return l10n.seyahatEksikUst;
      case 'alt':
        return l10n.seyahatEksikAlt;
      case 'ayakkabi':
        return l10n.seyahatEksikAyakkabi;
      case 'kombin':
        return l10n.seyahatEksikKombin('$gunSayisi');
      default:
        return eksik;
    }
  }

  Widget _grup(String baslik, List<Kiyafet> parcalar, ColorScheme colors) {
    if (parcalar.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            baslik,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: colors.onPrimaryContainer.withValues(alpha: 0.75),
            ),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final parca in parcalar)
                SizedBox(
                  width: 76,
                  child: Column(
                    children: [
                      Container(
                        width: 76,
                        height: 54,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: colors.surface.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Image.memory(
                          parca.resimBytes,
                          fit: BoxFit.contain,
                          filterQuality: FilterQuality.medium,
                          gaplessPlayback: true,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        parca.gorunenBaslik,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 10,
                          height: 1.15,
                          color: colors.onPrimaryContainer
                              .withValues(alpha: 0.85),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _paylas(ValizPlani plan, AppLocalizations l10n) async {
    final satirlar = <String>[];
    void ekle(String baslik, List<Kiyafet> parcalar) {
      if (parcalar.isEmpty) return;
      satirlar.add(
        '$baslik: ${parcalar.map((p) => p.gorunenBaslik).join(', ')}',
      );
    }

    ekle(l10n.gardirobumKategoriUst, plan.ustler);
    ekle(l10n.gardirobumKategoriAlt, plan.altlar);
    ekle(l10n.seyahatDiger, plan.disGiyim);
    ekle(l10n.gardirobumKategoriAyakkabi, plan.ayakkabilar);

    final metin = [
      l10n.seyahatPaylasMetni,
      l10n.seyahatKombine('{plan.kombinSayisi}'),
      ...satirlar,
    ].join('\n');

    // iPad'de paylaşım sayfasının konumu gerekiyor.
    final kutu = context.findRenderObject();
    final konum = kutu is RenderBox
        ? kutu.localToGlobal(Offset.zero) & kutu.size
        : null;

    await SharePlus.instance.share(
      ShareParams(
        text: metin,
        subject: l10n.seyahatBaslik,
        sharePositionOrigin: konum,
      ),
    );
  }
}
