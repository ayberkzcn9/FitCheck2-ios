// "Bugün" ekranındaki akışta gösterilen kombin.
//
// Hem yapay zekâdan hem de kural bazlı üreticiden gelen kombinler aynı modele
// dönüştürülür; böylece önbellek, doğrulama ve arayüz tek bir tip üzerinden
// çalışır.
//
// Parçalar id ile tutulur, başlıkla değil: kullanıcı bir kıyafetin adını
// değiştirse bile akış bozulmaz. Silinen parçalar [parcalar] sırasında atlanır.

import '../utils/kategori_utils.dart';
import 'kiyafet.dart';

class BugunKombin {
  /// Kombinin kısa adı (ör. "Ofis için sade"). Yapay zekâ kullanıcı dilinde
  /// yazar; kural bazlı üretimde parça adlarından oluşur.
  final String baslik;

  /// Bir cümlelik gerekçe; boş olabilir.
  final String aciklama;

  /// Kombini oluşturan kıyafetlerin id'leri (gösterim sırası korunur).
  final List<String> kiyafetIdleri;

  const BugunKombin({
    required this.baslik,
    this.aciklama = '',
    required this.kiyafetIdleri,
  });

  /// Aynı gün içinde tekrar üretilmesin diye karşılaştırma anahtarı:
  /// parça kümesi sırasız olarak birleştirilir.
  String get anahtar {
    final sirali = List<String>.from(kiyafetIdleri)..sort();
    return sirali.join('|');
  }

  /// En az iki parça varsa gösterilebilir.
  bool get gecerliMi => kiyafetIdleri.length >= 2;

  /// Id'lere karşılık gelen parçalar; dolapta bulunmayanlar atlanır.
  List<Kiyafet> parcalar(Map<String, Kiyafet> indeks) => kiyafetIdleri
      .map((id) => indeks[id])
      .whereType<Kiyafet>()
      .toList(growable: false);

  /// Parçaların kategori kodları ('ust', 'alt', 'ayakkabi', 'dis').
  Set<String> kategoriKodlari(Map<String, Kiyafet> indeks) =>
      parcalar(indeks).map((k) => kategoriModeldenCikar(k.kategori)).toSet();

  Map<String, dynamic> toJson() => <String, dynamic>{
        'baslik': baslik,
        'aciklama': aciklama,
        'idler': kiyafetIdleri,
      };

  factory BugunKombin.fromJson(Map<String, dynamic> json) {
    final hamIdler = json['idler'];
    final idler = hamIdler is List
        ? hamIdler.map((e) => e.toString()).where((e) => e.isNotEmpty).toList()
        : <String>[];
    return BugunKombin(
      baslik: (json['baslik'] ?? '').toString(),
      aciklama: (json['aciklama'] ?? '').toString(),
      kiyafetIdleri: idler,
    );
  }
}
