// Maske temizliğini GERÇEK sunucu çıktılarıyla ölçer: süre + ne kadar değişti.
//
// Kullanım: dart run tool/maske_olcum.dart <png> [<png> ...]
// Değişiklik varsa <ad>_temiz.png dosyasını yazar (gözle karşılaştırmak için).
import 'dart:io';

import 'package:fitcheck/services/maske_temizleyici.dart';
import 'package:image/image.dart' as img;

void main(List<String> yolListesi) {
  if (yolListesi.isEmpty) {
    stderr.writeln('Kullanım: dart run tool/maske_olcum.dart <png> [...]');
    exitCode = 64;
    return;
  }

  for (final yol in yolListesi) {
    final dosya = File(yol);
    if (!dosya.existsSync()) {
      stdout.writeln('ATLA (yok): $yol');
      continue;
    }

    final gorsel = img.decodePng(dosya.readAsBytesSync());
    if (gorsel == null) {
      stdout.writeln('ATLA (PNG değil): $yol');
      continue;
    }

    // Öncesi/sonrası saydam olmayan piksel sayısı (kaç piksel değişti?).
    int doluSayisi(img.Image g) {
      var sayi = 0;
      for (var y = 0; y < g.height; y++) {
        for (var x = 0; x < g.width; x++) {
          if (g.getPixel(x, y).a >= MaskeTemizleyici.alfaEsigi) sayi++;
        }
      }
      return sayi;
    }

    final oncekiDolu = doluSayisi(gorsel);

    final t0 = DateTime.now();
    final degisti = MaskeTemizleyici.temizle(gorsel);
    final ms = DateTime.now().difference(t0).inMilliseconds;

    final sonrakiDolu = doluSayisi(gorsel);

    stdout.writeln(
      '${dosya.uri.pathSegments.last}: ${gorsel.width}x${gorsel.height}  '
      '$ms ms  değişti=$degisti  '
      'dolu $oncekiDolu -> $sonrakiDolu (${sonrakiDolu - oncekiDolu})',
    );

    if (degisti) {
      final cikis = yol.replaceAll('.png', '_temiz.png');
      File(cikis).writeAsBytesSync(img.encodePng(gorsel));
      stdout.writeln('  -> $cikis');
    }
  }
}
