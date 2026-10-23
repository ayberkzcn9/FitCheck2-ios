# FitCheck Tasarım Sistemi

Sürüm: 1.0.33+52 · Son güncelleme: 22.10.2026

Bu doküman uygulamanın tasarım yöntemini tanımlar. Kodda bir karar
verildiğinde buraya bakılır; "neden böyle" sorusunun tek cevabı budur.

---

## 1. Yöntem: Material 3 + Marka Token Katmanı

Uygulama **iki katmanlı** bir tasarım sistemi kullanır:

| Katman | Nerede | Ne yapar |
|---|---|---|
| **1. Yapı** | Flutter Material 3 | Bileşen anatomisi, erişilebilirlik davranışı, etkileşim kalıpları |
| **2. Marka** | `lib/theme/app_tema.dart` + `lib/theme/design_tokens.dart` | Renk paleti, ölçü, tipografi, hareket |

Yani **M3'ün yapısı, markanın yüzeyi**. M3 renk şeması `fromSeed` ile
üretilir, sonra rol renklerinin (primary, primaryContainer, surface ramp,
outline…) tamamı elle marka değerleriyle değiştirilir.

M3'ün gölge/tonal yükselti mekanizması kullanılmaz; yüzeyler `Container`
+ `BoxDecoration` ile elle kurulur. Bu bilinçli bir tercihtir: uygulama
krem zemin üzerinde ince kenarlı kartlar kullanır, yükseltili kart gölgeleri
değil.

### Referans havuzu

Akış kalıpları Mobbin'den alınmıştır (`mobbin-ui-ux-inceleme.md`):
dijital dolap akışları, izin öncesi gerekçe ekranı, geri alma onayı,
paywall deneme süresi. **Desen alınır, görsel kopyalanmaz.**

---

## 2. Token katmanı

Tüm ölçüler tek kaynaktan gelir. Ekranda sabit sayı yazılmaz.

### `AppTema` — renk şeması
`lib/theme/app_tema.dart`. Açık ve koyu `ColorScheme` tek yerdedir. Hem
uygulama (`main.dart`) hem ekran görüntüsü testi (`test/ui_inceleme_test.dart`)
aynı kaynağı kullanır — bu yüzden inceleme görüntüleri gerçek görünümle
birebir aynıdır.

### `AppAccents` — anlam renkleri
| Token | Değer | Anlam |
|---|---|---|
| `primary` | `#0F5F4A` | Marka zümrütü, birincil eylem |
| `success` | `#1F7A5A` | Onay, tamamlandı |
| `successDark` | `#0F5F4A` | Koyu yeşil metin |
| `warning` | `#D97706` | Uyarı |
| `error` | `#DC2626` | Hata |
| `info` | `#30827D` | Bilgi |
| `styleist` | `#2E6E5E` | Stilist özelliği |

Kırmızı ve amber **anlam taşıdığı için** marka paletinin dışında tutulur.

### `AppText` — punto ölçeği
15 basamaklı tek ölçek. **En küçük punto 12** (erişilebilirlik alt sınırı).

```
sizeMicro 12 · sizeCaption 12 · sizeSmall 13 · sizeBodySmall 14
sizeBody 15 · sizeBodyLarge 16 · sizeTitleSmall 18 · sizeTitle 20
sizeTitleLarge 22 · sizeHeadline 24 · sizeDisplay 26 · sizeDisplayLarge 32
sizeEmoji 42 · sizeDisplayHuge 44
```

### `AppSpacing` — dolgu ölçeği
`xxs 2 · xs 4 · sm 8 · md 12 · lg 16 · xl 20 · xxl 24 · xxxl 32`

### `AppRadius` — köşe ölçeği
`xxs 2 · xs 4 · sm 8 · md 12 · lg 16 · xl 20 · xxl 24 · modal 32 · full 999`

### `AppMotion` — hareket ölçeği
Material 3 hareket kuralları: kısa / orta / uzun süre, dört eğri.

| Süre | Ne zaman |
|---|---|
| `hizli` 150 ms | anlık geri bildirim (basma, rozet) |
| `kisa` 200 ms | küçük durum değişimi (seçim, vurgu) |
| `normal` 300 ms | liste/kart geçişi |
| `orta` 400 ms | kart/panel açılışı |
| `uzun` 600 ms | büyük geçiş (sayfa, açılır pencere) |

| Eğri | Ne zaman |
|---|---|
| `giris` | ekrana girerken (yavaşlayan) |
| `cikis` | ekrandan çıkarken (hızlanan) |
| `standart` | ekranda kalırken |
| `tepki` | hafif aşma (rozet) |

---

## 3. Uygulanan kurallar

### Renk
- Marka tonları **159–165°** aralığında (6 derece). Yeni bir marka rengi
  eklenirse bu aralıkta kalmalı.
- Kritik renk çiftlerinin tamamı **WCAG AA** (4.5:1 metin, 3:1 kenar).
- Anlam renkleri (kırmızı/amber) hariç tüm vurgular zümrüt ailesinde.
- **Nötrler sıcak taştır** (h ≈ 40–50°), soğuk gri değil. Metin, ikon ve
  kenarlıklar `onSurface` / `onSurfaceVariant` / `outline` tokenlarından gelir;
  sabit gri (`#F2F2F2`, `#4A4F49`, `Colors.grey`) yasak — kapı denetler.
- Uyarı/stilist kutularının zemini kart zemininden **ΔE ≥ 6** uzak olmalı;
  aksi hâlde kutu "boş/gri" görünür (ölçülen eski değer ΔE 2.8 idi).

### Tipografi
- Her punto `AppText` tokenından gelir. Sabit `fontSize: 14` yazılmaz.
- 10–11 pt yasak (erişilebilirlik).

### Ölçü
- Dolgu `AppSpacing`, köşe `AppRadius` tokenından gelir.
- Sayfa yatay boşluğu **20 pt** (`AppSpacing.xl`), tüm ana sekmelerde aynı.
- Kart köşesi **16 pt** (`AppRadius.lgRadius`).

### Başlık
- **Tüm AppBar'lar sola hizalı.** Ortalı başlık kullanılmaz (12 ekranda 0).

### Erişilebilirlik
- Dokunma hedefi en az **44×44 pt**.
- Metin kontrastı WCAG AA.
- 320 pt genişlikte taşma olmaz (çok dilli test ile doğrulanır).

### Yön
- Metin hizası `TextAlign.left/right` **kullanılmaz**; `start/end` kullanılır.
- Kenar boşlukları `EdgeInsetsDirectional.only(start:/end:)`.
- Konumlar `AlignmentDirectional.centerStart/centerEnd`.
- Arapça (RTL) dili `flutter test` içinde doğrulanır.

### Yerelleştirme
- 12 dil: `en, tr, it, es, zh, ar, fr, de, pt, ja, ko, ru`
- Kullanıcıya gösterilen **hiçbir metin** kodda sabit yazılmaz.
- Yeni metin eklenince 12 ARB dosyasına da eklenir, sonra
  `flutter gen-l10n` çalıştırılır.

### Durum kapsaması
Her ekran şu durumları ele alır: **boş**, **yükleniyor**, **hata**.
Ölçütü anlaşılmayan sayıların yanında **bilgi (ⓘ) düğmesi** bulunur;
düğme "Tamam" düğmesi ve tutamakla kapanan bir açıklama sayfası açar.

---

## 4. Kalite kapısı

Bütünlük bir kere değil, **her sürümde** doğrulanır:

```
python tool/tasarim_kapisi.py
```

Denetimler: renk kalıntısı · tema dışı Material rengi · WCAG kontrast ·
sabit punto · 10–11 pt · sabit yarıçap · sabit dolgu · ortalı başlık ·
mutlak left/right (RTL) · sabit Türkçe metin · 44 px altı dokunma hedefi ·
token dışı animasyon süresi.

Çıkış kodu 0 olmalı.

Ek olarak:

```
flutter test                                  # 325 test
flutter test test/ui_inceleme_test.dart       # 45 ekran görüntüsü + çok dilli
```

---

## 5. Bilinçli istisnalar

| Konu | Karar | Neden |
|---|---|---|
| Kırmızı / amber | Marka paletinin dışında | Anlam taşıyor (hata, uyarı) |
| Kıyafet renkleri | `AppDataColors` (lacivert, pembe, mor…) | Kullanıcının giysisinin rengi, veri; adı doğru gösterilmeli |
| Tema metni | Saf siyah/beyaz yok | Varsayılan metin `onSurface` (sıcak mürekkep) |
| Oyun ekranları | Mevcut paleti korur | Kapsam dışı, ayrı karar |
| Yükseltili kart gölgesi | Yok | Krem zemin üzerinde ince kenarlı kart tercih edildi |
