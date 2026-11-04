"""Alt menü için kısa etiketler (navKombin, navProfil) — 12 dil.

Menüde her sekmeye ~53 dp düşüyor; uzun başlıklar ("Profil & Analiz")
kırpılıyor. Idempotent; sonrasında `flutter gen-l10n` gerekir.
"""

import io
import json
import os
import sys

KLASOR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "lib", "l10n")

METINLER = {
    "navKombin": {
        "tr": "Kombin",
        "en": "Outfits",
        "de": "Outfit",
        "fr": "Tenue",
        "es": "Conjunto",
        "it": "Outfit",
        "pt": "Look",
        "ru": "Образ",
        "ar": "إطلالة",
        "ja": "コーデ",
        "ko": "코디",
        "zh": "穿搭",
    },
    "navProfil": {
        "tr": "Profil",
        "en": "Profile",
        "de": "Profil",
        "fr": "Profil",
        "es": "Perfil",
        "it": "Profilo",
        "pt": "Perfil",
        "ru": "Профиль",
        "ar": "حسابي",
        "ja": "マイページ",
        "ko": "프로필",
        "zh": "我的",
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
