import io, os, re, sys
sys.stdout.reconfigure(encoding='utf-8', errors='replace')

KOK = r'D:\indirilenler\Yeni klasor43\lib'


def dosyalar():
    for dizin, _, adlar in os.walk(KOK):
        for ad in adlar:
            if not ad.endswith('.dart'):
                continue
            if ad.startswith('app_localizations') or 'kombin_oyunu' in ad or 'moda_renk' in ad:
                continue
            yield os.path.join(dizin, ad)


def edge_only(satir):
    """EdgeInsets.only(...) icindeki left/right -> start/end (EdgeInsetsDirectional)."""
    m = re.search(r'EdgeInsets\.only\(([^)]*)\)', satir)
    if not m:
        return None
    ic = m.group(1)
    if 'left:' not in ic and 'right:' not in ic:
        return None
    yeni = ic
    yeni = re.sub(r'\bleft:\s*([^,)]+)', r'start: \1', yeni)
    yeni = re.sub(r'\bright:\s*([^,)]+)', r'end: \1', yeni)
    return satir[:m.start()] + 'EdgeInsetsDirectional.only(' + yeni + ')' + satir[m.end():]


toplam = 0
for yol in dosyalar():
    s = io.open(yol, encoding='utf-8', newline='').read()
    if not re.search(r'Alignment\.center(Left|Right)\b|EdgeInsets\.only\([^)]*\b(left|right):', s):
        continue
    once = s
    # 1) Alignment.centerLeft / centerRight -> AlignmentDirectional
    s = s.replace('Alignment.centerLeft', 'AlignmentDirectional.centerStart')
    s = s.replace('Alignment.centerRight', 'AlignmentDirectional.centerEnd')
    # 2) EdgeInsets.only -> EdgeInsetsDirectional.only (satir satir)
    satirlar = s.split('\n')
    yeni_satirlar = []
    for satir in satirlar:
        y = edge_only(satir)
        yeni_satirlar.append(y if y is not None else satir)
    s = '\n'.join(yeni_satirlar)
    if s != once:
        io.open(yol, 'w', encoding='utf-8', newline='').write(s)
        n = len(re.findall(r'AlignmentDirectional\.|EdgeInsetsDirectional\.', s)) \
            - len(re.findall(r'AlignmentDirectional\.|EdgeInsetsDirectional\.', once))
        toplam += n
        print('  %-32s +%d' % (os.path.basename(yol), n))
print('toplam %d RTL kırılma noktası düzeltildi' % toplam)
