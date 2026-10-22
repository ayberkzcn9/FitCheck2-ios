import io
p = r'D:\indirilenler\Yeni klasor43\lib\screens\kendi_kombinim_ekrani.dart'
s = io.open(p, encoding='utf-8', newline='').read()
nl = '\r\n' if '\r\n' in s else '\n'

eski = """                    const SizedBox(height: 4),
                    Text(
                      doluMu ? secilenKiyafet.gorunenBaslik : l10n.parcaSecModalBaslik(baslik),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: doluMu ? FontWeight.w800 : FontWeight.w600,
                        color: doluMu ? colors.onSurface : colors.onSurfaceVariant,
                        letterSpacing: -0.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),""".replace('\n', nl)
yeni = """                    const SizedBox(height: 4),
                    // Boş durumda "Üst Giyim Seç" yazısı üstteki kategori
                    // etiketiyle aynı şeyi söylüyordu. Boş yuva dokunma
                    // çağrısını anlatan bir rozetle gösteriliyor.
                    if (doluMu)
                      Text(
                        secilenKiyafet.gorunenBaslik,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: colors.onSurface,
                          letterSpacing: -0.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      )
                    else
                      Row(
                        children: [
                          Icon(
                            Icons.add_circle_outline_rounded,
                            size: 15,
                            color: colors.primary,
                          ),
                          const SizedBox(width: 5),
                          Flexible(
                            child: Text(
                              l10n.kendiTasarimimParcaSec,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: colors.primary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),""".replace('\n', nl)
if s.count(eski) != 1:
    raise SystemExit('eslesme: %d' % s.count(eski))
s = s.replace(eski, yeni)
io.open(p, 'w', encoding='utf-8', newline='').write(s)
print('ok')
