# FitCheck — Apple token iptali kurulumu

Hesap silmede Apple ile Giriş token’larının iptal edilmesi için
`storeAppleToken` ve `deleteAccount` fonksiyonları Apple Developer anahtarıyla
yapılandırılmalıdır.

## 1. Apple Developer’da anahtar oluştur

1. Apple Developer → **Certificates, Identifiers & Profiles → Keys**.
2. **+** → ad: `FitCheck Sign in with Apple` → **Sign in with Apple** işaretle.
3. **Configure** → App ID `com.fitcheck2.app` seç.
4. **Register** → `.p8` dosyasını indir. Bu dosya yalnızca bir kez indirilebilir.
5. **Key ID** ve **Team ID** değerlerini not et.

## 2. `functions/.env` oluştur

`functions/.env` dosyası Git’e girmez. İçine şunları yaz:

```dotenv
APPLE_CLIENT_ID=com.fitcheck2.app
APPLE_TEAM_ID=XXXXXXXXXX
APPLE_KEY_ID=YYYYYYYYYY
APPLE_PRIVATE_KEY_BASE64=...
```

`.p8` dosyasını base64’e çevirmek için PowerShell:

```powershell
[Convert]::ToBase64String([IO.File]::ReadAllBytes("AuthKey_YYYYYYYYYY.p8"))
```

## 3. Fonksiyonları deploy et

```powershell
firebase deploy --only functions:storeAppleToken,functions:deleteAccount --project fitcheck-98dec
```

## 4. Doğrula

1. iOS’ta Apple ile giriş yap.
2. Firestore’da `appleTokens/{uid}` belgesinin oluştuğunu kontrol et.
3. Hesabı sil.
4. `appleTokens/{uid}` belgesinin silindiğini ve Apple token’ının iptal
   edildiğini doğrula.

`APPLE_*` değerleri yoksa giriş çalışmaya devam eder; ancak hesap silmede Apple
token’ı iptal edilemez ve fonksiyon bunu loglar.
