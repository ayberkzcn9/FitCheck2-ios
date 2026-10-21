"""Izin gerekce sayfasi metinleri - 12 dil. Idempotent; sonra `flutter gen-l10n`."""

import io
import json
import os
import sys

KLASOR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "lib", "l10n")

METINLER = {
    "izinGerekceKameraBaslik": {
        "tr": "Kamerayla kıyafet ekle",
        "en": "Add clothes with the camera",
        "de": "Kleidung mit der Kamera hinzufügen",
        "fr": "Ajouter des vêtements avec l'appareil photo",
        "es": "Añade prendas con la cámara",
        "it": "Aggiungi capi con la fotocamera",
        "pt": "Adiciona peças com a câmara",
        "ru": "Добавляйте вещи камерой",
        "ar": "أضف الملابس بالكاميرا",
        "ja": "カメラで衣類を追加",
        "ko": "카메라로 옷 추가",
        "zh": "用相机添加衣物",
    },
    "izinGerekceKameraAciklama": {
        "tr": "Kıyafetlerini fotoğraf olarak eklemek için kamerayı kullanıyoruz. Fotoğraf cihazından çıkar; arka plan silme ve renk/stil analizi sunucu üzerinde yapılır, kalıcı olarak saklanmaz.",
        "en": "We use the camera to add your clothes as photos. The photo leaves your device; background removal and colour/style analysis happen on our server and are not stored permanently.",
        "de": "Wir verwenden die Kamera, um deine Kleidung als Fotos hinzuzufügen. Das Foto verlässt dein Gerät; Hintergrundentfernung sowie Farb- und Stilanalyse erfolgen auf unserem Server und werden nicht dauerhaft gespeichert.",
        "fr": "Nous utilisons l'appareil photo pour ajouter vos vêtements en photos. La photo quitte votre appareil ; la suppression du fond et l'analyse des couleurs/styles sont faites sur notre serveur, sans stockage permanent.",
        "es": "Usamos la cámara para añadir tu ropa en fotos. La foto sale de tu dispositivo; el recorte de fondo y el análisis de color/estilo se hacen en nuestro servidor y no se guardan de forma permanente.",
        "it": "Usiamo la fotocamera per aggiungere i tuoi capi come foto. La foto lascia il dispositivo; rimozione dello sfondo e analisi di colore/stile avvengono sul nostro server e non vengono conservate.",
        "pt": "Usamos a câmara para adicionar as suas peças em fotos. A foto sai do dispositivo; a remoção de fundo e a análise de cor/estilo são feitas no nosso servidor e não são guardadas.",
        "ru": "Мы используем камеру, чтобы добавить одежду в виде фото. Фото покидает устройство; удаление фона и анализ цвета/стиля выполняются на нашем сервере и не хранятся постоянно.",
        "ar": "نستخدم الكاميرا لإضافة ملابسك كصور. تخرج الصورة من جهازك؛ تتم إزالة الخلفية وتحليل اللون والأسلوب على خادمنا ولا تُحفظ بشكل دائم.",
        "ja": "衣類を写真として追加するためにカメラを使います。写真は端末から送信され、背景除去と色・スタイル解析はサーバー側で実行され、恒久的には保存されません。",
        "ko": "옷을 사진으로 추가하기 위해 카메라를 사용합니다. 사진은 기기를 벗어나며, 배경 제거와 색상·스타일 분석은 서버에서 처리되어 영구 저장되지 않습니다.",
        "zh": "我们使用相机把衣物添加为照片。照片会离开你的设备；背景去除与颜色/风格分析在服务器完成，不会永久保存。",
    },
    "izinGerekceSimdiDegil": {
        "tr": "Şimdi değil",
        "en": "Not now",
        "de": "Jetzt nicht",
        "fr": "Pas maintenant",
        "es": "Ahora no",
        "it": "Non ora",
        "pt": "Agora não",
        "ru": "Не сейчас",
        "ar": "ليس الآن",
        "ja": "今は不要",
        "ko": "나중에",
        "zh": "暂不",
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
