// FitCheck — Gardırop görsel döndürme metnini 12 dilin ARB dosyasına işler.
//
// Çalıştırma: dart run tool/kiyafet_l10n_guncelle.dart
// Betik idempotenttir: anahtar zaten varsa dokunmaz.
import 'dart:io';

/// Yeni anahtar: dil -> "Döndür" karşılığı.
const Map<String, String> dondur = {
  'tr': 'Döndür',
  'en': 'Rotate',
  'it': 'Ruota',
  'es': 'Girar',
  'fr': 'Pivoter',
  'de': 'Drehen',
  'pt': 'Rodar',
  'ru': 'Повернуть',
  'ar': 'تدوير',
  'zh': '旋转',
  'ja': '回転',
  'ko': '회전',
};

const String anahtar = 'kiyafetDondur';

String jsonKacis(String s) => s.replaceAll('\\', r'\\').replaceAll('"', r'\"');

void main() {
  final dosyalar = Directory('lib/l10n')
      .listSync()
      .whereType<File>()
      .where((f) => RegExp(r'app_[a-z]{2}\.arb$').hasMatch(f.path))
      .toList()
    ..sort((a, b) => a.path.compareTo(b.path));

  var hataVar = false;

  for (final dosya in dosyalar) {
    final dil = RegExp(r'app_([a-z]{2})\.arb$').firstMatch(dosya.path)!.group(1)!;
    final deger = dondur[dil];
    if (deger == null) {
      stderr.writeln('Çeviri eksik: $dil');
      hataVar = true;
      continue;
    }

    var metin = dosya.readAsStringSync();

    if (RegExp('"${RegExp.escape(anahtar)}":').hasMatch(metin)) {
      stdout.writeln('$dil: zaten var, atlandı');
      continue;
    }

    final kapanisIndex = metin.lastIndexOf('}');
    var govde = metin.substring(0, kapanisIndex);
    final kapanis = metin.substring(kapanisIndex);
    govde = govde.replaceAll(RegExp(r'[\s,]+$'), '');
    metin = '$govde,\n  "$anahtar": "${jsonKacis(deger)}"\n$kapanis';

    dosya.writeAsStringSync(metin, flush: true);
    stdout.writeln('$dil: eklendi -> $deger');
  }

  if (hataVar) exitCode = 1;
}
