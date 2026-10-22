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

## 5. Dolaba eklerken yerleşim düzenleyici (yeni)

- [ ] Dolap → **+** → Galeriden / Kamerayla seç → AI kesimi bittikten sonra
      **yerleşim düzenleyici** açılıyor
- [ ] Tuvalde parçayı **sürükle**, iki parmakla **büyüt/küçült**
- [ ] Zemin seçenekleri: **Beyaz / Kırık beyaz / Açık gri / Saydam**
      (seçince tuvalin arkası hemen değişiyor)
- [ ] **Varsayılan** → otomatik yerleşime dönüyor
- [ ] **Kaydet** → "Kaydedildi" → parça dolapta seçtiğin zeminle görünüyor
- [ ] Saydam zemin seçip kaydet → parça **PNG** olarak (arka planı yok) duruyor
- [ ] Zemin seçmeden kaydet → parça eskisi gibi (otomatik) duruyor
- [ ] **Kontrol:** düzenleyiciyi kapatıp tekrar aç → son kaydettiğin yerleşim korunuyor

## 6. "Arka planda ekle" (yeni)

- [ ] Dolap → **+** → üç seçenek görünüyor: Galeriden, Kamerayla, **Arka planda ekle**
- [ ] "Arka planda ekle" → birden çok fotoğraf seçilebiliyor
- [ ] Seçimden sonra **tam ekran yükleme ekranı yok**; ekranın üstünde ince bir
      **ilerleme çubuğu** var ve uygulamayı kullanmaya devam edebiliyorsun
- [ ] Sekmeler arasında gezinirken yükleme devam ediyor
- [ ] Bitince özet bildirim: kaç parça eklendi, kaçı atlandı (kesilemeyenler)
- [ ] Atlandı bilgisi varsa hangi dosya olduğu yazıyor
- [ ] **Kontrol:** 3 fotoğraf seç → hepsi bitmeden Dolap'a gir → parçalar tek tek geliyor

## 7. Bugün - Kaydet / Giydim düğme durumları (yeni)

- [ ] Bugün → büyük kombin kartı → **Kaydet** (kontur düğme)
- [ ] Kaydettikten sonra düğme **dolu** oluyor ve **"Kaydedildi"** yazıyor
- [ ] Uygulamayı kapatıp aç → aynı kombin hâlâ **"Kaydedildi"** görünüyor
- [ ] **Giydim** → düğme yeşil tonlu **"Giydildi"** oluyor
- [ ] Aynı gün içinde uygulamayı kapatıp aç → **"Giydildi"** korunuyor
- [ ] Ertesi gün aynı kombin → düğme yeniden **"Giydim"** (dün giyilmiş sayılmıyor)
- [ ] Koyu temada her iki dolu durum da okunuyor (yeşil metin kontrastı)

## 8. Düelloda geri dönüş (yeni)

- [ ] Düello → başla → 2. soruyu cevapla → üst çubuktaki **‹** oku → 1. soruya dönüyor
- [ ] Geri bildirim panelindeki **Geri** düğmesi de aynı işi yapıyor
- [ ] Dönülen soruda **verdiğin cevap**, doğru/yanlış durumu ve **kazandığın XP**
      aynen görünüyor (XP yeniden hesaplanmıyor, artmıyor)
- [ ] **Devam** ile ileri gidince puan/seri bozulmuyor, tur sayacı doğru
- [ ] 1. soruda geri oku **görünmüyor**
- [ ] Geri dönüp son soruya kadar ilerleyip "Sonucu gör" deyince XP **iki kez**
      yazılmıyor (profil/XP toplamı bir tur kadar artıyor)

## 9. Regresyon (daha önce çalışan yerler)

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
