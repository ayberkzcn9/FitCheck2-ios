// Takvim gün adı yardımcıları.
//
// Haftalık plan gün adlarıyla saklanıyor (`Monday`, `Tuesday`...), bazı eski
// kayıtlarda ise yerelleştirilmiş adlar var (`Pazartesi`, `Montag`...).
// Bildirimler ve kombin takvimi aynı eşlemeyi kullansın diye tek yerde.

const List<String> ingilizceGunAdlari = <String>[
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];

/// Verilen tarihin planlayıcıdaki İngilizce gün adı.
String ingilizceGunAdi(DateTime tarih) =>
    ingilizceGunAdlari[tarih.weekday - 1];

const Map<String, List<String>> _gunEslestirmeleri = <String, List<String>>{
  'Monday': [
    'monday',
    'mon',
    'pazartesi',
    'pzt',
    'montag',
    'mo',
    'lundi',
    'lunedi',
    'lunes',
  ],
  'Tuesday': [
    'tuesday',
    'tue',
    'salı',
    'sali',
    'sal',
    'dienstag',
    'di',
    'mardi',
    'martedi',
    'martes',
  ],
  'Wednesday': [
    'wednesday',
    'wed',
    'çarşamba',
    'carsamba',
    'çar',
    'car',
    'mittwoch',
    'mi',
    'mercredi',
    'mercoledi',
    'miercoles',
  ],
  'Thursday': [
    'thursday',
    'thu',
    'perşembe',
    'persembe',
    'per',
    'donnerstag',
    'do',
    'jeudi',
    'giovedi',
    'jueves',
  ],
  'Friday': [
    'friday',
    'fri',
    'cuma',
    'cum',
    'freitag',
    'fr',
    'vendredi',
    'venerdi',
    'viernes',
  ],
  'Saturday': [
    'saturday',
    'sat',
    'cumartesi',
    'cmt',
    'samstag',
    'sa',
    'samedi',
    'sabato',
    'sabado',
  ],
  'Sunday': [
    'sunday',
    'sun',
    'pazar',
    'paz',
    'sonntag',
    'so',
    'dimanche',
    'domenica',
    'domingo',
  ],
};

/// `pazartesi`, `Monday`, `Mon`, `Montag` → `Monday`. Tanınmazsa null.
String? kanonikGunAdi(Object? ham) {
  final metin = ham?.toString().toLowerCase().trim() ?? '';
  if (metin.isEmpty) return null;

  for (final giris in _gunEslestirmeleri.entries) {
    if (giris.value.contains(metin)) return giris.key;
  }
  // "Pazartesi 12 Ekim" gibi ek metin varsa baştan eşle.
  for (final giris in _gunEslestirmeleri.entries) {
    for (final ad in giris.value) {
      if (metin.startsWith(ad)) return giris.key;
    }
  }
  return null;
}

/// `YYYY-MM-DD` (geçmiş kombin kayıtlarındaki `tarih` alanı).
String gunAnahtari(DateTime tarih) {
  final ay = tarih.month.toString().padLeft(2, '0');
  final gun = tarih.day.toString().padLeft(2, '0');
  return '${tarih.year}-$ay-$gun';
}
