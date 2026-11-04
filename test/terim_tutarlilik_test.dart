// Hak ve kıyafet alanı terimleri her dilde tek bir söz kullanmalı.
//
// Geçmişte aynı kavram için "Hak", "İşlem hakkı", "kombin hakkı", "Slot",
// "kıyafet alanı" gibi birden çok söz kullanılıyordu; Korece ve Japonca'da da
// aynı kavram için farklı sözler karışıyordu. Bu testler karışmayı engeller.

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> _arb(String dil) =>
    jsonDecode(File('lib/l10n/app_$dil.arb').readAsStringSync())
        as Map<String, dynamic>;

void main() {
  test('Türkçe hak terimi tek: "İşlem hakkı" ve "kombin hakkı" yok', () {
    final tr = _arb('tr');
    for (final anahtar in [
      'sinirsizIslemHakkiBaslik',
      'tebriklerHakEklendi',
      'hakEklendiTebrikler',
      'kuponKoduAciklama',
      'gunlukHakAciklama',
    ]) {
      final metin = tr[anahtar] as String;
      expect(metin.contains('İşlem hakkı'), isFalse, reason: '$anahtar: $metin');
      expect(metin.contains('kombin hakkı'), isFalse, reason: '$anahtar: $metin');
    }
  });

  test('Türkçe kıyafet alanı: "Slot" kullanılmıyor', () {
    final tr = _arb('tr');
    expect((tr['reklamIzleSlotEkle'] as String).contains('Slot'), isFalse);
  });

  test('Korece hak terimi tek: "이용권" yok', () {
    final ko = _arb('ko');
    for (final anahtar in [
      'reklamIzleHakKazan',
      'tebriklerHakEklendi',
      'hakEklendiTebrikler',
      'gunlukHakAciklama',
    ]) {
      final metin = ko[anahtar] as String;
      expect(metin.contains('이용권'), isFalse, reason: '$anahtar: $metin');
    }
  });

  test('Japonca kıyafet alanı tek terim: "スロット" yerine "枠"', () {
    final ja = _arb('ja');
    expect((ja['yeniSlotEklendiTebrikler'] as String).contains('スロット'),
        isFalse);
    expect((ja['reklamIzleSlotEkle'] as String).contains('枠'), isTrue);
  });

  test('kupon ipucu hiçbir dilde gerçek görünümlü örnek kod vermiyor', () {
    for (final dil in const ['tr', 'en', 'de', 'ja', 'ko', 'zh', 'ar']) {
      final metin = _arb(dil)['kuponKoduHint'] as String;
      expect(metin.contains('VIP2026'), isFalse, reason: '$dil: $metin');
    }
  });

  test('kullanıcıya görünen hak açıklaması kupondan söz etmiyor', () {
    expect((_arb('tr')['gunlukHakAciklama'] as String).contains('kupon'),
        isFalse);
    expect((_arb('en')['gunlukHakAciklama'] as String).contains('coupon'),
        isFalse);
  });

  test('günlük hak bitti metni kupon girmeyi vaat etmiyor', () {
    const yasak = <String>[
      'kupon',
      'coupon',
      'code promo',
      'promocional',
      'gutschein',
      'промокод',
      'قسيمة',
      '兑换码',
      '쿠폰',
      'クーポン',
      'código',
    ];
    for (final dil in const [
      'ar', 'de', 'en', 'es', 'fr', 'it', 'ja', 'ko', 'pt', 'ru', 'tr', 'zh',
    ]) {
      final metin =
          (_arb(dil)['gunlukHakBittiIcerik'] as String).toLowerCase();
      for (final kelime in yasak) {
        expect(metin.contains(kelime), isFalse, reason: '$dil: $metin');
      }
    }
  });

  test('kullanım koşulları onayı her dilde tam ve yerel', () {
    const beklenen = <String, String>{
      'ar': 'قرأتُ شروط الاستخدام وأوافق عليها.',
      'de': 'Ich habe die Nutzungsbedingungen gelesen und stimme zu.',
      'en': 'I have read and agree to the Terms of Use.',
      'es': 'He leído y acepto los términos de uso.',
      'fr': 'J’ai lu et j’accepte les conditions d’utilisation.',
      'it': 'Ho letto e accetto i termini di utilizzo.',
      'ja': '利用規約を読み、同意します。',
      'ko': '이용약관을 읽고 동의합니다.',
      'pt': 'Li e concordo com os termos de uso.',
      'ru': 'Я прочитал(а) и принимаю условия использования.',
      'tr': 'Kullanım koşullarını okudum ve onaylıyorum.',
      'zh': '我已阅读并同意使用条款。',
    };

    for (final entry in beklenen.entries) {
      final arb = _arb(entry.key);
      final sablon = arb['kullanimKosullariOnayMetni'] as String;
      final kosulMetni = arb['kullanimKosullarini'] as String;

      expect(sablon.contains('{terms}'), isTrue, reason: entry.key);
      expect(
        sablon.replaceAll('{terms}', kosulMetni),
        entry.value,
        reason: '${entry.key} çevirisi eksik, bozuk veya başka dilden kalmış.',
      );
    }
  });

  test('Türkçe "kombin hakkı" ifadesi kullanılmıyor', () {
    expect(
      (_arb('tr')['gardirobumHakEklendiMesaj'] as String).contains('kombin'),
      isFalse,
    );
  });
}
