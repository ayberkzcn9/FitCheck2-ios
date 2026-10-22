import io, os, re, sys
sys.stdout.reconfigure(encoding='utf-8', errors='replace')

L10N = r'D:\indirilenler\Yeni klasor43\lib\l10n'

metinler = {
    'tr': 'Bu özellik yakında eklenecek',
    'en': 'This feature is coming soon',
    'de': 'Diese Funktion wird bald verfügbar sein',
    'es': 'Esta función llegará pronto',
    'fr': 'Cette fonctionnalité arrive bientôt',
    'it': 'Questa funzionalità sarà presto disponibile',
    'pt': 'Este recurso chegará em breve',
    'ru': 'Эта функция скоро появится',
    'zh': '此功能即将推出',
    'ja': 'この機能は近日公開予定です',
    'ko': '이 기능은 곧 제공됩니다',
    'ar': 'هذه الميزة قادمة قريبًا',
}

for dil, metin in metinler.items():
    p = os.path.join(L10N, 'app_%s.arb' % dil)
    s = io.open(p, encoding='utf-8', newline='').read()
    if '"ozellikYakinda"' in s:
        print('zaten var:', dil)
        continue
    # Dosyanin son "anahtar": "deger", satirlarindan birine ekle.
    desen = re.compile(r'\n(\s*)"[^"]+":\s*"[^"]*",')
    m = list(desen.finditer(s))
    if not m:
        raise SystemExit('anahtar bulunamadi: ' + dil)
    son = m[-1]
    girinti = son.group(1)
    ek = '\n' + girinti + '"ozellikYakinda": "%s",' % metin
    s = s[:son.end()] + ek + s[son.end():]
    io.open(p, 'w', encoding='utf-8', newline='').write(s)
    print('eklendi:', dil)

# Kodda kullan
yol = r'D:\indirilenler\Yeni klasor43\lib\screens\dolaptan_kombin_ekrani.dart'
s = io.open(yol, encoding='utf-8', newline='').read()
eski = "content: const Text('Bu özellik yakında eklenecek'),"
if eski not in s:
    raise SystemExit('kodda bulunamadi')
s = s.replace(eski, 'content: Text(AppLocalizations.of(context)!.ozellikYakinda),')
io.open(yol, 'w', encoding='utf-8', newline='').write(s)
print('kod guncellendi')
