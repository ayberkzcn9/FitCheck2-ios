"""Play yayin notlarini 1.0.32+38'e gunceller: 12 dile dolap arama maddesi."""
import io
import re

YOL = "yayin-notlari-1.0.32.md"

YENI_MADDE = {
    "tr": "• Dolapta ara, kategoriye göre filtrele; sonuç sayısı anında güncellenir",
    "en": "• Search your wardrobe and filter by category; results update instantly",
    "it": "• Cerca nel guardaroba e filtra per categoria; risultati immediati",
    "es": "• Busca en tu armario y filtra por categoría; resultados al instante",
    "zh": "• 支持衣橱搜索与分类筛选，结果即时更新",
    "ar": "• ابحث في خزانتك وفلتر حسب الفئة، مع تحديث فوري للنتائج",
    "fr": "• Recherchez dans votre garde-robe et filtrez par catégorie, résultats immédiats",
    "de": "• Garderobe durchsuchen und nach Kategorie filtern, Treffer sofort",
    "pt": "• Pesquise no guarda-roupa e filtre por categoria, resultados imediatos",
    "ja": "• ワードローブの検索とカテゴリ絞り込み、結果はすぐ更新",
    "ko": "• 옷장 검색과 카테고리 필터, 결과 즉시 반영",
    "ru": "• Поиск по гардеробу и фильтр по категориям, результат сразу",
}

ham = io.open(YOL, encoding="utf-8", newline="").read()
ayrac = "\r\n" if "\r\n" in ham else "\n"
satirlar = ham.split(ayrac)

# Dil bloklarini bul: '## xx' ile baslayan bolumler
bloklar = []  # (dil, baslangic, bitis)
i = 0
while i < len(satirlar):
    m = re.match(r"^## ([a-z]{2})$", satirlar[i].strip())
    if m:
        j = i + 1
        while j < len(satirlar) and not satirlar[j].startswith("## ") and satirlar[j].strip() != "---":
            j += 1
        bloklar.append((m.group(1), i + 1, j))
        i = j
    else:
        i += 1

# Sondan basa ekle (indeks kaymasin)
eklenen = 0
for dil, bas, bit in reversed(bloklar):
    if dil not in YENI_MADDE:
        continue
    son_madde = None
    for k in range(bas, bit):
        if satirlar[k].startswith("• "):
            son_madde = k
    if son_madde is None:
        continue
    satirlar.insert(son_madde + 1, YENI_MADDE[dil])
    eklenen += 1

s = ayrac.join(satirlar)
print("eklenen madde:", eklenen)

# Baslik ve surum numaralari
s = s.replace("# FitCheck 1.0.32 (37)", "# FitCheck 1.0.32 (38)")
s = s.replace("FitCheck-1.0.32+37.aab", "FitCheck-1.0.32+38.aab")
s = s.replace("FitCheck-1.0.32+37.apk", "FitCheck-1.0.32+38.apk")
s = s.replace("versionCode 37", "versionCode 38")
s = s.replace(
    "SHA256 `4BDDFC378F001AC0EADBA8CD2A4EDDA65159E84F9E15CA9E9EC0C46693A1B7B8`",
    "SHA256 `{{AAB_SHA}}`",
)
s = s.replace(
    "SHA256 `BA1FE427E0495CAF64ACCF11A3B0DDE55468071F13B3E0421F154A3F5426A1C5`",
    "SHA256 `{{APK_SHA}}`",
)
s = s.replace("72.599.508 bayt", "{{AAB_BOYUT}} bayt")

s = re.sub(
    r"\(21\.10\.2026 UI turundan sonra yeniden üretildi; 37 hâlâ yüklenmediyse aynı\r?\n"
    r"   sürüm kullanılır\. Yüklendiyse versionCode 38'e çıkılmalı\.\)",
    "(21.10.2026 dolap arama/filtre turundan sonra yeniden üretildi. Önceki\n"
    "   derleme 37'ydi; bu paket versionCode 38 olduğu için yükleme çakışmaz.)",
    s,
)

s = s.replace(
    "   tek cam bulanıklığı (blur 12) ve sadeleşmiş yarıçap/yazı ölçeği.",
    "   tek cam bulanıklığı (blur 12) ve sadeleşmiş yarıçap/yazı ölçeği.\n"
    "   Son tur: dolapta arama + kategori çipleri + sonuç sayacı; AI'nin\n"
    "   döndürdüğü serbest kategori ('ceket', 'çanta'…) artık doğru rafa düşüyor\n"
    "   (önceden bu parçalar dolapta görünmüyordu).",
)

io.open(YOL, "w", encoding="utf-8", newline="").write(s)
print("yayin notlari guncellendi")
