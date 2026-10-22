import io
p = r'D:\indirilenler\Yeni klasor43\test\bilgi_butonlari_test.dart'
s = io.open(p, encoding='utf-8', newline='').read()
eski = "bilgiDugmesi('SANAL GARDIROBUM')"
yeni = "bilgiDugmesi('Sanal Gardırobum')"
print(s.count(eski))
s = s.replace(eski, yeni)
io.open(p, 'w', encoding='utf-8', newline='').write(s)
