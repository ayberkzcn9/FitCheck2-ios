// Bildirim metinlerini üreten saf yardımcı.
//
// Neden ayrı dosya: bildirimlerin içeriği "hangi gün hangi kombin" sorusuna
// bağlı; bu mantığı servisin içine gömmek yerine burada tutuyoruz ki
// testlerde cihaz/eklenti olmadan doğrulanabilsin.
//
// Plan (`haftalik_program_json`) gün adlarıyla saklanıyor (Monday, Tuesday...).
// Bu yüzden eşleme takvim gününe göre değil GÜN ADINA göre yapılıyor: plan kaç
// gün önce kaydedilmiş olursa olsun "pazartesi kombini" doğru güne düşer.
// Kullanıcı uygulamayı hiç açmazsa dahi eski plan yanlış güne kaymaz.

import '../l10n/app_localizations.dart';

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

  static const List<String> _ingilizceGunler = <String>[
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  /// Planlayıcının kullandığı İngilizce gün adı.
  static String gunAdi(DateTime tarih) => _ingilizceGunler[tarih.weekday - 1];

  /// Bugünden başlayarak [gunSayisi] günü, planlanan kombin adlarıyla döndürür.
  static List<BildirimGunu> gunler({
    required Map<String, dynamic>? program,
    required DateTime simdi,
    int gunSayisi = 7,
  }) {
    final bugun = DateTime(simdi.year, simdi.month, simdi.day);
    final planaGore = <String, String>{};

    final hafta = program?['hafta'];
    if (hafta is List) {
      for (final gun in hafta) {
        if (gun is! Map) continue;
        final ad = _kanonikGun(gun['gun']);
        if (ad == null) continue;
        final kombin = gun['kombin_adi']?.toString().trim() ?? '';
        if (kombin.isNotEmpty) planaGore[ad] = kombin;
      }
    }

    return List<BildirimGunu>.generate(gunSayisi, (index) {
      final tarih = bugun.add(Duration(days: index));
      return BildirimGunu(
        tarih: tarih,
        kombinAdi: planaGore[gunAdi(tarih)],
      );
    }, growable: false);
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

  /// "pazartesi", "Monday", "Mon", "mon", "Pazartesi" → "Monday".
  ///
  /// Eski kayıtlarda gün adı yerelleştirilmiş olabilir; ikisi de desteklenir.
  static String? _kanonikGun(Object? ham) {
    final metin = ham?.toString().toLowerCase().trim() ?? '';
    if (metin.isEmpty) return null;

    const esler = <String, List<String>>{
      'Monday': ['monday', 'mon', 'pazartesi', 'pzt', 'montag', 'mo', 'lundi', 'lunedi', 'lunes'],
      'Tuesday': ['tuesday', 'tue', 'salı', 'sali', 'sal', 'dienstag', 'di', 'mardi', 'martedi', 'martes'],
      'Wednesday': ['wednesday', 'wed', 'çarşamba', 'carsamba', 'çar', 'car', 'mittwoch', 'mi', 'mercredi', 'mercoledi', 'miercoles'],
      'Thursday': ['thursday', 'thu', 'perşembe', 'persembe', 'per', 'donnerstag', 'do', 'jeudi', 'giovedi', 'jueves'],
      'Friday': ['friday', 'fri', 'cuma', 'cum', 'freitag', 'fr', 'vendredi', 'venerdi', 'viernes'],
      'Saturday': ['saturday', 'sat', 'cumartesi', 'cmt', 'samstag', 'sa', 'samedi', 'sabato', 'sabado'],
      'Sunday': ['sunday', 'sun', 'pazar', 'paz', 'sonntag', 'so', 'dimanche', 'domenica', 'domingo'],
    };

    for (final giris in esler.entries) {
      if (giris.value.contains(metin)) return giris.key;
    }
    // "Pazartesi 12 Ekim" gibi ek metin varsa baştan eşle.
    for (final giris in esler.entries) {
      for (final ad in giris.value) {
        if (metin.startsWith(ad)) return giris.key;
      }
    }
    return null;
  }
}
