import io

def duzenle(yol, degisimler, say=1):
    s = io.open(yol, encoding='utf-8', newline='').read()
    nl = '\r\n' if '\r\n' in s else '\n'
    for eski, yeni in degisimler:
        eski = eski.replace('\n', nl)
        yeni = yeni.replace('\n', nl)
        if eski not in s:
            raise SystemExit('bulunamadi: ' + eski[:70])
        s = s.replace(eski, yeni, say)
    io.open(yol, 'w', encoding='utf-8', newline='').write(s)

# 1) Rapor: veri görselleri marka zümrütü (parlak yeşil kremle çelişiyordu)
duzenle(r'D:\indirilenler\Yeni klasor43\lib\screens\stil_gunlugu_ekrani.dart', [
    ("""    final farkRengi = rapor.degisim > 0
        ? AppAccents.success""",
     """    final farkRengi = rapor.degisim > 0
        ? colors.primary"""),
    ("""                            color: i == haftalar.length - 1
                                ? AppAccents.success""",
     """                            color: i == haftalar.length - 1
                                ? colors.primary"""),
    ("""                        ? AppAccents.success.withValues(alpha: 0.85)""",
     """                        ? colors.primary.withValues(alpha: 0.9)"""),
    ("""                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppAccents.success,
                ),""",
     """                valueColor: AlwaysStoppedAnimation<Color>(colors.primary),"""),
    # Takvim noktası: "giyildi" = zümrüt
    ("""            _noktaGostergesi(colors, AppAccents.success, l10n.stilGunluguGiyildi),""",
     """            _noktaGostergesi(colors, colors.primary, l10n.stilGunluguGiyildi),"""),
    ("""                      _nokta(colors, AppAccents.success)""",
     """                      _nokta(colors, colors.primary)"""),
    ("""                    renk: AppAccents.success,""",
     """                    renk: colors.primary,"""),
    # Kombin seçici satırı: 3 küçük görsel + 2 satır başlık (adlar kesiliyordu)
    ("""                child: SizedBox(width: 42, height: 52, child: _parcaGorseli(parca)),""",
     """                child: SizedBox(width: 34, height: 44, child: _parcaGorseli(parca)),"""),
    ("""                  Text(
                    baslik,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,""",
     """                  Text(
                    baslik,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,"""),
])

# 2) Seyahat: parça adları kesiliyordu → sarmalanan ızgara + 2 satır etiket
duzenle(r'D:\indirilenler\Yeni klasor43\lib\screens\seyahat_ekrani.dart', [
    ("""          SizedBox(
            height: 64,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: parcalar.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final parca = parcalar[i];
                return SizedBox(
                  width: 64,
                  child: Column(
                    children: [
                      Container(
                        width: 64,
                        height: 48,
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
                      const SizedBox(height: 2),
                      Text(
                        parca.gorunenBaslik,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 10,
                          color: colors.onPrimaryContainer
                              .withValues(alpha: 0.85),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),""",
     """          Wrap(
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
          ),"""),
])

# 3) Bilgi sayfası: tutamaç + "Anladım" düğmesi (kapatma yolu belirgin olsun)
duzenle(r'D:\indirilenler\Yeni klasor43\lib\widgets\bilgi_butonu.dart', [
    ("""                  padding: const EdgeInsets.fromLTRB(20, 22, 20, 14),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(""",
     """                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 36,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: colors.onSurfaceVariant.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      Row("""),
    ("""                      Text(
                        aciklama,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.4,
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ],""",
     """                      Text(
                        aciklama,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.45,
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () => Navigator.of(sheetContext).pop(),
                          child: Text(
                            MaterialLocalizations.of(sheetContext).okButtonLabel,
                          ),
                        ),
                      ),
                    ],"""),
])

print('ok')
