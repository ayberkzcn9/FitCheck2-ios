# FitCheck 1.0.32 (38) — Cihaz Test Rehberi

Paket: `build\FitCheck-1.0.32+38.apk` (ayrıca `D:\yedekler`de)
Doğrulama: `com.fitcheck2.app` · versionCode 38 · versionName 1.0.32 · imza geçerli

Kurulum: `adb install -r build\FitCheck-1.0.32+38.apk`
(veya APK'yı telefona atıp elle kur)

> Not: Bu sürüm **release** imzalı. Zaten Play'den 1.0.29+35 kuruluysa imza aynı
> olduğu için üzerine kurulur; veriler (dolap, favoriler) korunur.

---

## 1. Dolap — arama ve filtre (yeni)

- [ ] Dolap sekmesine gir → üstte arama kutusu ve **Tümü / Üst / Alt / Ayakkabı / Aksesuar**
      çipleri görünüyor
- [ ] Arama kutusuna "beyaz" yaz → sonuç sayacı ("N Ürün") güncelleniyor
- [ ] Eşleşmeyen raflar gizleniyor, "Üst" gibi başlıklar boş kalmıyor
- [ ] "Aksesuar" çipine bas → yalnız o raf kalıyor
- [ ] "Palto" gibi bulunmayan bir kelime → "Aramanla eşleşen parça yok." + "Aramayı temizle"
- [ ] **Kontrol:** AI'ye "ceket" kategorili bir parça ekle → dolapta **Üst** rafında görünmeli
      (eskiden hiçbir rafta görünmüyordu)

## 2. Stil Günlüğü — takvimde güne kombin atama (yeni)

- [ ] Stil Günlüğüm → Takvim → **bugüne** dokun → "Bu güne kombin seç" çıkar
- [ ] Dokun → üç bölüm: **ÖNERİLER** (kural bazlı, anında), **FAVORİLERİM**, **SON GİYİLENLER**
- [ ] Bir kombin seç → "Kombin güne eklendi" → gün hücresinde artık **küçük görsel** var
- [ ] Güne tekrar dokun → plan kartı (başlık + "N parça" + parça görselleri), **Değiştir** / **Kaldır**
- [ ] **Kaldır** → "Plan kaldırıldı" → **Geri al** → plan geri geliyor
- [ ] **Bugün** sekmesine dön → "BUGÜN PLANIN" kartı görünmüyor/var mı kontrol et
      (yoksa Stil Günlüğü'nden çıkışta tazelenir)
- [ ] Gelecek bir güne de kombini atayabiliyorsun, **geçmiş güne atayamıyorsun**

## 3. Bilgi (ⓘ) düğmeleri (yeni)

- [ ] Profil → "Dolap Verimliliği" başlığının yanındaki ⓘ → açıklama geliyor
- [ ] Aynı ⓘ'ler: Stil Kimliğin, Anlık Durum, Çamaşır Sepeti, Renk Paleti,
      Kategori Dağılımı, Kahramanlar, Unutulanlar
- [ ] Bugün → "Bugünün kombini" ⓘ → "günde en fazla bir yapay zekâ isteği" açıklaması
- [ ] Stil Günlüğü → Rapor sekmesi → sayıların yanındaki ⓘ'ler
- [ ] Düello → "Nasıl oynanır?" ⓘ → puanlama kuralları
- [ ] Dolap → başlıktaki ⓘ → arka plan silme / AI analizi açıklaması
- [ ] Alt sayfayı **kapat** düğmesi ve dışarı dokunarak kapatılabiliyor

## 4. Kamera izni gerekçesi (yeni)

- [ ] Dolap → fotoğraf ekle → kamera seç → önce **gerekçe sayfası** çıkıyor
      ("Kamerayla kıyafet ekle", "Şimdi değil")
- [ ] "Şimdi değil" → sistem izin penceresi **açılmıyor**
- [ ] "İzin Ver" → sistem penceresi açılıyor → fotoğraf çekiliyor

## 5. Regresyon (daha önce çalışan yerler)

- [ ] Alt menü 6 sekme, ikon + etiket: Bugün, Dolap, Plan, Kombin, Profil, Düello
- [ ] Bildirim → dokununca doğru sekmeyi açıyor (bugün / plan / düello)
- [ ] Akşam 21:00 plan hatırlatıcısı ayarlarda açılıp kapanıyor
- [ ] Kombin Düellosu: lobi → tur → geri bildirim → sonuç akışı
- [ ] Kombin paylaşma (paylaş kartı), raf aksiyonları (bugün giydim / kombin kur)
- [ ] Profil & Analiz: Dolap Verimliliği %0 ise (yeni eşya) doğru mu?
- [ ] Ayarlar → tema değişimi (koyu tema) ve bilgi düğmeleri koyu temada okunuyor mu?

---

## Sorun bildirirken

- Hangi adımda olduğunu yaz (örn. "2. adım, Değiştir'e basınca")
- Ekrana ait ekran görüntüsü
- Mümkünse cihazın Android sürümü
