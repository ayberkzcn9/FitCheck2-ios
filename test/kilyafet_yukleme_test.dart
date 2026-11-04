// Arka planda kıyafet yükleme servisi testleri.
//
// Ağ çağrısı yapılmaz: arka plan silici ve analiz enjekte edilir.

import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';

import 'package:fitcheck/models/kiyafet.dart';
import 'package:fitcheck/services/kiyafet_analiz_servisi.dart';
import 'package:fitcheck/services/kilyafet_yukleme_servisi.dart';

Uint8List _png() {
  // 1×1 geçerli PNG (başlık/renk burada önemsiz).
  const List<int> veri = [
    0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, //
    0x00, 0x00, 0x00, 0x0D, 0x49, 0x48, 0x44, 0x52,
    0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
    0x08, 0x02, 0x00, 0x00, 0x00, 0x90, 0x77, 0x53,
    0xDE, 0x00, 0x00, 0x00, 0x0C, 0x49, 0x44, 0x41,
    0x54, 0x08, 0xD7, 0x63, 0xF8, 0xCF, 0xC0, 0x00,
    0x00, 0x03, 0x01, 0x01, 0x00, 0x18, 0xDD, 0x8D,
    0xB0, 0x00, 0x00, 0x00, 0x00, 0x49, 0x45, 0x4E,
    0x44, 0xAE, 0x42, 0x60, 0x82,
  ];
  return Uint8List.fromList(veri);
}

/// Galeriden seçilmiş bir dosya gibi davranan sahte XFile.
XFile _sahteDosya() => XFile.fromData(_png(), name: 'sahte.png');

void main() {
  final servis = KilyafetYuklemeServisi();

  tearDown(() => servis.sifirla());

  test('başlat: her fotoğraf için parça ekler ve durumu günceller', () async {
    final eklenenler = <Kiyafet>[];

    await servis.baslat(
      dosyalar: [_sahteDosya(), _sahteDosya()],
      dil: 'tr',
      parcaEklendi: (k) async => eklenenler.add(k),
      arkaPlanSilici: (b) async => b,
      analiz: (resim, dil) async => const KiyafetAnalizi(
        baslik: 'Beyaz Tişört',
        kategori: 'ust',
        renk: 'Beyaz',
        stil: 'Casual',
      ),
    );

    expect(eklenenler.length, 2);
    expect(eklenenler.first.baslik, 'Beyaz Tişört');
    expect(eklenenler.first.kategori, 'ust');

    final durum = servis.durum.value;
    expect(durum.calisiyor, isFalse);
    expect(durum.eklenen, 2);
    expect(durum.atlanan, 0);
    expect(durum.toplam, 2);
  });

  test('arka plan silinemeyen fotoğraf atlanır, iş devam eder', () async {
    final eklenenler = <Kiyafet>[];
    var cagri = 0;

    await servis.baslat(
      dosyalar: [_sahteDosya(), _sahteDosya()],
      dil: 'tr',
      parcaEklendi: (k) async => eklenenler.add(k),
      arkaPlanSilici: (b) async {
        cagri++;
        // İlk fotoğrafta arka plan silinemiyor.
        return cagri == 1 ? null : b;
      },
      analiz: (resim, dil) async => const KiyafetAnalizi(
        baslik: 'Pantolon',
        kategori: 'alt',
        renk: 'Siyah',
        stil: 'Casual',
      ),
    );

    expect(eklenenler.length, 1);
    expect(servis.durum.value.atlanan, 1);
    expect(servis.durum.value.eklenen, 1);
  });

  test('analiz hatasında fotoğraf atlanır, işlem sürer', () async {
    final eklenenler = <Kiyafet>[];
    var cagri = 0;

    await servis.baslat(
      dosyalar: [_sahteDosya(), _sahteDosya()],
      dil: 'tr',
      parcaEklendi: (k) async => eklenenler.add(k),
      arkaPlanSilici: (b) async => b,
      analiz: (resim, dil) async {
        cagri++;
        if (cagri == 1) throw Exception('analiz yok');
        return const KiyafetAnalizi(
          baslik: 'Sneaker',
          kategori: 'ayakkabi',
          renk: 'Beyaz',
          stil: 'Casual',
        );
      },
    );

    expect(eklenenler.length, 1);
    expect(servis.durum.value.atlanan, 1);
  });

  test('bitiş bildirimi eklendi ve atlanan sayılarıyla çağrılır', () async {
    int? eklendi;
    int? atlandi;

    await servis.baslat(
      dosyalar: [_sahteDosya()],
      dil: 'tr',
      parcaEklendi: (k) async {},
      onBitti: (e, a) {
        eklendi = e;
        atlandi = a;
      },
      arkaPlanSilici: (b) async => b,
      analiz: (resim, dil) async => const KiyafetAnalizi(
        baslik: 'Tişört',
        kategori: 'ust',
        renk: 'Siyah',
        stil: 'Casual',
      ),
    );

    expect(eklendi, 1);
    expect(atlandi, 0);
  });

  test('aynı anda ikinci iş başlatılmaz', () async {
    final ilkIs = servis.baslat(
      dosyalar: [_sahteDosya()],
      dil: 'tr',
      parcaEklendi: (k) async {},
      arkaPlanSilici: (b) async => b,
      analiz: (resim, dil) async => const KiyafetAnalizi(
        baslik: 'X',
        kategori: 'ust',
        renk: 'Siyah',
        stil: 'Casual',
      ),
    );

    var ikinciBasladi = false;
    await servis.baslat(
      dosyalar: [_sahteDosya()],
      dil: 'tr',
      parcaEklendi: (k) async => ikinciBasladi = true,
      arkaPlanSilici: (b) async => b,
      analiz: (resim, dil) async => const KiyafetAnalizi(
        baslik: 'Y',
        kategori: 'ust',
        renk: 'Siyah',
        stil: 'Casual',
      ),
    );

    expect(ikinciBasladi, isFalse);
    await ilkIs;
  });
}
