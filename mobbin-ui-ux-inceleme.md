# Mobbin → FitCheck: UI/UX Referans İncelemesi

Tarih: 21.10.2026 · Sürüm bağlamı: 1.0.32+37

---

## 0. Kısa cevap

Evet, var — ama "hazır tasarım indirip kullanmak" şeklinde değil.
Mobbin gerçek uygulamalardan **ekran ve akış (flow) kütüphanesi**; bizim ürünümüze en
yakın gerçek ürün orada **Whering** (dijital dolap) ve akışları neredeyse birebir
bizim ekranlara denk geliyor.

En değerli bulgu: Mobbin'in **kendi MCP sunucusu** var
(`https://api.mobbin.com/mcp`, OAuth, Pro/Team/Enterprise).
Bağlanırsa `search_screens` / `search_flows` ile referansları doğrudan bu sohbete
çekebilirim — tahminle değil, gerçek ekranlarla çalışırız. (Bkz. bölüm 6.)

> Not: Aşağıdaki inceleme Mobbin'in **herkese açık akış adları, akış açıklamaları ve
> ürün davranışları** üzerinden yapıldı. Ekran görüntülerinin tamamı üyelik istiyor;
> bu yüzden "piksel" değil "desen" öneriyorum.

---

## 1. Mobbin'de erişim gerçeği

| Ne | Durum |
|---|---|
| Akış adları + adım adım açıklamalar | Herkese açık (arama sonuçlarında okunuyor) |
| Ekran görüntüleri (tam boy) | Üyelik gerekiyor |
| Figma/tasarım dosyası indirme | Yok |
| MCP (ajanla arama) | Pro ve üstü planlarda |

Mobbin'in kendi dokümanı da şunu söylüyor, bizim için de geçerli:
"Bir örnek, o ürünün bu tasarımı kullandığını gösterir; işe yaradığını kanıtlamaz.
Yaygın bir desen, otomatik olarak en iyi pratik değildir. Korumalı tasarımları,
marka öğelerini ve metinleri birebir kopyalamayın."
Yani doğru kullanım: **akış ödünç almak, görsel kopyalamak değil.**

---

## 2. Doğrulanmış referans envanteri (bizim kategori)

| Ürün | Mobbin'de doğrulanan akış/ekran | Bizdeki karşılığı |
|---|---|---|
| **Whering** (dijital dolap, iOS) | `Wardrobe` akışı (5 ekran) | Dolap sekmesi |
| Whering | `Assigning an outfit to a date` (Scheduling akışı) | Plan + Stil Günlüğüm takvimi |
| Whering | `Archiving an outfit` (onay + **geri al**) | Kombin/favori silme, "Bugün giydim" geri alma |
| Whering | `Archiving an item` (onay + geri al) | Parça silme |
| Whering | Ekran: `User Wardrobe` (yüklenen parçalar ızgarada) | Profil / Dolap |
| Whering | Ekran: `Item Added Confirmation` (**checkmark** ile "eklendi") | Toplu fotoğraf ekleme sonucu |
| **lululemon** (iOS) | `Placing an order`, `Comparing products` | Bize uzak (satış yok) — sadece ürün karşılaştırma fikri |
| **SSENSE** (iOS) | `Resetting password` vb. | Hesap/şifre akışları |
| **Pinterest** | Estetik/ilham ekranları | İlham panosu (bizde yok) |

### Mobbin'in akış kataloğu — hangi desende ne kadar referans var

Aşağıdaki sayılar Mobbin'in halka açık akış sayfasından; "bu desende ne kadar
malzeme var" sorusunun cevabı:

| Akış kategorisi | Akış sayısı | Bizde nerede işe yarar |
|---|---|---|
| Adding & Creating | 5.705 | Parça ekleme, kombin oluşturma |
| Searching & Finding | 3.131 | **Dolapta arama (bizde yok)** |
| Selecting & Choosing | 3.050 | Kategori/parça seçimi, düello cevapları |
| Filtering & Sorting | 2.560 | **Dolap filtre/sıralama (bizde yok)** |
| Uploading & Downloading | 1.629 | Fotoğraf yükleme, rapor paylaşımı |
| Starting & Completing | 1.448 | Onboarding, düello turu |
| Setting Up | 1.024 | İlk kurulum, dolap kurulumu |
| Enabling & Disabling | 869 | **İzin öncesi "neden" ekranı** |
| Subscribing & Upgrading | 709 | Premium/paywall |
| Showing & Hiding | 516 | Gizle/göster (kombin detayı, raf) |
| Favoriting & Pinning | 449 | Favori kombinler |
| Logging & Tracking | 433 | **Giyilme geçmişi, rapor** |
| Marking | 402 | "Bugün giydim" işaretleme |
| Scanning | 365 | Barkod/etiket tarama (ileride) |
| Taking Photos | 321 | **Kıyafet fotoğrafı çekimi** |

---

## 3. Ekran ekran eşleme: ne alıyoruz, neyi değiştiriyoruz

### 3.1 Dolap → arama + filtre (en yüksek getiri)

**Referans:** Mobbin `Searching & Finding` (3.131) + `Filtering & Sorting` (2.560).
Whering'in dolabı kategori sekmeleri + arama ile çalışıyor.

**Bizim durum (kodda doğrulandı):** `gardirobum_ekrani.dart` içinde arama yok;
filtre/sıralama yok. Tek `TextField`, *parça ekleme diyaloğundaki* isim alanı.
Kategori seçimi de sadece ekleme diyaloğunda bir `DropdownButton`.

**Sonuç:** 70 parçalı bir dolapta "siyah gömlek" bulmak imkânsız. Bir dolap
uygulaması için en temel işlev.

**Alınacak desen:**
1. Liste üstünde sabit arama çubuğu (dolap kaydırılınca kaybolmaz).
2. Kategori çipleri: Tümü / Üst / Alt / Dış / Ayakkabı / Aksesuar + "Temiz" filtresi.
3. Aktif filtreler **çip olarak** görünür ve tek dokunuşla kalkar (Mobbin'de standart).
4. Sonuç sayısı: "24 parça" — filtre işe yaradı mı sorusunu yanıtlar.
5. Sonuç yoksa boş durum: "Bu filtrede parça yok · Filtreleri temizle".

**Emek:** ~yarım gün · **Risk:** düşük (sadece dolap listesi görünümü).

### 3.2 Stil Günlüğü takvimi → güne kombin atama

**Referans:** Whering `Assigning an outfit to a date`. Whering'in kendi akışı:
takvimde günü seç → **+** → *mevcut kombini seç / kombinleri karıştır / AI önerisi* →
güne ata. Ayrıca kayıtlı kombinden "Add to calendar".

**Bizim durum:** takvimde güne dokunmak sadece `_gunDetayi` açıyor (okuma).
Güne kombin **ekleme** yok; plan oluşturmak için Haftalık Planlayıcı'ya gitmek gerekiyor.

**Alınacak desen:** güne dokun → alt sayfa: **"Favorilerimden ekle · AI öner · Boş bırak"**.
"AI öner" bizim `GunlukKombin`/feed motoruyla yapılabilir; yeni servis gerekmez.
Bu, Stil Günlüğü'nü "geçmişe bakılan yer" olmaktan çıkarıp "planlanan yer" yapar.

**Emek:** ~1 gün · **Risk:** orta (takvim + kayıt akışına dokunuyor).

### 3.3 Parça ekleme sonucu → "eklendi" onayı

**Referans:** Whering ekranı `Item Added Confirmation` — eklenen parçalar ızgarada
**checkmark** ile işaretlenir, kullanıcı toplu eklemenin sonucunu tek bakışta görür.

**Bizim durum:** toplu fotoğraf ekleme var (`_topluFotografEkle`), sonunda sadece
snackbar.

**Alınacak desen:** toplu ekleme bitince "3 parça eklendi" özet sayfası veya
ızgara üzerinde checkmark + "Bitti" düğmesi. Kullanıcı arka plan silmenin
çalıştığını görür (bizde arka plan silme 5 sn sürebiliyor).

**Emek:** ~yarım gün · **Risk:** düşük.

### 3.4 Silme/geri alma → onay yerine "geri al"

**Referans:** Whering `Archiving an outfit` / `Archiving an item` — işlem sonrası
**geri alma** sunulur; ağır onay diyaloğu yok.

**Bizim durum:** son sürümde "Bugün giydim" için bunu zaten yaptık (snackbar + Geri al).
Kombin/favori silmede hâlâ onay diyaloğu var.

**Alınacak desen:** tek dokunuşla sil + 5 sn "Geri al". Onay diyaloğu yalnızca
**geri dönüşü olmayan** işlemlerde (hesabı sil, geçmişi temizle) kalsın.

**Emek:** ~2 saat · **Risk:** düşük.

### 3.5 İzin akışı → önce gerekçe, sonra sistem izni

**Referans:** Mobbin `Enabling & Disabling` (869 akış) — izin istemeden önce
"bunu neden istiyoruz" ekranı (permission priming).

**Bizim durum (kodda doğrulandı):** `_izinKontrolEtVeGoster` her açılışta konum
veya kamera izni yoksa doğrudan `IzinDiyalogu.goster(context)` çağırıyor.

**Alınacak desen:** ilk açılışta onboarding'den sonra tek seferlik "Konumunu
kullanarak bugünün havasına göre kombin öneriyoruz" ekranı → "Devam" → sistem izni.
Reddedilirse bir daha açılışta sorma, ilgili yerde mikro-uyarı göster.

**Emek:** ~2 saat · **Risk:** düşük · **Kazanç:** izin kabul oranı + ilk açılışta
"üst üste iki diyalog" hissinin kalkması.

### 3.6 Paywall → zaten iyi, tek eksik deneme zaman çizelgesi

**Referans:** `Subscribing & Upgrading` (709 akış).

**Bizim durum:** `reklamsiz_premium_ekrani.dart` aylık/yıllık yan yana, deneme
rozeti (`premiumDenemeRozeti(7)`), "deneme sonrası fiyat" metni ve yıllık tasarruf
yüzdesi var. Mobbin'deki iyi örneklerin çoğundan geri değil.

**Eksik:** gün gün **deneme zaman çizelgesi** (bugün ücretsiz → 5. gün hatırlatma →
7. gün ücret) ve iptal koşulunun tek satırda yazması.

**Emek:** ~3 saat · **Risk:** düşük.

### 3.7 Kıyafet fotoğrafı çekimi → çekim rehberi

**Referans:** `Taking Photos` (321 akış).

**Bizim durum:** kamera + arka plan silme var (`background_remover_service.dart`,
isnet/silüet hibrit). Çekim sırasında yönlendirme yok.

**Alınacak desen:** çekim ekranında soluk **silüet çerçevesi** + tek satır ipucu
("Parçayı düz, açık bir zemine koy"), çekim sonrası "arka plan siliniyor" durumu,
sonuç önizlemesi.

**Emek:** ~yarım gün · **Risk:** düşük · **Kazanç:** kötü fotoğraf = kötü kombin
önerisi zincirini baştan keser.

---

## 4. Öncelik sırası (1.0.33 için önerim)

| # | İş | Referans | Etki | Emek |
|---|---|---|---|---|
| 1 | Dolap arama + filtre çipleri + sonuç sayısı ✅ (1.0.32) | Searching & Finding / Filtering & Sorting | Yüksek | 0,5 gün |
| 2 | Takvimde güne "favoriden / AI öner" ile kombin ekle ✅ (1.0.32) | Whering Assigning an outfit to a date | Yüksek | 1 gün |
| 3 | İzin öncesi gerekçe ekranı | Enabling & Disabling | Orta-yüksek | 2 saat |
| 4 | Silmede onay yerine "geri al" | Whering Archiving + undo | Orta | 2 saat |
| 5 | Toplu ekleme sonunda checkmark özeti | Whering Item Added Confirmation | Orta | 0,5 gün |
| 6 | Çekim rehberi (silüet + "arka plan siliniyor") | Taking Photos | Orta | 0,5 gün |
| 7 | Paywall deneme zaman çizelgesi | Subscribing & Upgrading | Düşük-orta | 3 saat |

### 4.1 Bu turda yapılanlar (21.10.2026)

Mobbin'den bağımsız, kendi denetimimizdeki "sistem disiplini" borcu azaltıldı:

- **Rapor ekranı** yenilendi: 44 pt büyük sayı, geçen haftaya göre fark çipi,
  4 haftalık çubuk grafik, en çok giyilen 3 parça (görselli), sıfır değerli
  satırlar gizli. Paylaşılan PNG aynı karttan üretildiği için otomatik güncel.
- **Bugün tek ızgara**: 4 hızlı işlem + "Stil Günlüğüm" + "Seyahat Modu"
  3×2 ızgarada; sayfa sonundaki ayrı kart ikilisi kaldırıldı.
- **Alt menü**: simge altına etiket (9–10 pt), seçim göstergesi nokta yerine
  renk + kalınlık; 320 dp'de taşma testi eklendi.
- **Tek cam bulanıklığı**: 7 farklı sigma (5–70) → `AppBlur.cam = 12`
  (arka plan degradesi 70 olarak ayrıldı); 48 kullanım tek değere indi.
- **Ölçek sadeleşti**: yarıçap 20 → 11 farklı değer (16/12/24/8/…),
  yazı boyutu 19 → 15; `AppRadius`/`AppText` dışına taşan ara değerler temizlendi.

Açık kalan en büyük borç: **gömülü renkler**. İlk sayım (113) yanıltıcıydı;
kırılımı: 57 kullanım `design_tokens.dart` (paletin kendisi), 42 kullanım
`main.dart` (açık/koyu `ColorScheme`). Ekranlarda kalan 39 kullanımın 11'i
token'a bağlandı (`AppAccents.successDeep` = Düello "doğru" yeşili,
`AppAccents.primary` = bildirim metni). Kalan 28 değer bilinçli yerel:
onboarding degrade çiftleri, profil renk kartelası (ten/saç/göz tonları),
koyu mod amber metin tonları.

### 4.2 Dolap arama + filtre (bu tur)

Mobbin'deki **Searching & Finding** / **Filtering & Sorting** desenleri uygulandı:

- Rafların üstünde **arama kutusu**: başlık, renk, stil ve kategori metninde
  büyük/küçük harf duyarsız arar; sağda "temizle" düğmesi.
- **Kategori çipleri**: Tümü / Üst / Alt / Ayakkabı / Aksesuar; seçili çip koyu
  dolgulu, yatay kaydırmalı (320 dp'de taşmaz).
- Filtre açıkken **eşleşmeyen raflar gizlenir** ve tek bir "N Ürün" sayacı
  kalır (raf başlıklarındaki sayı tekrarı bastırıldı).
- Eşleşme yoksa "Aramanla eşleşen parça yok." + "Aramayı temizle" düğmesi.
- **Veri hatası düzeltmesi (kayıp parça):** AI'nin döndürdüğü serbest kategori
  ('ceket', 'pantolon', 'çanta'…) rafta `==` ile karşılaştırılıyordu; bu parçalar
  hiçbir rafta görünmüyordu. Artık `kategoriModeldenCikar` + aksesuar kelime
  listesiyle çözülüyor, tanınmayan değerler üst rafına düşüyor (kaybolmuyor).
- Kurallar `lib/utils/dolap_filtresi.dart` içinde **saf fonksiyon**:
  11 birim testi + 4 widget testi (arama, çip, sayaç, boş durum).
- Görsel kontrol: `build/ui-review/14_gardirobum.png`, `15_gardirobum_arama.png`.

### 4.3 Takvimde güne kombin atama (bu tur)

Whering'in **Assigning an outfit to a date** akışı: takvim artık bir "geçmiş
okuma" ekranı değil, **planlama** ekranı.

- **Tarihe özel plan**: `planli_kombinler` deposunda `tarih → {başlık, parçalar}`.
  Haftalık program (gün adına bağlı) ile karışmaz; tarihe özel plan her zaman
  önceliklidir.
- **Gün hücresi** planlıysa parçanın küçük görselini taşır (nokta yerine).
- **Gün detayı** artık eylem alan: plan kartı (başlık + parça sayısı + parça
  görselleri) + **Değiştir** / **Kaldır**; plan yoksa ve gün geçmiş değilse
  "Bu güne kombin seç".
- **Seçim sayfası**: favoriler (görsel + ad + tarz). Favori yoksa boş durum ve
  "Kombin oluştur" düğmesi doğrudan Kombin sekmesine gider.
- **Bugün kartı**: bugüne atanmış plan varsa "BUGÜN PLANIN" kartı görünür;
  dokununca Stil Günlüğü açılır. Plan değişince kart `planJetonu` ile tazelenir.
- **Bildirimler**: sabah/akşam serileri tarihe özel planı okur; plan varsa
  bildirimde o kombin adı yazar (haftalık program yedek olarak kalır).
- Geçmiş günler salt okunur (yanlış kayıt yapılmasın).
- **Test:** 15 test (model, depo, takvim birleşimi, bildirim eşlemesi, 4 arayüz
  testi) + görsel kontrol `16_takvim_plan`, `17_gun_plani`, `18_kombin_secimi`.
- Seçim sayfası iki kaynak gösteriyor: **FAVORİLERİM** ve **SON GİYİLENLER**
  (geçmiş kaydındaki parçalar virgülden ayrıştırılıyor, en fazla 5, tekrarsız).
- Üçüncü kaynak **ÖNERİLER**: kural bazlı üretici (aynı motor Bugün akışının
  yedek yolu) — çevrimdışı, anında, ücretsiz; ağ çağrısı yok.

### 4.4 İzin öncesi gerekçe (Mobbin #3)

"Fotoğraf çek"e basınca kullanıcı **sistem izin penceresini** boş bir
istekle görüyordu. Artık önce kendi gerekçemiz gösteriliyor:

- Yeni `IzinGerekce.goster()` (cam panel, ikon, başlık, açıklama, "İzin Ver" +
  "Şimdi değil"): kamera isteğinden önce **neden** ve **verinin nereye gittiği**
  anlatılıyor (fotoğraf cihazdan çıkar, arka plan silme ve analiz sunucuda,
  kalıcı saklanmaz).
- Kullanıcı "Şimdi değil" derse sistem izni hiç istenmiyor.
- Bildirim izni **ayarlardaki anahtar ile** isteniyor (kullanıcı eylemi net),
  orada ayrı gerekçe sayfasına gerek yok.

### 4.5 Renk tutarlılığı (bu tur)

- Haftalık plan ekranındaki ana CTA **yeşildi** (`Colors.green.shade600`),
  uygulamadaki diğer birincil düğmeler koyu/siyah. Artık `colorScheme.primary`
  (aynı token ailesi) — birincil eylem rengi tek kaynaktan geliyor.
- "Giyildi" rozetlerindeki ham `Colors.green` yerine `AppAccents.success`
  (#16A34A) kullanılıyor; böylece "gri/gri tonları" dışındaki gömülü
  `Color(0x…)` kullanımı ekranlarda 28'de sabit kalıyor.

### 4.6 Profil ölçütlerinde bilgi düğmeleri

"Verimlilik %60" gibi sayılar kullanıcı için belirsizdi. Artık ölçüt başlığının
yanında küçük bir **ⓘ** düğmesi var; dokununca cam panel içinde o ölçütün
ne anlama geldiği kendi dilimizle anlatılıyor (12 dil).

Bilgi verilen ölçütler: Dolap Verimliliği · Stil Kimliğin · Giyme Serisi ·
Anlık Durum · Çamaşır Sepeti · Renk Paleti · Kategori Dağılımı ·
Dolabın Kahramanları · Derinlerde Unutulanlar.

Bileşen: `lib/widgets/bilgi_butonu.dart` (`BilgiButonu` + `BilgiSayfasi`).

Aynı desen diğer ekranlara da taşındı:

- **Bugün**: "Bugünün kombini" başlığında ⓘ → kombin nasıl seçiliyor (günde
  tek AI isteği, önbellek, kural bazlı yedek).
- **Stil Günlüğü Raporu**: "Bu hafta giyilen kombin", "Son 4 hafta",
  "En çok giydiklerin", "Dolap kullanımı", "Günlük seri", "Hiç giyilmemiş".
- **Kombin Düellosu**: "Nasıl oynanır?" → puanlama kuralları (renk uyumu,
  kategori dengesi, mevsim tutarlılığı, palet kuralı).
- **Dolap**: başlıkta ⓘ → fotoğraf → arka plan silme → AI analizi akışı ve
  verinin nerede işlendiği.

---

## 5. Kopyalamayacağımız şeyler (bilinçli karar)

- **Whering'in sosyal katmanı** (başkalarının dolabı, oylama, topluluk kombinleri):
  bizde "Kombin Düellosu" farklı bir konumda; ikisini birden taşımak ürünü dağıtır.
- **Avatar / sanal deneme (try-on)**: Acloset'te var, ayrı bir AI hattı ve maliyet
  demek; 1.0.x kapsamı dışı.
- **E-ticaret filtreleri (SSENSE)**: bizde satış yok.
- **Birebir ekran/illüstrasyon kopyalama**: telif + marka riski; ayrıca Mobbin'in
  kendi kullanım notu da bunu yasaklıyor.

---

## 6. Pratik: Mobbin'i bu iş akışına nasıl bağlarız

### Seçenek A — MCP (en iyisi, abonelik gerekiyor)

Mobbin resmî MCP sunucusu:

- Uç nokta: `https://api.mobbin.com/mcp`
- Taşıma: Streamable HTTP · Kimlik: **OAuth** (tarayıcıda Mobbin'e giriş)
- Plan: **Pro / Team / Enterprise** · Limit: 60 istek/dk
- Araçlar: `search_screens`, `search_flows`, `search_sections`

Bağlandığında ben doğrudan şunu yapabilirim:
"kombin takvimi olan dolap uygulamalarında güne kombin atama ekranları" gibi
sorgularla **gerçek ekranları** çekip bizim ekranla karşılaştırmak.

Kurulum: OpenCode tarafında MCP sunucusu olarak `https://api.mobbin.com/mcp`
eklenir, OAuth ile yetkilendirilir. (Senin hesabında Pro yoksa bu adım atlanır.)

### Seçenek B — abonelik yoksa (ücretsiz)

1. Mobbin'de ücretsiz hesapla akış adları/açıklamaları okunur.
2. Arama terimleri: `wardrobe`, `outfit planner`, `closet`, `digital wardrobe`,
   `styling`, `AI stylist`, `outfit calendar`, `packing list`.
3. Ücretsiz alternatif kaynaklar: **Page Flows** (video akışlar), **ScreensDesign**,
   **App Store/Play ekran görüntüleri** (Whering, Acloset, Indyx, Save Your Wardrobe,
   Stylebook), **Dribbble** (kavram, gerçek ürün değil).
4. Referansları `docs/referans/` altında tek bir koleksiyonda toplayıp "hangi ekran
   için hangi referans" eşlemesini bu dosyada tutmak.

---

## 7. Bu incelemeden çıkan net kararlar

1. Ürünümüzde **en büyük UX açığı arama/filtre**ydi: Mobbin'de bu desende 5.691 akış
   var, bizde sıfırdı. 1.0.32'de eklendi (bkz. §4.2).
2. Stil Günlüğü takvimi şu an "okuma" ekranı; Whering deseniyle **"planlama"**
   ekranına çevirmek en yüksek ürün değeri.
3. Geri alma deseni (Whering) bizde yarım uygulanmış; silme akışlarında tamamlanmalı.
4. Paywall'ı yeniden tasarlamaya gerek yok; sadece deneme zaman çizelgesi eklenmeli.
5. Mobbin'den **görsel kopyalamıyoruz**, akış ödünç alıyoruz.
