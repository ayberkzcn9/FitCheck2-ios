# kombin_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Release (Yayın) Derlemesi

⚠️ Release derlemesini **her zaman** karartma açık şekilde alın. `flutter build ... --release`
komutunu bayraksız çalıştırmak Dart kodunu karartmaz; APK/AAB içinde sınıf ve
metot isimleri okunabilir kalır.

Bunun için hazır script:

```powershell
powershell -ExecutionPolicy Bypass -File tool/release.ps1            # App Bundle (Play Console)
powershell -ExecutionPolicy Bypass -File tool/release.ps1 -Hedef apk # APK (elle dağıtım/test)
powershell -ExecutionPolicy Bypass -File tool/release.ps1 -Hedef ipa # iOS
```

VS Code'da **Terminal → Run Task → "Release: AAB (karartılmış)"** veya
**"Release: APK (karartılmış)"** de kullanılabilir.

Script her seferinde şu komutu çalıştırır ve sembolleri arşivler:

```bash
flutter build appbundle --release --obfuscate --split-debug-info=build/symbols
```

- `--obfuscate`: Dart sembollerini karartır.
- `--split-debug-info=build/symbols`: hata ayıklama sembollerini paketten ayırır.
  Oluşan `build/symbols` klasörünü **saklayın**; aksi hâlde çökme raporlarını
  okuyamazsınız. Script bu dosyaları `build/sembol-arsivi/<tarih>-<hedef>`
  altına kopyalar. `build/` sürüm kontrolünde tutulmadığı için arşivi kalıcı bir
  yere (ör. sürüm çıktı klasörü veya depolama) kopyalamayı unutmayın.
- Karartmanın etkin olduğunu doğrulamak için: paket içindeki `libapp.so` dosyasında
  sınıf adları (ör. `ReklamsizPremiumEkrani`) aranabilir; bulunuyorsa karartma
  uygulanmamış demektir. Karartılmış build'lerin `libapp.so` boyutu da belirgin
  şekilde küçülür.

Yayınlanan sürümün Java/Kotlin (R8) çökme kayıtlarını okuyabilmek için
`build/app/outputs/mapping/release/mapping.txt` dosyası gerekir. **AAB
yüklerken elle yüklemeniz gerekmez:** AGP 4.1 ve sonrası, eşleme dosyasını
paketin içine gömer; Play Console bunu otomatik alır. Bu projede gömülü kopya
`base/.../BUNDLE-METADATA/com.android.tools.build.obfuscation/proguard.map`
yolundadır ve diskteki `mapping.txt` ile birebir aynıdır.

Elle yükleme yalnızca APK ile yayınlıyorsanız gerekir (veya AAB durumunda
Play dosyayı almadıysa): Play Console → **Test ve yayınlama** → **Uygulama
paketi gezgini** → sağ üstten sürümü seç → **İndirilenler** sekmesi →
"Varlıklar" bölümündeki yükleme okundan eşleme dosyasını yükleyin.

#### Sorun giderme: "Release app bundle failed to strip debug symbols"

AAB üretilir ama derleme bu hatayla biter ve çıkış kodu 1 olur. Nedeni derleme
değil, Flutter'ın sonrasında yaptığı doğrulamadır: `apkanalyzer` aracıyla
paketteki `libapp.so.sym` / `libflutter.so.sym` dosyalarına bakar. Bu araç
Android SDK içindeki **cmdline-tools**'ta bulunur; SDK'da bu klasör yoksa
doğrulama çalışamaz.

Çözüm — resmî komut satırı araçlarını kurun:

1. https://dl.google.com/android/repository/commandlinetools-win-16111833_latest.zip indirin.
2. Arşivdeki `cmdline-tools` klasörünün **içeriğini** `<sdk>\cmdline-tools\latest\`
   altına çıkarın (sonuç: `<sdk>\cmdline-tools\latest\bin\apkanalyzer.bat`).
3. `flutter doctor` artık bu uyarıyı vermemeli.

Ayrıca SDK lisansları için bir kez `flutter doctor --android-licenses` çalıştırın.

Çökme kaydını okunabilir hâle getirmek için:

```bash
flutter symbolize -i <stack_trace_dosyasi> -d build/symbols/app.android-arm64.symbols
```

### Android (R8) optimizasyonu

`android/app/build.gradle.kts` içindeki `release` yapılandırmasında
`isMinifyEnabled` ve `isShrinkResources` açıktır; R8 de "full mode" ile çalışır.
Kuralların tamamı Flutter embedding, Firebase, Google Play Services/AdMob,
AndroidX ve Kotlin tarafından AAR içinde (consumer rules) zaten sağlanır.

⚠️ `android/app/proguard-rules.pro` dosyasına `-keep class com.google.** { *; }`
gibi geniş kurallar **eklemeyin**. Bu tür kurallar R8'in kod daraltma ve
karartma yapmasını engeller; Play Console'daki "Optimizasyon / Kod karartma /
Daraltma" yüzdelerinin düşük kalmasına neden olur.

Not: `com.google.android.gms.**` gibi bazı isimlerin pakette okunabilir kalması
normaldir; bunları ilgili SDK'ların AAR içindeki kendi kuralları korur. R8'in
çalıştığının kanıtı `build/app/outputs/mapping/release/mapping.txt` dosyasıdır:
uygulama ve eklenti sınıfları tek harfli isimlere yeniden adlandırılmış olarak
orada görünür.

#### Play Console "Uygulama optimizasyonu" yüzdeleri

Play Console bu üç yüzdeyi **yüklenen AAB'nin içindeki DEX kodu** üzerinden
hesaplar ve her yüklenen paket için ayrı ölçer.

Bu projede ölçülen değerler (AAB içindeki
`BUNDLE-METADATA/.../proguard.map` dosyasıyla doğrulandı):

| Ölçüm | Değer |
| --- | --- |
| Toplam sınıf | 15.722 |
| Adı değiştirilmiş (karartılmış) | 4.843 (%30,8) |
| `com.google.android.**` payı | 11.850 (%75); bunların yalnızca ~%10'u karartılmış |
| `com.google.android.gms.internal.ads` (AdMob) | 6.650 sınıf (tüm kodun %42'si) |

Yani yüzdeyi düşüren şey uygulama kodu değil, AdMob'un ve Google Play
Services'in **kendi** sınıflarıdır; isimlerini bu SDK'ların kendi consumer keep
kuralları korur ve projeden karartılamaz. Reklam SDK'sı kaldığı sürece ~%30
normaldir. Kendi kodunuzda karartma oranı ~%100'dür (pakette okunabilir kalan
tek uygulama sınıfı `com.fitcheck2.app.MainActivity`).

Yüzdeleri yükseltmek için yapılabilecekler:

* Raporun analiz ettiği sürümün `pubspec.yaml` sürümüyle aynı olduğunu
  doğrulayın; yeni AAB yüklendikten sonra rapor bir süre sonra güncellenir.
* Kullanılmayan bağımlılıkları kaldırın. `lib/` içinde import edilmeyen bir
  paket native kod getiriyorsa DEX'ten de düşer. Bu nedenle kullanılmayan
  `google_fonts`, `adaptive_theme`, `image`, `showcaseview` ve
  `package_info_plus` bağımlılıkları kaldırılmıştır.
* Reklam SDK'sını küçültmek (`play-services-ads-lite`) karartma yüzdesini
  artırabilir ancak mediation kodunu kaldırır ve çalışma zamanı riski taşır;
  gerçek cihazda test edilmeden uygulanmamalıdır.
