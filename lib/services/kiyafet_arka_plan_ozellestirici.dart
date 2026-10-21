// Kesilmiş kıyafeti seçilen zemine yerleştirip birleştirir.
//
// Neden ayrı dosya: piksel işi `image` paketiyle yapılıyor ve 1600 px'lik bir
// PNG'yi decode etmek ana iş parçacığını kilitler. Bu yüzden birleştirme
// **ayrı bir izolasyonda** çalışır; testte saf fonksiyon olarak da çağrılabilir.
//
// Tuvâl kare (1:1) ve dolabın ızgarasıyla aynı oranı taşır: böylece
// "ekranda gördüğün" ile "kaydedilen" aynı yerleşimdir.

import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

/// Kıyafetin arkasına seçilebilecek zeminler.
enum KirmaZemin {
  /// Temiz beyaz (varsayılan; katalog fotoğrafı hissi).
  beyaz,

  /// Sıcak kırık beyaz.
  kirikBeyaz,

  /// Soğuk açık gri.
  acikGri,

  /// Saydam (kendi zemininde saklanır; PNG).
  saydam,
}

/// Birleştirme girdisi (izolasyona gönderilebilir olmalı).
class BirlestirmeGirdisi {
  const BirlestirmeGirdisi({
    required this.kesim,
    required this.zemin,
    required this.olcek,
    required this.konumX,
    required this.konumY,
  });

  final Uint8List kesim;

  /// [KirmaZemin] indeksi.
  final int zemin;

  /// Tuvâla sığdırma çarpanı (1 = tam sığdırılmış).
  final double olcek;

  /// Yatay kayma, tuval genişliğinin oranı (-1..1).
  final double konumX;

  /// Dikey kayma, tuval yüksekliğinin oranı (-1..1).
  final double konumY;
}

class KiyafetArkaPlanOzellestirici {
  const KiyafetArkaPlanOzellestirici._();

  /// Kaydedilen görselin kare boyutu (piksel).
  static const int tuvalBoyutu = 1024;

  /// JPEG kalitesi (opak zeminlerde).
  static const int jpegKalitesi = 85;

  /// Zemin rengi (ARGB). Saydam zemin için `null`.
  static int? zeminRengi(KirmaZemin zemin) {
    switch (zemin) {
      case KirmaZemin.beyaz:
        return 0xFFFFFFFF;
      case KirmaZemin.kirikBeyaz:
        return 0xFFF4EFE7;
      case KirmaZemin.acikGri:
        return 0xFFE8E8E8;
      case KirmaZemin.saydam:
        return null;
    }
  }

  /// Kesilmiş görseli seçilen zemine yerleştirip birleştirir.
  ///
  /// [olcek] 1 = görsel tuvâla tam sığar; [konumX]/[konumY] ise tuvâl
  /// boyutunun oranı cinsinden kayma (-1..1).
  static Future<Uint8List> birlestir(
    Uint8List kesim, {
    required KirmaZemin zemin,
    double olcek = 1,
    double konumX = 0,
    double konumY = 0,
  }) {
    return compute(
      _birlestirIsolate,
      BirlestirmeGirdisi(
        kesim: kesim,
        zemin: zemin.index,
        olcek: olcek,
        konumX: konumX,
        konumY: konumY,
      ),
    );
  }

  /// Aynı hesap, izolasyonsuz (testler ve önizleme için).
  static Uint8List birlestirDogrudan(
    Uint8List kesim, {
    required KirmaZemin zemin,
    double olcek = 1,
    double konumX = 0,
    double konumY = 0,
  }) {
    return _birlestirIsolate(
      BirlestirmeGirdisi(
        kesim: kesim,
        zemin: zemin.index,
        olcek: olcek,
        konumX: konumX,
        konumY: konumY,
      ),
    );
  }

  /// Bozuk baytlar `decodeImage`'in içinde istisna fırlatabiliyor; akışı
  /// kırmamak için yakalanır.
  static img.Image? _guvenliCoz(Uint8List veri) {
    try {
      return img.decodeImage(veri);
    } catch (_) {
      return null;
    }
  }

  /// Birleştirmenin izolasyon içindeki gövdesi.
  static Uint8List _birlestirIsolate(BirlestirmeGirdisi girdi) {
    final kesim = _guvenliCoz(girdi.kesim);
    if (kesim == null) return girdi.kesim;

    final N = tuvalBoyutu;
    final tuval = img.Image(width: N, height: N, numChannels: 4);

    final zemin = zeminRengi(KirmaZemin.values[girdi.zemin]);
    if (zemin == null) {
      img.fill(tuval, color: img.ColorRgba8(0, 0, 0, 0));
    } else {
      img.fill(
        tuval,
        color: img.ColorRgb8(
          (zemin >> 16) & 0xFF,
          (zemin >> 8) & 0xFF,
          zemin & 0xFF,
        ),
      );
    }

    // Görseli tuvâla sığdır, sonra ölçek ve kayma uygula.
    final oran = math.min(N / kesim.width, N / kesim.height) * girdi.olcek;
    final genislik = math.max(1, (kesim.width * oran).round());
    final yukseklik = math.max(1, (kesim.height * oran).round());
    final x = ((N - genislik) / 2 + girdi.konumX * N).round();
    final y = ((N - yukseklik) / 2 + girdi.konumY * N).round();

    img.compositeImage(
      tuval,
      kesim,
      dstX: x,
      dstY: y,
      dstW: genislik,
      dstH: yukseklik,
    );

    if (zemin == null) return img.encodePng(tuval);
    return img.encodeJpg(tuval, quality: jpegKalitesi);
  }

  /// Kayıtlı görselin byte büyüklüğü (tahmini) — depolama uyarısı için.
  static int tahminiBoyut(Uint8List kesim, KirmaZemin zemin) {
    if (zemin == KirmaZemin.saydam) return kesim.length * 2;
    return kesim.length ~/ 2;
  }

  /// Testler için: görselin gerçek boyutu.
  static (int genislik, int yukseklik) boyut(Uint8List veri) {
    final gorsel = img.decodeImage(veri);
    if (gorsel == null) return (0, 0);
    return (gorsel.width, gorsel.height);
  }

  /// Görselin üst kenarından bir örnek nokta alır (test: zemin rengi uygulandı mı).
  static int? ustMerkezRengi(Uint8List veri) {
    final gorsel = img.decodeImage(veri);
    if (gorsel == null) return null;
    final p = gorsel.getPixel(gorsel.width ~/ 2, 2);
    return (p.a.toInt() << 24) |
        (p.r.toInt() << 16) |
        (p.g.toInt() << 8) |
        p.b.toInt();
  }
}
