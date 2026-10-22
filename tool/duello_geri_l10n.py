"""Duello 'Geri' metni - 12 dil. Idempotent; sonra `flutter gen-l10n`."""

import io
import json
import os
import sys

KLASOR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "lib", "l10n")

METINLER = {
    "duelloGeri": {
        "tr": "Geri",
        "en": "Back",
        "de": "Zurück",
        "fr": "Retour",
        "es": "Atrás",
        "it": "Indietro",
        "pt": "Voltar",
        "ru": "Назад",
        "ar": "رجوع",
        "ja": "戻る",
        "ko": "이전",
        "zh": "返回",
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
