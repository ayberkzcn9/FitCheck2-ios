"""Geri alma (undo) etiketini 12 ARB'ye ekler.

Idempotent. Calistirdiktan sonra `flutter gen-l10n` gerekir.
"""

import io
import json
import os
import sys

KLASOR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "lib", "l10n")

ANAHTAR = "geriAl"

METINLER = {
    "tr": "Geri al",
    "en": "Undo",
    "de": "Rückgängig",
    "fr": "Annuler",
    "es": "Deshacer",
    "it": "Annulla",
    "pt": "Anular",
    "ru": "Отменить",
    "ar": "تراجع",
    "ja": "元に戻す",
    "ko": "실행 취소",
    "zh": "撤销",
}


def main():
    for dil, deger in METINLER.items():
        yol = os.path.join(KLASOR, "app_%s.arb" % dil)
        if not os.path.exists(yol):
            print("YOK: %s" % yol)
            return 1
        with io.open(yol, encoding="utf-8") as f:
            veri = json.load(f)
        if veri.get(ANAHTAR) == deger:
            print("%s: zaten guncel" % dil)
            continue
        veri[ANAHTAR] = deger
        with io.open(yol, "w", encoding="utf-8", newline="\n") as f:
            json.dump(veri, f, ensure_ascii=False, indent=2)
            f.write("\n")
        print("%s: guncellendi" % dil)
    return 0


if __name__ == "__main__":
    sys.exit(main())
