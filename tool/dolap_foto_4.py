import io
p = r'D:\indirilenler\Yeni klasor43\lib\screens\gardirobum_ekrani.dart'
s = io.open(p, encoding='utf-8', newline='').read()
nl = '\r\n' if '\r\n' in s else '\n'

eski = """                            child: Image.memory(
                              item.resimBytes,
                              // 🔍 contain: yatay kalan görsellerde kıyafetin
                              // kenarları kırpılmasın (cover kırpıyordu).
                              fit: BoxFit.contain,""".replace('\n', nl)
yeni = """                            child: Image.memory(
                              item.resimBytes,
                              // 🔍 contain: yatay kalan görsellerde kıyafetin
                              // kenarları kırpılmasın (cover kırpıyordu).
                              fit: BoxFit.contain,
                              // Sığmayan görsel kartın üstüne yaslanır; ortalı
                              // bırakıldığında üstte boş bir bant kalıyordu.
                              alignment: Alignment.topCenter,""".replace('\n', nl)
if s.count(eski) != 1:
    raise SystemExit('eslesme: %d' % s.count(eski))
s = s.replace(eski, yeni)
io.open(p, 'w', encoding='utf-8', newline='').write(s)
print('ok')
