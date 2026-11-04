"""Kombin paylasim metinlerini 12 ARB'ye ekler.

Idempotent. Calistirdiktan sonra `flutter gen-l10n` gerekir.
"""

import io
import json
import os
import sys

KLASOR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "lib", "l10n")

METINLER = {
    "tr": {
        "bugunPaylas": "Kombini paylaş",
        "bugunPaylasMetni": "Bugünkü kombini FitCheck'te hazırladım ✨",
        "bugunPaylasHata": "Paylaşım açılamadı. Tekrar dene.",
    },
    "en": {
        "bugunPaylas": "Share outfit",
        "bugunPaylasMetni": "I put today's outfit together with FitCheck ✨",
        "bugunPaylasHata": "Couldn't open sharing. Try again.",
    },
    "de": {
        "bugunPaylas": "Outfit teilen",
        "bugunPaylasMetni": "Mein heutiges Outfit habe ich mit FitCheck zusammengestellt ✨",
        "bugunPaylasHata": "Teilen konnte nicht geöffnet werden. Versuch es erneut.",
    },
    "fr": {
        "bugunPaylas": "Partager la tenue",
        "bugunPaylasMetni": "J'ai composé ma tenue du jour avec FitCheck ✨",
        "bugunPaylasHata": "Impossible d'ouvrir le partage. Réessaie.",
    },
    "es": {
        "bugunPaylas": "Compartir look",
        "bugunPaylasMetni": "He preparado mi look de hoy con FitCheck ✨",
        "bugunPaylasHata": "No se pudo abrir compartir. Inténtalo de nuevo.",
    },
    "it": {
        "bugunPaylas": "Condividi outfit",
        "bugunPaylasMetni": "Ho creato il mio outfit di oggi con FitCheck ✨",
        "bugunPaylasHata": "Impossibile aprire la condivisione. Riprova.",
    },
    "pt": {
        "bugunPaylas": "Partilhar look",
        "bugunPaylasMetni": "Combinei o meu look de hoje no FitCheck ✨",
        "bugunPaylasHata": "Não foi possível abrir a partilha. Tenta de novo.",
    },
    "ru": {
        "bugunPaylas": "Поделиться образом",
        "bugunPaylasMetni": "Собрал(а) сегодняшний образ в FitCheck ✨",
        "bugunPaylasHata": "Не удалось открыть меню «Поделиться». Попробуй ещё раз.",
    },
    "ar": {
        "bugunPaylas": "شارك الإطلالة",
        "bugunPaylasMetni": "نسّقت إطلالة اليوم عبر FitCheck ✨",
        "bugunPaylasHata": "تعذّر فتح المشاركة. حاول مرة أخرى.",
    },
    "ja": {
        "bugunPaylas": "コーデをシェア",
        "bugunPaylasMetni": "今日のコーデはFitCheckで組みました ✨",
        "bugunPaylasHata": "共有を開けませんでした。もう一度お試しください。",
    },
    "ko": {
        "bugunPaylas": "코디 공유",
        "bugunPaylasMetni": "오늘의 코디는 FitCheck로 완성했어요 ✨",
        "bugunPaylasHata": "공유를 열 수 없어요. 다시 시도해 주세요.",
    },
    "zh": {
        "bugunPaylas": "分享穿搭",
        "bugunPaylasMetni": "今天的穿搭是用 FitCheck 搭配的 ✨",
        "bugunPaylasHata": "无法打开分享，请重试。",
    },
}


def ekle(yol, metinler):
    with io.open(yol, encoding="utf-8") as f:
        veri = json.load(f)
    eklenen = 0
    for anahtar, deger in metinler.items():
        if veri.get(anahtar) != deger:
            eklenen += 1
        veri[anahtar] = deger
    if eklenen:
        with io.open(yol, "w", encoding="utf-8", newline="\n") as f:
            json.dump(veri, f, ensure_ascii=False, indent=2)
            f.write("\n")
    return eklenen


def main():
    toplam = 0
    for dil, metinler in METINLER.items():
        yol = os.path.join(KLASOR, "app_%s.arb" % dil)
        if not os.path.exists(yol):
            print("YOK: %s" % yol)
            return 1
        n = ekle(yol, metinler)
        toplam += n
        print("%s: %d metin" % (dil, n))
    print("\ntoplam %d" % toplam)
    return 0


if __name__ == "__main__":
    sys.exit(main())
