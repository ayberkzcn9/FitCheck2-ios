// Kombin takvimi: geçmişte ne giydim, önümüzdeki günlerde ne planladım?
//
// İki kaynak birleştirilir:
//  - `gecmis_data` (AnaEkran): [{tarih: 'YYYY-MM-DD', baslik, detay}] — giyilenler
//  - `haftalik_program_json`: 7 günlük plan (gün adı + kombin_adi) — planlananlar
//
// Plan gün adıyla tutulduğu için yalnızca bugünden itibaren 7 güne yansıtılır;
// geçmiş günlere "plan" yazmak yanıltıcı olurdu.

import '../models/planli_kombin.dart';
import '../utils/takvim_gunleri.dart';

/// Takvimdeki tek bir gün.
class TakvimGunu {
  const TakvimGunu({
    required this.tarih,
    this.planlanan = const <String>[],
    this.giyilen = const <String>[],
    this.planliKombin,
  });

  final DateTime tarih;

  /// Haftalık programdan gelen plan (bugünden itibaren en fazla 7 gün).
  final List<String> planlanan;

  /// O gün giyildi olarak kaydedilen kombin adları.
  final List<String> giyilen;

  /// Tarihe özel plan (takvimde güne elle atanmış kombin). Varsa haftalık
  /// programın önüne geçer.
  final PlanliKombin? planliKombin;

  bool get planVar => planliKombin != null || planlanan.isNotEmpty;
  bool get giyildi => giyilen.isNotEmpty;
  bool get bos => !planVar && !giyildi;
}

/// Bir ayın günlerini plan + geçmişle birleştirir.
class KombinTakvimi {
  KombinTakvimi._();

  /// Ayın 1'inden son gününe kadar; ilk günden önceki boşluklar null.
  ///
  /// [ay] yıl+ay yeterli (gün yok sayılır).
  static List<TakvimGunu?> ay({
    required DateTime ay,
    required List<Map<String, String>> gecmis,
    required Map<String, dynamic>? program,
    required DateTime simdi,
    Map<String, PlanliKombin> planliKombinler = const <String, PlanliKombin>{},
  }) {
    final ilk = DateTime(ay.year, ay.month, 1);
    final gunSayisi = DateTime(ay.year, ay.month + 1, 0).day;
    final bugun = DateTime(simdi.year, simdi.month, simdi.day);

    final giyilenler = _giyilenlerHaritasi(gecmis);
    final plan = _planHaritasi(program, bugun);

    // Pazartesi = 1; takvim pazartesi ile başlıyor.
    final bosluk = ilk.weekday - 1;
    final gunler = <TakvimGunu?>[
      ...List<TakvimGunu?>.filled(bosluk, null),
    ];

    for (var gun = 1; gun <= gunSayisi; gun++) {
      final tarih = DateTime(ay.year, ay.month, gun);
      final anahtar = gunAnahtari(tarih);
      gunler.add(
        TakvimGunu(
          tarih: tarih,
          giyilen: giyilenler[anahtar] ?? const <String>[],
          planlanan: plan[anahtar] ?? const <String>[],
          planliKombin: planliKombinler[anahtar],
        ),
      );
    }

    return gunler;
  }

  /// Geçmiş kayıtlarını güne göre toplar.
  static Map<String, List<String>> _giyilenlerHaritasi(
    List<Map<String, String>> gecmis,
  ) {
    final sonuc = <String, List<String>>{};
    for (final kayit in gecmis) {
      final tarih = kayit['tarih']?.trim() ?? '';
      final baslik = kayit['baslik']?.trim() ?? '';
      if (tarih.isEmpty || baslik.isEmpty) continue;
      sonuc.putIfAbsent(tarih, () => <String>[]);
      if (!sonuc[tarih]!.contains(baslik)) sonuc[tarih]!.add(baslik);
    }
    return sonuc;
  }

  /// Planı, bugünden itibaren 7 günün tarihine yansıtır.
  static Map<String, List<String>> _planHaritasi(
    Map<String, dynamic>? program,
    DateTime bugun,
  ) {
    final kombinler = <String, String>{};
    final hafta = program?['hafta'];
    if (hafta is! List) return const <String, List<String>>{};

    for (final gun in hafta) {
      if (gun is! Map) continue;
      final ad = kanonikGunAdi(gun['gun']);
      final kombin = gun['kombin_adi']?.toString().trim() ?? '';
      if (ad == null || kombin.isEmpty) continue;
      kombinler[ad] = kombin;
    }

    final sonuc = <String, List<String>>{};
    for (var i = 0; i < 7; i++) {
      final tarih = bugun.add(Duration(days: i));
      final kombin = kombinler[ingilizceGunAdi(tarih)];
      if (kombin != null) {
        sonuc[gunAnahtari(tarih)] = <String>[kombin];
      }
    }
    return sonuc;
  }
}
