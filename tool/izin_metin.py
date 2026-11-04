import io, re, sys
sys.stdout.reconfigure(encoding='utf-8', errors='replace')
s = io.open(r'D:\indirilenler\Yeni klasor43\lib\l10n\app_tr.arb', encoding='utf-8').read()
for k in ['izinAciklama', 'izinEkraniAciklama', 'izinBaslik', 'konumIzni',
          'kameraIzni', 'bildirimIzni', 'izinAciklamaMetni', 'izinEkraniBaslik']:
    m = re.search('"' + k + '":\\s*"([^"]*)"', s)
    if m:
        print('%-24s = %s' % (k, m.group(1)[:260]))
