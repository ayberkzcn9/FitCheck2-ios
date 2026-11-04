import io, re, sys
sys.stdout.reconfigure(encoding='utf-8', errors='replace')
for p in ['lib/screens/ayarlar_ekrani.dart', 'lib/screens/reklamsiz_premium_ekrani.dart']:
    s = io.open(p, encoding='utf-8').read()
    i = s.index('class ', s.index('class ') + 1)
    blok = s[s.rfind('class', 0, i):i + 900]
    print('==', p)
    print(blok)
