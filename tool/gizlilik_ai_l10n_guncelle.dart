// FitCheck — Gizlilik politikasına "Yapay Zekâ ile Görsel Analizi" maddesini
// (5. madde) 12 dilde ekler ve son güncelleme tarihini yeniler.
//
// Neden: vision özelliği kıyafet fotoğraflarını Google (Gemini) ve Groq'a
// gönderiyor. Play, gizlilik politikasının veri akışını doğru anlatmasını
// istiyor; ayrıca kullanıcı neyin nereye gittiğini uygulama içinde görmeli.
//
// Betik hem YENİ anahtar ekler hem VAR OLAN anahtarın değerini değiştirir
// (sonGuncellemeTarihi). İstenildiği kadar çalıştırılabilir.
//
// Çalıştırma: dart run tool/gizlilik_ai_l10n_guncelle.dart
import 'dart:io';

/// Yeni anahtarlar + güncellenecek tarih metni.
const Map<String, Map<String, String>> yeniler = {
  'tr': {
    'gizlilikMadde5Baslik': '5. Yapay Zekâ ile Görsel Analizi',
    'gizlilikMadde5Icerik':
        'Kıyafet fotoğrafları, arka planı silinmek üzere kendi sunucumuzda '
            'işlenir; stil analizi ve kombin önerileri için Google (Gemini) ve '
            'Groq yapay zekâ servislerine gönderilir. Fotoğraflar yalnızca '
            'isteğinizi yanıtlamak için işlenir, tarafımızca kalıcı olarak '
            'saklanmaz ve reklam amacıyla kullanılmaz. Fotoğrafın kendisi '
            'cihazınızda kalır; dilediğiniz zaman gardıroptan silebilirsiniz.',
    'sonGuncellemeTarihi': 'Son Güncelleme: 20 Ekim 2026',
  },
  'en': {
    'gizlilikMadde5Baslik': '5. AI Image Analysis',
    'gizlilikMadde5Icerik':
        'Garment photos are processed on our own server to remove the '
            'background and sent to Google (Gemini) and Groq AI services for '
            'style analysis and outfit suggestions. Photos are processed only '
            'to answer your request, are not stored permanently by us and are '
            'not used for advertising. The photo itself stays on your device; '
            'you can delete it from your wardrobe at any time.',
    'sonGuncellemeTarihi': 'Last Updated: October 20, 2026',
  },
  'it': {
    'gizlilikMadde5Baslik': '5. Analisi delle immagini con IA',
    'gizlilikMadde5Icerik':
        "Le foto dei capi vengono elaborate sul nostro server per rimuovere lo "
            "sfondo e inviate ai servizi di IA Google (Gemini) e Groq per "
            "l'analisi dello stile e i suggerimenti sugli outfit. Le foto sono "
            "elaborate solo per rispondere alla tua richiesta, non vengono "
            "conservate in modo permanente da noi e non sono usate per la "
            "pubblicità. La foto resta sul tuo dispositivo; puoi eliminarla dal "
            "guardaroba in qualsiasi momento.",
    'sonGuncellemeTarihi': 'Ultimo aggiornamento: 20 ottobre 2026',
  },
  'es': {
    'gizlilikMadde5Baslik': '5. Análisis de imágenes con IA',
    'gizlilikMadde5Icerik':
        'Las fotos de las prendas se procesan en nuestro propio servidor para '
            'quitar el fondo y se envían a los servicios de IA de Google '
            '(Gemini) y Groq para el análisis de estilo y las sugerencias de '
            'conjuntos. Las fotos se procesan solo para responder a tu '
            'solicitud, no las almacenamos de forma permanente ni las usamos '
            'para publicidad. La foto permanece en tu dispositivo; puedes '
            'borrarla del armario cuando quieras.',
    'sonGuncellemeTarihi': 'Última actualización: 20 de octubre de 2026',
  },
  'zh': {
    'gizlilikMadde5Baslik': '5. AI 图像分析',
    'gizlilikMadde5Icerik':
        '衣物照片会在我们自己的服务器上去除背景，并发送至 Google（Gemini）和 Groq '
            '人工智能服务进行风格分析与搭配建议。照片仅用于回应您的请求，我们不会永久保存，'
            '也不会用于广告。照片本身保存在您的设备上，您可以随时从衣橱中删除。',
    'sonGuncellemeTarihi': '最后更新：2026年10月20日',
  },
  'ar': {
    'gizlilikMadde5Baslik': '5. تحليل الصور بالذكاء الاصطناعي',
    'gizlilikMadde5Icerik':
        'تُعالج صور الملابس على خادمنا الخاص لإزالة الخلفية، ثم تُرسل إلى خدمات '
            'الذكاء الاصطناعي من Google (Gemini) وGroq لتحليل الأسلوب واقتراح '
            'التنسيقات. تُعالج الصور فقط للإجابة على طلبك، ولا نحتفظ بها بشكل دائم '
            'ولا نستخدمها للإعلانات. تبقى الصورة على جهازك، ويمكنك حذفها من خزانة '
            'ملابسك في أي وقت.',
    'sonGuncellemeTarihi': 'آخر تحديث: 20 أكتوبر 2026',
  },
  'fr': {
    'gizlilikMadde5Baslik': "5. Analyse d'images par IA",
    'gizlilikMadde5Icerik':
        "Les photos de vêtements sont traitées sur notre propre serveur pour "
            "supprimer l'arrière-plan, puis envoyées aux services d'IA Google "
            "(Gemini) et Groq pour l'analyse du style et les suggestions de "
            "tenues. Les photos sont traitées uniquement pour répondre à votre "
            "demande, ne sont pas conservées durablement par nos soins et ne "
            "servent pas à la publicité. La photo reste sur votre appareil ; "
            "vous pouvez la supprimer du dressing à tout moment.",
    'sonGuncellemeTarihi': 'Dernière mise à jour : 20 octobre 2026',
  },
  'de': {
    'gizlilikMadde5Baslik': '5. KI-Bildanalyse',
    'gizlilikMadde5Icerik':
        'Kleidungsfotos werden auf unserem eigenen Server verarbeitet, um den '
            'Hintergrund zu entfernen, und für Stilanalyse und Outfit-Vorschläge '
            'an die KI-Dienste von Google (Gemini) und Groq gesendet. Die Fotos '
            'werden nur zur Beantwortung deiner Anfrage verarbeitet, von uns '
            'nicht dauerhaft gespeichert und nicht für Werbung genutzt. Das Foto '
            'selbst bleibt auf deinem Gerät; du kannst es jederzeit aus der '
            'Garderobe löschen.',
    'sonGuncellemeTarihi': 'Letzte Aktualisierung: 20. Oktober 2026',
  },
  'pt': {
    'gizlilikMadde5Baslik': '5. Análise de imagens com IA',
    'gizlilikMadde5Icerik':
        'As fotos das peças são processadas no nosso próprio servidor para '
            'remover o fundo e enviadas aos serviços de IA Google (Gemini) e '
            'Groq para análise de estilo e sugestões de looks. As fotos são '
            'processadas apenas para responder ao seu pedido, não são guardadas '
            'permanentemente por nós nem usadas para publicidade. A foto '
            'permanece no seu dispositivo; pode apagá-la do guarda-roupa a '
            'qualquer momento.',
    'sonGuncellemeTarihi': 'Última atualização: 20 de outubro de 2026',
  },
  'ja': {
    'gizlilikMadde5Baslik': '5. AI による画像分析',
    'gizlilikMadde5Icerik':
        '衣類の写真は背景を削除するために当社のサーバーで処理され、スタイル分析と'
            'コーディネート提案のために Google（Gemini）および Groq の AI サービスに'
            '送信されます。写真はご依頼への回答のみに使用され、当社が永続的に保存することは'
            'なく、広告には使用しません。写真自体は端末に保存され、いつでもワードローブから'
            '削除できます。',
    'sonGuncellemeTarihi': '最終更新日：2026年10月20日',
  },
  'ko': {
    'gizlilikMadde5Baslik': '5. AI 이미지 분석',
    'gizlilikMadde5Icerik':
        '의류 사진은 배경 제거를 위해 자체 서버에서 처리되며, 스타일 분석과 코디 추천을 '
            '위해 Google(Gemini) 및 Groq AI 서비스로 전송됩니다. 사진은 요청에 응답하기 '
            '위해서만 처리되고, 당사가 영구적으로 저장하지 않으며 광고에 사용하지 않습니다. '
            '사진 자체는 기기에 남아 있으며 언제든지 옷장에서 삭제할 수 있습니다.',
    'sonGuncellemeTarihi': '최종 업데이트: 2026년 10월 20일',
  },
  'ru': {
    'gizlilikMadde5Baslik': '5. Анализ изображений с помощью ИИ',
    'gizlilikMadde5Icerik':
        'Фотографии одежды обрабатываются на нашем собственном сервере для '
            'удаления фона и отправляются в сервисы ИИ Google (Gemini) и Groq для '
            'анализа стиля и подбора образов. Фотографии обрабатываются только для '
            'ответа на ваш запрос, мы не храним их постоянно и не используем для '
            'рекламы. Сама фотография остаётся на вашем устройстве; вы можете '
            'удалить её из гардероба в любой момент.',
    'sonGuncellemeTarihi': 'Последнее обновление: 20 октября 2026 г.',
  },
};

/// Dosyaya eklenme sırası (son anahtarın ardından virgül kaldırılır).
const List<String> eklemeSirasi = [
  'gizlilikMadde5Baslik',
  'gizlilikMadde5Icerik',
];

/// Değeri değiştirilecek (zaten var olan) anahtarlar.
const List<String> guncellenecek = ['sonGuncellemeTarihi'];

String jsonKacis(String s) => s.replaceAll('\\', r'\\').replaceAll('"', r'\"');

void main() {
  final dosyalar = Directory('lib/l10n')
      .listSync()
      .whereType<File>()
      .where((f) => RegExp(r'app_[a-z]{2}\.arb$').hasMatch(f.path))
      .toList()
    ..sort((a, b) => a.path.compareTo(b.path));

  var hataVar = false;

  for (final dosya in dosyalar) {
    final eslesme = RegExp(r'app_([a-z]{2})\.arb$').firstMatch(dosya.path);
    final dil = eslesme!.group(1)!;
    final tablo = yeniler[dil];
    if (tablo == null) {
      stderr.writeln('Dil tablosu eksik: $dil');
      hataVar = true;
      continue;
    }

    var metin = dosya.readAsStringSync();
    final eklenecekler = <String>[];
    var guncellenen = 0;

    // 1) Var olan anahtarların değerini değiştir.
    for (final anahtar in guncellenecek) {
      final deger = tablo[anahtar];
      if (deger == null) {
        stderr.writeln('Metin eksik: $dil/$anahtar');
        hataVar = true;
        continue;
      }
      final desen = RegExp(
        '"${RegExp.escape(anahtar)}"\\s*:\\s*"(?:[^"\\\\]|\\\\.)*"',
      );
      if (!desen.hasMatch(metin)) {
        stderr.writeln('Güncellenecek anahtar bulunamadı: $dil/$anahtar');
        hataVar = true;
        continue;
      }
      metin = metin.replaceFirst(
        desen,
        '"$anahtar": "${jsonKacis(deger)}"',
      );
      guncellenen++;
    }

    // 2) Yeni anahtarları ekle (varsa atla).
    for (final anahtar in eklemeSirasi) {
      if (RegExp('"${RegExp.escape(anahtar)}":').hasMatch(metin)) continue;
      final deger = tablo[anahtar];
      if (deger == null) {
        stderr.writeln('Metin eksik: $dil/$anahtar');
        hataVar = true;
        continue;
      }
      eklenecekler.add('  "$anahtar": "${jsonKacis(deger)}",');
    }

    if (eklenecekler.isNotEmpty) {
      final kapanisIndex = metin.lastIndexOf('}');
      var govde = metin.substring(0, kapanisIndex);
      final kapanis = metin.substring(kapanisIndex);
      govde = govde.replaceAll(RegExp(r'[\s,]+$'), '');
      var blok = eklenecekler.join('\n');
      // Bloktaki son virgül kaldırılır (geçerli JSON için).
      blok = blok.replaceRange(blok.lastIndexOf(','), blok.lastIndexOf(',') + 1, '');
      metin = '$govde,\n$blok\n$kapanis';
    }

    dosya.writeAsStringSync(metin, flush: true);
    stdout.writeln(
      '$dil: ${eklenecekler.length} anahtar eklendi, $guncellenen tarih güncellendi',
    );
  }

  if (hataVar) exitCode = 1;
}
