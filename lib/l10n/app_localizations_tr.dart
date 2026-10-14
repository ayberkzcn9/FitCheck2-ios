// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'FitCheck';

  @override
  String get gorunumVeTema => 'Görünüm ve Tema';

  @override
  String get karanlikMod => 'Karanlık Mod';

  @override
  String get koyuTemaAktif => 'Koyu Tema Aktif';

  @override
  String get acikTemaAktif => 'Açık Tema Aktif';

  @override
  String get dilAyarlari => 'Dil ve Bölge Ayarları';

  @override
  String get uygulamaDili => 'Uygulama Dili';

  @override
  String get hakkinda => 'Uygulama Hakkında';

  @override
  String get surum => 'Sürüm';

  @override
  String get ayarOtomatikCihazDili => '🌐 Otomatik (Cihaz Dili)';

  @override
  String get iptal => 'İptal';

  @override
  String get tamam => 'Tamam';

  @override
  String get gardirobumTitle => 'SANAL GARDIROBUM';

  @override
  String get gardirobumYukleniyor => 'AI İnceliyor...';

  @override
  String get gardirobumTopluEkle => 'Toplu Parça Ekle';

  @override
  String gardirobumInceleniyor(Object kacinci, Object toplam) {
    return 'İnceleniyor ($kacinci/$toplam)';
  }

  @override
  String get gardirobumTemizleBaslik => 'Gardırobu Temizle';

  @override
  String get gardirobumTemizleOnay =>
      'Dolabınızdaki tüm kıyafetler silinecek. Emin misiniz?';

  @override
  String get gardirobumEvet => 'Evet, Temizle';

  @override
  String get gardirobumHataMesaji => 'Parçalar eklenirken bir hata oluştu.';

  @override
  String get gardirobumKategoriTumu => 'Tümü';

  @override
  String get gardirobumKategoriUst => 'Üst';

  @override
  String get gardirobumKategoriAlt => 'Alt';

  @override
  String get gardirobumKategoriAyakkabi => 'Ayakkabı';

  @override
  String get gardirobumKategoriAksesuar => 'Aksesuar';

  @override
  String get gardirobumBosKategori => 'Bu kategoride parça bulunmuyor.';

  @override
  String get gardirobumGiymeSayisi => 'Giyme:';

  @override
  String gardirobumMaliyet(Object tutar) {
    return 'Maliyet: ₺$tutar / giyim';
  }

  @override
  String get gardirobumDolabaAl => 'Dolaba Al';

  @override
  String get gardirobumSepeteAt => 'Sepete At';

  @override
  String get gardirobumSepetteRozet => 'SEPETTE';

  @override
  String get gardirobumGecersizParcaBaslik => 'Geçersiz Parça Algılandı';

  @override
  String get gardirobumGecersizParcaIcerik =>
      'Sistemimiz bu görselde bir giysi, ayakkabı veya aksesuar tespit edemedi (Ahşap eşya, mobilya, ev eşyası veya uyumsuz nesne algılandı). Lütfen sadece gardırop parçalarınızı yükleyin.';

  @override
  String get gardirobumTamam => 'Tamam';

  @override
  String get stilistTitle => 'ANLIK KOMBİN STİLİSTİ';

  @override
  String get gunlukKombinTitle => 'GÜNLÜK KOMBİN';

  @override
  String get gunlukKombinHazirBaslik => 'Kombinine Hazır mısın?';

  @override
  String get gunlukKombinHazirIcerik =>
      'Zar atarak ya da telefonunu sallayarak bugünün kombinini oluştur.';

  @override
  String get gunlukKombinKartBaslik => 'Bugünün Kombini';

  @override
  String get stilistAnlikHavaDurumu =>
      'Anlık Hava Durumu (Yenilemek için dokun)';

  @override
  String get stilistKonumKontrol => 'Konum kontrol ediliyor...';

  @override
  String get stilistNereyeGidiyorsun => 'Nereye Gidiyorsun?';

  @override
  String get stilistDusunuyor => 'Stilist Düşünüyor...';

  @override
  String get stilistBugunNeGiymeliyim => 'Bugün Ne Giymeliyim?';

  @override
  String get stilistKombiniTemizle => 'Kombini Temizle';

  @override
  String stilistKombininTitle(Object ortam) {
    return '$ortam Kombinin';
  }

  @override
  String stilistUyum(Object puan) {
    return '🎨 Uyum: %$puan';
  }

  @override
  String get stilistUstGiyim => 'Üst Giyim';

  @override
  String get stilistAltGiyim => 'Alt Giyim';

  @override
  String get stilistAyakkabi => 'Ayakkabı';

  @override
  String get stilistAksesuar => 'Aksesuar';

  @override
  String get stilistFavoriyeEkle => 'Favoriye Ekle';

  @override
  String get stilistBugunGiydim => 'Bugün Giydim';

  @override
  String get bugunGiydimOnayIcerik => 'Bugün bu kombini giydin mi?';

  @override
  String get stilistTrendyolTamamla => 'Trendyol\'da Tamamla';

  @override
  String get stilistHata => 'Kombin oluşturulurken bir hata oluştu.';

  @override
  String get ortamCasual => 'Günlük / Casual';

  @override
  String get ortamOfis => 'Ofis / İş';

  @override
  String get ortamDavet => 'Düğün / Özel Davet';

  @override
  String get ortamSpor => 'Spor / Yürüyüş';

  @override
  String get ortamGece => 'Gece Eğlencesi';

  @override
  String get ortamRomantik => 'Romantik Buluşma';

  @override
  String get stilistUyariDolapBosBaslik =>
      'Gardırobun Boş Veya Tüm Parçalar Yıkamada! 🧺';

  @override
  String get stilistUyariDolapBosIcerik =>
      'Sana özel anlık kombinler yapabilmem için dolabına birkaç temiz kıyafet veya aksesuar eklemelisin.';

  @override
  String get stilistUyariUstEksikBaslik => 'Üst Giyim Eksik! 👕';

  @override
  String get stilistUyariUstEksikIcerik =>
      'Gardırobunda henüz hiç temiz üst giyim yok. Tam bir kombin için dolabına en az bir üst parçası eklemelisin!';

  @override
  String get stilistUyariAltEksikBaslik => 'Alt Giyim Eksik! 👖';

  @override
  String get stilistUyariAltEksikIcerik =>
      'Gardırobunda henüz hiç temiz alt giyim yok. Şık bir kombin yapabilmemiz için dolabına bir alt parçası eklemelisin!';

  @override
  String get stilistUyariAyakkabiEksikBaslik => 'Ayakkabın Eksik! 👟';

  @override
  String get stilistUyariAyakkabiEksikIcerik =>
      'Kıyafetlerin harika görünüyor ama kombinini tamamlayacak temiz bir ayakkabı bulamadım. Dolabına hemen bir ayakkabı ekle!';

  @override
  String get stilistUyariButon => 'Anladım, Ekliyorum!';

  @override
  String get anaHavaYukleniyor => 'Konum hava durumu yükleniyor...';

  @override
  String get anaDinliyor => '🎙️ FITCHECK Sizi Dinliyor... Konuşun!';

  @override
  String get anaMikrofonHata =>
      'Mikrofon izni veya ses tanıma servisi hazır değil.';

  @override
  String anaCinsiyetGuncellendi(Object cinsiyet) {
    return 'Tercihiniz \"$cinsiyet\" olarak güncellendi ✨';
  }

  @override
  String get anaKonumKapaliBaslik => 'Konum Servisi Kapalı';

  @override
  String get anaKonumKapaliIcerik =>
      'Hava durumuna göre kombin önerileri alabilmek için GPS konumunuzu açmanız gerekiyor.';

  @override
  String get anaKonumuAc => 'Konumu Aç';

  @override
  String get anaIzinVer => 'İzin Ver';

  @override
  String get anaIptal => 'İptal';

  @override
  String get anaKonumIzinRedBaslik => 'Konum İzni Reddedildi';

  @override
  String get anaKonumIzinRedIcerik1 =>
      'İzin verilmediği için tahmin alınamadı.';

  @override
  String get anaKonumIzinRedIcerik2 => 'Ayarlardan izin vermelisiniz.';

  @override
  String get anaKonumIzinGerekliBaslik => 'Konum İzni Gerekli';

  @override
  String get anaKonumIzinGerekliIcerik =>
      'Uygulamanın hava durumunu görebilmesi için ayarlardan konum iznini aktif etmelisiniz.';

  @override
  String get anaHavaDurumuAlinamadi => 'Hava durumu alınamadı';

  @override
  String get anaHavaTahminiYuklenemedi => 'Hava tahminleri yüklenemedi.';

  @override
  String get anaFavoriEklendi => 'Kombin favorilere eklendi! ⭐';

  @override
  String get anaKombinTekrarUyari =>
      '⚠️ Uyarı: Bu parçaları veya benzerlerini son zamanlarda çok sık giydin. Bugün farklı bir tarz deneyebilirsin!';

  @override
  String get anaKombinMukemmel =>
      '✨ Mükemmel seçim! Tarzın bugün gayet dengeli ve ferah.';

  @override
  String get anaYikamaUyariBaslik => 'Akıllı Yıkama Uyarısı';

  @override
  String anaYikamaUyariIcerik(Object parcalar) {
    return 'Bu kombini giydiğiniz için \"$parcalar\" adlı parça(lar) çok sık kullanıldı ve otomatik olarak yıkama sepetine gönderildi! 🧺';
  }

  @override
  String get anaTamam => 'Tamam';

  @override
  String get anaAyarlarTooltip => 'Ayarlar';

  @override
  String get anaKadin => 'Kadın';

  @override
  String get anaErkek => 'Erkek';

  @override
  String get anaSesleKonus => 'Sesle Konuş';

  @override
  String get anaStilistAsistani => 'Stilist Asistani';

  @override
  String get anaSekmeGardirop => 'Gardırop';

  @override
  String get anaSekmeHaftalik => 'Haftalık';

  @override
  String get anaSekmeAnlik => 'Anlık';

  @override
  String get anaSekmeYarismasi => 'Yarışma';

  @override
  String get anaSekmeProfil => 'Profil & Analiz';

  @override
  String get modaYarismasiBaslik => 'Moda & Renk Uyumu';

  @override
  String get modaYarismasiGunlukTamamlandi => 'Bugünkü yarışma tamamlandı';

  @override
  String get modaYarismasiYeniYarin =>
      'Yeni 10 soruluk set yarın tekrar gelir.';

  @override
  String get modaYarismasiSonuc => 'Sonuç';

  @override
  String modaYarismasiSkor(Object skor) {
    return 'Skorun: $skor / 10';
  }

  @override
  String modaYarismasiSoru(Object index) {
    return 'Soru $index / 10';
  }

  @override
  String get modaYarismasiGeri => 'Geri';

  @override
  String get modaYarismasiAnaEkrana => 'Ana Ekrana Dön';

  @override
  String get havaParcaliBulutlu => 'Parçalı Bulutlu';

  @override
  String get havaSicakGunesli => 'Sıcak ve Güneşli';

  @override
  String get havaSogukKarli => 'Soğuk ve Karlı';

  @override
  String get havaYagmurlu => 'Yağmurlu';

  @override
  String get havaGunesli => 'Güneşli';

  @override
  String get havaSoguk => 'Soğuk';

  @override
  String get gunPzt => 'Pazartesi';

  @override
  String get gunSal => 'Salı';

  @override
  String get gunCar => 'Çarşamba';

  @override
  String get gunPer => 'Perşembe';

  @override
  String get gunCum => 'Cuma';

  @override
  String get gunCmt => 'Cumartesi';

  @override
  String get gunPaz => 'Pazar';

  @override
  String get stilKahveBaslik => '☕ Kahve & Günlük';

  @override
  String get stilKahveSoru =>
      'Arkadaşlarla kahveye çıkmak için günlük şık bir kombin öner';

  @override
  String get stilOfisBaslik => '💼 İş / Ofis Şıklığı';

  @override
  String get stilOfisSoru =>
      'Ofis ve iş ortamına uygun modern ve şık bir kombin öner';

  @override
  String get stilSporBaslik => '🏃 Spor / Rahat Giyim';

  @override
  String get stilSporSoru =>
      'Hafta sonu gezisi için çok rahat ve spor bir kombin öner';

  @override
  String get stilGeceBaslik => '🌙 Gece / Özel Davet';

  @override
  String get stilGeceSoru =>
      'Akşam yemeği veya özel davet için iddialı bir kombin öner';

  @override
  String get ilkGorevBaslik => '🎯 İlk Görev: Stilini Seç!';

  @override
  String get ilkGorevAciklama =>
      'FitCheck Yapay Zekası senin için anında kombin üretecek. Bugün nereye gidiyorsun?';

  @override
  String get haftalikUyariButon => 'Anladım';

  @override
  String get haftalikUyariDolapBosBaslik => 'Gardırobun Boş!';

  @override
  String get haftalikUyariDolapBosIcerik =>
      'Haftalık plan yapabilmem için dolabına kıyafet eklemelisin.';

  @override
  String get haftalikUyariUstEksikBaslik => 'Üst Giyim Eksik!';

  @override
  String get haftalikUyariUstEksikIcerik =>
      'Dolabında hiç temiz üst giyim yok.';

  @override
  String get haftalikUyariAltEksikBaslik => 'Alt Giyim Eksik!';

  @override
  String get haftalikUyariAltEksikIcerik =>
      'Dolabında hiç temiz alt giyim yok.';

  @override
  String get haftalikUyariAyakkabiEksikBaslik => 'Ayakkabı Eksik!';

  @override
  String get haftalikUyariAyakkabiEksikIcerik =>
      'Dolabında temiz ayakkabı bulunmuyor.';

  @override
  String get haftalikHata => 'Haftalık plan oluşturulurken hata oluştu.';

  @override
  String get haftalikAjandaTitle => 'HAFTALIK STİL AJANDASI';

  @override
  String get haftalikAnlikHavaDurumu => 'Haftalık Hava Tahmini';

  @override
  String get haftalikKonumKontrol => 'Hava durumu yükleniyor...';

  @override
  String get haftalikTemizParca => 'Temiz Parça';

  @override
  String get haftalikSepette => 'Sepette';

  @override
  String get haftalikPlanAciklama =>
      'Yapay zeka hava durumuna göre 7 günlük kombin planını hazırlasın.';

  @override
  String get haftalikProgramOlustur => 'Haftalık Program Oluştur';

  @override
  String get haftalikPlaniTemizle => 'Planı Temizle';

  @override
  String get haftalikAnalizEdiliyor => 'Yapay Zeka Planlıyor...';

  @override
  String get haftalikUyum => 'Uyum';

  @override
  String get haftalikFavoriEkle => 'Favorilere Ekle';

  @override
  String get haftalikGiyildiIsaretle => 'Bugün Giydim';

  @override
  String get haftalikHava => 'Hava Durumu:';

  @override
  String get haftalikHavaUyarisi =>
      'Not: Bu kombindeki parçalar, günün havasına uygun olacak şekilde güncellendi.';

  @override
  String get haftalikUyumsuzParca => 'Eksik Parça';

  @override
  String get haftalikEksikParcaStilistNotu =>
      'Eksik parçayı da hesaba katan stilist, elindeki temiz parçalarla önerileri hazırladı.';

  @override
  String get haftalikEksikParcaYeterliParcaYok =>
      'Bu günü dolduracak kadar temiz parça kalmadı. Dolabına yeni bir parça ekle ya da çamaşırları yıka; stilist buraya yeni bir kombin önersin.';

  @override
  String get haftalikEksikParcaAiOnerisi => 'AI Kombin Önerisi';

  @override
  String get haftalikEksikParcaOneriYok =>
      'Eksik parçayı tamamlayan üst, alt ve ayakkabı kombinini görmek için planı yenile.';

  @override
  String get haftalikEksikParcaOnerisiBaslik => 'AI Stilist Kombin Önerisi';

  @override
  String get haftalikEksikParcaOneriHazirlaniyor =>
      'Stilist kombin önerisini hazırlıyor…';

  @override
  String get haftalikEksikParcaPlanKurulamadi =>
      'Üst ve alt parça olmadan kombin kurulamıyor. Stilist tamamlayıcı önerisini yukarıda hazırladı.';

  @override
  String get haftalikNot => 'Not';

  @override
  String get haftalikTrendyolAra => 'Trendyol\'da Ara';

  @override
  String get izinZorunluMesaj =>
      'Uygulamayı kullanabilmek için bu izinler zorunludur.';

  @override
  String get izinGerekliBaslik => 'İzin Gerekli';

  @override
  String get izinGerekliIcerik =>
      'Kamera ve konum izinleri reddedilmiş. Ayarlardan aktif etmeniz gerekiyor.';

  @override
  String get ayarlaraGit => 'Ayarlara Git';

  @override
  String get izinAnaBaslik => 'İzinler Gerekli';

  @override
  String get izinAciklama =>
      'Sana en iyi kombinleri sunabilmemiz için konum (hava durumu) ve kamera (fotoğraf) izinlerine ihtiyacımız var.';

  @override
  String get konumIzni => 'Konum İzni';

  @override
  String get kameraIzni => 'Kamera İzni';

  @override
  String get izinVerDevamEt => 'İzin Ver ve Devam Et';

  @override
  String get gunlukHavaMevcutDegil => 'Hava durumu mevcut değil';

  @override
  String get profilAnalizTitle => 'PROFİL & ANALİZ';

  @override
  String get anlikDurum => 'Anlık Durum';

  @override
  String get toplamParca => 'Toplam Parça';

  @override
  String get favoriKombin => 'Favori Kombin';

  @override
  String get gardiropDegeri => 'Gardırop Değeri';

  @override
  String get ortalamaMaliyet => 'Ortalama Maliyet';

  @override
  String get kategoriDagilimi => 'Kategori Dağılımı';

  @override
  String get ustGiyim => 'Üst Giyim';

  @override
  String get altGiyim => 'Alt Giyim';

  @override
  String get ayakkabi => 'Ayakkabı';

  @override
  String get disGiyim => 'Dış Giyim';

  @override
  String get aksesuar => 'Aksesuar';

  @override
  String get sonGiyecekGecmisi => 'Son Giyilenler Geçmişi';

  @override
  String get kayit => 'Kayıt';

  @override
  String get gecmisKombinYok => 'Henüz geçmiş kombin kaydı yok.';

  @override
  String get parca => 'Parça';

  @override
  String get onboardingHosGeldinBaslik => 'FitCheck\'e Hoş Geldin! ✨';

  @override
  String get onboardingDolabiniDijitallestir => 'Dolabını Dijitalleştir';

  @override
  String get onboardingDolapAciklama =>
      'Kıyafetlerini saniyeler içinde ekle ve kendi sanal gardırobunu oluştur.';

  @override
  String get onboardingHavaDurumu => 'Hava Durumuna Uygun';

  @override
  String get onboardingHavaAciklama =>
      'Bulunduğun konumun günlük hava durumuna en uygun kombin önerilerini al.';

  @override
  String get onboardingYikama => 'Akıllı Yıkama Takibi';

  @override
  String get onboardingYikamaAciklama =>
      'Çok sık giydiğin kıyafetleri sistem otomatik algılar ve yıkama sepetine gönderir.';

  @override
  String get onboardingEksikParca => 'Eksik Parça Önerisi';

  @override
  String get onboardingEksikAciklama =>
      'Kombinini tamamlayacak eksik parçaları belirler ve anında alışveriş önerisi sunar.';

  @override
  String get onboardingAnalitik => 'Gelişmiş Analitik';

  @override
  String get onboardingAnalitikAciklama =>
      'Dolabının toplam değerini, giyim başı maliyetini ve favori tarzını analiz et.';

  @override
  String get onboardingStilist => 'Yapay Zeka Stilist';

  @override
  String get onboardingStilistAciklama =>
      'Sadece nereye gideceğini söyle, yapay zeka saniyeler içinde en şık kombini hazırlasın.';

  @override
  String get onboardingAtla => 'Atla';

  @override
  String get onboardingModaProfiliniz => 'Moda Profilin';

  @override
  String get onboardingKadin => 'Kadın';

  @override
  String get onboardingErkek => 'Erkek';

  @override
  String get onboardingBasla => 'Hemen Başla';

  @override
  String get onboardingDevamEt => 'Devam Et';

  @override
  String get cinsiyetBaslik => 'CİNSİYET';

  @override
  String get tarzBaslik => 'GÜNLÜK TARZINIZ (BİRDEN FAZLA)';

  @override
  String get renkTercihiBaslik => 'RENK TERCİHİNİZ';

  @override
  String get tenRengiBaslik => 'TEN RENGİ TERCİHİNİZ';

  @override
  String get kadin => 'Kadın';

  @override
  String get erkek => 'Erkek';

  @override
  String get cinsiyetBelirtilmemis => 'Belirtilmemiş';

  @override
  String get tarzSpor => 'Spor';

  @override
  String get tarzKlasik => 'Klasik';

  @override
  String get tarzSokakModasi => 'Sokak Modası';

  @override
  String get tarzMinimalist => 'Minimalist';

  @override
  String get renkKoyuTonlar => 'Koyu Tonlar';

  @override
  String get renkPastel => 'Pastel Renkler';

  @override
  String get renkCanli => 'Canlı Renkler';

  @override
  String get renkNotr => 'Nötr';

  @override
  String get tenAcikBeyaz => 'Açık / Beyaz';

  @override
  String get tenBugday => 'Buğday';

  @override
  String get tenEsmerKoyu => 'Esmer / Koyu';

  @override
  String get hesabinizaGirisYapin => 'Hesabınıza Giriş Yapın';

  @override
  String get yeniHesapOlusturun => 'Yeni Hesap Oluşturun';

  @override
  String get stilDunyanaTekrarHosGeldin => 'Stil dünyana tekrar hoş geldin ✨';

  @override
  String get kombinleriniSaklamakIcinKatil =>
      'Kombinlerini saklamak için aramıza katıl 🚀';

  @override
  String get girisYap => 'Giriş Yap';

  @override
  String get girisYapGoogle => 'Google ile Giriş Yap';

  @override
  String get girisBeniHatirla => 'Beni hatırla';

  @override
  String get girisVeya => 'veya';

  @override
  String get kayitOl => 'Kayıt Ol';

  @override
  String get adinizVeyaLakabiniz => 'Adınız veya Lakabınız';

  @override
  String get epostaAdresiniz => 'E-posta Adresiniz';

  @override
  String get sifreniz => 'Şifreniz';

  @override
  String get girisYapVeBasla => 'Giriş Yap ve Başla';

  @override
  String get kayitOlVeBasla => 'Kayıt Ol ve Başla';

  @override
  String get misafirOlarakDevamEt => 'Misafir Olarak Devam Et';

  @override
  String get lutfenEpostaVeSifreGiriniz =>
      'Lütfen e-posta adresinizi ve şifrenizi giriniz.';

  @override
  String get lutfenAdiniziGiriniz => 'Lütfen adınızı giriniz.';

  @override
  String get kullanimKosullariBaslik => 'Kullanım Koşulları ve Sözleşme';

  @override
  String get onaylamakIcinKaydirin =>
      'Onaylamak için metnin sonuna kadar kaydırın';

  @override
  String get okudumAnladimKabulEdiyorum => 'Okudum, Anladım ve Kabul Ediyorum';

  @override
  String get kullanimKosullarini => 'Kullanım Koşullarını';

  @override
  String get okudumVeOnayliyorum => ' okudum ve onaylıyorum.';

  @override
  String get onaylamadanOnceKosullariOkuyun =>
      'Onaylamadan önce lütfen kullanım koşullarını okuyun.';

  @override
  String get devamEtmekIcinKosullariKabulEdin =>
      'Devam etmek için kullanım koşullarını kabul etmelisiniz.';

  @override
  String get kullanimKosullariMetni =>
      'FITCHECK KULLANIM KOŞULLARI VE HİZMET SÖZLEŞMESİ\n\nSon Güncelleme Tarihi: 27 Ağustos 2026\n\nLütfen FitCheck mobil uygulamasını (“Uygulama”) kullanmadan önce bu Kullanım Koşulları’nı (“Sözleşme”) dikkatlice okuyunuz. Uygulamayı indirerek, erişerek veya kullanarak bu Sözleşme’de yer alan tüm şartları kabul etmiş sayılırsınız.\n\n1. TARAFLAR VE AMAÇ\nBu Sözleşme, FitCheck uygulamasının geliştiricisi ile Uygulama’yı indiren ve kullanan bireysel kullanıcı (\"Kullanıcı\") arasında akdedilmiştir. Uygulama; dijital gardırop oluşturma, kıyafet takibi, hava durumuna uygun kombin önerileri ve AI destekli stil danışmanlığı sunar.\n\n2. HİZMETİN KAPSAMI VE KULLANIM ŞARTLARI\n• Yaş Sınırı: Uygulamayı kullanmak için en az 13 yaşında olmanız gerekmektedir.\n• Kullanıcı Bilgileri: Kullanıcı, profil aşamasında sunduğu ad, cinsiyet, tarz ve renk tercihlerinin doğruluğundan sorumludur.\n• Tavsiye Niteliği: Yapay zeka tarafından sunulan stil puanları, satın alma önerileri ve çamaşır günü hatırlatmaları tamamen tavsiye niteliğindedir.\n• Hava Durumu Verileri: Hava durum bilgileri anlık konum bilgisine dayalı olarak sunulmaktadır. Olası sapmalardan Şirket sorumlu tutulamaz.\n\n3. FİKRİ MÜLKİYET VE İÇERİK HAKLARI\nYüklediğiniz kıyafet görsellerinin fikri mülkiyeti size aittir. FitCheck logosu, tasarımı, yazılım kodları ve algoritmaları tamamen FitCheck\'e aittir.\n\n4. GİZLİLİK VE VERİ GÜVENLİĞİ\nKıyafet görselleriniz ve kombin geçmişiniz öncelikli olarak cihazınızın yerel hafızasında saklanır. Konum verileri yalnızca anlık hava durumunu almak için kullanılır.\n\n5. SORUMLULUĞUN SINIRLANDIRILMASI\nFitCheck, hizmetin kesintisiz devam edeceğini garanti etmez. Cihaz değişikliği veya uygulama silinmesi sebebiyle veri kayıplarından sorumlu tutulamaz.\n\n6. İLETİŞİM\nSorularınız için bizimle Ayarlar sekmesindeki iletişim alanından veya destek@fitcheckapp.com adresinden iletişime geçebilirsiniz.\n\n--- 📜 SÖZLEŞMENİN SONU ---\nLütfen aşağıdaki butona basarak şartları onaylayınız.';

  @override
  String chatKarsilama(Object hava) {
    return 'Selam! 👋 Bugün dışarısı $hava. Senin tarzına uygun harika bir kombin hazırlayalım mı? ✨';
  }

  @override
  String get chatGorselGonderildi => 'Görsel gönderildi.';

  @override
  String get chatAsistanSohbeti => 'Asistan Sohbeti';

  @override
  String get chatModHavaDuyarli => 'Hava durumuna göre akıllı stil önerileri';

  @override
  String get chatStilistHazirliyor => 'Stilist kombin hazırlıyor...';

  @override
  String get chatGorselEklendi => 'Görsel eklendi';

  @override
  String get chatTekrarDene => 'Tekrar dene';

  @override
  String get chatKamera => 'Kamera';

  @override
  String get chatGaleri => 'Galeriden görsel seç';

  @override
  String get chatMikrofon => 'Mikrofon';

  @override
  String get chatGonder => 'Mesajı gönder';

  @override
  String get chatOneriYagmur => '🌧️ Yağmurlu Hava Kombini';

  @override
  String get chatOneriOfis => '💼 Ofis / Şık Tarz';

  @override
  String get chatOneriHaftaSonu => '☕ Hafta Sonu Rahatlığı';

  @override
  String get chatOneriKirliSepeti => '🧺 Kirli Sepeti Kontrolü';

  @override
  String get chatDinleniyor => 'Dinleniyor...';

  @override
  String get chatBirSeylerYazin => 'Asistana bir şeyler yazın...';

  @override
  String get chatKombiniGiydim => 'Bu Kombini Giydim 👗';

  @override
  String get chatKombinIslendi => 'Kombin bugün giyilenlere işlendi! 📅';

  @override
  String get chatGorselIncele => 'Bu görseli incele ve kombin öner.';

  @override
  String get profilAyarlariBaslik => 'PROFİL AYARLARI';

  @override
  String get cinsiyetTercihiBaslik => 'Cinsiyet Tercihi';

  @override
  String get stilAramaHint =>
      'Örn: \'Siyah ceketli spor şık kombin\', \'Yazlık elbise\'...';

  @override
  String get stilFiltreTumu => 'Tüm Parçalar';

  @override
  String get stilFiltreSadeceTemizler => 'Sadece Temizler';

  @override
  String get stilFiltreSadeceSepet => 'Sadece Yıkamadakiler';

  @override
  String get profilFavoriKombinlerTitle => 'Favori Kombinlerim';

  @override
  String get profilFavoriKombinYok =>
      'Henüz favorilere eklenmiş bir kombin bulunmuyor.';

  @override
  String get profilYikamaSepetimTitle => 'Çamaşır Sepetim';

  @override
  String get profilYikamaSepetimBos =>
      'Yıkama sepetiniz boş, tüm kıyafetleriniz temiz! ✨';

  @override
  String get profilSepetiBosalt => 'Sepeti Boşalt';

  @override
  String get profilSepetiBosaltOnay =>
      'Tüm kıyafetler temizlendi olarak işaretlenecek. Onaylıyor musunuz?';

  @override
  String get profilSepetiBosaltButon => 'Evet, Hepsini Yıka';

  @override
  String get profilTenRengi => 'Ten Rengi / Kompleksiyon';

  @override
  String get profilTarzTercihi => 'Tarz Tercihi';

  @override
  String get profilRenkPaleti => 'Sevdiğin Renk Paleti';

  @override
  String get rehberGardiropEkleTitle => 'Fotoğraf Ekle';

  @override
  String get rehberGardiropEkleDesc =>
      'Tekli veya toplu olarak kıyafetlerinin fotoğraflarını çekip yükleyebilirsin.';

  @override
  String get rehberAiStilistTitle => 'AI Stilist Asistani';

  @override
  String get rehberAiStilistDesc =>
      'Yapay zekaya istediğin kombini sorabilir veya tavsiye alabilirsin.';

  @override
  String get rehberSesliTitle => 'Sesli Komut';

  @override
  String get rehberSesliDesc =>
      'Konuşarak direkt olarak kombin önerisi isteyebilirsin.';

  @override
  String get rehberAyarlarTitle => 'Ayarlar ve Profil';

  @override
  String get rehberAyarlarDesc =>
      'Cinsiyet, stil tercihi ve ten rengi ayarlarını güncelleyebilirsin.';

  @override
  String get rehberGardiropNavTitle => 'Gardırobum';

  @override
  String get rehberGardiropNavDesc =>
      'Tüm eklediğin kıyafetlerini kategorilerine göre burada görebilirsin.';

  @override
  String get rehberHaftalikNavTitle => 'Haftalık Planlayıcı';

  @override
  String get rehberHaftalikNavDesc =>
      '7 günlük hava durumuna göre haftalık kombin planı oluşturabilirsin.';

  @override
  String get rehberDolaptanNavTitle => 'Anlık Kombin Stilisti';

  @override
  String get rehberDolaptanNavDesc =>
      'Gideceğin ortama özel anlık AI kombinleri oluşturabilirsin.';

  @override
  String get rehberKendiNavTitle => 'Kendi Kombinim';

  @override
  String get rehberKendiNavDesc =>
      'Parçaları kendin eşleştirip kendi kombinlerini tasarlayabilirsin.';

  @override
  String get rehberProfilNavTitle => 'Profil ve Analiz';

  @override
  String get rehberProfilNavDesc =>
      'Gardırobunun maliyet analizini ve çamaşır sepetini takip edebilirsin.';

  @override
  String get simdilikAtla => 'Şimdilik Atla';

  @override
  String get uygulamaIzinleri => 'Uygulama İzinleri';

  @override
  String get izinEkraniAciklama =>
      'FitCheck\'in size kişiselleştirilmiş kombinler sunabilmesi ve çamaşır/hava durumu hatırlatmaları gönderebilmesi için bu izinlere ihtiyacı var.';

  @override
  String get konumIzniAciklama =>
      'Anlık hava durumuna göre kombin önerileri için';

  @override
  String get kameraIzniAciklama =>
      'Kıyafet fotoğraflarınızı gardırobunuza eklemek için';

  @override
  String get bildirimIzni => 'Bildirim İzni';

  @override
  String get bildirimIzniAciklama =>
      'Çamaşır günü ve hava durumu uyarıları için';

  @override
  String get izinleriVerVeBasla => 'İzinleri Ver ve Başla';

  @override
  String get dahaSonraAyarla => 'Daha Sonra Ayarla';

  @override
  String get gunlukHakBittiBaslik => 'Günlük Hakkın Bitti!';

  @override
  String get dahaSonra => 'Daha Sonra';

  @override
  String get reklamIzleHakKazan => 'Reklam İzle (+2 Hak)';

  @override
  String get tebriklerHakEklendi => 'Tebrikler! +2 İşlem hakkı tanımlandı. ✨';

  @override
  String kombinIsaretlemeKaldirildi(String kombinAdi) {
    return '\"$kombinAdi\" kombini işaretlemesi kaldırıldı.';
  }

  @override
  String kombinGiydimIsaretlendi(String kombinAdi) {
    return '\"$kombinAdi\" kombini bugün giyildi olarak işaretlendi! 👕✨';
  }

  @override
  String get kiyafetDetayi => 'Kıyafet Detayı';

  @override
  String get parcaDetayiBaslik => 'PARÇA DETAYI';

  @override
  String get farkliParcaSec => 'Farklı Parça Seç';

  @override
  String get farkliUstSec => 'Farklı Üst Giyim Seç 👕';

  @override
  String get farkliAltSec => 'Farklı Alt Giyim Seç 👖';

  @override
  String get farkliAyakkabiSec => 'Farklı Ayakkabı Seç 👟';

  @override
  String get farkliDisSec => 'Farklı Dış Giyim Seç 🧥';

  @override
  String get baskaTemizKiyafetYok =>
      'Bu kategoride değiştirebileceğiniz\nbaşka temiz kıyafetiniz yok.';

  @override
  String get planiYenile => 'Planı Yenile';

  @override
  String get havaEtiketi => 'HAVA';

  @override
  String get yukleniyor => 'Yükleniyor...';

  @override
  String get temizle => 'Temizle';

  @override
  String get yenidenDegerlendiriliyor => 'Yeniden değerlendiriliyor...';

  @override
  String get kombinParcalariBaslik => 'KOMBİN PARÇALARI';

  @override
  String get parcalariKaydirIpucu =>
      'Kombindeki diğer parçalar için sağa/sola kaydırın 👈👉';

  @override
  String zorunluParcaYorumu(Object parcaAdi) {
    return '✨ $parcaAdi parçasını merkeze alarak bu kombini hazırladım!';
  }

  @override
  String get sihirliDokunus => 'Sihirli Dokunuş';

  @override
  String get dolabiKaristirEksikUyari =>
      'Dolabı karıştırabilmek için en az 1 temiz Üst, Alt ve Ayakkabı bulunmalı! 👕👖👟';

  @override
  String get zarlarAtildiYorumu =>
      '🎲 Zarlar atıldı! Yepyeni ve şaşırtıcı bir kombin keşfettin.';

  @override
  String get rastgeleKombinTuru => 'Rastgele';

  @override
  String get temizAlternatifYok =>
      'Bu kategori için temiz başka alternatif yok! 🧺';

  @override
  String get kisiselDokunus => 'Kişisel Dokunus';

  @override
  String get aiYeniParcaAnalizEdiyor =>
      'Yapay zeka yeni parçayı analiz ediyor... ✨';

  @override
  String get parcaDegisimVarsayilanYorum =>
      '✨ Parçaları değiştirerek harika bir uyum yakaladın!';

  @override
  String get parcaDegisimHataYorum =>
      '✨ Parçaları değiştirerek kombini tamamen kendi tarzına uyarladın!';

  @override
  String get bilgileriDuzenleBaslik => 'Bilgileri Düzenle';

  @override
  String get kiyafetAdiEtiketi => 'Kıyafet Adı';

  @override
  String get renkEtiketi => 'Renk';

  @override
  String get kaydet => 'Kaydet';

  @override
  String get yenidenZarAt => 'Yeniden Zar At';

  @override
  String get zarAtKaristir => 'Zar At (Karıştır)';

  @override
  String get zarPopupBaslik => 'Sihirli Zarları Salla!';

  @override
  String get zarPopupAciklama =>
      'Telefonunu fiziksel olarak sallayarak veya aşağıdaki butona basarak zarları atabilir, dolabından rastgele kombinler oluşturabilirsin.';

  @override
  String get zarlariAt => 'Zarları At';

  @override
  String get zarSalla => 'Zar Salla';

  @override
  String get degistirmekIcinKaydirIpucu =>
      'Değiştirmek için parçaları sağa/sola kaydırın veya dokunun 👈👉';

  @override
  String get favorilerdeEtiketi => 'Favorilerde';

  @override
  String get bugunGiydildiEtiketi => 'Bugün Giyildi ✨';

  @override
  String get varsayilanKendiAnalizYorumu =>
      'Harika bir seçim! Parçalar renk tonlarıyla mükemmel bir denge oluşturmuş.';

  @override
  String get kendiTasarimimBaslik => 'Kendi Tasarımım';

  @override
  String parcaSecModalBaslik(Object kategori) {
    return '$kategori Seç';
  }

  @override
  String get kendiKombininiTasarlaTitle => 'Kendi Kombinini Tasarla';

  @override
  String get secimleriSifirla => 'Seçimleri Sıfırla';

  @override
  String get kombinHazirAiTavsiyesi =>
      'Kombin harika görünüyor! Yapay zeka ile analiz edip kaydet.';

  @override
  String get kombinBaslaIpucu =>
      'Bugün ne giymek istersin? Parçaları seçerek başla.';

  @override
  String get ustAltModu => 'Üst + Alt';

  @override
  String get tekParcaElbiseModu => 'Tek Parça (Elbise)';

  @override
  String get tekParcaElbise => 'Tek Parça / Elbise';

  @override
  String get aksesuarOpsiyonel => 'Aksesuar (Opsiyonel)';

  @override
  String get stilistAnaliziBaslik => 'STİLİST ANALİZİ';

  @override
  String get stilistDegerlendiriyor => 'Stilist Değerlendiriyor...';

  @override
  String get aiIleAnalizEtKaydet => 'AI İle Analiz Et & Kaydet';

  @override
  String get bilinmiyor => 'Bilinmiyor';

  @override
  String get karmasikSiklik => 'Karmaşık Şıklık';

  @override
  String get gecmisiTemizleTitle => 'Geçmişi Temizle';

  @override
  String get gecmisiTemizleOnayIcerik =>
      'Tüm giyilenler geçmişini silmek istediğinize emin misiniz? Bu işlem geri alınamaz.';

  @override
  String get gecmisBasariylaTemizlendi => 'Geçmiş başarıyla temizlendi 🗑️';

  @override
  String get kayitGecmistenSilindi => 'Kayıt geçmişten silindi.';

  @override
  String get kombin => 'Kombin';

  @override
  String get kombinDetayiUst => 'KOMBİN DETAYI';

  @override
  String get giyilenParcalarUst => 'GİYİLEN PARÇALAR';

  @override
  String get detayBulunamadi => 'Detay bulunamadı.';

  @override
  String get henuzFavoriEklemediniz => 'Henüz favori kombin eklemediniz.';

  @override
  String get camasirSepetiTitle => 'Çamaşır Sepeti';

  @override
  String get sepetBosTumKiyafetlerTemiz =>
      'Sepet tamamen boş, tüm kıyafetler temiz!';

  @override
  String get tumKiyafetlerTemizlendi =>
      'Tüm kıyafetler temizlendi ve dolaba eklendi 🧺✨';

  @override
  String get tumunuTemizIsaretle => 'Tümünü Temiz İşaretle';

  @override
  String get profilVeAnalizTitle => 'Profil ve Analiz';

  @override
  String get harikaGidiyorsun => 'Harika Gidiyorsun!';

  @override
  String gundurSeridesin(Object gun) {
    return '$gun Gündür Seridesin';
  }

  @override
  String get tumuTemiz => 'Tümü Temiz';

  @override
  String kirliParcaSayisi(Object sayi) {
    return '$sayi Kirli Parça';
  }

  @override
  String get stilKimligin => 'Stil Kimliğin';

  @override
  String get dolapVerimliligi => 'Dolap Verimliliği';

  @override
  String get renkPaletin => 'Renk Paletin';

  @override
  String get dolabinKahramanlari => 'Dolabın Kahramanları';

  @override
  String get derinlerdeUnutulanlar => 'Derinlerde Unutulanlar';

  @override
  String get sonGiyilenler => 'Son Giyilenler';

  @override
  String get tumunuTemizle => 'Tümünü Temizle';

  @override
  String get henuzGecmisKaydiYok => 'Henüz geçmiş kaydı yok.';

  @override
  String kezGiyildi(Object sayi) {
    return '$sayi kez giyildi';
  }

  @override
  String get ayarlarTitle => 'Ayarlar';

  @override
  String get hesapVeGuvenlikMerkeziUst => 'HESAP VE GÜVENLİK MERKEZİ';

  @override
  String get kullaniciHesabi => 'Kullanıcı Hesabı';

  @override
  String get misafirKullanici => 'Misafir Kullanıcı';

  @override
  String get epostaDogrulanmis => 'E-posta doğrulanmış';

  @override
  String get esitlemekIcinGirisYapin =>
      'Tüm cihazlarda eşitlemek için giriş yapın.';

  @override
  String get cikisYapTitle => 'Çıkış Yap';

  @override
  String get cikisYapOnayIcerik =>
      'Hesabınızdan çıkış yapmak istediğinize emin misiniz?';

  @override
  String get bagliHesaplarUst => 'BAĞLI HESAPLAR';

  @override
  String get googleHesabiBagli => 'Google Hesabı Bağlı';

  @override
  String get googleHesabiniBagla => 'Google Hesabını Bağla';

  @override
  String get googleHesabiBaglandi => 'Google hesabınız başarıyla bağlandı! 🔗';

  @override
  String get googleHesabiBaglantisiKesildi =>
      'Google hesabı bağlantısı kesildi.';

  @override
  String get sifreVeGuvenlik => 'Şifre ve Güvenlik';

  @override
  String get sifreYenilemeBaglantisiIste => 'Şifre yenileme bağlantısı iste';

  @override
  String get sifremiUnuttum => 'Şifremi unuttum';

  @override
  String get sifreDegistirTitle => 'Şifre Değiştir';

  @override
  String get sifreSifirlamaAciklama =>
      'Hesabınıza bağlı e-posta adresine şifre sıfırlama bağlantısı gönderilecektir:';

  @override
  String get epostaAdresi => 'E-posta Adresi';

  @override
  String get gecerliBirEpostaGiriniz => 'Geçerli bir e-posta adresi giriniz';

  @override
  String sifreEpostasiGonderildi(Object eposta) {
    return '$eposta adresine şifre yenileme e-postası gönderildi! ✉️';
  }

  @override
  String get baglantiGonder => 'Bağlantı Gönder';

  @override
  String get hesabiKaliciSilTitle => 'Hesabı Kalıcı Olarak Sil';

  @override
  String get hesabiSilGeriAlinamazUyari =>
      'Bu işlem geri alınamaz. Gardırop verileriniz ve profiliniz kalıcı olarak silinecektir.';

  @override
  String get hesabiSilOnayKoduMetni =>
      'Onaylamak için aşağıya \"fitcheck\" yazın:';

  @override
  String get vazgec => 'Vazgeç';

  @override
  String get hesabimiSil => 'Hesabımı Sil';

  @override
  String get hesabinizSilindi => 'Hesabınız ve ilişkili veriler silindi.';

  @override
  String get kisiselStilVeProfilUst => 'KİŞİSEL STİL VE PROFİL';

  @override
  String get stilVeTarzTercihleri => 'Stil & Tarz Tercihleri';

  @override
  String get secili => 'Seçili';

  @override
  String get tenRengiTercihinizUst => 'TEN RENGİ TERCİHİNİZ';

  @override
  String get yapayZekaVeStilHassasiyetiUst => 'YAPAY ZEKÂ VE STİL HASSASİYETİ';

  @override
  String get stilistKisiligiVeYantitTarziUst =>
      'STİLİST KİŞİLİĞİ VE YANIT TARZI';

  @override
  String get aiKisilikSamimiBaslik => 'Samimi / Arkadaş Canlısı';

  @override
  String get aiKisilikSamimiAciklama =>
      'Sıcak, motive edici ve modayı eğlenceli kılan sohbet dili';

  @override
  String get aiKisilikElestirmenBaslik => 'Profesyonel Moda Eleştirmeni';

  @override
  String get aiKisilikElestirmenAciklama =>
      'Renk teorisi ve vücut tipine odaklanan teknik tavsiyeler';

  @override
  String get aiKisilikMinimalistBaslik => 'Minimalist & Kısa';

  @override
  String get aiKisilikMinimalistAciklama =>
      'Doğrudan sadede gelen, net ve vakit kaybettirmeyen öneriler';

  @override
  String get sikiRenkTeorisiUyumModu => 'Sıkı Renk Teorisi Uyum Modu';

  @override
  String get sikiRenkTeorisiAciklama =>
      'Açıkken yapay zeka sadece klasik renk kurallarına uyar';

  @override
  String get bildirimlerVeHatirlaticiUst => 'BİLDİRİMLER VE HATIRLATICI';

  @override
  String get sabahKombinOnerisi => 'Sabah Kombin Önerisi';

  @override
  String herSabahBildirimAl(Object saat) {
    return 'Her sabah $saat vaktinde bildirim al';
  }

  @override
  String get bildirimSaatiniOzellestir => 'Bildirim Saatini Özelleştir';

  @override
  String get gunlukKombinBildirimSaati => 'Günlük kombin bildirim saati';

  @override
  String get sabahBildirimSaatiSec => 'Sabah bildirim saatini seç';

  @override
  String get saatKaydedildiAksama =>
      'Saat kaydedildi ancak bildirim servisine ulaşılamadı.';

  @override
  String sabahBildirimiAyarlandi(Object saat) {
    return 'Sabah bildirimi $saat olarak ayarlandı. ⏰';
  }

  @override
  String get bildirimIzinGerekliUyari =>
      'Bildirimleri açmak için cihaz ayarlarından izin vermeniz gerekiyor.';

  @override
  String get camasirSepetiUyarilari => 'Çamaşır Sepeti Uyarıları';

  @override
  String get camasirSepetiUyarilariAciklama =>
      'Kirlenen kıyafetlerin için akıllı hatırlatma al';

  @override
  String get haftalikStilRaporu => 'Haftalık Stil Raporu';

  @override
  String get haftalikStilRaporuAciklama =>
      'Her Pazar akşamı dolap kullanım özeti al';

  @override
  String get gorunumVeBolgeUst => 'GÖRÜNÜM VE BÖLGE';

  @override
  String get lokasyonVeBirimlerUst => 'LOKASYON VE BİRİMLER';

  @override
  String get sicaklikBirimi => 'Sıcaklık Birimi';

  @override
  String get varsayilanSehirBolge => 'Varsayılan Şehir / Bölge';

  @override
  String get sehirOrnekHint => 'Örn: İstanbul, Bursa, London';

  @override
  String get gpsKullan => 'GPS Kullan';

  @override
  String get veriVeDepolamaYonetimiUst => 'VERİ VE DEPOLAMA YÖNETİMİ';

  @override
  String get gorselOnbelleginiTemizle => 'Görsel Önbelleğini Temizle';

  @override
  String get geciciFotografHafizasiAciklama =>
      'Geçici fotoğraf hafızasını boşaltır';

  @override
  String get onbellekTemizlendiBasari =>
      'Görsel önbelleği ve geçici dosyalar temizlendi! ✨';

  @override
  String get onbellekTemizlerkenHata =>
      'Önbellek temizlenirken bir aksama oluştu.';

  @override
  String get gardirobuDisaAktarYedekle => 'Gardırobu Dışa Aktar (Yedekle)';

  @override
  String get tumKiyafetVeKombinJsonAciklama =>
      'Tüm kıyafet ve kombin verilerini JSON al';

  @override
  String get disaAktarilacakVeriYok =>
      'Dışa aktarılacak gardırop verisi bulunamadı. 📭';

  @override
  String get gardiropVerisiKopyalandi =>
      'Tüm gardırop verileriniz JSON formatında panoya kopyalandı! 📋';

  @override
  String get destekVeDegerlendirmeUst => 'DESTEK VE DEĞERLENDİRME';

  @override
  String get uygulamayiDegerlendirin => 'Uygulamayı Değerlendirin';

  @override
  String get googlePlay5YildizDestek =>
      'Google Play\'de 5 yıldız vererek destek olun ⭐';

  @override
  String get googlePlayAcilamadi => 'Google Play açılamadı.';

  @override
  String get geriBildirimVeDestek => 'Geri Bildirim & Destek';

  @override
  String get hataBildirVeyaOneri => 'Hata bildir veya yeni özellik öner';

  @override
  String get islemTamamlanamadi =>
      'İşlem tamamlanamadı. Lütfen tekrar deneyin.';

  @override
  String get epostaUygulamasiAcilamadi =>
      'E-posta uygulaması açılamadı. Lütfen ayberkzcn9@gmail.com adresine yazın.';

  @override
  String get gizlilikPolitikasiTitle => 'Gizlilik Politikası';

  @override
  String get veriKullanimiVeGizlilikHaklari =>
      'Veri kullanımı ve gizlilik haklarınızı görün';

  @override
  String get sonGuncellemeTarihi => 'Son Güncelleme: 27 Ağustos 2026';

  @override
  String get gizlilikMadde1Baslik => '1. Veri Toplama ve Kullanımı';

  @override
  String get gizlilikMadde1Icerik =>
      'FitCheck uygulaması, kişisel gardırop yönetiminizi ve kombin önerilerinizi optimize etmek için çalışır. Uygulamaya eklediğiniz kıyafet fotoğrafları, tarz ve cinsiyet tercihleriniz cihazınızda yerel olarak saklanır.';

  @override
  String get gizlilikMadde2Baslik => '2. Konum İzinleri';

  @override
  String get gizlilikMadde2Icerik =>
      'Hava durumuna uygun günlük kombin tavsiyeleri sunabilmek adına anlık konum bilginiz Open-Meteo servisleri ile anonim olarak işlenir. Konum verileriniz sunucularımızda saklanmaz veya üçüncü taraflarla paylaşılmaz.';

  @override
  String get gizlilikMadde3Baslik => '3. Sesli Asistan ve Mikrofon';

  @override
  String get gizlilikMadde3Icerik =>
      'Sesli komut ile kombin oluşturma özelliğini kullandığınızda, sesiniz anlık olarak metne dönüştürülür ve işlenir. Ses kayıtlarınız kalıcı olarak depolanmaz.';

  @override
  String get gizlilikMadde4Baslik => '4. Üçüncü Taraf Servisler';

  @override
  String get gizlilikMadde4Icerik =>
      'Uygulama performans analitiği ve reklam yayınları için Firebase ve Google AdMob altyapısı kullanılmaktadır.';

  @override
  String get anladim => 'Anladım';

  @override
  String get stilVeModaTercihleriniz => 'Stil & Moda Tercihleriniz';

  @override
  String get stilModalAciklama =>
      'Yapay zekâ kombin üretirken bu tarz ve kesim tercihlerinizi önceliklendirir.';

  @override
  String get favoriTarzinizUst => 'FAVORİ TARZINIZ';

  @override
  String get giyimKesimiFitUst => 'GİYİM KESİMİ (FIT)';

  @override
  String get hesapSilmeUst => 'HESAP SİLME';

  @override
  String get tumBulutVeYerelVeriTemizlenir =>
      'Tüm bulut ve yerel verilerinizi temizler';

  @override
  String get hakkindaUst => 'HAKKINDA';

  @override
  String get topluFotografEkleTooltip => 'Toplu Kıyafet Ekle';

  @override
  String get kuponKoduKullanTitle => 'Kupon Kodu Kullan';

  @override
  String get kuponKoduAciklama =>
      'Ekstra kombin hakkı kazanmak için kupon kodunuzu aşağıya girin:';

  @override
  String get kuponKoduHint => 'Örn: VIP2026';

  @override
  String get kuponKullanButon => 'Kullan';

  @override
  String get kuponBasariliMesaji =>
      '🎉 Kupon başarıyla tanımlandı! Haklarınız yüklendi.';

  @override
  String get kuponKullanilmisUyari =>
      '⚠️ Bu kupon kodunu daha önce kullandınız!';

  @override
  String get kuponGecersizUyari =>
      '❌ Geçersiz kupon kodu! Lütfen tekrar deneyin.';

  @override
  String get sinirsizIslemHakkiBaslik => 'Sınırsız İşlem Hakkı 👑';

  @override
  String kalanHakkinizBaslik(Object hak) {
    return 'Kalan Hakkınız: $hak ⚡';
  }

  @override
  String get sinirsizHakAciklama =>
      'Premium ayrıcalığıyla tüm kombin ve stil analizlerini sınırsız kullanabilirsiniz.';

  @override
  String get gunlukHakAciklama =>
      'Günlük haklarınız her gün 00:00\'da yenilenir. Daha fazla hak için reklam izleyebilir veya kupon kullanabilirsiniz.';

  @override
  String get kuponKullan => 'Kupon Kullan';

  @override
  String get hakEklendiTebrikler => 'Tebrikler! +2 İşlem hakkı tanımlandı. ✨';

  @override
  String get gardirobunDolduTitle => 'Gardırobun Doldu!';

  @override
  String gardirobunDolduIcerik(Object limit) {
    return 'Mevcut limitin olan $limit kıyafete ulaştın. Kısa bir video izleyerek gardırobuna +2 kıyafet yükleme alanı eklemek ister misin? 👕';
  }

  @override
  String get reklamIzleSlotEkle => 'Reklam İzle (+2 Slot)';

  @override
  String get yeniSlotEklendiTebrikler =>
      'Tebrikler! Gardırobuna +2 yeni kıyafet alanı eklendi. 🎉';

  @override
  String get gunlukHakBittiTitle => 'Günlük Hakkın Bitti!';

  @override
  String get gunlukHakBittiIcerik =>
      'Bugünlük ücretsiz işlem hakkını tamamladın. Kısa bir video izleyerek veya kupon girerek yeni haklar kazanabilirsin! 🛍️';

  @override
  String get kuponGir => 'Kupon Gir';

  @override
  String get anaSemsiyeBildirimBaslik => 'Şemsiyeni Unutma! ☔';

  @override
  String get anaSemsiyeBildirimIcerik =>
      'Bugün hava yağmurlu görünüyor, kombinini buna göre seçmeyi unutma.';

  @override
  String get anaCamasirGunuBildirimBaslik => 'Çamaşır Günü! 🧺';

  @override
  String get anaCamasirGunuBildirimIcerik =>
      'Sepetinde yıkanmayı bekleyen kıyafetler birikti. Makineyi çalıştırma vakti!';

  @override
  String chatZorunluParcaMesaji(Object parca) {
    return '✨ Bu parçayla ne giyebilirim? ($parca)';
  }

  @override
  String chatKombinHazirBaslik(Object ortam) {
    return 'Kombinin Hazır ($ortam)';
  }

  @override
  String get chatKombiniGorButon => 'Kombini Gör';

  @override
  String get chatStilistKombinTasarlayor => 'Stilist kombini tasarlıyor...';

  @override
  String get chatStilistYaziyor => 'Stilist yazıyor...';

  @override
  String get pazartesi => 'Pazartesi';

  @override
  String get sali => 'Salı';

  @override
  String get carsamba => 'Çarşamba';

  @override
  String get persembe => 'Perşembe';

  @override
  String get cuma => 'Cuma';

  @override
  String get cumartesi => 'Cumartesi';

  @override
  String get pazar => 'Pazar';

  @override
  String get rehberiAtla => 'REHBERİ ATLA';

  @override
  String get rehberAnladimBasla => 'Anladım, Başla!';

  @override
  String get rehberSonrakiAdim => 'Sonraki Adım ➔';

  @override
  String get rehberGardirobuDijitallestirBaslik =>
      '📸 Gardırobunu Dijitalleştir';

  @override
  String get rehberGardirobuDijitallestirAciklama =>
      'Bu butona basarak kıyafetlerinin fotoğrafını çekebilir veya galerinden ekleyerek kendi dijital gardırobunu oluşturabilirsin.';

  @override
  String get rehberSesliAsistanBaslik => '🎙️ Sesli Stil Asistanı';

  @override
  String get rehberSesliAsistanAciklama =>
      'Sesli komut vererek ne giyeceğini sorabilir veya hızlıca kombin tavsiyesi alabilirsin.';

  @override
  String get rehberAiStilistBaslik => '✨ AI Stilist Önerileri';

  @override
  String get rehberAiStilistAciklama =>
      'Günün havasına, ten rengine ve tarzına en uygun kombin önerilerini tek tıkla yapay zekadan alabilirsin.';

  @override
  String get rehberAyarlarBaslik => '⚙️ Kişiselleştirme & Ayarlar';

  @override
  String get rehberAyarlarAciklama =>
      'Cinsiyet, ten rengi, renk ve tema tercihlerini ayarlayabilir veya kullanım rehberine tekrar ulaşabilirsin.';

  @override
  String get rehberNavGardirobumBaslik => '👔 Gardırobum';

  @override
  String get rehberNavGardirobumAciklama =>
      'Tüm kıyafetlerini kategorilerine göre görüntüle, filtrele ve pratik bir şekilde yönet.';

  @override
  String get rehberNavHaftalikBaslik => '📅 Haftalık Planlayıcı';

  @override
  String get rehberNavHaftalikAciklama =>
      'Önümüzdeki günlerin hava durumuna göre kombinlerini gün gün önceden planla.';

  @override
  String get rehberNavDolaptanBaslik => '🤖 AI Dolaptan Kombin';

  @override
  String get rehberNavDolaptanAciklama =>
      'Mevcut kıyafetlerin arasından günün şartlarına en uygun otomatik kombinleri yapay zekaya ürettir.';

  @override
  String get rehberNavKendiBaslik => '🎨 Kendi Kombinini Yap';

  @override
  String get rehberNavKendiAciklama =>
      'Üst, alt ve ayakkabı parçalarını manuel eşleştirerek kendi stilini oluştur ve kaydet.';

  @override
  String get rehberNavProfilBaslik => '📊 Analiz & Çamaşır Sepeti';

  @override
  String get rehberNavProfilAciklama =>
      'Kıyafet giyilme istatistiklerini incele ve kirlenen parçalarını çamaşır sepetinden takip et.';

  @override
  String get bildirimIzinGerekliBaslik => 'Bildirim İzni Gerekli';

  @override
  String get bildirimIzinGerekliIcerik =>
      'Çamaşır günü hatırlatıcıları, yağmurlu hava uyarıları ve günlük stil önerilerini alabilmek için bildirim izinlerini açmanız önerilir.';

  @override
  String get bildirimGunaydinBaslik => 'Günaydın! ☀️';

  @override
  String get bildirimGunaydinIcerik =>
      'Bugünün hava durumuna göre harika bir kombin hazırladım. Görmek ister misin?';

  @override
  String get bildirimKanalGenelBaslik => 'Genel Bildirimler';

  @override
  String get bildirimKanalGenelAciklama => 'FitCheck genel bildirimleri';

  @override
  String get bildirimKanalGunlukBaslik => 'Günlük Kombin Önerileri';

  @override
  String get bildirimKanalGunlukAciklama =>
      'Günlük kombin önerileri bildirimleri';

  @override
  String get bildirimKanalYikamaBaslik => 'Çamaşır Hatırlatıcıları';

  @override
  String get bildirimKanalYikamaAciklama =>
      'Çamaşır ve kıyafet bakım hatırlatıcıları';

  @override
  String get bildirimKanalRaporBaslik => 'Haftalık Stil Raporları';

  @override
  String get bildirimKanalRaporAciklama =>
      'Haftalık gardırop ve stil raporları';

  @override
  String get tenRengiAcik => 'Açık / Beyaz';

  @override
  String get tenRengiBugday => 'Buğday';

  @override
  String get tenRengiEsmer => 'Esmer / Koyu';

  @override
  String get stilStreetwear => 'Streetwear / Casual';

  @override
  String get stilKlasik => 'Klasik / Ofis';

  @override
  String get stilMinimalist => 'Minimalist';

  @override
  String get stilSpor => 'Spor / Athleisure';

  @override
  String get stilVintage => 'Vintage / Retro';

  @override
  String get fitSlim => 'Slim Fit';

  @override
  String get fitRegular => 'Regular Fit';

  @override
  String get fitOversize => 'Oversize / Relaxed';

  @override
  String get gardirobumBosBaslik => 'Dolabın Çok Boş!';

  @override
  String get gardirobumGizlendiBaslik => 'Gardırop Gizlendi';

  @override
  String get gardirobumGizlendiAciklama =>
      'Görüntülemek için sağ üstteki göz simgesine dokunun';

  @override
  String get gardirobumGoster => 'İçeriği Göster';

  @override
  String get gardirobumGizle => 'İçeriği Gizle';

  @override
  String get kategoriUst => 'ÜST';

  @override
  String get kategoriAlt => 'ALT';

  @override
  String get kategoriAyakkabi => 'AYAKKABI';

  @override
  String get kategoriAksesuar => 'AKSESUAR';

  @override
  String get gardirobumBosAciklama =>
      'Hemen ilk kıyafetini ekle ve yapay zekanın sihrini gör.';

  @override
  String get gardirobumAiIslem1 => 'Gardıroburuz taranıyor...';

  @override
  String get gardirobumAiIslem2 => 'Hava durumu analiz ediliyor...';

  @override
  String get gardirobumAiIslem3 => 'Renk uyumları hesaplanıyor...';

  @override
  String get gardirobumAiIslem4 => 'En iyi kombinler seçiliyor...';

  @override
  String get gardirobumAiIslem5 => 'Son dokunuşlar yapılıyor...';

  @override
  String get gardirobumHakBittiBaslik => 'Günlük Limit Doldu';

  @override
  String get gardirobumHakBittiAciklama =>
      'Günlük kombin oluşturma limitinize ulaştınız.';

  @override
  String get gardirobumHakEklendiMesaj =>
      'Tebrikler, yeni kombin hakkı kazanıldı!';

  @override
  String get ayarlariAc => 'Ayarları Aç';

  @override
  String get kiyafetEkle => 'Kıyafet Ekle';

  @override
  String get kameraIleCek => 'Kamera ile Çek';

  @override
  String get galeridenSecToplu => 'Galeriden Toplu Seç';

  @override
  String get kameraIzniGerekliBaslik => 'Kamera İzni Gerekli';

  @override
  String get kameraIzniGerekliAciklama =>
      'Fotoğraf çekebilmek için lütfen kamera izni verin.';

  @override
  String get kiyafetDuzenleBaslik => 'Kıyafeti Düzenle';

  @override
  String get kategori => 'Kategori';

  @override
  String get evetSil => 'Evet, Sil';

  @override
  String get favorilerdenCikarildi => 'Favorilerden çıkarıldı';

  @override
  String get gardirobumHenuzYokEkle =>
      'Henüz kıyafet eklenmedi. Hemen ekleyin!';

  @override
  String gardirobumMaksFotografUyari(int max) {
    return 'En fazla $max adet fotoğraf seçebilirsiniz.';
  }

  @override
  String gardirobumUrunSayisi(int count) {
    return '$count Ürün';
  }

  @override
  String kombinUyumYuzdesi(String oran) {
    return '%$oran Uyum';
  }

  @override
  String get kombinSohbetAc => 'Kombin hakkında sohbet et';

  @override
  String get kombinSohbetBaslik => 'Kombin Sohbeti';

  @override
  String kombinSohbetAltBaslik(Object gun) {
    return '$gun kombini üzerine sohbet';
  }

  @override
  String kombinSohbetKarsilama(Object kombin) {
    return '$kombin kombinini birlikte inceleyelim! Renk uyumu, hava durumu ya da alternatif parçalar hakkında ne istersen sorabilirsin. ✨';
  }

  @override
  String get kombinSohbetOneriUyum => '🤔 Bu kombin neden uyumlu?';

  @override
  String get kombinSohbetOneriAlternatif => '👟 Alternatif parça öner';

  @override
  String get kombinSohbetOneriHava => '🌦️ Hava değişirse ne giyerim?';

  @override
  String get kombinSohbetOneriAksesuar => '💍 Aksesuar önerisi ver';

  @override
  String get kombinSohbetAltBaslikAnlik => 'Anlık kombin üzerine sohbet';

  @override
  String get chatKirliSepetiBos =>
      '🧺 Kirli sepetin boş! Tüm parçaların kullanıma hazır, istediğin zaman kombin hazırlayabilirim. ✨';

  @override
  String chatKirliSepetiDoluBaslik(Object sayi) {
    return '🧺 Kirli sepetinde **$sayi** parça yıkanmayı bekliyor:';
  }

  @override
  String get chatKirliSepetiDoluNot =>
      'Bu parçalar yıkanana kadar kombin önerilerine dahil edilmez. İstersen temiz parçalarınla hemen bir kombin hazırlayabilirim.';

  @override
  String get analitikVerileriPaylas => 'Analitik verileri paylaş';

  @override
  String get analitikVerileriPaylasAciklama =>
      'Uygulama deneyimini iyileştirmek için anonim kullanım verileri gönderilir. Kapatırsanız bu cihazdaki analitik veriler silinir.';

  @override
  String get chatKarsilamaHavaYok =>
      'Selam! 👋 Senin tarzına uygun harika bir kombin hazırlayalım mı? ✨';

  @override
  String get premiumBaslik => 'Aylık reklamsız kullanım';

  @override
  String get premiumAciklama =>
      'FitCheck deneyimini reklamsız kullan. Aboneliğin aktif olduğu sürece tüm reklamlar kaldırılır.';

  @override
  String get premiumOzellikReklamsiz => 'Tüm reklamlar kaldırılır';

  @override
  String get premiumOzellikAylik => 'Aylık otomatik yenilenir';

  @override
  String get premiumOzellikMagaza => 'Google Play üzerinden yönetilir';

  @override
  String get premiumAktifMesaji =>
      'Premium aktif. Reklamlar hesabınız için kapalı.';

  @override
  String get premiumAboneOl => 'Aylık abone ol';

  @override
  String premiumAboneOlFiyatli(String fiyat) {
    return 'Aylık abone ol • $fiyat';
  }

  @override
  String get premiumGeriYukle => 'Satın almayı geri yükle';

  @override
  String get premiumMagazaHazirDegil =>
      'Google Play bağlantısı hazır değil. Lütfen tekrar deneyin.';

  @override
  String get premiumSatinAlmaBaslatilamadi => 'Satın alma başlatılamadı.';

  @override
  String get premiumSatinAlmaBasarisiz => 'Satın alma başarısız oldu.';

  @override
  String get premiumAylikBaslik => 'Aylık Reklamsız Premium';

  @override
  String premiumAylikAltBaslik(String fiyat) {
    return 'Aylık $fiyat ile reklamları kaldır';
  }

  @override
  String premiumGec(String fiyat) {
    return 'Premium’a geç • $fiyat/ay';
  }

  @override
  String get guncellemeBaslik => 'Güncelleme gerekli';

  @override
  String get guncellemeAciklama =>
      'FitCheck\'in yeni bir sürümü yayınlandı. Devam edebilmek için lütfen uygulamayı güncelle.';

  @override
  String get guncellemeButonu => 'Şimdi güncelle';

  @override
  String guncellemeYeniSurum(String surum) {
    return 'Yeni sürüm: $surum';
  }

  @override
  String get guncellemeMagazaUrlYok =>
      'Mağaza bağlantısı bulunamadı. Lütfen uygulamayı mağazadan güncelleyin.';

  @override
  String get premiumUrunBulunamadi =>
      'Abonelik bilgisi alınamadı. Daha sonra tekrar deneyin.';

  @override
  String get triviaQ1 =>
      'Taba / Turuncu tonları ile renk çarkında tam zıt konumda yer alan ve güçlü bir kontrast oluşturan renk hangisidir?';

  @override
  String get triviaQ1o1 => 'Saks Mavisi / Petrol Mavisi';

  @override
  String get triviaQ1o2 => 'Zümrüt Yeşili';

  @override
  String get triviaQ1o3 => 'Bordo';

  @override
  String get triviaQ1o4 => 'Hardal Sarısı';

  @override
  String get triviaQ2 =>
      'Modada \'Monokrom\' (Monochromatic) giyim tarzı ne anlama gelir?';

  @override
  String get triviaQ2o1 =>
      'Tek bir rengin farklı tonlarını bir arada kullanmak';

  @override
  String get triviaQ2o2 => 'Sadece siyah ve beyaz kıyafetler giyinmek';

  @override
  String get triviaQ2o3 => 'En az 3 zıt rengi aynı anda harmanlamak';

  @override
  String get triviaQ2o4 => 'Sadece desenli ve baskılı parçaları eşleştirmek';

  @override
  String get triviaQ3 =>
      'Altın (Gold) takıların, kiremit ve zeytin yeşili gibi tonların en çok yakıştığı cilt alt tonu hangisidir?';

  @override
  String get triviaQ3o1 => 'Soğuk (Cool) Alt Ton';

  @override
  String get triviaQ3o2 => 'Sıcak (Warm) Alt Ton';

  @override
  String get triviaQ3o3 => 'Mavi Alt Ton';

  @override
  String get triviaQ3o4 => 'Pembe Alt Ton';

  @override
  String get triviaQ4 =>
      'Kapsül gardırop oluştururken her renkle kolayca eşleşen \'Nötr Renkler\' grubunda hangisi YER ALMAZ?';

  @override
  String get triviaQ4o1 => 'Bej / Krem';

  @override
  String get triviaQ4o2 => 'Lacivert';

  @override
  String get triviaQ4o3 => 'Flaş (Neon) Sarı';

  @override
  String get triviaQ4o4 => 'Taba / Kahverengi';

  @override
  String get triviaQ5 =>
      'Renk çarkında yan yana duran ve yumuşak, göz yormayan bir geçiş sağlayan renk grubuna ne ad verilir?';

  @override
  String get triviaQ5o1 => 'Tamamlayıcı (Zıt) Renkler';

  @override
  String get triviaQ5o2 => 'Analog Renkler';

  @override
  String get triviaQ5o3 => 'Pastel Renkler';

  @override
  String get triviaQ5o4 => 'Triadik Renkler';

  @override
  String get triviaQ6 =>
      'Modada vücut oranını daha uzun ve dengeli göstermek için uygulanan \'Üçte Bir Kuralı\' (Rule of Thirds) hangisidir?';

  @override
  String get triviaQ6o1 => '1/2 Üst - 1/2 Alt (Gövde ve bacak eşit)';

  @override
  String get triviaQ6o2 => '1/3 Üst - 2/3 Alt (Yüksek bel / Kısa üst)';

  @override
  String get triviaQ6o3 => '2/3 Üst - 1/3 Alt (Uzun tunik / Kısa alt)';

  @override
  String get triviaQ6o4 => '3/3 Tam boy tek parça';

  @override
  String get triviaQ7 =>
      'Fransızca moda terimi olan \'Ton-sür-ton\' giyim tekniği neyi ifade eder?';

  @override
  String get triviaQ7o1 =>
      'Aynı rengin farklı doygunluk ve açık/koyu nüanslarını katmanlamak';

  @override
  String get triviaQ7o2 => 'Tamamen zıt iki rengi keskin hatlarla birleştirmek';

  @override
  String get triviaQ7o3 => 'Siyah ve beyaz desenleri karıştırmak';

  @override
  String get triviaQ7o4 => 'Farklı kumaş dokularını tek renkte toplamak';

  @override
  String get triviaQ8 =>
      'Klasik ve formal giyim kurallarına göre, deri kemer rengi hangisiyle birebir eşleşmelidir?';

  @override
  String get triviaQ8o1 => 'Kravat veya Şal';

  @override
  String get triviaQ8o2 => 'Gömlek';

  @override
  String get triviaQ8o3 => 'Ayakkabı';

  @override
  String get triviaQ8o4 => 'Ceket Astarı';

  @override
  String get triviaQ9 =>
      'Renk çarkında eşit uzaklıktaki 3 rengin (Ör: Kırmızı, Sarı, Mavi) oluşturduğu canlı kombin tarzına ne denir?';

  @override
  String get triviaQ9o1 => 'Triadik (Üçlü) Renk Uyumu';

  @override
  String get triviaQ9o2 => 'Nötr Uyum';

  @override
  String get triviaQ9o3 => 'Monokrom Uyum';

  @override
  String get triviaQ9o4 => 'Kapsül Geçiş';

  @override
  String get triviaQ10 =>
      'Ten rengine (Nude) veya giyilen pantolonun rengine tam uyan bir ayakkabı seçmek nasıl bir görsel etki yaratır?';

  @override
  String get triviaQ10o1 => 'Bacak boyunu kesintisiz ve daha uzun gösterir';

  @override
  String get triviaQ10o2 => 'Vücudu daha geniş gösterir';

  @override
  String get triviaQ10o3 => 'Omuz genişliğini öne çıkarır';

  @override
  String get triviaQ10o4 => 'Boyu olduğundan kısa gösterir';

  @override
  String get kombinOyunuBaslik => 'Kombin Oyunu';

  @override
  String get kombinMevcutKombin => 'Mevcut Kombin';

  @override
  String get kombinParcaUst => 'Üst';

  @override
  String get kombinParcaAlt => 'Alt';

  @override
  String get kombinEksik_ayakkabi => 'Eksik: Ayakkabı';

  @override
  String get kombinEksik_ceket => 'Eksik: Ceket';

  @override
  String get kombinEksik_aksesuar => 'Eksik: Aksesuar';

  @override
  String get kombinSoru_ayakkabi => 'Hangi ayakkabı en uygun?';

  @override
  String get kombinSoru_ceket => 'Hangi ceket en uygun?';

  @override
  String get kombinSoru_aksesuar => 'Hangi aksesuar en uygun?';

  @override
  String get kombinKategoriAyakkabi => 'Ayakkabı';

  @override
  String get kombinKategoriCeket => 'Ceket';

  @override
  String get kombinKategoriAksesuar => 'Aksesuar';

  @override
  String get kombinOrtamOfis => 'Ofis';

  @override
  String get kombinOrtamCasual => 'Casual';

  @override
  String get kombinOrtamDavet => 'Davet';

  @override
  String get kombinOrtamSpor => 'Spor';

  @override
  String get kombinHavaGunesli => 'Güneşli';

  @override
  String get kombinHavaYagmurlu => 'Yağmurlu';

  @override
  String get kombinHavaSoguk => 'Soğuk';

  @override
  String get kombinHavaSicak => 'Sıcak';

  @override
  String get kombinRenkBeyaz => 'Beyaz';

  @override
  String get kombinRenkSiyah => 'Siyah';

  @override
  String get kombinRenkKahverengi => 'Kahverengi';

  @override
  String get kombinRenkLacivert => 'Lacivert';

  @override
  String get kombinRenkBej => 'Bej';

  @override
  String get kombinRenkKoyuYesil => 'Koyu Yeşil';

  @override
  String get kombinRenkNude => 'Nude';

  @override
  String get kombinRenkAltin => 'Altın';

  @override
  String get kombinRenkGri => 'Gri';

  @override
  String get kombinRenkPastelMavi => 'Pastel Mavi';

  @override
  String get kombinRenkKirmizi => 'Kırmızı';

  @override
  String get kombinRenkMavi => 'Mavi';

  @override
  String get kombinRenkGumus => 'Gümüş';

  @override
  String get kombinRenkKoyuMavi => 'Koyu Mavi';

  @override
  String get kombinRenkKamel => 'Kamel';

  @override
  String get kombinRenkYesil => 'Yeşil';

  @override
  String get kombinRenkAcikMavi => 'Açık Mavi';

  @override
  String get kombinRenkNavy => 'Navy';

  @override
  String get kombinSecenekKahverengiOxford => 'Kahverengi Deri Oxford';

  @override
  String get kombinSecenekSiyahDerby => 'Siyah Deri Derby';

  @override
  String get kombinSecenekBeyazSpor => 'Beyaz Spor Ayakkabı';

  @override
  String get kombinSecenekKahverengiCizme => 'Kahverengi Çizme';

  @override
  String get kombinSecenekSiyahSuGecirmezBot => 'Siyah Su Geçirmez Bot';

  @override
  String get kombinSecenekNudeBallerina => 'Nude Ballerina';

  @override
  String get kombinSecenekAltinSandalet => 'Altın Sandalet';

  @override
  String get kombinSecenekSiyahBlazer => 'Siyah Blazer';

  @override
  String get kombinSecenekKirmiziDeriCeket => 'Kırmızı Deri Ceket';

  @override
  String get kombinSecenekAltinDetayliCeket => 'Altın Detaylı Ceket';

  @override
  String get kombinSecenekBeyazPufy => 'Beyaz Pufy Ceket';

  @override
  String get kombinSecenekBeyazKosu => 'Beyaz Koşu Ayakkabısı';

  @override
  String get kombinSecenekSiyahBasketbol => 'Siyah Basketbol Ayakkabısı';

  @override
  String get kombinSecenekMaviTerlik => 'Mavi Terlik';

  @override
  String get kombinSecenekKahverengiLoafer => 'Kahverengi Loafer';

  @override
  String get kombinSecenekBeyazBespan => 'Beyaz Beşpan';

  @override
  String get kombinSecenekSiyahGunes => 'Siyah Güneş Gözlüğü';

  @override
  String get kombinSecenekSiyahSirtCantasi => 'Siyah Sırt Çantası';

  @override
  String get kombinSecenekGumusAkilliSaat => 'Gümüş Akıllı Saat';

  @override
  String get kombinSecenekKamelCifteYaka => 'Kamel Renkli Çifte Yaka';

  @override
  String get kombinSecenekSiyahBomber => 'Siyah Bomber';

  @override
  String get kombinSecenekKirmiziPufy => 'Kırmızı Pufy';

  @override
  String get kombinSecenekYesilDenim => 'Yeşil Denim Ceket';

  @override
  String get kombinSecenekKahverengiKemer => 'Kahverengi Kemer';

  @override
  String get kombinSecenekSiyahKemer => 'Siyah Kemer';

  @override
  String get kombinSecenekNavyBlokSal => 'Navy Blok Şal';

  @override
  String get kombinSecenekKahverengiGozluk => 'Kahverengi Gözlük';

  @override
  String get kombinSecenekGriSuGecirmez => 'Gri Su Geçirmez Koşu';

  @override
  String get kombinSecenekKahverengiTrekking => 'Kahverengi Trekking Botu';

  @override
  String get kombinSecenekSiyahTerlik => 'Siyah Terlik';

  @override
  String get kombinSecenekBeyazTenis => 'Beyaz Tenis Ayakkabısı';

  @override
  String get kombinOyunBitti => 'Oyun Bitti';

  @override
  String get kombinToplamPuan => 'Toplam Puan';

  @override
  String get kombinBasariOrani => 'Başarı Oranı';

  @override
  String get kombinTekrarOyna => 'Tekrar Oyna';

  @override
  String get kombinAnaSayfa => 'Ana Sayfa';

  @override
  String get kombinSonucUsta => 'Stil Ustası! 🏆';

  @override
  String get kombinSonucUstaMesaj => 'Renk ve uyum hissini ödüllemeye değer!';

  @override
  String get kombinSonucIyi => 'İyi Gidiyorsun! 👍';

  @override
  String get kombinSonucIyiMesaj => 'Az pratikle mükemmel olacaksın.';

  @override
  String get kombinSonucPratik => 'Pratik Lazım 📚';

  @override
  String get kombinSonucPratikMesaj =>
      'Renk teorisi ipuçları için \"Analiz\" sekmesine bak.';

  @override
  String get degerlendirmeBaslik => 'FitCheck\'i beğendiniz mi?';

  @override
  String get degerlendirmeIcerik =>
      'Uygulamayı seviyorsanız 5 saniyenizi ayırıp bize yorum bırakabilir misiniz? Küçük yorumlar büyük destek! ⭐ Değerlendirme yapanlara +3 hak hediye!';

  @override
  String get degerlendirmeEvet => 'Evet, değerlendireyim';

  @override
  String get degerlendirmeBelkiSonra => 'Belki sonra';

  @override
  String get yakinda => 'Yakında';

  @override
  String get yakindaAciklama =>
      'Bu özellik üzerinde çalışıyoruz, çok yakında sizlerle!';
}
