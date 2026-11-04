"""Takvim secim sayfasi basliklari - 12 dil. Idempotent; sonra `flutter gen-l10n`."""

import io
import json
import os
import sys

KLASOR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "lib", "l10n")

METINLER = {
    "planFavorilerim": {
        "tr": "Favorilerim",
        "en": "My favourites",
        "de": "Meine Favoriten",
        "fr": "Mes favoris",
        "es": "Mis favoritos",
        "it": "I miei preferiti",
        "pt": "Os meus favoritos",
        "ru": "Мои избранное",
        "ar": "مفضلتي",
        "ja": "お気に入り",
        "ko": "즐겨찾기",
        "zh": "我的收藏",
    },
    "planSonGiyilenler": {
        "tr": "Son giyilenler",
        "en": "Recently worn",
        "de": "Zuletzt getragen",
        "fr": "Récemment portées",
        "es": "Usados recientemente",
        "it": "Indossati di recente",
        "pt": "Usados recentemente",
        "ru": "Недавно надетое",
        "ar": "ارتدتها مؤخرًا",
        "ja": "最近着たもの",
        "ko": "최근 입은 옷",
        "zh": "最近穿过的",
    },
}


def main():
    for anahtar, diller in METINLER.items():
        for dil, deger in sorted(diller.items()):
            yol = os.path.join(KLASOR, "app_%s.arb" % dil)
            with io.open(yol, encoding="utf-8") as f:
                veri = json.load(f)
            if veri.get(anahtar) != deger:
                veri[anahtar] = deger
                with io.open(yol, "w", encoding="utf-8", newline="\n") as f:
                    json.dump(veri, f, ensure_ascii=False, indent=2)
                    f.write("\n")
        print("%s: tamam" % anahtar)
    return 0


if __name__ == "__main__":
    sys.exit(main())
