import io, os, re, sys
sys.stdout.reconfigure(encoding='utf-8', errors='replace')

KOK = r'D:\indirilenler\Yeni klasor43\lib'

# 1) Dokunma hedefi: 32x32 -> 44x44 (Apple HIG, WCAG 2.5.8 icin de guvenli)
yol = None
for d, _, fs in os.walk(KOK):
    if 'kendi_kombinim_ekrani.dart' in fs:
        yol = os.path.join(d, 'kendi_kombinim_ekrani.dart')
        break
s = io.open(yol, encoding='utf-8', newline='').read()
if 'minimumSize: const Size(32, 32),' in s:
    s = s.replace('minimumSize: const Size(32, 32),', 'minimumSize: const Size(44, 44),')
    io.open(yol, 'w', encoding='utf-8', newline='').write(s)
    print('kendi kombinim dokunma hedefi 32 -> 44')
else:
    print('kendi kombinim: hedef bulunamadi')

# 2) Animasyon tokenlari (Material 3: short4=200, medium4=400, long4=600)
tok = os.path.join(KOK, 'theme', 'design_tokens.dart')
s = io.open(tok, encoding='utf-8', newline='').read()

if 'class AppMotion' not in s:
    blok = '''
/// ANİMASYON — süre ve eğri ölçeği.
///
/// Material 3 hareket kurallarına göre üç kademe: kısa (200 ms), orta
/// (400 ms), uzun (600 ms). Eğriler de aynı mantıkla: ekrana girerken
/// yavaşlayan (decelerate), çıkarken hızlanan (accelerate), ekranda
/// kalırken standart.
class AppMotion {
  const AppMotion._();

  // Süreler
  /// 200 ms — küçük durum değişimi (seçim, vurgu)
  static const Duration kisa = Duration(milliseconds: 200);

  /// 400 ms — kart/liste geçişi, panel açılışı
  static const Duration orta = Duration(milliseconds: 400);

  /// 600 ms — büyük geçiş (sayfa, açılır pencere)
  static const Duration uzun = Duration(milliseconds: 600);

  // Eğriler
  /// Ekrana girerken (yavaşlayan)
  static const Curve giris = Curves.easeOutCubic;

  /// Ekrandan çıkarken (hızlanan)
  static const Curve cikis = Curves.easeInCubic;

  /// Ekranda kalırken (standart)
  static const Curve standart = Curves.easeInOutCubic;

  /// Geri tepki (hafif aşma) — vurgu rozetleri
  static const Curve tepki = Curves.elasticOut;
}
'''
    i = s.index('class AppSpacing {')
    s = s[:i] + blok.lstrip('\n') + '\n' + s[i:]
    io.open(tok, 'w', encoding='utf-8', newline='').write(s)
    print('AppMotion tokenlari eklendi')
