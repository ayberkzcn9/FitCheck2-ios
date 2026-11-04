"""Takvimde gune kombin atama - yayin notlari (12 dil), mevcut notlara eklenir."""

import io
import os
import re

YOL = "yayin-notlari-1.0.32.md"

MADDELER = {
    "tr": "• Takvimde bir güne kombin atayın; Bugün kartında planınız görünür",
    "en": "• Assign an outfit to a day in the calendar; your plan shows on Today",
    "it": "• Assegna un outfit a un giorno nel calendario; il piano compare su Oggi",
    "es": "• Asigna un look a un día del calendario; tu plan aparece en Hoy",
    "zh": "• 可在日历中为某一天指定穿搭，计划会显示在“今天”",
    "ar": "• عيّن إطلالة ليوم في التقويم؛ ستظهر خطتك في «اليوم»",
    "fr": "• Attribuez une tenue à un jour du calendrier ; votre plan s'affiche sur Aujourd'hui",
    "de": "• Outfit im Kalender einem Tag zuweisen; dein Plan erscheint auf Heute",
    "pt": "• Atribui um look a um dia no calendário; o teu plano aparece em Hoje",
    "ja": "• カレンダーで日付にコーデを割り当てると「今日」に表示されます",
    "ko": "• 캘린더에서 날짜에 코디를 지정하면 오늘에 표시됩니다",
    "ru": "• Назначь образ на день в календаре — план появится в «Сегодня»",
}

ham = io.open(YOL, encoding="utf-8", newline="").read()
ayrac = "\r\n" if "\r\n" in ham else "\n"
satirlar = ham.split(ayrac)

bloklar = []
i = 0
while i < len(satirlar):
    m = re.match(r"^## ([a-z]{2})$", satirlar[i].strip())
    if m:
        dil = m.group(1)
        j = i + 1
        while j < len(satirlar) and not satirlar[j].startswith("## ") and satirlar[j].strip() != "---":
            j += 1
        bloklar.append((dil, i + 1, j))
        i = j
    else:
        i += 1

for dil, bas, bit in reversed(bloklar):
    if dil not in MADDELER:
        continue
    if any(MADDELER[dil] in s for s in satirlar[bas:bit]):
        continue
    satirlar.insert(bas, MADDELER[dil])

s = ayrac.join(satirlar)
io.open(YOL, "w", encoding="utf-8", newline="").write(s)

# Karakter sayimi
print("karakter sayilari:")
i = 0
satirlar = s.split(ayrac)
while i < len(satirlar):
    m = re.match(r"^## ([a-z]{2})$", satirlar[i].strip())
    if m:
        dil = m.group(1)
        j = i + 1
        while j < len(satirlar) and not satirlar[j].startswith("## ") and satirlar[j].strip() != "---":
            j += 1
        govde = "\n".join(satirlar[i + 1:j]).strip()
        print("  %s: %d" % (dil, len(govde)))
        i = j
    else:
        i += 1
