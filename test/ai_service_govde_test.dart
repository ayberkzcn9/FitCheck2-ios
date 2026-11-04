// AI istek gövdelerinin testleri (ağ çağrısı YOK).
//
// Kritik davranışlar:
//  • Görseller sırayla ve doğru biçimde eklenir (Gemini inlineData / Groq image_url).
//  • Görsel yoksa istek eskisi gibi salt metin olur (mevcut davranış bozulmasın).
//  • İstek başına görsel sayısı sınırlanır (kota/maliyet koruması).
//
// Çalıştırma: flutter test test/ai_service_govde_test.dart
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';

import 'package:fitcheck/services/ai_service.dart';

void main() {
  final ai = AiService();

  final birinci = Uint8List.fromList(<int>[1, 2, 3, 4]);
  final ikinci = Uint8List.fromList(<int>[5, 6, 7, 8]);

  group('geminiGovde', () {
    test('görseller sırayla inlineData olarak eklenir', () {
      final govde = ai.geminiGovde(
        sistemPromptu: 'SISTEM',
        kullaniciMesaji: 'MESAJ',
        resimler: <Uint8List>[birinci, ikinci],
      );

      final icerik = govde['contents'] as List;
      final parts = (icerik.single as Map)['parts'] as List;

      expect(parts.length, 3); // metin + 2 görsel
      expect((parts[0] as Map)['text'], 'MESAJ');
      expect(
        ((parts[1] as Map)['inlineData'] as Map)['mimeType'],
        'image/jpeg',
      );
      expect(
        ((parts[1] as Map)['inlineData'] as Map)['data'],
        base64Encode(birinci),
      );
      expect(
        ((parts[2] as Map)['inlineData'] as Map)['data'],
        base64Encode(ikinci),
      );
      // Sistem promptu ayrı alanda kalır.
      expect(
        ((govde['systemInstruction'] as Map)['parts'] as List).single,
        <String, dynamic>{'text': 'SISTEM'},
      );
    });

    test('görsel yoksa yalnızca metin gönderilir', () {
      final govde = ai.geminiGovde(
        sistemPromptu: 'SISTEM',
        kullaniciMesaji: 'MESAJ',
      );

      final parts =
          ((govde['contents'] as List).single as Map)['parts'] as List;
      expect(parts.length, 1);
      expect((parts.single as Map)['text'], 'MESAJ');
    });
  });

  group('groqGovde', () {
    test('görsel varsa görme modeli ve data-url kullanılır', () {
      final govde = ai.groqGovde(
        sistemPromptu: 'SISTEM',
        kullaniciMesaji: 'MESAJ',
        resimler: <Uint8List>[birinci, ikinci],
      );

      expect(govde['model'], 'meta-llama/llama-4-scout-17b-16e-instruct');

      final mesajlar = govde['messages'] as List;
      final kullanici = mesajlar[1] as Map;
      final icerik = kullanici['content'] as List;

      expect(icerik.length, 3);
      expect((icerik[0] as Map)['type'], 'text');
      final url = ((icerik[1] as Map)['image_url'] as Map)['url'] as String;
      expect(url.startsWith('data:image/jpeg;base64,'), isTrue);
      expect(base64Decode(url.split(',').last), birinci);
    });

    test('görsel yoksa metin modeli ve düz metin içerik', () {
      final govde = ai.groqGovde(
        sistemPromptu: 'SISTEM',
        kullaniciMesaji: 'MESAJ',
      );

      expect(govde['model'], 'openai/gpt-oss-120b');
      final kullanici = (govde['messages'] as List)[1] as Map;
      expect(kullanici['content'], 'MESAJ');
    });

    test('boş görseller yok sayılır ve en fazla 4 görsel gönderilir', () {
      final alti = List<Uint8List>.generate(
        6,
        (i) => Uint8List.fromList(<int>[i + 1]),
      );

      final govde = ai.groqGovde(
        sistemPromptu: 'SISTEM',
        kullaniciMesaji: 'MESAJ',
        resimler: <Uint8List>[Uint8List(0), ...alti],
      );

      final icerik = ((govde['messages'] as List)[1] as Map)['content'] as List;
      expect(icerik.length, 5); // metin + 4 görsel (boş görsel atıldı)
      expect(govde['model'], 'meta-llama/llama-4-scout-17b-16e-instruct');
    });
  });
}
