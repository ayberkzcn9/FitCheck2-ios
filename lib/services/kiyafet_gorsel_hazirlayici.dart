// Vision (görme) için kıyafet görsellerini hazırlar.
//
// Neden gerekli: gardıroptaki görseller arka planı silinmiş, yüksek çözünürlüklü
// PNG'lerdir. Bunları olduğu gibi AI'ya göndermek hem yavaş hem pahalıdır
// (bir görsel 200 KB+ ve binlerce token). Burada görseller:
//   • en uzun kenarı [enBuyukKenar] piksele indirilir,
//   • şeffaf arka plan beyaza boyanır (JPEG alfa kanalı taşımaz; boyanmazsa
//     arka plan siyah çıkar ve model kıyafeti yanlış yorumlar),
//   • JPEG (kalite [jpegKalitesi]) olarak kodlanır,
//   • parça kimliğine göre bellekte önbelleğe alınır (aynı sohbette tekrar
//     kodlama yapılmaz).
//
// Hata durumunda `null` döner; çağıran taraf o parçayı sessizce atlar, yani
// görsel hazırlanamasa bile sohbet metinle çalışmaya devam eder.

import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

import '../models/kiyafet.dart';

/// Görsellerle birlikte, görsellerin hangi parçalara ait olduğunu taşır.
///
/// [parcalar] ile [gorseller] aynı sıradadır ve aynı uzunluktadır; hazırlanamayan
/// parça iki listeden de düşer. Böylece promptta "1. görsel = ID x" eşlemesi
/// güvenle yazılabilir.
class HazirGorseller {
  final List<Kiyafet> parcalar;
  final List<Uint8List> gorseller;

  const HazirGorseller(this.parcalar, this.gorseller);

  static const HazirGorseller bos = HazirGorseller(<Kiyafet>[], <Uint8List>[]);

  bool get bosMu => gorseller.isEmpty;

  int get uzunluk => gorseller.length;
}

class KiyafetGorselHazirlayici {
  KiyafetGorselHazirlayici._();

  /// Gönderilen görselin en uzun kenarı (piksel). 384 px, desen/kumaş/kesim
  /// ayrımı için yeterli; token maliyeti görsel başına ~200 token.
  static const int enBuyukKenar = 384;

  /// JPEG kalitesi. 72, 30 KB civarı dosya üretir; kalite kaybı gözle görülmez.
  static const int jpegKalitesi = 72;

  /// Tek istekte gönderilebilecek en fazla görsel sayısı.
  static const int enFazlaGorsel = 4;

  /// İsteğin şişmemesi için toplam görsel boyutu üst sınırı (bayt).
  static const int enFazlaToplamBayt = 3 * 1024 * 1024;

  /// Kodlanmış görsellerin önbelleği: "id:hamBaytUzunluğu" -> JPEG.
  static final Map<String, Uint8List> _onbellek = <String, Uint8List>{};

  /// Önbelleği boşaltır (test ve bellek temizliği için).
  static void onbellegiTemizle() => _onbellek.clear();

  static String _anahtar(Kiyafet kiyafet) =>
      '${kiyafet.id}:${kiyafet.resimBytes.length}';

  /// Verilen parçaların ilk [enFazla] tanesini hazırlar.
  static Future<HazirGorseller> hazirla(
    List<Kiyafet> parcalar, {
    int enFazla = enFazlaGorsel,
  }) async {
    if (parcalar.isEmpty || enFazla <= 0) return HazirGorseller.bos;

    final secilenParcalar = <Kiyafet>[];
    final secilenGorseller = <Uint8List>[];
    var toplamBayt = 0;

    for (final parca in parcalar.take(enFazla)) {
      final gorsel = await hazirlaTek(parca);
      if (gorsel == null || gorsel.isEmpty) continue;
      if (toplamBayt + gorsel.length > enFazlaToplamBayt) break;
      toplamBayt += gorsel.length;
      secilenParcalar.add(parca);
      secilenGorseller.add(gorsel);
    }

    if (secilenGorseller.isEmpty) return HazirGorseller.bos;
    return HazirGorseller(secilenParcalar, secilenGorseller);
  }

  /// Tek bir parçanın görselini hazırlar (önbellek destekli).
  static Future<Uint8List?> hazirlaTek(Kiyafet kiyafet) async {
    final anahtar = _anahtar(kiyafet);
    final hazir = _onbellek[anahtar];
    if (hazir != null) return hazir;

    try {
      final jpeg = await compute(kucultVeJpegYap, kiyafet.resimBytes);
      if (jpeg == null || jpeg.isEmpty) return null;
      _onbellek[anahtar] = jpeg;
      return jpeg;
    } catch (e) {
      debugPrint('Kıyafet görseli hazırlanamadı: $e');
      return null;
    }
  }
}

/// Görseli küçültür, beyaz zemine oturtur ve JPEG'e çevirir.
///
/// İzolasyonda (compute) çalıştığı için top-level fonksiyon; ayrıca test
/// edilebilir. Çözülemeyen veri için `null` döner.
@visibleForTesting
Uint8List? kucultVeJpegYap(Uint8List ham) {
  final img.Image? cozulen;
  try {
    // Bozuk/eksik görsel verisinde kod çözücü istisna atabiliyor (ör. PSD
    // sezgiseli); uygulama çökmesin diye burada yakalanır.
    cozulen = img.decodeImage(ham);
  } catch (e) {
    debugPrint('Görsel çözülemedi: $e');
    return null;
  }
  if (cozulen == null || cozulen.width <= 0 || cozulen.height <= 0) return null;

  final enUzunKenar =
      cozulen.width > cozulen.height ? cozulen.width : cozulen.height;

  final img.Image olcekli;
  if (enUzunKenar > KiyafetGorselHazirlayici.enBuyukKenar) {
    final oran = KiyafetGorselHazirlayici.enBuyukKenar / enUzunKenar;
    olcekli = img.copyResize(
      cozulen,
      width: (cozulen.width * oran).round().clamp(1, 100000),
      height: (cozulen.height * oran).round().clamp(1, 100000),
      interpolation: img.Interpolation.average,
    );
  } else {
    olcekli = cozulen;
  }

  // Şeffaf arka planı beyaza boya: JPEG alfa taşımadığı için boyanmazsa
  // arka plan siyah olur ve model kıyafeti yanlış okur.
  final tuval = img.Image(width: olcekli.width, height: olcekli.height);
  img.fill(tuval, color: img.ColorRgb8(255, 255, 255));
  img.compositeImage(tuval, olcekli);

  return Uint8List.fromList(
    img.encodeJpg(tuval, quality: KiyafetGorselHazirlayici.jpegKalitesi),
  );
}
