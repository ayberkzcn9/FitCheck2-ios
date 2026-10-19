// Yaşayan stilist hafızasının (kalıcı notlar + özet) davranışını doğrular.
//
// Kritik davranışlar:
//  • AI cevabı ```json çitli ya da etrafında metin varken de ayıklanır.
//  • Aynı not defalarca eklenmez; sınır aşılırsa en eski not düşer.
//  • Not/özet uzunluk sınırları aşılmaz (prompt şişmesin).
//  • Hafıza kapalıyken prompta eklenmez ve bozuk kayıt uygulamayı çökertmez.
//  • Kaydedilen hafıza diskten geri okunur.
//
// Çalıştırma: flutter test test/stilist_hafizasi_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fitcheck/services/stilist_hafizasi.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final hafiza = StilistHafizasi();

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    await hafiza.acikAyarla(true);
    await hafiza.temizle();
  });

  group('jsonCikar', () {
    test('düz JSON', () {
      final veri = hafiza.jsonCikar('{"notlar":["a"],"ozet":"b"}');
      expect(veri['notlar'], ['a']);
      expect(veri['ozet'], 'b');
    });

    test('```json çitleri ve fazladan metin', () {
      const cevap = 'Elbette! İşte JSON:\n'
          '```json\n'
          '{"notlar": ["Prefers oversize tops"], "ozet": "Office looks"}\n'
          '```\n'
          'Umarım yardımcı olur.';
      final veri = hafiza.jsonCikar(cevap);
      expect(veri['notlar'], ['Prefers oversize tops']);
      expect(veri['ozet'], 'Office looks');
    });

    test('boş/bozuk cevap boş map döner', () {
      expect(hafiza.jsonCikar(''), isEmpty);
      expect(hafiza.jsonCikar('merhaba'), isEmpty);
      expect(hafiza.jsonCikar('{"notlar": [,]}'), isEmpty);
    });
  });

  group('ogrenmeyiUygula', () {
    test('notları ve özeti işler, değişimi bildirir', () {
      final degisti = hafiza.ogrenmeyiUygula(<String, dynamic>{
        'notlar': ['Prefers oversize tops', '  - Avoids tight trousers  '],
        'ozet': 'Office looks were discussed.',
      });

      expect(degisti, isTrue);
      expect(
        hafiza.notlar,
        ['Prefers oversize tops', 'Avoids tight trousers'],
      );
      expect(hafiza.ozet, contains('Office looks'));
      expect(hafiza.guncellenme, isNotNull);
    });

    test('aynı not tekrar eklenmez (büyük/küçük harf ve fazla boşluk)', () {
      hafiza.ogrenmeyiUygula(<String, dynamic>{
        'notlar': ['Prefers oversize tops'],
      });
      hafiza.ogrenmeyiUygula(<String, dynamic>{
        'notlar': ['  prefers   OVERSIZE  tops!  '],
      });

      expect(hafiza.notlar.length, 1);
    });

    test('biri diğerini içeren uzun not tekrar eklenmez', () {
      hafiza.ogrenmeyiUygula(<String, dynamic>{
        'notlar': ['Prefers oversize tops'],
      });
      hafiza.ogrenmeyiUygula(<String, dynamic>{
        'notlar': ['Prefers oversize tops and muted colours'],
      });

      expect(hafiza.notlar.length, 1);
    });

    test('kısa benzer notlar yanlışlıkla birleştirilmez', () {
      hafiza.ogrenmeyiUygula(<String, dynamic>{
        'notlar': ['note 1'],
      });
      hafiza.ogrenmeyiUygula(<String, dynamic>{
        'notlar': ['note 10'],
      });

      expect(hafiza.notlar, ['note 1', 'note 10']);
    });

    test('not sınırı aşılmaz, en eski not düşer', () {
      for (var i = 0; i < StilistHafizasi.enFazlaNot + 5; i++) {
        hafiza.ogrenmeyiUygula(<String, dynamic>{
          'notlar': ['not $i about office'],
        });
      }

      expect(hafiza.notlar.length, StilistHafizasi.enFazlaNot);
      expect(hafiza.notlar.first, 'not 5 about office');
      expect(
        hafiza.notlar.last,
        'not ${StilistHafizasi.enFazlaNot + 4} about office',
      );
    });

    test('uzun not ve özet kısaltılır', () {
      hafiza.ogrenmeyiUygula(<String, dynamic>{
        'notlar': ['x' * (StilistHafizasi.enFazlaNotUzunlugu + 50)],
        'ozet': 'y' * (StilistHafizasi.enFazlaOzetUzunlugu + 200),
      });

      expect(hafiza.notlar.single.length, StilistHafizasi.enFazlaNotUzunlugu);
      expect(hafiza.ozet.length, StilistHafizasi.enFazlaOzetUzunlugu);
    });

    test('öğrenilecek bir şey yoksa değişiklik bildirilmez', () {
      final degisti = hafiza.ogrenmeyiUygula(<String, dynamic>{
        'notlar': <String>[],
        'ozet': '',
      });

      expect(degisti, isFalse);
      expect(hafiza.bosMu, isTrue);
      expect(hafiza.guncellenme, isNull);
    });
  });

  group('promptBlogu', () {
    test('boş hafızada boş döner', () {
      expect(hafiza.promptBlogu(), '');
    });

    test('notları ve özeti içerir', () {
      hafiza.ogrenmeyiUygula(<String, dynamic>{
        'notlar': ['Prefers oversize tops'],
        'ozet': 'Office looks were discussed.',
      });

      final blok = hafiza.promptBlogu();
      expect(blok, contains('[LONG-TERM MEMORY ABOUT THIS USER]'));
      expect(blok, contains('Prefers oversize tops'));
      expect(blok, contains('Office looks were discussed.'));
      expect(blok, contains('[RECENT CHAT CONTEXT]'));
    });

    test('hafıza kapalıyken boş döner', () async {
      hafiza.ogrenmeyiUygula(<String, dynamic>{
        'notlar': ['Prefers oversize tops'],
      });
      await hafiza.acikAyarla(false);

      expect(hafiza.promptBlogu(), '');
      expect(hafiza.notlar, isNotEmpty, reason: 'Notlar silinmez, sadece kullanılmaz.');
    });
  });

  group('kalıcılık', () {
    test('diskteki hafıza okunur', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{
        StilistHafizasi.anahtar: '{"surum":1,"acik":true,'
            '"notlar":["Likes earth tones"],"ozet":"Recent chats","sohbet_sayisi":3}',
      });

      await hafiza.yukle(zorla: true);

      expect(hafiza.notlar, ['Likes earth tones']);
      expect(hafiza.ozet, 'Recent chats');
      expect(hafiza.sohbetSayisi, 3);
    });

    test('bozuk kayıt çökertmez, hafıza boş kalır', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{
        StilistHafizasi.anahtar: '{bozuk json',
      });

      await hafiza.yukle(zorla: true);

      expect(hafiza.bosMu, isTrue);
      expect(hafiza.promptBlogu(), '');
    });

    test('kaydetme diske yazar', () async {
      hafiza.ogrenmeyiUygula(<String, dynamic>{
        'notlar': ['Likes earth tones'],
      });
      await hafiza.kaydet();

      final prefs = await SharedPreferences.getInstance();
      final ham = prefs.getString(StilistHafizasi.anahtar);

      expect(ham, isNotNull);
      expect(ham, contains('Likes earth tones'));
    });

    test('temizle hem belleği hem diski boşaltır', () async {
      hafiza.ogrenmeyiUygula(<String, dynamic>{
        'notlar': ['Likes earth tones'],
        'ozet': 'Recent chats',
      });
      await hafiza.temizle();

      final prefs = await SharedPreferences.getInstance();
      expect(hafiza.bosMu, isTrue);
      expect(prefs.getString(StilistHafizasi.anahtar), isNot(contains('earth tones')));

      await hafiza.yukle(zorla: true);
      expect(hafiza.bosMu, isTrue);
    });

    test('kayıt yoksa bellek boşaltılır (silinen hafıza geri gelmez)', () async {
      hafiza.ogrenmeyiUygula(<String, dynamic>{
        'notlar': ['Likes earth tones'],
      });
      expect(hafiza.bosMu, isFalse);

      SharedPreferences.setMockInitialValues(<String, Object>{});
      await hafiza.yukle(zorla: true);

      expect(hafiza.bosMu, isTrue);
    });
  });
}
