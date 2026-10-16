# FitCheck — Abonelik (Premium) Kurulum Rehberi

Bu dosya, **aylık/yıllık premium abonelik** ve **ücretsiz deneme** için mağaza
tarafında yapılması gerekenleri ve kodla birebir eşleşmesi zorunlu değerleri
listeler. Kod tarafı hazırdır; aşağıdaki adımlar yapılmazsa "abone ol" düğmesi
pasif kalır ve ekranda teknik tanı metni görünür.

---

## 1. Kodla eşleşmesi ZORUNLU değerler

| Yer | Değer | Nerede |
|---|---|---|
| Aylık ürün kimliği | `fitcheck_premium_monthly` | `lib/services/satin_alma_servisi.dart` → `aylikUrunKimligi` |
| Yıllık ürün kimliği | `fitcheck_premium_yearly` | `lib/services/satin_alma_servisi.dart` → `yillikUrunKimligi` |
| Ücretsiz deneme günü | `7` | `lib/services/satin_alma_servisi.dart` → `denemeGunSayisi` |
| Yedek aylık fiyat | `49,90 TL` | `varsayilanFiyat` |
| Yedek yıllık fiyat | `399,90 TL` | `varsayilanYillikFiyat` |

> **Fiyatlar mağazadan okunur.** Yukarıdaki "yedek" fiyatlar yalnızca mağaza
> bağlantısı kurulamadığında gösterilir. Mağaza fiyatı girildiğinde uygulama
> otomatik olarak gerçek fiyatı gösterir.

> **`denemeGunSayisi` uyarısı:** Play Console'da ücretsiz deneme (intro offer)
> **tanımlamadıysan bu değeri `0` yap.** Aksi halde uygulama "7 gün ücretsiz"
> der ama ödeme ekranı deneme göstermez; bu mağaza politikası ihlalidir.
> (Android'de uygulama ayrıca mağazanın 0 fiyatlı teklif döndürüp
> döndürmediğini doğrular, yani rozet yine çıkmaz; yine de değeri doğru tut.)

---

## 2. Play Console adımları

1. **Monetize → Products → Subscriptions → Create subscription**
   - Product ID: `fitcheck_premium_monthly`
   - Name: `FitCheck Premium (Aylık)`
2. İlk **base plan**:
   - Base plan ID: `aylik`
   - Type: Auto-renewing
   - Billing period: **Monthly**
   - Price: örn. `49,90 TRY` (ülke bazlı fiyatlandırmayı kendi kararınla ayarla)
3. **Kısa video izleyerek yeni haklar kazanabilirsin** yerine geçen **ücretsiz
   deneme** (isteğe bağlı ama dönüşümü artırır):
   - Base plan içinde **Add offer → Free trial**
   - Süre: **7 gün**, ardından ücretli fatura
   - Eligibility: yeni aboneler
4. **Create subscription** ile ikinci ürünü oluştur:
   - Product ID: `fitcheck_premium_yearly`
   - Base plan ID: `yillik`
   - Billing period: **Yearly**
   - Price: örn. `399,90 TRY` (aylıkla karşılaştırıldığında "2 ay bedava" hissi)
5. Her iki aboneliği **Activate** et.
6. **Test:** Play Console → License testing → kendi Gmail hesabını "License
   tester" olarak ekle. Test ödemeleri ücretsizdir (belirli aralıkla yenilenir).
7. Uygulama sürümü Play'e yüklendikten sonra ürünlerin **aktif** olduğunu
   doğrula; ürünler Play'de "Active" değilse `queryProductDetails` boş döner.

---

## 3. App Store Connect adımları (iOS)

1. **Subscriptions → Subscription Group** oluştur: `FitCheck Premium`
2. Grup içine iki abonelik ekle:
   - Product ID: `fitcheck_premium_monthly` → Duration: **1 Month**
   - Product ID: `fitcheck_premium_yearly` → Duration: **1 Year**
3. Her abonelik için **Introductory Offer → Free Trial → 7 Days** ekle
   (isteğe bağlı).
4. Her aboneliğe yerelleştirilmiş görünen ad ve açıklama gir (en az bir dil
   zorunlu).
5. Abonelikleri **"Ready to Submit"** durumuna getir ve uygulama sürümüyle
   birlikte incelemeye gönder.

---

## 4. Ekranda ne görünür?

Paywall (`lib/screens/reklamsiz_premium_ekrani.dart`):

- Ücretsiz deneme varsa: yeşil **"7 GÜN ÜCRETSİZ"** rozeti + CTA altında
  "Deneme bitince <fiyat>".
- Yıllık plan varsa: **"YILLIK"** kartı, "EN AVANTAJLI" rozeti ve iki mağaza
  fiyatından **otomatik hesaplanan yüzde tasarruf** (örn. "%33 tasarruf").
- Yıllık ürün mağazada yoksa yalnızca aylık plan gösterilir; ekran bozulmaz.
- Aylık/yıllık seçimi dokunmayla değişir; CTA seçili planın fiyatını gösterir.

---

## 5. Sık karşılaşılan sorunlar

| Belirti | Neden |
|---|---|
| Ekranda teknik tanı: `notFoundIDs: ...` | Ürün kimliği Play Console'daki ile aynı değil ya da ürün aktif değil |
| "Abonelik bilgisi alınamadı" | Base plan/teklif yok veya uygulama sürümü iç teste yüklenmemiş |
| "Google Play bağlantısı hazır değil" | Cihazda Play Store yok/oturum kapalı (emülatörde sık görülür) |
| Deneme rozeti çıkmıyor | Android'de mağaza 0 fiyatlı teklif döndürmüyor (deneme tanımlı değil) |
| Yıllık kartı görünmüyor | `fitcheck_premium_yearly` ürünü oluşturulmamış/aktif değil |

---

## 6. Otomatik yenileme ve yasal metin

Paywall alt bilgisinde şu ifadeler gösterilir:
- "Abonelik, dönem sonunda otomatik yenilenir. İstediğin zaman iptal
  edebilirsin."
- "Google Play üzerinden yönetilir"

Bu iki satır mağaza kuralları için önemlidir; **kaldırılmamalıdır.**
