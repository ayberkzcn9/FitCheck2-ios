// Arka plan silme orkestrasyonunu doğrular (ağ çağrısı yapılmaz, sahtelerle).
//
// Kritik davranış: arka plan silinemezse yardımcı `null` döner ve karar
// kullanıcıya sorulur — fotoğraf SESSİZCE arka planıyla kaydedilmez.
//
// Çalıştırma: flutter test test/arka_plan_silme_yardimcisi_test.dart
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';

import 'package:fitcheck/services/arka_plan_silme_yardimcisi.dart';

Uint8List _bayt(int uzunluk) => Uint8List.fromList(List<int>.filled(uzunluk, 7));

void main() {
  group('ArkaPlanSilmeYardimcisi.dene', () {
    test('yerel sunucu ilk denemede başarılıysa buluta gidilmez', () async {
      var yerelCagri = 0;
      var bulutCagri = 0;

      final sonuc = await ArkaPlanSilmeYardimcisi.dene(
        _bayt(500),
        yerel: (_) async {
          yerelCagri++;
          return _bayt(400);
        },
        bulut: (_) async {
          bulutCagri++;
          return _bayt(300);
        },
        bekleme: Duration.zero,
      );

      expect(sonuc, isNotNull);
      expect(sonuc!.length, 400);
      expect(yerelCagri, 1, reason: 'Gereksiz tekrar denenmemeli');
      expect(bulutCagri, 0, reason: 'Yerel çalışıyorsa bulut çağrılmamalı');
    });

    test('yerel sunucu ilk denemede boş dönerse bir kez daha denenir', () async {
      var yerelCagri = 0;

      final sonuc = await ArkaPlanSilmeYardimcisi.dene(
        _bayt(500),
        yerel: (_) async {
          yerelCagri++;
          return yerelCagri == 1 ? null : _bayt(400);
        },
        bulut: (_) async => _bayt(300),
        bekleme: Duration.zero,
      );

      expect(sonuc, isNotNull);
      expect(yerelCagri, 2);
    });

    test('yerel sunucu hep başarısızsa buluta düşülür', () async {
      var bulutCagri = 0;

      final sonuc = await ArkaPlanSilmeYardimcisi.dene(
        _bayt(500),
        yerel: (_) async => null,
        bulut: (_) async {
          bulutCagri++;
          return _bayt(300);
        },
        bekleme: Duration.zero,
      );

      expect(sonuc, isNotNull);
      expect(bulutCagri, 1);
    });

    test('ikisi de başarısızsa null döner (karar kullanıcıya sorulur)', () async {
      final sonuc = await ArkaPlanSilmeYardimcisi.dene(
        _bayt(500),
        yerel: (_) async => null,
        bulut: (_) async => null,
        bekleme: Duration.zero,
      );

      expect(sonuc, isNull, reason: 'Sessizce arka planlı kaydedilmemeli');
    });

    test('kısa/bozuk yanıt geçersiz sayılır', () async {
      final sonuc = await ArkaPlanSilmeYardimcisi.dene(
        _bayt(500),
        yerel: (_) async => _bayt(10),
        bulut: (_) async => _bayt(50),
        bekleme: Duration.zero,
      );

      expect(sonuc, isNull);
      expect(ArkaPlanSilmeYardimcisi.gecerliMi(_bayt(101)), isTrue);
      expect(ArkaPlanSilmeYardimcisi.gecerliMi(_bayt(100)), isFalse);
      expect(ArkaPlanSilmeYardimcisi.gecerliMi(null), isFalse);
    });

    test('istisna atan servis akışı bozmaz', () async {
      final sonuc = await ArkaPlanSilmeYardimcisi.dene(
        _bayt(500),
        yerel: (_) async => throw Exception('ağ hatası'),
        bulut: (_) async => _bayt(300),
        bekleme: Duration.zero,
      );

      expect(sonuc?.length, 300);
    });
  });
}
