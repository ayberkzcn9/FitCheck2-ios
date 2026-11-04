// Takvimde belirli bir güne atanmış kombin.
//
// Haftalık program (`haftalik_program_json`) gün adına bağlıdır ve her hafta
// tekrar eder; bu model ise **tek bir tarihe** bağlıdır. Tarihe özel plan her
// zaman haftalık programın önüne geçer.

class PlanliKombin {
  const PlanliKombin({
    required this.tarih,
    required this.baslik,
    required this.parcalar,
  });

  /// `YYYY-MM-DD` biçiminde gün anahtarı.
  final String tarih;

  final String baslik;

  /// Parçaların görünen başlıkları (favori kombinler ve geçmiş kayıtlarıyla
  /// aynı biçim). Görseller bu adlardan dolaba bakılarak bulunur.
  final List<String> parcalar;

  Map<String, dynamic> toJson() {
    return {
      'tarih': tarih,
      'baslik': baslik,
      'parcalar': parcalar,
    };
  }

  factory PlanliKombin.fromJson(Map<String, dynamic> json) {
    final hamParcalar = json['parcalar'];
    return PlanliKombin(
      tarih: (json['tarih'] ?? '').toString(),
      baslik: (json['baslik'] ?? '').toString(),
      parcalar: hamParcalar is List
          ? hamParcalar.map((e) => e.toString()).toList()
          : const <String>[],
    );
  }

  PlanliKombin kopya({String? tarih, String? baslik, List<String>? parcalar}) {
    return PlanliKombin(
      tarih: tarih ?? this.tarih,
      baslik: baslik ?? this.baslik,
      parcalar: parcalar ?? this.parcalar,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! PlanliKombin) return false;
    if (other.tarih != tarih || other.baslik != baslik) return false;
    if (other.parcalar.length != parcalar.length) return false;
    for (var i = 0; i < parcalar.length; i++) {
      if (other.parcalar[i] != parcalar[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hash(tarih, baslik, Object.hashAll(parcalar));
}
