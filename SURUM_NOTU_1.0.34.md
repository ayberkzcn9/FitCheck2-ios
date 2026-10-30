# FitCheck 1.0.34+40 — Sürüm Notu

Play Console'a yüklenecek 12 dilli kısa not. Her satır 500 UTF-16 karakterin
altında.

## tr
Tanıtım üç adıma indirildi; ilk kombinine daha hızlı ulaş. Reklamla kazandığın haklar artık günlük sıfırlamada silinmiyor.

## en
Onboarding is now three steps, so you reach your first outfit faster. Ad-earned credits are no longer reset at midnight.

## de
Das Onboarding hat jetzt drei Schritte – du bist schneller beim ersten Outfit. Durch Werbung verdientes Guthaben bleibt bei der täglichen Zurücksetzung erhalten.

## fr
L'intégration passe à trois étapes pour arriver plus vite à votre première tenue. Les crédits gagnés via les pubs ne sont plus réinitialisés.

## es
La introducción ahora tiene tres pasos para llegar antes a tu primer conjunto. Los créditos ganados con anuncios ya no se borran en el reinicio diario.

## it
L'introduzione ora ha tre passaggi per arrivare prima al primo outfit. I crediti guadagnati con gli annunci non vengono più azzerati.

## pt
A introdução agora tem três etapas para você chegar mais rápido ao primeiro look. Os créditos ganhos com anúncios não são mais apagados na reinicialização diária.

## ru
Знакомство теперь состоит из трёх шагов — до первого образа быстрее. Кредиты за рекламу больше не сбрасываются ежедневно.

## ar
أصبحت البداية ثلاث خطوات للوصول إلى أول إطلالة أسرع. أرصدة الإعلانات لم تعد تُحذف عند التجديد اليومي.

## ja
オンボーディングを3ステップに短縮し、最初のコーデに早く到達できます。広告で獲得したクレジットは毎日のリセットで消えなくなりました。

## ko
온보딩을 3단계로 줄여 첫 코디에 더 빨리 도달합니다. 광고로 얻은 생성권은 일일 초기화 때 삭제되지 않습니다.

## zh
引导流程缩短为三步，更快开始第一套穿搭。广告获得的额度不再在每日重置时被清除。

---

## Kapalı test notu (Türkçe)

- Günlük hak ile reklamla kazanılan hak iki ayrı sayaçta tutuluyor
  (`reklam_gunluk_hak`, `reklam_ekstra_hak`). Gece yarısı yalnızca günlük hak
  3'e tamamlanıyor; ekstra haklar silinmiyor.
- Eski tek sayaçlı kayıt, toplam korunarak yeni modele geçiriliyor. Geçişte
  hiçbir hak silinmiyor; ilk geçişte günlük 3 hak bir kez fazla verilebilir.
- Harcama sırası: önce günlük hak, sonra ekstra hak. İade edilen hak ekstra
  hakka eklenir ve süresizdir.
- `test/hak_ekstra_test.dart`: 6 regresyon testi (gece yarısı koruma, göç,
  ödül, harcama sırası, iade, günlük 3).
- Tanıtım 7 içerik sayfası + kayıt yerine 2 içerik sayfası + kayıt (toplam 3)
  olarak kısaltıldı. Kişiselleştirme ve kullanım koşulları son içerik
  sayfasında kaldı. Sayfa renk paleti 3 sayfaya indirildi.
- Doğrulama: `flutter analyze` 0 hata, `flutter test` 359 geçti / 1 atlandı,
  tasarım kapısı geçti.
