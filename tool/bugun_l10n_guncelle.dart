// "Bugün" ekranının metinlerini 12 dilin ARB dosyasına ekler.
//
// Neden betik: elle 12 dosyaya 21 anahtar yazmak hem yavaş hem hataya açık.
// Betik anahtar zaten varsa atlar, bu yüzden tekrar çalıştırılabilir.
//
// Çalıştırma: dart run tool/bugun_l10n_guncelle.dart
// Sonrasında: flutter gen-l10n
import 'dart:io';

const List<String> anahtarlar = <String>[
  'bugunSekmesi',
  'bugunBaslik',
  'bugunGunaydin',
  'bugunIyiGunler',
  'bugunIyiAksamlar',
  'bugunBugununKombini',
  'bugunHizliFotograf',
  'bugunHizliKombin',
  'bugunHizliStilist',
  'bugunHizliPlan',
  'bugunHazirlaniyor',
  'bugunBosBaslik',
  'bugunBosAciklama',
  'bugunYenile',
  'bugunGiydim',
  'bugunKaydet',
  'bugunSeninIcin',
  'bugunGiyilmediRafi',
  'bugunYeniRafi',
  'bugunHavaRafi',
  'bugunRafIpucu',
];

const Map<String, List<String>> metinler = {
  'tr': [
    'Bugün',
    'Bugün',
    'Günaydın',
    'İyi günler',
    'İyi akşamlar',
    'Bugünün kombini',
    'Fotoğrafla ekle',
    'Kombin üret',
    'Stiliste sor',
    'Haftayı planla',
    'Kombinler hazırlanıyor…',
    'Dolabın henüz boş',
    'İlk parçanı ekle; her sabah burada yeni kombin önerileri olacak.',
    'Yenile',
    'Giydim',
    'Kaydet',
    'Senin için',
    '2 haftadır giymediklerin',
    'Yeni eklenenler',
    'Bugüne uygun',
    'Dolabında görmek için dokun',
  ],
  'en': [
    'Today',
    'Today',
    'Good morning',
    'Good afternoon',
    'Good evening',
    "Today's outfit",
    'Add a photo',
    'Build an outfit',
    'Ask the stylist',
    'Plan the week',
    'Preparing outfits…',
    'Your wardrobe is empty',
    'Add your first item; new outfit ideas will be here every morning.',
    'Refresh',
    'Wore it',
    'Save',
    'For you',
    'Not worn in 2 weeks',
    'Recently added',
    'Right for today',
    'Tap to open in your wardrobe',
  ],
  'it': [
    'Oggi',
    'Oggi',
    'Buongiorno',
    'Buon pomeriggio',
    'Buonasera',
    "L'outfit di oggi",
    'Aggiungi una foto',
    'Crea un outfit',
    'Chiedi allo stylist',
    'Pianifica la settimana',
    'Preparazione degli outfit…',
    'Il tuo guardaroba è vuoto',
    'Aggiungi il primo capo; ogni mattina troverai qui nuovi abbinamenti.',
    'Aggiorna',
    "L'ho indossato",
    'Salva',
    'Per te',
    'Non indossati da 2 settimane',
    'Aggiunti di recente',
    'Adatti a oggi',
    'Tocca per aprire nel guardaroba',
  ],
  'es': [
    'Hoy',
    'Hoy',
    'Buenos días',
    'Buenas tardes',
    'Buenas noches',
    'El conjunto de hoy',
    'Añadir una foto',
    'Crear un conjunto',
    'Preguntar al estilista',
    'Planificar la semana',
    'Preparando conjuntos…',
    'Tu armario está vacío',
    'Añade tu primera prenda; cada mañana tendrás aquí nuevas ideas de conjuntos.',
    'Actualizar',
    'Me lo puse',
    'Guardar',
    'Para ti',
    'Sin usar desde hace 2 semanas',
    'Añadidos recientemente',
    'Adecuados para hoy',
    'Toca para abrir en tu armario',
  ],
  'zh': [
    '今天',
    '今天',
    '早上好',
    '下午好',
    '晚上好',
    '今日穿搭',
    '添加照片',
    '生成穿搭',
    '询问造型师',
    '规划一周',
    '正在准备穿搭…',
    '你的衣橱还是空的',
    '添加第一件衣物，每天早上这里都会有新的搭配建议。',
    '刷新',
    '我穿了',
    '保存',
    '为你推荐',
    '两周未穿',
    '最近添加',
    '适合今天',
    '点击在衣橱中打开',
  ],
  'ar': [
    'اليوم',
    'اليوم',
    'صباح الخير',
    'نهارك سعيد',
    'مساء الخير',
    'إطلالة اليوم',
    'أضف صورة',
    'أنشئ إطلالة',
    'اسأل المنسق',
    'خطط للأسبوع',
    'يتم تجهيز الإطلالات…',
    'خزانتك فارغة',
    'أضف أول قطعة؛ ستجد أفكار إطلالات جديدة هنا كل صباح.',
    'تحديث',
    'ارتديته',
    'حفظ',
    'لك',
    'لم تُلبس منذ أسبوعين',
    'أُضيفت مؤخرًا',
    'مناسبة لليوم',
    'اضغط لفتحها في خزانتك',
  ],
  'fr': [
    "Aujourd'hui",
    "Aujourd'hui",
    'Bonjour',
    'Bon après-midi',
    'Bonsoir',
    'La tenue du jour',
    'Ajouter une photo',
    'Créer une tenue',
    'Demander au styliste',
    'Planifier la semaine',
    'Préparation des tenues…',
    'Ton dressing est vide',
    "Ajoute ta première pièce ; chaque matin, de nouvelles idées de tenues t'attendront ici.",
    'Actualiser',
    "Je l'ai porté",
    'Enregistrer',
    'Pour toi',
    'Pas portés depuis 2 semaines',
    'Ajoutés récemment',
    "Adaptés à aujourd'hui",
    'Touche pour ouvrir dans ton dressing',
  ],
  'de': [
    'Heute',
    'Heute',
    'Guten Morgen',
    'Guten Tag',
    'Guten Abend',
    'Das Outfit von heute',
    'Foto hinzufügen',
    'Outfit erstellen',
    'Stylist fragen',
    'Woche planen',
    'Outfits werden vorbereitet…',
    'Deine Garderobe ist noch leer',
    'Füge dein erstes Teil hinzu; jeden Morgen warten hier neue Outfit-Ideen.',
    'Aktualisieren',
    'Getragen',
    'Speichern',
    'Für dich',
    'Seit 2 Wochen nicht getragen',
    'Neu hinzugefügt',
    'Passend für heute',
    'Tippen, um in der Garderobe zu öffnen',
  ],
  'pt': [
    'Hoje',
    'Hoje',
    'Bom dia',
    'Boa tarde',
    'Boa noite',
    'O look de hoje',
    'Adicionar foto',
    'Criar look',
    'Perguntar ao stylist',
    'Planear a semana',
    'A preparar looks…',
    'O teu guarda-roupa está vazio',
    'Adiciona a primeira peça; todas as manhãs terás aqui novas ideias de looks.',
    'Atualizar',
    'Usei',
    'Guardar',
    'Para ti',
    'Sem usar há 2 semanas',
    'Adicionados recentemente',
    'Adequados para hoje',
    'Toca para abrir no guarda-roupa',
  ],
  'ja': [
    '今日',
    '今日',
    'おはようございます',
    'こんにちは',
    'こんばんは',
    '今日のコーデ',
    '写真を追加',
    'コーデを作成',
    'スタイリストに聞く',
    '1週間を計画',
    'コーデを準備中…',
    'ワードローブはまだ空です',
    '最初のアイテムを追加しましょう。毎朝ここに新しいコーデの提案が届きます。',
    '更新',
    '着た',
    '保存',
    'あなたへ',
    '2週間着ていない',
    '最近追加',
    '今日に合う',
    'タップしてワードローブで開く',
  ],
  'ko': [
    '오늘',
    '오늘',
    '좋은 아침이에요',
    '좋은 오후예요',
    '좋은 저녁이에요',
    '오늘의 코디',
    '사진 추가',
    '코디 만들기',
    '스타일리스트에게 묻기',
    '한 주 계획하기',
    '코디를 준비하는 중…',
    '옷장이 비어 있어요',
    '첫 옷을 추가해 보세요. 매일 아침 새로운 코디 제안이 여기에 표시됩니다.',
    '새로고침',
    '입었어요',
    '저장',
    '당신을 위해',
    '2주 동안 입지 않은 옷',
    '최근 추가',
    '오늘에 어울리는',
    '탭하여 옷장에서 열기',
  ],
  'ru': [
    'Сегодня',
    'Сегодня',
    'Доброе утро',
    'Добрый день',
    'Добрый вечер',
    'Образ дня',
    'Добавить фото',
    'Создать образ',
    'Спросить стилиста',
    'Спланировать неделю',
    'Готовим образы…',
    'Ваш гардероб пока пуст',
    'Добавьте первую вещь; каждое утро здесь будут новые идеи образов.',
    'Обновить',
    'Надел',
    'Сохранить',
    'Для вас',
    'Не надевали 2 недели',
    'Недавно добавленные',
    'Подходят на сегодня',
    'Нажмите, чтобы открыть в гардеробе',
  ],
};

String jsonKacis(String s) =>
    s.replaceAll('\\', r'\\').replaceAll('"', r'\"');

void main() {
  final dosyalar = Directory('lib/l10n')
      .listSync()
      .whereType<File>()
      .where((f) => RegExp(r'app_[a-z]{2}\.arb$').hasMatch(f.path))
      .toList()
    ..sort((a, b) => a.path.compareTo(b.path));

  var hataVar = false;

  for (final dosya in dosyalar) {
    final dil =
        RegExp(r'app_([a-z]{2})\.arb$').firstMatch(dosya.path)!.group(1)!;
    final degerler = metinler[dil];

    if (degerler == null || degerler.length != anahtarlar.length) {
      stderr.writeln('Dil tablosu eksik/hatalı: $dil');
      hataVar = true;
      continue;
    }

    var metin = dosya.readAsStringSync();
    final eklenecekler = <String>[];

    for (var i = 0; i < anahtarlar.length; i++) {
      final anahtar = anahtarlar[i];
      if (RegExp('"${RegExp.escape(anahtar)}":').hasMatch(metin)) continue;
      eklenecekler.add(
        '  "$anahtar": "${jsonKacis(degerler[i])}",',
      );
    }

    if (eklenecekler.isNotEmpty) {
      final kapanisIndex = metin.lastIndexOf('}');
      var govde = metin.substring(0, kapanisIndex);
      final kapanis = metin.substring(kapanisIndex);
      govde = govde.replaceAll(RegExp(r'[\s,]+$'), '');
      var blok = eklenecekler.join('\n');
      blok = blok.replaceRange(
          blok.lastIndexOf(','), blok.lastIndexOf(',') + 1, '');
      metin = '$govde,\n$blok\n$kapanis';
    }

    dosya.writeAsStringSync(metin, flush: true);
    stdout.writeln('$dil: ${eklenecekler.length} anahtar eklendi');
  }

  if (hataVar) exitCode = 1;
}
