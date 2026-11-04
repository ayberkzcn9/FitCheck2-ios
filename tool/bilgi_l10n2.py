"""Dolabin kahramanlari / unutulanlar bilgi metinleri - 12 dil."""

import io
import json
import os
import sys

KLASOR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "lib", "l10n")

METINLER = {
    "bilgiKahramanlar": {
        "tr": "Dolabının kahramanları, dolabında en çok giyilen parçalardır. Sık giyilen parçalar kombinlerde daha çok yer alır ve gardırobunu sürdürür.",
        "en": "Your wardrobe heroes are the pieces you wear most often. Frequently worn pieces show up in more outfits and keep your wardrobe in rotation.",
        "de": "Deine Garderobenhelden sind die am häufigsten getragenen Teile. Oft getragene Teile tauchen in mehr Outfits auf und halten deine Garderobe in Bewegung.",
        "fr": "Les héros de votre garde-robe sont les pièces que vous portez le plus souvent. Les pièces les plus portées apparaissent dans plus de tenues et font tourner votre garde-robe.",
        "es": "Los héroes de tu armario son las prendas que más llevas. Las prendas más usadas aparecen en más looks y mantienen tu armario en movimiento.",
        "it": "Gli eroi del tuo guardaroba sono i capi che indossi più spesso. I capi più frequenti compaiono in più outfit e tengono in movimento il guardaroba.",
        "pt": "Os heróis do teu guarda-roupa são as peças que usas mais. As peças mais usadas aparecem em mais looks e mantêm o guarda-roupa em movimento.",
        "ru": "Герои вашего гардероба — вещи, которые вы носите чаще всего. Часто надеваемые вещи попадают в больше образов и «вращают» гардероб.",
        "ar": "أبطال خزانتك هم القطع التي ترتديها كثيرًا. القطع كثيرة الاستخدام تظهر في إطلالات أكثر وتدفع خزانتك إلى الدوران.",
        "ja": "ワードローブのヒーローは、よく着ているアイテムです。着回しの多いアイテムは多くの提案に登場し、ワードローブを活着させます。",
        "ko": "옱장의 히어로는 가장 자주 입는 아이템입니다. 자주 입는 아이템은 코디에 더 많이 등장하고 옷장을 계속 돌게 합니다.",
        "zh": "衣橱英雄是你最常穿的那些单品。常穿的单品会出现在更多搭配中，让衣橱保持流转。",
    },
    "bilgiUnutulanlar": {
        "tr": "Derinlerde unutulanlar, hiç giyilmemiş ya da çok uzun süredir giyilmemiş parçalardır. Kullanılmayan parçalar yeni kombinlerle yeniden hayat bulabilir.",
        "en": "Forgotten items are pieces you have never worn, or have not worn for a long time. Unused pieces can come back to life with new outfits.",
        "de": "Die vergessenen Teile sind Stücke, die nie getragen wurden oder lange nicht getragen wurden. Ungenutzte Teile können durch neue Outfits wiederbelebt werden.",
        "fr": "Les pièces oubliées sont celles que vous n'avez jamais portées ou portées très longtemps. Les pièces inutilisées peuvent revivre avec de nouvelles tenues.",
        "es": "Las piezas olvidadas son aquellas que nunca has lucido o que llevas mucho tiempo sin usar. Las piezas sin usar pueden revivir con nuevos looks.",
        "it": "I capi dimenticati sono quelli mai indossati o portati da molto tempo. I capi inutilizzati possono tornare utili con nuovi outfit.",
        "pt": "As peças esquecidas são as que nunca usaste ou que não usas há muito tempo. As peças por usar podem ressuscitar com novos looks.",
        "ru": "Забытые вещи — те, которые вы не надевали или не надевали очень давно. Неиспользованные вещи могут заиграть снова в новых образах.",
        "ar": "القطع المنسية هي التي لم ترتدها قط أو لم ترتدها منذ وقت طويل. القطع غير المستخدمة قد تعود للحياة مع إطلالات جديدة.",
        "ja": "忘れたアイテムは、着たことがない、または長く着ていないものです。使っていないアイテムも新しいコーデで復活します。",
        "ko": "잊힌 아이템은 한 번도 입지 않았거나 오랫동안 입지 않은 것입니다. 쓰지 않는 아이템도 새 코디로 다시 살릴 수 있습니다.",
        "zh": "被遗忘的单品是你从未穿过或很久没穿的那些。未被使用的单品可以通过新搭配重新派上用场。",
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
