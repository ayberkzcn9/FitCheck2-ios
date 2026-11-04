"""Yeni dolap maddesini her dilde listenin basina tasir ve karakter sayar."""
import io
import re

YOL = "yayin-notlari-1.0.32.md"
ham = io.open(YOL, encoding="utf-8", newline="").read()
ayrac = "\r\n" if "\r\n" in ham else "\n"
satirlar = ham.split(ayrac)

bloklar = []
i = 0
while i < len(satirlar):
    if re.match(r"^## ([a-z]{2})$", satirlar[i].strip()):
        dil = satirlar[i].strip()[3:]
        j = i + 1
        while j < len(satirlar) and not satirlar[j].startswith("## ") and satirlar[j].strip() != "---":
            j += 1
        bloklar.append((dil, i + 1, j))
        i = j
    else:
        i += 1

for dil, bas, bit in reversed(bloklar):
    madde = None
    for k in range(bas, bit):
        if "Dolapta ara" in satirlar[k] or "Search your wardrobe" in satirlar[k] \
                or "Cerca nel guardaroba" in satirlar[k] or "Busca en tu armario" in satirlar[k] \
                or "支持衣橱搜索" in satirlar[k] or "ابحث في خزانتك" in satirlar[k] \
                or "Recherchez dans votre garde-robe" in satirlar[k] \
                or "Garderobe durchsuchen" in satirlar[k] \
                or "Pesquise no guarda-roupa" in satirlar[k] \
                or "ワードローブの検索" in satirlar[k] or "옷장 검색" in satirlar[k] \
                or "Поиск по гардеробу" in satirlar[k]:
            madde = satirlar.pop(k)
            bit -= 1
            break
    if madde:
        satirlar.insert(bas, madde)

# Karakter sayimi
metin = ayrac.join(satirlar)
for dil, bas, bit in bloklar:
    pass
print("karakter sayilari:")
i = 0
while i < len(satirlar):
    if re.match(r"^## ([a-z]{2})$", satirlar[i].strip()):
        dil = satirlar[i].strip()[3:]
        j = i + 1
        while j < len(satirlar) and not satirlar[j].startswith("## ") and satirlar[j].strip() != "---":
            j += 1
        govde = "\n".join(satirlar[i + 1:j]).strip()
        print("  %s: %d" % (dil, len(govde)))
        i = j
    else:
        i += 1

io.open(YOL, "w", encoding="utf-8", newline="").write(metin)
print("tamam")
