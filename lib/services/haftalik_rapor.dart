// Haftalık stil raporu: paylaşılabilir özet için saf hesaplama.
//
// Kaynaklar:
//  - `gecmis_data`: [{tarih: 'YYYY-MM-DD', baslik, detay}] (detay = "A, B, C")
//  - dolap: [Kiyafet] (toplam parça, hiç giyilmeyenler)

import '../models/kiyafet.dart';
import '../utils/takvim_gunleri.dart';

/// Son 7 günün özeti.
class HaftalikRaporVerisi {
  const HaftalikRaporVerisi({
    required this.baslangic,
    required this.bitis,
    required this.kombinSayisi,
    required this.oncekiHaftaKombinSayisi,
    required this.farkliParcaSayisi,
    required this.toplamParcaSayisi,
    required this.enCokParca,
    required this.enCokParcaAdet,
    required this.seriGun,
    required this.gunler,
    required this.hicGiyilmemis,
  });

  /// Pencerenin ilk günü (bugün - 6).
  final DateTime baslangic;

  /// Bugün.
  final DateTime bitis;

  /// Pencerede kaydedilen kombin sayısı.
  final int kombinSayisi;

  /// Bir önceki 7 günde kaydedilen kombin sayısı.
  final int oncekiHaftaKombinSayisi;

  /// Pencerede giyilen farklı parça sayısı.
  final int farkliParcaSayisi;

  /// Dolaptaki toplam parça sayısı.
  final int toplamParcaSayisi;

  /// En sık giyilen parça adı (yoksa null).
  final String? enCokParca;
  final int enCokParcaAdet;

  /// Bugünden geriye doğru kesintisiz kombin kaydı olan gün sayısı.
  final int seriGun;

  /// 7 eleman: en eskiden bugüne, o gün kombin giyildi mi?
  final List<bool> gunler;

  /// Dolapta hiç giyilmemiş parça sayısı.
  final int hicGiyilmemis;

  /// Bu hafta dolabın yüzde kaçı kullanıldı (0-100).
  int get kullanimYuzdesi {
    if (toplamParcaSayisi <= 0) return 0;
    final yuzde = (farkliParcaSayisi / toplamParcaSayisi) * 100;
    return yuzde.clamp(0, 100).round();
  }

  /// Önceki haftaya göre kombin sayısı farkı.
  int get degisim => kombinSayisi - oncekiHaftaKombinSayisi;

  bool get bos => kombinSayisi == 0;

  static HaftalikRaporVerisi hesapla({
    required List<Map<String, String>> gecmis,
    required List<Kiyafet> gardirobum,
    required DateTime simdi,
  }) {
    final bugun = DateTime(simdi.year, simdi.month, simdi.day);
    final baslangic = bugun.subtract(const Duration(days: 6));
    final oncekiBaslangic = baslangic.subtract(const Duration(days: 7));
    final oncekiBitis = baslangic.subtract(const Duration(days: 1));

    final parcaSayaci = <String, int>{};
    final giyilenGunler = <String>{};
    var kombinSayisi = 0;
    var oncekiHafta = 0;

    for (final kayit in gecmis) {
      final tarih = _tarihCoz(kayit['tarih']?.trim() ?? '');
      if (tarih == null) continue;

      final pencerede = !tarih.isBefore(baslangic) && !tarih.isAfter(bugun);
      final oncekiPencerede =
          !tarih.isBefore(oncekiBaslangic) && !tarih.isAfter(oncekiBitis);
      if (!pencerede && !oncekiPencerede) continue;

      if (pencerede) {
        kombinSayisi++;
        giyilenGunler.add(gunAnahtari(tarih));
        for (final parca in _parcalar(kayit['detay'])) {
          parcaSayaci[parca] = (parcaSayaci[parca] ?? 0) + 1;
        }
      }
      if (oncekiPencerede) oncekiHafta++;
    }

    String? enCokParca;
    var enCokAdet = 0;
    for (final giris in parcaSayaci.entries) {
      if (giris.value > enCokAdet) {
        enCokAdet = giris.value;
        enCokParca = giris.key;
      }
    }

    final gunler = List<bool>.generate(
      7,
      (index) => giyilenGunler.contains(
        gunAnahtari(baslangic.add(Duration(days: index))),
      ),
    );

    var seri = 0;
    for (var i = 0; i < 60; i++) {
      final tarih = bugun.subtract(Duration(days: i));
      if (!giyilenGunler.contains(gunAnahtari(tarih))) break;
      seri++;
    }

    return HaftalikRaporVerisi(
      baslangic: baslangic,
      bitis: bugun,
      kombinSayisi: kombinSayisi,
      oncekiHaftaKombinSayisi: oncekiHafta,
      farkliParcaSayisi: parcaSayaci.length,
      toplamParcaSayisi: gardirobum.length,
      enCokParca: enCokParca,
      enCokParcaAdet: enCokAdet,
      seriGun: seri,
      gunler: gunler,
      hicGiyilmemis: gardirobum.where((k) => k.giyilmeSayisi == 0).length,
    );
  }

  /// "A, B, C" → [A, B, C]
  static List<String> _parcalar(String? detay) {
    return (detay ?? '')
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  static DateTime? _tarihCoz(String metin) {
    final parcalar = metin.split('-');
    if (parcalar.length != 3) return null;
    final yil = int.tryParse(parcalar[0]);
    final ay = int.tryParse(parcalar[1]);
    final gun = int.tryParse(parcalar[2]);
    if (yil == null || ay == null || gun == null) return null;
    return DateTime(yil, ay, gun);
  }
}
