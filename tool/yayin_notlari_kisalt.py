"""Play 500 karakter sinirina uymak icin yayin notlarindaki uzun maddeleri kisaltir."""

import io
import os
import re

YOL = "yayin-notlari-1.0.32.md"

KISALTMALAR = [
    # tr
    ("Dolapta ara, kategoriye göre filtrele; sonuç sayısı anında güncellenir",
     "Dolapta ara ve kategoriye göre filtrele"),
    ("Kombini görsel olarak paylaş; raf parçasına dokun: bugün giydim / kombin kur",
     "Kombini paylaş; raf parçasına dokun: bugün giydim"),
    ('Akşam 21:00\'de "yarınki kombinin hazır" hatırlatıcısı',
     "Akşam 21:00'de yarınki kombin hatırlatıcısı"),
    # en
    ("Search your wardrobe and filter by category; results update instantly",
     "Search and filter your wardrobe by category"),
    ("Share today's outfit as an image; tap a shelf item to wear it or build an outfit",
     "Share today's outfit; tap a shelf item to wear it"),
    # it
    ("Cerca nel guardaroba e filtra per categoria; risultati immediati",
     "Cerca e filtra il guardaroba per categoria"),
    ("Condividi il look come immagine; tocca un capo: indossalo oggi o crea un outfit",
     "Condividi il look; tocca un capo: indossalo oggi"),
    ("Le notifiche mostrano il look del giorno e aprono la scheda giusta",
     "Le notifiche mostrano il look del giorno e aprono la scheda"),
    ("Nuovo \"Il mio diario di stile\": calendario, diario, rapporto settimanale",
     "Nuovo \"Il mio diario di stile\": calendario e rapporto settimanale"),
    ("Assegna un outfit a un giorno nel calendario; il piano compare su Oggi",
     "Assegna un outfit a un giorno nel calendario"),
    # es
    ("Busca en tu armario y filtra por categoría; resultados al instante",
     "Busca y filtra tu armario por categoría"),
    ("Comparte el look como imagen; toca una prenda: me la puse hoy o crea un look",
     "Comparte el look; toca una prenda: me la puse hoy"),
    ("Asigna un look a un día del calendario; tu plan aparece en Hoy",
     "Asigna un look a un día del calendario"),
    # fr
    ("Recherche et filtres dans votre garde-robe", "Recherche dans votre garde-robe"),
    ("Partagez la tenue en image ; touchez un article : porté aujourd'hui, créer une tenue",
     "Partagez la tenue ; touchez un article : porté aujourd'hui"),
    ("Les notifications montrent la tenue du jour et ouvrent le bon onglet",
     "Les notifications montrent la tenue du jour"),
    ("Attribuez une tenue à un jour du calendrier ; votre plan s'affiche sur Aujourd'hui",
     "Attribuez une tenue à un jour du calendrier"),
    # de
    ("Garderobe durchsuchen und nach Kategorie filtern, Treffer sofort",
     "Garderobe durchsuchen und filtern"),
    ("Outfit als Bild teilen; Regal-Teil antippen: heute getragen oder Outfit bauen",
     "Outfit teilen; Regal-Teil antippen: heute getragen"),
    ("Benachrichtigungen zeigen dein Outfit des Tages und öffnen den richtigen Tab",
     "Benachrichtigungen zeigen dein Outfit des Tages"),
    ("Outfit im Kalender einem Tag zuweisen; dein Plan erscheint auf Heute",
     "Outfit im Kalender einem Tag zuweisen"),
    # pt
    ("Pesquise no guarda-roupa e filtre por categoria, resultados imediatos",
     "Pesquise e filtre o guarda-roupa por categoria"),
    ("Partilhe o look como imagem; toque numa peça: usei hoje ou criar look",
     "Partilhe o look; toque numa peça: usei hoje"),
    ("Atribui um look a um dia no calendário; o teu plano aparece em Hoje",
     "Atribui um look a um dia no calendário"),
    # ru
    ("Поиск по гардеробу и фильтр по категориям, результат сразу",
     "Поиск и фильтр по гардеробу"),
    ("Поделитесь образом картинкой; нажмите на вещь: надето сегодня или собрать образ",
     "Поделитесь образом; нажмите на вещь: надето сегодня"),
    ("Назначь образ на день в календаре — план появится в «Сегодня»",
     "Назначь образ на день в календаре"),
]

ham = io.open(YOL, encoding="utf-8", newline="").read()
ayrac = "\r\n" if "\r\n" in ham else "\n"

for eski, yeni in KISALTMALAR:
    if eski in ham:
        ham = ham.replace(eski, yeni)
    else:
        print("BULUNAMADI:", eski[:50])

io.open(YOL, "w", encoding="utf-8", newline="").write(ham)

satirlar = ham.split(ayrac)
print("karakter sayilari:")
i = 0
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
