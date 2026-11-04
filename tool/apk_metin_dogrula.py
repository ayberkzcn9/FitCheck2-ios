"""APK icine gercekten islenen ceviri metinlerini dogrular.

Dart AOT goruntusu (libapp.so) metinleri karakter koduna gore Latin-1 ya da
UTF-16LE olarak saklar; bu yuzden her iki kodlamayi da dener.

Kullanim: python tool_apk_metin_dogrula.py <apk_yolu>
"""

import sys
import zipfile

# (aciklama, metin) — 12 dilden ornekler
ARANANLAR = [
    ("tr ipucu 1", "Kıyafeti düz, tek renkli bir zemine koy."),
    ("tr baslik", "Daha iyi kesim için"),
    ("en baslik", "For a better cutout"),
    ("ja ipucu 1", "衣類は平らな無地の面に置いてください。"),
    ("ar baslik", "لنتيجة قص أفضل"),
    ("ko baslik", "더 깔끔한 누끼를 위해"),
    ("ru ipucu 3", "Избегайте теней и узорчатых поверхностей."),
]


def main():
    apk = sys.argv[1] if len(sys.argv) > 1 else "build/FitCheck-1.0.30+36-kesim-test.apk"
    with zipfile.ZipFile(apk) as z:
        lib = z.read("lib/arm64-v8a/libapp.so")
    print("libapp.so: %d bayt" % len(lib))

    eksik = 0
    # Komut satirindan verilen ek metinler de dogrulanir
    # (or. python tool/apk_metin_dogrula.py apk.apk "Tekrar cek").
    arananlar = list(ARANANLAR) + [
        ("ek %d" % (i + 1), m) for i, m in enumerate(sys.argv[2:])
    ]
    for ad, metin in arananlar:
        bulundu = None
        for kod, etiket in (("utf-16-le", "UTF-16LE"), ("latin-1", "Latin-1"), ("utf-8", "UTF-8")):
            if lib.find(metin.encode(kod)) >= 0:
                bulundu = etiket
                break
        print("  %-14s %-22s %s" % (ad, bulundu or "YOK", "OK" if bulundu else "<-- eksik"))
        if not bulundu:
            eksik += 1

    print("\n%s" % ("TUM METINLER APK ICINDE" if eksik == 0 else "%d metin bulunamadi" % eksik))
    return 1 if eksik else 0


if __name__ == "__main__":
    sys.exit(main())
