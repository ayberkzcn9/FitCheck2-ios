// "Kombin Düellosu"nun kalıcı durumu: en iyi skor, günlük seri, XP.
//
// Hepsi cihazda (SharedPreferences) tutuluyor; hesap ya da ağ gerekmiyor.
// Oyunun kendisi gibi bu dosya da saf Dart: widget yok, testte doğrudan
// SharedPreferences.setMockInitialValues ile çalıştırılabiliyor.

import 'package:shared_preferences/shared_preferences.dart';

/// Oyuncunun düello geçmişinin özeti.
class DuelloDurumu {
  const DuelloDurumu({
    this.enIyiSkor = 0,
    this.enIyiSeri = 0,
    this.gunlukSeri = 0,
    this.toplamXp = 0,
    this.toplamDogru = 0,
    this.toplamTur = 0,
    this.bugunOynandi = false,
  });

  /// Tek turda yapılan en yüksek doğru sayısı (10 üzerinden).
  final int enIyiSkor;

  /// Bir tur içinde üst üste en çok doğru.
  final int enIyiSeri;

  /// Kaç gün üst üste oynandı.
  final int gunlukSeri;

  final int toplamXp;
  final int toplamDogru;
  final int toplamTur;

  /// Bugün düello oynandı mı? (Lobide "bugün oynadın" notu için.)
  final bool bugunOynandi;

  /// Her 500 XP bir seviye.
  static const int seviyeEsigi = 500;

  int get seviye => 1 + toplamXp ~/ seviyeEsigi;

  /// Bir sonraki seviyeye kalan XP oranı (0.0 - 1.0).
  double get seviyeIlerlemesi => (toplamXp % seviyeEsigi) / seviyeEsigi;

  int get sonrakiSeviyeyeKalan => seviyeEsigi - (toplamXp % seviyeEsigi);

  DuelloDurumu kopyala({
    int? enIyiSkor,
    int? enIyiSeri,
    int? gunlukSeri,
    int? toplamXp,
    int? toplamDogru,
    int? toplamTur,
    bool? bugunOynandi,
  }) {
    return DuelloDurumu(
      enIyiSkor: enIyiSkor ?? this.enIyiSkor,
      enIyiSeri: enIyiSeri ?? this.enIyiSeri,
      gunlukSeri: gunlukSeri ?? this.gunlukSeri,
      toplamXp: toplamXp ?? this.toplamXp,
      toplamDogru: toplamDogru ?? this.toplamDogru,
      toplamTur: toplamTur ?? this.toplamTur,
      bugunOynandi: bugunOynandi ?? this.bugunOynandi,
    );
  }
}

class KombinDuellosuServisi {
  KombinDuellosuServisi({DateTime Function()? simdi})
      : _simdi = simdi ?? DateTime.now;

  /// Testlerde "bugün"ü sabitlemek için.
  final DateTime Function() _simdi;

  static const String _enIyiSkorAnahtari = 'duello_en_iyi_skor';
  static const String _enIyiSeriAnahtari = 'duello_en_iyi_seri';
  static const String _gunlukSeriAnahtari = 'duello_gunluk_seri';
  static const String _toplamXpAnahtari = 'duello_toplam_xp';
  static const String _toplamDogruAnahtari = 'duello_toplam_dogru';
  static const String _toplamTurAnahtari = 'duello_toplam_tur';
  static const String _sonGunAnahtari = 'duello_son_gun';

  Future<DuelloDurumu> yukle() async {
    final prefs = await SharedPreferences.getInstance();
    final sonGun = prefs.getString(_sonGunAnahtari);
    final bugun = gunAnahtari(_simdi());
    return DuelloDurumu(
      enIyiSkor: prefs.getInt(_enIyiSkorAnahtari) ?? 0,
      enIyiSeri: prefs.getInt(_enIyiSeriAnahtari) ?? 0,
      gunlukSeri: prefs.getInt(_gunlukSeriAnahtari) ?? 0,
      toplamXp: prefs.getInt(_toplamXpAnahtari) ?? 0,
      toplamDogru: prefs.getInt(_toplamDogruAnahtari) ?? 0,
      toplamTur: prefs.getInt(_toplamTurAnahtari) ?? 0,
      bugunOynandi: sonGun == bugun,
    );
  }

  /// Tur bitince çağrılır. Günlük seri burada güncellenir:
  /// dün oynandıysa +1, bugün oynandıysa sabit, daha eskiyse 1'den başlar.
  Future<DuelloDurumu> turuKaydet({
    required int dogru,
    required int toplam,
    required int xp,
    required int enIyiSeri,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final simdi = _simdi();
    final bugun = gunAnahtari(simdi);
    final dun = gunAnahtari(simdi.subtract(const Duration(days: 1)));
    final sonGun = prefs.getString(_sonGunAnahtari);

    var gunlukSeri = prefs.getInt(_gunlukSeriAnahtari) ?? 0;
    if (sonGun == bugun) {
      gunlukSeri = gunlukSeri < 1 ? 1 : gunlukSeri;
    } else if (sonGun == dun) {
      gunlukSeri += 1;
    } else {
      gunlukSeri = 1;
    }

    final enIyiSkor = prefs.getInt(_enIyiSkorAnahtari) ?? 0;
    final yeniEnIyiSkor = dogru > enIyiSkor ? dogru : enIyiSkor;
    final yeniEnIyiSeri =
        enIyiSeri > (prefs.getInt(_enIyiSeriAnahtari) ?? 0)
            ? enIyiSeri
            : (prefs.getInt(_enIyiSeriAnahtari) ?? 0);

    final yeniXp = (prefs.getInt(_toplamXpAnahtari) ?? 0) + xp;
    final yeniDogru = (prefs.getInt(_toplamDogruAnahtari) ?? 0) + dogru;
    final yeniTur = (prefs.getInt(_toplamTurAnahtari) ?? 0) + toplam;

    await prefs.setInt(_enIyiSkorAnahtari, yeniEnIyiSkor);
    await prefs.setInt(_enIyiSeriAnahtari, yeniEnIyiSeri);
    await prefs.setInt(_gunlukSeriAnahtari, gunlukSeri);
    await prefs.setInt(_toplamXpAnahtari, yeniXp);
    await prefs.setInt(_toplamDogruAnahtari, yeniDogru);
    await prefs.setInt(_toplamTurAnahtari, yeniTur);
    await prefs.setString(_sonGunAnahtari, bugun);

    return DuelloDurumu(
      enIyiSkor: yeniEnIyiSkor,
      enIyiSeri: yeniEnIyiSeri,
      gunlukSeri: gunlukSeri,
      toplamXp: yeniXp,
      toplamDogru: yeniDogru,
      toplamTur: yeniTur,
      bugunOynandi: true,
    );
  }
}

/// Yerel tarihi `2026-10-20` biçiminde döndürür.
String gunAnahtari(DateTime tarih) {
  final ay = tarih.month.toString().padLeft(2, '0');
  final gun = tarih.day.toString().padLeft(2, '0');
  return '${tarih.year}-$ay-$gun';
}
