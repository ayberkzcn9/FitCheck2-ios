"""Rapor ekranı için 3 yeni metni 12 ARB dosyasına ekler.

Idempotent. Çalıştırdıktan sonra `flutter gen-l10n` gerekir.
"""

import io
import json
import os
import sys

KLASOR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "lib", "l10n")

METINLER = {
    "stilGunluguRaporSayiEtiketi": {
        "tr": "Bu hafta giyilen kombin",
        "en": "Outfits worn this week",
        "de": "Getragene Outfits diese Woche",
        "fr": "Tenues portées cette semaine",
        "es": "Conjuntos llevados esta semana",
        "it": "Outfit indossati questa settimana",
        "pt": "Looks usados esta semana",
        "ru": "Образов надето за неделю",
        "ar": "إطلالات تم ارتداؤها هذا الأسبوع",
        "ja": "今週着たコーデ",
        "ko": "이번 주 착용한 코디",
        "zh": "本周穿搭次数",
    },
    "stilGunluguRaporDortHafta": {
        "tr": "Son 4 hafta",
        "en": "Last 4 weeks",
        "de": "Letzte 4 Wochen",
        "fr": "4 dernières semaines",
        "es": "Últimas 4 semanas",
        "it": "Ultime 4 settimane",
        "pt": "Últimas 4 semanas",
        "ru": "Последние 4 недели",
        "ar": "آخر 4 أسابيع",
        "ja": "過去4週間",
        "ko": "최근 4주",
        "zh": "最近4周",
    },
    "stilGunluguRaporEnCokParcalar": {
        "tr": "En çok giydiklerin",
        "en": "Most worn pieces",
        "de": "Meistgetragene Teile",
        "fr": "Pièces les plus portées",
        "es": "Prendas más usadas",
        "it": "Capi più indossati",
        "pt": "Peças mais usadas",
        "ru": "Самые носимые вещи",
        "ar": "القطع الأكثر ارتداءً",
        "ja": "よく着たアイテム",
        "ko": "가장 많이 입은 아이템",
        "zh": "最常穿的单品",
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
