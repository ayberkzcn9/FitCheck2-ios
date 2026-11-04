import io
p = r'D:\indirilenler\Yeni klasor43\test\ui_inceleme_test.dart'
s = io.open(p, encoding='utf-8', newline='').read()
a = s.count("          onFavoriEkle: (_) {},\r\n          onFavoriCikar: (_) {},\r\n          onGecmiseEkle: (_) {},")
b = s.count("          onFavoriEkle: (_) {},\n          onFavoriCikar: (_) {},\n          onGecmiseEkle: (_) {},")
nl = '\r\n' if a else '\n'
eski = nl.join(["          onFavoriEkle: (_) {},", "          onFavoriCikar: (_) {},", "          onGecmiseEkle: (_) {},"])
yeni = nl.join(["          onFavoriEkle: (_) {},", "          onFavoriCikar: (_) {},", "          onGecmiseEkle: (_, __) {},"])
print(s.count(eski))
s = s.replace(eski, yeni)
eski2 = nl.join(["          onFavoriEkle: (_) {},", "          onGecmiseEkle: (_) {},", "          onKonumuYenile: () {},"])
yeni2 = nl.join(["          onFavoriEkle: (_) {},", "          onGecmiseEkle: (_, __) async {},", "          onKonumuYenile: () {},"])
print(s.count(eski2))
s = s.replace(eski2, yeni2)
io.open(p, 'w', encoding='utf-8', newline='').write(s)
