# FitCheck 1.0.33+39 — Sürüm Notu

Play Console'a yüklenecek 12 dilli kısa not. Her satır 500 UTF-16 karakterin
altında.

## tr
Gardırop fotoğrafları işlenirken artık iptal edebilirsin. Hata mesajları sadeleştirildi, terimler tutarlı hale getirildi.

## en
You can now cancel while wardrobe photos are being processed. Error messages are clearer and terms are more consistent.

## de
Du kannst die Verarbeitung von Kleiderschrank-Fotos jetzt abbrechen. Fehlermeldungen sind klarer, Begriffe einheitlicher.

## fr
Vous pouvez désormais annuler le traitement des photos de votre dressing. Messages d'erreur plus clairs et termes harmonisés.

## es
Ahora puedes cancelar mientras se procesan las fotos de tu armario. Mensajes de error más claros y términos coherentes.

## it
Ora puoi annullare mentre le foto del guardaroba vengono elaborate. Messaggi di errore più chiari e termini coerenti.

## pt
Agora você pode cancelar enquanto as fotos do guarda-roupa são processadas. Mensagens de erro mais claras e termos consistentes.

## ru
Теперь можно отменить обработку фотографий гардероба. Сообщения об ошибках стали понятнее, термины — единообразнее.

## ar
يمكنك الآن إلغاء المعالجة أثناء تجهيز صور الخزانة. رسائل الأخطاء أوضح والمصطلحات أكثر اتساقًا.

## ja
クローゼットの写真を処理中にキャンセルできるようになりました。エラーメッセージと用語も整理しました。

## ko
옷장 사진을 처리하는 동안 취소할 수 있습니다. 오류 메시지와 용어를 더 명확하게 정리했습니다.

## zh
处理衣橱照片时现在可以取消。错误提示更清晰，术语更统一。

---

## Kapalı test notu (Türkçe)

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
- Doğrulama: `flutter analyze` 0 hata, `flutter test` 353 geçti / 1 atlandı,
  tasarım kapısı geçti. APK içinde eski kupon kodu taranarak bulunmadı
  (`libapp.so`, üç ABI).
