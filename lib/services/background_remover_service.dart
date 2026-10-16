// Yerel sunucu (rembg / Python) tabanlı arka plan silme servisi.
//
// Bu servis, bilgisayarınızda çalışan bir HTTP sunucusuna (ör. FastAPI + rembg)
// görsel gönderip arka planı silinmiş PNG alır. remove.bg bulut API'sine
// alternatif, tamamen yerel bir çözümdür.
//
// 🔐 Kimlik doğrulama: Sunucu, isteklerde `X-API-Key` header'ı bekler. Key
//    `.env` dosyasındaki `BG_REMOVE_API_KEY` değerinden okunur; yoksa
//    [_fallbackApiKey] kullanılır.
//
// ⚙️ Ayarlar `.env` dosyasından okunur:
//    BG_REMOVE_BASE_URL=http://192.168.1.XX:8000
//    BG_REMOVE_API_KEY=...
//
//    - Android Emülatör : http://10.0.2.2:8000
//    - Gerçek cihaz     : http://192.168.1.XX:8000 (telefon ve PC aynı WiFi'de)

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class BackgroundRemoverService {
  /// 🔧 Fallback adres. `.env`'de `BG_REMOVE_BASE_URL` varsa o kullanılır.
  /// Oracle Cloud sunucusu (genel IP, her yerden erişilebilir).
  static const String _fallbackBaseUrl = 'http://129.159.12.161:8000';

  /// 🔧 Fallback API key. `.env`'de `BG_REMOVE_API_KEY` varsa o kullanılır.
  static const String _fallbackApiKey = 'uIplFP4EIh0-9ARqmOnNc-S4g8AgOKYi-tEBZcmJ_qA';

  /// Sunucu adresi (önce `.env`, yoksa fallback).
  static String get baseUrl {
    final fromEnv = dotenv.env['BG_REMOVE_BASE_URL']?.trim();
    return (fromEnv != null && fromEnv.isNotEmpty) ? fromEnv : _fallbackBaseUrl;
  }

  /// Sunucu API anahtarı (önce `.env`, yoksa fallback).
  static String get apiKey {
    final fromEnv = dotenv.env['BG_REMOVE_API_KEY']?.trim();
    return (fromEnv != null && fromEnv.isNotEmpty)
        ? fromEnv
        : _fallbackApiKey;
  }

  /// Sunucu ayakta mı? (GET /health) — teşhis için.
  static Future<bool> sunucuSaglikliMi() async {
    try {
      final res = await http
          .get(Uri.parse('$baseUrl/health'))
          .timeout(const Duration(seconds: 5));
      return res.statusCode == 200;
    } catch (e) {
      debugPrint('Sunucu sağlık kontrolü başarısız: $e');
      return false;
    }
  }

  /// Görseli yerel sunucuya gönderip arka planı silinmiş baytları döndürür.
  /// Hata durumunda `null` döner.
  ///
  /// Bayt alır: fotoğraf zaten bellekte olduğu için dosyadan yeniden
  /// okunmaz. Yön (EXIF) düzeltmesini sunucu yapar; istemci yalnızca
  /// sunucunun PNG çıktısını gerekirse dikeyleştirir
  /// (bkz. `GorselYonService.dikeylestir`).
  static Future<Uint8List?> removeBackground(Uint8List imageBytes) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/remove-bg'),
      );

      // 🔐 Kimlik doğrulama header'ı
      request.headers['X-API-Key'] = apiKey;

      request.files.add(
        http.MultipartFile.fromBytes('file', imageBytes, filename: 'kiyafet'),
      );

      final streamed = await request
          .send()
          .timeout(const Duration(seconds: 60));
      final response = await http.Response.fromStream(streamed);

      if (response.statusCode == 200) return response.bodyBytes;

      if (response.statusCode == 401 || response.statusCode == 403) {
        debugPrint('Arka plan silme: API key geçersiz/yetkisiz '
            '(${response.statusCode})');
      } else {
        debugPrint('Arka plan silme sunucu hatası: ${response.statusCode}');
      }
      return null;
    } catch (e) {
      debugPrint('BG Remove Error: $e');
      return null;
    }
  }

  /// Sonucu geçici dizine kaydeder ve dosyayı döndürür.
  static Future<File> saveResult(Uint8List bytes) async {
    final dir = await getTemporaryDirectory();
    final file = File(
      '${dir.path}/nobg_${DateTime.now().millisecondsSinceEpoch}.png',
    );
    await file.writeAsBytes(bytes);
    return file;
  }
}