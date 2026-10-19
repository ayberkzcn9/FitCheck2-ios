// FitCheck — Stilist Hafızası metinlerini 12 dilin ARB dosyasına işler.
//
// Neden betik: 12 dil x 10 metin = 120 düzenleme. Betik, mevcut JSON biçimini
// koruyarak eksik anahtarları dosya sonuna ekler (var olanlara dokunmaz).
// Çalıştırma: dart run tool/hafiza_l10n_guncelle.dart
import 'dart:io';

/// Yeni anahtarların 12 dildeki karşılıkları.
const Map<String, Map<String, String>> yeniler = {
  'tr': {
    'stilistHafizasiBaslik': 'Stilist Hafızası',
    'stilistHafizasiAltBaslikNotlu': '{sayi} not hatırlıyor',
    'stilistHafizasiAltBaslikBos': 'Henüz bir şey hatırlamıyor',
    'stilistHafizasiAciklama':
        'Stilist, sohbetlerden öğrendiklerini kalıcı not olarak saklar ve önerilerini ona göre kişiselleştirir. Notlar yalnızca bu cihazda tutulur.',
    'stilistHafizasiNelerBiliyor': 'Neler hatırlıyor?',
    'stilistHafizasiOzetBaslik': 'Son konuşmaların özeti',
    'stilistHafizasiBos':
        'Henüz bir şey öğrenmedim. Sohbet ettikçe tarzını tanırım.',
    'stilistHafizasiTemizle': 'Hafızayı temizle',
    'stilistHafizasiTemizleOnay':
        'Stilistin seninle ilgili hatırladığı her şey silinecek. Bu işlem geri alınamaz.',
    'stilistHafizasiTemizlendi': 'Hafıza temizlendi 🧠',
  },
  'en': {
    'stilistHafizasiBaslik': 'Stylist Memory',
    'stilistHafizasiAltBaslikNotlu': 'Remembers {sayi} notes',
    'stilistHafizasiAltBaslikBos': 'Remembers nothing yet',
    'stilistHafizasiAciklama':
        'The stylist stores what it learns in your chats as permanent notes and personalises its suggestions. Notes stay on this device only.',
    'stilistHafizasiNelerBiliyor': 'What does it remember?',
    'stilistHafizasiOzetBaslik': 'Summary of your recent chats',
    'stilistHafizasiBos':
        'I haven\'t learned anything yet. I will get to know your style as we chat.',
    'stilistHafizasiTemizle': 'Clear memory',
    'stilistHafizasiTemizleOnay':
        'Everything the stylist remembers about you will be deleted. This cannot be undone.',
    'stilistHafizasiTemizlendi': 'Memory cleared 🧠',
  },
  'it': {
    'stilistHafizasiBaslik': 'Memoria dello stilista',
    'stilistHafizasiAltBaslikNotlu': 'Ricorda {sayi} note',
    'stilistHafizasiAltBaslikBos': 'Non ricorda ancora nulla',
    'stilistHafizasiAciklama':
        'Lo stilista salva come note permanenti ciò che impara dalle tue chat e personalizza i suggerimenti. Le note restano solo su questo dispositivo.',
    'stilistHafizasiNelerBiliyor': 'Cosa ricorda?',
    'stilistHafizasiOzetBaslik': 'Riepilogo delle tue chat recenti',
    'stilistHafizasiBos':
        'Non ho ancora imparato nulla. Conoscerò il tuo stile chiacchierando.',
    'stilistHafizasiTemizle': 'Cancella memoria',
    'stilistHafizasiTemizleOnay':
        'Tutto ciò che lo stilista ricorda di te verrà eliminato. L\'operazione non è reversibile.',
    'stilistHafizasiTemizlendi': 'Memoria cancellata 🧠',
  },
  'es': {
    'stilistHafizasiBaslik': 'Memoria del estilista',
    'stilistHafizasiAltBaslikNotlu': 'Recuerda {sayi} notas',
    'stilistHafizasiAltBaslikBos': 'Todavía no recuerda nada',
    'stilistHafizasiAciklama':
        'El estilista guarda como notas permanentes lo que aprende en tus chats y personaliza sus sugerencias. Las notas solo se guardan en este dispositivo.',
    'stilistHafizasiNelerBiliyor': '¿Qué recuerda?',
    'stilistHafizasiOzetBaslik': 'Resumen de tus chats recientes',
    'stilistHafizasiBos':
        'Todavía no he aprendido nada. Iré conociendo tu estilo mientras charlamos.',
    'stilistHafizasiTemizle': 'Borrar memoria',
    'stilistHafizasiTemizleOnay':
        'Se eliminará todo lo que el estilista recuerda sobre ti. Esta acción no se puede deshacer.',
    'stilistHafizasiTemizlendi': 'Memoria borrada 🧠',
  },
  'zh': {
    'stilistHafizasiBaslik': '造型师记忆',
    'stilistHafizasiAltBaslikNotlu': '已记住 {sayi} 条',
    'stilistHafizasiAltBaslikBos': '还没有记住任何内容',
    'stilistHafizasiAciklama':
        '造型师会把聊天中学到的内容保存为长期笔记，并据此个性化建议。笔记只保存在本机。',
    'stilistHafizasiNelerBiliyor': '记住了什么？',
    'stilistHafizasiOzetBaslik': '最近对话摘要',
    'stilistHafizasiBos': '我还没有学到任何内容。多聊几次就能了解你的风格。',
    'stilistHafizasiTemizle': '清除记忆',
    'stilistHafizasiTemizleOnay': '造型师关于你的所有记忆都将被删除，此操作无法撤销。',
    'stilistHafizasiTemizlendi': '记忆已清除 🧠',
  },
  'ar': {
    'stilistHafizasiBaslik': 'ذاكرة المصمم',
    'stilistHafizasiAltBaslikNotlu': 'يتذكر {sayi} ملاحظة',
    'stilistHafizasiAltBaslikBos': 'لا يتذكر شيئًا بعد',
    'stilistHafizasiAciklama':
        'يحفظ المصمم ما يتعلمه من محادثاتك كملاحظات دائمة ويخصص اقتراحاته بناءً عليها. تبقى الملاحظات على هذا الجهاز فقط.',
    'stilistHafizasiNelerBiliyor': 'ماذا يتذكر؟',
    'stilistHafizasiOzetBaslik': 'ملخص محادثاتك الأخيرة',
    'stilistHafizasiBos':
        'لم أتعلم شيئًا بعد. سأتعرف على أسلوبك مع كل محادثة.',
    'stilistHafizasiTemizle': 'مسح الذاكرة',
    'stilistHafizasiTemizleOnay':
        'سيتم حذف كل ما يتذكره المصمم عنك. لا يمكن التراجع عن هذا الإجراء.',
    'stilistHafizasiTemizlendi': 'تم مسح الذاكرة 🧠',
  },
  'fr': {
    'stilistHafizasiBaslik': 'Mémoire du styliste',
    'stilistHafizasiAltBaslikNotlu': 'Retient {sayi} notes',
    'stilistHafizasiAltBaslikBos': 'Ne retient rien pour l\'instant',
    'stilistHafizasiAciklama':
        'Le styliste enregistre sous forme de notes permanentes ce qu\'il apprend dans tes conversations et personnalise ses suggestions. Les notes restent uniquement sur cet appareil.',
    'stilistHafizasiNelerBiliyor': 'Que retient-il ?',
    'stilistHafizasiOzetBaslik': 'Résumé de tes conversations récentes',
    'stilistHafizasiBos':
        'Je n\'ai encore rien appris. Je découvrirai ton style au fil des conversations.',
    'stilistHafizasiTemizle': 'Effacer la mémoire',
    'stilistHafizasiTemizleOnay':
        'Tout ce que le styliste retient de toi sera supprimé. Cette action est irréversible.',
    'stilistHafizasiTemizlendi': 'Mémoire effacée 🧠',
  },
  'de': {
    'stilistHafizasiBaslik': 'Stilisten-Gedächtnis',
    'stilistHafizasiAltBaslikNotlu': 'Merkt sich {sayi} Notizen',
    'stilistHafizasiAltBaslikBos': 'Merkt sich noch nichts',
    'stilistHafizasiAciklama':
        'Der Stilist speichert, was er in deinen Chats lernt, als dauerhafte Notizen und personalisiert damit seine Vorschläge. Die Notizen bleiben nur auf diesem Gerät.',
    'stilistHafizasiNelerBiliyor': 'Was merkt er sich?',
    'stilistHafizasiOzetBaslik': 'Zusammenfassung deiner letzten Chats',
    'stilistHafizasiBos':
        'Ich habe noch nichts gelernt. Ich lerne deinen Stil mit jedem Chat besser kennen.',
    'stilistHafizasiTemizle': 'Gedächtnis löschen',
    'stilistHafizasiTemizleOnay':
        'Alles, was der Stilist über dich gespeichert hat, wird gelöscht. Das kann nicht rückgängig gemacht werden.',
    'stilistHafizasiTemizlendi': 'Gedächtnis gelöscht 🧠',
  },
  'pt': {
    'stilistHafizasiBaslik': 'Memória do stylist',
    'stilistHafizasiAltBaslikNotlu': 'Lembra de {sayi} notas',
    'stilistHafizasiAltBaslikBos': 'Ainda não lembra de nada',
    'stilistHafizasiAciklama':
        'O stylist guarda como notas permanentes o que aprende nas suas conversas e personaliza as sugestões. As notas ficam apenas neste dispositivo.',
    'stilistHafizasiNelerBiliyor': 'O que ele lembra?',
    'stilistHafizasiOzetBaslik': 'Resumo das suas conversas recentes',
    'stilistHafizasiBos':
        'Ainda não aprendi nada. Vou conhecendo seu estilo conforme conversamos.',
    'stilistHafizasiTemizle': 'Limpar memória',
    'stilistHafizasiTemizleOnay':
        'Tudo o que o stylist lembra sobre você será apagado. Isso não pode ser desfeito.',
    'stilistHafizasiTemizlendi': 'Memória limpa 🧠',
  },
  'ja': {
    'stilistHafizasiBaslik': 'スタイリストの記憶',
    'stilistHafizasiAltBaslikNotlu': '{sayi} 件のメモを記憶',
    'stilistHafizasiAltBaslikBos': 'まだ何も覚えていません',
    'stilistHafizasiAciklama':
        'スタイリストはチャットから学んだ内容を長期メモとして保存し、提案をパーソナライズします。メモはこの端末にのみ保存されます。',
    'stilistHafizasiNelerBiliyor': '何を覚えている？',
    'stilistHafizasiOzetBaslik': '最近の会話の要約',
    'stilistHafizasiBos': 'まだ何も学んでいません。会話するほどあなたのスタイルを理解します。',
    'stilistHafizasiTemizle': '記憶を消去',
    'stilistHafizasiTemizleOnay': 'スタイリストがあなたについて記憶した内容はすべて削除されます。元に戻せません。',
    'stilistHafizasiTemizlendi': '記憶を消去しました 🧠',
  },
  'ko': {
    'stilistHafizasiBaslik': '스타일리스트 기억',
    'stilistHafizasiAltBaslikNotlu': '메모 {sayi}개 기억 중',
    'stilistHafizasiAltBaslikBos': '아직 기억하는 내용이 없어요',
    'stilistHafizasiAciklama':
        '스타일리스트는 대화에서 배운 내용을 장기 메모로 저장하고 이를 바탕으로 제안을 개인화합니다. 메모는 이 기기에만 저장됩니다.',
    'stilistHafizasiNelerBiliyor': '무엇을 기억하나요?',
    'stilistHafizasiOzetBaslik': '최근 대화 요약',
    'stilistHafizasiBos': '아직 배운 내용이 없어요. 대화할수록 스타일을 알아갑니다.',
    'stilistHafizasiTemizle': '기억 삭제',
    'stilistHafizasiTemizleOnay': '스타일리스트가 당신에 대해 기억한 모든 내용이 삭제됩니다. 되돌릴 수 없습니다.',
    'stilistHafizasiTemizlendi': '기억이 삭제되었습니다 🧠',
  },
  'ru': {
    'stilistHafizasiBaslik': 'Память стилиста',
    'stilistHafizasiAltBaslikNotlu': 'Помнит {sayi} заметок',
    'stilistHafizasiAltBaslikBos': 'Пока ничего не помнит',
    'stilistHafizasiAciklama':
        'Стилист сохраняет то, что узнаёт из ваших чатов, как постоянные заметки и персонализирует советы. Заметки хранятся только на этом устройстве.',
    'stilistHafizasiNelerBiliyor': 'Что он помнит?',
    'stilistHafizasiOzetBaslik': 'Сводка последних чатов',
    'stilistHafizasiBos':
        'Я пока ничего не узнал. Чем больше мы общаемся, тем лучше я знаю ваш стиль.',
    'stilistHafizasiTemizle': 'Очистить память',
    'stilistHafizasiTemizleOnay':
        'Всё, что стилист помнит о вас, будет удалено. Это действие нельзя отменить.',
    'stilistHafizasiTemizlendi': 'Память очищена 🧠',
  },
};

/// Dosyaya eklenme sırası (son anahtarın ardından virgül kaldırılır).
const List<String> eklemeSirasi = [
  'stilistHafizasiBaslik',
  'stilistHafizasiAltBaslikNotlu',
  'stilistHafizasiAltBaslikBos',
  'stilistHafizasiAciklama',
  'stilistHafizasiNelerBiliyor',
  'stilistHafizasiOzetBaslik',
  'stilistHafizasiBos',
  'stilistHafizasiTemizle',
  'stilistHafizasiTemizleOnay',
  'stilistHafizasiTemizlendi',
];

/// Yer tutucu (placeholder) bilgisi şablonda (tr) yazılır.
const String yerTutuculuAnahtar = 'stilistHafizasiAltBaslikNotlu';
const String yerTutucuAdi = 'sayi';

String jsonKacis(String s) => s.replaceAll('\\', r'\\').replaceAll('"', r'\"');

String yerTutucuBlogu(String anahtar) => '  "@$anahtar": {\n'
    '    "placeholders": {\n'
    '      "$yerTutucuAdi": {\n'
    '        "type": "int"\n'
    '      }\n'
    '    }\n'
    '  },';

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
      if (anahtar == yerTutuculuAnahtar && dil == 'tr') {
        eklenecekler.add(yerTutucuBlogu(anahtar));
      }
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
    stdout.writeln(
        '$dil: ${eklenecekler.where((l) => l.trimLeft().startsWith('"')).length} anahtar eklendi');
  }

  if (hataVar) exitCode = 1;
}
