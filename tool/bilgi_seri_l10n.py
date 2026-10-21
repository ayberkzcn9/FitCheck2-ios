"""Seri olcutunun basligi - 12 dil. Idempotent; sonra `flutter gen-l10n`."""

import io
import json
import os
import sys

KLASOR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "lib", "l10n")

METINLER = {
    "bilgiSeriBaslik": {
        "tr": "Giyme Serisi",
        "en": "Wearing Streak",
        "de": "Trage-Serie",
        "fr": "Série de port",
        "es": "Racha de uso",
        "it": "Serie di indossamento",
        "pt": "Sequência de uso",
        "ru": "Серия дней ношения",
        "ar": "سلسلة اللبس",
        "ja": "着た連続記録",
        "ko": "착용 연속 기록",
        "zh": "连续穿着记录",
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
