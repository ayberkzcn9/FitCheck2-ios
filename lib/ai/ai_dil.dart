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
