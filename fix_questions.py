with open(r'C:\Users\mehmet\Downloads\Yeni klasor26\lib\screens\moda_renk_yarismasi_ekrani.dart', 'r', encoding='utf-8') as f:
    content = f.read()

old = '''  List<_Soru> _sorulariOlustur(AppLocalizations l10n) {
    return [
      _Soru(soru: l10n.triviaQ1, secenekler: [l10n.triviaQ1o1, l10n.triviaQ1o2, l10n.triviaQ1o3, l10n.triviaQ1o4], dogruIndex: 0),
      _Soru(soru: l10n.triviaQ2, secenekler: [l10n.triviaQ2o1, l10n.triviaQ2o2, l10n.triviaQ2o3, l10n.triviaQ2o4], dogruIndex: 0),
      _Soru(soru: l10n.triviaQ3, secenekler: [l10n.triviaQ3o1, l10n.triviaQ3o2, l10n.triviaQ3o3, l10n.triviaQ3o4], dogruIndex: 1),
      _Soru(soru: l10n.triviaQ4, secenekler: [l10n.triviaQ4o1, l10n.triviaQ4o2, l10n.triviaQ4o3, l10n.triviaQ4o4], dogruIndex: 2),
      _Soru(soru: l10n.triviaQ5, secenekler: [l10n.triviaQ5o1, l10n.triviaQ5o2, l10n.triviaQ5o3, l10n.triviaQ5o4], dogruIndex: 1),
      _Soru(soru: l10n.triviaQ6, secenekler: [l10n.triviaQ6o1, l10n.triviaQ6o2, l10n.triviaQ6o3, l10n.triviaQ6o4], dogruIndex: 1),
      _Soru(soru: l10n.triviaQ7, secenekler: [l10n.triviaQ7o1, l10n.triviaQ7o2, l10n.triviaQ7o3, l10n.triviaQ7o4], dogruIndex: 0),
      _Soru(soru: l10n.triviaQ8, secenekler: [l10n.triviaQ8o1, l10n.triviaQ8o2, l10n.triviaQ8o3, l10n.triviaQ8o4], dogruIndex: 2),
      _Soru(soru: l10n.triviaQ9, secenekler: [l10n.triviaQ9o1, l10n.triviaQ9o2, l10n.triviaQ9o3, l10n.triviaQ9o4], dogruIndex: 0),
      _Soru(soru: l10n.triviaQ10, secenekler: [l10n.triviaQ10o1, l10n.triviaQ10o2, l10n.triviaQ10o3, l10n.triviaQ10o4], dogruIndex: 1),
    ];
  }'''

new = '''  List<_Soru> _sorulariOlustur(AppLocalizations l10n) {
    // Easy questions (Turkish) - 12 samples, we will take first 10 each day
    return [
      _Soru(
        soru: "Türkiye'nin başkenti neresidir?",
        secenekler: ["İstanbul", "Ankara", "İzmir", "Bursa"],
        dogruIndex: 1,
      ),
      _Soru(
        soru: "Dünya'nın en büyük okyanusu hangisidir?",
        secenekler: ["Atlas", "Hint", "Pasifik", "Kuzey Kutup"],
        dogruIndex: 2,
      ),
      _Soru(
        soru: "İlk olarak ağaçtan yapılmış yazılım cihazı hangisidir?",
        secenekler: ["Abaküs", "Mikrodenge", "Analog bilgisayar", "ENIAC"],
        dogruIndex: 0,
      ),
      _Soru(
        soru: "Bir üçgenin iç açılar toplamı kaç derecedir?",
        secenekler: ["180°", "360°", "90°", "270°"],
        dogruIndex: 0,
      ),
      _Soru(
        soru: "Türk bayrağındaki ayın şekli nedir?",
        secenekler: ["Yıldız", "Ay", "Yarım Ay", "Tam Ay"],
        dogruIndex: 2,
      ),
      _Soru(
        soru: "Hangisi bir memeli hayvandır?",
        secenekler: ["Kunduz", "Balık", "Kuş", "Kertenkele"],
        dogruIndex: 0,
      ),
      _Soru(
        soru: "İnternet'te 'WWW' kısaltması ne anlama gelir?",
        secenekler: ["World Wide Web", "World Wide Wrestling", "World Weather Watch", "World Water Week"],
        dogruIndex: 0,
      ),
      _Soru(
        soru: "Bir gün kaç saat eder?",
        secenekler: ["12", "24", "36", "48"],
        dogruIndex: 1,
      ),
      _Soru(
        soru: "Türkçe alfabesinde kaç harf vardır?",
        secenekler: ["26", "28", "29", "30"],
        dogruIndex: 2,
      ),
      _Soru(
        soru: "Hangisi bir meyvedir?",
        secenekler: ["Elma", "Soğan", "Patates", "Marul"],
        dogruIndex: 0,
      ),
      _Soru(
        soru: "Dünya'nın en uzun nehri hangisidir?",
        secenekler: ["Amazon", "Nil", "Yangtze", "Mississippi"],
        dogruIndex: 1,
      ),
      _Soru(
        soru: "Atatürk'ün doğum yılı nedir?",
        secenekler: ["1881", "1890", "1900", "1912"],
        dogruIndex: 0,
      ),
    ];
  }'''

if old in content:
    content = content.replace(old, new)
    with open(r'C:\Users\mehmet\Downloads\Yeni klasor26\lib\screens\moda_renk_yarismasi_ekrani.dart', 'w', encoding='utf-8') as f:
        f.write(content)
    print('SUCCESS: Replaced!')
else:
    print('FAILED: Old text not found')
    idx = content.index('  List<_Soru> _sorulariOlustur')
    print('Actual content:')
    print(repr(content[idx:idx+len(old)]))