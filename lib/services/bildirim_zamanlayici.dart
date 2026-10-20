// Bildirimlerin ne zaman ve hangi metinle kurulacağını yönetir.
//
// Tek giriş noktası: uygulama açıldığında, ayar değiştiğinde ve haftalık plan
// kaydedildiğinde çağrılır. Böylece bildirim metni her zaman son planı yansıtır
// (ör. "Yarın için: bej trençkot + siyah pantolon").

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/helpers.dart';
import '../utils/l10n_yardimcilari.dart';
import 'bildirim_metinleri.dart';
import 'bildirim_servisi.dart';

class BildirimZamanlayici {
  BildirimZamanlayici._();

  /// Ayarlardaki "sabah bildirimi" varsayılanı (Ayarlar ekranıyla aynı).
  static const int varsayilanSabahSaat = 8;
  static const int varsayilanSabahDakika = 30;

  /// Akşam plan hatırlatıcısı: yarının kombini için sabah telaşı olmasın.
  static const int aksamSaat = 21;
  static const int aksamDakika = 0;

  /// Tüm bildirim serilerini yeniden kurar.
  ///
  /// [program] verilmezse kayıtlı haftalık plan okunur.
  static Future<void> yenidenKur({
    BuildContext? context,
    Map<String, dynamic>? program,
    DateTime? simdi,
  }) async {
    final l10n = await l10nAl(context);
    final prefs = await SharedPreferences.getInstance();
    final an = simdi ?? DateTime.now();

    final sabahAcik = prefs.getBool('sabah_bildirimi') ?? true;
    final aksamAcik = prefs.getBool('plan_hatirlatimi') ?? true;
    final saat = (prefs.getInt('sabah_bildirim_saat') ?? varsayilanSabahSaat)
        .clamp(0, 23);
    final dakika =
        (prefs.getInt('sabah_bildirim_dakika') ?? varsayilanSabahDakika)
            .clamp(0, 59);

    final plan = program ?? _programiOku(prefs);
    final gunler = BildirimMetinleri.gunler(program: plan, simdi: an);

    if (sabahAcik) {
      final bildirimler = <BildirimIcerigi>[
        for (final gun in gunler)
          BildirimIcerigi(
            zaman: DateTime(
              gun.tarih.year,
              gun.tarih.month,
              gun.tarih.day,
              saat,
              dakika,
            ),
            baslik: l10n.bildirimGunaydinBaslik,
            icerik: BildirimMetinleri.sabahMetni(l10n, gun),
            hedef: 'bugun',
          ),
      ];
      await BildirimServisi().sabahBildirimleriKur(
        bildirimler: bildirimler,
      );
    } else {
      await BildirimServisi().gunlukSabahBildiriminiIptalEt();
    }

    // Akşam hatırlatıcısı yalnızca gerçekten plan yapan kullanıcıya gider;
    // planı hiç olmayan birine her akşam "planla" demek spam olur.
    if (aksamAcik && BildirimMetinleri.planDolu(gunler)) {
      final bildirimler = <BildirimIcerigi>[];
      for (var i = 0; i < gunler.length - 1; i++) {
        final yarin = gunler[i + 1];
        bildirimler.add(
          BildirimIcerigi(
            zaman: DateTime(
              gunler[i].tarih.year,
              gunler[i].tarih.month,
              gunler[i].tarih.day,
              aksamSaat,
              aksamDakika,
            ),
            baslik: l10n.bildirimPlanBaslik,
            icerik: BildirimMetinleri.aksamMetni(l10n, yarin),
            hedef: 'plan',
          ),
        );
      }
      await BildirimServisi().planHatirlatmalariniKur(
        bildirimler: bildirimler,
      );
    } else {
      await BildirimServisi().planHatirlatmalariniIptalEt();
    }
  }

  static Map<String, dynamic>? _programiOku(SharedPreferences prefs) {
    final ham = prefs.getString('haftalik_program_json');
    if (ham == null || ham.isEmpty) return null;
    final cozulen = safeJsonDecodeMap(ham, tag: 'bildirim_plani');
    return cozulen.isEmpty ? null : cozulen;
  }
}
