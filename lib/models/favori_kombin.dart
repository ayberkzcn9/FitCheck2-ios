class FavoriKombin {
  final String? id;
  final String baslik;
  final List<String> parcalar;
  final String tuyo;
  final int renkUyumuPuani;

  FavoriKombin({
    this.id,
    required this.baslik,
    required this.parcalar,
    required this.tuyo,
    required this.renkUyumuPuani,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'baslik': baslik,
      'parcalar': parcalar,
      'tuyo': tuyo,
      'renkUyumuPuani': renkUyumuPuani,
    };
  }

  factory FavoriKombin.fromJson(Map<String, dynamic> json) {
    return FavoriKombin(
      id: json['id'],
      baslik: json['baslik'] ?? '',
      parcalar: json['parcalar'] != null ? List<String>.from(json['parcalar']) : [],
      tuyo: json['tuyo'] ?? '',
      renkUyumuPuani: json['renkUyumuPuani'] ?? 90,
    );
  }

  // Equality: ID varsa ID'ye gore, yoksa parcacara gore (backward compat)
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! FavoriKombin) return false;

    // Her ikisinde de ID varsa ID'ye gore karsilastir
    if (id != null && other.id != null) {
      return id == other.id;
    }

    // ID yoksa parcacara gore (eski veri icin fallback)
    if (parcalar.length != other.parcalar.length) return false;

    final sortedThis = List<String>.from(parcalar.map((e) => e.trim().toLowerCase()))..sort();
    final sortedOther = List<String>.from(other.parcalar.map((e) => e.trim().toLowerCase()))..sort();

    for (int i = 0; i < sortedThis.length; i++) {
      if (sortedThis[i] != sortedOther[i]) return false;
    }

    return true;
  }

  @override
  int get hashCode {
    // ID varsa ID'yi hash'e dahil et, yoksa parcaclari kullan
    if (id != null) {
      return id!.hashCode;
    }
    final sortedList = List<String>.from(parcalar.map((e) => e.trim().toLowerCase()))..sort();
    return sortedList.fold(0, (prev, element) => prev ^ element.hashCode);
  }
}