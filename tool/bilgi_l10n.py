"""Profil & Analiz olcut bilgi metinleri - 12 dil. Idempotent; sonra `flutter gen-l10n`."""

import io
import json
import os
import sys

KLASOR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "lib", "l10n")

METINLER = {
    "bilgiVerimlilik": {
        "tr": "Dolap verimliliği, dolabındaki parçaların ne kadarının en az bir kez giyildiğini gösterir. %60 üzeri sağlıklı bir dolap için iyidir; daha düşükse bazı parçalar henüz kullanılmamış ya da fazla almışsındır.",
        "en": "Wardrobe efficiency shows how many of your pieces have been worn at least once. Above 60% is considered healthy for a wardrobe; lower means some pieces are unused or you own too many.",
        "de": "Die Garderobe-Effizienz zeigt, wie viele deiner Teile mindestens einmal getragen wurden. Über 60 % gilt als gesund; niedrigere Werte bedeuten ungenutzte Teile oder zu viele Käufe.",
        "fr": "L'efficacité de la garde-robe indique la part de vos pièces portées au moins une fois. Au-delà de 60 %, c'est sain ; en dessous, certaines pièces ne sont jamais portées ou vous en avez trop.",
        "es": "La eficiencia del armario muestra cuántas prendas has lucido al menos una vez. Por encima del 60 % se considera saludable; menos indica prendas sin usar o demasiadas prendas.",
        "it": "L'efficienza del guardaroba indica la percentuale di capi indossati almeno una volta. Oltre il 60% è considerata sana; valori più bassi indicano capi mai usati o troppi acquisti.",
        "pt": "A eficiência do guarda-roupa mostra a percentagem de peças que já usaste pelo menos uma vez. Acima de 60% é considerado saudável; menos indica peças por usar ou peças a mais.",
        "ru": "Эффективность гардероба показывает долю вещей, надетых хотя бы раз. Выше 60 % считается здоровым показателем; ниже есть неиспользованные вещи или лишние покупки.",
        "ar": "كفاءة خزانتك تُظهر نسبة القطع التي ارتديتها مرة واحدة على الأقل. أكثر من 60% يُعدّ حجمًا صحيًا، والأقل يعني وجود قطع لم تُستخدم أو مشتريات زائدة.",
        "ja": "ワードローブ効率は、少なくとも一度でも着たアイテムの割合を示します。60%を超えると健全な状態とみなされ、下回ると着ていないアイテムや買いすぎの兆候があります。",
        "ko": "옷장 효율은 한 번이라도 입은 아이템의 비율입니다. 60%를 넘으면 건강한 상태로 봅니다. 더 낮으면 입지 않은 아이템이 있거나 너무 많이 산했다는 뜻입니다.",
        "zh": "衣橱效率表示至少穿过一次的衣物占比。超过 60% 视为健康；低于此说明有衣物闲置或购买过多。",
    },
    "bilgiStil": {
        "tr": "Stil kimliğin, dolabındaki parçaların çoğunluğunun ortak özelliklerinden çıkarılır: renk, kategori ve tarz etiketi. Kombin önerileri bu profile göre sıralanır.",
        "en": "Your style identity is derived from the most common traits of your wardrobe: colour, category and style tags. Outfit suggestions are ranked using this profile.",
        "de": "Deine Stil-Identität wird aus den häufigsten Merkmalen deiner Garderobe abgeleitet: Farbe, Kategorie und Stil-Tags. Kombinvorschläge richten sich danach.",
        "fr": "Votre identité de style vient des traits les plus fréquents de votre garde-robe : couleur, catégorie et etiquetas de style. Les tenues proposées sont classées selon ce profil.",
        "es": "Tu identidad de estilo se calcula a partir de las características más comunes de tu armario: color, categoría y etiquetas de estilo. Las recomendaciones se ordenan con ese perfil.",
        "it": "La tua identità di stile deriva dalle caratteristiche più comuni del guardaroba: colore, categoria e tag di stile. I suggerimenti di outfit seguono questo profilo.",
        "pt": "A tua identidade de estilo vem das traços mais comuns do guarda-roupa: cor, categoria e etiquetas de estilo. As recomendações de look seguem esse perfil.",
        "ru": "Ваш стилевой профиль вычисляется по самым частым признакам гардероба: цвету, категории и тегам стиля. Подборки образов сортируются по нему.",
        "ar": "تُحسب هويتك في الأناقة من أكثر خصائص خزانتك شيوعًا: اللون والفئة ووسوم الأسلوب. تُرتَّب اقتراحات الإطلالات وفق هذه الصورة.",
        "ja": "スタイル身元は、ワードローブに多い色・カテゴリ・スタイルタグから計算されます。单品の提案はこのプロファイルに合わせて並び替わります。",
        "ko": "스타일 정체성은 옷장에 가장 많은 색상, 카테고리, 스타일 태그를 바탕으로 계산됩니다. 코디 제안도 이 프로필을 따릅니다.",
        "zh": "风格画像根据衣橱中最常见的特征计算：颜色、品类与风格标签。穿搭推荐按该画像排序。",
    },
    "bilgiSeri": {
        "tr": "Seri, üst üste giydiğin gün sayısıdır. Her «bugün giydim» işaretlemen seriye ekler; bir gün atlayınca seri sıfırlanır.",
        "en": "The streak is the number of consecutive days you have dressed. Each “worn today” adds to it; skipping a day resets it.",
        "de": "Die Serie ist die Zahl der Tage, an denen du hintereinander etwas getragen hast. Jedes „Heute getragen“ erhöht sie; ein ausgelassener Tag setzt sie zurück.",
        "fr": "La série est le nombre de jours consécutifs où vous vous êtes habillé. Chaque « porté aujourd'hui » l'augmente ; un jour manqué la remet à zéro.",
        "es": "La racha es el número de días seguidos que te has vestido. Cada «me lo puse hoy» la aumenta; saltarte un día la reinicia.",
        "it": "La serie è il numero di giorni consecutivi in cui ti sei vestito. Ogni «indossato oggi» la aumenta; saltare un giorno la azzera.",
        "pt": "A sequência é o número de dias consecutivos em que te vestiste. Cada «usei hoje» aumenta-a; saltar um dia reinicia-a.",
        "ru": "Серия — это число дней подряд, когда вы надевали одежду. Каждое «ношу сегодня» увеличивает её, пропущенный день обнуляет.",
        "ar": "السلسلة هي عدد الأيام المتتالية التي ارتديت فيها ملابس. كل «ارتديته اليوم» يزيدها، وتجاهل يوم يعيدها إلى الصفر.",
        "ja": "連続記録は、続けて着た日数です。「今日着た」を押すたびに増え、1日飛ばすとリセットされます。",
        "ko": "연속 기록은 연속으로 입은 날짜 수입니다. ‘오늘 입었어요’를 누를 때마다 늘어나고, 하루를 건너뛰면 초기화됩니다.",
        "zh": "连续记录指连续穿着的天数。每次标记「今天穿了」都会增加，漏掉一天即归零。",
    },
    "bilgiSepet": {
        "tr": "Çamaşır sepeti, giydiğin ama henüz yıkamak istediğin parçalardır. Sepete attığın parçalar bir sonraki kombin önerisinde kullanılmaz.",
        "en": "The laundry basket holds pieces you have worn but want to wash. Items in the basket are not used in the next outfit suggestion.",
        "de": "Der Wäschekorb enthält Teile, die du getragen hast und waschen möchtest. Sie werden für den nächsten Kombinvorschlag nicht verwendet.",
        "fr": "Le panier à linge contient les pièces que vous avez portées et que vous voulez laver. Elles ne sont pas utilisées dans la tenue suivante proposée.",
        "es": "El cesto de la ropa contiene las prendas que te has puesto y quieres lavar. No se usan en la siguiente recomendación de look.",
        "it": "Il cesto della lavanderia contiene i capi che hai indossato e che vuoi lavare. Non vengono usati nel prossimo outfit suggerito.",
        "pt": "O cesto da roupa tem as peças que usaste e queres lavar. Não entram na próxima recomendação de look.",
        "ru": "Корзина для белья содержит вещи, которые вы носили и хотите постирать. Они не попадают в следующую подборку образа.",
        "ar": "سلة الغسيل تضم القطع التي ارتديتها وتريد غسلها. لا تُستخدم في اقتراح الإطلالة التالي.",
        "ja": "洗濯かごは、着たが洗いたいアイテムの置き場です。かごにあるアイテムは次の单品提案には使われません。",
        "ko": "세탁 바구니는 입었지만 아직 빨고 싶은 아이템입니다. 다음 코디 제안에는 쓰이지 않습니다.",
        "zh": "洗衣篮存放已穿过但想清洗的衣物。篮中衣物不会用于下一次穿搭推荐。",
    },
    "bilgiRenkPaleti": {
        "tr": "Renk paletin, dolabında en çok bulunan dört rengin dağılımını gösterir. Birbirine yakın tonlar kombinde daha uyumlu görünür.",
        "en": "Your colour palette shows the distribution of the four colours that appear most in your wardrobe. Similar shades look more harmonious together.",
        "de": "Deine Farbpalette zeigt die Verteilung der vier häufigsten Farben in deiner Garderobe. Ähnliche Töne wirken harmonischer.",
        "fr": "Votre palette montre la répartition des quatre couleurs les plus présentes dans votre garde-robe. Des teintes proches s'accordent mieux.",
        "es": "Tu paleta de colores muestra la distribución de los cuatro colores más habituales en tu armario. Los tonos parecidos combinan mejor.",
        "it": "La tua palette mostra la distribuzione dei quattro colori più presenti nel guardaroba. Tonalità simili si abbinano meglio.",
        "pt": "A tua paleta de cores mostra a distribuição das quatro cores mais frequentes no guarda-roupa. Tons parecidos combinam melhor.",
        "ru": "Палитра показывает распределение четырёх самых частых цветов в гардеробе. Похожие оттенки сочетаются лучше.",
        "ar": "تُظهر لوحة الألوان توزيع الألوان الأربعة الأكثر تكرارًا في خزانتك. الدرجات المتقاربة تتناسق معًا بصورة أفضل.",
        "ja": "カラーパレットは、ワードローブで最も多い4色の分布を示します。似た色味どうしは相性がよく見えます。",
        "ko": "컬러 팔레트는 옷장에서 가장 많이 있는 네 가지 색의 분포를 보여줍니다. 비슷한 색조끼리 더 잘 어울립니다.",
        "zh": "配色板显示衣橱中出现最多的四种颜色的分布。相近色调搭配更协调。",
    },
    "bilgiKategoriDagilimi": {
        "tr": "Kategori dağılımı, dolabının üst, alt, ayakkabı ve aksesuar dengesini gösterir. Tek bir kategoride fazla parça varsa kombin kurmak zorlaşır.",
        "en": "Category distribution shows the balance between tops, bottoms, shoes and accessories. Too many pieces in one category makes outfits harder to build.",
        "de": "Die Kategorieverteilung zeigt das Verhältnis von Oberteilen, Hosen, Schuhen und Accessoires. Zu viele Teile in einer Kategorie machen Outfits schwerer.",
        "fr": "La répartition par catégories montre l'équilibre entre hauts, bas, chaussures et accessoires. Trop de pièces dans une catégorie complique la création de tenues.",
        "es": "La distribución por categorías muestra el equilibrio entre partes de arriba, de abajo, calzado y accesorios. Si tienes muchas prendas de una categoría, crear looks cuesta más.",
        "it": "La distribuzione per categorie mostra l'equilibrio tra maglie, pantaloni, scarpe e accessori. Troppi capi in una categoria rendono più difficile creare outfit.",
        "pt": "A distribuição por categorias mostra o equilíbrio entre tops, bottoms, calçados e acessórios. Ter muitas peças numa categoria torna mais difícil criar looks.",
        "ru": "Распределение по категориям показывает баланс верха, низа, обуви и аксессуаров. Слишком много вещей в одной категории затрудняет подбор образа.",
        "ar": "تُظهر توزيع الفئات التوازن بين القطع العلوية والسفلية والأحذية والإكسسوارات. كثرة القطع في فئة واحدة تصعّب تكوين الإطلالات.",
        "ja": "カテゴリ分布は、トップス・ボトムス・靴・アクセソリーのバランスを示します。1つのカテゴリに偏ると、单品が作りにくくなります。",
        "ko": "카테고리 분포는 상의, 하의, 신발, 액세서리 균형을 보여줍니다. 한 카테고리가 몰리면 코디를 만들기 어려워집니다.",
        "zh": "品类分布显示上衣、下装、鞋履与配饰的均衡情况。某一品类过多会难以搭配。",
    },
    "bilgiAnlikDurum": {
        "tr": "Anlık durum, bulunduğun şehre göre hava durumuna ve dolabına uygun kısa bir öneri verir.",
        "en": "Instant status gives you a short suggestion based on the weather in your city and your wardrobe.",
        "de": "Der Sofort-Status gibt dir einen kurzen Hinweis passend zum Wetter deiner Stadt und deiner Garderobe.",
        "fr": "Le statut instantané donne un bref conseil selon la météo de votre ville et votre garde-robe.",
        "es": "El estado instantáneo te da un consejo breve según el tiempo de tu ciudad y tu armario.",
        "it": "Lo stato istantaneo dà un breve consiglio in base al meteo della tua città e al tuo guardaroba.",
        "pt": "O estado instantâneo dá-te uma sugestão curta com base no tempo da tua cidade e no teu guarda-roupa.",
        "ru": "Мгновенная сводка даёт короткий совет по погоде в вашем городе и составу гардероба.",
        "ar": "الحالة الفورية تعطي اقتراحًا قصيرًا حسب طقس مدينتك ومحتويات خزانتك.",
        "ja": "インスタント状態は、お住まいの天気とワードローブにもとづく短い提案を出します。",
        "ko": "즉시 상태는 도시의 날씨와 옷장을 바탕으로 짧은 조언을 제공합니다.",
        "zh": "即时状态根据所在城市的天气与你的衣橱给出简短建议。",
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
