import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

/// remove.bg API ile arkaplan silme servisi.
/// https://remove.bg/api#getting-started
/// Ücretsiz: 50 kredi/ay (1 kredi = 1 görsel)
class BackgroundRemovalService {
  static const String _endpoint = 'https://api.remove.bg/v1.0/removebg';

  String? _apiKey;

  /// Singleton instance
  static final BackgroundRemovalService _instance = BackgroundRemovalService._internal();
  factory BackgroundRemovalService() => _instance;
  BackgroundRemovalService._internal();

  /// API key'i .env'den veya parametre olarak alır.
  /// Öncelik: 1) constructor parametresi, 2) .env (REMOVE_BG_API_KEY), 3) dart-define
  void initialize({String? apiKey}) {
    _apiKey = apiKey ??
        dotenv.env['REMOVE_BG_API_KEY'] ??
        const String.fromEnvironment('REMOVE_BG_API_KEY');
    
    if (_apiKey == null || _apiKey!.isEmpty) {
      debugPrint('⚠️ BackgroundRemovalService: API key bulunamadı! .env dosyasına REMOVE_BG_API_KEY ekleyin.');
    } else {
      debugPrint('✅ BackgroundRemovalService: API key yüklendi (${_apiKey!.substring(0, 8)}...)');
    }
  }

  /// Arkaplanı siler ve şeffaf PNG olarak döner.
  /// [imageBytes] Orijinal görsel bytes (JPG, PNG, WebP)
  /// [size] 'auto' | 'preview' | 'full' | 'hd' | '4k'
  /// [format] 'png' | 'jpg' | 'zip' (png şeffaf destekler)
  /// Başarılıysa arkaplansız PNG bytes, hata olursa null döner.
  Future<Uint8List?> removeBackground({
    required Uint8List imageBytes,
    String size = 'auto',
    String format = 'png',
    String? bgColor, // opsiyonel: 'white', '#FF0000', vb.
  }) async {
    if (_apiKey == null || _apiKey!.isEmpty) {
      debugPrint('❌ BackgroundRemovalService: API key yok, arkaplan silinemiyor.');
      return null;
    }

    try {
      var request = http.MultipartRequest('POST', Uri.parse(_endpoint))
        ..headers['X-Api-Key'] = _apiKey!
        ..files.add(http.MultipartFile.fromBytes(
          'image_file',
          imageBytes,
          filename: 'clothing_${DateTime.now().millisecondsSinceEpoch}.jpg',
        ))
        ..fields['size'] = size
        ..fields['format'] = format;

      if (bgColor != null && bgColor.isNotEmpty) {
        request.fields['bg_color'] = bgColor;
      }

      debugPrint('🔄 remove.bg isteği gönderiliyor... (${imageBytes.length} bytes)');
      
      final response = await request.send().timeout(const Duration(seconds: 30));
      
      if (response.statusCode == 200) {
        final resultBytes = await response.stream.toBytes();
        debugPrint('✅ Arkaplan silindi! Sonuç: ${resultBytes.length} bytes');
        return resultBytes;
      } else {
        final errorBody = await response.stream.bytesToString();
        debugPrint('❌ remove.bg hata ${response.statusCode}: $errorBody');
        
        // Kredi biterse 402 döner
        if (response.statusCode == 402) {
          debugPrint('⚠️ remove.bg krediniz bitmiş olabilir. Dashboard kontrol edin: https://remove.bg/account');
        }
        return null;
      }
    } catch (e) {
      debugPrint('❌ BackgroundRemovalService exception: $e');
      return null;
    }
  }

  /// Kalan kredi sayısını kontrol eder (opsiyonel).
  Future<int?> getRemainingCredits() async {
    if (_apiKey == null || _apiKey!.isEmpty) return null;
    
    try {
      final response = await http.get(
        Uri.parse('https://api.remove.bg/v1.0/account'),
        headers: {'X-Api-Key': _apiKey!},
      ).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return (data['data']?['attributes']?['credits']?['total'] as num?)?.toInt();
      }
    } catch (e) {
      debugPrint('Kredi kontrolü hatası: $e');
    }
    return null;
  }

  /// API key geçerli mi test eder.
  Future<bool> testApiKey() async {
    if (_apiKey == null || _apiKey!.isEmpty) return false;
    
    try {
      final response = await http.get(
        Uri.parse('https://api.remove.bg/v1.0/account'),
        headers: {'X-Api-Key': _apiKey!},
      ).timeout(const Duration(seconds: 10));
      
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}