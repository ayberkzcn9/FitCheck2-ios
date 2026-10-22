import io, re, os, sys
sys.stdout.reconfigure(encoding='utf-8', errors='replace')

kok = r'D:\indirilenler\Yeni klasor43\lib\l10n'

metinler = {
    'tr': 'Parça seç',
    'en': 'Pick a piece',
    'de': 'Teil auswählen',
    'es': 'Elige una prenda',
    'fr': 'Choisissez un vêtement',
    'it': 'Scegli un capo',
    'pt': 'Escolher uma peça',
    'ru': 'Выберите вещь',
    'zh': '选择单品',
    'ja': 'アイテムを選択',
    'ko': '아이템 선택',
    'ar': 'اختر قطعة',
}

for dil, metin in metinler.items():
    p = os.path.join(kok, 'app_%s.arb' % dil)
    s = io.open(p, encoding='utf-8', newline='').read()
    if '"kendiTasarimimParcaSec"' in s:
        print('zaten var:', dil)
        continue
    m = re.search(r'\n(\s*)"kendiTasarimimBaslik":\s*"[^"]*",', s)
    if not m:
        print('BULUNAMADI:', dil)
        continue
    girinti = m.group(1)
    yeni = m.group(0) + '\n' + girinti + '"kendiTasarimimParcaSec": "%s",' % metin
    s = s[:m.start()] + yeni + s[m.end():]
    io.open(p, 'w', encoding='utf-8', newline='').write(s)
    print('eklendi:', dil)
