import io

p = r'D:\indirilenler\Yeni klasor43\android\app\src\main\AndroidManifest.xml'
s = io.open(p, encoding='utf-8', newline='').read()

satir = '    <uses-permission android:name="android.permission.USE_EXACT_ALARM" />'
yeni = None
for son in ('\r\n', '\n'):
    if satir + son in s:
        yeni = s.replace(satir + son, '')
        print('silindi, satir sonu: %r' % son)
        break

if yeni is None:
    print('HATA: satir bulunamadi')
else:
    io.open(p, 'w', encoding='utf-8', newline='').write(yeni)
    for i, l in enumerate(yeni.splitlines(), 1):
        if 'EXACT_ALARM' in l or 'WAKE_LOCK' in l or 'POST_NOTIFICATIONS' in l:
            print(i, l.strip())
