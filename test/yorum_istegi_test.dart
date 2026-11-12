import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fitcheck/services/yorum_istegi_servisi.dart';

void main() {
  group('YorumIstegiServisi.gosterilmeliMi', () {
    test('olumlu an yoksa sormaz', () {
      expect(
        YorumIstegiServisi.gosterilmeliMi(
            olumluAnSayisi: 0, yapildi: false, acilisSayisi: 5, sonIsteme: 0),
        isFalse,
      );
    });

    test('ilk olumlu andan sonra sorar', () {
      expect(
        YorumIstegiServisi.gosterilmeliMi(
            olumluAnSayisi: 1, yapildi: false, acilisSayisi: 1, sonIsteme: 0),
        isTrue,
      );
    });

    test('kullanici evet dediyse bir daha sormaz', () {
      expect(
        YorumIstegiServisi.gosterilmeliMi(
            olumluAnSayisi: 9, yapildi: true, acilisSayisi: 20, sonIsteme: 0),
        isFalse,
      );
    });

    test('reddedildiyse ayni oturumda ve 3 acilistan once sormaz', () {
      expect(
        YorumIstegiServisi.gosterilmeliMi(
            olumluAnSayisi: 3, yapildi: false, acilisSayisi: 4, sonIsteme: 4),
        isFalse,
      );
      expect(
        YorumIstegiServisi.gosterilmeliMi(
            olumluAnSayisi: 3, yapildi: false, acilisSayisi: 6, sonIsteme: 4),
        isFalse,
      );
    });

    test('reddedildiyse 3 acilis sonra tekrar sorar', () {
      expect(
        YorumIstegiServisi.gosterilmeliMi(
            olumluAnSayisi: 3, yapildi: false, acilisSayisi: 7, sonIsteme: 4),
        isTrue,
      );
    });
  });

  group('YorumIstegiServisi saklama', () {
    setUp(() => SharedPreferences.setMockInitialValues({}));

    test('olumluAnKaydet ilk seferde true, soruldu sonrasi false', () async {
      await YorumIstegiServisi.acilisiSay();
      expect(await YorumIstegiServisi.olumluAnKaydet(), isTrue);
      await YorumIstegiServisi.soruldu();
      expect(await YorumIstegiServisi.olumluAnKaydet(), isFalse);
    });

    test('yapildiIsaretle sonrasi hic sormaz', () async {
      await YorumIstegiServisi.acilisiSay();
      await YorumIstegiServisi.yapildiIsaretle();
      expect(await YorumIstegiServisi.olumluAnKaydet(), isFalse);
    });
  });
}
