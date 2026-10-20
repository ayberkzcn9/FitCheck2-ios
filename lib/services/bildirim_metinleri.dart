// Bildirim metinlerini üreten saf yardımcı.
//
// Neden ayrı dosya: bildirimlerin içeriği "hangi gün hangi kombin" sorusuna
// bağlı; bu mantığı servisin içine gömmek yerine burada tutuyoruz ki
// testlerde cihaz/eklenti olmadan doğrulanabilsin.
//
// Plan (`haftalik_program_json`) gün adlarıyla saklanıyor (Monday, Tuesday...).
// Bu yüzden eşleme takvim gününe göre değil GÜN ADINA göre yapılıyor: plan kaç
// gün önce kaydedilmiş olursa olsun "pazartesi kombini" doğru güne düşer.

import '../l10n/app_localizations.dart';
import '../utils/takvim_gunleri.dart';

/// Bildirimde kullanılacak tek bir gün.
class BildirimGunu {
  const BildirimGunu({required this.tarih, this.kombinAdi});

  final DateTime tarih;

  /// O gün için planlanan kombin adı; plan yoksa null.
  final String? kombinAdi;

  bool get kombinVarMi {
    final ad = kombinAdi?.trim() ?? '';
    return ad.isNotEmpty;
  }
}

/// Bildirim metinleri ve plan eşlemesi.
class BildirimMetinleri {
  BildirimMetinleri._();

  /// Planlayıcının kullandığı İngilizce gün adı.
  static String gunAdi(DateTime tarih) => ingilizceGunAdi(tarih);

  /// Bugünden başlayarak [gunSayisi] günü, planlanan kombin adlarıyla döndürür.
  static List<BildirimGunu> gunler({
    required Map<String, dynamic>? program,
    required DateTime simdi,
    int gunSayisi = 7,
  }) {
    final planaGore = planKombinAdlari(program);

    final bugun = DateTime(simdi.year, simdi.month, simdi.day);
    return List<BildirimGunu>.generate(gunSayisi, (index) {
      final tarih = bugun.add(Duration(days: index));
      return BildirimGunu(
        tarih: tarih,
        kombinAdi: planaGore[gunAdi(tarih)],
      );
    }, growable: false);
  }

  /// Plan → gün adı → kombin adı (boş kombinler atlanır).
  static Map<String, String> planKombinAdlari(Map<String, dynamic>? program) {
    final sonuc = <String, String>{};
    final hafta = program?['hafta'];
    if (hafta is! List) return sonuc;

    for (final gun in hafta) {
      if (gun is! Map) continue;
      final ad = kanonikGunAdi(gun['gun']);
      if (ad == null) continue;
      final kombin = gun['kombin_adi']?.toString().trim() ?? '';
      if (kombin.isNotEmpty) sonuc[ad] = kombin;
    }
    return sonuc;
  }

  /// Sabah bildirimi: kombini olan gün için kişisel, olmayan gün için genel.
  static String sabahMetni(AppLocalizations l10n, BildirimGunu gun) {
    if (!gun.kombinVarMi) return l10n.bildirimGunaydinIcerik;
    return l10n.bildirimSabahKombin(gun.kombinAdi!.trim());
  }

  /// Akşam hatırlatıcısı: yarının kombini varsa onu söyler.
  static String aksamMetni(AppLocalizations l10n, BildirimGunu yarin) {
    if (!yarin.kombinVarMi) return l10n.bildirimPlanBos;
    return l10n.bildirimPlanKombin(yarin.kombinAdi!.trim());
  }

  /// Plan en az bir gün için dolu mu? Boş planda akşam hatırlatıcısı kurulmaz.
  static bool planDolu(List<BildirimGunu> gunler) =>
      gunler.any((gun) => gun.kombinVarMi);
}
