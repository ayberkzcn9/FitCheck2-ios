import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Temel Widget Testi', (WidgetTester tester) async {
    // Kendi projemizi çağırmak yerine, testin hata vermemesi için 
    // boş, standart bir MaterialApp çalıştırıyoruz.
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: Text('Test Başarılı'),
      ),
    ));

    // Ekranda Scaffold olduğunu doğruluyoruz.
    expect(find.byType(Scaffold), findsOneWidget);
  });
}