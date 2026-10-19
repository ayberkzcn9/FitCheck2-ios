// FitCheck — "Arka plan silinemedi" diyalog metinlerini 12 dilin ARB dosyasına
// işler.
//
// Neden betik: 12 dil x 3 metin = 36 düzenleme. Betik mevcut JSON biçimini
// koruyarak eksik anahtarları dosya sonuna ekler (var olanlara dokunmaz), bu
// yüzden istenildiği kadar çalıştırılabilir.
//
// Çalıştırma: dart run tool/arka_plan_l10n_guncelle.dart
import 'dart:io';

/// Yeni anahtarların 12 dildeki karşılıkları.
const Map<String, Map<String, String>> yeniler = {
  'tr': {
    'gardirobumArkaPlanSilinemediBaslik': 'Arka plan silinemedi',
    'gardirobumArkaPlanSilinemediAciklama':
        'Bağlantı sorunu olabilir. Tekrar denemek, fotoğrafı arka planıyla kaydetmek ya da bu fotoğrafı atlamak istediğini seç.',
    'gardirobumArkaPlanliKaydet': 'Arka planıyla kaydet',
  },
  'en': {
    'gardirobumArkaPlanSilinemediBaslik': 'Background not removed',
    'gardirobumArkaPlanSilinemediAciklama':
        'There may be a connection problem. Choose whether to try again, save the photo with its background, or skip this photo.',
    'gardirobumArkaPlanliKaydet': 'Save with background',
  },
  'it': {
    'gardirobumArkaPlanSilinemediBaslik': 'Sfondo non rimosso',
    'gardirobumArkaPlanSilinemediAciklama':
        'Potrebbe esserci un problema di connessione. Scegli se riprovare, salvare la foto con lo sfondo o saltare questa foto.',
    'gardirobumArkaPlanliKaydet': 'Salva con sfondo',
  },
  'es': {
    'gardirobumArkaPlanSilinemediBaslik': 'Fondo no eliminado',
    'gardirobumArkaPlanSilinemediAciklama':
        'Puede haber un problema de conexión. Elige si quieres intentarlo de nuevo, guardar la foto con su fondo u omitir esta foto.',
    'gardirobumArkaPlanliKaydet': 'Guardar con fondo',
  },
  'zh': {
    'gardirobumArkaPlanSilinemediBaslik': '未能移除背景',
    'gardirobumArkaPlanSilinemediAciklama':
        '可能是连接问题。你可以选择重试、保留背景保存照片，或跳过这张照片。',
    'gardirobumArkaPlanliKaydet': '保留背景保存',
  },
  'ar': {
    'gardirobumArkaPlanSilinemediBaslik': 'لم تتم إزالة الخلفية',
    'gardirobumArkaPlanSilinemediAciklama':
        'قد تكون هناك مشكلة في الاتصال. اختر إعادة المحاولة أو حفظ الصورة مع خلفيتها أو تخطي هذه الصورة.',
    'gardirobumArkaPlanliKaydet': 'حفظ مع الخلفية',
  },
  'fr': {
    'gardirobumArkaPlanSilinemediBaslik': 'Arrière-plan non supprimé',
    'gardirobumArkaPlanSilinemediAciklama':
        'Il peut s\'agir d\'un problème de connexion. Choisis de réessayer, d\'enregistrer la photo avec son arrière-plan ou d\'ignorer cette photo.',
    'gardirobumArkaPlanliKaydet': 'Enregistrer avec l\'arrière-plan',
  },
  'de': {
    'gardirobumArkaPlanSilinemediBaslik': 'Hintergrund nicht entfernt',
    'gardirobumArkaPlanSilinemediAciklama':
        'Möglicherweise liegt ein Verbindungsproblem vor. Wähle, ob du es erneut versuchen, das Foto mit Hintergrund speichern oder dieses Foto überspringen möchtest.',
    'gardirobumArkaPlanliKaydet': 'Mit Hintergrund speichern',
  },
  'pt': {
    'gardirobumArkaPlanSilinemediBaslik': 'Fundo não removido',
    'gardirobumArkaPlanSilinemediAciklama':
        'Pode haver um problema de conexão. Escolha tentar novamente, salvar a foto com o fundo ou pular esta foto.',
    'gardirobumArkaPlanliKaydet': 'Salvar com fundo',
  },
  'ja': {
    'gardirobumArkaPlanSilinemediBaslik': '背景を削除できませんでした',
    'gardirobumArkaPlanSilinemediAciklama':
        '接続に問題がある可能性があります。再試行する、背景付きで保存する、この写真をスキップする、のいずれかを選んでください。',
    'gardirobumArkaPlanliKaydet': '背景付きで保存',
  },
  'ko': {
    'gardirobumArkaPlanSilinemediBaslik': '배경을 제거하지 못했습니다',
    'gardirobumArkaPlanSilinemediAciklama':
        '연결에 문제가 있을 수 있습니다. 다시 시도하거나, 배경이 있는 그대로 저장하거나, 이 사진을 건너뛰세요.',
    'gardirobumArkaPlanliKaydet': '배경 포함 저장',
  },
  'ru': {
    'gardirobumArkaPlanSilinemediBaslik': 'Фон не удалён',
    'gardirobumArkaPlanSilinemediAciklama':
        'Возможно, проблема с подключением. Выберите: повторить попытку, сохранить фото с фоном или пропустить это фото.',
    'gardirobumArkaPlanliKaydet': 'Сохранить с фоном',
  },
};

/// Dosyaya eklenme sırası (son anahtarın ardından virgül kaldırılır).
const List<String> eklemeSirasi = [
  'gardirobumArkaPlanSilinemediBaslik',
  'gardirobumArkaPlanSilinemediAciklama',
  'gardirobumArkaPlanliKaydet',
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
