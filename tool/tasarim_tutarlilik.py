"""Görsel tutarlılık: bulanıklık, köşe yarıçapı ve yazı boyutlarını tek ölçeğe indirir.

- Bulanıklık: 5/6/8/10/12/16 → AppBlur.cam (12). Arka plan (70) korunur.
- Yarıçap: 10→12, 14→16, 18→16, 18.5→16, 22→24, 23→24, 26→28, 99/100→999.
- Yazı: 12.5→12, 14.5→14, 10.5→10, 9→10.

Idempotent. Çalıştırdıktan sonra `flutter analyze` ve testler koşulmalı.
"""

import glob
import io
import os
import re
import sys

KOK = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..")
LIB = os.path.join(KOK, "lib")

BULANIK = {"5", "6", "8", "10", "12", "16"}
YARICAP = {
    "10": "12",
    "14": "16",
    "18": "16",
    "18.5": "16",
    "22": "24",
    "23": "24",
    "26": "28",
    "99": "999",
    "100": "999",
}
YAZI = {"12.5": "12", "14.5": "14", "10.5": "10", "9": "10"}

BULANIK_RE = re.compile(r"sigmaX:\s*([0-9.]+),\s*sigmaY:\s*([0-9.]+)")
YARICAP_RE = re.compile(r"(BorderRadius\.circular\(\s*)([0-9.]+)(\s*\))")
YAZI_RE = re.compile(r"(fontSize:\s*)([0-9.]+)(\s*[,\)])")


def importsuz_ekle(metin: str) -> str:
    if "theme/design_tokens.dart" in metin:
        return metin
    # lib/ köküne göre göreli yol.
    return metin


def isle(yol: str) -> tuple[bool, str]:
    with io.open(yol, encoding="utf-8", newline="") as f:
        s = f.read()
    ozgun = s
    kullanilan_blur = False

    def blur_degistir(m):
        nonlocal kullanilan_blur
        if m.group(1) != m.group(2) or m.group(1) not in BULANIK:
            return m.group(0)
        kullanilan_blur = True
        return "sigmaX: AppBlur.cam, sigmaY: AppBlur.cam"

    s = BULANIK_RE.sub(blur_degistir, s)
    s = YARICAP_RE.sub(
        lambda m: m.group(1) + YARICAP.get(m.group(2), m.group(2)) + m.group(3), s
    )
    s = YAZI_RE.sub(
        lambda m: m.group(1) + YAZI.get(m.group(2), m.group(2)) + m.group(3), s
    )

    if kullanilan_blur and "theme/design_tokens.dart" not in s:
        goreli = os.path.relpath(
            os.path.join(LIB, "theme", "design_tokens.dart"), os.path.dirname(yol)
        ).replace(os.sep, "/")
        s = s.replace(
            "import 'package:flutter/material.dart';",
            "import 'package:flutter/material.dart';\n\nimport '%s';" % goreli,
            1,
        )

    if s != ozgun:
        with io.open(yol, "w", encoding="utf-8", newline="") as f:
            f.write(s)
        return True, ("blur" if kullanilan_blur else "")
    return False, ""


def main():
    degisen = []
    for yol in glob.glob(os.path.join(LIB, "**", "*.dart"), recursive=True):
        if os.sep + "l10n" + os.sep in yol:
            continue
        oldu, not_ = isle(yol)
        if oldu:
            degisen.append((os.path.relpath(yol, KOK), not_))
    for yol, not_ in degisen:
        print("guncellendi: %s %s" % (yol, not_))
    print("toplam: %d dosya" % len(degisen))
    return 0


if __name__ == "__main__":
    sys.exit(main())
