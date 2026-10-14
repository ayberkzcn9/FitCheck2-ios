# 🍎 FitCheck — iOS Yayın Rehberi

Bu dosya, FitCheck uygulamasının iOS (App Store) sürümü için yapılması gerekenleri listeler.

---

## ✅ Kod Tarafında YAPILDI (bu depoda hazır)

| # | Yapılan | Dosya |
|---|---------|-------|
| 1 | Bundle ID: `com.example.kombinApp` → **`com.fitcheck2.app`** | `ios/Runner.xcodeproj/project.pbxproj` |
| 2 | Uygulama adı: **FitCheck** | `ios/Runner/Info.plist` |
| 3 | İzin açıklamaları (kamera, galeri, konum, mikrofon, konuşma tanıma, izleme) | `ios/Runner/Info.plist` |
| 4 | AdMob uygulama kimliği | `ios/Runner/Info.plist` |
| 5 | iOS minimum sürüm: **15.0** | `project.pbxproj`, `AppFrameworkInfo.plist` |
| 6 | Privacy Manifest (`PrivacyInfo.xcprivacy`) | `ios/Runner/PrivacyInfo.xcprivacy` |
| 7 | HTTP izni (Oracle Cloud sunucusu için) | `Info.plist` (NSAppTransportSecurity) |

---

## 🔴 SENİN YAPMAN GEREKENLER

### 1. Firebase iOS Yapılandırması

**Neden:** Push bildirim + analytics iOS için ayrı dosya ister.

**Adımlar:**
1. https://console.firebase.google.com → proje: **fitcheck-98dec**
2. ⚙️ Proje Ayarları → **Genel** → **Uygulamanı ekle** → **iOS** (🍎 ikonu)
3. **Apple bundle ID:** `com.fitcheck2.app`
4. Uygulama adı: `FitCheck iOS`
5. **GoogleService-Info.plist** dosyasını indir
6. İndirdiğin dosyayı şuraya koy:
   ```
   ios/Runner/GoogleService-Info.plist
   ```
7. Aynı dosyayı Xcode projesine ekle (Xcode'da Runner'a sürükle-bırak)

---

### 2. Apple Developer Hesabı

| Gereksinim | Maliyet |
|------------|---------|
| Apple Developer Program | **$99/yıl** (~₺3.400) |

- Kayıt: https://developer.apple.com/programs/
- Onay: 1-2 gün

---

### 3. App Store Connect'te Uygulama Oluştur

1. https://appstoreconnect.apple.com
2. **My Apps → + → New App**
3. Doldur:
   - **Platform:** iOS
   - **Name:** FitCheck
   - **Primary Language:** Turkish (veya English)
   - **Bundle ID:** `com.fitcheck2.app` (seç)
   - **SKU:** `fitcheck-ios-001`

---

### 4. Mac + Xcode Gerekli

**iOS derlemek için Mac zorunlu.** Seçenekler:

| Yol | Maliyet |
|-----|---------|
| Mac bilgisayar | — |
| MacinCloud / MacStadium (kiralık Mac) | ~$25-100/ay |
| Codemagic (bulut CI) | Ücretsiz plan var |
| GitHub Actions (macOS runner) | Ücretsiz (public repo) |

**Mac'te yapılacaklar:**
```bash
# CocoaPods kur
sudo gem install cocoapods

# Bağımlılıkları yükle
cd ios && pod install

# Xcode'da aç
open Runner.xcworkspace
```

**Xcode'da:**
- **Signing & Capabilities** → Team seç (Apple hesabın)
- **Bundle Identifier** = `com.fitcheck2.app`
- **GoogleService-Info.plist** ekle (yukarıdaki adım)
- **Push Notifications** capability ekle
- **Background Modes** → Remote notifications ✓

---

### 5. Derleme (Mac'te)

```bash
flutter clean
flutter pub get
cd ios && pod install && cd ..
flutter build ipa --release --obfuscate --split-debug-info=build/symbols-ios
```

Çıktı: `build/ios/ipa/fitcheck.ipa`

---

### 6. Yükleme

**Xcode ile:**
```
Xcode → Product → Archive → Distribute App → App Store Connect → Upload
```

**Veya Transporter uygulaması** ile IPA yükle.

---

### 7. App Store İncelemesi

- **TestFlight** ile önce test et (davet edilenler)
- Sonra **App Store**'a gönder
- İnceleme: 1-3 gün

---

## 📋 Checklist

- [ ] Firebase iOS uygulaması ekle + `GoogleService-Info.plist` indir
- [ ] `GoogleService-Info.plist` → `ios/Runner/` içine koy
- [ ] Apple Developer hesabı al ($99)
- [ ] App Store Connect'te uygulama oluştur
- [ ] Mac bul/kirala
- [ ] Xcode'da signing + capability ayarla
- [ ] `flutter build ipa`
- [ ] TestFlight testi
- [ ] App Store'a gönder

---

## ⚠️ Notlar

- **App Store gizlilik politikası URL'si** zorunlu (App Store Connect'te alan var)
- **Ekran görüntüleri** gerekli: 6.7" ve 5.5" iPhone + iPad (opsiyonel)
- **Açıklama + anahtar kelimeler** yazılmalı
- **Yaş sınırı:** 4+ (veya içerik durumuna göre)
- **Reklam içerdiği** beyan edilmeli (AdMob var)

---

## 💰 Toplam Maliyet

| Kalem | Maliyet |
|-------|---------|
| Apple Developer | $99/yıl |
| Mac kiralama (opsiyonel) | $25-100/ay |
| **Toplam (Mac varsa)** | **$99/yıl** |

---

**Son güncelleme:** 2026-10-14
