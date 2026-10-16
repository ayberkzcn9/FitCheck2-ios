// AI hedef dil eşlemesi - tüm 12 dil için tek kaynak.
// AI (yapay zekâ) yanıtlarının uygulamanın seçili dilinde üretilmesi için
// dil kodunu İngilizce dil adına çevirir.

/// Dil kodunu (ör. 'tr', 'ru') AI'nın anlayacağı dil adına çevirir.
/// Tüm desteklenen 12 dil kapsanır; bilinmeyen durumda İngilizce'ye döner.
String aiHedefDil(String dilKodu) {
  switch (dilKodu) {
    case 'tr':
      return 'TURKISH';
    case 'en':
      return 'ENGLISH';
    case 'de':
      return 'GERMAN';
    case 'fr':
      return 'FRENCH';
    case 'es':
      return 'SPANISH';
    case 'it':
      return 'ITALIAN';
    case 'pt':
      return 'PORTUGUESE';
    case 'ru':
      return 'RUSSIAN';
    case 'ar':
      return 'ARABIC';
    case 'ja':
      return 'JAPANESE';
    case 'ko':
      return 'KOREAN';
    case 'zh':
      return 'CHINESE';
    default:
      return 'ENGLISH';
  }
}

/// Konuşma tanıma (speech-to-text) için platform dil kodu.
/// Tüm desteklenen 12 dil kapsanır; bilinmeyen durumda İngilizce'ye döner.
String konusmaDiliKodu(String dilKodu) {
  switch (dilKodu) {
    case 'tr':
      return 'tr_TR';
    case 'en':
      return 'en_US';
    case 'de':
      return 'de_DE';
    case 'fr':
      return 'fr_FR';
    case 'es':
      return 'es_ES';
    case 'it':
      return 'it_IT';
    case 'pt':
      return 'pt_PT';
    case 'ru':
      return 'ru_RU';
    case 'ar':
      return 'ar_SA';
    case 'ja':
      return 'ja_JP';
    case 'ko':
      return 'ko_KR';
    case 'zh':
      return 'zh_CN';
    default:
      return 'en_US';
  }
}

/// Kullanıcının kayıtlı cinsiyet değerini (Türkçe saklanır: 'Kadın',
/// 'Erkek', 'Belirtilmemiş') yapay zekâ istemleri için nötr/İngilizce
/// bir terime çevirir.
String aiCinsiyet(String ham) {
  final s = ham.toLowerCase().trim();
  if (s == 'erkek' || s == 'male' || s == 'man') return 'male';
  if (s == 'belirtilmemiş' ||
      s == 'belirtilmemis' ||
      s == 'unspecified' ||
      s == 'not specified') {
    return 'unspecified (do not assume a gender)';
  }
  return 'female';
}

/// Kullanıcının kayıtlı stil tercihini (cihaz diline göre Türkçe/İngilizce
/// saklanabilir, ör. 'Spor', 'Klasik / Ofis', 'Streetwear / Casual')
/// yapay zekâ istemleri için İngilizce/nötr bir terime çevirir.
String aiTarz(String ham) {
  final s = ham.toLowerCase().trim();
  if (s.contains('streetwear') || s.contains('sokak') || s.contains('casual')) {
    return 'Streetwear / Casual';
  }
  if (s.contains('klasik') ||
      s.contains('classic') ||
      s.contains('ofis') ||
      s.contains('office') ||
      s.contains('formal')) {
    return 'Classic / Smart';
  }
  if (s.contains('minimal')) return 'Minimalist';
  if (s.contains('spor') || s.contains('sport') || s.contains('athleisure')) {
    return 'Sporty / Athleisure';
  }
  if (s.contains('vintage') || s.contains('retro')) return 'Vintage / Retro';
  return 'General';
}

/// Kullanıcının kayıtlı renk paleti tercihini (ör. 'Koyu Tonlar', 'Pastel',
/// 'Canlı', 'Nötr') yapay zekâ istemleri için İngilizce terime çevirir.
String aiRenkPaleti(String ham) {
  final s = ham.toLowerCase().trim();
  if (s.contains('koyu') || s.contains('dark')) return 'Dark tones';
  if (s.contains('pastel')) return 'Pastel';
  if (s.contains('canlı') ||
      s.contains('canli') ||
      s.contains('vibrant') ||
      s.contains('bright') ||
      s.contains('bold')) {
    return 'Vibrant / Bold';
  }
  if (s.contains('nötr') ||
      s.contains('notr') ||
      s.contains('neutral')) {
    return 'Neutral';
  }
  return 'Mixed';
}

/// Kullanıcının kayıtlı ten rengi değerini (anahtar: 'light'/'wheat'/'dark'
/// ya da yerelleştirilmiş etiket) yapay zekâ istemleri için İngilizce
/// terime çevirir. Dönen değer, istemdeki ten önerisi başlıklarıyla eşleşir.
String aiTenRengi(String ham) {
  final s = ham.toLowerCase().trim();
  if (s == 'light' ||
      s.contains('açık') ||
      s.contains('acik') ||
      s.contains('beyaz') ||
      s.contains('fair')) {
    return 'Fair/Light';
  }
  if (s == 'dark' || s.contains('esmer') || s.contains('koyu') || s.contains('deep')) {
    return 'Dark/Tan';
  }
  return 'Wheat/Medium/Warm';
}

/// Kullanıcı mesajında "kombin isteniyor mu" tespiti için çok dilli
/// anahtar kelimeler. Her dilde kombin/giyim talebini yakalar.
const List<String> kombinIstegiAnahtarKelimeleri = [ // Türkçe
  'kombin',
  'giy',
  'öner',
  'seç',
  'hazırla',
  'bul',
  'ne giyeyim',
  'yardımcı ol',
  'kıyafet',
  'stil',
  // İngilizce
  'outfit',
  'wear',
  'suggest',
  'style',
  'look',
  'dress',
  'help me',
  // Almanca
  'outfit',
  'anziehen',
  'empfehl',
  'stil',
  'kleidung',
  // Fransızca
  'tenue',
  'porter',
  'suggér',
  'style',
  'vêtement',
  'look',
  // İspanyolca
  'conjunto',
  'atuendo',
  'llevar',
  'sugerir',
  'estilo',
  'ropa',
  // İtalyanca
  'outfit',
  'indossare',
  'suggerisci',
  'stile',
  'vestito',
  // Portekizce
  'look',
  'vestir',
  'sugerir',
  'estilo',
  'roupa',
  // Rusça
  'образ',
  'надеть',
  'предлож',
  'стиль',
  'одежд',
  // Arapça
  'طقم',
  'إطلالة',
  'ارتد',
  'اقترح',
  'أسلوب',
  // Japonca
  'コーデ',
  '服',
  '着',
  '提案',
  'スタイル',
  // Korece
  '코디',
  '옷',
  '입',
  '추천',
  '스타일',
  // Çince
  '搭配',
  '穿',
  '推荐',
  '风格',
  '服装',
];
