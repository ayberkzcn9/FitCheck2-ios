"""Takvim planlama metinleri - 12 dil. Idempotent; sonra `flutter gen-l10n`."""

import io
import json
import os
import sys

KLASOR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "lib", "l10n")

METINLER = {
    "planGuneKombinSec": {
        "tr": "Bu güne kombin seç",
        "en": "Choose an outfit for this day",
        "de": "Outfit für diesen Tag wählen",
        "fr": "Choisir une tenue pour ce jour",
        "es": "Elegir un look para este día",
        "it": "Scegli un outfit per questo giorno",
        "pt": "Escolher um look para este dia",
        "ru": "Выбрать образ на этот день",
        "ar": "اختر إطلالة لهذا اليوم",
        "ja": "この日のコーデを選ぶ",
        "ko": "이 날의 코디 선택",
        "zh": "为此日选择穿搭",
    },
    "planKombinSec": {
        "tr": "Kombin seç",
        "en": "Pick an outfit",
        "de": "Outfit wählen",
        "fr": "Choisir une tenue",
        "es": "Elegir un look",
        "it": "Scegli un outfit",
        "pt": "Escolher um look",
        "ru": "Выбрать образ",
        "ar": "اختر إطلالة",
        "ja": "コーデを選ぶ",
        "ko": "코디 선택",
        "zh": "选择穿搭",
    },
    "planDegistir": {
        "tr": "Değiştir",
        "en": "Change",
        "de": "Ändern",
        "fr": "Modifier",
        "es": "Cambiar",
        "it": "Cambia",
        "pt": "Alterar",
        "ru": "Изменить",
        "ar": "تغيير",
        "ja": "変更",
        "ko": "변경",
        "zh": "更换",
    },
    "planKaldir": {
        "tr": "Kaldır",
        "en": "Remove",
        "de": "Entfernen",
        "fr": "Retirer",
        "es": "Quitar",
        "it": "Rimuovi",
        "pt": "Remover",
        "ru": "Убрать",
        "ar": "إزالة",
        "ja": "削除",
        "ko": "삭제",
        "zh": "移除",
    },
    "planFavoriYok": {
        "tr": "Henüz favori kombinin yok.",
        "en": "No favourite outfits yet.",
        "de": "Noch keine Lieblings-Outfits.",
        "fr": "Aucune tenue favorite pour l'instant.",
        "es": "Aún no tienes looks favoritos.",
        "it": "Nessun outfit preferito.",
        "pt": "Ainda não tens looks favoritos.",
        "ru": "Пока нет избранных образов.",
        "ar": "لا توجد إطلالات مفضلة بعد.",
        "ja": "お気に入りのコーデはまだありません。",
        "ko": "아직 즐겨찾기 코디가 없습니다.",
        "zh": "还没有收藏的穿搭。",
    },
    "planKombinOlustur": {
        "tr": "Kombin oluştur",
        "en": "Create an outfit",
        "de": "Outfit erstellen",
        "fr": "Créer une tenue",
        "es": "Crear un look",
        "it": "Crea un outfit",
        "pt": "Criar um look",
        "ru": "Создать образ",
        "ar": "أنشئ إطلالة",
        "ja": "コーデを作る",
        "ko": "코디 만들기",
        "zh": "创建穿搭",
    },
    "planGuneEklendi": {
        "tr": "Kombin güne eklendi",
        "en": "Outfit added to the day",
        "de": "Outfit zum Tag hinzugefügt",
        "fr": "Tenue ajoutée au jour",
        "es": "Look añadido al día",
        "it": "Outfit aggiunto al giorno",
        "pt": "Look adicionado ao dia",
        "ru": "Образ добавлен на день",
        "ar": "تمت إضافة الإطلالة إلى اليوم",
        "ja": "コーデをこの日に追加しました",
        "ko": "코디를 이 날에 추가했습니다",
        "zh": "已将穿搭添加到该日",
    },
    "planKaldirildi": {
        "tr": "Plan kaldırıldı",
        "en": "Plan removed",
        "de": "Plan entfernt",
        "fr": "Plan retiré",
        "es": "Plan eliminado",
        "it": "Piano rimosso",
        "pt": "Plano removido",
        "ru": "План убран",
        "ar": "تمت إزالة الخطة",
        "ja": "予定を削除しました",
        "ko": "일정을 삭제했습니다",
        "zh": "已移除计划",
    },
    "planHaftalikProgram": {
        "tr": "Haftalık program",
        "en": "Weekly schedule",
        "de": "Wochenplan",
        "fr": "Programme hebdomadaire",
        "es": "Programa semanal",
        "it": "Programma settimanale",
        "pt": "Programa semanal",
        "ru": "Недельный план",
        "ar": "البرنامج الأسبوعي",
        "ja": "週間スケジュール",
        "ko": "주간 스케줄",
        "zh": "每周计划",
    },
}

SAYILI = {
    "planParcaSayisi": {
        "tr": "{count} parça",
        "en": "{count} pieces",
        "de": "{count} Teile",
        "fr": "{count} pièces",
        "es": "{count} prendas",
        "it": "{count} capi",
        "pt": "{count} peças",
        "ru": "{count} вещей",
        "ar": "{count} قطع",
        "ja": "{count} 点",
        "ko": "{count}개",
        "zh": "{count} 件",
    }
}


def ekle(veri, anahtar, deger, meta=None):
    if veri.get(anahtar) != deger:
        veri[anahtar] = deger
    if meta is not None and veri.get("@" + anahtar) != meta:
        veri["@" + anahtar] = meta


def main():
    for anahtar, diller in METINLER.items():
        for dil, deger in sorted(diller.items()):
            yol = os.path.join(KLASOR, "app_%s.arb" % dil)
            with io.open(yol, encoding="utf-8") as f:
                veri = json.load(f)
            ekle(veri, anahtar, deger)
            with io.open(yol, "w", encoding="utf-8", newline="\n") as f:
                json.dump(veri, f, ensure_ascii=False, indent=2)
                f.write("\n")
        print("%s: tamam" % anahtar)

    meta = {"placeholders": {"count": {"type": "int"}}}
    for anahtar, diller in SAYILI.items():
        for dil, deger in sorted(diller.items()):
            yol = os.path.join(KLASOR, "app_%s.arb" % dil)
            with io.open(yol, encoding="utf-8") as f:
                veri = json.load(f)
            ekle(veri, anahtar, deger, meta)
            with io.open(yol, "w", encoding="utf-8", newline="\n") as f:
                json.dump(veri, f, ensure_ascii=False, indent=2)
                f.write("\n")
        print("%s: tamam" % anahtar)
    return 0


if __name__ == "__main__":
    sys.exit(main())
