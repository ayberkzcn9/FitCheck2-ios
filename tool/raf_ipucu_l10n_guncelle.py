"""Raf ipucu metnini guncelleyir (parca dokununca hizli aksiyonlar acilir).

Idempotent. Calistirdiktan sonra `flutter gen-l10n` gerekir.
"""

import io
import json
import os
import sys

KLASOR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "lib", "l10n")

ANAHTAR = "bugunRafIpucu"

METINLER = {
    "tr": "Dokun: giydim, kombin kur veya dolapta aç",
    "en": "Tap: wear it, build an outfit or open it in the wardrobe",
    "it": "Tocca: indossalo, crea un outfit o apri nel guardaroba",
    "es": "Toca: me la puse hoy, crea un look o ábrela en el armario",
    "zh": "点击：标记今天穿了、搭配它或在衣橱中打开",
    "ar": "اضغط: ارتديها اليوم أو نسّق إطلالة أو افتحها في الخزانة",
    "fr": "Touchez : portée aujourd'hui, créer une tenue ou ouvrir",
    "de": "Tippen: getragen, Outfit bauen oder im Kleiderschrank öffnen",
    "pt": "Toque: usei hoje, criar look ou abrir no guarda-roupa",
    "ja": "タップ：着た記録・着合わせ作成・クローゼットで開く",
    "ko": "누르기: 오늘 입었어요, 코디 만들기, 옷장에서 열기",
    "ru": "Нажмите: надето сегодня, собрать образ или открыть в гардеробе",
}


def main():
    for dil, deger in METINLER.items():
        yol = os.path.join(KLASOR, "app_%s.arb" % dil)
        if not os.path.exists(yol):
            print("YOK: %s" % yol)
            return 1
        with io.open(yol, encoding="utf-8") as f:
            veri = json.load(f)
        if ANAHTAR not in veri:
            print("%s: anahtar yok" % dil)
            continue
        if veri[ANAHTAR] == deger:
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
