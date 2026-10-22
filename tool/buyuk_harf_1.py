import io, os, re

# 1) Yardımcı: Türkçede "i" -> "İ" (Dart toUpperCase bunu yapmaz).
yardimci = r'D:\indirilenler\Yeni klasor43\lib\utils\buyuk_harf.dart'
io.open(yardimci, 'w', encoding='utf-8', newline='').write(
"""/// Metni büyük harfe çevirir. Türkçede "i" büyüyünce "İ" olmalı; Dart'ın
/// [String.toUpperCase] bunu "I" yaptığı için ayrı bir kural uygulanır.
String buyukHarf(String metin, String dilKodu) {
  if (dilKodu == 'tr' || dilKodu == 'az') {
    return metin.replaceAll('i', 'İ').toUpperCase();
  }
  return metin.toUpperCase();
}
""")
print('yardimci yazildi')

def bul(ad):
    for dizin, _, dosyalar in os.walk(r'D:\indirilenler\Yeni klasor43\lib'):
        if ad in dosyalar:
            return os.path.join(dizin, ad)
    raise SystemExit('yok ' + ad)

def degistir(ad, eski, yeni, beklenen=1):
    yol = bul(ad)
    s = io.open(yol, encoding='utf-8', newline='').read()
    n = s.count(eski)
    if n != beklenen:
        raise SystemExit('%s: %d (beklenen %d) %s' % (ad, n, beklenen, eski))
    s = s.replace(eski, yeni)
    # import ekle (yoksa)
    if "import '../utils/buyuk_harf.dart';" not in s and "buyuk_harf.dart" not in s:
        m = re.search(r"^import '[^']+';\s*$", s, re.M)
        satir = "import '../utils/buyuk_harf.dart';"
        s = s[:m.start()] + satir + '\n' + s[m.start():]
    io.open(yol, 'w', encoding='utf-8', newline='').write(s)
    print('ok', ad)

degistir('kendi_kombinim_ekrani.dart',
         'baslik.toUpperCase(),',
         'buyukHarf(baslik, Localizations.localeOf(context).languageCode),')
degistir('dolaptan_kombin_ekrani.dart',
         'l10n.stilistAnlikHavaDurumu.toUpperCase(),',
         'buyukHarf(l10n.stilistAnlikHavaDurumu, Localizations.localeOf(context).languageCode),')
degistir('dolaptan_kombin_ekrani.dart',
         'etiket.toUpperCase(),',
         'buyukHarf(etiket, Localizations.localeOf(context).languageCode),')
