// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get chatOrtamCasual => 'Casual';

  @override
  String get chatOrtamOfis => 'Ofis';

  @override
  String get chatOrtamDavet => 'Davet';

  @override
  String get chatOrtamSpor => 'Spor';

  @override
  String get chatOrtamGece => 'Gece';

  @override
  String get chatOrtamRomantik => 'Romantik';

  @override
  String get chatOrtamHaftaSonu => 'Hafta Sonu';

  @override
  String get gardirobumAdimArkaplan => 'Arkaplan Siliniyor';

  @override
  String get gardirobumAdimArkaplanAlt => 'AI ile görüntü ayrıştırılıyor';

  @override
  String get gardirobumAdimAnaliz => 'Kıyafet Analiz Ediliyor';

  @override
  String get gardirobumAdimAnalizAlt => 'Renk, stil, kategori belirleniyor';

  @override
  String get gardirobumAdimKaydet => 'Kaydediliyor';

  @override
  String get gardirobumAdimKaydetAlt => 'Gardıroba ekleniyor';

  @override
  String get gardirobumLutfenBekleyin => 'Lütfen bekleyin...';

  @override
  String get authHataZayifSifre =>
      'Girilen şifre çok zayıf. En az 6 karakter olmalı.';

  @override
  String get authHataEpostaKullanimda => 'Bu e-posta adresi zaten kullanımda.';

  @override
  String get authHataGecersizEposta => 'Geçersiz bir e-posta adresi girdiniz.';

  @override
  String get authHataKullaniciBulunamadi =>
      'Bu e-posta adresine ait kullanıcı bulunamadı.';

  @override
  String get authHataYanlisSifre => 'Şifre hatalı, lütfen tekrar deneyin.';

  @override
  String get authHataGecersizKimlik =>
      'E-posta veya şifre hatalı. Lütfen bilgilerinizi kontrol edin.';

  @override
  String get authHataYontemIzinliDegil =>
      'Giriş yöntemi Firebase Konsolu üzerinden etkinleştirilmemiş.';

  @override
  String get authHataFarkliYontem =>
      'Bu e-posta adresi farklı bir giriş yöntemi ile zaten kayıtlı.';

  @override
  String get authHataAgHatasi =>
      'İnternet bağlantınızı kontrol edip tekrar deneyin.';

  @override
  String get authHataCokDeneme =>
      'Çok fazla deneme yaptınız. Lütfen biraz sonra tekrar deneyin.';

  @override
  String get authHataHesapDevreDisi => 'Bu hesap devre dışı bırakılmış.';

  @override
  String get authHataYenidenGiris =>
      'Bu işlem için tekrar giriş yapmanız gerekiyor.';

  @override
  String get authHataGenel => 'Bir hata oluştu. Lütfen tekrar deneyin.';

  @override
  String get authHataSifreEpostasiGonderilemedi =>
      'Şifre sıfırlama e-postası gönderilemedi. Lütfen tekrar deneyin.';

  @override
  String get authHataGoogleDogrulanamadi =>
      'Google oturumu doğrulanamadı. Lütfen tekrar deneyin.';

  @override
  String get authHataGoogleFarkliKullanici =>
      'Bu Google hesabı başka bir kullanıcıya bağlı.';

  @override
  String get authHataGoogleZatenBagli => 'Bu Google hesabı zaten bağlı.';

  @override
  String get authHataGoogleYapilandirilmamis =>
      'Google ile giriş bu cihazda yapılandırılmamış. Lütfen bu hatayı destek ekibine bildirin.';

  @override
  String get authHataGooglePencereAcik =>
      'Google giriş penceresi hâlâ açık. Birkaç saniye bekleyip tekrar deneyin.';

  @override
  String get authHataGoogleTamamlanamadi =>
      'Google ile giriş tamamlanamadı. Lütfen birkaç saniye sonra tekrar deneyin.';

  @override
  String get authHataGoogleHesapSec =>
      'Oturum açmak için Google hesabınızı seçmeniz gerekiyor.';

  @override
  String get authHataGoogleOnayBekliyor =>
      'Google hesabınızda onay bekleyen bir işlem var. Lütfen tekrar deneyin.';

  @override
  String get authHataGoogleBeklenmeyen =>
      'Google ile giriş yapılırken beklenmeyen bir hata oluştu. Lütfen tekrar deneyin.';

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
  String get ayarOtomatikCihazDili => 'Otomatik (Cihaz Dili)';

  @override
  String get iptal => 'İptal';

  @override
  String get tamam => 'Tamam';

  @override
  String get gardirobumTitle => 'Sanal Gardırobum';

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
  String get stilistTitle => 'Anlık Kombin Stilisti';

  @override
  String get gunlukKombinTitle => 'Günlük Kombin';

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
    return 'Uyum: %$puan';
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
      'Gardırobun Boş Veya Tüm Parçalar Yıkamada';

  @override
  String get stilistUyariDolapBosIcerik =>
      'Sana özel anlık kombinler yapabilmem için dolabına birkaç temiz kıyafet veya aksesuar eklemelisin.';

  @override
  String get stilistUyariUstEksikBaslik => 'Üst Giyim Eksik';

  @override
  String get stilistUyariUstEksikIcerik =>
      'Gardırobunda henüz hiç temiz üst giyim yok. Tam bir kombin için dolabına en az bir üst parçası eklemelisin';

  @override
  String get stilistUyariAltEksikBaslik => 'Alt Giyim Eksik';

  @override
  String get stilistUyariAltEksikIcerik =>
      'Gardırobunda henüz hiç temiz alt giyim yok. Şık bir kombin yapabilmemiz için dolabına bir alt parçası eklemelisin';

  @override
  String get stilistUyariAyakkabiEksikBaslik => 'Ayakkabın Eksik';

  @override
  String get stilistUyariAyakkabiEksikIcerik =>
      'Kıyafetlerin harika görünüyor ama kombinini tamamlayacak temiz bir ayakkabı bulamadım. Dolabına hemen bir ayakkabı ekle';

  @override
  String get stilistUyariButon => 'Anladım, Ekliyorum';

  @override
  String get anaHavaYukleniyor => 'Konum hava durumu yükleniyor...';

  @override
  String get anaDinliyor => 'FITCHECK Sizi Dinliyor... Konuşun';

  @override
  String get anaMikrofonHata =>
      'Mikrofon izni veya ses tanıma servisi hazır değil.';

  @override
  String anaCinsiyetGuncellendi(Object cinsiyet) {
    return 'Tercihiniz \"$cinsiyet\" olarak güncellendi';
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
  String get anaFavoriEklendi => 'Kombin favorilere eklendi ⭐';

  @override
  String get anaKombinTekrarUyari =>
      'Uyarı: Bu parçaları veya benzerlerini son zamanlarda çok sık giydin. Bugün farklı bir tarz deneyebilirsin';

  @override
  String get anaKombinMukemmel =>
      'Mükemmel seçim Tarzın bugün gayet dengeli ve ferah.';

  @override
  String get anaYikamaUyariBaslik => 'Akıllı Yıkama Uyarısı';

  @override
  String anaYikamaUyariIcerik(Object parcalar) {
    return 'Bu kombini giydiğiniz için \"$parcalar\" adlı parça(lar) çok sık kullanıldı ve otomatik olarak yıkama sepetine gönderildi';
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
  String get stilKahveBaslik => 'Kahve & Günlük';

  @override
  String get stilKahveSoru =>
      'Arkadaşlarla kahveye çıkmak için günlük şık bir kombin öner';

  @override
  String get stilOfisBaslik => 'İş / Ofis Şıklığı';

  @override
  String get stilOfisSoru =>
      'Ofis ve iş ortamına uygun modern ve şık bir kombin öner';

  @override
  String get stilSporBaslik => 'Spor / Rahat Giyim';

  @override
  String get stilSporSoru =>
      'Hafta sonu gezisi için çok rahat ve spor bir kombin öner';

  @override
  String get stilGeceBaslik => 'Gece / Özel Davet';

  @override
  String get stilGeceSoru =>
      'Akşam yemeği veya özel davet için iddialı bir kombin öner';

  @override
  String get ilkGorevBaslik => 'İlk Görev: Stilini Seç';

  @override
  String get ilkGorevAciklama =>
      'FitCheck Yapay Zekası senin için anında kombin üretecek. Bugün nereye gidiyorsun?';

  @override
  String get haftalikUyariButon => 'Anladım';

  @override
  String get haftalikUyariDolapBosBaslik => 'Gardırobun Boş';

  @override
  String get haftalikUyariDolapBosIcerik =>
      'Haftalık plan yapabilmem için dolabına kıyafet eklemelisin.';

  @override
  String get haftalikUyariUstEksikBaslik => 'Üst Giyim Eksik';

  @override
  String get haftalikUyariUstEksikIcerik =>
      'Dolabında hiç temiz üst giyim yok.';

  @override
  String get haftalikUyariAltEksikBaslik => 'Alt Giyim Eksik';

  @override
  String get haftalikUyariAltEksikIcerik =>
      'Dolabında hiç temiz alt giyim yok.';

  @override
  String get haftalikUyariAyakkabiEksikBaslik => 'Ayakkabı Eksik';

  @override
  String get haftalikUyariAyakkabiEksikIcerik =>
      'Dolabında temiz ayakkabı bulunmuyor.';

  @override
  String get haftalikHata => 'Haftalık plan oluşturulurken hata oluştu.';

  @override
  String get haftalikAjandaTitle => 'Haftalık Stil Ajandası';

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
  String get profilAnalizTitle => 'Profil & Analiz';

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
  String get onboardingHosGeldinBaslik => 'FitCheck\'e Hoş Geldin';

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
  String get stilDunyanaTekrarHosGeldin => 'Stil dünyana tekrar hoş geldin';

  @override
  String get kombinleriniSaklamakIcinKatil =>
      'Kombinlerini saklamak için aramıza katıl';

  @override
  String get girisYap => 'Giriş Yap';

  @override
  String get girisYapGoogle => 'Google ile Giriş Yap';

  @override
  String get girisYapApple => 'Apple ile Giriş Yap';

  @override
  String get aiOnayVazgec => 'Vazgeç';

  @override
  String get aiBildirimTesekkur => 'Bildirimin alındı. Teşekkürler.';

  @override
  String get aiBildirimGonder => 'Bildir';

  @override
  String get aiBildirimIcerik =>
      'Bu AI yanıtını uygunsuz veya yanıltıcı bulduysan bize bildir. Yanıt metni incelenmek üzere kaydedilir.';

  @override
  String get aiBildirimBaslik => 'Yanıtı bildir';

  @override
  String get aiYanitBildir => 'Bu yanıtı bildir';

  @override
  String get aiOnayKabul => 'Kabul et ve devam et';

  @override
  String get aiOnayIcerik =>
      'Kıyafet fotoğrafların ve yazdığın metinler, stil analizi ve kombin önerisi için Google (Gemini) ve Groq yapay zekâ servislerine gönderilir. Fotoğraflar arka plan silme için kendi sunucumuzda da işlenir. Veriler yalnızca isteğini yanıtlamak için kullanılır; tarafımızca kalıcı olarak saklanmaz. Devam etmek için açık rıza vermen gerekiyor.';

  @override
  String get aiOnayBaslik => 'AI veri paylaşımı';

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
  String get kullanimKosullarini => 'Kullanım koşullarını';

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
      'FITCHECK KULLANIM KOŞULLARI VE HİZMET SÖZLEŞMESİ\n\nSon Güncelleme Tarihi: 27 Ağustos 2026\n\nLütfen FitCheck mobil uygulamasını (“Uygulama”) kullanmadan önce bu Kullanım Koşulları’nı (“Sözleşme”) dikkatlice okuyunuz. Uygulamayı indirerek, erişerek veya kullanarak bu Sözleşme’de yer alan tüm şartları kabul etmiş sayılırsınız.\n\n1. TARAFLAR VE AMAÇ\nBu Sözleşme, FitCheck uygulamasının geliştiricisi ile Uygulama’yı indiren ve kullanan bireysel kullanıcı (\"Kullanıcı\") arasında akdedilmiştir. Uygulama; dijital gardırop oluşturma, kıyafet takibi, hava durumuna uygun kombin önerileri ve AI destekli stil danışmanlığı sunar.\n\n2. HİZMETİN KAPSAMI VE KULLANIM ŞARTLARI\n• Yaş Sınırı: Uygulamayı kullanmak için en az 13 yaşında olmanız gerekmektedir.\n• Kullanıcı Bilgileri: Kullanıcı, profil aşamasında sunduğu ad, cinsiyet, tarz ve renk tercihlerinin doğruluğundan sorumludur.\n• Tavsiye Niteliği: Yapay zeka tarafından sunulan stil puanları, satın alma önerileri ve çamaşır günü hatırlatmaları tamamen tavsiye niteliğindedir.\n• Hava Durumu Verileri: Hava durum bilgileri anlık konum bilgisine dayalı olarak sunulmaktadır. Olası sapmalardan Şirket sorumlu tutulamaz.\n\n3. FİKRİ MÜLKİYET VE İÇERİK HAKLARI\nYüklediğiniz kıyafet görsellerinin fikri mülkiyeti size aittir. FitCheck logosu, tasarımı, yazılım kodları ve algoritmaları tamamen FitCheck\'e aittir.\n\n4. GİZLİLİK VE VERİ GÜVENLİĞİ\nKıyafet görselleriniz ve kombin geçmişiniz cihazınızın yerel hafızasında saklanır. AI özelliklerini kullandığınızda, Gizlilik Politikası\'nda açıklanan veriler Gemini ve Groq\'a gönderilir. Konum verileri yalnızca anlık hava durumunu almak için kullanılır. Konum verileri yalnızca anlık hava durumunu almak için kullanılır.\n\n5. SORUMLULUĞUN SINIRLANDIRILMASI\nFitCheck, hizmetin kesintisiz devam edeceğini garanti etmez. Cihaz değişikliği veya uygulama silinmesi sebebiyle veri kayıplarından sorumlu tutulamaz.\n\n6. İLETİŞİM\nSorularınız için bizimle Ayarlar sekmesindeki iletişim alanından veya destek@fitcheckapp.com adresinden iletişime geçebilirsiniz.\n\n--- SÖZLEŞMENİN SONU ---\nLütfen aşağıdaki butona basarak şartları onaylayınız.';

  @override
  String chatKarsilama(Object hava) {
    return 'Selam Bugün dışarısı $hava. Senin tarzına uygun harika bir kombin hazırlayalım mı?';
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
  String get chatOneriYagmur => 'Yağmurlu Hava Kombini';

  @override
  String get chatOneriOfis => 'Ofis / Şık Tarz';

  @override
  String get chatOneriHaftaSonu => 'Hafta Sonu Rahatlığı';

  @override
  String get chatOneriKirliSepeti => 'Kirli Sepeti Kontrolü';

  @override
  String get chatDinleniyor => 'Dinleniyor...';

  @override
  String get chatBirSeylerYazin => 'Asistana bir şeyler yazın...';

  @override
  String get chatKombiniGiydim => 'Bu Kombini Giydim';

  @override
  String get chatKombinIslendi => 'Kombin bugün giyilenlere işlendi';

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
      'Yıkama sepetiniz boş, tüm kıyafetleriniz temiz';

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
  String get gunlukHakBittiBaslik => 'Günlük Hakkın Bitti';

  @override
  String get dahaSonra => 'Daha Sonra';

  @override
  String reklamIzleHakKazan(int adet) {
    return 'Reklam İzle (+$adet Hak)';
  }

  @override
  String tebriklerHakEklendi(int adet) {
    return 'Tebrikler +$adet hak eklendi.';
  }

  @override
  String kombinIsaretlemeKaldirildi(String kombinAdi) {
    return '\"$kombinAdi\" kombini işaretlemesi kaldırıldı.';
  }

  @override
  String kombinGiydimIsaretlendi(String kombinAdi) {
    return '\"$kombinAdi\" kombini bugün giyildi olarak işaretlendi';
  }

  @override
  String get kiyafetDetayi => 'Kıyafet Detayı';

  @override
  String get parcaDetayiBaslik => 'PARÇA DETAYI';

  @override
  String get farkliParcaSec => 'Farklı Parça Seç';

  @override
  String get farkliUstSec => 'Farklı Üst Giyim Seç';

  @override
  String get farkliAltSec => 'Farklı Alt Giyim Seç';

  @override
  String get farkliAyakkabiSec => 'Farklı Ayakkabı Seç';

  @override
  String get farkliDisSec => 'Farklı Dış Giyim Seç';

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
      'Kombindeki diğer parçalar için sağa/sola kaydırın';

  @override
  String zorunluParcaYorumu(Object parcaAdi) {
    return '$parcaAdi parçasını merkeze alarak bu kombini hazırladım';
  }

  @override
  String get sihirliDokunus => 'Sihirli Dokunuş';

  @override
  String get dolabiKaristirEksikUyari =>
      'Dolabı karıştırabilmek için en az 1 temiz Üst, Alt ve Ayakkabı bulunmalı';

  @override
  String get zarlarAtildiYorumu =>
      'Zarlar atıldı Yepyeni ve şaşırtıcı bir kombin keşfettin.';

  @override
  String get rastgeleKombinTuru => 'Rastgele';

  @override
  String get temizAlternatifYok =>
      'Bu kategori için temiz başka alternatif yok';

  @override
  String get kisiselDokunus => 'Kişisel Dokunus';

  @override
  String get aiYeniParcaAnalizEdiyor =>
      'Yapay zeka yeni parçayı analiz ediyor...';

  @override
  String get parcaDegisimVarsayilanYorum =>
      'Parçaları değiştirerek harika bir uyum yakaladın';

  @override
  String get parcaDegisimHataYorum =>
      'Parçaları değiştirerek kombini tamamen kendi tarzına uyarladın';

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
  String get zarPopupBaslik => 'Sihirli Zarları Salla';

  @override
  String get zarPopupAciklama =>
      'Telefonunu fiziksel olarak sallayarak veya aşağıdaki butona basarak zarları atabilir, dolabından rastgele kombinler oluşturabilirsin.';

  @override
  String get zarlariAt => 'Zarları At';

  @override
  String get zarSalla => 'Zar Salla';

  @override
  String get degistirmekIcinKaydirIpucu =>
      'Değiştirmek için parçaları sağa/sola kaydırın veya dokunun';

  @override
  String get favorilerdeEtiketi => 'Favorilerde';

  @override
  String get bugunGiydildiEtiketi => 'Bugün Giyildi';

  @override
  String get varsayilanKendiAnalizYorumu =>
      'Harika bir seçim Parçalar renk tonlarıyla mükemmel bir denge oluşturmuş.';

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
      'Kombin harika görünüyor Yapay zeka ile analiz edip kaydet.';

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
  String get gecmisBasariylaTemizlendi => 'Geçmiş başarıyla temizlendi';

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
      'Sepet tamamen boş, tüm kıyafetler temiz';

  @override
  String get tumKiyafetlerTemizlendi =>
      'Tüm kıyafetler temizlendi ve dolaba eklendi';

  @override
  String get tumunuTemizIsaretle => 'Tümünü Temiz İşaretle';

  @override
  String get profilVeAnalizTitle => 'Profil ve Analiz';

  @override
  String get harikaGidiyorsun => 'Harika Gidiyorsun';

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
  String get googleHesabiBaglandi => 'Google hesabınız başarıyla bağlandı';

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
    return '$eposta adresine şifre yenileme e-postası gönderildi';
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
      'Görsel önbelleği ve geçici dosyalar temizlendi';

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
      'Dışa aktarılacak gardırop verisi bulunamadı.';

  @override
  String get gardiropVerisiKopyalandi =>
      'Tüm gardırop verileriniz JSON formatında panoya kopyalandı';

  @override
  String get destekVeDegerlendirmeUst => 'DESTEK VE DEĞERLENDİRME';

  @override
  String get uygulamayiDegerlendirin => 'Uygulamayı Değerlendirin';

  @override
  String get googlePlay5YildizDestek =>
      'Google Play\'de 5 yıldız vererek destek olun ⭐';

  @override
  String get appStoreDegerlendirAciklama =>
      'App Store\'da değerlendirerek destek olun ⭐';

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
  String get gizlilikPolitikasiTamamiAc => 'Politikanın tamamını aç';

  @override
  String get veriKullanimiVeGizlilikHaklari =>
      'Veri kullanımı ve gizlilik haklarınızı görün';

  @override
  String get sonGuncellemeTarihi => 'Son Güncelleme: 20 Ekim 2026';

  @override
  String get gizlilikMadde1Baslik => '1. Veri Toplama ve Kullanımı';

  @override
  String get gizlilikMadde1Icerik =>
      'FitCheck uygulaması, kişisel gardırop yönetiminizi ve kombin önerilerinizi optimize etmek için çalışır. Uygulamaya eklediğiniz kıyafet fotoğrafları, tarz ve cinsiyet tercihleriniz cihazınızda yerel olarak saklanır. AI özelliklerinde, 5. bölümde açıklanan veriler Gemini ve Groq\'a gönderilir.';

  @override
  String get gizlilikMadde2Baslik => '2. Konum İzinleri';

  @override
  String get gizlilikMadde2Icerik =>
      'Konum izni verdiğinizde enlem ve boylamınız hava durumu için Open-Meteo\'ya, şehir adını belirlemek için BigDataCloud\'a gönderilir. FitCheck bu koordinatları kendi sunucularında saklamaz. Bu servislerin veri işleme koşulları kendi gizlilik politikalarına tabidir.';

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
  String get kuponKoduAciklama => 'Kupon kodunuzu aşağıya girin:';

  @override
  String get kuponKoduHint => 'Kupon kodu';

  @override
  String get kuponKullanButon => 'Kullan';

  @override
  String get kuponBasariliMesaji => 'Kupon etkinleştirildi.';

  @override
  String get kuponKullanilmisUyari => 'Bu kupon kodunu daha önce kullandınız';

  @override
  String get kuponGecersizUyari => 'Geçersiz kupon kodu Lütfen tekrar deneyin.';

  @override
  String get sinirsizIslemHakkiBaslik => 'Sınırsız Hak';

  @override
  String kalanHakkinizBaslik(Object hak) {
    return 'Kalan Hakkınız: $hak';
  }

  @override
  String get sinirsizHakAciklama =>
      'Premium ayrıcalığıyla tüm kombin ve stil analizlerini sınırsız kullanabilirsiniz.';

  @override
  String get gunlukHakAciklama =>
      'Günlük haklarınız her gün 00:00\'da yenilenir. Daha fazla hak için reklam izleyebilirsiniz.';

  @override
  String get kuponKullan => 'Kupon Kullan';

  @override
  String hakEklendiTebrikler(int adet) {
    return 'Tebrikler +$adet hak eklendi.';
  }

  @override
  String get gardirobunDolduTitle => 'Gardırobun Doldu';

  @override
  String gardirobunDolduIcerik(int limit, int adet) {
    return 'Mevcut limitin olan $limit kıyafete ulaştın. Kısa bir video izleyerek gardırobuna +$adet kıyafet yükleme alanı eklemek ister misin?';
  }

  @override
  String reklamIzleSlotEkle(int adet) {
    return 'Reklam İzle (+$adet Kıyafet Alanı)';
  }

  @override
  String yeniSlotEklendiTebrikler(int adet) {
    return 'Tebrikler Gardırobuna +$adet yeni kıyafet alanı eklendi.';
  }

  @override
  String get gunlukHakBittiTitle => 'Günlük Hakkın Bitti';

  @override
  String get gunlukHakBittiIcerik =>
      'Bugünlük ücretsiz işlem hakkını tamamladın. Kısa bir video izleyerek yeni haklar kazanabilirsin';

  @override
  String get kuponGir => 'Kupon Gir';

  @override
  String get anaSemsiyeBildirimBaslik => 'Şemsiyeni Unutma';

  @override
  String get anaSemsiyeBildirimIcerik =>
      'Bugün hava yağmurlu görünüyor, kombinini buna göre seçmeyi unutma.';

  @override
  String get anaCamasirGunuBildirimBaslik => 'Çamaşır Günü';

  @override
  String get anaCamasirGunuBildirimIcerik =>
      'Sepetinde yıkanmayı bekleyen kıyafetler birikti. Makineyi çalıştırma vakti';

  @override
  String chatZorunluParcaMesaji(Object parca) {
    return 'Bu parçayla ne giyebilirim? ($parca)';
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
  String get rehberAnladimBasla => 'Anladım, Başla';

  @override
  String get rehberSonrakiAdim => 'Sonraki Adım';

  @override
  String get rehberGardirobuDijitallestirBaslik => 'Gardırobunu Dijitalleştir';

  @override
  String get rehberGardirobuDijitallestirAciklama =>
      'Bu butona basarak kıyafetlerinin fotoğrafını çekebilir veya galerinden ekleyerek kendi dijital gardırobunu oluşturabilirsin.';

  @override
  String get rehberSesliAsistanBaslik => 'Sesli Stil Asistanı';

  @override
  String get rehberSesliAsistanAciklama =>
      'Sesli komut vererek ne giyeceğini sorabilir veya hızlıca kombin tavsiyesi alabilirsin.';

  @override
  String get rehberAiStilistBaslik => 'AI Stilist Önerileri';

  @override
  String get rehberAiStilistAciklama =>
      'Günün havasına, ten rengine ve tarzına en uygun kombin önerilerini tek tıkla yapay zekadan alabilirsin.';

  @override
  String get rehberAyarlarBaslik => 'Kişiselleştirme & Ayarlar';

  @override
  String get rehberAyarlarAciklama =>
      'Cinsiyet, ten rengi, renk ve tema tercihlerini ayarlayabilir veya kullanım rehberine tekrar ulaşabilirsin.';

  @override
  String get rehberNavGardirobumBaslik => 'Gardırobum';

  @override
  String get rehberNavGardirobumAciklama =>
      'Tüm kıyafetlerini kategorilerine göre görüntüle, filtrele ve pratik bir şekilde yönet.';

  @override
  String get rehberNavHaftalikBaslik => 'Haftalık Planlayıcı';

  @override
  String get rehberNavHaftalikAciklama =>
      'Önümüzdeki günlerin hava durumuna göre kombinlerini gün gün önceden planla.';

  @override
  String get rehberNavDolaptanBaslik => 'AI Dolaptan Kombin';

  @override
  String get rehberNavDolaptanAciklama =>
      'Mevcut kıyafetlerin arasından günün şartlarına en uygun otomatik kombinleri yapay zekaya ürettir.';

  @override
  String get rehberNavKendiBaslik => 'Kendi Kombinini Yap';

  @override
  String get rehberNavKendiAciklama =>
      'Üst, alt ve ayakkabı parçalarını manuel eşleştirerek kendi stilini oluştur ve kaydet.';

  @override
  String get rehberNavProfilBaslik => 'Analiz & Çamaşır Sepeti';

  @override
  String get rehberNavProfilAciklama =>
      'Kıyafet giyilme istatistiklerini incele ve kirlenen parçalarını çamaşır sepetinden takip et.';

  @override
  String get bildirimIzinGerekliBaslik => 'Bildirim İzni Gerekli';

  @override
  String get bildirimIzinGerekliIcerik =>
      'Çamaşır günü hatırlatıcıları, yağmurlu hava uyarıları ve günlük stil önerilerini alabilmek için bildirim izinlerini açmanız önerilir.';

  @override
  String get bildirimGunaydinBaslik => 'Günaydın';

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
  String get gardirobumBosBaslik => 'Dolabın Çok Boş';

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
  String get gardirobumHakEklendiMesaj => 'Tebrikler, yeni hak kazandın';

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
  String get gardirobumHenuzYokEkle => 'Henüz kıyafet eklenmedi. Hemen ekleyin';

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
    return '$kombin kombinini birlikte inceleyelim Renk uyumu, hava durumu ya da alternatif parçalar hakkında ne istersen sorabilirsin.';
  }

  @override
  String get kombinSohbetOneriUyum => 'Bu kombin neden uyumlu?';

  @override
  String get kombinSohbetOneriAlternatif => 'Alternatif parça öner';

  @override
  String get kombinSohbetOneriHava => 'Hava değişirse ne giyerim?';

  @override
  String get kombinSohbetOneriAksesuar => 'Aksesuar önerisi ver';

  @override
  String get kombinSohbetAltBaslikAnlik => 'Anlık kombin üzerine sohbet';

  @override
  String get chatKirliSepetiBos =>
      'Kirli sepetin boş Tüm parçaların kullanıma hazır, istediğin zaman kombin hazırlayabilirim.';

  @override
  String chatKirliSepetiDoluBaslik(Object sayi) {
    return 'Kirli sepetinde **$sayi** parça yıkanmayı bekliyor:';
  }

  @override
  String get chatKirliSepetiDoluNot =>
      'Bu parçalar yıkanana kadar kombin önerilerine dahil edilmez. İstersen temiz parçalarınla hemen bir kombin hazırlayabilirim.';

  @override
  String get analitikVerileriPaylas => 'Analitik verileri paylaş';

  @override
  String get analitikVerileriPaylasAciklama =>
      'Analiz verileri, uygulama kullanımını anlamak ve deneyimi iyileştirmek için Firebase Analytics\'e gönderilir. Bu isteğe bağlıdır; istediğiniz zaman kapatabilirsiniz.';

  @override
  String get chatKarsilamaHavaYok =>
      'Selam Senin tarzına uygun harika bir kombin hazırlayalım mı?';

  @override
  String get premiumBaslik => 'Sınırsız stil, sıfır reklam';

  @override
  String get premiumAciklama =>
      'Kombinlerini ve stil analizlerini sınırsız kullan, tüm reklamları kaldır. Tek bir avantajlı abonelikle.';

  @override
  String get premiumOzellikReklamsiz => 'Tüm reklamlar kaldırılır';

  @override
  String get premiumOzellikAylik => 'Aylık otomatik yenilenir';

  @override
  String get premiumOzellikMagaza => 'Google Play üzerinden yönetilir';

  @override
  String get premiumAktifMesaji =>
      'Premium aktif. Sınırsız kullanım ve reklamsız deneyim açık.';

  @override
  String get premiumAboneOl => 'Abone ol';

  @override
  String premiumAboneOlFiyatli(String fiyat) {
    return 'Abone ol • $fiyat';
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
  String get premiumAylikBaslik => 'FitCheck Premium';

  @override
  String premiumAylikAltBaslik(String fiyat) {
    return 'Sınırsız kombin • ayda $fiyat';
  }

  @override
  String premiumGec(String fiyat) {
    return 'Sınırsız kullan • $fiyat/ay';
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
  String get kombinSonucUsta => 'Stil Ustası';

  @override
  String get kombinSonucUstaMesaj => 'Renk ve uyum hissini ödüllemeye değer';

  @override
  String get kombinSonucIyi => 'İyi Gidiyorsun';

  @override
  String get kombinSonucIyiMesaj => 'Az pratikle mükemmel olacaksın.';

  @override
  String get kombinSonucPratik => 'Pratik Lazım';

  @override
  String get kombinSonucPratikMesaj =>
      'Renk teorisi ipuçları için \"Analiz\" sekmesine bak.';

  @override
  String get degerlendirmeBaslik => 'FitCheck\'i beğendiniz mi?';

  @override
  String get degerlendirmeIcerik =>
      'Uygulamayı seviyorsanız 5 saniyenizi ayırıp bize yorum bırakabilir misiniz? Küçük yorumlar büyük destek';

  @override
  String get degerlendirmeEvet => 'Evet, değerlendireyim';

  @override
  String get degerlendirmeBelkiSonra => 'Belki sonra';

  @override
  String get yakinda => 'Yakında';

  @override
  String get yakindaAciklama =>
      'Bu özellik üzerinde çalışıyoruz, çok yakında sizlerle';

  @override
  String get aiOneriHazirlaniyor => 'Öneri hazırlanıyor...';

  @override
  String get haftalikStilistOnerisiHazirlanamadi =>
      'Stilist önerisi hazırlanamadı. Tekrar dene.';

  @override
  String get haftalikAiServisHatasi =>
      'Yapay zekâ servisine ulaşılamadı. İnternet bağlantını kontrol edip tekrar dene.';

  @override
  String get haftalikAiGecerliPlanYok =>
      'Yapay zekâ geçerli bir plan döndürmedi. Tekrar dene.';

  @override
  String get haftalikPlanBeklenmeyenHata =>
      'Plan oluşturulurken beklenmeyen bir hata oluştu. Tekrar dene.';

  @override
  String get haftalikBugunGiyildi =>
      'Bugünün kombini zaten giyildi; yeni kombin oluşturulmadı.';

  @override
  String get girisHataKullaniciAdiKisa => 'En az 3 karakter giriniz';

  @override
  String get girisHataEpostaGecersiz => 'Geçerli bir e-posta giriniz';

  @override
  String get girisHataSifreKisa => 'En az 6 karakter giriniz';

  @override
  String get googleKullanicisi => 'Google Kullanıcısı';

  @override
  String get premiumEkranBaslik => 'FitCheck Premium';

  @override
  String get dilSecimBaslik => 'Dil Seçimi';

  @override
  String get dilSecenekOtomatik => 'Otomatik (Cihaz Dili)';

  @override
  String get kapat => 'Kapat';

  @override
  String get bildirimBaslik => 'Bildirim';

  @override
  String get ayarlarAltbilgi => 'Stil ile yapıldı';

  @override
  String get geriBildirimKonu => 'FitCheck Geri Bildirim';

  @override
  String get premiumOzelliklerBaslik => 'Premium ile neler kazanırsın?';

  @override
  String get premiumOzellikSinirsizKombin => 'Sınırsız kombin oluşturma';

  @override
  String get premiumOzellikSinirsizAnaliz => 'Sınırsız yapay zekâ stil analizi';

  @override
  String get premiumOzellikSinirsizGardirob => 'Sınırsız gardırop alanı';

  @override
  String get premiumPlanAylik => 'Aylık';

  @override
  String get premiumPlanYillik => 'Yıllık';

  @override
  String get premiumEnAvantajli => 'EN AVANTAJLI';

  @override
  String premiumTasarrufYuzde(int yuzde) {
    return '%$yuzde tasarruf';
  }

  @override
  String premiumDenemeRozeti(int gun) {
    return '$gun GÜN ÜCRETSİZ';
  }

  @override
  String premiumDenemeSonrasi(String fiyat) {
    return 'Deneme bitince $fiyat';
  }

  @override
  String get premiumYenilemeNotu =>
      'Abonelik, dönem sonunda otomatik yenilenir. İstediğin zaman iptal edebilirsin.';

  @override
  String get kiyafetDondur => 'Döndür';

  @override
  String get stilistHafizasiBaslik => 'Stilist Hafızası';

  @override
  String stilistHafizasiAltBaslikNotlu(int sayi) {
    return '$sayi not hatırlıyor';
  }

  @override
  String get stilistHafizasiAltBaslikBos => 'Henüz bir şey hatırlamıyor';

  @override
  String get stilistHafizasiAciklama =>
      'Stilist, sohbetlerden öğrendiklerini kalıcı not olarak saklar ve önerilerini ona göre kişiselleştirir. Notlar yalnızca bu cihazda tutulur.';

  @override
  String get stilistHafizasiNelerBiliyor => 'Neler hatırlıyor?';

  @override
  String get stilistHafizasiOzetBaslik => 'Son konuşmaların özeti';

  @override
  String get stilistHafizasiBos =>
      'Henüz bir şey öğrenmedim. Sohbet ettikçe tarzını tanırım.';

  @override
  String get stilistHafizasiTemizle => 'Hafızayı temizle';

  @override
  String get stilistHafizasiTemizleOnay =>
      'Stilistin seninle ilgili hatırladığı her şey silinecek. Bu işlem geri alınamaz.';

  @override
  String get stilistHafizasiTemizlendi => 'Hafıza temizlendi';

  @override
  String get gardirobumArkaPlanSilinemediBaslik => 'Arka plan silinemedi';

  @override
  String get gardirobumArkaPlanSilinemediAciklama =>
      'Bağlantı sorunu olabilir. Tekrar denemek, fotoğrafı arka planıyla kaydetmek ya da bu fotoğrafı atlamak istediğini seç.';

  @override
  String get gardirobumArkaPlanliKaydet => 'Arka planıyla kaydet';

  @override
  String get cekimIpucuBaslik => 'Daha iyi kesim için';

  @override
  String get cekimIpucu1 => 'Kıyafeti düz, tek renkli bir zemine koy.';

  @override
  String get cekimIpucu2 => 'Zemin kıyafetten farklı bir renk olsun.';

  @override
  String get cekimIpucu3 => 'Gölge ve desenli zeminden kaçın.';

  @override
  String kullanimKosullariOnayMetni(String terms) {
    return '$terms okudum ve onaylıyorum.';
  }

  @override
  String get kendiTasarimimParcaSec => 'Parça seç';

  @override
  String get hesapSilmeBasarisiz =>
      'Hesap silme tamamlanamadı. İnternet bağlantınızı kontrol edip tekrar deneyin.';

  @override
  String get bildirimTamZamanAyar => 'Tam Zamanlı Bildirim';

  @override
  String get bildirimTamZamanAciklama =>
      'Bildirimlerin tam seçtiğin saatte gelmesi için Android\'de \'Alarms & reminders\' iznini ver.';

  @override
  String get bildirimTamZamanAcik => 'Tam zamanlı bildirimler açık.';

  @override
  String get premiumSatinAlmaDogrulamaHazirDegil =>
      'Bu platform için güvenli mağaza doğrulaması henüz hazır değil. Satın alma geçici olarak kullanılamıyor.';

  @override
  String get islemIptalEdildi =>
      'İşlem iptal edildi. Şimdiye kadar eklenen kıyafetler gardırobunda duruyor.';

  @override
  String get islemIptalEdiliyor => 'İptal ediliyor…';

  @override
  String get sifreGoster => 'Şifreyi göster';

  @override
  String get sifreGizle => 'Şifreyi gizle';

  @override
  String get gunSayisiAzalt => 'Gün sayısını azalt';

  @override
  String get gunSayisiArttir => 'Gün sayısını artır';

  @override
  String get chatGorseliKaldir => 'Görseli kaldır';

  @override
  String get kesimUyarisiBaslik => 'Kesim hatalı olabilir';

  @override
  String get kesimUyarisiAciklama =>
      'Kıyafet zemine çok yakın renkte. Arka plan silme bu durumda zorlanır: zeminden parça kalabilir ya da kıyafetin bir bölümü kesilebilir. Farklı renkte bir zeminde tekrar çekmek genellikle çözer.';

  @override
  String get kesimUyarisiTekrarCek => 'Tekrar çek';

  @override
  String get kesimUyarisiYineDeKaydet => 'Yine de kaydet';

  @override
  String get gizlilikMadde5Baslik => '5. Yapay Zekâ ile Görsel Analizi';

  @override
  String get gizlilikMadde5Icerik =>
      'Kıyafet fotoğrafları, arka planı silinmek üzere kendi sunucumuzda işlenir; stil analizi ve kombin önerileri için Google (Gemini) ve Groq yapay zekâ servislerine gönderilir. Fotoğraflar yalnızca isteğinizi yanıtlamak için işlenir, tarafımızca kalıcı olarak saklanmaz ve reklam amacıyla kullanılmaz. Orijinal fotoğraf da yalnızca istenen analiz için bu AI servislerine gönderilir ve tarafımızca kalıcı olarak saklanmaz.';

  @override
  String get bugunSekmesi => 'Bugün';

  @override
  String get bugunBaslik => 'Bugün';

  @override
  String get bugunGunaydin => 'Günaydın';

  @override
  String get bugunIyiGunler => 'İyi günler';

  @override
  String get bugunIyiAksamlar => 'İyi akşamlar';

  @override
  String get bugunBugununKombini => 'Bugünün kombini';

  @override
  String get bugunNedenBuKombin => 'Neden bu kombin?';

  @override
  String get bugunRenkUyumu => 'Renk uyumu';

  @override
  String get kombinHedefiBaslik => 'Kombin hedefin';

  @override
  String get kombinHedefiAciklama =>
      'Yeni kombin ve haftalık plan önerilerinde neyi öne çıkaralım?';

  @override
  String get kombinHedefiDenge => 'Dengeli öneriler';

  @override
  String get kombinHedefiRenk => 'Renkleri keşfet';

  @override
  String get kombinHedefiUnutulan => 'Az giydiklerimi kullan';

  @override
  String get kombinHedefiCokYonlu => 'Çok yönlü parçalar';

  @override
  String get bugunHizliFotograf => 'Fotoğrafla ekle';

  @override
  String get bugunHizliKombin => 'Kombin üret';

  @override
  String get bugunHizliStilist => 'Stiliste sor';

  @override
  String get bugunHizliPlan => 'Haftayı planla';

  @override
  String get bugunHazirlaniyor => 'Kombinler hazırlanıyor…';

  @override
  String get bugunBosBaslik => 'Dolabın henüz boş';

  @override
  String get bugunBosAciklama =>
      'İlk parçanı ekle; her sabah burada yeni kombin önerileri olacak.';

  @override
  String get bugunYenile => 'Yenile';

  @override
  String get bugunGiydim => 'Giydim';

  @override
  String get bugunKaydet => 'Kaydet';

  @override
  String get bugunSeninIcin => 'Senin için';

  @override
  String get bugunGiyilmediRafi => '2 haftadır giymediklerin';

  @override
  String get bugunYeniRafi => 'Yeni eklenenler';

  @override
  String get bugunHavaRafi => 'Bugüne uygun';

  @override
  String get bugunRafIpucu => 'Dokun: giydim, kombin kur veya dolapta aç';

  @override
  String get duelloSekmesi => 'Düello';

  @override
  String get duelloBaslik => 'Kombin Düellosu';

  @override
  String get duelloAltBaslik =>
      'İki kombinden birini seç, stil gözünü test et.';

  @override
  String get duelloBaslat => 'Düelloya başla';

  @override
  String get duelloNasilOynanir => 'Nasıl oynanır?';

  @override
  String get duelloKural1 => 'Her turda iki kombin görürsün.';

  @override
  String get duelloKural2 => 'Soruya göre doğru olanı seç.';

  @override
  String get duelloKural3 => 'Doğru seçim seri ve puan kazandırır.';

  @override
  String get duelloEnIyi => 'En iyi';

  @override
  String get duelloSeri => 'Seri';

  @override
  String duelloGunSerisi(int gun) {
    return '$gun gün';
  }

  @override
  String get duelloSeviye => 'Seviye';

  @override
  String duelloSeviyeDegeri(int seviye) {
    return 'Seviye $seviye';
  }

  @override
  String duelloXp(int xp) {
    return '$xp XP';
  }

  @override
  String duelloTur(int tur, int toplam) {
    return 'Tur $tur/$toplam';
  }

  @override
  String get duelloOlcuRenk => 'Hangisinin renkleri daha uyumlu?';

  @override
  String get duelloOlcuHava => 'Hangisi bugünkü havaya daha uygun?';

  @override
  String get duelloDokun => 'Bir kombine dokun';

  @override
  String get duelloDogru => 'Doğru';

  @override
  String get duelloYanlis => 'Olmadı';

  @override
  String get duelloDevam => 'Devam';

  @override
  String get duelloSonuc => 'Sonucu gör';

  @override
  String get duelloBitti => 'Düello bitti';

  @override
  String duelloSkor(int dogru, int toplam) {
    return '$dogru/$toplam doğru';
  }

  @override
  String get duelloYeniden => 'Tekrar oyna';

  @override
  String get duelloBugune => 'Bugün\'e dön';

  @override
  String duelloEnIyiSeri(int seri) {
    return 'En iyi seri: $seri';
  }

  @override
  String get duelloPaletNotu =>
      'Bu turda renk kartları var. Dolabına parça ekledikçe düellolar kendi kıyafetlerinle oynanır.';

  @override
  String get duelloDolapEkle => 'Dolaba parça ekle';

  @override
  String get duelloBugunOynadi => 'Bugün oynadın. Yarın seriyi sürdür.';

  @override
  String get duelloSebepNotr => 'Nötr ve toprak tonlar birbirini dengeliyor.';

  @override
  String get duelloSebepMonokrom =>
      'Tek renk ailesinde kalarak bütünlük sağlıyor.';

  @override
  String get duelloSebepAnalog => 'Yakın tonlar yumuşak bir geçiş oluşturuyor.';

  @override
  String get duelloSebepVurgu => 'Nötr bir zeminde tek vurgu rengi var.';

  @override
  String get duelloSebepZit => 'Karşıt renkler dengeli kullanılmış.';

  @override
  String get duelloSebepDagink => 'İki uzak renk arasında köprü yok.';

  @override
  String get duelloSebepCokRenk => 'Üç ayrı canlı renk birbiriyle yarışıyor.';

  @override
  String get duelloSebepHavaUygun => 'Parçalar bugünkü sıcaklığa uygun.';

  @override
  String get duelloSebepHavaAgir => 'Kalın parçalar bu hava için fazla.';

  @override
  String get duelloSebepHavaHafif => 'İnce parçalar bu hava için yetersiz.';

  @override
  String bildirimSabahKombin(String kombin) {
    return 'Bugünkü kombinin hazır: $kombin. Görmek için dokun.';
  }

  @override
  String get bildirimPlanBaslik => 'Yarınki kombinin hazır';

  @override
  String bildirimPlanKombin(String kombin) {
    return 'Yarın için: $kombin. Şimdi bak, sabah acele etme.';
  }

  @override
  String get bildirimPlanBos =>
      'Yarın için henüz kombin yok. 2 dakikada planla.';

  @override
  String get planHatirlatimiAyar => 'Akşam plan hatırlatıcısı';

  @override
  String get planHatirlatimiAyarAciklama =>
      'Yarınki kombinini akşam 21:00\'de hatırlatır';

  @override
  String get bugunPaylas => 'Kombini paylaş';

  @override
  String get bugunPaylasMetni => 'Bugünkü kombini FitCheck\'te hazırladım';

  @override
  String get bugunPaylasHata => 'Paylaşım açılamadı. Tekrar dene.';

  @override
  String get bugunParcaGiydim => 'Bugün giydim';

  @override
  String get bugunParcaKombin => 'Bununla kombin kur';

  @override
  String get bugunParcaDolapta => 'Dolapta aç';

  @override
  String bugunParcaGiydimIsaretlendi(String parca) {
    return '«$parca» bugün giydim olarak işaretlendi.';
  }

  @override
  String get stilGunluguBaslik => 'Stil Günlüğüm';

  @override
  String get stilGunluguTakvim => 'Takvim';

  @override
  String get stilGunluguGunluk => 'Günlük';

  @override
  String get stilGunluguRapor => 'Rapor';

  @override
  String get stilGunluguGiyildi => 'Giyildi';

  @override
  String get stilGunluguPlanli => 'Planlandı';

  @override
  String get stilGunluguGunBos => 'Bu gün için kayıt yok';

  @override
  String stilGunluguRaporOzet(String kombin) {
    return 'Bu hafta $kombin kombin giyindin';
  }

  @override
  String stilGunluguRaporGecenHafta(String fark) {
    return 'Geçen haftaya göre $fark';
  }

  @override
  String get stilGunluguRaporKullanim => 'Dolap kullanımı';

  @override
  String get stilGunluguRaporEnCok => 'En çok giyilen';

  @override
  String get stilGunluguRaporSeri => 'Günlük seri';

  @override
  String get stilGunluguRaporHicGiyilmemis => 'Hiç giyilmemiş';

  @override
  String get stilGunluguRaporPaylas => 'Raporu paylaş';

  @override
  String stilGunluguRaporPaylasMetni(String ozet) {
    return 'Haftalık stil raporum: $ozet';
  }

  @override
  String get stilGunluguRaporBos =>
      'Bu hafta henüz kombin kaydın yok. Giyildiğinde burada görünecek.';

  @override
  String get seyahatBaslik => 'Seyahat Modu';

  @override
  String get seyahatGunSayisi => 'Gün sayısı';

  @override
  String get seyahatHava => 'Hava';

  @override
  String get seyahatHavaSicak => 'Sıcak';

  @override
  String get seyahatHavaIliman => 'Ilıman';

  @override
  String get seyahatHavaSoguk => 'Soğuk';

  @override
  String get seyahatAmac => 'Amaç';

  @override
  String get seyahatAmacGunluk => 'Günlük';

  @override
  String get seyahatAmacIs => 'İş';

  @override
  String get seyahatAmacOzel => 'Özel';

  @override
  String get seyahatPlanBaslik => 'Valiz Planı';

  @override
  String seyahatKombine(String adet) {
    return '$adet kombin çıkar';
  }

  @override
  String get seyahatDiger => 'Dış giyim';

  @override
  String get seyahatEksikUst => 'Temiz üst giyim yok';

  @override
  String get seyahatEksikAlt => 'Temiz alt giyim yok';

  @override
  String get seyahatEksikAyakkabi => 'Ayakkabı yok';

  @override
  String seyahatEksikKombin(String gun) {
    return '$gun gün için kombin yetmiyor';
  }

  @override
  String get seyahatPaylas => 'Listeyi paylaş';

  @override
  String get seyahatPaylasMetni => 'FitCheck valiz planım';

  @override
  String get geriAl => 'Geri al';

  @override
  String get stilGunluguRaporSayiEtiketi => 'Bu hafta giyilen kombin';

  @override
  String get stilGunluguRaporDortHafta => 'Son 4 hafta';

  @override
  String get stilGunluguRaporEnCokParcalar => 'En çok giydiklerin';

  @override
  String get navKombin => 'Kombin';

  @override
  String get navProfil => 'Profil';

  @override
  String get dolapAra => 'Dolabında ara';

  @override
  String get dolapEslesmeYok => 'Aramanla eşleşen parça yok.';

  @override
  String get dolapAramayiTemizle => 'Aramayı temizle';

  @override
  String get planGuneKombinSec => 'Bu güne kombin seç';

  @override
  String get planKombinSec => 'Kombin seç';

  @override
  String get planDegistir => 'Değiştir';

  @override
  String get planKaldir => 'Kaldır';

  @override
  String get planFavoriYok => 'Henüz favori kombinin yok.';

  @override
  String get planKombinOlustur => 'Kombin oluştur';

  @override
  String get planGuneEklendi => 'Kombin güne eklendi';

  @override
  String get planKaldirildi => 'Plan kaldırıldı';

  @override
  String get planHaftalikProgram => 'Haftalık program';

  @override
  String planParcaSayisi(int count) {
    return '$count parça';
  }

  @override
  String get planBugun => 'Bugün planın';

  @override
  String get planTakvimdenDegistir => 'Takvimden değiştir';

  @override
  String get planFavorilerim => 'Favorilerim';

  @override
  String get planSonGiyilenler => 'Son giyilenler';

  @override
  String get izinGerekceKameraBaslik => 'Kamerayla kıyafet ekle';

  @override
  String get izinGerekceKameraAciklama =>
      'Kıyafetlerini fotoğraf olarak eklemek için kamerayı kullanıyoruz. Fotoğraf cihazından çıkar; arka plan silme ve renk/stil analizi sunucu üzerinde yapılır, kalıcı olarak saklanmaz.';

  @override
  String get izinGerekceSimdiDegil => 'Şimdi değil';

  @override
  String get planOneriler => 'Öneriler';

  @override
  String get bilgiVerimlilik =>
      'Dolap verimliliği, dolabındaki parçaların ne kadarının en az bir kez giyildiğini gösterir. %60 üzeri sağlıklı bir dolap için iyidir; daha düşükse bazı parçalar henüz kullanılmamış ya da fazla almışsındır.';

  @override
  String get bilgiStil =>
      'Stil kimliğin, dolabındaki parçaların çoğunluğunun ortak özelliklerinden çıkarılır: renk, kategori ve tarz etiketi. Kombin önerileri bu profile göre sıralanır.';

  @override
  String get bilgiSeri =>
      'Seri, üst üste giydiğin gün sayısıdır. Her «bugün giydim» işaretlemen seriye ekler; bir gün atlayınca seri sıfırlanır.';

  @override
  String get bilgiSepet =>
      'Çamaşır sepeti, giydiğin ama henüz yıkamak istediğin parçalardır. Sepete attığın parçalar bir sonraki kombin önerisinde kullanılmaz.';

  @override
  String get bilgiRenkPaleti =>
      'Renk paletin, dolabında en çok bulunan dört rengin dağılımını gösterir. Birbirine yakın tonlar kombinde daha uyumlu görünür.';

  @override
  String get bilgiKategoriDagilimi =>
      'Kategori dağılımı, dolabının üst, alt, ayakkabı ve aksesuar dengesini gösterir. Tek bir kategoride fazla parça varsa kombin kurmak zorlaşır.';

  @override
  String get bilgiAnlikDurum =>
      'Anlık durum, bulunduğun şehre göre hava durumuna ve dolabına uygun kısa bir öneri verir.';

  @override
  String get bilgiSeriBaslik => 'Giyme Serisi';

  @override
  String get bilgiKahramanlar =>
      'Dolabının kahramanları, dolabında en çok giyilen parçalardır. Sık giyilen parçalar kombinlerde daha çok yer alır ve gardırobunu sürdürür.';

  @override
  String get bilgiUnutulanlar =>
      'Derinlerde unutulanlar, hiç giyilmemiş ya da çok uzun süredir giyilmemiş parçalardır. Kullanılmayan parçalar yeni kombinlerle yeniden hayat bulabilir.';

  @override
  String get bilgiBugunKombini =>
      'Bugünün kombini, dolabın ve hava durumu dikkate alınarak seçilir. Günde en fazla bir yapay zekâ isteği yapılır ve sonuç gün boyunca saklanır; yapay zekâ kullanılamazsa kural bazlı öneriler devreye girer.';

  @override
  String get bilgiRaporHafta =>
      'Son 7 günde kaydettiğin kombin sayısı. Her «bugün giydim» işaretlemen bir kombin olarak sayılır; aynı güne birden fazla kombin kaydedebilirsin.';

  @override
  String get bilgiRaporDortHafta =>
      'Son 4 haftanın haftalık kombin sayıları. Grafik, haftalık düzeni ve artıp azalışı gösterir.';

  @override
  String get bilgiRaporEnCokParcalar =>
      'Bu hafta en çok giyilen parçalar. Sık kullanılan parçalar gardırobunun omurgasıdır.';

  @override
  String get bilgiRaporKullanim =>
      'Dolabındaki parçaların ne kadarının son 7 günde kullanıldığı. Düşükse bazı parçalar henüz kombine girmemiş demektir.';

  @override
  String get bilgiRaporSeri =>
      'Üst üste giydiğin gün sayısı. Her gün bir kombin kaydedersen artar, bir gün boşluk bırakırsan sıfırlanır.';

  @override
  String get bilgiRaporHicGiyilmemis =>
      'Son 7 günde hiç giyilmemiş parça sayısı. Bu parçalar yeni kombinlerle yeniden kullanılabilir.';

  @override
  String get bilgiDueloPuan =>
      'Her soruda iki kombin arasından seçim yaparsın. Doğru cevap puan ve seri kazandırır, yanlış cevap seriyi sıfırlar. Puanlama kural tabanlıdır: renk uyumu, kategori dengesi ve mevsim tutarlılığı ölçülür. Dolabında 4\'ten az parça varsa geçmiş kombinlerden bir palet oluşturulur.';

  @override
  String get bilgiDolapCalisma =>
      'Dolabına fotoğraf eklediğinde arka plan otomatik silinir; renk, kategori, stil ve mevsim yapay zekâ tarafından okunur. Kıyafetler cihazında saklanır, arka plan silme ve analiz sunucu üzerinde yapılır.';

  @override
  String get duzenleArkaPlanBaslik => 'Arka plan ve yerleşim';

  @override
  String get duzenleIpucu =>
      'Parçayı sürükleyerek yerleştirebilir, iki parmakla büyütebilirsin.';

  @override
  String get duzenleZeminBeyaz => 'Beyaz';

  @override
  String get duzenleZeminKirik => 'Kırık beyaz';

  @override
  String get duzenleZeminGri => 'Açık gri';

  @override
  String get duzenleZeminSaydam => 'Saydam';

  @override
  String get duzenleKaydet => 'Kaydet';

  @override
  String get duzenleVarsayilan => 'Varsayılan';

  @override
  String get arkaPlandaEkle => 'Arka planda ekle';

  @override
  String get arkaPlandaEkleAciklama =>
      'Uygulamayı kullanmaya devam edebilirsin; parçalar arka planda eklenir.';

  @override
  String arkaPlandaBasladi(int count) {
    return '$count fotoğraf arka planda ekleniyor';
  }

  @override
  String arkaPlandaIlerleme(int count, int toplam) {
    return '$count/$toplam işlendi';
  }

  @override
  String arkaPlandaTamamlandi(int count) {
    return '$count parça dolabına eklendi';
  }

  @override
  String arkaPlandaBaziAtlandi(int count) {
    return '$count fotoğraf işlenemedi';
  }

  @override
  String get bugunKaydedildi => 'Kaydedildi';

  @override
  String get bugunGiydildi => 'Giydildi';

  @override
  String get ozellikYakinda => 'Bu özellik yakında eklenecek';

  @override
  String get duelloGeri => 'Geri';
}
