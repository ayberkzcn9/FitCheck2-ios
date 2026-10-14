# 🚀 Codemagic ile iOS + Android Build Rehberi

Mac olmadan **iOS** build almak ve TestFlight'a yüklemek için adım adım rehber.

---

## 📋 Ön Gereksinimler

| # | Gereksinim | Maliyet | Durum |
|---|-----------|---------|-------|
| 1 | **Apple Developer Program** | $99/yıl | ⏳ |
| 2 | **GitHub hesabı** | Ücretsiz | ⏳ |
| 3 | **Codemagic hesabı** | Ücretsiz plan | ⏳ |
| 4 | **App Store Connect API Key** | — | ⏳ |
| 5 | **Android keystore** (`upload-keystore.jks`) | Elinde ✓ | ✅ |

---

## ADIM 1: Apple Developer Program ($99)

1. https://developer.apple.com/programs/enroll/
2. **Enroll** → Apple ID ile giriş
3. **Individual** veya **Organization** seç
4. Ödeme ($99/yıl)
5. Onay: 1-2 gün

---

## ADIM 2: GitHub'a Kod Yükle

```powershell
cd "D:\indirilenler\Yeni klasor43"

# Git başlat
git init
git add .
git commit -m "FitCheck ilk commit"

# GitHub'da repo oluştur (private), sonra:
git remote add origin https://github.com/KULLANICI/fitcheck.git
git branch -M main
git push -u origin main
```

### ⚠️ GitHub'a GİTMEYECEK dosyalar (`.gitignore` koruyor):
- `.env` (API anahtarları) ✓
- `android/key.properties` (keystore şifresi) ✓
- `android/app/google-services.json` (Firebase) ⚠️ eklenebilir

### 🔐 Git'e EKLENMESİ GEREKENLER:
- `ios/Runner/GoogleService-Info.plist` ✓ (Firebase iOS)
- `android/app/google-services.json` ✓ (Firebase Android)

> 💡 Firebase dosyaları gizli değildir (client-side), güvenle commit edilebilir.

---

## ADIM 3: Codemagic Hesabı

1. https://codemagic.io → **Sign up with GitHub**
2. **Applications** → `fitcheck` repo'nu **Add application**
3. **Set up build** → **codemagic.yaml** seç

---

## ADIM 4: App Store Connect API Key

### 4.1 Apple'da oluştur

1. https://appstoreconnect.apple.com → **Users and Access**
2. **Integrations** sekmesi → **App Store Connect API** → **Team Keys**
3. **+** butonuna bas:
   - **Name:** `Codemagic`
   - **Role:** **App Manager**
4. **Generate** → **Download API Key** (`.p8` — bir kez inebilir, sakla!)
5. Not al:
   ```
   Key ID : ABC123DEF4          (10 karakter)
   Issuer ID : xxxxxxxx-xxxx-.... (UUID)
   .p8 dosyası (AuthKey_ABC123DEF4.p8)
   ```

### 4.2 Codemagic'e ekle

Codemagic → **Teams** → **Integrations** → **App Store Connect** → **Add**

| Alan | Değer |
|------|-------|
| **Name** | `Codemagic ASC` |
| **Key ID** | (yukarıdaki) |
| **Issuer ID** | (yukarıdaki) |
| **API Key** | .p8 dosyasının içeriği |

---

## ADIM 5: Kod İmzalama (iOS)

Codemagic'te **iOS code signing** → **Automatic** (önerilen):

| Alan | Değer |
|------|-------|
| **Apple ID** | Apple Developer e-postan |
| **App-specific password** | appleid.apple.com'dan oluştur |
| **Bundle ID** | `com.fitcheck2.app` |

### App-specific password nasıl alınır?
1. https://appleid.apple.com → **Sign-In and Security**
2. **App-Specific Passwords** → **Generate**
3. İsim: `Codemagic` → kopyala

---

## ADIM 6: Ortam Değişkenleri (Codemagic UI)

Codemagic → Uygulama → **Environment variables** → Ekle:

| Değişken | Değer | Gizli? |
|----------|-------|--------|
| `ENV_FILE` | `.env` dosyanın **tüm içeriği** | ✅ Evet |
| `GOOGLE_SERVICE_INFO_PLIST` | `GoogleService-Info.plist` (base64) | ✅ |
| `GOOGLE_SERVICES_JSON` | `google-services.json` (base64) | ✅ |
| `KEYSTORE_BASE64` | `upload-keystore.jks` (base64) | ✅ |
| `KEYSTORE_PASSWORD` | `150903` | ✅ |
| `KEY_PASSWORD` | `150903` | ✅ |
| `KEY_ALIAS` | `upload` | ✅ |

### Base64 nasıl oluşturulur? (PowerShell)

```powershell
# GoogleService-Info.plist
[Convert]::ToBase64String([IO.File]::ReadAllBytes("ios\Runner\GoogleService-Info.plist"))

# google-services.json
[Convert]::ToBase64String([IO.File]::ReadAllBytes("android\app\google-services.json"))

# Keystore
[Convert]::ToBase64String([IO.File]::ReadAllBytes("C:\Users\mehmet\Downloads\upload-keystore.jks"))
```

Çıkan uzun metni ilgili değişkene yapıştır.

---

## ADIM 7: App Store Connect'te Uygulama Oluştur

1. https://appstoreconnect.apple.com → **My Apps → + → New App**
2. Doldur:

| Alan | Değer |
|------|-------|
| **Platform** | iOS |
| **Name** | FitCheck |
| **Primary Language** | Turkish |
| **Bundle ID** | `com.fitcheck2.app` |
| **SKU** | `fitcheck-ios-001` |

3. **Create**

---

## ADIM 8: Build Başlat

Codemagic → **Start new build** → **ios-release** workflow

Build başlar:
1. Flutter bağımlılıkları ✓
2. `.env` oluşturulur ✓
3. Firebase dosyaları yerleştirilir ✓
4. CocoaPods kurulur ✓
5. Kod imzalanır ✓
6. IPA üretilir ✓
7. **TestFlight'a yüklenir** ✓

**~15-25 dakika** sürer.

---

## ADIM 9: TestFlight Testi

1. TestFlight'a yüklenince Apple **işler** (10-30 dk)
2. **TestFlight** sekmesi → build görünür
3. **Internal Testing** → test kullanıcısı ekle (kendin)
4. iPhone'da **TestFlight** uygulamasından test et

---

## ADIM 10: App Store'a Gönder

Test başarılıysa:
1. App Store Connect → **App Store** sekmesi
2. Ekran görüntüleri, açıklama, anahtar kelimeler ekle
3. **Gizlilik politikası URL** (zorunlu)
4. Build seç → **Submit for Review**
5. İnceleme: **1-3 gün**

---

## 📋 Tam Checklist

- [ ] Apple Developer hesabı ($99)
- [ ] GitHub'a kod yükle
- [ ] Codemagic hesabı + repo bağla
- [ ] App Store Connect API Key oluştur
- [ ] Codemagic'e ASC entegrasyonu ekle
- [ ] iOS code signing (automatic)
- [ ] Ortam değişkenleri (7 adet)
- [ ] App Store Connect'te uygulama oluştur
- [ ] Build başlat
- [ ] TestFlight testi
- [ ] App Store'a gönder

---

## 💰 Maliyet

| Kalem | Maliyet |
|-------|---------|
| Apple Developer | $99/yıl |
| Codemagic (ücretsiz plan) | $0 (aylık 500 dk build) |
| GitHub (private) | $0 |
| **Toplam** | **$99/yıl** |

> ⚠️ Codemagic ücretsiz planı **aylık 500 dakika** macOS build verir. iOS build ~25 dk → **ayda ~20 build** ücretsiz.

---

## 🆘 Sorun Giderme

| Hata | Çözüm |
|------|-------|
| "Signing failed" | Apple ID + app-specific password kontrol et |
| "Bundle ID mismatch" | `com.fitcheck2.app` her yerde tutarlı olsun |
| "Firebase not initialized" | `GoogleService-Info.plist` doğru yerde mi? |
| "Provisioning profile" | Codemagic otomatik oluştursun |
| Build timeout | `max_build_duration` artır |

---

## 📎 İlgili Dosyalar

- `codemagic.yaml` — Build yapılandırması (bu depo)
- `IOS_YAYIN_REHBERI.md` — iOS genel rehber
- `.env` — API anahtarları (git'e girmez!)

---

**Son güncelleme:** 2026-10-14
