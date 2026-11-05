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
//    BG_REMOVE_BASE_URL=https://129-159-12-161.sslip.io
//    BG_REMOVE_API_KEY=...
//
//    HTTP adresleri bilerek kabul edilmez; kişisel fotoğraflar yalnızca
//    geçerli sertifikalı HTTPS üzerinden gönderilir.

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class BackgroundRemoverService {
  /// Varsayılan adres yalnızca HTTPS olabilir. Eski HTTP adresi bilerek
  /// kullanılmaz; kişisel fotoğraflar şifresiz taşınmamalıdır.
  static const String _fallbackBaseUrl = 'https://129-159-12-161.sslip.io';

  /// Sunucu adresi: `.env` yalnızca HTTPS ise kullanılır; değilse güvenli
  /// varsayılana düşülür.
  static String get baseUrl {
    final fromEnv = dotenv.env['BG_REMOVE_BASE_URL']?.trim();
    if (fromEnv != null && fromEnv.startsWith('https://')) return fromEnv;
    return _fallbackBaseUrl;
  }

  /// API anahtarı yalnızca ortamdan gelir; kaynakta sabit anahtar tutulmaz.
  static String get apiKey {
    final fromEnv = dotenv.env['BG_REMOVE_API_KEY']?.trim();
    if (fromEnv != null && fromEnv.isNotEmpty) return fromEnv;
    return const String.fromEnvironment('BG_REMOVE_API_KEY');
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
  /// okunmaz. Yön (EXIF) düzeltmesini sunucu yapar; istemci sunucunun PNG
  /// çıktısını gerekirse dikeyleştirir ve çevresindeki boş alanı kırpar
  /// (bkz. `GorselYonService.duzenle`).
  static Future<Uint8List?> removeBackground(Uint8List imageBytes) async {
    if (apiKey.isEmpty) {
      debugPrint(
        'Arka plan silme anahtarı yok; BG_REMOVE_API_KEY tanımlanmalı.',
      );
      return null;
    }
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

      // ⏱️ Zaman aşımı: sunucu kaliteli model (1024x1024) kullandığı için tek
      // fotoğraf ~11 sn sürer. Sunucu tek isteği aynı anda işlediğinden sırada
      // bekleyen istekler de olabilir; bu yüzden süre geniş tutulur. Süre
      // dolarsa çağıran bulut yedeğe (remove.bg) düşer.
      final streamed =
          await request.send().timeout(const Duration(seconds: 90));
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
