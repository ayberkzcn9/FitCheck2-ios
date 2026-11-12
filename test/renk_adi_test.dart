import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitcheck/l10n/app_localizations.dart';
import 'package:fitcheck/utils/renk_adi.dart';

void main() {
  test('Turkce renk adi Ingilizce ekranda Ingilizce gorunur', () async {
    final en = await AppLocalizations.delegate.load(const Locale('en'));
    expect(renkAdiYerellestir(en, 'bordo'), en.renkBordo);
    expect(renkAdiYerellestir(en, ' Lacivert '), en.kombinRenkLacivert);
    expect(renkAdiYerellestir(en, 'KIRMIZI'.toLowerCase()), en.kombinRenkKirmizi);
    expect(renkAdiYerellestir(en, 'bordo'), isNot('bordo'));
  });

  test('bilinmeyen renk oldugu gibi kalir', () async {
    final en = await AppLocalizations.delegate.load(const Locale('en'));
    expect(renkAdiYerellestir(en, 'burgundy'), 'burgundy');
    expect(renkAdiYerellestir(en, ''), '');
  });

  test('Turkce ekranda Turkce kalir', () async {
    final tr = await AppLocalizations.delegate.load(const Locale('tr'));
    expect(renkAdiYerellestir(tr, 'bordo'), tr.renkBordo);
  });
}
