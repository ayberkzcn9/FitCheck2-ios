"""Diger ekranlardaki bilgi metinleri - 12 dil. Idempotent; sonra `flutter gen-l10n`."""

import io
import json
import os
import sys

KLASOR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "lib", "l10n")

METINLER = {
    "bilgiBugunKombini": {
        "tr": "Bugünün kombini, dolabın ve hava durumu dikkate alınarak seçilir. Günde en fazla bir yapay zekâ isteği yapılır ve sonuç gün boyunca saklanır; yapay zekâ kullanılamazsa kural bazlı öneriler devreye girer.",
        "en": "Your outfit of the day is picked from your wardrobe and the weather. At most one AI request is made per day and the result is kept for the day; if the AI is unavailable, rule-based suggestions take over.",
        "de": "Dein Outfit des Tages wird aus deiner Garderobe und dem Wetter gewählt. Pro Tag wird höchstens eine KI-Anfrage gestellt und das Ergebnis für den Tag gespeichert; fällt die KI aus, übernehmen regelbasierte Vorschläge.",
        "fr": "La tenue du jour est choisie dans ta garde-robe selon la météo. Au plus une requête IA par jour est faite et le résultat est gardé pour la journée ; sans IA, des suggestions par règles prennent le relais.",
        "es": "Tu look del día se elige de tu armario según el tiempo. Se hace como máximo una petición a la IA al día y el resultado se guarda para el día; si la IA no está disponible, mandan las sugerencias por reglas.",
        "it": "L'outfit di oggi è scelto dal tuo guardaroba in base al meteo. Al massimo una richiesta all'IA al giorno e il risultato viene conservato per la giornata; se l'IA non è disponibile subentrano i suggerimenti a regole.",
        "pt": "O teu look do dia é escolhido no guarda-roupa com base no tempo. É feito no máximo um pedido à IA por dia e o resultado fica guardado para o dia; se a IA não estiver disponível, entram as sugestões por regras.",
        "ru": "Образ дня выбирается из гардероба с учётом погоды. В день выполняется не более одного запроса к ИИ, результат сохраняется на день; если ИИ недоступна, работают предложения по правилам.",
        "ar": "يُختار إطلالة اليوم من خزانتك حسب حالة الطقس. يُجرى طلب واحد فقط إلى الذكاء الاصطناعي يوميًا وتُحفظ النتيجة طوال اليوم، وإذا تعذّر الذكاء الاصطناعي تتولى الاقتراحات القائمة على القواعد المهمة.",
        "ja": "今日のコーデは、ワードローブと天気から選ばれます。1日につきAIへの問い合わせは最大1回で、結果は当日中保持されます。AIが使えない場合はルールベースの提案に切り替わります。",
        "ko": "오늘의 코디는 옷장과 날씨를 바탕으로 고릅니다. 하루에 AI 요청은 최대 한 번만 하고 결과는 그날 동안 유지됩니다. AI를 쓸 수 없으면 규칙 기반 제안이 대신합니다.",
        "zh": "今日的穿搭会根据衣橱和天气挑选。每天最多请求一次 AI，结果当天保留；AI 不可用时改用规则生成的建议。",
    },
    "bilgiRaporHafta": {
        "tr": "Son 7 günde kaydettiğin kombin sayısı. Her «bugün giydim» işaretlemen bir kombin olarak sayılır; aynı güne birden fazla kombin kaydedebilirsin.",
        "en": "The number of outfits you recorded in the last 7 days. Every “worn today” mark counts as one outfit; you can record several outfits on the same day.",
        "de": "Die Anzahl der in den letzten 7 Tagen erfassten Outfits. Jedes „Heute getragen“ zählt als ein Outfit; du kannst an einem Tag mehrere Outfits erfassen.",
        "fr": "Le nombre de tenues enregistrées sur les 7 derniers jours. Chaque « porté aujourd'hui » compte pour une tenue ; tu peux en enregistrer plusieurs le même jour.",
        "es": "El número de looks que has registrado en los últimos 7 días. Cada «me lo puse hoy» cuenta como un look; puedes registrar varios el mismo día.",
        "it": "Il numero di outfit registrati negli ultimi 7 giorni. Ogni «indossato oggi» conta come un outfit; puoi registrarne più di uno lo stesso giorno.",
        "pt": "O número de looks que registaste nos últimos 7 dias. Cada «usei hoje» conta como um look; podes registar vários no mesmo dia.",
        "ru": "Количество образов, записанных за последние 7 дней. Каждая отметка «ношу сегодня» считается одним образом; в один день можно записать несколько.",
        "ar": "عدد الإطلالات التي سجّلتها في آخر 7 أيام. كل علامة «ارتديته اليوم» تُحتسب إطلالة واحدة، ويمكنك تسجيل أكثر من إطلالة في اليوم نفسه.",
        "ja": "過去7日に記録した着数。「今日着た」を押すたびに1着として数え、同じ日に何着でも記録できます。",
        "ko": "최근 7일 동안 기록한 코디 수예요. ‘오늘 입었어요’를 누를 때마다 한 건으로 세고, 같은 날 여러 개를 기록할 수 있습니다.",
        "zh": "最近 7 天记录的穿搭数量。每次标记「今天穿了」算一套，同一天可以记录多套。",
    },
    "bilgiRaporDortHafta": {
        "tr": "Son 4 haftanın haftalık kombin sayıları. Grafik, haftalık düzeni ve artıp azalışı gösterir.",
        "en": "The number of outfits per week over the last 4 weeks. The chart shows your weekly rhythm and whether it is rising or falling.",
        "de": "Die Outfit-Zahlen der letzten 4 Wochen. Das Diagramm zeigt deinen Wochenrhythmus und ob er steigt oder fällt.",
        "fr": "Le nombre de tenues par semaine sur les 4 dernières semaines. Le graphique montre ton rythme hebdomadaire et s'il augmente ou diminue.",
        "es": "El número de looks por semana de las últimas 4 semanas. El gráfico muestra tu ritmo semanal y si sube o baja.",
        "it": "Il numero di outfit a settimana nelle ultime 4 settimane. Il grafico mostra il tuo ritmo settimanale e se è in aumento o in calo.",
        "pt": "O número de looks por semana nas últimas 4 semanas. O gráfico mostra o teu ritmo semanal e se está a subir ou a descer.",
        "ru": "Количество образов по неделям за последние 4 недели. График показывает ваш недельный ритм и растёт он или падает.",
        "ar": "عدد الإطلالات لكل أسبوع في آخر 4 أسابيع. يوضح الرسم إيقاعك الأسبوعي وهل هو في ارتفاع أم انخفاض.",
        "ja": "直近4週間の週ごとの着用数。グラフは週のリズムと増減を示します。",
        "ko": "최근 4주 동안의 주별 코디 수예요. 그래프는 주간 리듬과 증가·감소를 보여줍니다.",
        "zh": "最近 4 周每周的穿搭数量。图表显示你的每周节奏是上升还是下降。",
    },
    "bilgiRaporEnCokParcalar": {
        "tr": "Bu hafta en çok giyilen parçalar. Sık kullanılan parçalar gardırobunun omurgasıdır.",
        "en": "The pieces you wore most this week. Frequently worn pieces are the backbone of your wardrobe.",
        "de": "Die in dieser Woche am häufigsten getragenen Teile. Oft getragene Teile sind das Rückgrat deiner Garderobe.",
        "fr": "Les pièces les plus portées cette semaine. Les pièces fréquentes sont la colonne vertébrale de ta garde-robe.",
        "es": "Las prendas que más llevas esta semana. Las prendas más usadas son la base de tu armario.",
        "it": "I capi più indossati questa settimana. I capi frequenti sono la spina dorsale del guardaroba.",
        "pt": "As peças que mais usaste esta semana. As peças mais usadas são a espinha dorsal do guarda-roupa.",
        "ru": "Вещи, которые вы носили чаще всего на этой неделе. Часто надетые вещи — основа гардероба.",
        "ar": "القطع التي ارتديتها أكثر هذا الأسبوع. القطع كثيرة الاستخدام هي عمود خزانتك الفقري.",
        "ja": "今週いちばん着たアイテム。着回しの多いアイテムはワードローブの背骨です。",
        "ko": "이번 주에 가장 많이 입은 아이템이에요. 자주 입는 아이템이 옷장의 뼈대입니다.",
        "zh": "本周穿得最多的单品。常穿的单品是衣橱的骨干。",
    },
    "bilgiRaporKullanim": {
        "tr": "Dolabındaki parçaların ne kadarının son 7 günde kullanıldığı. Düşükse bazı parçalar henüz kombine girmemiş demektir.",
        "en": "The share of your wardrobe used in the last 7 days. A low value means some pieces have not made it into an outfit yet.",
        "de": "Der Anteil deiner Garderobe, der in den letzten 7 Tagen genutzt wurde. Ein niedriger Wert heißt, dass manche Teile noch in keinem Outfit waren.",
        "fr": "La part de ta garde-robe utilisée sur les 7 derniers jours. Une valeur basse signifie que certaines pièces n'ont pas encore intégré une tenue.",
        "es": "La parte de tu armario usada en los últimos 7 días. Un valor bajo significa que algunas prendas aún no han entrado en ningún look.",
        "it": "La quota del guardaroba usata negli ultimi 7 giorni. Un valore basso significa che alcuni capi non sono ancora entrati in un outfit.",
        "pt": "A parte do guarda-roupa usada nos últimos 7 dias. Um valor baixo significa que algumas peças ainda não entraram num look.",
        "ru": "Доля гардероба, использованная за последние 7 дней. Низкое значение означает, что некоторые вещи ещё не попали в образ.",
        "ar": "نسبة خزانتك المستخدمة في آخر 7 أيام. القيمة المنخفضة تعني أن بعض القطع لم تدخل في إطلالة بعد.",
        "ja": "直近7日に使ったワードローブの割合。低い場合は、まだ一度も着那した組み合わせに入っていないことを意味します。",
        "ko": "최근 7일 동안 사용한 옷장의 비율이에요. 낮으면 아직 어떤 코디에도 들어가지 않은 아이템이 있다는 뜻입니다.",
        "zh": "最近 7 天使用过的衣橱占比。数值偏低说明有些单品还没进入过任何搭配。",
    },
    "bilgiRaporSeri": {
        "tr": "Üst üste giydiğin gün sayısı. Her gün bir kombin kaydedersen artar, bir gün boşluk bırakırsan sıfırlanır.",
        "en": "The number of days you have dressed in a row. It grows whenever you record an outfit and resets after a missed day.",
        "de": "Die Zahl der Tage, an denen du hintereinander etwas getragen hast. Sie steigt bei jedem erfassten Outfit und setzt nach einem ausgelassenen Tag zurück.",
        "fr": "Le nombre de jours consécutifs où tu t'es habillé. Il augmente à chaque tenue enregistrée et repart à zéro après un jour manqué.",
        "es": "El número de días seguidos que te has vestido. Aumenta cada vez que registras un look y se reinicia si se te pasa un día.",
        "it": "Il numero di giorni consecutivi in cui ti sei vestito. Aumenta a ogni outfit registrato e si azzera dopo un giorno saltato.",
        "pt": "O número de dias seguidos em que te vestiste. Aumenta sempre que registas um look e reinicia se saltares um dia.",
        "ru": "Число дней подряд, когда вы надевали одежду. Растёт с каждой записью образа и обнуляется после пропущенного дня.",
        "ar": "عدد الأيام المتتالية التي ارتديت فيها ملابس. يزيد مع كل إطلالة مسجّلة ويُصفَّر بعد يوم فائت.",
        "ja": "続けて着た日数。着た組み合わせを記録するたびに増え、1日飛ばすとリセットされます。",
        "ko": "연속으로 입은 날짜 수예요. 코디를 기록할 때마다 늘어나고 하루를 건너뛰면 초기화됩니다.",
        "zh": "连续穿着的天数。每记录一套穿搭就增加，漏掉一天即归零。",
    },
    "bilgiRaporHicGiyilmemis": {
        "tr": "Son 7 günde hiç giyilmemiş parça sayısı. Bu parçalar yeni kombinlerle yeniden kullanılabilir.",
        "en": "The number of pieces not worn at all in the last 7 days. You can put these back to use with new outfits.",
        "de": "Die Anzahl der Teile, die in den letzten 7 Tagen gar nicht getragen wurden. Mit neuen Outfits kannst du sie wieder einsetzen.",
        "fr": "Le nombre de pièces non portées du tout sur les 7 derniers jours. Tu peux les remettre en jeu avec de nouvelles tenues.",
        "es": "El número de prendas que no has lucido en los últimos 7 días. Puedes volver a usarlas con nuevos looks.",
        "it": "Il numero di capi non indossati affatto negli ultimi 7 giorni. Puoi rimetterli in gioco con nuovi outfit.",
        "pt": "O número de peças que não usaste nos últimos 7 dias. Podes voltar a usá-las com novos looks.",
        "ru": "Количество вещей, которые вообще не надевали за последние 7 дней. Их можно вернуть в оборот с новыми образами.",
        "ar": "عدد القطع التي لم تُرتدى إطلاقًا في آخر 7 أيام. يمكنك إعادتها إلى الاستخدام مع إطلالات جديدة.",
        "ja": "直近7日に一度も着ていないアイテムの数。新しいの組み合わせで 다시着られます。",
        "ko": "최근 7일 동안 한 번도 입지 않은 아이템 수예요. 새 코디로 다시 입어볼 수 있습니다.",
        "zh": "最近 7 天一次都没穿过的单品数量。可以用新搭配重新让它们派上用场。",
    },
    "bilgiDueloPuan": {
        "tr": "Her soruda iki kombin arasından seçim yaparsın. Doğru cevap puan ve seri kazandırır, yanlış cevap seriyi sıfırlar. Puanlama kural tabanlıdır: renk uyumu, kategori dengesi ve mevsim tutarlılığı ölçülür. Dolabında 4'ten az parça varsa geçmiş kombinlerden bir palet oluşturulur.",
        "en": "Each round shows two outfits and you pick one. A correct answer earns points and builds your streak; a wrong one resets the streak. Scoring is rule-based: colour harmony, category balance and seasonal consistency are measured. If your wardrobe has fewer than 4 pieces, a palette is built from your past outfits.",
        "de": "In jeder Runde siehst du zwei Outfits und wählst eines. Eine richtige Antwort bringt Punkte und eine Serie, eine falsche setzt die Serie zurück. Die Wertung ist regelbasiert: Farbharmonie, Kategoriebalance und Saisonkonsistenz werden gemessen. Hat deine Garderobe weniger als 4 Teile, wird eine Palette aus früheren Outfits gebildet.",
        "fr": "À chaque manche, deux tenues te sont proposées et tu en choisis une. Une bonne réponse rapporte des points et fait monter la série, une mauvaise la remet à zéro. Le score suit des règles : harmonie des couleurs, équilibre des catégories et cohérence de saison. Si ta garde-robe compte moins de 4 pièces, une palette est construite à partir de tes anciennes tenues.",
        "es": "En cada ronda ves dos looks y eliges uno. Acertar da puntos y mantiene la racha; fallar la reinicia. La puntuación sigue reglas: armonía de color, equilibrio de categorías y coherencia de temporada. Si tu armario tiene menos de 4 prendas, se crea una paleta con tus looks anteriores.",
        "it": "In ogni round vedi due outfit e ne scegli uno. La risposta giusta dà punti e fa crescere la serie, quella sbagliata la azzera. Il punteggio segue regole: armonia dei colori, equilibrio delle categorie e coerenza stagionale. Se il guardaroba ha meno di 4 capi, la palette viene costruita dai vecchi outfit.",
        "pt": "Em cada ronda vês dois looks e escolhes um. Acertar dá pontos e mantém a sequência; errar reinicia-a. A pontuação segue regras: harmonia de cores, equilíbrio de categorias e coerência de estação. Se o guarda-roupa tiver menos de 4 peças, a paleta é construída a partir de looks anteriores.",
        "ru": "В каждом раунде показываются два образа, и ты выбираешь один. Верный ответ приносит очки и продлевает серию, неверный обнуляет её. Оценка по правилам: цветовая гармония, баланс категорий и соответствие сезону. Если в гардеробе меньше 4 вещей, палитра собирается из прошлых образов.",
        "ar": "في كل جولة يظهر أمامك إطلالتان وتختار إحداهما. الإجابة الصحيحة تمنحك نقاطًا وتبني السلسلة، والخاطئة تصفّرها. النقاط حسب قواعد واضحة: توافق الألوان، توازن الفئات واتساق الموسم. إذا كان في خزانتك أقل من 4 قطع، تُبنى لوحة من إطلالاتك السابقة.",
        "ja": "各ラウンドで2つのコーデから1つを選びます。正解なら得点と連続記録が増え、外すと連続記録はリセットされます。採点はルールベースで、色の調和・カテゴリのバランス・季節の整合性を測ります。ワードローブが4着未満の場合は過去のコーデからパレットを作ります。",
        "ko": "매 라운드마다 코디 두 개가 나오고 하나를 고릅니다. 맞히면 점수와 연속 기록이 늘고, 틀리면 연속 기록이 초기화됩니다. 점수는 규칙 기반이라 색 조화, 카테고리 균형, 계절 일관성을 봅니다. 옷장이 4개 미만이면 예전 코디로 팔레트를 만듭니다.",
        "zh": "每轮给出两套穿搭，你选一套。选对得分并累计连胜，选错则连胜归零。评分基于规则：色彩协调、品类均衡与季节一致性。若衣橱少于 4 件，会用你以往的搭配生成调色盘。",
    },
    "bilgiDolapCalisma": {
        "tr": "Dolabına fotoğraf eklediğinde arka plan otomatik silinir; renk, kategori, stil ve mevsim yapay zekâ tarafından okunur. Kıyafetler cihazında saklanır, arka plan silme ve analiz sunucu üzerinde yapılır.",
        "en": "When you add a photo, the background is removed automatically and the colour, category, style and season are read by AI. Your clothes stay on your device; background removal and analysis run on our server.",
        "de": "Wenn du ein Foto hinzufügst, wird der Hintergrund automatisch entfernt und Farbe, Kategorie, Stil und Saison werden von der KI erkannt. Deine Kleidung bleibt auf dem Gerät; Hintergrundentfernung und Analyse laufen auf unserem Server.",
        "fr": "Quand tu ajoutes une photo, le fond est supprimé automatiquement et la couleur, la catégorie, le style et la saison sont lus par l'IA. Tes vêtements restent sur ton appareil ; le traitement et l'analyse se font sur notre serveur.",
        "es": "Cuando añades una foto, el fondo se recorta automáticamente y la IA lee el color, la categoría, el estilo y la temporada. Tu ropa se queda en el dispositivo; el recorte y el análisis se hacen en nuestro servidor.",
        "it": "Quando aggiungi una foto, lo sfondo viene rimosso automaticamente e colore, categoria, stile e stagione vengono letti dall'IA. I tuoi capi restano sul dispositivo; rimozione dello sfondo e analisi avvengono sul nostro server.",
        "pt": "Quando juntas uma foto, o fundo é removido automaticamente e a IA lê a cor, a categoria, o estilo e a estação. As tuas peças ficam no dispositivo; a remoção de fundo e a análise são feitas no nosso servidor.",
        "ru": "Когда ты добавляешь фото, фон удаляется автоматически, а цвет, категория, стиль и сезон определяет ИИ. Одежда остаётся на устройстве; удаление фона и анализ выполняются на нашем сервере.",
        "ar": "عند إضافة صورة يُزال الخلفية تلقائيًا ويقرأ الذكاء الاصطناعي اللون والفئة والأسلوب والموسم. تبقى ملابسك على جهازك، بينما تتم إزالة الخلفية والتحليل على خادمنا.",
        "ja": "写真を追加すると背景が自動で取り除かれ、色・カテゴリ・スタイル・季節をAIが読み取ります。衣類は端末に保存され、背景除去と分析はサーバー側で処理されます。",
        "ko": "사진을 추가하면 배경이 자동으로 제거되고 AI가 색상, 카테고리, 스타일, 계절을 읽습니다. 옷은 기기에 저장되며 배경 제거와 분석은 서버에서 처리됩니다.",
        "zh": "添加照片时背景会自动去除，AI 会识别颜色、品类、风格与季节。衣物保存在你的设备上，背景去除与分析在服务器完成。",
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
