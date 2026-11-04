// Stil Günlüğü ve Seyahat Modu ekranlarının arayüz testleri.

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fitcheck/l10n/app_localizations.dart';
import 'package:fitcheck/models/kiyafet.dart';
import 'package:fitcheck/screens/seyahat_ekrani.dart';
import 'package:fitcheck/screens/stil_gunlugu_ekrani.dart';

final Uint8List _png = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8B'
  'QDwAEhQGAhKmMIQAAAABJRU5ErkJggg==',
);

Kiyafet _kiyafet(String id, String kategori, {bool sepette = false}) {
  return Kiyafet(
    id: id,
    baslik: id,
    kategori: kategori,
    resimBytes: _png,
    renk: 'Siyah',
    stil: 'Regular',
    sepetteMi: sepette,
    eklenmeTarihi: DateTime(2026, 1, 1),
  );
}

void main() {
  final dolap = [
    _kiyafet('Beyaz Tişört', 'ust'),
    _kiyafet('Siyah Pantolon', 'alt'),
    _kiyafet('Spor Ayakkabı', 'ayakkabi'),
    _kiyafet('Beyaz Gömlek', 'ust'),
  ];

  // Tarihler sabit yazılırsa test bir süre sonra kendiliğinden bozulur:
  // rapor "son 7 gün" penceresine bakar, sabit tarihler pencereden çıkar.
  // Bu yüzden tohum verisi her zaman "düne" ve "önceki güne" göre üretilir.
  String gun(DateTime t) =>
      '${t.year}-${t.month.toString().padLeft(2, '0')}-'
      '${t.day.toString().padLeft(2, '0')}';
  final bugun = DateTime.now();

  final gecmis = <Map<String, String>>[
    {
      'tarih': gun(bugun.subtract(const Duration(days: 1))),
      'baslik': 'Ofis kombini',
      'detay': 'Beyaz Tişört, Siyah Pantolon',
    },
    {
      'tarih': gun(bugun.subtract(const Duration(days: 2))),
      'baslik': 'Spor kombini',
      'detay': 'Beyaz Gömlek, Siyah Pantolon',
    },
  ];

  Future<void> kurStil(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('tr'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: StilGunluguEkrani(
          gardirobum: dolap,
          gecmisKombinler: gecmis,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('üç sekme görünür ve takvim ayı gösterir', (tester) async {
    await kurStil(tester);

    expect(find.text('Stil Günlüğüm'), findsOneWidget);
    expect(find.text('Takvim'), findsOneWidget);
    expect(find.text('Günlük'), findsOneWidget);
    expect(find.text('Rapor'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('günlükte giyilen kombinler listelenir', (tester) async {
    await kurStil(tester);

    await tester.tap(find.text('Günlük'));
    await tester.pumpAndSettle();

    expect(find.text('Ofis kombini'), findsOneWidget);
    expect(find.text('Spor kombini'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('rapor sekmesi haftalık özeti gösterir', (tester) async {
    await kurStil(tester);

    await tester.tap(find.text('Rapor'));
    await tester.pumpAndSettle();

    // Büyük sayı + etiketi (eski "3 kombin giyindin" cümlesi yerine).
    expect(find.text('2'), findsWidgets);
    expect(find.text('Bu hafta giyilen kombin'), findsOneWidget);
    expect(find.text('Son 4 hafta'), findsOneWidget);
    expect(find.text('En çok giydiklerin'), findsOneWidget);
    // En çok giyilen parça listenin başında ve adediyle görünür.
    expect(find.text('Siyah Pantolon'), findsOneWidget);
    expect(find.text('×2'), findsOneWidget);
    expect(find.text('Dolap kullanımı'), findsOneWidget);
    expect(find.text('En çok giyilen'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('bos raporda paylas dugmesi pasif olur', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('tr'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: StilGunluguEkrani(
          gardirobum: dolap,
          gecmisKombinler: const <Map<String, String>>[],
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Rapor'));
    await tester.pumpAndSettle();

    final dugme = find.widgetWithIcon(FilledButton, Icons.ios_share_rounded);
    expect(dugme, findsOneWidget);
    expect(tester.widget<FilledButton>(dugme).onPressed, isNull);
    expect(find.textContaining('kaydın yok'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('takvim kayit yokken ipucu gosterir', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('tr'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: StilGunluguEkrani(
          gardirobum: dolap,
          gecmisKombinler: const <Map<String, String>>[],
        ),
      ),
    );
    await tester.pumpAndSettle();

    // İpucu takvimin altında; kaydırınca görünür.
    await tester.drag(find.byType(ListView).first, const Offset(0, -600));
    await tester.pumpAndSettle();

    expect(
      find.text(lookupAppLocalizations(const Locale('tr')).gecmisKombinYok),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('seyahat modu valiz planını hesaplar', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('tr'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: SeyahatEkrani(gardirobum: dolap),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Seyahat Modu'), findsOneWidget);
    expect(find.text('Valiz Planı'), findsOneWidget);
    expect(find.textContaining('kombin çıkar'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('seyahat modunda gün sayısı değiştirilir', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('tr'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: SeyahatEkrani(gardirobum: dolap),
      ),
    );
    await tester.pumpAndSettle();

    // 3 gün → 2 üst + 2 alt yoksa 1 üst x 1 alt = 1 kombin.
    await tester.tap(find.byIcon(Icons.add_circle_outline_rounded));
    await tester.pumpAndSettle();

    expect(find.text('4'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
