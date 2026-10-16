// FitCheck — Premium paywall metinlerini 12 dilin ARB dosyasına işler.
//
// Neden betik: 12 dil x ~19 metin = 200+ düzenleme. Betik, mevcut JSON
// biçimini koruyarak yalnızca ilgili değerleri değiştirir ve eksik anahtarları
// sona ekler. Çalıştırma: dart run tool/premium_l10n_guncelle.dart
import 'dart:io';

/// Mevcut anahtarların yeni değerleri (dil kodu -> anahtar -> metin).
const Map<String, Map<String, String>> guncellenenler = {
  'tr': {
    'premiumBaslik': 'Sınırsız stil, sıfır reklam',
    'premiumAciklama':
        'Kombinlerini ve stil analizlerini sınırsız kullan, tüm reklamları kaldır. Tek bir avantajlı abonelikle.',
    'premiumAktifMesaji':
        'Premium aktif. Sınırsız kullanım ve reklamsız deneyim açık.',
    'premiumAboneOl': 'Abone ol',
    'premiumAboneOlFiyatli': 'Abone ol • {fiyat}',
    'premiumAylikBaslik': 'FitCheck Premium',
    'premiumAylikAltBaslik': 'Sınırsız kombin • ayda {fiyat}',
    'premiumGec': 'Sınırsız kullan • {fiyat}/ay',
  },
  'en': {
    'premiumBaslik': 'Unlimited style, zero ads',
    'premiumAciklama':
        'Use your outfits and style analyses without limits and remove all ads with a single subscription.',
    'premiumAktifMesaji':
        'Premium is active. Unlimited use and an ad-free experience are on.',
    'premiumAboneOl': 'Subscribe',
    'premiumAboneOlFiyatli': 'Subscribe • {fiyat}',
    'premiumAylikBaslik': 'FitCheck Premium',
    'premiumAylikAltBaslik': 'Unlimited outfits • {fiyat}/month',
    'premiumGec': 'Go unlimited • {fiyat}/mo',
  },
  'it': {
    'premiumBaslik': 'Stile illimitato, zero pubblicità',
    'premiumAciklama':
        'Usa outfit e analisi di stile senza limiti e rimuovi tutte le pubblicità con un solo abbonamento.',
    'premiumAktifMesaji':
        'Premium attivo. Uso illimitato e nessuna pubblicità.',
    'premiumAboneOl': 'Abbonati',
    'premiumAboneOlFiyatli': 'Abbonati • {fiyat}',
    'premiumAylikBaslik': 'FitCheck Premium',
    'premiumAylikAltBaslik': 'Outfit illimitati • {fiyat} al mese',
    'premiumGec': 'Passa a illimitato • {fiyat}/mese',
  },
  'es': {
    'premiumBaslik': 'Estilo ilimitado, cero anuncios',
    'premiumAciklama':
        'Usa tus conjuntos y análisis de estilo sin límites y elimina todos los anuncios con una sola suscripción.',
    'premiumAktifMesaji': 'Premium activo. Uso ilimitado y sin anuncios.',
    'premiumAboneOl': 'Suscríbete',
    'premiumAboneOlFiyatli': 'Suscríbete • {fiyat}',
    'premiumAylikBaslik': 'FitCheck Premium',
    'premiumAylikAltBaslik': 'Conjuntos ilimitados • {fiyat}/mes',
    'premiumGec': 'Hazte ilimitado • {fiyat}/mes',
  },
  'fr': {
    'premiumBaslik': 'Style illimité, zéro pub',
    'premiumAciklama':
        'Utilise tes tenues et tes analyses de style sans limite et supprime toutes les publicités avec un seul abonnement.',
    'premiumAktifMesaji':
        'Premium est actif. Utilisation illimitée et sans publicité.',
    'premiumAboneOl': 'S\'abonner',
    'premiumAboneOlFiyatli': 'S\'abonner • {fiyat}',
    'premiumAylikBaslik': 'FitCheck Premium',
    'premiumAylikAltBaslik': 'Tenues illimitées • {fiyat}/mois',
    'premiumGec': 'Passe à l\'illimité • {fiyat}/mois',
  },
  'de': {
    'premiumBaslik': 'Unbegrenzter Stil, keine Werbung',
    'premiumAciklama':
        'Nutze Outfits und Stilanalysen unbegrenzt und entferne mit einem Abo alle Werbung.',
    'premiumAktifMesaji':
        'Premium ist aktiv. Unbegrenzte Nutzung und keine Werbung.',
    'premiumAboneOl': 'Abonnieren',
    'premiumAboneOlFiyatli': 'Abonnieren • {fiyat}',
    'premiumAylikBaslik': 'FitCheck Premium',
    'premiumAylikAltBaslik': 'Unbegrenzte Outfits • {fiyat}/Monat',
    'premiumGec': 'Unbegrenzt nutzen • {fiyat}/Monat',
  },
  'pt': {
    'premiumBaslik': 'Estilo ilimitado, zero anúncios',
    'premiumAciklama':
        'Usa os teus looks e análises de estilo sem limites e remove todos os anúncios com uma única subscrição.',
    'premiumAktifMesaji':
        'Premium ativo. Utilização ilimitada e sem anúncios.',
    'premiumAboneOl': 'Subscrever',
    'premiumAboneOlFiyatli': 'Subscrever • {fiyat}',
    'premiumAylikBaslik': 'FitCheck Premium',
    'premiumAylikAltBaslik': 'Looks ilimitados • {fiyat}/mês',
    'premiumGec': 'Passar a ilimitado • {fiyat}/mês',
  },
  'ru': {
    'premiumBaslik': 'Безлимитный стиль, без рекламы',
    'premiumAciklama':
        'Пользуйся образами и анализом стиля без ограничений и отключи всю рекламу одной подпиской.',
    'premiumAktifMesaji':
        'Premium активен. Безлимитный доступ и без рекламы.',
    'premiumAboneOl': 'Подписаться',
    'premiumAboneOlFiyatli': 'Подписаться • {fiyat}',
    'premiumAylikBaslik': 'FitCheck Premium',
    'premiumAylikAltBaslik': 'Безлимитные образы • {fiyat}/мес.',
    'premiumGec': 'Безлимит • {fiyat}/мес.',
  },
  'ar': {
    'premiumBaslik': 'أناقة بلا حدود وبدون إعلانات',
    'premiumAciklama':
        'استخدم إطلالاتك وتحليلات الأناقة بلا حدود وأزل كل الإعلانات باشتراك واحد.',
    'premiumAktifMesaji': 'Premium مفعّل. استخدام بلا حدود وبدون إعلانات.',
    'premiumAboneOl': 'اشترك',
    'premiumAboneOlFiyatli': 'اشترك • {fiyat}',
    'premiumAylikBaslik': 'FitCheck Premium',
    'premiumAylikAltBaslik': 'إطلالات بلا حدود • {fiyat} شهريًا',
    'premiumGec': 'استخدم بلا حدود • {fiyat}/شهر',
  },
  'zh': {
    'premiumBaslik': '风格无限制，零广告',
    'premiumAciklama': '无限制使用搭配和风格分析，并通过一次订阅移除所有广告。',
    'premiumAktifMesaji': 'Premium 已生效。无限使用且无广告。',
    'premiumAboneOl': '订阅',
    'premiumAboneOlFiyatli': '订阅 • {fiyat}',
    'premiumAylikBaslik': 'FitCheck Premium',
    'premiumAylikAltBaslik': '无限制搭配 • 每月 {fiyat}',
    'premiumGec': '无限使用 • {fiyat}/月',
  },
  'ja': {
    'premiumBaslik': 'スタイル無制限、広告ゼロ',
    'premiumAciklama':
        'コーデとスタイル分析を無制限に使えて、1つのサブスクリプションで広告をすべて削除。',
    'premiumAktifMesaji': 'Premiumが有効です。無制限で広告もありません。',
    'premiumAboneOl': '登録する',
    'premiumAboneOlFiyatli': '登録する • {fiyat}',
    'premiumAylikBaslik': 'FitCheck Premium',
    'premiumAylikAltBaslik': 'コーデ無制限 • 月 {fiyat}',
    'premiumGec': '無制限で使う • {fiyat}/月',
  },
  'ko': {
    'premiumBaslik': '무제한 스타일, 광고 없음',
    'premiumAciklama':
        '코디와 스타일 분석을 무제한으로 사용하고 하나의 구독으로 모든 광고를 제거하세요.',
    'premiumAktifMesaji': 'Premium이 활성화되었습니다. 무제한 사용과 광고 없음.',
    'premiumAboneOl': '구독하기',
    'premiumAboneOlFiyatli': '구독하기 • {fiyat}',
    'premiumAylikBaslik': 'FitCheck Premium',
    'premiumAylikAltBaslik': '무제한 코디 • 월 {fiyat}',
    'premiumGec': '무제한 사용 • {fiyat}/월',
  },
};

/// Yeni anahtarlar (dil kodu -> anahtar -> metin). Sırayla dosya sonuna eklenir.
const Map<String, Map<String, String>> yeniler = {
  'tr': {
    'premiumOzelliklerBaslik': 'Premium ile neler kazanırsın?',
    'premiumOzellikSinirsizKombin': 'Sınırsız kombin oluşturma',
    'premiumOzellikSinirsizAnaliz': 'Sınırsız yapay zekâ stil analizi',
    'premiumOzellikSinirsizGardirob': 'Sınırsız gardırop alanı',
    'premiumPlanAylik': 'Aylık',
    'premiumPlanYillik': 'Yıllık',
    'premiumEnAvantajli': 'EN AVANTAJLI',
    'premiumTasarrufYuzde': '%{yuzde} tasarruf',
    'premiumDenemeRozeti': '{gun} GÜN ÜCRETSİZ',
    'premiumDenemeSonrasi': 'Deneme bitince {fiyat}',
    'premiumYenilemeNotu':
        'Abonelik, dönem sonunda otomatik yenilenir. İstediğin zaman iptal edebilirsin.',
  },
  'en': {
    'premiumOzelliklerBaslik': 'What you unlock with Premium',
    'premiumOzellikSinirsizKombin': 'Unlimited outfit creation',
    'premiumOzellikSinirsizAnaliz': 'Unlimited AI style analysis',
    'premiumOzellikSinirsizGardirob': 'Unlimited wardrobe space',
    'premiumPlanAylik': 'Monthly',
    'premiumPlanYillik': 'Yearly',
    'premiumEnAvantajli': 'BEST VALUE',
    'premiumTasarrufYuzde': 'Save {yuzde}%',
    'premiumDenemeRozeti': '{gun}-DAY FREE TRIAL',
    'premiumDenemeSonrasi': 'Then {fiyat}',
    'premiumYenilemeNotu':
        'Subscription renews automatically at the end of each period. Cancel anytime.',
  },
  'it': {
    'premiumOzelliklerBaslik': 'Cosa sblocchi con Premium',
    'premiumOzellikSinirsizKombin': 'Creazione di outfit illimitata',
    'premiumOzellikSinirsizAnaliz': 'Analisi di stile AI illimitata',
    'premiumOzellikSinirsizGardirob': 'Spazio guardaroba illimitato',
    'premiumPlanAylik': 'Mensile',
    'premiumPlanYillik': 'Annuale',
    'premiumEnAvantajli': 'PIÙ CONVENIENTE',
    'premiumTasarrufYuzde': 'Risparmia il {yuzde}%',
    'premiumDenemeRozeti': '{gun} GIORNI GRATIS',
    'premiumDenemeSonrasi': 'Poi {fiyat}',
    'premiumYenilemeNotu':
        'L\'abbonamento si rinnova automaticamente alla fine di ogni periodo. Puoi annullare quando vuoi.',
  },
  'es': {
    'premiumOzelliklerBaslik': 'Lo que desbloqueas con Premium',
    'premiumOzellikSinirsizKombin': 'Creación de conjuntos ilimitada',
    'premiumOzellikSinirsizAnaliz': 'Análisis de estilo con IA ilimitado',
    'premiumOzellikSinirsizGardirob': 'Espacio de armario ilimitado',
    'premiumPlanAylik': 'Mensual',
    'premiumPlanYillik': 'Anual',
    'premiumEnAvantajli': 'MEJOR OPCIÓN',
    'premiumTasarrufYuzde': 'Ahorra un {yuzde}%',
    'premiumDenemeRozeti': '{gun} DÍAS GRATIS',
    'premiumDenemeSonrasi': 'Luego {fiyat}',
    'premiumYenilemeNotu':
        'La suscripción se renueva automáticamente al final de cada período. Cancela cuando quieras.',
  },
  'fr': {
    'premiumOzelliklerBaslik': 'Ce que Premium débloque',
    'premiumOzellikSinirsizKombin': 'Création de tenues illimitée',
    'premiumOzellikSinirsizAnaliz': 'Analyse de style IA illimitée',
    'premiumOzellikSinirsizGardirob': 'Espace dressing illimité',
    'premiumPlanAylik': 'Mensuel',
    'premiumPlanYillik': 'Annuel',
    'premiumEnAvantajli': 'MEILLEUR CHOIX',
    'premiumTasarrufYuzde': 'Économisez {yuzde} %',
    'premiumDenemeRozeti': '{gun} JOURS GRATUITS',
    'premiumDenemeSonrasi': 'Puis {fiyat}',
    'premiumYenilemeNotu':
        'L\'abonnement se renouvelle automatiquement à la fin de chaque période. Annulable à tout moment.',
  },
  'de': {
    'premiumOzelliklerBaslik': 'Das schaltet Premium frei',
    'premiumOzellikSinirsizKombin': 'Unbegrenzt Outfits erstellen',
    'premiumOzellikSinirsizAnaliz': 'Unbegrenzte KI-Stilanalyse',
    'premiumOzellikSinirsizGardirob': 'Unbegrenzter Kleiderschrank',
    'premiumPlanAylik': 'Monatlich',
    'premiumPlanYillik': 'Jährlich',
    'premiumEnAvantajli': 'BESTES ANGEBOT',
    'premiumTasarrufYuzde': '{yuzde} % sparen',
    'premiumDenemeRozeti': '{gun} TAGE GRATIS',
    'premiumDenemeSonrasi': 'Danach {fiyat}',
    'premiumYenilemeNotu':
        'Das Abo verlängert sich am Ende jeder Periode automatisch. Jederzeit kündbar.',
  },
  'pt': {
    'premiumOzelliklerBaslik': 'O que desbloqueias com o Premium',
    'premiumOzellikSinirsizKombin': 'Criação de looks ilimitada',
    'premiumOzellikSinirsizAnaliz': 'Análise de estilo com IA ilimitada',
    'premiumOzellikSinirsizGardirob': 'Espaço de guarda-roupa ilimitado',
    'premiumPlanAylik': 'Mensal',
    'premiumPlanYillik': 'Anual',
    'premiumEnAvantajli': 'MELHOR OPÇÃO',
    'premiumTasarrufYuzde': 'Poupa {yuzde}%',
    'premiumDenemeRozeti': '{gun} DIAS GRÁTIS',
    'premiumDenemeSonrasi': 'Depois {fiyat}',
    'premiumYenilemeNotu':
        'A subscrição renova automaticamente no fim de cada período. Cancelas quando quiseres.',
  },
  'ru': {
    'premiumOzelliklerBaslik': 'Что открывает Premium',
    'premiumOzellikSinirsizKombin': 'Неограниченное создание образов',
    'premiumOzellikSinirsizAnaliz': 'Неограниченный ИИ-анализ стиля',
    'premiumOzellikSinirsizGardirob': 'Неограниченное место в гардеробе',
    'premiumPlanAylik': 'Месяц',
    'premiumPlanYillik': 'Год',
    'premiumEnAvantajli': 'ЛУЧШИЙ ВЫБОР',
    'premiumTasarrufYuzde': 'Скидка {yuzde}%',
    'premiumDenemeRozeti': '{gun} ДНЕЙ БЕСПЛАТНО',
    'premiumDenemeSonrasi': 'Затем {fiyat}',
    'premiumYenilemeNotu':
        'Подписка продлевается автоматически в конце каждого периода. Отменить можно в любое время.',
  },
  'ar': {
    'premiumOzelliklerBaslik': 'ما الذي يفتحه لك Premium',
    'premiumOzellikSinirsizKombin': 'إنشاء إطلالات بلا حدود',
    'premiumOzellikSinirsizAnaliz': 'تحليل الأناقة بالذكاء الاصطناعي بلا حدود',
    'premiumOzellikSinirsizGardirob': 'مساحة خزانة بلا حدود',
    'premiumPlanAylik': 'شهري',
    'premiumPlanYillik': 'سنوي',
    'premiumEnAvantajli': 'الأفضل قيمة',
    'premiumTasarrufYuzde': 'وفّر {yuzde}%',
    'premiumDenemeRozeti': '{gun} أيام مجانًا',
    'premiumDenemeSonrasi': 'ثم {fiyat}',
    'premiumYenilemeNotu':
        'يتجدد الاشتراك تلقائيًا في نهاية كل فترة. يمكنك الإلغاء في أي وقت.',
  },
  'zh': {
    'premiumOzelliklerBaslik': 'Premium 解锁的内容',
    'premiumOzellikSinirsizKombin': '无限制搭配生成',
    'premiumOzellikSinirsizAnaliz': '无限制 AI 风格分析',
    'premiumOzellikSinirsizGardirob': '无限制衣橱空间',
    'premiumPlanAylik': '按月',
    'premiumPlanYillik': '按年',
    'premiumEnAvantajli': '最超值',
    'premiumTasarrufYuzde': '省 {yuzde}%',
    'premiumDenemeRozeti': '{gun} 天免费',
    'premiumDenemeSonrasi': '之后 {fiyat}',
    'premiumYenilemeNotu': '订阅将在每个周期结束时自动续订。可随时取消。',
  },
  'ja': {
    'premiumOzelliklerBaslik': 'Premiumで使えるもの',
    'premiumOzellikSinirsizKombin': 'コーデ作成が無制限',
    'premiumOzellikSinirsizAnaliz': 'AIスタイル分析が無制限',
    'premiumOzellikSinirsizGardirob': 'クローゼット容量が無制限',
    'premiumPlanAylik': '月払い',
    'premiumPlanYillik': '年払い',
    'premiumEnAvantajli': 'いちばんお得',
    'premiumTasarrufYuzde': '{yuzde}% お得',
    'premiumDenemeRozeti': '{gun}日間無料',
    'premiumDenemeSonrasi': 'その後 {fiyat}',
    'premiumYenilemeNotu':
        'サブスクリプションは各期間の終了時に自動更新されます。いつでも解約できます。',
  },
  'ko': {
    'premiumOzelliklerBaslik': 'Premium로 열리는 것',
    'premiumOzellikSinirsizKombin': '무제한 코디 생성',
    'premiumOzellikSinirsizAnaliz': '무제한 AI 스타일 분석',
    'premiumOzellikSinirsizGardirob': '무제한 옷장 공간',
    'premiumPlanAylik': '월간',
    'premiumPlanYillik': '연간',
    'premiumEnAvantajli': '가장 이득',
    'premiumTasarrufYuzde': '{yuzde}% 절약',
    'premiumDenemeRozeti': '{gun}일 무료',
    'premiumDenemeSonrasi': '이후 {fiyat}',
    'premiumYenilemeNotu':
        '구독은 각 기간 종료 시 자동으로 갱신됩니다. 언제든지 해지할 수 있습니다.',
  },
};

/// Parametreli yeni anahtarların yer tutucu tipleri.
const Map<String, String> yerTutucuTipleri = {
  'premiumTasarrufYuzde': 'int',
  'premiumDenemeRozeti': 'int',
  'premiumDenemeSonrasi': 'String',
};

/// Yeni anahtarların dosyaya eklenme sırası (sonuncusu düz metin olmalı).
const List<String> eklemeSirasi = [
  'premiumOzelliklerBaslik',
  'premiumOzellikSinirsizKombin',
  'premiumOzellikSinirsizAnaliz',
  'premiumOzellikSinirsizGardirob',
  'premiumPlanAylik',
  'premiumPlanYillik',
  'premiumEnAvantajli',
  'premiumTasarrufYuzde',
  'premiumDenemeRozeti',
  'premiumDenemeSonrasi',
  'premiumYenilemeNotu',
];

String jsonKacis(String s) =>
    s.replaceAll('\\', r'\\').replaceAll('"', r'\"');

String yerTutucuBlogu(String anahtar) {
  final ad = yerTutucuTipleri[anahtar]!;
  final yerAdi = anahtar == 'premiumTasarrufYuzde'
      ? 'yuzde'
      : anahtar == 'premiumDenemeRozeti'
          ? 'gun'
          : 'fiyat';
  return '  "@$anahtar": {\n'
      '    "placeholders": {\n'
      '      "$yerAdi": {\n'
      '        "type": "$ad"\n'
      '      }\n'
      '    }\n'
      '  },';
}

void main() {
  final dosyalar = Directory('lib/l10n')
      .listSync()
      .whereType<File>()
      .where((f) => RegExp(r'app_[a-z]{2}\.arb$').hasMatch(f.path))
      .toList()
    ..sort((a, b) => a.path.compareTo(b.path));

  var hataVar = false;

  for (final dosya in dosyalar) {
    final dil = RegExp(r'app_([a-z]{2})\.arb$').firstMatch(dosya.path)!.group(1)!;
    final guncel = guncellenenler[dil];
    final yeni = yeniler[dil];
    if (guncel == null || yeni == null) {
      stderr.writeln('Dil tablosu eksik: $dil');
      hataVar = true;
      continue;
    }

    var metin = dosya.readAsStringSync();
    final eklenecekler = <String>[];
    var guncellenen = 0;

    // 1) Mevcut anahtarların değerleri yenilenir.
    guncel.forEach((anahtar, deger) {
      final desen = RegExp(
        '"${RegExp.escape(anahtar)}":\\s*"(?:[^"\\\\]|\\\\.)*"',
      );
      final yerine = '"$anahtar": "${jsonKacis(deger)}"';
      if (desen.hasMatch(metin)) {
        metin = metin.replaceFirst(desen, yerine);
        guncellenen++;
      } else {
        // Anahtar bu dilde yoksa sona eklenir.
        eklenecekler.add('  "$anahtar": "${jsonKacis(deger)}",');
      }
    });

    // 2) Yeni anahtarlar sırayla sona eklenir.
    for (final anahtar in eklemeSirasi) {
      final deger = yeni[anahtar];
      if (deger == null) {
        stderr.writeln('Yeni anahtar eksik: $dil/$anahtar');
        hataVar = true;
        continue;
      }
      final desen = RegExp('"${RegExp.escape(anahtar)}":');
      if (desen.hasMatch(metin)) {
        // Zaten eklenmiş (betik ikinci kez çalıştırıldı).
        continue;
      }
      eklenecekler.add('  "$anahtar": "${jsonKacis(deger)}",');
      if (yerTutucuTipleri.containsKey(anahtar)) {
        eklenecekler.add(yerTutucuBlogu(anahtar));
      }
    }

    if (eklenecekler.isNotEmpty) {
      final kapanisIndex = metin.lastIndexOf('}');
      var govde = metin.substring(0, kapanisIndex);
      final kapanis = metin.substring(kapanisIndex);
      govde = govde.replaceAll(RegExp(r'[\s,]+$'), '');
      var blok = eklenecekler.join('\n');
      // En son satırın sonundaki virgül kaldırılır (geçerli JSON için).
      blok = blok.replaceRange(
        blok.lastIndexOf(','),
        blok.lastIndexOf(',') + 1,
        '',
      );
      metin = '$govde,\n$blok\n$kapanis';
    }

    dosya.writeAsStringSync(metin, flush: true);
    stdout.writeln('$dil: $guncellenen güncellendi, '
        '${eklenecekler.where((l) => l.trimLeft().startsWith('"premium')).length} eklendi');
  }

  if (hataVar) {
    exitCode = 1;
  }
}
