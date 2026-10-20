"""AAB (Play paketi) dogrulamasi: manifest, imza ve gercek metinler.

Neden: APK ile AAB farkli klasor yapisina sahiptir (base/lib/...). Play'e
yuklemeden once surumun ve yeni metinlerin paketin ICINDE oldugunu gormek
gerekir; "derlendi" demek "dogru derlendi" demek degildir.

Kullanim:
    python tool/aab_dogrula.py build/FitCheck-1.0.30+36.aab
    python tool/aab_dogrula.py <aab> "metin" ["metin" ...]
"""

import sys
import zipfile

BEKLENEN_GIRDI = [
    "base/manifest/AndroidManifest.xml",
    "base/resources.pb",
]

# Hem APK (lib/...) hem AAB (base/lib/...) icin denenecek yollar.
LIB_YOLLARI = [
    "base/lib/arm64-v8a/libapp.so",
    "lib/arm64-v8a/libapp.so",
]


def metin_ara(lib, metin):
    for kod, etiket in (("utf-16-le", "UTF-16LE"), ("latin-1", "Latin-1"), ("utf-8", "UTF-8")):
        try:
            if lib.find(metin.encode(kod)) >= 0:
                return etiket
        except UnicodeEncodeError:
            continue
    return None


def main():
    if len(sys.argv) < 2:
        print("Kullanim: aab_dogrula.py <aab> [metin ...]")
        return 2

    yol = sys.argv[1]
    metinler = sys.argv[2:]

    with zipfile.ZipFile(yol) as z:
        adlar = z.namelist()
        print("girdi sayisi: %d" % len(adlar))

        eksik = [g for g in BEKLENEN_GIRDI if g not in adlar]
        for g in BEKLENEN_GIRDI:
            print("  %-42s %s" % (g, "OK" if g not in eksik else "<-- YOK"))

        imzalar = [a for a in adlar if a.startswith("META-INF/") and
                   a.upper().endswith((".RSA", ".DSA", ".EC"))]
        print("  %-42s %s" % ("META-INF imza blogu",
                              imzalar[0] if imzalar else "<-- YOK"))

        lib_yolu = next((y for y in LIB_YOLLARI if y in adlar), None)
        if not lib_yolu:
            print("libapp.so bulunamadi")
            return 1
        lib = z.read(lib_yolu)
        print("  %-42s %d bayt" % (lib_yolu, len(lib)))

    hata = bool(eksik) or not imzalar
    for metin in metinler:
        bulundu = metin_ara(lib, metin)
        print("  metin: %-38s %s" % (metin[:38], bulundu or "<-- YOK"))
        if not bulundu:
            hata = True

    print("\n%s" % ("PAKET DOGRULANDI" if not hata else "DOGRULAMA BASARISIZ"))
    return 1 if hata else 0


if __name__ == "__main__":
    sys.exit(main())
