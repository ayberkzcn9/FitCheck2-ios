import 'package:shared_preferences/shared_preferences.dart';

/// AI özelliklerinde kişisel verilerin üçüncü taraf AI servislerine
/// gönderilmesi için açık kullanıcı onayını saklar.
class AiOnayServisi {
  AiOnayServisi._();

  /// Onay metni veya kapsamı değişirse sürümü artırın; kullanıcı yeniden
  /// bilgilendirilip onay istenir.
  static const String anahtar = 'ai_veri_paylasim_onayi_v1';

  static Future<bool> onayVarMi() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(anahtar) ?? false;
    } catch (_) {
      return false;
    }
  }

  static Future<void> onayVer() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(anahtar, true);
    } catch (_) {
      // Onay yazılamazsa AI çağrısı yine de devam etmez; çağıran taraf
      // onay yokmuş gibi davranır.
    }
  }

  static Future<void> onayiKaldir() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(anahtar);
    } catch (_) {}
  }
}
