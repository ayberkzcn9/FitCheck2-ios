// FitCheck — Arka planı silinmiş görsellerde kalan maske kusurlarını temizler.
//
// SORUN: Arka plan silme modelleri (sunucudaki silueta/u2net) kıyafetin
// çevresinde fotoğrafın arka planından kalan küçük "leke"ler bırakabilir ya da
// kıyafetin içinde küçük "delik"ler açabilir. Bu kusurlar gardırop ızgarasında
// kirli görünür ve otomatik kırpmanın sınırını da bozar (kırpma, uzaktaki bir
// lekeyi de içeri alır; kıyafet kutuda küçük kalır).
//
// ÇÖZÜM — iki muhafazakâr adım:
//   1) Küçük ve gürültü benzeri (seyrek) saydam olmayan adacıklar SİLİNİR.
//   2) Kıyafetin içinde kapalı kalan KÜÇÜK delikler, çevredeki kumaş rengi
//      içeri doğru yayılarak KAPATILIR (delik, arka plan rengiyle değil kumaş
//      rengiyle dolar; aksi hâlde kıyafetin üstünde leke gibi görünürdü).
//
// KORUNANLAR (eşikler bilinçli olarak tutucu):
//   • Büyük ve dolu adacıklar — ör. kıyafetten ayrı duran kemer, tokalı çanta
//     askısı — silinmez (yalnızca küçük ya da gürültü benzeri olanlar gider).
//   • İnce ama UZUN adacıklar — eğik duran askı, bağcık, kemer ucu — "seyrek"
//     görünseler bile silinmez (bkz. inceUzunKosegenOrani). Gerçek lekeler
//     kısa ve dağınıktır; ayırt etmenin ölçütü budur.
//   • Büyük delikler — ör. çanta sapının oluşturduğu gerçek boşluk, gözlük
//     çerçevesinin içi — kapatılmaz.
//
// NOT: Eşikler 19.10.2026'da 10 kat sıkılaştırıldı. Önceki değerlerle (leke
// oranı 0,0002 / orta 0,0008) 1600 px'lik bir görselde 343 piksele kadar olan
// seyrek parçalar siliniyor, yani kıyafetin bağcık/toka gibi gerçek parçaları
// kayboluyordu.
//
// Tüm eşikler aşağıdaki sabitlerden ayarlanabilir; algoritma görsel boyutundan
// bağımsız çalışsın diye hepsi GÖRSEL ALANINA ORAN olarak tanımlıdır.

import 'dart:math' as math;
import 'dart:typed_data';

import 'package:image/image.dart' as img;

class MaskeTemizleyici {
  MaskeTemizleyici._();

  /// Bu değerin altındaki alfa "saydam" sayılır (maske ikiye ayrılırken).
  /// `GorselYonService.alfaEsigi` (8) sınır kutusu içindir; maske kararı için
  /// daha katı bir eşik kullanılır ki yarı saydam saçaklar delik sayılmasın.
  static const int alfaEsigi = 128;

  /// Bu orandan küçük adacıklar her koşulda silinir (görsel alanına oran).
  /// Bilinçli olarak çok küçük: gerçek lekeler birkaç pikselliktir, tokası/
  /// bağcığı olan gerçek parçalar bu boyuta nadiren iner.
  static const double kucukLekeOrani = 0.00002;

  /// Bu orandan küçük adacıklar, yalnızca "gürültü benzeri" ise silinir.
  static const double ortaLekeOrani = 0.0002;

  /// Gürültü ölçütü: adacığın alanı, sınır kutusunun alanına göre bu orandan
  /// küçükse seyrek/dağınık (gürültü benzeri) sayılır. Kenarları taraklı, ince
  /// bir leke bu sayede yakalanır; dolu ve toplu bir parça korunur.
  static const double seyreklikSiniri = 0.35;

  /// İnce-uzun koruma: "seyrek" görünen adacık, sınır kutusunun köşegeni
  /// görselin uzun kenarının bu oranından büyükse SİLİNMEZ. Eğik duran ince
  /// askı, bağcık ya da kemer ucu bu kurala girer; aksi hâlde kıyafetin bir
  /// parçası "leke" sanılıp yok ediliyordu. Kısa ve seyrek parçalar (gerçek
  /// lekeler) silinmeye devam eder.
  static const double inceUzunKosegenOrani = 0.03;

  /// Bu orandan küçük delikler kapatılır (görsel alanına oran).
  static const double enBuyukDelikOrani = 0.002;

  /// Görselin alfa maskesini temizler. **Yerinde** çalışır (görseli değiştirir)
  /// ve gerçekten bir şey değiştiyse `true` döner — çağıran taraf, değişiklik
  /// yoksa görseli yeniden kodlamaz.
  ///
  /// Saydamlık yoksa ya da maske tamamen boş/doluysa hiçbir şey yapılmaz.
  static bool temizle(img.Image gorsel) {
    if (!gorsel.hasAlpha) return false;

    final en = gorsel.width;
    final boy = gorsel.height;
    final n = en * boy;
    if (n == 0) return false;

    final veri = gorsel.getBytes(order: img.ChannelOrder.rgba);

    // İkili maske: 1 = kıyafet (saydam değil), 0 = arka plan (saydam).
    final dolu = Uint8List(n);
    var doluSayi = 0;
    for (var i = 0; i < n; i++) {
      if (veri[i * 4 + 3] >= alfaEsigi) {
        dolu[i] = 1;
        doluSayi++;
      }
    }
    // Temizlenecek bir maske yok: ya tamamen boş ya tamamen dolu.
    if (doluSayi == 0 || doluSayi == n) return false;

    final kucukEsik = math.max(6, (n * kucukLekeOrani).round());
    final ortaEsik = math.max(24, (n * ortaLekeOrani).round());
    final delikEsigi = math.max(64, (n * enBuyukDelikOrani).round());

    var degisti = false;

    // Yığın, görüntünün tamamı kadar olabilir: her piksel en fazla bir kez
    // yığına konur. Kayan nokta / özyineleme kullanılmaz (yığın taşması yok).
    final yigin = Int32List(n);

    // ---------------------------------------------------------------- 1) LEKE
    // Saydam olmayan bağlı bileşenleri gez (4 komşuluk) ve küçük/gürültü
    // benzeri olanları sil.
    final etiket = Int32List(n)..fillRange(0, n, -1);
    final uyeler = <int>[];

    for (var bas = 0; bas < n; bas++) {
      if (dolu[bas] == 0 || etiket[bas] != -1) continue;

      var tepe = 0;
      yigin[tepe++] = bas;
      etiket[bas] = bas;
      uyeler.clear();
      var sol = en, sag = -1, ust = boy, alt = -1;

      while (tepe > 0) {
        final p = yigin[--tepe];
        uyeler.add(p);
        final px = p % en;
        final py = p ~/ en;
        if (px < sol) sol = px;
        if (px > sag) sag = px;
        if (py < ust) ust = py;
        if (py > alt) alt = py;

        if (px > 0) {
          final q = p - 1;
          if (dolu[q] == 1 && etiket[q] == -1) {
            etiket[q] = bas;
            yigin[tepe++] = q;
          }
        }
        if (px < en - 1) {
          final q = p + 1;
          if (dolu[q] == 1 && etiket[q] == -1) {
            etiket[q] = bas;
            yigin[tepe++] = q;
          }
        }
        if (py > 0) {
          final q = p - en;
          if (dolu[q] == 1 && etiket[q] == -1) {
            etiket[q] = bas;
            yigin[tepe++] = q;
          }
        }
        if (py < boy - 1) {
          final q = p + en;
          if (dolu[q] == 1 && etiket[q] == -1) {
            etiket[q] = bas;
            yigin[tepe++] = q;
          }
        }
      }

      final alan = uyeler.length;
      var silinsin = alan < kucukEsik;
      var seyrek = false;
      final kutuAlan = (sag - sol + 1) * (alt - ust + 1);
      if (alan < ortaEsik && alan < kutuAlan * seyreklikSiniri) {
        seyrek = true;
        silinsin = true;
      }

      // İnce ama uzun parça (askı, bağcık, kemer ucu) yapısal kıyafet
      // parçasıdır: "seyrek" görünse bile korunur.
      if (silinsin && seyrek) {
        final kosegen = math.sqrt(kutuAlan.toDouble());
        if (kosegen >= inceUzunKosegenOrani * math.max(en, boy)) {
          silinsin = false;
        }
      }

      if (silinsin) {
        for (final p in uyeler) {
          dolu[p] = 0;
          final i = p * 4;
          gorsel.setPixelRgba(p % en, p ~/ en, veri[i], veri[i + 1], veri[i + 2], 0);
        }
        degisti = true;
      }
    }

    // ---------------------------------------------------------------- 2) DELİK
    // Kenardan erişilebilen saydam alan "dışarısı"dır. Erişilemeyen saydam
    // bölgeler (kıyafetin içinde kapalı kalanlar) delik adayıdır.
    // disari: 0 = henüz bakılmadı, 1 = dışarısı, 2 = delik pikeseli (işlendi)
    final disari = Uint8List(n);
    var tepe = 0;

    void tohumla(int p) {
      if (dolu[p] == 0 && disari[p] == 0) {
        disari[p] = 1;
        yigin[tepe++] = p;
      }
    }

    for (var x = 0; x < en; x++) {
      tohumla(x);
      tohumla((boy - 1) * en + x);
    }
    for (var y = 0; y < boy; y++) {
      tohumla(y * en);
      tohumla(y * en + en - 1);
    }

    while (tepe > 0) {
      final p = yigin[--tepe];
      final px = p % en;
      final py = p ~/ en;
      if (px > 0) {
        final q = p - 1;
        if (dolu[q] == 0 && disari[q] == 0) {
          disari[q] = 1;
          yigin[tepe++] = q;
        }
      }
      if (px < en - 1) {
        final q = p + 1;
        if (dolu[q] == 0 && disari[q] == 0) {
          disari[q] = 1;
          yigin[tepe++] = q;
        }
      }
      if (py > 0) {
        final q = p - en;
        if (dolu[q] == 0 && disari[q] == 0) {
          disari[q] = 1;
          yigin[tepe++] = q;
        }
      }
      if (py < boy - 1) {
        final q = p + en;
        if (dolu[q] == 0 && disari[q] == 0) {
          disari[q] = 1;
          yigin[tepe++] = q;
        }
      }
    }

    // Kalan saydam pikseller kapalı deliklerdir: bileşenlere ayır.
    final kuyruk = Int32List(n);
    final renk = Int32List(n)..fillRange(0, n, -1);

    void doldur(List<int> delik) {
      // Deliğin kenarındaki kumaş pikselinin rengini içeri doğru yay: en yakın
      // kenar rengi her piksele ulaşır (BFS). Böylece deliğin üstü kumaş
      // rengiyle kapanır, arka plan rengiyle değil.
      var bas = 0, son = 0;
      for (final p in delik) {
        renk[p] = -2;
      }
      for (final p in delik) {
        final px = p % en;
        final py = p ~/ en;
        var kaynak = -1;
        if (px > 0 && dolu[p - 1] == 1) kaynak = p - 1;
        if (kaynak < 0 && px < en - 1 && dolu[p + 1] == 1) kaynak = p + 1;
        if (kaynak < 0 && py > 0 && dolu[p - en] == 1) kaynak = p - en;
        if (kaynak < 0 && py < boy - 1 && dolu[p + en] == 1) kaynak = p + en;
        if (kaynak >= 0) {
          renk[p] = (veri[kaynak * 4] << 16) |
              (veri[kaynak * 4 + 1] << 8) |
              veri[kaynak * 4 + 2];
          kuyruk[son++] = p;
        }
      }

      while (bas < son) {
        final p = kuyruk[bas++];
        final px = p % en;
        final py = p ~/ en;
        for (var k = 0; k < 4; k++) {
          final int q;
          if (k == 0) {
            if (px == 0) continue;
            q = p - 1;
          } else if (k == 1) {
            if (px == en - 1) continue;
            q = p + 1;
          } else if (k == 2) {
            if (py == 0) continue;
            q = p - en;
          } else {
            if (py == boy - 1) continue;
            q = p + en;
          }
          if (renk[q] == -2) {
            renk[q] = renk[p];
            kuyruk[son++] = q;
          }
        }
      }

      for (final p in delik) {
        final c = renk[p];
        gorsel.setPixelRgba(
          p % en,
          p ~/ en,
          (c >> 16) & 0xFF,
          (c >> 8) & 0xFF,
          c & 0xFF,
          255,
        );
        renk[p] = -1;
      }
    }

    final delik = <int>[];
    for (var bas = 0; bas < n; bas++) {
      if (dolu[bas] == 1 || disari[bas] != 0) continue;

      var tp = 0;
      yigin[tp++] = bas;
      disari[bas] = 2;
      delik.clear();

      while (tp > 0) {
        final p = yigin[--tp];
        delik.add(p);
        final px = p % en;
        final py = p ~/ en;
        if (px > 0) {
          final q = p - 1;
          if (dolu[q] == 0 && disari[q] == 0) {
            disari[q] = 2;
            yigin[tp++] = q;
          }
        }
        if (px < en - 1) {
          final q = p + 1;
          if (dolu[q] == 0 && disari[q] == 0) {
            disari[q] = 2;
            yigin[tp++] = q;
          }
        }
        if (py > 0) {
          final q = p - en;
          if (dolu[q] == 0 && disari[q] == 0) {
            disari[q] = 2;
            yigin[tp++] = q;
          }
        }
        if (py < boy - 1) {
          final q = p + en;
          if (dolu[q] == 0 && disari[q] == 0) {
            disari[q] = 2;
            yigin[tp++] = q;
          }
        }
      }

      if (delik.length <= delikEsigi) {
        doldur(delik);
        for (final p in delik) {
          dolu[p] = 1;
        }
        degisti = true;
      }
    }

    return degisti;
  }
}
