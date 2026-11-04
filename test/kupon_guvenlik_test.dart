// Yönetici kuponu ve yönetici modu yalnızca geliştirme derlemesinde çalışmalı.
//
// Geçmişte kupon kodu (FITCHECK-ADMIN-2026) kaynakta sabitti ve derlenmiş
// APK'nın içinde düz metin olarak bulunuyordu. Kodu bilen herkes sınırsız ve
// reklamsız yönetici modunu açabiliyordu. Bu testler o açığın geri gelmesini
// engeller.

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:fitcheck/services/reklam_servisi.dart';

void main() {
  group('yönetici kuponu', () {
    test('yayın sürümünde kupon hiçbir koşulda etkin değil', () {
      expect(ReklamServisi.kuponKarari(yayinModu: true, kod: 'KOD'), isFalse);
    });

    test('geliştirme sürümünde kupon yalnızca kod tanımlıysa etkin', () {
      expect(ReklamServisi.kuponKarari(yayinModu: false, kod: ''), isFalse);
      expect(ReklamServisi.kuponKarari(yayinModu: false, kod: 'KOD'), isTrue);
    });

    test('test ortamında kod tanımlı değil; kupon kapalı', () async {
      expect(ReklamServisi.adminKuponKodu, isEmpty);
      expect(ReklamServisi.kuponAktifMi, isFalse);
      expect(await ReklamServisi().kuponKoduKullan('FITCHECK-ADMIN-2026'), 0);
    });

    test('kaynakta eski sabit yönetici kodu kalmamış', () {
      final kaynak = File('lib/services/reklam_servisi.dart').readAsStringSync();
      expect(kaynak.contains('FITCHECK-ADMIN'), isFalse,
          reason: 'Yönetici kodu kaynakta sabit olmamalı.');
    });
  });

  group('yönetici modu', () {
    test('yayın sürümünde kayıtlı yönetici modu yok sayılır', () {
      expect(
        ReklamServisi.adminModuKarari(yayinModu: true, kayitliAdmin: true),
        isFalse,
      );
    });

    test('geliştirme sürümünde kayıtlı yönetici modu geçerli', () {
      expect(
        ReklamServisi.adminModuKarari(yayinModu: false, kayitliAdmin: true),
        isTrue,
      );
      expect(
        ReklamServisi.adminModuKarari(yayinModu: false, kayitliAdmin: false),
        isFalse,
      );
    });
  });
}
