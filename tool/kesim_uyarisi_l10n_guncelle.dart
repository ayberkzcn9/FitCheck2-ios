// FitCheck — "Kesim hatalı olabilir" (zemin kıyafete çok yakın) uyarısının
// metinlerini 12 dilin ARB dosyasına işler.
//
// Neden: arka plan silme modelleri, kıyafet ile zemin rengi birbirine çok
// yakınken sınırı bulamaz. Uyarı, kullanıcıya sonucu gördüğü anda "tekrar çek"
// seçeneği sunar. Metinler tüm dillerde olmalı.
//
// Betik mevcut JSON biçimini koruyarak eksik anahtarları dosya sonuna ekler
// (var olanlara dokunmaz), bu yüzden istenildiği kadar çalıştırılabilir.
//
// Çalıştırma: dart run tool/kesim_uyarisi_l10n_guncelle.dart
import 'dart:io';

/// Yeni anahtarların 12 dildeki karşılıkları.
const Map<String, Map<String, String>> yeniler = {
  'tr': {
    'kesimUyarisiBaslik': 'Kesim hatalı olabilir',
    'kesimUyarisiAciklama':
        'Kıyafet zemine çok yakın renkte. Arka plan silme bu durumda zorlanır: '
            'zeminden parça kalabilir ya da kıyafetin bir bölümü kesilebilir. '
            'Farklı renkte bir zeminde tekrar çekmek genellikle çözer.',
    'kesimUyarisiTekrarCek': 'Tekrar çek',
    'kesimUyarisiYineDeKaydet': 'Yine de kaydet',
  },
  'en': {
    'kesimUyarisiBaslik': 'The cutout may be inaccurate',
    'kesimUyarisiAciklama':
        'The garment colour is very close to the background. Background removal '
            'struggles here: some background may remain or part of the garment '
            'may be cut off. Retaking the photo on a surface of a different '
            'colour usually fixes it.',
    'kesimUyarisiTekrarCek': 'Retake photo',
    'kesimUyarisiYineDeKaydet': 'Save anyway',
  },
  'it': {
    'kesimUyarisiBaslik': 'Il ritaglio potrebbe non essere preciso',
    'kesimUyarisiAciklama':
        'Il colore del capo è molto vicino a quello dello sfondo. La rimozione '
            'dello sfondo fatica: può restare parte dello sfondo o tagliare una '
            'parte del capo. Rifare la foto su una superficie di colore diverso '
            'di solito risolve.',
    'kesimUyarisiTekrarCek': 'Scatta di nuovo',
    'kesimUyarisiYineDeKaydet': 'Salva comunque',
  },
  'es': {
    'kesimUyarisiBaslik': 'El recorte puede no ser preciso',
    'kesimUyarisiAciklama':
        'El color de la prenda es muy parecido al del fondo. La eliminación del '
            'fondo tiene dificultades: puede quedar parte del fondo o cortarse '
            'una parte de la prenda. Volver a hacer la foto sobre una superficie '
            'de otro color suele solucionarlo.',
    'kesimUyarisiTekrarCek': 'Volver a hacer la foto',
    'kesimUyarisiYineDeKaydet': 'Guardar igualmente',
  },
  'zh': {
    'kesimUyarisiBaslik': '抠图可能不准确',
    'kesimUyarisiAciklama':
        '衣物颜色与背景非常接近。此时去背景容易出错：可能残留背景，或把衣物的一部分切掉。'
            '换一种颜色的背景重新拍摄通常就能解决。',
    'kesimUyarisiTekrarCek': '重新拍摄',
    'kesimUyarisiYineDeKaydet': '仍然保存',
  },
  'ar': {
    'kesimUyarisiBaslik': 'قد يكون القص غير دقيق',
    'kesimUyarisiAciklama':
        'لون الملابس قريب جدًا من لون الخلفية. تواجه إزالة الخلفية صعوبة هنا: '
            'قد تبقى أجزاء من الخلفية أو يُقطع جزء من الملابس. '
            'إعادة التصوير على سطح بلون مختلف تحل المشكلة عادةً.',
    'kesimUyarisiTekrarCek': 'إعادة التصوير',
    'kesimUyarisiYineDeKaydet': 'الحفظ على أي حال',
  },
  'fr': {
    'kesimUyarisiBaslik': 'Le détourage peut être imprécis',
    'kesimUyarisiAciklama':
        'La couleur du vêtement est très proche de celle du fond. Le détourage '
            'a du mal : il peut rester des morceaux de fond ou une partie du '
            'vêtement peut être coupée. Reprendre la photo sur une surface '
            "d'une autre couleur règle généralement le problème.",
    'kesimUyarisiTekrarCek': 'Reprendre la photo',
    'kesimUyarisiYineDeKaydet': 'Enregistrer quand même',
  },
  'de': {
    'kesimUyarisiBaslik': 'Der Ausschnitt ist evtl. ungenau',
    'kesimUyarisiAciklama':
        'Die Farbe des Kleidungsstücks liegt sehr nah am Hintergrund. Die '
            'Freistellung hat damit Mühe: Es können Hintergrundreste bleiben '
            'oder ein Teil des Kleidungsstücks abgeschnitten werden. Ein neues '
            'Foto auf einer andersfarbigen Fläche löst das meist.',
    'kesimUyarisiTekrarCek': 'Neu aufnehmen',
    'kesimUyarisiYineDeKaydet': 'Trotzdem speichern',
  },
  'pt': {
    'kesimUyarisiBaslik': 'O recorte pode não estar preciso',
    'kesimUyarisiAciklama':
        'A cor da peça é muito parecida com a do fundo. A remoção do fundo tem '
            'dificuldade: pode sobrar parte do fundo ou cortar parte da peça. '
            'Tirar a foto novamente sobre uma superfície de outra cor costuma '
            'resolver.',
    'kesimUyarisiTekrarCek': 'Tirar novamente',
    'kesimUyarisiYineDeKaydet': 'Guardar mesmo assim',
  },
  'ja': {
    'kesimUyarisiBaslik': '切り抜きが正しくない可能性があります',
    'kesimUyarisiAciklama':
        '衣類の色が背景と非常に近いため、背景の削除がうまくいかないことがあります。'
            '背景が残ったり、衣類の一部が切れたりする場合があります。'
            '別の色の面で撮り直すと解決することが多いです。',
    'kesimUyarisiTekrarCek': '撮り直す',
    'kesimUyarisiYineDeKaydet': 'このまま保存',
  },
  'ko': {
    'kesimUyarisiBaslik': '누끼가 정확하지 않을 수 있습니다',
    'kesimUyarisiAciklama':
        '옷 색상이 배경과 매우 비슷합니다. 이 경우 배경 제거가 어려워 배경이 남거나 '
            '옷의 일부가 잘릴 수 있습니다. 다른 색의 바닥에서 다시 촬영하면 대부분 해결됩니다.',
    'kesimUyarisiTekrarCek': '다시 촬영',
    'kesimUyarisiYineDeKaydet': '그대로 저장',
  },
  'ru': {
    'kesimUyarisiBaslik': 'Вырез может быть неточным',
    'kesimUyarisiAciklama':
        'Цвет вещи очень близок к цвету фона. Удаление фона в таком случае '
            'затруднено: могут остаться части фона или обрежется часть вещи. '
            'Повторная съёмка на поверхности другого цвета обычно решает проблему.',
    'kesimUyarisiTekrarCek': 'Переснять',
    'kesimUyarisiYineDeKaydet': 'Всё равно сохранить',
  },
};

/// Dosyaya eklenme sırası (son anahtarın ardından virgül kaldırılır).
const List<String> eklemeSirasi = [
  'kesimUyarisiBaslik',
  'kesimUyarisiAciklama',
  'kesimUyarisiTekrarCek',
  'kesimUyarisiYineDeKaydet',
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
