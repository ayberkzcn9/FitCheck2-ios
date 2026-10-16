import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../l10n/app_localizations.dart';

/// Uygulamada kayıtlı dil kodunu döndürür (kullanıcı "Otomatik" seçtiyse null).
Future<String?> kayitliDilKodu() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('secilen_dil_kodu');
  } catch (_) {
    return null;
  }
}

/// Desteklenen dil kodları (l10n delegesi ve `main.dart` ile aynı).
const Set<String> desteklenenDilKodlari = {
  'tr', 'en', 'de', 'fr', 'es', 'it', 'pt', 'ru', 'ar', 'ja', 'ko', 'zh',
};

/// `BuildContext` olmadan (ör. servis/bildirim katmanı) yerelleştirme üretir.
/// Kayıtlı dil yoksa veya desteklenmiyorsa Türkçe'ye düşer.
Future<AppLocalizations> cevrimdisiL10n() async {
  final kod = await kayitliDilKodu();
  final secilen =
      (kod != null && desteklenenDilKodlari.contains(kod)) ? kod : 'tr';
  return lookupAppLocalizations(Locale(secilen));
}

/// Context varsa ondan, yoksa kayıtlı dilden yerelleştirme döndürür.
Future<AppLocalizations> l10nAl(BuildContext? context) async {
  if (context != null) {
    final l = AppLocalizations.of(context);
    if (l != null) return l;
  }
  return cevrimdisiL10n();
}
