"""Arka planda yukleme metinleri - 12 dil. Idempotent; sonra `flutter gen-l10n`."""

import io
import json
import os
import sys

KLASOR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "lib", "l10n")

METINLER = {
    "arkaPlandaEkle": {
        "tr": "Arka planda ekle",
        "en": "Add in background",
        "de": "Im Hintergrund hinzufügen",
        "fr": "Ajouter en arrière-plan",
        "es": "Añadir en segundo plano",
        "it": "Aggiungi in background",
        "pt": "Adicionar em segundo plano",
        "ru": "Добавить в фоне",
        "ar": "أضِف في الخلفية",
        "ja": "バックグラウンドで追加",
        "ko": "백그라운드에서 추가",
        "zh": "后台添加",
    },
    "arkaPlandaEkleAciklama": {
        "tr": "Uygulamayı kullanmaya devam edebilirsin; parçalar arka planda eklenir.",
        "en": "You can keep using the app; your pieces are added in the background.",
        "de": "Du kannst die App weiter nutzen; deine Teile werden im Hintergrund hinzugefügt.",
        "fr": "Tu peux continuer à utiliser l'application ; tes pièces sont ajoutées en arrière-plan.",
        "es": "Puedes seguir usando la app; tus prendas se añaden en segundo plano.",
        "it": "Puoi continuare a usare l'app; i tuoi capi vengono aggiunti in background.",
        "pt": "Podes continuar a usar a app; as tuas peças são adicionadas em segundo plano.",
        "ru": "Продолжай пользоваться приложением — вещи добавляются в фоне.",
        "ar": "يمكنك متابعة استخدام التطبيق؛ تُضاف قطعك في الخلفية.",
        "ja": "アプリを使い続けたまま、アイテムはバックグラウンドで追加されます。",
        "ko": "앱을 계속 사용하세요. 아이템은 백그라운드에서 추가됩니다.",
        "zh": "你可以继续使用应用，衣物会在后台添加。",
    },
    "arkaPlandaBasladi": {
        "tr": "{count} fotoğraf arka planda ekleniyor",
        "en": "{count} photos are being added in the background",
        "de": "{count} Fotos werden im Hintergrund hinzugefügt",
        "fr": "{count} photos sont ajoutées en arrière-plan",
        "es": "{count} fotos se añaden en segundo plano",
        "it": "{count} foto vengono aggiunte in background",
        "pt": "{count} fotos estão a ser adicionadas em segundo plano",
        "ru": "{count} фото добавляются в фоне",
        "ar": "يتم إضافة {count} صور في الخلفية",
        "ja": "{count} 枚の写真をバックグラウンドで追加しています",
        "ko": "사진 {count}장을 백그라운드에서 추가합니다",
        "zh": "正在后台添加 {count} 张照片",
    },
    "arkaPlandaIlerleme": {
        "tr": "{count}/{toplam} işlendi",
        "en": "{count} of {toplam} processed",
        "de": "{count} von {toplam} verarbeitet",
        "fr": "{count} sur {toplam} traités",
        "es": "{count} de {toplam} procesados",
        "it": "{count} di {toplam} elaborati",
        "pt": "{count} de {toplam} processados",
        "ru": "Обработано {count} из {toplam}",
        "ar": "تمت معالجة {count} من {toplam}",
        "ja": "{toplam} 件中 {count} 件を処理",
        "ko": "{toplam}개 중 {count}개 처리",
        "zh": "已处理 {count}/{toplam}",
    },
    "arkaPlandaTamamlandi": {
        "tr": "{count} parça dolabına eklendi",
        "en": "{count} pieces added to your wardrobe",
        "de": "{count} Teile wurden deiner Garderobe hinzugefügt",
        "fr": "{count} pièces ajoutées à ta garde-robe",
        "es": "{count} prendas añadidas a tu armario",
        "it": "{count} capi aggiunti al tuo guardaroba",
        "pt": "{count} peças adicionadas ao teu guarda-roupa",
        "ru": "{count} вещей добавлено в гардероб",
        "ar": "تمت إضافة {count} قطع إلى خزانتك",
        "ja": "{count} 点をワードローブに追加しました",
        "ko": "옷장에 {count}개 아이템을 추가했습니다",
        "zh": "已向衣橱添加 {count} 件单品",
    },
    "arkaPlandaBaziAtlandi": {
        "tr": "{count} fotoğraf işlenemedi",
        "en": "{count} photos could not be processed",
        "de": "{count} Fotos konnten nicht verarbeitet werden",
        "fr": "{count} photos n'ont pas pu être traitées",
        "es": "{count} fotos no se pudieron procesar",
        "it": "{count} foto non sono stati elaborati",
        "pt": "{count} fotos não puderam ser processadas",
        "ru": "{count} фото не удалось обработать",
        "ar": "تعذّرت معالجة {count} صور",
        "ja": "{count} 枚を処理できませんでした",
        "ko": "사진 {count}장을 처리하지 못했습니다",
        "zh": "{count} 张照片无法处理",
    },
}

SAYILI = ["arkaPlandaBasladi", "arkaPlandaTamamlandi", "arkaPlandaBaziAtlandi"]


def main():
    for anahtar, diller in METINLER.items():
        for dil, deger in sorted(diller.items()):
            yol = os.path.join(KLASOR, "app_%s.arb" % dil)
            with io.open(yol, encoding="utf-8") as f:
                veri = json.load(f)
            değişti = veri.get(anahtar) != deger
            if değişti:
                veri[anahtar] = deger
            if anahtar in SAYILI:
                meta = {"placeholders": {"count": {"type": "int"}}}
            elif anahtar == "arkaPlandaIlerleme":
                meta = {
                    "placeholders": {
                        "count": {"type": "int"},
                        "toplam": {"type": "int"},
                    }
                }
            else:
                meta = None
            if meta is not None and veri.get("@" + anahtar) != meta:
                veri["@" + anahtar] = meta
                değişti = True
            if değişti:
                with io.open(yol, "w", encoding="utf-8", newline="\n") as f:
                    json.dump(veri, f, ensure_ascii=False, indent=2)
                    f.write("\n")
        print("%s: tamam" % anahtar)
    return 0


if __name__ == "__main__":
    sys.exit(main())
