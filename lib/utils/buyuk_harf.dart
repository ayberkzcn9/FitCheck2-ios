/// Metni büyük harfe çevirir. Türkçede "i" büyüyünce "İ" olmalı; Dart'ın
/// [String.toUpperCase] bunu "I" yaptığı için ayrı bir kural uygulanır.
String buyukHarf(String metin, String dilKodu) {
  if (dilKodu == 'tr' || dilKodu == 'az') {
    return metin.replaceAll('i', 'İ').toUpperCase();
  }
  return metin.toUpperCase();
}
