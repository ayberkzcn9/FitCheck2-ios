# FitCheck 1.0.34+40 — Sürüm Notu

Play Console'a yüklenecek 12 dilli kısa not. Her satır 500 UTF-16 karakterin
altında.

## tr
Tanıtım üç adıma indirildi. Reklamla kazanılan haklar günlük yenilemede korunuyor. Fotoğraf işleme iptal edilebiliyor; ekranlar büyük yazıda daha rahat kullanılıyor.

## en
Onboarding is now three steps. Ad-earned credits are preserved at daily reset. Photo processing can be cancelled, and key screens work better with larger text.

## de
Das Onboarding hat jetzt drei Schritte. Durch Werbung verdiente Guthaben bleiben beim Tageswechsel erhalten. Die Fotoverarbeitung lässt sich abbrechen; große Schrift wird besser unterstützt.

## fr
L'intégration passe à trois étapes. Les crédits gagnés via les pubs sont conservés au renouvellement quotidien. Le traitement des photos peut être annulé et les grands caractères sont mieux pris en charge.

## es
La introducción ahora tiene tres pasos. Los créditos ganados con anuncios se conservan al reiniciarse el día. Puedes cancelar el procesamiento de fotos y usar mejor la app con texto grande.

## it
L'introduzione ora ha tre passaggi. I crediti guadagnati con gli annunci restano disponibili al rinnovo giornaliero. Puoi annullare l'elaborazione delle foto; il testo grande è gestito meglio.

## pt
A introdução agora tem três etapas. Os créditos ganhos com anúncios são preservados na renovação diária. É possível cancelar o processamento de fotos, com melhor suporte a textos maiores.

## ru
Знакомство теперь состоит из трёх шагов. Кредиты за рекламу сохраняются при ежедневном обновлении. Обработку фото можно отменить; крупный текст отображается удобнее.

## ar
أصبحت البداية ثلاث خطوات. تُحفظ الأرصدة المكتسبة من الإعلانات عند التجديد اليومي. يمكن إلغاء معالجة الصور، وأصبح عرض النص الكبير أفضل.

## ja
オンボーディングを3ステップに短縮しました。広告で獲得したクレジットは毎日の更新後も保持されます。写真処理をキャンセルでき、大きな文字にも対応しました。

## ko
온보딩을 3단계로 줄였습니다. 광고로 얻은 생성권은 매일 초기화되어도 유지됩니다. 사진 처리 중 취소할 수 있으며 큰 글자 표시도 개선했습니다.

## zh
引导流程缩短为三步。广告获得的额度在每日刷新时会保留。照片处理现在可以取消，并改善了大字号显示。

---

## Kapalı test notu (Türkçe)

- Günlük ve reklamla kazanılan haklar ayrı sayaçlarda tutulur; günlük yenileme
  reklamla kazanılmış hakları silmez. Eski sayaç kayıtları korunarak taşınır.
- Tanıtım iki içerik adımı ve giriş/kayıt adımı olmak üzere üç ekrana indirildi.
- Gardırop fotoğrafları işlenirken iptal edilebilir; o ana kadar eklenenler kalır.
- Konum ve analitik gizlilik açıklamaları güncellendi; analitik varsayılan olarak
  kapalıdır.
- Android abonelikleri Firebase Functions üzerinden Google Play ile doğrulanır.
  Hesap silme profili ve satın alma kayıtlarını da temizler.
- Bugün ekranında ana kombin öne alındı; hava ve gardırop metinleri %200 yazıda
  daha okunaklı hale getirildi.
- Doğrulama: Flutter testleri 370 geçti / 1 atlandı; Functions testleri 4 geçti;
  Firestore kuralları Emulator'da denendi; tasarım kapısı geçti.
