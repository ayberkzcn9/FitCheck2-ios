import 'package:shared_preferences/shared_preferences.dart';

/// Mağaza puanlama isteğinin NE ZAMAN gösterileceğine karar verir.
///
/// Eskiden uygulama 2. açılışta soruyordu; kullanıcı henüz uygulamanın
/// değerini görmeden sorulduğu için düşük puan riski yüksekti. Artık istek,
/// kullanıcı olumlu bir şey yaptıktan sonra gösterilir: bir kombini
/// "giydim" olarak işaretlemek veya favorilere kaydetmek.
///
/// Kurallar:
/// * En az bir olumlu an yaşanmış olmalı.
/// * Kullanıcı "evet" dediyse bir daha sorulmaz.
/// * Reddettiyse en az [tekrarAcilisAraligi] açılış sonra tekrar sorulur
///   (aynı oturumda ikinci kez sorulmaz).
class YorumIstegiServisi {
  const YorumIstegiServisi._();

  static const String acilisSayisiAnahtari = 'acilis_sayisi';
  static const String yapildiAnahtari = 'degerlendirme_yapildi';
  static const String sonIstemeAnahtari = 'degerlendirme_son_isteme';
  static const String olumluAnAnahtari = 'degerlendirme_olumlu_an';

  /// Reddedilen isteğin ardından kaç açılış beklenecek.
  static const int tekrarAcilisAraligi = 3;

  /// Uygulama her açıldığında çağrılır; açılış sayacını artırır.
  static Future<int> acilisiSay() async {
    final prefs = await SharedPreferences.getInstance();
    final sayi = (prefs.getInt(acilisSayisiAnahtari) ?? 0) + 1;
    await prefs.setInt(acilisSayisiAnahtari, sayi);
    return sayi;
  }

  /// Saf karar fonksiyonu (kolay test edilsin diye ayrı).
  static bool gosterilmeliMi({
    required int olumluAnSayisi,
    required bool yapildi,
    required int acilisSayisi,
    required int sonIsteme,
  }) {
    if (yapildi) return false;
    if (olumluAnSayisi < 1) return false;
    // Hiç sorulmadıysa hemen sorulabilir.
    if (sonIsteme <= 0) return true;
    return acilisSayisi - sonIsteme >= tekrarAcilisAraligi;
  }

  /// Kullanıcı olumlu bir şey yaptığında çağrılır. İstek gösterilmeliyse
  /// `true` döner. Soru gerçekten gösterildiğinde [soruldu] çağrılmalıdır.
  static Future<bool> olumluAnKaydet() async {
    final prefs = await SharedPreferences.getInstance();
    final olumlu = (prefs.getInt(olumluAnAnahtari) ?? 0) + 1;
    await prefs.setInt(olumluAnAnahtari, olumlu);

    return gosterilmeliMi(
      olumluAnSayisi: olumlu,
      yapildi: prefs.getBool(yapildiAnahtari) ?? false,
      acilisSayisi: prefs.getInt(acilisSayisiAnahtari) ?? 0,
      sonIsteme: prefs.getInt(sonIstemeAnahtari) ?? 0,
    );
  }

  /// Soru kullanıcıya gösterildi: tekrar sorma aralığı buradan başlar.
  static Future<void> soruldu() async {
    final prefs = await SharedPreferences.getInstance();
    final acilis = prefs.getInt(acilisSayisiAnahtari) ?? 0;
    // 0 "hiç sorulmadı" demek; açılış sayacı 0 ise 1 yaz.
    await prefs.setInt(sonIstemeAnahtari, acilis < 1 ? 1 : acilis);
  }

  /// Kullanıcı "evet, değerlendireyim" dedi: bir daha sorma.
  static Future<void> yapildiIsaretle() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(yapildiAnahtari, true);
  }
}
