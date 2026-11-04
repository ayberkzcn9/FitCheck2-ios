"""Dolap arama/filtre metinleri — 12 dil. Idempotent; sonrasında `flutter gen-l10n`."""

import io
import json
import os
import sys

KLASOR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "lib", "l10n")

METINLER = {
    "dolapAra": {
        "tr": "Dolabında ara",
        "en": "Search your wardrobe",
        "de": "Garderobe durchsuchen",
        "fr": "Rechercher dans votre garde-robe",
        "es": "Buscar en tu armario",
        "it": "Cerca nel guardaroba",
        "pt": "Pesquisar no guarda-roupa",
        "ru": "Поиск в гардеробе",
        "ar": "ابحث في خزانتك",
        "ja": "ワードローブを検索",
        "ko": "옷장 검색",
        "zh": "搜索衣橱",
    },
    "dolapEslesmeYok": {
        "tr": "Aramanla eşleşen parça yok.",
        "en": "No pieces match your search.",
        "de": "Keine passenden Teile gefunden.",
        "fr": "Aucune pièce ne correspond.",
        "es": "Ninguna prenda coincide.",
        "it": "Nessun capo corrisponde.",
        "pt": "Nenhuma peça corresponde.",
        "ru": "Ничего не найдено.",
        "ar": "لا توجد قطع مطابقة.",
        "ja": "一致するアイテムがありません。",
        "ko": "일치하는 아이템이 없습니다.",
        "zh": "没有匹配的单品。",
    },
    "dolapAramayiTemizle": {
        "tr": "Aramayı temizle",
        "en": "Clear search",
        "de": "Suche löschen",
        "fr": "Effacer la recherche",
        "es": "Borrar búsqueda",
        "it": "Cancella ricerca",
        "pt": "Limpar pesquisa",
        "ru": "Очистить поиск",
        "ar": "مسح البحث",
        "ja": "検索をクリア",
        "ko": "검색 지우기",
        "zh": "清除搜索",
    },
}


def main():
    for anahtar, diller in METINLER.items():
        for dil, deger in sorted(diller.items()):
            yol = os.path.join(KLASOR, "app_%s.arb" % dil)
            if not os.path.exists(yol):
                print("YOK: %s" % yol)
                return 1
            with io.open(yol, encoding="utf-8") as f:
                veri = json.load(f)
            if veri.get(anahtar) == deger:
                continue
            veri[anahtar] = deger
            with io.open(yol, "w", encoding="utf-8", newline="\n") as f:
                json.dump(veri, f, ensure_ascii=False, indent=2)
                f.write("\n")
        print("%s: tamam" % anahtar)
    return 0


if __name__ == "__main__":
    sys.exit(main())
