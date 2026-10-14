// Haftalık planlayıcı AI prompt şablonları
// Tüm prompt'lar merkezi buradan yönetilir; inline string karmaşası önlenir.

/// Ortak sistem promptu - sadece dil değişkeni alır
String sistemPromptuDil(String hedefDil, {String? ekKural}) {
  final buffer = StringBuffer();
  buffer.writeln('Return ONLY a valid JSON.');
  buffer.writeln('You MUST write all textual fields in **$hedefDil** language.');
  if (ekKural != null && ekKural.isNotEmpty) {
    buffer.writeln(ekKural);
  }
  return buffer.toString();
}

/// 1. Kombin yeniden analiz promptu (tek gün için renk uyumu + tuyo)
Map<String, String> analizPromptu({
  required String hedefDil,
  required String tenRengi,
  required String gunHavasi,
  required List<dynamic> parcalar,
}) {
  final sistemPromptu = sistemPromptuDil(hedefDil);
  final kullaniciMesaji = '''
Analyze outfit harmony and skin complexion compatibility ($tenRengi).

User Skin Complexion: $tenRengi

Weather for that day: ${gunHavasi.isEmpty ? 'UNKNOWN' : gunHavasi}

Outfit items:
${parcalar.join("\n")}

WEATHER MATCH RULE: If the outfit is not suitable for that day's weather (summer pieces like shorts, linen, sleeveless tops, sandals in cold weather below 12°C; winter pieces like wool, coat, parka, down, boots in hot weather above 28°C), say so clearly in the 'tuyo' field and lower the score accordingly.

Respond ONLY with this JSON structure:
{
  "renk_uyumu_puani": 85,
  "tuyo": "Constructive style advice in $hedefDil..."
}
''';

  return {
    'sistemPromptu': sistemPromptu,
    'kullaniciMesaji': kullaniciMesaji.trim(),
  };
}

/// 2. Eksik üst/alt parçası için stilistin metin önerisi
Map<String, String> eksikParcaStilistPromptu({
  required String hedefDil,
  required String cinsiyet,
  required String tarz,
  required String renkPaleti,
  required String tenRengi,
  required String envanter,
  required String eksikKategoriler,
  required String gunlukHava,
  required String detayliHaftalikHava,
}) {
  final sistemPromptu = sistemPromptuDil(hedefDil);
  final kullaniciMesaji = '''
You are an expert AI fashion stylist. The user's clean wardrobe has no top ('ust') and no bottom ('alt') item, so no full outfit can be built from the wardrobe. Write a stylist text recommendation instead.

User Profile:
- Gender: $cinsiyet
- Style Preference: $tarz
- Color Palette: $renkPaleti
- Skin Complexion: $tenRengi

Clean Inventory:
${envanter.isEmpty ? 'none' : envanter}

Missing Categories (no clean item available): ${eksikKategoriler.isEmpty ? 'none' : eksikKategoriler}

Today's Weather: $gunlukHava
Weekly Weather:
$detayliHaftalikHava

CRITICAL RULES:
1. Write a short stylist recommendation (2-4 sentences) describing a COMPLETE outfit: a top ('ust'), a bottom ('alt') and shoes ('ayakkabi').
2. For categories that ARE available in the clean inventory, refer to the existing item by its title instead of inventing a new one.
3. For the missing categories, describe what kind of piece to add; mention the missing category clearly so the user knows what to buy.
4. The recommendation MUST fit the weather above: never suggest summer pieces (shorts, linen, sleeveless tops, sandals) when it is below 12°C, and never suggest winter pieces (wool, coat, parka, down, boots) when it is above 28°C.
5. NEVER use "Clean Item #" references and never claim the user owns a piece that is listed as missing.
6. Write everything in $hedefDil, plain text only: no markdown, no emojis, no JSON inside the text.

Respond ONLY with this JSON structure:
{
  "oneri": "Complete outfit recommendation (ust + alt + ayakkabi) written in $hedefDil."
}
''';

  return {
    'sistemPromptu': sistemPromptu,
    'kullaniciMesaji': kullaniciMesaji.trim(),
  };
}

/// 3. Boş günler için stilistin önerileri (birden fazla gün)
Map<String, String> bosGunlerStilistPromptu({
  required String hedefDil,
  required String cinsiyet,
  required String tarz,
  required String renkPaleti,
  required String tenRengi,
  required String envanter,
  required String eksikKategoriler,
  required String detayliHaftalikHava,
  required String gunListesi,
  required List<String> bosGunAdlari,
}) {
  final sistemPromptu = sistemPromptuDil(hedefDil);
  final kullaniciMesaji = '''
You are an expert AI fashion stylist. The clean wardrobe does not have enough items left to build outfits for some days of the week, so those days would look empty. For EVERY day listed below, write a plain-text stylist recommendation describing a COMPLETE outfit: a top ('ust'), a bottom ('alt') and shoes ('ayakkabi').

User Profile:
- Gender: $cinsiyet
- Style Preference: $tarz
- Color Palette: $renkPaleti
- Skin Complexion: $tenRengi

Clean Inventory:
${envanter.isEmpty ? 'none' : envanter}

Missing Categories (no clean item available): ${eksikKategoriler.isEmpty ? 'none' : eksikKategoriler}

7-Day Weather Forecast:
$detayliHaftalikHava

Days That Need A Suggestion:
$gunListesi

CRITICAL RULES:
1. Return EXACTLY one entry per day listed above, in the same order, and copy the day name exactly as written.
2. Each 'oneri' must be a short plain-text recommendation (2-3 sentences) covering ust + alt + ayakkabi, mentioning type, color and fabric, and must match that day's weather.
3. These pieces are recommendations, NOT inventory: never use 'Clean Item #' references and never claim the user owns them. If a suitable piece exists in the clean inventory, you may refer to its title.
4. Never suggest summer pieces (shorts, linen, sleeveless tops, sandals) below 12°C and never winter pieces (wool, coat, parka, down, boots) above 28°C.
5. Write everything in $hedefDil: plain text only, no markdown and no emojis.

Respond ONLY with this JSON structure:
{
  "gunler": [
    {"gun": "${bosGunAdlari.isNotEmpty ? bosGunAdlari.first : 'day name in $hedefDil'}", "oneri": "Complete outfit recommendation (ust + alt + ayakkabi) in $hedefDil."}
  ]
}
''';

  return {
    'sistemPromptu': sistemPromptu,
    'kullaniciMesaji': kullaniciMesaji.trim(),
  };
}

/// 4. Ana haftalık plan üretim promptu (en kapsamlı)
Map<String, String> haftalikPlanPromptu({
  required String hedefDil,
  required int aiPlanGunSayisi,
  required bool bugununKombiniKorunacak,
  required String cinsiyet,
  required String tarz,
  required String renkPaleti,
  required String tenRengi,
  required String envanter,
  required String eksikKategoriler,
  required String detayliHaftalikHava,
}) {
  final sistemPromptu = sistemPromptuDil(
    hedefDil,
    ekKural: "All descriptive texts ('kombin_adi', 'tuyo', 'gun') must be in **$hedefDil** language.",
  );
  final kullaniciMesaji = '''
You are an expert AI fashion stylist. Create a $aiPlanGunSayisi-DAY outfit plan ${bugununKombiniKorunacak ? 'starting tomorrow because today is already worn' : 'starting today'}. Do not include days before the requested start day.

User Profile:
- Gender: $cinsiyet
- Style Preference: $tarz
- Color Palette: $renkPaleti
- Skin Complexion: $tenRengi

Clean Inventory:
$envanter

Missing Categories (no clean item available - NEVER invent items for these):
${eksikKategoriler.isEmpty ? 'none' : eksikKategoriler}

7-Day Weather Forecast:
$detayliHaftalikHava

CRITICAL RULES:
1. 'hafta' array MUST contain EXACTLY $aiPlanGunSayisi items, starting ${bugununKombiniKorunacak ? 'tomorrow' : 'today'}. Do not include any day before the requested start day.
2. 'gun' field must be the day name written in $hedefDil.
3. 'kombin_adi' and 'tuyo' must be in $hedefDil language.
4. Each outfit MUST order items: 'ust', 'alt', 'ayakkabi' (only the categories available in the clean inventory), and optional 'dis'.
5. Always use EXACT category names in item descriptions: 'ust', 'alt', 'ayakkabi', or 'dis'.
6. Shoes may be reused on different days. Do not reject a plan because the same shoe is used again.
7. Do not reuse upper, lower, or outerwear items on different days.
8. WEATHER MATCH (CRITICAL): Choose each day's items according to THAT day's forecast above. On a cold day (max 12°C or below) NEVER use summer pieces (shorts, linen, sleeveless tops, sandals, thin fabrics) and prefer warm layers. On a hot day (max 28°C or above) NEVER use winter pieces (wool, cashmere, coat, parka, down, thick knits, boots). If the inventory has nothing suitable for that day, pick the closest option and warn the user in the 'tuyo' field.
9. MISSING PIECE = STYLIST MODE (CRITICAL): Some categories may be missing from the clean inventory (not owned or in the laundry). NEVER leave a day empty or return 'parcalar': []. Still style the best possible outfit from the available items, simply OMIT the missing category from 'parcalar' and never invent item numbers. In 'tuyo', act as a personal stylist: name the missing piece and suggest concretely what would complete the look (type, color, fabric suitable for that day's weather).
10. Keep 'kombin_adi' short and inspiring even when a category is missing (e.g. 'Layered Cozy Look + missing shoes'), so the day never looks blank.
11. 'eksik_parca_onerisi' (TEXT SUGGESTION, written in $hedefDil): when any category listed in 'Missing Categories' is missing that day, write a short stylist text that recommends a COMPLETE outfit combination as plain text covering an upper piece (ust), a lower piece (alt) AND shoes (ayakkabi) that would finish that day's look, suited to that day's weather and the user's style profile (mention type, color and fabric). This is a recommendation, NOT inventory: never use 'Clean Item #' here and never claim these items are in the wardrobe. If no category is missing that day, use an empty string "".

Respond ONLY with this JSON structure:
{
  "hafta": [
    {
      "gun": "Monday",
      "gunluk_hava": "22°C / 31°C",
      "kombin_adi": "Outfit Title",
      "parcalar": ["Clean Item #1...", "Clean Item #2..."],
      "tuyo": "Style tip in $hedefDil...",
      "eksik_parca_onerisi": "Text recommendation (ust + alt + ayakkabi) that completes the missing pieces, or empty string",
      "renk_uyumu_puani": 90
    }
  ]
}
''';

  return {
    'sistemPromptu': sistemPromptu,
    'kullaniciMesaji': kullaniciMesaji.trim(),
  };
}

/// Prompt şablonlarını test etmek için basit yardımcı
