// FitCheck — "Kesim için zemin önemli" çekim ipuçlarını 12 dilin ARB dosyasına
// işler.
//
// Neden: kullanıcılar kıyafeti desenli/gölgeli zeminlerde çektiğinde arka plan
// silme modelleri parça bırakıyor ya da kıyafetin bir bölümünü kesiyor. Kod
// tarafında yapılabilecekler sınırlı; asıl kazanç doğru çekim alışkanlığıdır.
// İpuçları fotoğraf kaynağı seçme penceresinde gösterilir.
//
// Betik mevcut JSON biçimini koruyarak eksik anahtarları dosya sonuna ekler
// (var olanlara dokunmaz), bu yüzden istenildiği kadar çalıştırılabilir.
//
// Çalıştırma: dart run tool/cekim_ipucu_l10n_guncelle.dart
import 'dart:io';

/// Yeni anahtarların 12 dildeki karşılıkları.
const Map<String, Map<String, String>> yeniler = {
  'tr': {
    'cekimIpucuBaslik': 'Daha iyi kesim için',
    'cekimIpucu1': 'Kıyafeti düz, tek renkli bir zemine koy.',
    'cekimIpucu2': 'Zemin kıyafetten farklı bir renk olsun.',
    'cekimIpucu3': 'Gölge ve desenli zeminden kaçın.',
  },
  'en': {
    'cekimIpucuBaslik': 'For a better cutout',
    'cekimIpucu1': 'Place the garment on a flat, plain surface.',
    'cekimIpucu2': 'Use a surface colour different from the garment.',
    'cekimIpucu3': 'Avoid shadows and patterned surfaces.',
  },
  'it': {
    'cekimIpucuBaslik': 'Per un ritaglio migliore',
    'cekimIpucu1': 'Appoggia il capo su una superficie piana e tinta unita.',
    'cekimIpucu2': 'Usa un colore diverso da quello del capo.',
    'cekimIpucu3': 'Evita ombre e superfici con motivi.',
  },
  'es': {
    'cekimIpucuBaslik': 'Para un mejor recorte',
    'cekimIpucu1': 'Coloca la prenda sobre una superficie plana y lisa.',
    'cekimIpucu2': 'Usa un color distinto al de la prenda.',
    'cekimIpucu3': 'Evita sombras y superficies con dibujos.',
  },
  'zh': {
    'cekimIpucuBaslik': '让抠图更干净',
    'cekimIpucu1': '将衣物放在平整的纯色表面上。',
    'cekimIpucu2': '表面颜色要与衣物不同。',
    'cekimIpucu3': '避免阴影和带花纹的表面。',
  },
  'ar': {
    'cekimIpucuBaslik': 'لنتيجة قص أفضل',
    'cekimIpucu1': 'ضع الملابس على سطح مستوٍ بلون واحد.',
    'cekimIpucu2': 'اجعل لون السطح مختلفًا عن لون الملابس.',
    'cekimIpucu3': 'تجنّب الظلال والأسطح المنقوشة.',
  },
  'fr': {
    'cekimIpucuBaslik': 'Pour un meilleur détourage',
    'cekimIpucu1': 'Pose le vêtement sur une surface plane et unie.',
    'cekimIpucu2': 'Choisis une couleur différente de celle du vêtement.',
    'cekimIpucu3': 'Évite les ombres et les surfaces à motifs.',
  },
  'de': {
    'cekimIpucuBaslik': 'Für einen saubereren Ausschnitt',
    'cekimIpucu1': 'Lege das Kleidungsstück auf eine ebene, einfarbige Fläche.',
    'cekimIpucu2': 'Wähle eine andere Farbe als die des Kleidungsstücks.',
    'cekimIpucu3': 'Vermeide Schatten und gemusterte Flächen.',
  },
  'pt': {
    'cekimIpucuBaslik': 'Para um recorte melhor',
    'cekimIpucu1': 'Coloque a peça numa superfície plana e lisa.',
    'cekimIpucu2': 'Use uma cor diferente da peça.',
    'cekimIpucu3': 'Evite sombras e superfícies com padrão.',
  },
  'ja': {
    'cekimIpucuBaslik': 'きれいに切り抜くために',
    'cekimIpucu1': '衣類は平らな無地の面に置いてください。',
    'cekimIpucu2': '衣類と違う色の面を使ってください。',
    'cekimIpucu3': '影や柄のある面は避けてください。',
  },
  'ko': {
    'cekimIpucuBaslik': '더 깔끔한 누끼를 위해',
    'cekimIpucu1': '옷을 평평한 단색 위에 놓아 주세요.',
    'cekimIpucu2': '옷과 다른 색의 바닥을 사용해 주세요.',
    'cekimIpucu3': '그림자와 무늬 있는 바닥은 피해 주세요.',
  },
  'ru': {
    'cekimIpucuBaslik': 'Для лучшего выреза',
    'cekimIpucu1': 'Положите вещь на ровную однотонную поверхность.',
    'cekimIpucu2': 'Цвет поверхности должен отличаться от цвета вещи.',
    'cekimIpucu3': 'Избегайте теней и узорчатых поверхностей.',
  },
};

/// Dosyaya eklenme sırası (son anahtarın ardından virgül kaldırılır).
const List<String> eklemeSirasi = [
  'cekimIpucuBaslik',
  'cekimIpucu1',
  'cekimIpucu2',
  'cekimIpucu3',
];

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
    final eslesme = RegExp(r'app_([a-z]{2})\.arb$').firstMatch(dosya.path);
    final dil = eslesme!.group(1)!;
    final tablo = yeniler[dil];
    if (tablo == null) {
      stderr.writeln('Dil tablosu eksik: $dil');
      hataVar = true;
      continue;
    }

    var metin = dosya.readAsStringSync();
    final eklenecekler = <String>[];
    var zatenVar = 0;

    for (final anahtar in eklemeSirasi) {
      if (RegExp('"${RegExp.escape(anahtar)}":').hasMatch(metin)) {
        zatenVar++;
        continue;
      }
      final deger = tablo[anahtar];
      if (deger == null) {
        stderr.writeln('Metin eksik: $dil/$anahtar');
        hataVar = true;
        continue;
      }
      eklenecekler.add('  "$anahtar": "${jsonKacis(deger)}",');
    }

    if (eklenecekler.isEmpty) {
      stdout.writeln('$dil: eklenecek yeni anahtar yok ($zatenVar mevcut)');
      continue;
    }

    final kapanisIndex = metin.lastIndexOf('}');
    var govde = metin.substring(0, kapanisIndex);
    final kapanis = metin.substring(kapanisIndex);
    govde = govde.replaceAll(RegExp(r'[\s,]+$'), '');
    var blok = eklenecekler.join('\n');
    // Bloktaki son virgül kaldırılır (geçerli JSON için).
    blok = blok.replaceRange(blok.lastIndexOf(','), blok.lastIndexOf(',') + 1, '');
    metin = '$govde,\n$blok\n$kapanis';

    dosya.writeAsStringSync(metin, flush: true);
    stdout.writeln('$dil: ${eklenecekler.length} anahtar eklendi');
  }

  if (hataVar) exitCode = 1;
}
