// FitCheck — Kesim kalite denetimi: kıyafet zemine çok yakın renkte mi?
//
// NEDEN: arka plan silme modelleri, kıyafet ile zeminin rengi birbirine çok
// yakın olduğunda sınırı bulamaz — görüntüde o hatta dair kenar bilgisi yoktur.
// Sonuç: arka plandan parça kalır ya da kıyafetin bir bölümü (ince askı,
// bağcık, beyaz ürünün beyaz zemindeki kenarı) kesilir. Bu bir model kusuru
// değil, girdi sorunudur; çözümü fotoğrafı daha kontrastlı bir zeminde yeniden
// çekmektir. Bu denetim, kullanıcıya bunu sonucu kaydettikten çok sonra değil,
// tam o anda söyler.
//
// ÖLÇÜT (iki ayrı görselden iki ortalama; hizalama gerekmez):
//   • Zemin rengi  → ORIJINAL fotoğrafın dış kenar şeridinin ortalaması.
//   • Kıyafet rengi → KESİLMİŞ görselde maske sınırının hemen içindeki
//     piksellerin ortalaması (bu piksellerin RGB'si korunur; yalnızca tamamen
//     saydam piksellerin rengi sıfırlanır).
//   • Zemin şeridi "tek renkli" değilse (dağınık/desenli arka plan) karar
//     VERİLMEZ: bu durumda ortalama bir renk anlamlı değildir ve yanlış uyarı
//     çıkmasın diye susulur.
//
// EŞİKLER bilinçli olarak tutucu: yalnızca gerçekten sınırın kaybolduğu
// fotoğraflarda uyarı çıkar.

import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

class KesimKaliteDenetimi {
  KesimKaliteDenetimi._();

  /// Renk farkı (0-441 arası Öklid) bu değerin altındaysa zemin kıyafete çok
  /// yakın sayılır. 45, "aynı rengin farklı tonu" sınırına denk gelir:
  /// beyaz kıyafet + beyaz zemin uyarı verir, açık gri zemin vermez.
  static const double zeminBenzerEsigi = 45;

  /// Zemin şeridinin tek renkliliği: kanal başına ortalama standart sapma bu
  /// değeri geçerse zemin "dağınık" sayılır ve karar verilmez.
  static const double zeminDuzgunlukEsigi = 20;

  /// Kenar şeridi genişliği (görselin kısa kenarına oran).
  static const double kenarSeridiOrani = 0.05;

  /// Maske sınırından en az bu kadar örnek toplanamazsa karar verilmez.
  static const int enAzSinirOrnegi = 300;

  /// İki görseli karşılaştırıp "zemin kıyafete çok yakın" kararını verir.
  ///
  /// [orijinal] arka plan silinmeden önceki fotoğraf, [kesilmis] sunucudan
  /// dönen saydamlı görseldir. Karar verilemeyen durumlarda `false` döner
  /// (yanlış uyarı göstermemek için).
  static Future<bool> zeminBenzerMi(Uint8List orijinal, Uint8List kesilmis) =>
      compute(zeminBenzerSenkron, <Uint8List>[orijinal, kesilmis]);

  /// [zeminBenzerMi] ile aynı işi yapar, isolate açmadan (testler için).
  static bool zeminBenzerSenkron(List<Uint8List> girdi) {
    if (girdi.length != 2) return false;
    try {
      final orijinal = img.decodeImage(girdi[0]);
      final kesim = img.decodeImage(girdi[1]);
      if (orijinal == null || kesim == null) return false;
      if (!kesim.hasAlpha) return false;

      final zemin = _zeminRengi(orijinal);
      if (zemin == null) return false;

      final kiyafet = _sinirRengi(kesim);
      if (kiyafet == null) return false;

      final dr = zemin.$1 - kiyafet.$1;
      final dg = zemin.$2 - kiyafet.$2;
      final db = zemin.$3 - kiyafet.$3;
      final fark = math.sqrt(dr * dr + dg * dg + db * db);

      debugPrint(
        'Kesim kalite denetimi: zemin ${zemin.$1.toStringAsFixed(0)},'
        '${zemin.$2.toStringAsFixed(0)},${zemin.$3.toStringAsFixed(0)} '
        '| kıyafet ${kiyafet.$1.toStringAsFixed(0)},'
        '${kiyafet.$2.toStringAsFixed(0)},${kiyafet.$3.toStringAsFixed(0)} '
        '| fark ${fark.toStringAsFixed(1)}',
      );

      return fark < zeminBenzerEsigi;
    } catch (e) {
      debugPrint('Kesim kalite denetimi yapılamadı: $e');
      return false;
    }
  }

  /// Orijinal fotoğrafın dış kenar şeridinden zemin rengini tahmin eder.
  ///
  /// Şerit tek renkli değilse `null` döner (karar verilmez).
  static (double, double, double)? _zeminRengi(img.Image gorsel) {
    final en = gorsel.width;
    final boy = gorsel.height;
    if (en < 8 || boy < 8) return null;

    final serit = math.max(2, (math.min(en, boy) * kenarSeridiOrani).round());
    final veri = gorsel.getBytes(order: img.ChannelOrder.rgb);

    var n = 0;
    var sr = 0.0, sg = 0.0, sb = 0.0;
    var qr = 0.0, qg = 0.0, qb = 0.0;

    void ekle(int x, int y) {
      final i = (y * en + x) * 3;
      final r = veri[i].toDouble();
      final g = veri[i + 1].toDouble();
      final b = veri[i + 2].toDouble();
      sr += r; sg += g; sb += b;
      qr += r * r; qg += g * g; qb += b * b;
      n++;
    }

    for (var y = 0; y < boy; y++) {
      final kenarda = y < serit || y >= boy - serit;
      if (kenarda) {
        for (var x = 0; x < en; x++) {
          ekle(x, y);
        }
      } else {
        for (var x = 0; x < serit; x++) {
          ekle(x, y);
          ekle(en - 1 - x, y);
        }
      }
    }

    if (n == 0) return null;

    final mr = sr / n, mg = sg / n, mb = sb / n;
    var vr = qr / n - mr * mr;
    var vg = qg / n - mg * mg;
    var vb = qb / n - mb * mb;
    if (vr < 0) vr = 0;
    if (vg < 0) vg = 0;
    if (vb < 0) vb = 0;
    final sapma = (math.sqrt(vr) + math.sqrt(vg) + math.sqrt(vb)) / 3.0;

    // Dağınık/desenli arka plan: ortalama renk anlamsız → karar verilmez.
    if (sapma > zeminDuzgunlukEsigi) return null;

    return (mr, mg, mb);
  }

  /// Kesilmiş görselde maske sınırının HEMEN İÇİNDEKİ piksellerin ortalama
  /// rengini verir. Sınır, kıyafetin gerçek kenarıdır; oradaki renk ile zemin
  /// rengi karşılaştırılır.
  static (double, double, double)? _sinirRengi(img.Image kesim) {
    final en = kesim.width;
    final boy = kesim.height;
    if (en < 3 || boy < 3) return null;

    final veri = kesim.getBytes(order: img.ChannelOrder.rgba);

    const icEsik = 200; // sınırın içi sayılacak alfa
    const disEsik = 60; // dışarısı sayılacak alfa

    var sayi = 0;
    var sr = 0.0, sg = 0.0, sb = 0.0;

    // Tüm pikseller taranır (seyreltme YAPILMAZ): büyük fotoğraflarda sınır
    // pikseli sayısı azdır; örneklemek uyarının hiç çıkmamasına yol açıyordu.
    for (var y = 0; y < boy; y++) {
      final satir = y * en;
      for (var x = 0; x < en; x++) {
        final p = satir + x;
        final i = p * 4;
        if (veri[i + 3] < icEsik) continue;

        var kenarda = false;
        if (x > 0 && veri[i - 4 + 3] <= disEsik) {
          kenarda = true;
        } else if (x < en - 1 && veri[i + 4 + 3] <= disEsik) {
          kenarda = true;
        } else if (y > 0 && veri[i - en * 4 + 3] <= disEsik) {
          kenarda = true;
        } else if (y < boy - 1 && veri[i + en * 4 + 3] <= disEsik) {
          kenarda = true;
        }
        if (!kenarda) continue;

        sr += veri[i].toDouble();
        sg += veri[i + 1].toDouble();
        sb += veri[i + 2].toDouble();
        sayi++;
      }
    }

    if (sayi < enAzSinirOrnegi) return null;
    return (sr / sayi, sg / sayi, sb / sayi);
  }
}
