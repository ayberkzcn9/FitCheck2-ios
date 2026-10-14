import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/helpers.dart';

/// API key'ler .env dosyasından yüklenir, fallback olarak --dart-define desteklenir
String get geminiApiKey {
  final fromDotEnv = dotenv.env['GEMINI_API_KEY'];
  if (fromDotEnv != null && fromDotEnv.isNotEmpty) return fromDotEnv;
  return const String.fromEnvironment('GEMINI_API_KEY');
}
String get groqApiKey {
  final fromDotEnv = dotenv.env['GROQ_API_KEY'];
  if (fromDotEnv != null && fromDotEnv.isNotEmpty) return fromDotEnv;
  return const String.fromEnvironment('GROQ_API_KEY');
}

// Google AI Studio'da güncel ve kararlı Flash-Lite modeli.
const String _geminiModel = 'gemini-3.5-flash-lite';
const String _geminiEndpoint =
    'https://generativelanguage.googleapis.com/v1beta/models/$_geminiModel:generateContent';
const String _groqTextModel = 'openai/gpt-oss-120b';
const String _groqVisionModel = 'meta-llama/llama-4-scout-17b-16e-instruct';
const String _groqEndpoint =
    'https://api.groq.com/openai/v1/chat/completions';
const Duration _aiTimeout = Duration(seconds: 30);

class AiServiceException implements Exception {
  const AiServiceException();
}

/// Singleton AI servisi
class AiService {
  static final AiService _instance = AiService._internal();
  factory AiService() => _instance;
  AiService._internal();

  Future<String> _stilistPromptunuHazirla(String sistemPromptu) async {
    String kisilik = 'Samimi / Arkadaş Canlısı';
    String fit = 'Regular Fit';
    bool sikiRenkUyumu = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      kisilik = prefs.getString('ai_kisilik') ?? kisilik;
      fit = prefs.getString('kullanici_fit') ?? fit;
      sikiRenkUyumu = prefs.getBool('siki_renk_uyumu') ?? sikiRenkUyumu;
    } catch (_) {}

    String kisilikTalimat;
    if (kisilik == 'Profesyonel Moda Eleştirmeni') {
      kisilikTalimat =
          'Yanıt tarzın profesyonel bir moda eleştirmeni gibi olsun: net, bilgili, yapıcı ve somut öneriler ver. Eleştirirken kırıcı veya küçümseyici olma.';
    } else if (kisilik == 'Minimalist & Kısa') {
      kisilikTalimat =
          'Yanıtlarını minimalist ve kısa tut. Gereksiz giriş yapma; en önemli değerlendirmeyi ve öneriyi doğrudan söyle.';
    } else {
      kisilikTalimat =
          'Yanıt tarzın samimi ve arkadaş canlısı olsun: sıcak, cesaretlendirici ve doğal konuş. Kullanıcıyı yargılama.';
    }

    final fitTalimat = switch (fit) {
      'Slim Fit' => 'Kıyafetlerin vücuda daha oturan Slim Fit tercihine uygunluğunu değerlendir.',
      'Oversize / Relaxed' => 'Rahat ve bol Oversize / Relaxed tercihine uygunluğu değerlendir.',
      _ => 'Regular Fit tercihine uygun, dengeli kalıpları önceliklendir.',
    };
    final renkTalimat = sikiRenkUyumu
        ? 'Renk uyumunda daha seçici ol; uyumsuz ve çakışan renk kombinlerini açıkça belirt.'
        : 'Renk uyumunda esnek ol; cesur ve kontrast kombinleri de uygun olduğunda öner.';

    return '$sistemPromptu\n\nSTİLİST KİŞİLİĞİ VE YANIT TARZI:\n$kisilikTalimat\n\nKULLANICI TERCİHLERİ:\n$fitTalimat\n$renkTalimat';
  }

  dynamic _decodeJson(http.Response response) {
    return safeJsonDecode<Map<String, dynamic>>(
      utf8.decode(response.bodyBytes),
      fallback: null,
      tag: 'ai_response',
    );
  }

  String? _geminiText(dynamic data) {
    if (data is! Map) return null;
    final candidates = data['candidates'];
    if (candidates is! List || candidates.isEmpty) return null;
    final first = candidates.first;
    if (first is! Map || first['content'] is! Map) return null;
    final parts = (first['content'] as Map)['parts'];
    if (parts is! List) return null;

    final metinler = <String>[];
    for (final part in parts) {
      if (part is Map && part['text'] is String) {
        final metin = (part['text'] as String).trim();
        if (metin.isNotEmpty) metinler.add(metin);
      }
    }
    return metinler.isEmpty ? null : metinler.join('\n');
  }

  String? _groqText(dynamic data) {
    if (data is! Map || data['choices'] is! List) return null;
    final choices = data['choices'] as List;
    if (choices.isEmpty || choices.first is! Map) return null;
    final message = (choices.first as Map)['message'];
    if (message is! Map || message['content'] is! String) return null;
    final metin = (message['content'] as String).trim();
    return metin.isEmpty ? null : metin;
  }

  Future<String> _geminiIstek({
    required String sistemPromptu,
    required String kullaniciMesaji,
    Uint8List? resimBytes,
  }) async {
    if (geminiApiKey.isEmpty) throw const AiServiceException();
    final etkiliSistemPromptu = await _stilistPromptunuHazirla(sistemPromptu);

    final parts = <Map<String, dynamic>>[
      {'text': kullaniciMesaji},
    ];
    if (resimBytes != null && resimBytes.isNotEmpty) {
      parts.add({
        'inlineData': {
          'mimeType': 'image/jpeg',
          'data': base64Encode(resimBytes),
        },
      });
    }

    final response = await http
        .post(
          Uri.parse(_geminiEndpoint),
          headers: {
            'Content-Type': 'application/json',
            'x-goog-api-key': geminiApiKey,
          },
          body: jsonEncode({
            'systemInstruction': {
              'parts': [
                {'text': etkiliSistemPromptu},
              ],
            },
            'contents': [
              {'role': 'user', 'parts': parts},
            ],
            'generationConfig': {'temperature': 0.3},
          }),
        )
        .timeout(_aiTimeout);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      debugPrint(
        'Gemini API hatası: ${response.statusCode} ${utf8.decode(response.bodyBytes)}',
      );
      throw const AiServiceException();
    }
    final text = _geminiText(_decodeJson(response));
    if (text == null) throw const AiServiceException();
    return metniGuvenliYap(text);
  }

  Future<String> _groqIstek({
    required String sistemPromptu,
    required String kullaniciMesaji,
    Uint8List? resimBytes,
  }) async {
    if (groqApiKey.isEmpty) throw const AiServiceException();
    final etkiliSistemPromptu = await _stilistPromptunuHazirla(sistemPromptu);

    final userContent = <Map<String, dynamic>>[
      {'type': 'text', 'text': kullaniciMesaji},
    ];
    if (resimBytes != null && resimBytes.isNotEmpty) {
      userContent.add({
        'type': 'image_url',
        'image_url': {
          'url': 'data:image/jpeg;base64,${base64Encode(resimBytes)}',
        },
      });
    }

    final response = await http
        .post(
          Uri.parse(_groqEndpoint),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $groqApiKey',
          },
          body: jsonEncode({
            'model': resimBytes != null && resimBytes.isNotEmpty
                ? _groqVisionModel
                : _groqTextModel,
            'messages': [
              {'role': 'system', 'content': etkiliSistemPromptu},
              {
                'role': 'user',
                'content': resimBytes == null ? kullaniciMesaji : userContent,
              },
            ],
            'temperature': 0.3,
            'max_completion_tokens': 4096,
          }),
        )
        .timeout(_aiTimeout);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      debugPrint(
        'Groq API hatası: ${response.statusCode} ${utf8.decode(response.bodyBytes)}',
      );
      throw const AiServiceException();
    }
    final text = _groqText(_decodeJson(response));
    if (text == null) throw const AiServiceException();
    return metniGuvenliYap(text);
  }

  Future<String> _hibritIstek({
    required String sistemPromptu,
    required String kullaniciMesaji,
    Uint8List? resimBytes,
  }) async {
    try {
      return await _geminiIstek(
        sistemPromptu: sistemPromptu,
        kullaniciMesaji: kullaniciMesaji,
        resimBytes: resimBytes,
      );
    } catch (_) {
      try {
        return await _groqIstek(
          sistemPromptu: sistemPromptu,
          kullaniciMesaji: kullaniciMesaji,
          resimBytes: resimBytes,
        );
      } catch (_) {
        throw const AiServiceException();
      }
    }
  }

  Future<String> hibritAiSorgula({
    required String sistemPromptu,
    required String kullaniciMesaji,
    Uint8List? resimBytes,
  }) {
    return _hibritIstek(
      sistemPromptu: sistemPromptu,
      kullaniciMesaji: kullaniciMesaji,
      resimBytes: resimBytes,
    );
  }

  Future<String> sadeceMetinSorgula({
    required String sistemPromptu,
    required String kullaniciMesaji,
    String varsayilanYorum = '✨ Parçaları başarıyla değiştirdin!',
  }) {
    return _hibritIstek(
      sistemPromptu: sistemPromptu,
      kullaniciMesaji: kullaniciMesaji,
    );
  }
}