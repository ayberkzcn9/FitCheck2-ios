// Bildirim metinlerinin plan ile eşleşmesi.
//
// Kritik nokta: plan kaç gün önce kaydedilmiş olursa olsun doğru güne düşmeli
// ve yanlış kombini bildirmemeli.

import 'package:fitcheck/l10n/app_localizations.dart';
import 'package:fitcheck/services/bildirim_metinleri.dart';
import 'package:flutter/widgets.dart' show Locale;
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tr = lookupAppLocalizations(const Locale('tr'));

  Map<String, dynamic> plan(List<Map<String, String?>> gunler) =>
      <String, dynamic>{'hafta': gunler};

  test('gunAdi doğru İngilizce adı verir', () {
    expect(BildirimMetinleri.gunAdi(DateTime(2026, 10, 19)), 'Monday');
    expect(BildirimMetinleri.gunAdi(DateTime(2026, 10, 20)), 'Tuesday');
    expect(BildirimMetinleri.gunAdi(DateTime(2026, 10, 25)), 'Sunday');
  });

  test('plan gün adına göre eşleşir, kayıt tarihi önemli değil', () {
    // Plan pazartesi kaydedilmiş; bugün çarşamba.
    final program = plan([
      {'gun': 'Monday', 'kombin_adi': 'Bej trençkot'},
      {'gun': 'Tuesday', 'kombin_adi': 'Yün kazak'},
      {'gun': 'Wednesday', 'kombin_adi': 'Siyah elbise'},
    ]);

    final gunler = BildirimMetinleri.gunler(
      program: program,
      simdi: DateTime(2026, 10, 21), // çarşamba
    );

    expect(gunler.first.kombinAdi, 'Siyah elbise');
    expect(gunler[1].kombinAdi, isNull);
  });

  test('Türkçe gün adları da eşleşir', () {
    final program = plan([
      {'gun': 'Pazartesi', 'kombin_adi': 'Kot ceket'},
      {'gun': 'Salı', 'kombin_adi': 'Beyaz gömlek'},
    ]);

    final gunler = BildirimMetinleri.gunler(
      program: program,
      simdi: DateTime(2026, 10, 19), // pazartesi
    );

    expect(gunler.first.kombinAdi, 'Kot ceket');
    expect(gunler[1].kombinAdi, 'Beyaz gömlek');
  });

  test('boş kombin adı ve boş plan yok sayılır', () {
    final program = plan([
      {'gun': 'Monday', 'kombin_adi': '  '},
      {'gun': 'Tuesday'},
    ]);

    final gunler = BildirimMetinleri.gunler(
      program: program,
      simdi: DateTime(2026, 10, 19),
    );

    expect(gunler.first.kombinAdi, isNull);
    expect(gunler[1].kombinAdi, isNull);
    expect(BildirimMetinleri.planDolu(gunler), isFalse);
  });

  test('plan yoksa hepsi boş döner', () {
    final gunler = BildirimMetinleri.gunler(
      program: null,
      simdi: DateTime(2026, 10, 19),
    );

    expect(gunler.length, 7);
    expect(gunler.every((gun) => gun.kombinAdi == null), isTrue);
  });

  test('sabah metni kombin varsa kişisel, yoksa genel', () {
    final kombinli = BildirimGunu(
      tarih: DateTime(2026, 10, 19),
      kombinAdi: 'Bej trençkot',
    );
    final bos = BildirimGunu(tarih: DateTime(2026, 10, 19));

    expect(
      BildirimMetinleri.sabahMetni(tr, kombinli),
      contains('Bej trençkot'),
    );
    expect(BildirimMetinleri.sabahMetni(tr, bos), tr.bildirimGunaydinIcerik);
  });

  test('akşam metni yarının kombini yoksa planlamaya çağırır', () {
    final kombinli = BildirimGunu(
      tarih: DateTime(2026, 10, 20),
      kombinAdi: 'Yün kazak',
    );
    final bos = BildirimGunu(tarih: DateTime(2026, 10, 20));

    expect(BildirimMetinleri.aksamMetni(tr, kombinli), contains('Yün kazak'));
    expect(BildirimMetinleri.aksamMetni(tr, bos), tr.bildirimPlanBos);
  });
}
