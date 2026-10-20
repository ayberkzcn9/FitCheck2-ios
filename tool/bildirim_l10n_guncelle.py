"""Aksam plan hatirlaticisi + kisisel sabah bildirimi metinlerini 12 ARB'ye ekler.

Idempotent: anahtar zaten varsa deger guncellenir, yoksa sona eklenir.
Calistirdiktan sonra `flutter gen-l10n` gerekir.
"""

import io
import json
import os
import sys

KLASOR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "lib", "l10n")

YER_TUTUCU = ("bildirimSabahKombin", "bildirimPlanKombin")

METINLER = {
    "tr": {
        "bildirimSabahKombin": "Bugünkü kombinin hazır: {kombin}. Görmek için dokun.",
        "bildirimPlanBaslik": "Yarınki kombinin hazır",
        "bildirimPlanKombin": "Yarın için: {kombin}. Şimdi bak, sabah acele etme.",
        "bildirimPlanBos": "Yarın için henüz kombin yok. 2 dakikada planla.",
        "planHatirlatimiAyar": "Akşam plan hatırlatıcısı",
        "planHatirlatimiAyarAciklama": "Yarınki kombinini akşam 21:00'de hatırlatır",
    },
    "en": {
        "bildirimSabahKombin": "Today's outfit is ready: {kombin}. Tap to see it.",
        "bildirimPlanBaslik": "Tomorrow's outfit is ready",
        "bildirimPlanKombin": "For tomorrow: {kombin}. Take a look now, no rush in the morning.",
        "bildirimPlanBos": "No outfit planned for tomorrow yet. Plan it in 2 minutes.",
        "planHatirlatimiAyar": "Evening plan reminder",
        "planHatirlatimiAyarAciklama": "Reminds you of tomorrow's outfit at 21:00",
    },
    "de": {
        "bildirimSabahKombin": "Dein Outfit für heute ist fertig: {kombin}. Zum Ansehen tippen.",
        "bildirimPlanBaslik": "Dein Outfit für morgen ist fertig",
        "bildirimPlanKombin": "Für morgen: {kombin}. Schon jetzt ansehen, morgens keine Eile.",
        "bildirimPlanBos": "Für morgen ist noch kein Outfit geplant. In 2 Minuten planen.",
        "planHatirlatimiAyar": "Abend-Erinnerung",
        "planHatirlatimiAyarAciklama": "Erinnert dich um 21:00 an das Outfit für morgen",
    },
    "fr": {
        "bildirimSabahKombin": "Ta tenue du jour est prête : {kombin}. Touche pour la voir.",
        "bildirimPlanBaslik": "Ta tenue de demain est prête",
        "bildirimPlanKombin": "Pour demain : {kombin}. Regarde maintenant, pas de rush le matin.",
        "bildirimPlanBos": "Aucune tenue prévue pour demain. Planifie-la en 2 minutes.",
        "planHatirlatimiAyar": "Rappel du soir",
        "planHatirlatimiAyarAciklama": "Te rappelle la tenue de demain à 21h00",
    },
    "es": {
        "bildirimSabahKombin": "Tu look de hoy está listo: {kombin}. Toca para verlo.",
        "bildirimPlanBaslik": "Tu look de mañana está listo",
        "bildirimPlanKombin": "Para mañana: {kombin}. Míralo ahora, sin prisas por la mañana.",
        "bildirimPlanBos": "Aún no hay look para mañana. Planifícalo en 2 minutos.",
        "planHatirlatimiAyar": "Recordatorio de la tarde",
        "planHatirlatimiAyarAciklama": "Te recuerda el look de mañana a las 21:00",
    },
    "it": {
        "bildirimSabahKombin": "Il tuo outfit di oggi è pronto: {kombin}. Tocca per vederlo.",
        "bildirimPlanBaslik": "Il tuo outfit di domani è pronto",
        "bildirimPlanKombin": "Per domani: {kombin}. Guardalo ora, niente fretta la mattina.",
        "bildirimPlanBos": "Nessun outfit pianificato per domani. Pianificalo in 2 minuti.",
        "planHatirlatimiAyar": "Promemoria serale",
        "planHatirlatimiAyarAciklama": "Ti ricorda l'outfit di domani alle 21:00",
    },
    "pt": {
        "bildirimSabahKombin": "O teu look de hoje está pronto: {kombin}. Toca para ver.",
        "bildirimPlanBaslik": "O teu look de amanhã está pronto",
        "bildirimPlanKombin": "Para amanhã: {kombin}. Vê agora, sem pressa de manhã.",
        "bildirimPlanBos": "Ainda não há look para amanhã. Planeia em 2 minutos.",
        "planHatirlatimiAyar": "Lembrete da noite",
        "planHatirlatimiAyarAciklama": "Lembra-te do look de amanhã às 21:00",
    },
    "ru": {
        "bildirimSabahKombin": "Твой образ на сегодня готов: {kombin}. Нажми, чтобы посмотреть.",
        "bildirimPlanBaslik": "Твой образ на завтра готов",
        "bildirimPlanKombin": "На завтра: {kombin}. Посмотри сейчас, утром не будет спешки.",
        "bildirimPlanBos": "На завтра образ ещё не запланирован. Спланируй за 2 минуты.",
        "planHatirlatimiAyar": "Вечернее напоминание",
        "planHatirlatimiAyarAciklama": "Напомнит об образе на завтра в 21:00",
    },
    "ar": {
        "bildirimSabahKombin": "إطلالتك لهذا اليوم جاهزة: {kombin}. اضغط للعرض.",
        "bildirimPlanBaslik": "إطلالتك ليوم غد جاهزة",
        "bildirimPlanKombin": "لغد: {kombin}. ألقِ نظرة الآن، بلا عجلة في الصباح.",
        "bildirimPlanBos": "لا توجد إطلالة مخطط لها لغد بعد. خططها في دقيقتين.",
        "planHatirlatimiAyar": "تذكير مسائي",
        "planHatirlatimiAyarAciklama": "يذكّرك بإطلالة الغد الساعة 21:00",
    },
    "ja": {
        "bildirimSabahKombin": "今日のコーデができました：{kombin}。タップして見る。",
        "bildirimPlanBaslik": "明日のコーデができました",
        "bildirimPlanKombin": "明日は：{kombin}。今のうちにチェックして、朝はゆっくり。",
        "bildirimPlanBos": "明日のコーデはまだ未定です。2分で計画しましょう。",
        "planHatirlatimiAyar": "夜のプラン通知",
        "planHatirlatimiAyarAciklama": "明日のコーデを21:00にお知らせします",
    },
    "ko": {
        "bildirimSabahKombin": "오늘의 코디가 준비됐어요: {kombin}. 눌러서 확인하세요.",
        "bildirimPlanBaslik": "내일의 코디가 준비됐어요",
        "bildirimPlanKombin": "내일은: {kombin}. 지금 확인하고 아침엔 여유롭게.",
        "bildirimPlanBos": "내일 코디가 아직 없어요. 2분이면 계획할 수 있어요.",
        "planHatirlatimiAyar": "저녁 플랜 알림",
        "planHatirlatimiAyarAciklama": "내일의 코디를 21:00에 알려드려요",
    },
    "zh": {
        "bildirimSabahKombin": "今天的穿搭已就绪：{kombin}。点击查看。",
        "bildirimPlanBaslik": "明天的穿搭已就绪",
        "bildirimPlanKombin": "明天：{kombin}。现在看看，早上不慌。",
        "bildirimPlanBos": "明天还没有穿搭计划。两分钟就能安排。",
        "planHatirlatimiAyar": "晚间计划提醒",
        "planHatirlatimiAyarAciklama": "21:00 提醒你明天的穿搭",
    },
}


def metadata(anahtar):
    return {"placeholders": {"kombin": {"type": "String"}}}


def ekle(yol, metinler):
    with io.open(yol, encoding="utf-8") as f:
        veri = json.load(f)
    eklenen = 0
    for anahtar, deger in metinler.items():
        if veri.get(anahtar) != deger:
            eklenen += 1
        veri[anahtar] = deger
        if anahtar in YER_TUTUCU:
            veri["@" + anahtar] = metadata(anahtar)
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
        print("%s: %d metin guncellendi" % (dil, n))
    print("\ntoplam %d" % toplam)
    return 0


if __name__ == "__main__":
    sys.exit(main())
