import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:fitcheck/services/ai_service.dart';

Map<String, dynamic> _arb(String language) =>
    jsonDecode(File('lib/l10n/app_$language.arb').readAsStringSync())
        as Map<String, dynamic>;

void main() {
  test('renk keşfi hedefi kıyafetlerin algılanan rengini değiştirmez', () {
    final talimat = AiService.kombinHedefiTalimatiniGetir('renk_kesfet');
    expect(talimat, contains('Preserve every garment color exactly'));
    expect(talimat, contains('never rename or substitute a hue'));
  });

  test('az giyilen parça hedefi çamaşırdaki parçaları hariç tutar', () {
    final talimat = AiService.kombinHedefiTalimatiniGetir('unutulan_parcalar');
    expect(talimat, contains('worn least recently'));
    expect(talimat, contains('Never recommend laundry items'));
  });

  test('çok yönlü hedefi kombinlenebilir parçaları önceliklendirir', () {
    final talimat = AiService.kombinHedefiTalimatiniGetir('cok_yonlu');
    expect(talimat, contains('versatile garments'));
    expect(talimat, contains('several other wardrobe items'));
  });

  test('hedef ayarının tüm seçenekleri 12 dilde çevrilmiş', () {
    const diller = [
      'ar', 'de', 'en', 'es', 'fr', 'it', 'ja', 'ko', 'pt', 'ru', 'tr', 'zh',
    ];
    const anahtarlar = [
      'kombinHedefiBaslik',
      'kombinHedefiAciklama',
      'kombinHedefiDenge',
      'kombinHedefiRenk',
      'kombinHedefiUnutulan',
      'kombinHedefiCokYonlu',
    ];
    for (final dil in diller) {
      final arb = _arb(dil);
      for (final anahtar in anahtarlar) {
        expect(arb[anahtar], isA<String>(), reason: '$dil:$anahtar');
        expect((arb[anahtar] as String).trim(), isNotEmpty,
            reason: '$dil:$anahtar');
      }
    }
  });
}
