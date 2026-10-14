import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import '../l10n/app_localizations.dart';
import '../models/kiyafet.dart';

/// [jsonString] güvenli şekilde decode eder; hata olursa [fallback] döner.
/// [tag] loglama için opsiyonel etiket.
T? safeJsonDecode<T>(
  String? jsonString, {
  T? fallback,
  String? tag,
}) {
  if (jsonString == null || jsonString.trim().isEmpty) return fallback;
  try {
    return jsonDecode(jsonString) as T;
  } catch (e) {
    debugPrint('JSON decode hatası${tag != null ? " [$tag]" : ""}: $e');
    return fallback;
  }
}

/// [jsonString] güvenli şekilde `List<dynamic>` olarak decode eder.
List<dynamic> safeJsonDecodeList(String? jsonString, {String? tag}) {
  return safeJsonDecode<List<dynamic>>(jsonString, fallback: <dynamic>[], tag: tag) ?? <dynamic>[];
}

/// [jsonString] güvenli şekilde `Map<String, dynamic>` olarak decode eder.
Map<String, dynamic> safeJsonDecodeMap(String? jsonString, {String? tag}) {
  return safeJsonDecode<Map<String, dynamic>>(jsonString, fallback: <String, dynamic>{}, tag: tag) ?? <String, dynamic>{};
}

String metniGuvenliYap(String text) {
  // Markdown işaretlerini ve kontrol karakterlerini temizler.
  // ÖNEMLİ: Tüm Unicode alfabeler (Kiril, Arapça, Japonca, Korece, Çince...)
  // ve emojiler KORUNUR; yalnızca kontrol karakterleri atılır.
  return text
      .replaceAll('**', '')
      .replaceAll('__', '')
      .replaceAll('#', '')
      .replaceAll(
        // Sekme (\t=09), satır sonu (\n=0A) ve \r (0D) hariç kontrol karakterleri
        RegExp(r'[\u0000-\u0008\u000B\u000C\u000E-\u001F\u007F]'),
        '',
      )
      .trim();
}

Future<void> trendyoldaAra(String arananKelime) async {
  final encodedQuery = Uri.encodeComponent(arananKelime);
  final url = Uri.parse('https://www.trendyol.com/sr?q=$encodedQuery');
  try {
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("Trendyol açılamadı");
    }
  } catch (e) {
    debugPrint("URL açma hatası: $e");
  }
}

void gorseliBuhur(
  BuildContext context,
  Uint8List resimBytes,
  String baslik,
) {
  // 🔧 Orijinal bytes kopyalanıyor - dialog açıkken kaynak liste değişirse görüntü bozulmasın
  final bytesCopy = Uint8List.fromList(resimBytes);
  showDialog(
    context: context,
    builder: (context) {
      final colors = Theme.of(context).colorScheme;

      return Dialog(
        backgroundColor: colors.surfaceContainerHigh,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                baslik,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: colors.onSurface,
                ),
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.memory(
                  bytesCopy,
                  height: 320,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Kapat',
                  style: TextStyle(
                    color: colors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

/// Gardırop için kategori->ilk eşleşen item indeksi (performans için önbelleklenebilir)
class GardirobIndex {
  final Map<String, Kiyafet> byKategori = {};
  final Map<String, Kiyafet> byBaslik = {};
  final Map<String, Kiyafet> byRenk = {};
  final List<Kiyafet> all;

  GardirobIndex(this.all) {
    for (int i = 0; i < all.length; i++) {
      final item = all[i];
      final kat = item.kategori.toLowerCase();
      final baslik = item.baslik.toLowerCase();
      final renk = item.renk.toLowerCase();

      // İlk eşleşeni tut (sıra önemli)
      byKategori.putIfAbsent(kat, () => item);
      byBaslik.putIfAbsent(baslik, () => item);
      byRenk.putIfAbsent(renk, () => item);
    }
  }
}

/// [parcaMetni] içindeki parçaya karşılık gelen görseli bulur.
/// Performans için [index] önbelleği geçilebilir (opsiyonel).
Uint8List? parcaGorseliBul(String parcaMetni, List<Kiyafet> gardirobum, {GardirobIndex? index}) {
  final temizParca = parcaMetni.toLowerCase();
  final idx = index ?? GardirobIndex(gardirobum);

  // 1. Sıra numarası eşleşmesi: "Parça #1", "Parça #2"...
  final siraMatch = RegExp(r'par[cç]a #(\d+)').firstMatch(temizParca);
  if (siraMatch != null) {
    final siraNo = int.tryParse(siraMatch.group(1)!) ?? 0;
    if (siraNo > 0 && siraNo <= gardirobum.length) {
      return gardirobum[siraNo - 1].resimBytes;
    }
  }

  // 2. Başlık veya renk + kategori eşleşmesi (tek geçiş)
  for (final item in gardirobum) {
    final itemBaslik = item.baslik.toLowerCase();
    final itemRenk = item.renk.toLowerCase();
    final itemKategori = item.kategori.toLowerCase();

    final isimVeyaRenkUyusuyor = temizParca.contains(itemBaslik) || temizParca.contains(itemRenk);
    bool kategoriUyusuyor = temizParca.contains(itemKategori);
    
    if (!kategoriUyusuyor) {
      // Kategori anahtar kelimeleri ile genişletilmiş eşleşme
      if (itemKategori == 'ust') {
        kategoriUyusuyor = temizParca.contains('bluz') ||
            temizParca.contains('tisort') ||
            temizParca.contains('gomlek') ||
            temizParca.contains('kazak');
      } else if (itemKategori == 'alt') {
        kategoriUyusuyor = temizParca.contains('pantolon') ||
            temizParca.contains('etek') ||
            temizParca.contains('sort');
      } else if (itemKategori == 'ayakkabi') {
        kategoriUyusuyor = temizParca.contains('ayakkabi') ||
            temizParca.contains('bot') ||
            temizParca.contains('sneaker');
      }
    }

    if (isimVeyaRenkUyusuyor && kategoriUyusuyor) {
      return item.resimBytes;
    }
  }

  // 3. Fallback: kategori bazlı ilk eşleşen (önbellek kullan)
  if (temizParca.contains('bluz') || temizParca.contains('tisort') || temizParca.contains('gomlek')) {
    return idx.byKategori['ust']?.resimBytes;
  }
  if (temizParca.contains('pantolon') || temizParca.contains('etek') || temizParca.contains('sort')) {
    return idx.byKategori['alt']?.resimBytes;
  }
  if (temizParca.contains('ayakkabi') || temizParca.contains('bot') || temizParca.contains('sneaker')) {
    return idx.byKategori['ayakkabi']?.resimBytes;
  }

  return null;
}

/// Hava durumu alınamadığında ana ekranın gösterdiği yerelleştirilmiş durum
/// metinleri.
///
/// Bu metinler gerçek bir hava tahmini değildir; karşılama cümlelerinde ve
/// yapay zekâ istemlerinde hava durumu olarak kullanılmamalıdır.
List<String> havaDurumuDurumMetinleri(AppLocalizations l10n) => <String>[
      l10n.anaHavaYukleniyor,
      l10n.anaKonumKapaliBaslik,
      l10n.anaKonumIzinRedBaslik,
      l10n.anaHavaDurumuAlinamadi,
      l10n.gunlukHavaMevcutDegil,
    ];

/// [metin] gerçek bir hava tahmini mi, yoksa "konum kapalı / izin reddedildi /
/// yükleniyor" gibi bir durum mesajı mı olduğunu söyler.
///
/// Konum izni verilmediğinde, servis kapalıyken veya veri hâlâ yüklenirken
/// hava durumundan hiç söz edilmemesi için kullanılır.
bool havaDurumuKullanilabilirMi(String metin, AppLocalizations l10n) {
  final temiz = metin.trim();
  if (temiz.isEmpty) return false;
  return !havaDurumuDurumMetinleri(l10n).any((durum) => durum.trim() == temiz);
}