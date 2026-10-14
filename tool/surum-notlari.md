# FitCheck — Sürüm Notları (Play Store)

## Sürüm 1.0.25+31 — 9 Ekim 2026

### 🇹🇷 Türkçe (Play Store "Yenilikler" alanına kopyalayın)

```
🆕 Bu Sürümde Neler Var?

⭐ Uygulama değerlendirmesi: Deneyiminizi tek dokunuşla paylaşabilirsiniz
🛠️ Kombin oyunu iyileştirmeleri ve hata düzeltmeleri
🚧 Kombin Oyunu çok yakında sizlerle!
⚙️ Performans ve kararlılık iyileştirmeleri

Geri bildirimleriniz için teşekkürler! 💜
```

*(≈290 karakter — Play Store 500 karakter sınırı içinde)*

### 🇬🇧 English

```
🆕 What's New

⭐ App rating: Share your experience with one tap
🛠️ Outfit game improvements and bug fixes
🚧 Outfit Game coming soon!
⚙️ Performance and stability improvements

Thanks for your feedback! 💜
```

### 📋 Bu sürümdeki teknik değişiklikler (dahili not)

1. **Kritik hata düzeltildi:** `kombin_oyunu_ekrani.dart` içinde `_kombinleriHazirla()` metodunun
   kapatma parantezi eksikti — uygulama derlenemiyordu.
2. **Oyun mantığı düzeltildi:**
   - Kategori eşleşmesi: `'ayakkabı'` (Türkçe ı) yerine ASCII `'ayakkabi'` kullanıldı —
     artık dolaptaki ayakkabılar gerçekten kullanılıyor.
   - Seçenek etiketleri: `kombinSecenekCustom_xxx` ham anahtarı yerine gerçek ürün adı
     (`gorunenBaslik`) gösteriliyor.
   - Doğru cevap mantığı: doğru = renk uyumlu, yanlış = aynı kategoriden uyumsuz renkli
     (oyuncu artık renklere bakarak ayırt edebilir).
   - Fallback swap hatası düzeltildi (`dogruIndex: dogruIdx`).
3. **Oyun gizlendi:** Play Store yayını için `_oyunEtkin = false` — "Yakında" ekranı gösterilir,
   sekme etiketi "Yakında" yapıldı. Geri açmak için `true` yapın.
4. **Değerlendirme istemi eklendi:** `in_app_review` paketi ile 2. açılışta (ve reddedilirse
   her 3 açılışta bir) Google Play puan penceresi gösterilir. 12 dile çevrildi.
5. **"Yakında" ekranı 12 dile çevrildi:** Sekme etiketi ve ekran metinleri artık
   `yakinda` / `yakindaAciklama` anahtarlarıyla yerelleştirilmiş (hardcode Türkçe değildi).
6. Temizlik: kullanılmayan değişkenler/fonksiyonlar/importlar kaldırıldı.

### 🔖 Sonraki sürümler için notlar

- Sürüm numarası `pubspec.yaml` içinde: `version: 1.0.25+31`
  (Play Store'daki son yüklenen bundle: 30 / 1.0.24 → 31 > 30 ✓ her yüklemede artırılmalı)
- Derleme: `powershell -ExecutionPolicy Bypass -File tool/release.ps1` (obfuscate + split-debug-info)
- Oyunu yeniden açarken: `_oyunEtkin = true` + sekme etiketini `'Kombin Oyunu'` yap
