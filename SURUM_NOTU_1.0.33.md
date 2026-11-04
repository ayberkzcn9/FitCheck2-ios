# FitCheck 1.0.33+39 — Sürüm Notu

Play Console'a yüklenecek 12 dilli kısa not. Her satır 500 UTF-16 karakterin
altında.

## tr
Tanıtım üç adıma indirildi. Reklamla kazandığın haklar artık günlük sıfırlamada silinmiyor. Gardırop fotoğraflarını işlerken iptal edebilirsin.

## en
Onboarding is now three steps. Ad-earned credits are no longer reset at midnight. You can cancel while wardrobe photos are being processed.

## de
Das Onboarding hat jetzt drei Schritte. Durch Werbung verdientes Guthaben bleibt bei der täglichen Zurücksetzung erhalten. Die Verarbeitung von Kleiderschrank-Fotos lässt sich abbrechen.

## fr
L'intégration passe à trois étapes. Les crédits gagnés via les pubs ne sont plus réinitialisés. Vous pouvez annuler le traitement des photos du dressing.

## es
La introducción ahora tiene tres pasos. Los créditos ganados con anuncios ya no se borran en el reinicio diario. Puedes cancelar el procesamiento de las fotos del armario.

## it
L'introduzione ora ha tre passaggi. I crediti guadagnati con gli annunci non vengono più azzerati. Puoi annullare l'elaborazione delle foto del guardaroba.

## pt
A introdução agora tem três etapas. Os créditos ganhos com anúncios não são mais apagados na reinicialização diária. Você pode cancelar o processamento das fotos do guarda-roupa.

## ru
Знакомство теперь состоит из трёх шагов. Кредиты за рекламу больше не сбрасываются ежедневно. Обработку фотографий гардероба можно отменить.

## ar
أصبحت البداية ثلاث خطوات. أرصدة الإعلانات لم تعد تُحذف عند التجديد اليومي. يمكنك إلغاء معالجة صور الخزانة.

## ja
オンボーディングを3ステップに短縮しました。広告で獲得したクレジットは毎日のリセットで消えません。クローゼット写真の処理中にキャンセルできます。

## ko
온보딩을 3단계로 줄였습니다. 광고로 얻은 생성권은 일일 초기화 때 삭제되지 않습니다. 옷장 사진 처리 중 취소할 수 있습니다.

## zh
引导流程缩短为三步。广告获得的额度不再在每日重置时被清除。处理衣橱照片时可以取消。

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
  sayfasında kaldı.
- Gardırop fotoğraf işleme sırasında "İptal" düğmesi eklendi. İşlem bir sonraki
  adımda durur; o ana kadar eklenen kıyafetler gardıropta kalır ve kullanıcıya
  bu durum bildirilir.
- Yönetici kuponu yayın derlemesinden kaldırıldı. Kupon düğmesi yayında
  görünmüyor, kod kabul edilmiyor, kayıtlı yönetici modu yok sayılıyor. Kod
  yalnızca geliştirme derlemesinde `--dart-define` ile tanımlanabilir.
- Premium ekranındaki ham mağaza hata metni ve tanı yazısı artık yalnızca debug
  derlemesinde görünüyor.
- 12 dilde "kupon girerek hak kazan" vaadi kaldırıldı; günlük hak bitti metni
  yalnızca reklamı öneriyor.
- TR/KO/JA/ZH'de hak ve kıyafet alanı terimleri tek söze indirildi.
- Doğrulama: `flutter analyze` 0 hata, `flutter test` 359 geçti / 1 atlandı,
  tasarım kapısı geçti. APK içinde eski kupon kodu taranarak bulunmadı
  (`libapp.so`, üç ABI).
