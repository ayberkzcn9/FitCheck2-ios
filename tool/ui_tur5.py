import io

def duzenle(yol, degisimler, say=None):
    s = io.open(yol, encoding='utf-8', newline='').read()
    nl = '\r\n' if '\r\n' in s else '\n'
    for eski, yeni in degisimler:
        eski = eski.replace('\n', nl)
        yeni = yeni.replace('\n', nl)
        if eski not in s:
            raise SystemExit('bulunamadi: ' + eski[:70])
        s = s.replace(eski, yeni, say if say is not None else 1)
    io.open(yol, 'w', encoding='utf-8', newline='').write(s)

# 1) Giriş ekranı: ana eylem düğmeleri eski "successDark" yeşili yerine marka zümrütü.
p = r'D:\indirilenler\Yeni klasor43\lib\screens\giris_ekrani.dart'
s = io.open(p, encoding='utf-8', newline='').read()
n = s.count('AppAccents.successDark')
s = s.replace('AppAccents.successDark', 'primaryColor')
io.open(p, 'w', encoding='utf-8', newline='').write(s)
print('giris: successDark -> primaryColor x%d' % n)

# 2) Test harness: hata ayıklama şeridi görüntüleri kirletmesin.
duzenle(r'D:\indirilenler\Yeni klasor43\test\ui_inceleme_test.dart', [
    ("""  return MaterialApp(
    locale: const Locale('tr'),""",
     """  return MaterialApp(
    debugShowCheckedModeBanner: false,
    locale: const Locale('tr'),"""),
])
print('ok')
