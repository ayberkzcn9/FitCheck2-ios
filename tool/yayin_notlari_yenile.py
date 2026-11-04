"""1.0.32 yayin notlarini tum yeni ozellikleri kapsayacak sekilde yazar.

Play siniri: dil basina 500 karakter. Script sonunda sayimi yazar.
"""
import io
import re

YOL = "yayin-notlari-1.0.32.md"

MADDELER = {
    "tr": [
        "Kesim kalitesi arttı, yeni AI modeli",
        "Yeni \"Bugün\" ekranı ve Kombin Düellosu",
        "Dolapta ara, kategoriye göre filtrele",
        "Takvimde bir güne kombin ata",
        "Planın Bugün kartında görünür, bildirimler onu okur",
        "Dolaba eklerken arka planı ve yerleşimi sen seç",
        "\"Arka planda ekle\": yükleme ekranı seni kilitlemez",
        "Bilgi düğmeleri her ölçütün ne anlama geldiğini anlatır",
        "Yeni \"Stil Günlüğüm\": takvim, günlük, haftalık rapor",
        "Yeni \"Seyahat Modu\": kapsül valiz planı",
    ],
    "en": [
        "Better cutouts, new AI model",
        "New \"Today\" screen and Outfit Duel",
        "Search your wardrobe and filter by category",
        "Assign an outfit to a day in the calendar",
        "Your plan shows on Today and in notifications",
        "Choose the background and placement when adding clothes",
        "\"Add in background\": the loading screen no longer blocks you",
        "Info buttons explain every metric",
        "New \"My Style Diary\": calendar, diary, weekly report",
        "New \"Travel Mode\": capsule packing plan",
    ],
    "it": [
        "Ritaglio più pulito, nuovo modello IA",
        "Nuove schermate \"Oggi\" e Duello di outfit",
        "Cerca nel guardaroba e filtra per categoria",
        "Assegna un outfit a un giorno nel calendario",
        "Il piano compare su Oggi e nelle notifiche",
        "Scegli sfondo e posizione quando aggiungi un capo",
        "\"Aggiungi in background\" non blocca lo schermo",
        "Le icone informazione spiegano ogni metrica",
        "Nuovo \"Il mio diario di stile\": calendario, diario, rapporto",
        "Nuova \"Modalità viaggio\": piano valigia a capsula",
    ],
    "es": [
        "Mejor recorte, nuevo modelo de IA",
        "Nuevas pantallas \"Hoy\" y Duelo de conjuntos",
        "Busca en tu armario y filtra por categoría",
        "Asigna un look a un día del calendario",
        "Tu plan aparece en Hoy y en las notificaciones",
        "Elige fondo y colocación al añadir prendas",
        "\"Añadir en segundo plano\" no bloquea la pantalla",
        "Los botones de información explican cada métrica",
        "Nuevo \"Mi diario de estilo\": calendario, diario, informe",
        "Nuevo \"Modo viaje\": plan de maleta cápsula",
    ],
    "zh": [
        "抠图质量提升，全新 AI 模型",
        "全新\"今天\"页面与穿搭对决",
        "衣橱支持搜索与分类筛选",
        "可在日历中为某一天指定穿搭",
        "计划显示在\"今天\"并用于通知",
        "添加衣物时可选择背景与摆放位置",
        "\"后台添加\"不再卡住加载界面",
        "信息按钮解释每项指标的含义",
        "请求相机权限前会先说明原因",
        "全新\"我的风格日记\"：日历、日记、周报",
        "全新\"旅行模式\"：胶囊打包方案",
    ],
    "ar": [
        "قص أنظف بنموذج ذكاء اصطناعي جديد",
        "شاشتان جديدتان: «اليوم» ومبارزة الإطلالات",
        "ابحث في خزانتك وفلتر حسب الفئة",
        "عيّن إطلالة ليوم في التقويم",
        "تظهر خطتك في «اليوم» وتستخدمها الإشعارات",
        "اختر الخلفية والتموضع عند إضافة الملابس",
        "«أضِف في الخلفية» لم يعد يجمّد الشاشة",
        "أزرار المعلومات تشرح كل مقياس",
        "نشرح لماذا نحتاج الكاميرا قبل طلبها",
        "جديد «مجلد أسلوبي»: تقويم ويوميات وتقرير",
        "جديد «وضع السفر»: خطة حقيبة كبسولة",
    ],
    "fr": [
        "Détourage plus net, nouveau modèle d'IA",
        "Nouveaux écrans « Aujourd'hui » et Duel de tenues",
        "Recherchez dans votre garde-robe, filtrez par catégorie",
        "Attribuez une tenue à un jour du calendrier",
        "Votre plan s'affiche sur Aujourd'hui et dans les notifs",
        "Choisissez fond et placement à l'ajout",
        "« Ajouter en arrière-plan » ne bloque rien",
        "Les boutons d'info expliquent les indicateurs",
        "« Mon carnet de style » : calendrier, journal, rapport",
        "Nouveau « Mode voyage » : plan de valise capsule",
    ],
    "de": [
        "Bessere Freistellung, neues KI-Modell",
        "Neue Bildschirme „Heute“ und Outfit-Duell",
        "Garderobe durchsuchen und filtern",
        "Outfit einem Kalendertag zuweisen",
        "Dein Plan erscheint auf Heute und in Benachrichtigungen",
        "Hintergrund und Platzierung beim Hinzufügen wählen",
        "„Im Hintergrund hinzufügen“ blockiert nicht mehr",
        "Info-Symbole erklären jede Kennzahl",
        "Neues „Mein Stil-Tagebuch“: Kalender, Tagebuch, Bericht",
        "Neuer „Reisemodus“: Capsule-Packplan",
    ],
    "pt": [
        "Recorte melhor, novo modelo de IA",
        "Novos ecrãs \"Hoje\" e Duelo de looks",
        "Pesquise e filtre o guarda-roupa por categoria",
        "Atribua um look a um dia no calendário",
        "O teu plano aparece em Hoje e nas notificações",
        "Escolhe fundo e colocação ao adicionar peças",
        "\"Adicionar em segundo plano\" não bloqueia o ecrã",
        "Os botões de informação explicam cada métrica",
        "Novo \"O meu diário de estilo\": calendário, diário, relatório",
        "Novo \"Modo viagem\": plano de mala cápsula",
    ],
    "ja": [
        "切り抜き品質が向上。新しい AI モデル",
        "新しい「今日」画面とコーデ対決",
        "ワードローブの検索とカテゴリ絞り込み",
        "カレンダーで日付にコーデを割り当て",
        "計画は「今日」と通知に反映",
        "追加時に背景と配置を選べます",
        "「バックグラウンドで追加」で画面が止まらない",
        "情報アイコンが指標の意味を説明",
        "カメラ権限の前に理由を説明します",
        "新しい「マイスタイル日記」：カレンダー、日記、週次レポート",
        "新しい「トラベルモード」：短期旅行のパッキング",
    ],
    "ko": [
        "누끼 품질 향상, 새로운 AI 모델",
        "새로운 \"오늘\" 화면과 코디 대결",
        "옷장 검색과 카테고리 필터",
        "캘린더에서 날짜에 코디 배정",
        "계획이 \"오늘\"과 알림에 반영",
        "추가할 때 배경과 위치를 선택",
        "\"백그라운드에서 추가\"로 화면이 멈추지 않음",
        "정보 버튼이 각 지표를 설명",
        "카메라 권한 전에 이유를 알려드림",
        "새로운 \"나의 스타일 다이어리\": 달력, 일지, 주간 리포트",
        "새로운 \"여행 모드\": 짧은 여행 짐 계획",
    ],
    "ru": [
        "Более чистое вырезание с новой моделью ИИ",
        "Новые экраны «Сегодня» и «Дуэль образов»",
        "Поиск по гардеробу и фильтр по категориям",
        "Назначь образ на день в календаре",
        "План виден в «Сегодня» и в уведомлениях",
        "Фон и расположение выбираются при добавлении",
        "«Добавить в фоне» больше не блокирует экран",
        "Кнопки-подсказки объясняют показатели",
        "Мы объясняем, зачем нужен доступ к камере",
        "Новый «Мой дневник стиля»: календарь, дневник, отчёт",
        "Новый «Режим путешествия»: капсульный план чемодана",
    ],
}

SINIR = 500

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
    satirlar[bas:bit] = ["• " + m for m in MADDELER[dil]]

s = ayrac.join(satirlar)

# Dil blokları arasında boş satır olsun (okunabilirlik).
satirlar = s.split(ayrac)
duzeltilmis = []
for satir in satirlar:
    if re.match(r"^## [a-z]{2}$", satir.strip()) and duzeltilmis and duzeltilmis[-1].strip() != "":
        duzeltilmis.append("")
    duzeltilmis.append(satir)
s = ayrac.join(duzeltilmis)

io.open(YOL, "w", encoding="utf-8", newline="").write(s)

satirlar = s.split(ayrac)
print("karakter sayilari (sinir %d):" % SINIR)
i = 0
while i < len(satirlar):
    m = re.match(r"^## ([a-z]{2})$", satirlar[i].strip())
    if m:
        dil = m.group(1)
        j = i + 1
        while j < len(satirlar) and not satirlar[j].startswith("## ") and satirlar[j].strip() != "---":
            j += 1
        govde = "\n".join(satirlar[i + 1:j]).strip()
        durum = "OK " if len(govde) <= SINIR else "!! "
        print("  %s%s: %d" % (durum, dil, len(govde)))
        i = j
    else:
        i += 1
