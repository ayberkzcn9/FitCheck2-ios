// Kıyafet yüklemesini arka planda sürdüren servis.
//
// SORUN: Fotoğraf ekleme akışı ekranda kilitli bir yükleme katmanıyla
// çalışıyordu; kullanıcı 10 fotoğraf yüklerken uygulamayı kullanamıyordu.
// ÇÖZÜM: İş, ekrandan bağımsız bir servis tarafından sürdürülür. Kullanıcı
// "Arka planda ekle" dediğinde akış hemen kapanır, iş devam eder, ilerleme
// uygulamanın her yerinde ince bir çubuk olarak görünür ve sonuçta özet
// bildirilir.
//
// Tasarım notları:
//  * Servis tek iş yapar (aynı anda tek kuyruk); "zaten çalışıyor" durumunda
//    yeni iş başlatılmaz.
//  * Arka plan modunda kullanıcıya **soru sorulmaz**: arka plan silinemezse
//    fotoğraf atlanır, kesim tutmazsa uyarı özette toplanır.
//  * Test için dış bağımlılıklar (arka plan silici, analiz) enjekte edilebilir.

import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import '../models/kiyafet.dart';
import 'arka_plan_silme_yardimcisi.dart';
import 'background_remover_service.dart';
import 'gorsel_yon_service.dart';
import 'kiyafet_analiz_servisi.dart';

/// Arka plan yüklemesinin anlık durumu.
class KilyafetYuklemeDurumu {
  const KilyafetYuklemeDurumu({
    this.calisiyor = false,
    this.islenen = 0,
    this.toplam = 0,
    this.eklenen = 0,
    this.atlanan = 0,
    this.adim = '',
    this.hata,
  });

  final bool calisiyor;

  /// İşlenen fotoğraf sayısı.
  final int islenen;

  /// Toplam fotoğraf sayısı.
  final int toplam;

  /// Başarıyla eklenen parça sayısı.
  final int eklenen;

  /// Atlanan (başarısız) fotoğraf sayısı.
  final int atlanan;

  /// Şu anki adım: 'arka_plan' | 'analiz' | 'kaydet'.
  final String adim;

  /// İş bitince hata metni (varsa).
  final String? hata;

  double get oran => toplam == 0 ? 0 : islenen / toplam;
}

/// Arka plan kıyafet yükleme servisi (tekil).
class KilyafetYuklemeServisi {
  KilyafetYuklemeServisi._();

  static final KilyafetYuklemeServisi _ornek = KilyafetYuklemeServisi._();
  factory KilyafetYuklemeServisi() => _ornek;

  /// İlerleme dinleyicisi (uygulamanın her yerinden izlenebilir).
  final ValueNotifier<KilyafetYuklemeDurumu> durum =
      ValueNotifier<KilyafetYuklemeDurumu>(const KilyafetYuklemeDurumu());

  static int _idSayaci = 0;

  bool get calisiyor => durum.value.calisiyor;

  /// Yüklemeyi arka planda başlatır.
  ///
  /// [parcaEklendi] her parça için çağrılır; ekran kapansa da çalışır.
  /// [onBitti] iş bitince (eklendi/atlandı sayılarıyla) çağrılır.
  Future<void> baslat({
    required List<XFile> dosyalar,
    required String dil,
    required Future<void> Function(Kiyafet kiyafet) parcaEklendi,
    void Function(int eklendi, int atlanan)? onBitti,
    ArkaPlanSilici? arkaPlanSilici,
    Future<KiyafetAnalizi> Function(Uint8List resim, String dil)? analiz,
  }) async {
    if (calisiyor || dosyalar.isEmpty) return;

    durum.value = KilyafetYuklemeDurumu(
      calisiyor: true,
      islenen: 0,
      toplam: dosyalar.length,
    );

    var eklendi = 0;
    var atlandi = 0;

    final silici = arkaPlanSilici ??
        (Uint8List baytlar) => ArkaPlanSilmeYardimcisi.dene(
              baytlar,
              yerel: BackgroundRemoverService.removeBackground,
            );

    final analizEt = analiz ??
        (Uint8List resim, String d) =>
            KiyafetAnalizServisi.analizEt(resim: resim, dil: d);

    for (var i = 0; i < dosyalar.length; i++) {
      try {
        durum.value = KilyafetYuklemeDurumu(
          calisiyor: true,
          islenen: i,
          toplam: dosyalar.length,
          eklenen: eklendi,
          atlanan: atlandi,
          adim: 'arka_plan',
        );

        final orijinal = await dosyalar[i].readAsBytes();

        final kesim = await silici(orijinal);
        if (kesim == null) {
          // Arka plan silinemedi: arka plan modunda soru sorulmaz, atlanır.
          atlandi++;
          continue;
        }

        durum.value = KilyafetYuklemeDurumu(
          calisiyor: true,
          islenen: i,
          toplam: dosyalar.length,
          eklenen: eklendi,
          atlanan: atlandi,
          adim: 'analiz',
        );

        final duzenlenmis = await GorselYonService.duzenle(kesim) ?? kesim;
        final analiz = await analizEt(duzenlenmis, dil);

        durum.value = KilyafetYuklemeDurumu(
          calisiyor: true,
          islenen: i,
          toplam: dosyalar.length,
          eklenen: eklendi,
          atlanan: atlandi,
          adim: 'kaydet',
        );

        _idSayaci++;
        final kimlik =
            '${DateTime.now().microsecondsSinceEpoch}_${_idSayaci}_${Random().nextInt(999999999)}_${duzenlenmis.length}';

        await parcaEklendi(
          Kiyafet(
            id: kimlik,
            baslik: analiz.baslik,
            kategori: analiz.kategori,
            resimBytes: duzenlenmis,
            renk: analiz.renk,
            stil: analiz.stil,
            mevsim: analiz.mevsim,
            fiyat: 0.0,
          ),
        );
        eklendi++;
      } catch (e) {
        atlandi++;
        debugPrint('Arka plan yükleme: ${i + 1}. fotoğraf işlenemedi ($e)');
      } finally {
        durum.value = KilyafetYuklemeDurumu(
          calisiyor: true,
          islenen: i + 1,
          toplam: dosyalar.length,
          eklenen: eklendi,
          atlanan: atlandi,
        );
      }
    }

    durum.value = KilyafetYuklemeDurumu(
      calisiyor: false,
      islenen: dosyalar.length,
      toplam: dosyalar.length,
      eklenen: eklendi,
      atlanan: atlandi,
    );

    onBitti?.call(eklendi, atlandi);
  }

  /// Test/eklenti amaçlı: durumu sıfırlar.
  void sifirla() {
    durum.value = const KilyafetYuklemeDurumu();
  }
}
