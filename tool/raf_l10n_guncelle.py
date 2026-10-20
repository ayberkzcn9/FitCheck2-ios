"""Bugun rafi hizli aksiyon metinlerini 12 ARB'ye ekler.

Idempotent. Calistirdiktan sonra `flutter gen-l10n` gerekir.
"""

import io
import json
import os
import sys

KLASOR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "lib", "l10n")

YER_TUTUCU = ("bugunParcaGiydimIsaretlendi",)

METINLER = {
    "tr": {
        "bugunParcaGiydim": "Bugün giydim",
        "bugunParcaKombin": "Bununla kombin kur",
        "bugunParcaDolapta": "Dolapta aç",
        "bugunParcaGiydimIsaretlendi": "«{parca}» bugün giydim olarak işaretlendi.",
    },
    "en": {
        "bugunParcaGiydim": "Wore it today",
        "bugunParcaKombin": "Build an outfit with this",
        "bugunParcaDolapta": "Open in wardrobe",
        "bugunParcaGiydimIsaretlendi": "\"{parca}\" marked as worn today.",
    },
    "de": {
        "bugunParcaGiydim": "Heute getragen",
        "bugunParcaKombin": "Outfit damit erstellen",
        "bugunParcaDolapta": "Im Kleiderschrank öffnen",
        "bugunParcaGiydimIsaretlendi": "\u201e{parca}\u201c wurde für heute als getragen markiert.",
    },
    "fr": {
        "bugunParcaGiydim": "Porté aujourd'hui",
        "bugunParcaKombin": "Créer une tenue avec",
        "bugunParcaDolapta": "Ouvrir dans le dressing",
        "bugunParcaGiydimIsaretlendi": "« {parca} » marqué comme porté aujourd'hui.",
    },
    "es": {
        "bugunParcaGiydim": "Lo llevé hoy",
        "bugunParcaKombin": "Crear look con esta prenda",
        "bugunParcaDolapta": "Abrir en el armario",
        "bugunParcaGiydimIsaretlendi": "«{parca}» marcada como usada hoy.",
    },
    "it": {
        "bugunParcaGiydim": "Indossato oggi",
        "bugunParcaKombin": "Crea un outfit con questo",
        "bugunParcaDolapta": "Apri nel guardaroba",
        "bugunParcaGiydimIsaretlendi": "«{parca}» segnato come indossato oggi.",
    },
    "pt": {
        "bugunParcaGiydim": "Usei hoje",
        "bugunParcaKombin": "Criar look com esta peça",
        "bugunParcaDolapta": "Abrir no guarda-roupa",
        "bugunParcaGiydimIsaretlendi": "«{parca}» marcada como usada hoje.",
    },
    "ru": {
        "bugunParcaGiydim": "Надел(а) сегодня",
        "bugunParcaKombin": "Собрать образ с этим",
        "bugunParcaDolapta": "Открыть в гардеробе",
        "bugunParcaGiydimIsaretlendi": "«{parca}» отмечено как надетое сегодня.",
    },
    "ar": {
        "bugunParcaGiydim": "ارتديتها اليوم",
        "bugunParcaKombin": "نسّق إطلالة بها",
        "bugunParcaDolapta": "افتح في الخزانة",
        "bugunParcaGiydimIsaretlendi": "تم وضع «{parca}» كمرتدى اليوم.",
    },
    "ja": {
        "bugunParcaGiydim": "今日着た",
        "bugunParcaKombin": "これでコーデを作る",
        "bugunParcaDolapta": "クローゼットで開く",
        "bugunParcaGiydimIsaretlendi": "「{parca}」を今日着たものにしました。",
    },
    "ko": {
        "bugunParcaGiydim": "오늘 입었어요",
        "bugunParcaKombin": "이걸로 코디 만들기",
        "bugunParcaDolapta": "옷장에서 열기",
        "bugunParcaGiydimIsaretlendi": "‘{parca}’을(를) 오늘 입은 것으로 표시했어요.",
    },
    "zh": {
        "bugunParcaGiydim": "今天穿了",
        "bugunParcaKombin": "用它搭配穿搭",
        "bugunParcaDolapta": "在衣橱中打开",
        "bugunParcaGiydimIsaretlendi": "已将“{parca}”标记为今天穿过。",
    },
}


def ekle(yol, metinler):
    with io.open(yol, encoding="utf-8") as f:
        veri = json.load(f)
    eklenen = 0
    for anahtar, deger in metinler.items():
        if veri.get(anahtar) != deger:
            eklenen += 1
        veri[anahtar] = deger
        if anahtar in YER_TUTUCU:
            veri["@" + anahtar] = {"placeholders": {"parca": {"type": "String"}}}
    if eklenen:
        with io.open(yol, "w", encoding="utf-8", newline="\n") as f:
            json.dump(veri, f, ensure_ascii=False, indent=2)
            f.write("\n")
    return eklenen


def main():
    toplam = 0
    for dil, metinler in METINLER.items():
        yol = os.path.join(KLASOR, "app_%s.arb" % dil)
        if not os.path.exists(yol):
            print("YOK: %s" % yol)
            return 1
        n = ekle(yol, metinler)
        toplam += n
        print("%s: %d metin" % (dil, n))
    print("\ntoplam %d" % toplam)
    return 0


if __name__ == "__main__":
    sys.exit(main())
