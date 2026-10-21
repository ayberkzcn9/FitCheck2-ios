// Tarihe özel kombin planlarının yerel deposu.
//
// `SharedPreferences` altında tek bir JSON listesi tutulur:
//   [{"tarih": "2026-10-25", "baslik": "Klasik Kombin", "parcalar": [...]}, ...]
//
// Liste yerine tarih→plan haritası döndürülür; takvim günü ararken tek adımda
// bulur. Bozuk kayıt okunamazsa plan yok sayılır, uygulama açılmaya devam eder.

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/planli_kombin.dart';
import '../utils/helpers.dart';

class PlanliKombinDeposu {
  static const String anahtar = 'planli_kombinler';

  /// Ham JSON metnini tarih→plan haritasına çevirir.
  ///
  /// Saf fonksiyon: testte doğrudan çağrılabilir. Bozuk/eksik kayıtlar atlanır.
  static Map<String, PlanliKombin> coz(String? ham) {
    if (ham == null || ham.trim().isEmpty) return <String, PlanliKombin>{};

    final sonuc = <String, PlanliKombin>{};
    final liste = safeJsonDecodeList(ham, tag: 'planli_kombinler');
    for (final kayit in liste) {
      final plan = PlanliKombin.fromJson(kayit);
      if (plan.tarih.isEmpty || plan.baslik.isEmpty) continue;
      sonuc[plan.tarih] = plan;
    }
    return sonuc;
  }

  Future<Map<String, PlanliKombin>> yukle() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return coz(prefs.getString(anahtar));
    } catch (_) {
      return <String, PlanliKombin>{};
    }
  }

  /// Tek bir güne plan yazar (varsa üzerine yazar).
  Future<Map<String, PlanliKombin>> ata(PlanliKombin plan) async {
    final planlar = await yukle();
    planlar[plan.tarih] = plan;
    await _yaz(planlar);
    return planlar;
  }

  Future<Map<String, PlanliKombin>> kaldir(String tarih) async {
    final planlar = await yukle();
    planlar.remove(tarih);
    await _yaz(planlar);
    return planlar;
  }

  Future<void> _yaz(Map<String, PlanliKombin> planlar) async {
    final prefs = await SharedPreferences.getInstance();
    final liste = planlar.values.map((p) => p.toJson()).toList();
    await prefs.setString(anahtar, jsonEncode(liste));
  }
}
