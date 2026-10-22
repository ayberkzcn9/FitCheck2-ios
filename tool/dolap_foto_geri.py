import io
p = r'D:\indirilenler\Yeni klasor43\lib\screens\gardirobum_ekrani.dart'
s = io.open(p, encoding='utf-8', newline='').read()
nl = '\r\n' if '\r\n' in s else '\n'

# Align(topCenter) icindeki Image sikisti ve gorunmez oldu; eski, calisan
# hizalamaya don.
eski = """                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Image.memory(
                                item.resimBytes,
                                // 🔍 contain: yatay kalan görsellerde kıyafetin
                                // kenarları kırpılmasın (cover kırpıyordu).
                                fit: BoxFit.contain,
                                errorBuilder: (_, __, ___) => Center(
                                  child: Icon(Icons.broken_image_outlined, color: colors.onSurfaceVariant),
                                ),
                              ),
                            ),
                          ),""".replace('\n', nl)
yeni = """                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Image.memory(
                              item.resimBytes,
                              // 🔍 contain: yatay kalan görsellerde kıyafetin
                              // kenarları kırpılmasın (cover kırpıyordu).
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => Center(
                                child: Icon(Icons.broken_image_outlined, color: colors.onSurfaceVariant),
                              ),
                            ),
                          ),""".replace('\n', nl)
if s.count(eski) != 1:
    raise SystemExit('eslesme: %d' % s.count(eski))
s = s.replace(eski, yeni)

# Kart yuksekligi eski degerine don.
s = s.replace('        SizedBox(\n          height: 205,', '        SizedBox(\n          height: 265,')
io.open(p, 'w', encoding='utf-8', newline='').write(s)
print('ok')
