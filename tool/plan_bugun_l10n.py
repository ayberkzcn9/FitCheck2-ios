"""Bugun plan karti metinleri - 12 dil. Idempotent; sonra `flutter gen-l10n`."""

import io
import json
import os
import sys

KLASOR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "lib", "l10n")

METINLER = {
    "planBugun": {
        "tr": "Bugün planın",
        "en": "Your plan today",
        "de": "Dein Plan heute",
        "fr": "Ta tenue du jour",
        "es": "Tu look de hoy",
        "it": "Il tuo outfit di oggi",
        "pt": "O teu look de hoje",
        "ru": "Твой образ на сегодня",
        "ar": "إطلالتك اليوم",
        "ja": "今日のコーデ",
        "ko": "오늘의 코디",
        "zh": "今日穿搭",
    },
    "planTakvimdenDegistir": {
        "tr": "Takvimden değiştir",
        "en": "Change in calendar",
        "de": "Im Kalender ändern",
        "fr": "Modifier dans le calendrier",
        "es": "Cambiar en el calendario",
        "it": "Cambia nel calendario",
        "pt": "Alterar no calendário",
        "ru": "Изменить в календаре",
        "ar": "تغيير في التقويم",
        "ja": "カレンダーで変更",
        "ko": "캘린더에서 변경",
        "zh": "在日历中更换",
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
