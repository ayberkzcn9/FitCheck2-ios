"""Kiyfet duzenleyici metinleri - 12 dil. Idempotent; sonra `flutter gen-l10n`."""

import io
import json
import os
import sys

KLASOR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "lib", "l10n")

METINLER = {
    "duzenleArkaPlanBaslik": {
        "tr": "Arka plan ve yerleşim",
        "en": "Background and placement",
        "de": "Hintergrund und Platzierung",
        "fr": "Arrière-plan et placement",
        "es": "Fondo y colocación",
        "it": "Sfondo e posizione",
        "pt": "Fundo e posicionamento",
        "ru": "Фон и размещение",
        "ar": "الخلفية والتموضع",
        "ja": "背景と配置",
        "ko": "배경과 배치",
        "zh": "背景与摆放",
    },
    "duzenleIpucu": {
        "tr": "Parçayı sürükleyerek yerleştirebilir, iki parmakla büyütebilirsin.",
        "en": "Drag to place the item, pinch to resize it.",
        "de": "Ziehe das Teil an die Stelle und pinch zum Skalieren.",
        "fr": "Glisse l'article pour le placer, pince pour le redimensionner.",
        "es": "Arrastra la prenda para colocarla y pellizca para cambiar su tamaño.",
        "it": "Trascina il capo per posizionarlo, pizzica per ridimensionarlo.",
        "pt": "Arrasta a peça para a posicionar e faz pinça para redimensionar.",
        "ru": "Перетащите вещь, чтобы разместить её, и сожмите двумя пальцами, чтобы изменить размер.",
        "ar": "اسحب القطعة لتحديد موضعها وضم إصبعين لتغيير حجمها.",
        "ja": "ドラッグで配置し、ピンチでサイズを変更できます。",
        "ko": "드래그해서 위치를 정하고, 두 손가락으로 크기를 조절하세요.",
        "zh": "拖动可摆放位置，双指可调整大小。",
    },
    "duzenleZeminBeyaz": {
        "tr": "Beyaz",
        "en": "White",
        "de": "Weiß",
        "fr": "Blanc",
        "es": "Blanco",
        "it": "Bianco",
        "pt": "Branco",
        "ru": "Белый",
        "ar": "أبيض",
        "ja": "白",
        "ko": "흰색",
        "zh": "白色",
    },
    "duzenleZeminKirik": {
        "tr": "Kırık beyaz",
        "en": "Off-white",
        "de": "Creme",
        "fr": "Blanc cassé",
        "es": "Blanco roto",
        "it": "Bianco caldo",
        "pt": "Branco quente",
        "ru": "Молочный",
        "ar": "أبيض مائل",
        "ja": "オフホワイト",
        "ko": "아이보리",
        "zh": "米白",
    },
    "duzenleZeminGri": {
        "tr": "Açık gri",
        "en": "Light grey",
        "de": "Hellgrau",
        "fr": "Gris clair",
        "es": "Gris claro",
        "it": "Grigio chiaro",
        "pt": "Cinzento claro",
        "ru": "Светло-серый",
        "ar": "رمادي فاتح",
        "ja": "ライトグレー",
        "ko": "연회색",
        "zh": "浅灰",
    },
    "duzenleZeminSaydam": {
        "tr": "Saydam",
        "en": "Transparent",
        "de": "Transparent",
        "fr": "Transparent",
        "es": "Transparente",
        "it": "Trasparente",
        "pt": "Transparente",
        "ru": "Прозрачный",
        "ar": "شفاف",
        "ja": "透明",
        "ko": "투명",
        "zh": "透明",
    },
    "duzenleKaydet": {
        "tr": "Kaydet",
        "en": "Save",
        "de": "Speichern",
        "fr": "Enregistrer",
        "es": "Guardar",
        "it": "Salva",
        "pt": "Guardar",
        "ru": "Сохранить",
        "ar": "حفظ",
        "ja": "保存",
        "ko": "저장",
        "zh": "保存",
    },
    "duzenleVarsayilan": {
        "tr": "Varsayılan",
        "en": "Default",
        "de": "Standard",
        "fr": "Par défaut",
        "es": "Predeterminado",
        "it": "Predefinito",
        "pt": "Predefinido",
        "ru": "По умолчанию",
        "ar": "افتراضي",
        "ja": "そのまま",
        "ko": "기본값",
        "zh": "默认",
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
