import 'dart:convert';
import 'dart:typed_data';

class Kiyafet {
  final String id;
  String baslik; // AI'ın verdiği isim (Düzenlenebilir)
  String? kullaniciBasligi; // Kullanıcının değiştirdiği özel isim
  String kategori; // 🚀 'final' KALDIRILDI! Artık kategoriyi değiştirebiliriz.
  Uint8List resimBytes; // 🔄 "Döndür" ile güncellenebildiği için final değil.
  String renk;
  final String stil;

  /// Kıyafetin hangi mevsimde giyilebileceği: 'kislik', 'yazlik' veya
  /// 'dort_mevsim'. Bilinmiyorsa null'dır ve ürün adından tahmin edilir
  /// (bkz. `utils/hava_uygunlugu.dart`).
  String? mevsim;
  bool sepetteMi;
  int giyilmeSayisi;
  DateTime? sonGiyilmeTarihi;
  final DateTime eklenmeTarihi;
  final double fiyat;

  Kiyafet({
    required this.id,
    required this.baslik,
    this.kullaniciBasligi,
    required this.kategori,
    required this.resimBytes,
    required this.renk,
    required this.stil,
    this.mevsim,
    this.sepetteMi = false,
    this.giyilmeSayisi = 0,
    this.sonGiyilmeTarihi,
    DateTime? eklenmeTarihi,
    this.fiyat = 0.0,
  }) : eklenmeTarihi = eklenmeTarihi ?? DateTime.now();

  /// 🏷️ Ekranda gösterilecek isim
  String get gorunenBaslik =>
      (kullaniciBasligi != null && kullaniciBasligi!.trim().isNotEmpty)
          ? kullaniciBasligi!
          : baslik;

  /// Giyim başına maliyeti hesaplar
  double get giyimBasinaMaliyet {
    if (giyilmeSayisi == 0) return fiyat;
    return fiyat / giyilmeSayisi;
  }

  /// 🧺 Kıyafeti "Bugün Giydim" olarak işaretler
  void giyildiOlarakIsaretle() {
    giyilmeSayisi += 1;
    sonGiyilmeTarihi = DateTime.now();
    sepetteMi = true;
  }

  /// ✨ Çamaşır yıkandığında kıyafeti tekrar Temiz/Dolapta yapar
  void yikandiOlarakIsaretle() {
    sepetteMi = false;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'baslik': baslik,
      'kullaniciBasligi': kullaniciBasligi,
      'kategori': kategori,
      'resimBytes': base64Encode(resimBytes),
      'renk': renk,
      'stil': stil,
      'mevsim': mevsim,
      'sepetteMi': sepetteMi,
      'giyilmeSayisi': giyilmeSayisi,
      'sonGiyilmeTarihi': sonGiyilmeTarihi?.toIso8601String(),
      'eklenmeTarihi': eklenmeTarihi.toIso8601String(),
      'fiyat': fiyat,
    };
  }

  factory Kiyafet.fromJson(Map<String, dynamic> json) {
    return Kiyafet(
      id: json['id'],
      baslik: json['baslik'],
      kullaniciBasligi: json['kullaniciBasligi'],
      kategori: json['kategori'],
      resimBytes: base64Decode(json['resimBytes']),
      renk: json['renk'],
      stil: json['stil'],
      mevsim: json['mevsim'],
      sepetteMi: json['sepetteMi'] ?? false,
      giyilmeSayisi: json['giyilmeSayisi'] ?? 0,
      sonGiyilmeTarihi: json['sonGiyilmeTarihi'] != null
          ? DateTime.parse(json['sonGiyilmeTarihi'])
          : null,
      eklenmeTarihi: DateTime.parse(json['eklenmeTarihi']),
      fiyat: (json['fiyat'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
