// Kombin takvimi: ay ızgarası, plan ve geçmiş eşlemesi.

import 'package:fitcheck/services/kombin_takvimi.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final simdi = DateTime(2026, 10, 20, 9); // salı

  List<Map<String, String>> gecmis(List<(String, String)> kayitlar) {
    return [
      for (final kayit in kayitlar)
        {'tarih': kayit.$1, 'baslik': kayit.$2, 'detay': ''},
    ];
  }

  test('ay, pazartesi başlangıçlı ve doğru uzunlukta', () {
    // 1 Ekim 2026 perşembe → başta 3 boşluk, 31 gün.
    final gunler = KombinTakvimi.ay(
      ay: DateTime(2026, 10, 15),
      gecmis: const [],
      program: null,
      simdi: simdi,
    );

    expect(gunler.where((g) => g == null).length, 3);
    expect(gunler.whereType<TakvimGunu>().length, 31);
    expect(gunler.whereType<TakvimGunu>().first.tarih.day, 1);
    expect(gunler.whereType<TakvimGunu>().last.tarih.day, 31);
  });

  test('geçmiş kayıtları güne yazılır', () {
    final gunler = KombinTakvimi.ay(
      ay: DateTime(2026, 10),
      gecmis: gecmis([
        ('2026-10-18', 'Pazar kombini'),
        ('2026-10-20', 'Ofis kombini'),
      ]),
      program: null,
      simdi: simdi,
    );

    final onsekiz = gunler.whereType<TakvimGunu>().firstWhere(
          (g) => g.tarih.day == 18,
        );
    expect(onsekiz.giyilen, ['Pazar kombini']);
    expect(onsekiz.giyildi, isTrue);

    final ondokuz = gunler.whereType<TakvimGunu>().firstWhere(
          (g) => g.tarih.day == 19,
        );
    expect(ondokuz.bos, isTrue);
  });

  test('plan yalnızca önümüzdeki 7 güne yansır', () {
    final program = <String, dynamic>{
      'hafta': [
        {'gun': 'Tuesday', 'kombin_adi': 'Salı kombini'},
        {'gun': 'Thursday', 'kombin_adi': 'Perşembe kombini'},
      ],
    };

    final gunler = KombinTakvimi.ay(
      ay: DateTime(2026, 10),
      gecmis: const [],
      program: program,
      simdi: simdi,
    );

    TakvimGunu gun(int no) =>
        gunler.whereType<TakvimGunu>().firstWhere((g) => g.tarih.day == no);

    expect(gun(20).planlanan, ['Salı kombini']);
    expect(gun(22).planlanan, ['Perşembe kombini']);
    // Geçmiş güne plan yazılmaz; 27 Ekim pencerenin dışında.
    expect(gun(13).planlanan, isEmpty);
    expect(gun(27).planlanan, isEmpty);
  });

  test('aynı gün iki kombin iki satır olur', () {
    final gunler = KombinTakvimi.ay(
      ay: DateTime(2026, 10),
      gecmis: gecmis([
        ('2026-10-20', 'Sabah kombini'),
        ('2026-10-20', 'Akşam kombini'),
      ]),
      program: null,
      simdi: simdi,
    );

    final bugun = gunler
        .whereType<TakvimGunu>()
        .firstWhere((g) => g.tarih.day == 20);
    expect(bugun.giyilen, ['Sabah kombini', 'Akşam kombini']);
  });
}
