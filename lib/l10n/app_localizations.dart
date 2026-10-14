import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
    Locale('pt'),
    Locale('ru'),
    Locale('tr'),
    Locale('zh')
  ];

  /// No description provided for @appTitle.
  ///
  /// In tr, this message translates to:
  /// **'FitCheck'**
  String get appTitle;

  /// No description provided for @gorunumVeTema.
  ///
  /// In tr, this message translates to:
  /// **'Görünüm ve Tema'**
  String get gorunumVeTema;

  /// No description provided for @karanlikMod.
  ///
  /// In tr, this message translates to:
  /// **'Karanlık Mod'**
  String get karanlikMod;

  /// No description provided for @koyuTemaAktif.
  ///
  /// In tr, this message translates to:
  /// **'Koyu Tema Aktif'**
  String get koyuTemaAktif;

  /// No description provided for @acikTemaAktif.
  ///
  /// In tr, this message translates to:
  /// **'Açık Tema Aktif'**
  String get acikTemaAktif;

  /// No description provided for @dilAyarlari.
  ///
  /// In tr, this message translates to:
  /// **'Dil ve Bölge Ayarları'**
  String get dilAyarlari;

  /// No description provided for @uygulamaDili.
  ///
  /// In tr, this message translates to:
  /// **'Uygulama Dili'**
  String get uygulamaDili;

  /// No description provided for @hakkinda.
  ///
  /// In tr, this message translates to:
  /// **'Uygulama Hakkında'**
  String get hakkinda;

  /// No description provided for @surum.
  ///
  /// In tr, this message translates to:
  /// **'Sürüm'**
  String get surum;

  /// No description provided for @ayarOtomatikCihazDili.
  ///
  /// In tr, this message translates to:
  /// **'🌐 Otomatik (Cihaz Dili)'**
  String get ayarOtomatikCihazDili;

  /// No description provided for @iptal.
  ///
  /// In tr, this message translates to:
  /// **'İptal'**
  String get iptal;

  /// No description provided for @tamam.
  ///
  /// In tr, this message translates to:
  /// **'Tamam'**
  String get tamam;

  /// No description provided for @gardirobumTitle.
  ///
  /// In tr, this message translates to:
  /// **'SANAL GARDIROBUM'**
  String get gardirobumTitle;

  /// No description provided for @gardirobumYukleniyor.
  ///
  /// In tr, this message translates to:
  /// **'AI İnceliyor...'**
  String get gardirobumYukleniyor;

  /// No description provided for @gardirobumTopluEkle.
  ///
  /// In tr, this message translates to:
  /// **'Toplu Parça Ekle'**
  String get gardirobumTopluEkle;

  /// No description provided for @gardirobumInceleniyor.
  ///
  /// In tr, this message translates to:
  /// **'İnceleniyor ({kacinci}/{toplam})'**
  String gardirobumInceleniyor(Object kacinci, Object toplam);

  /// No description provided for @gardirobumTemizleBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Gardırobu Temizle'**
  String get gardirobumTemizleBaslik;

  /// No description provided for @gardirobumTemizleOnay.
  ///
  /// In tr, this message translates to:
  /// **'Dolabınızdaki tüm kıyafetler silinecek. Emin misiniz?'**
  String get gardirobumTemizleOnay;

  /// No description provided for @gardirobumEvet.
  ///
  /// In tr, this message translates to:
  /// **'Evet, Temizle'**
  String get gardirobumEvet;

  /// No description provided for @gardirobumHataMesaji.
  ///
  /// In tr, this message translates to:
  /// **'Parçalar eklenirken bir hata oluştu.'**
  String get gardirobumHataMesaji;

  /// No description provided for @gardirobumKategoriTumu.
  ///
  /// In tr, this message translates to:
  /// **'Tümü'**
  String get gardirobumKategoriTumu;

  /// No description provided for @gardirobumKategoriUst.
  ///
  /// In tr, this message translates to:
  /// **'Üst'**
  String get gardirobumKategoriUst;

  /// No description provided for @gardirobumKategoriAlt.
  ///
  /// In tr, this message translates to:
  /// **'Alt'**
  String get gardirobumKategoriAlt;

  /// No description provided for @gardirobumKategoriAyakkabi.
  ///
  /// In tr, this message translates to:
  /// **'Ayakkabı'**
  String get gardirobumKategoriAyakkabi;

  /// No description provided for @gardirobumKategoriAksesuar.
  ///
  /// In tr, this message translates to:
  /// **'Aksesuar'**
  String get gardirobumKategoriAksesuar;

  /// No description provided for @gardirobumBosKategori.
  ///
  /// In tr, this message translates to:
  /// **'Bu kategoride parça bulunmuyor.'**
  String get gardirobumBosKategori;

  /// No description provided for @gardirobumGiymeSayisi.
  ///
  /// In tr, this message translates to:
  /// **'Giyme:'**
  String get gardirobumGiymeSayisi;

  /// No description provided for @gardirobumMaliyet.
  ///
  /// In tr, this message translates to:
  /// **'Maliyet: ₺{tutar} / giyim'**
  String gardirobumMaliyet(Object tutar);

  /// No description provided for @gardirobumDolabaAl.
  ///
  /// In tr, this message translates to:
  /// **'Dolaba Al'**
  String get gardirobumDolabaAl;

  /// No description provided for @gardirobumSepeteAt.
  ///
  /// In tr, this message translates to:
  /// **'Sepete At'**
  String get gardirobumSepeteAt;

  /// No description provided for @gardirobumSepetteRozet.
  ///
  /// In tr, this message translates to:
  /// **'SEPETTE'**
  String get gardirobumSepetteRozet;

  /// No description provided for @gardirobumGecersizParcaBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Geçersiz Parça Algılandı'**
  String get gardirobumGecersizParcaBaslik;

  /// No description provided for @gardirobumGecersizParcaIcerik.
  ///
  /// In tr, this message translates to:
  /// **'Sistemimiz bu görselde bir giysi, ayakkabı veya aksesuar tespit edemedi (Ahşap eşya, mobilya, ev eşyası veya uyumsuz nesne algılandı). Lütfen sadece gardırop parçalarınızı yükleyin.'**
  String get gardirobumGecersizParcaIcerik;

  /// No description provided for @gardirobumTamam.
  ///
  /// In tr, this message translates to:
  /// **'Tamam'**
  String get gardirobumTamam;

  /// No description provided for @stilistTitle.
  ///
  /// In tr, this message translates to:
  /// **'ANLIK KOMBİN STİLİSTİ'**
  String get stilistTitle;

  /// No description provided for @gunlukKombinTitle.
  ///
  /// In tr, this message translates to:
  /// **'GÜNLÜK KOMBİN'**
  String get gunlukKombinTitle;

  /// No description provided for @gunlukKombinHazirBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Kombinine Hazır mısın?'**
  String get gunlukKombinHazirBaslik;

  /// No description provided for @gunlukKombinHazirIcerik.
  ///
  /// In tr, this message translates to:
  /// **'Zar atarak ya da telefonunu sallayarak bugünün kombinini oluştur.'**
  String get gunlukKombinHazirIcerik;

  /// No description provided for @gunlukKombinKartBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Bugünün Kombini'**
  String get gunlukKombinKartBaslik;

  /// No description provided for @stilistAnlikHavaDurumu.
  ///
  /// In tr, this message translates to:
  /// **'Anlık Hava Durumu (Yenilemek için dokun)'**
  String get stilistAnlikHavaDurumu;

  /// No description provided for @stilistKonumKontrol.
  ///
  /// In tr, this message translates to:
  /// **'Konum kontrol ediliyor...'**
  String get stilistKonumKontrol;

  /// No description provided for @stilistNereyeGidiyorsun.
  ///
  /// In tr, this message translates to:
  /// **'Nereye Gidiyorsun?'**
  String get stilistNereyeGidiyorsun;

  /// No description provided for @stilistDusunuyor.
  ///
  /// In tr, this message translates to:
  /// **'Stilist Düşünüyor...'**
  String get stilistDusunuyor;

  /// No description provided for @stilistBugunNeGiymeliyim.
  ///
  /// In tr, this message translates to:
  /// **'Bugün Ne Giymeliyim?'**
  String get stilistBugunNeGiymeliyim;

  /// No description provided for @stilistKombiniTemizle.
  ///
  /// In tr, this message translates to:
  /// **'Kombini Temizle'**
  String get stilistKombiniTemizle;

  /// No description provided for @stilistKombininTitle.
  ///
  /// In tr, this message translates to:
  /// **'{ortam} Kombinin'**
  String stilistKombininTitle(Object ortam);

  /// No description provided for @stilistUyum.
  ///
  /// In tr, this message translates to:
  /// **'🎨 Uyum: %{puan}'**
  String stilistUyum(Object puan);

  /// No description provided for @stilistUstGiyim.
  ///
  /// In tr, this message translates to:
  /// **'Üst Giyim'**
  String get stilistUstGiyim;

  /// No description provided for @stilistAltGiyim.
  ///
  /// In tr, this message translates to:
  /// **'Alt Giyim'**
  String get stilistAltGiyim;

  /// No description provided for @stilistAyakkabi.
  ///
  /// In tr, this message translates to:
  /// **'Ayakkabı'**
  String get stilistAyakkabi;

  /// No description provided for @stilistAksesuar.
  ///
  /// In tr, this message translates to:
  /// **'Aksesuar'**
  String get stilistAksesuar;

  /// No description provided for @stilistFavoriyeEkle.
  ///
  /// In tr, this message translates to:
  /// **'Favoriye Ekle'**
  String get stilistFavoriyeEkle;

  /// No description provided for @stilistBugunGiydim.
  ///
  /// In tr, this message translates to:
  /// **'Bugün Giydim'**
  String get stilistBugunGiydim;

  /// No description provided for @bugunGiydimOnayIcerik.
  ///
  /// In tr, this message translates to:
  /// **'Bugün bu kombini giydin mi?'**
  String get bugunGiydimOnayIcerik;

  /// No description provided for @stilistTrendyolTamamla.
  ///
  /// In tr, this message translates to:
  /// **'Trendyol\'da Tamamla'**
  String get stilistTrendyolTamamla;

  /// No description provided for @stilistHata.
  ///
  /// In tr, this message translates to:
  /// **'Kombin oluşturulurken bir hata oluştu.'**
  String get stilistHata;

  /// No description provided for @ortamCasual.
  ///
  /// In tr, this message translates to:
  /// **'Günlük / Casual'**
  String get ortamCasual;

  /// No description provided for @ortamOfis.
  ///
  /// In tr, this message translates to:
  /// **'Ofis / İş'**
  String get ortamOfis;

  /// No description provided for @ortamDavet.
  ///
  /// In tr, this message translates to:
  /// **'Düğün / Özel Davet'**
  String get ortamDavet;

  /// No description provided for @ortamSpor.
  ///
  /// In tr, this message translates to:
  /// **'Spor / Yürüyüş'**
  String get ortamSpor;

  /// No description provided for @ortamGece.
  ///
  /// In tr, this message translates to:
  /// **'Gece Eğlencesi'**
  String get ortamGece;

  /// No description provided for @ortamRomantik.
  ///
  /// In tr, this message translates to:
  /// **'Romantik Buluşma'**
  String get ortamRomantik;

  /// No description provided for @stilistUyariDolapBosBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Gardırobun Boş Veya Tüm Parçalar Yıkamada! 🧺'**
  String get stilistUyariDolapBosBaslik;

  /// No description provided for @stilistUyariDolapBosIcerik.
  ///
  /// In tr, this message translates to:
  /// **'Sana özel anlık kombinler yapabilmem için dolabına birkaç temiz kıyafet veya aksesuar eklemelisin.'**
  String get stilistUyariDolapBosIcerik;

  /// No description provided for @stilistUyariUstEksikBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Üst Giyim Eksik! 👕'**
  String get stilistUyariUstEksikBaslik;

  /// No description provided for @stilistUyariUstEksikIcerik.
  ///
  /// In tr, this message translates to:
  /// **'Gardırobunda henüz hiç temiz üst giyim yok. Tam bir kombin için dolabına en az bir üst parçası eklemelisin!'**
  String get stilistUyariUstEksikIcerik;

  /// No description provided for @stilistUyariAltEksikBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Alt Giyim Eksik! 👖'**
  String get stilistUyariAltEksikBaslik;

  /// No description provided for @stilistUyariAltEksikIcerik.
  ///
  /// In tr, this message translates to:
  /// **'Gardırobunda henüz hiç temiz alt giyim yok. Şık bir kombin yapabilmemiz için dolabına bir alt parçası eklemelisin!'**
  String get stilistUyariAltEksikIcerik;

  /// No description provided for @stilistUyariAyakkabiEksikBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Ayakkabın Eksik! 👟'**
  String get stilistUyariAyakkabiEksikBaslik;

  /// No description provided for @stilistUyariAyakkabiEksikIcerik.
  ///
  /// In tr, this message translates to:
  /// **'Kıyafetlerin harika görünüyor ama kombinini tamamlayacak temiz bir ayakkabı bulamadım. Dolabına hemen bir ayakkabı ekle!'**
  String get stilistUyariAyakkabiEksikIcerik;

  /// No description provided for @stilistUyariButon.
  ///
  /// In tr, this message translates to:
  /// **'Anladım, Ekliyorum!'**
  String get stilistUyariButon;

  /// No description provided for @anaHavaYukleniyor.
  ///
  /// In tr, this message translates to:
  /// **'Konum hava durumu yükleniyor...'**
  String get anaHavaYukleniyor;

  /// No description provided for @anaDinliyor.
  ///
  /// In tr, this message translates to:
  /// **'🎙️ FITCHECK Sizi Dinliyor... Konuşun!'**
  String get anaDinliyor;

  /// No description provided for @anaMikrofonHata.
  ///
  /// In tr, this message translates to:
  /// **'Mikrofon izni veya ses tanıma servisi hazır değil.'**
  String get anaMikrofonHata;

  /// No description provided for @anaCinsiyetGuncellendi.
  ///
  /// In tr, this message translates to:
  /// **'Tercihiniz \"{cinsiyet}\" olarak güncellendi ✨'**
  String anaCinsiyetGuncellendi(Object cinsiyet);

  /// No description provided for @anaKonumKapaliBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Konum Servisi Kapalı'**
  String get anaKonumKapaliBaslik;

  /// No description provided for @anaKonumKapaliIcerik.
  ///
  /// In tr, this message translates to:
  /// **'Hava durumuna göre kombin önerileri alabilmek için GPS konumunuzu açmanız gerekiyor.'**
  String get anaKonumKapaliIcerik;

  /// No description provided for @anaKonumuAc.
  ///
  /// In tr, this message translates to:
  /// **'Konumu Aç'**
  String get anaKonumuAc;

  /// No description provided for @anaIzinVer.
  ///
  /// In tr, this message translates to:
  /// **'İzin Ver'**
  String get anaIzinVer;

  /// No description provided for @anaIptal.
  ///
  /// In tr, this message translates to:
  /// **'İptal'**
  String get anaIptal;

  /// No description provided for @anaKonumIzinRedBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Konum İzni Reddedildi'**
  String get anaKonumIzinRedBaslik;

  /// No description provided for @anaKonumIzinRedIcerik1.
  ///
  /// In tr, this message translates to:
  /// **'İzin verilmediği için tahmin alınamadı.'**
  String get anaKonumIzinRedIcerik1;

  /// No description provided for @anaKonumIzinRedIcerik2.
  ///
  /// In tr, this message translates to:
  /// **'Ayarlardan izin vermelisiniz.'**
  String get anaKonumIzinRedIcerik2;

  /// No description provided for @anaKonumIzinGerekliBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Konum İzni Gerekli'**
  String get anaKonumIzinGerekliBaslik;

  /// No description provided for @anaKonumIzinGerekliIcerik.
  ///
  /// In tr, this message translates to:
  /// **'Uygulamanın hava durumunu görebilmesi için ayarlardan konum iznini aktif etmelisiniz.'**
  String get anaKonumIzinGerekliIcerik;

  /// No description provided for @anaHavaDurumuAlinamadi.
  ///
  /// In tr, this message translates to:
  /// **'Hava durumu alınamadı'**
  String get anaHavaDurumuAlinamadi;

  /// No description provided for @anaHavaTahminiYuklenemedi.
  ///
  /// In tr, this message translates to:
  /// **'Hava tahminleri yüklenemedi.'**
  String get anaHavaTahminiYuklenemedi;

  /// No description provided for @anaFavoriEklendi.
  ///
  /// In tr, this message translates to:
  /// **'Kombin favorilere eklendi! ⭐'**
  String get anaFavoriEklendi;

  /// No description provided for @anaKombinTekrarUyari.
  ///
  /// In tr, this message translates to:
  /// **'⚠️ Uyarı: Bu parçaları veya benzerlerini son zamanlarda çok sık giydin. Bugün farklı bir tarz deneyebilirsin!'**
  String get anaKombinTekrarUyari;

  /// No description provided for @anaKombinMukemmel.
  ///
  /// In tr, this message translates to:
  /// **'✨ Mükemmel seçim! Tarzın bugün gayet dengeli ve ferah.'**
  String get anaKombinMukemmel;

  /// No description provided for @anaYikamaUyariBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Akıllı Yıkama Uyarısı'**
  String get anaYikamaUyariBaslik;

  /// No description provided for @anaYikamaUyariIcerik.
  ///
  /// In tr, this message translates to:
  /// **'Bu kombini giydiğiniz için \"{parcalar}\" adlı parça(lar) çok sık kullanıldı ve otomatik olarak yıkama sepetine gönderildi! 🧺'**
  String anaYikamaUyariIcerik(Object parcalar);

  /// No description provided for @anaTamam.
  ///
  /// In tr, this message translates to:
  /// **'Tamam'**
  String get anaTamam;

  /// No description provided for @anaAyarlarTooltip.
  ///
  /// In tr, this message translates to:
  /// **'Ayarlar'**
  String get anaAyarlarTooltip;

  /// No description provided for @anaKadin.
  ///
  /// In tr, this message translates to:
  /// **'Kadın'**
  String get anaKadin;

  /// No description provided for @anaErkek.
  ///
  /// In tr, this message translates to:
  /// **'Erkek'**
  String get anaErkek;

  /// No description provided for @anaSesleKonus.
  ///
  /// In tr, this message translates to:
  /// **'Sesle Konuş'**
  String get anaSesleKonus;

  /// No description provided for @anaStilistAsistani.
  ///
  /// In tr, this message translates to:
  /// **'Stilist Asistani'**
  String get anaStilistAsistani;

  /// No description provided for @anaSekmeGardirop.
  ///
  /// In tr, this message translates to:
  /// **'Gardırop'**
  String get anaSekmeGardirop;

  /// No description provided for @anaSekmeHaftalik.
  ///
  /// In tr, this message translates to:
  /// **'Haftalık'**
  String get anaSekmeHaftalik;

  /// No description provided for @anaSekmeAnlik.
  ///
  /// In tr, this message translates to:
  /// **'Anlık'**
  String get anaSekmeAnlik;

  /// No description provided for @anaSekmeYarismasi.
  ///
  /// In tr, this message translates to:
  /// **'Yarışma'**
  String get anaSekmeYarismasi;

  /// No description provided for @anaSekmeProfil.
  ///
  /// In tr, this message translates to:
  /// **'Profil & Analiz'**
  String get anaSekmeProfil;

  /// No description provided for @modaYarismasiBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Moda & Renk Uyumu'**
  String get modaYarismasiBaslik;

  /// No description provided for @modaYarismasiGunlukTamamlandi.
  ///
  /// In tr, this message translates to:
  /// **'Bugünkü yarışma tamamlandı'**
  String get modaYarismasiGunlukTamamlandi;

  /// No description provided for @modaYarismasiYeniYarin.
  ///
  /// In tr, this message translates to:
  /// **'Yeni 10 soruluk set yarın tekrar gelir.'**
  String get modaYarismasiYeniYarin;

  /// No description provided for @modaYarismasiSonuc.
  ///
  /// In tr, this message translates to:
  /// **'Sonuç'**
  String get modaYarismasiSonuc;

  /// No description provided for @modaYarismasiSkor.
  ///
  /// In tr, this message translates to:
  /// **'Skorun: {skor} / 10'**
  String modaYarismasiSkor(Object skor);

  /// No description provided for @modaYarismasiSoru.
  ///
  /// In tr, this message translates to:
  /// **'Soru {index} / 10'**
  String modaYarismasiSoru(Object index);

  /// No description provided for @modaYarismasiGeri.
  ///
  /// In tr, this message translates to:
  /// **'Geri'**
  String get modaYarismasiGeri;

  /// No description provided for @modaYarismasiAnaEkrana.
  ///
  /// In tr, this message translates to:
  /// **'Ana Ekrana Dön'**
  String get modaYarismasiAnaEkrana;

  /// No description provided for @havaParcaliBulutlu.
  ///
  /// In tr, this message translates to:
  /// **'Parçalı Bulutlu'**
  String get havaParcaliBulutlu;

  /// No description provided for @havaSicakGunesli.
  ///
  /// In tr, this message translates to:
  /// **'Sıcak ve Güneşli'**
  String get havaSicakGunesli;

  /// No description provided for @havaSogukKarli.
  ///
  /// In tr, this message translates to:
  /// **'Soğuk ve Karlı'**
  String get havaSogukKarli;

  /// No description provided for @havaYagmurlu.
  ///
  /// In tr, this message translates to:
  /// **'Yağmurlu'**
  String get havaYagmurlu;

  /// No description provided for @havaGunesli.
  ///
  /// In tr, this message translates to:
  /// **'Güneşli'**
  String get havaGunesli;

  /// No description provided for @havaSoguk.
  ///
  /// In tr, this message translates to:
  /// **'Soğuk'**
  String get havaSoguk;

  /// No description provided for @gunPzt.
  ///
  /// In tr, this message translates to:
  /// **'Pazartesi'**
  String get gunPzt;

  /// No description provided for @gunSal.
  ///
  /// In tr, this message translates to:
  /// **'Salı'**
  String get gunSal;

  /// No description provided for @gunCar.
  ///
  /// In tr, this message translates to:
  /// **'Çarşamba'**
  String get gunCar;

  /// No description provided for @gunPer.
  ///
  /// In tr, this message translates to:
  /// **'Perşembe'**
  String get gunPer;

  /// No description provided for @gunCum.
  ///
  /// In tr, this message translates to:
  /// **'Cuma'**
  String get gunCum;

  /// No description provided for @gunCmt.
  ///
  /// In tr, this message translates to:
  /// **'Cumartesi'**
  String get gunCmt;

  /// No description provided for @gunPaz.
  ///
  /// In tr, this message translates to:
  /// **'Pazar'**
  String get gunPaz;

  /// No description provided for @stilKahveBaslik.
  ///
  /// In tr, this message translates to:
  /// **'☕ Kahve & Günlük'**
  String get stilKahveBaslik;

  /// No description provided for @stilKahveSoru.
  ///
  /// In tr, this message translates to:
  /// **'Arkadaşlarla kahveye çıkmak için günlük şık bir kombin öner'**
  String get stilKahveSoru;

  /// No description provided for @stilOfisBaslik.
  ///
  /// In tr, this message translates to:
  /// **'💼 İş / Ofis Şıklığı'**
  String get stilOfisBaslik;

  /// No description provided for @stilOfisSoru.
  ///
  /// In tr, this message translates to:
  /// **'Ofis ve iş ortamına uygun modern ve şık bir kombin öner'**
  String get stilOfisSoru;

  /// No description provided for @stilSporBaslik.
  ///
  /// In tr, this message translates to:
  /// **'🏃 Spor / Rahat Giyim'**
  String get stilSporBaslik;

  /// No description provided for @stilSporSoru.
  ///
  /// In tr, this message translates to:
  /// **'Hafta sonu gezisi için çok rahat ve spor bir kombin öner'**
  String get stilSporSoru;

  /// No description provided for @stilGeceBaslik.
  ///
  /// In tr, this message translates to:
  /// **'🌙 Gece / Özel Davet'**
  String get stilGeceBaslik;

  /// No description provided for @stilGeceSoru.
  ///
  /// In tr, this message translates to:
  /// **'Akşam yemeği veya özel davet için iddialı bir kombin öner'**
  String get stilGeceSoru;

  /// No description provided for @ilkGorevBaslik.
  ///
  /// In tr, this message translates to:
  /// **'🎯 İlk Görev: Stilini Seç!'**
  String get ilkGorevBaslik;

  /// No description provided for @ilkGorevAciklama.
  ///
  /// In tr, this message translates to:
  /// **'FitCheck Yapay Zekası senin için anında kombin üretecek. Bugün nereye gidiyorsun?'**
  String get ilkGorevAciklama;

  /// No description provided for @haftalikUyariButon.
  ///
  /// In tr, this message translates to:
  /// **'Anladım'**
  String get haftalikUyariButon;

  /// No description provided for @haftalikUyariDolapBosBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Gardırobun Boş!'**
  String get haftalikUyariDolapBosBaslik;

  /// No description provided for @haftalikUyariDolapBosIcerik.
  ///
  /// In tr, this message translates to:
  /// **'Haftalık plan yapabilmem için dolabına kıyafet eklemelisin.'**
  String get haftalikUyariDolapBosIcerik;

  /// No description provided for @haftalikUyariUstEksikBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Üst Giyim Eksik!'**
  String get haftalikUyariUstEksikBaslik;

  /// No description provided for @haftalikUyariUstEksikIcerik.
  ///
  /// In tr, this message translates to:
  /// **'Dolabında hiç temiz üst giyim yok.'**
  String get haftalikUyariUstEksikIcerik;

  /// No description provided for @haftalikUyariAltEksikBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Alt Giyim Eksik!'**
  String get haftalikUyariAltEksikBaslik;

  /// No description provided for @haftalikUyariAltEksikIcerik.
  ///
  /// In tr, this message translates to:
  /// **'Dolabında hiç temiz alt giyim yok.'**
  String get haftalikUyariAltEksikIcerik;

  /// No description provided for @haftalikUyariAyakkabiEksikBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Ayakkabı Eksik!'**
  String get haftalikUyariAyakkabiEksikBaslik;

  /// No description provided for @haftalikUyariAyakkabiEksikIcerik.
  ///
  /// In tr, this message translates to:
  /// **'Dolabında temiz ayakkabı bulunmuyor.'**
  String get haftalikUyariAyakkabiEksikIcerik;

  /// No description provided for @haftalikHata.
  ///
  /// In tr, this message translates to:
  /// **'Haftalık plan oluşturulurken hata oluştu.'**
  String get haftalikHata;

  /// No description provided for @haftalikAjandaTitle.
  ///
  /// In tr, this message translates to:
  /// **'HAFTALIK STİL AJANDASI'**
  String get haftalikAjandaTitle;

  /// No description provided for @haftalikAnlikHavaDurumu.
  ///
  /// In tr, this message translates to:
  /// **'Haftalık Hava Tahmini'**
  String get haftalikAnlikHavaDurumu;

  /// No description provided for @haftalikKonumKontrol.
  ///
  /// In tr, this message translates to:
  /// **'Hava durumu yükleniyor...'**
  String get haftalikKonumKontrol;

  /// No description provided for @haftalikTemizParca.
  ///
  /// In tr, this message translates to:
  /// **'Temiz Parça'**
  String get haftalikTemizParca;

  /// No description provided for @haftalikSepette.
  ///
  /// In tr, this message translates to:
  /// **'Sepette'**
  String get haftalikSepette;

  /// No description provided for @haftalikPlanAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Yapay zeka hava durumuna göre 7 günlük kombin planını hazırlasın.'**
  String get haftalikPlanAciklama;

  /// No description provided for @haftalikProgramOlustur.
  ///
  /// In tr, this message translates to:
  /// **'Haftalık Program Oluştur'**
  String get haftalikProgramOlustur;

  /// No description provided for @haftalikPlaniTemizle.
  ///
  /// In tr, this message translates to:
  /// **'Planı Temizle'**
  String get haftalikPlaniTemizle;

  /// No description provided for @haftalikAnalizEdiliyor.
  ///
  /// In tr, this message translates to:
  /// **'Yapay Zeka Planlıyor...'**
  String get haftalikAnalizEdiliyor;

  /// No description provided for @haftalikUyum.
  ///
  /// In tr, this message translates to:
  /// **'Uyum'**
  String get haftalikUyum;

  /// No description provided for @haftalikFavoriEkle.
  ///
  /// In tr, this message translates to:
  /// **'Favorilere Ekle'**
  String get haftalikFavoriEkle;

  /// No description provided for @haftalikGiyildiIsaretle.
  ///
  /// In tr, this message translates to:
  /// **'Bugün Giydim'**
  String get haftalikGiyildiIsaretle;

  /// No description provided for @haftalikHava.
  ///
  /// In tr, this message translates to:
  /// **'Hava Durumu:'**
  String get haftalikHava;

  /// No description provided for @haftalikHavaUyarisi.
  ///
  /// In tr, this message translates to:
  /// **'Not: Bu kombindeki parçalar, günün havasına uygun olacak şekilde güncellendi.'**
  String get haftalikHavaUyarisi;

  /// No description provided for @haftalikUyumsuzParca.
  ///
  /// In tr, this message translates to:
  /// **'Eksik Parça'**
  String get haftalikUyumsuzParca;

  /// No description provided for @haftalikEksikParcaStilistNotu.
  ///
  /// In tr, this message translates to:
  /// **'Eksik parçayı da hesaba katan stilist, elindeki temiz parçalarla önerileri hazırladı.'**
  String get haftalikEksikParcaStilistNotu;

  /// No description provided for @haftalikEksikParcaYeterliParcaYok.
  ///
  /// In tr, this message translates to:
  /// **'Bu günü dolduracak kadar temiz parça kalmadı. Dolabına yeni bir parça ekle ya da çamaşırları yıka; stilist buraya yeni bir kombin önersin.'**
  String get haftalikEksikParcaYeterliParcaYok;

  /// No description provided for @haftalikEksikParcaAiOnerisi.
  ///
  /// In tr, this message translates to:
  /// **'AI Kombin Önerisi'**
  String get haftalikEksikParcaAiOnerisi;

  /// No description provided for @haftalikEksikParcaOneriYok.
  ///
  /// In tr, this message translates to:
  /// **'Eksik parçayı tamamlayan üst, alt ve ayakkabı kombinini görmek için planı yenile.'**
  String get haftalikEksikParcaOneriYok;

  /// No description provided for @haftalikEksikParcaOnerisiBaslik.
  ///
  /// In tr, this message translates to:
  /// **'AI Stilist Kombin Önerisi'**
  String get haftalikEksikParcaOnerisiBaslik;

  /// No description provided for @haftalikEksikParcaOneriHazirlaniyor.
  ///
  /// In tr, this message translates to:
  /// **'Stilist kombin önerisini hazırlıyor…'**
  String get haftalikEksikParcaOneriHazirlaniyor;

  /// No description provided for @haftalikEksikParcaPlanKurulamadi.
  ///
  /// In tr, this message translates to:
  /// **'Üst ve alt parça olmadan kombin kurulamıyor. Stilist tamamlayıcı önerisini yukarıda hazırladı.'**
  String get haftalikEksikParcaPlanKurulamadi;

  /// No description provided for @haftalikNot.
  ///
  /// In tr, this message translates to:
  /// **'Not'**
  String get haftalikNot;

  /// No description provided for @haftalikTrendyolAra.
  ///
  /// In tr, this message translates to:
  /// **'Trendyol\'da Ara'**
  String get haftalikTrendyolAra;

  /// No description provided for @izinZorunluMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Uygulamayı kullanabilmek için bu izinler zorunludur.'**
  String get izinZorunluMesaj;

  /// No description provided for @izinGerekliBaslik.
  ///
  /// In tr, this message translates to:
  /// **'İzin Gerekli'**
  String get izinGerekliBaslik;

  /// No description provided for @izinGerekliIcerik.
  ///
  /// In tr, this message translates to:
  /// **'Kamera ve konum izinleri reddedilmiş. Ayarlardan aktif etmeniz gerekiyor.'**
  String get izinGerekliIcerik;

  /// No description provided for @ayarlaraGit.
  ///
  /// In tr, this message translates to:
  /// **'Ayarlara Git'**
  String get ayarlaraGit;

  /// No description provided for @izinAnaBaslik.
  ///
  /// In tr, this message translates to:
  /// **'İzinler Gerekli'**
  String get izinAnaBaslik;

  /// No description provided for @izinAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Sana en iyi kombinleri sunabilmemiz için konum (hava durumu) ve kamera (fotoğraf) izinlerine ihtiyacımız var.'**
  String get izinAciklama;

  /// No description provided for @konumIzni.
  ///
  /// In tr, this message translates to:
  /// **'Konum İzni'**
  String get konumIzni;

  /// No description provided for @kameraIzni.
  ///
  /// In tr, this message translates to:
  /// **'Kamera İzni'**
  String get kameraIzni;

  /// No description provided for @izinVerDevamEt.
  ///
  /// In tr, this message translates to:
  /// **'İzin Ver ve Devam Et'**
  String get izinVerDevamEt;

  /// No description provided for @gunlukHavaMevcutDegil.
  ///
  /// In tr, this message translates to:
  /// **'Hava durumu mevcut değil'**
  String get gunlukHavaMevcutDegil;

  /// No description provided for @profilAnalizTitle.
  ///
  /// In tr, this message translates to:
  /// **'PROFİL & ANALİZ'**
  String get profilAnalizTitle;

  /// No description provided for @anlikDurum.
  ///
  /// In tr, this message translates to:
  /// **'Anlık Durum'**
  String get anlikDurum;

  /// No description provided for @toplamParca.
  ///
  /// In tr, this message translates to:
  /// **'Toplam Parça'**
  String get toplamParca;

  /// No description provided for @favoriKombin.
  ///
  /// In tr, this message translates to:
  /// **'Favori Kombin'**
  String get favoriKombin;

  /// No description provided for @gardiropDegeri.
  ///
  /// In tr, this message translates to:
  /// **'Gardırop Değeri'**
  String get gardiropDegeri;

  /// No description provided for @ortalamaMaliyet.
  ///
  /// In tr, this message translates to:
  /// **'Ortalama Maliyet'**
  String get ortalamaMaliyet;

  /// No description provided for @kategoriDagilimi.
  ///
  /// In tr, this message translates to:
  /// **'Kategori Dağılımı'**
  String get kategoriDagilimi;

  /// No description provided for @ustGiyim.
  ///
  /// In tr, this message translates to:
  /// **'Üst Giyim'**
  String get ustGiyim;

  /// No description provided for @altGiyim.
  ///
  /// In tr, this message translates to:
  /// **'Alt Giyim'**
  String get altGiyim;

  /// No description provided for @ayakkabi.
  ///
  /// In tr, this message translates to:
  /// **'Ayakkabı'**
  String get ayakkabi;

  /// No description provided for @disGiyim.
  ///
  /// In tr, this message translates to:
  /// **'Dış Giyim'**
  String get disGiyim;

  /// No description provided for @aksesuar.
  ///
  /// In tr, this message translates to:
  /// **'Aksesuar'**
  String get aksesuar;

  /// No description provided for @sonGiyecekGecmisi.
  ///
  /// In tr, this message translates to:
  /// **'Son Giyilenler Geçmişi'**
  String get sonGiyecekGecmisi;

  /// No description provided for @kayit.
  ///
  /// In tr, this message translates to:
  /// **'Kayıt'**
  String get kayit;

  /// No description provided for @gecmisKombinYok.
  ///
  /// In tr, this message translates to:
  /// **'Henüz geçmiş kombin kaydı yok.'**
  String get gecmisKombinYok;

  /// No description provided for @parca.
  ///
  /// In tr, this message translates to:
  /// **'Parça'**
  String get parca;

  /// No description provided for @onboardingHosGeldinBaslik.
  ///
  /// In tr, this message translates to:
  /// **'FitCheck\'e Hoş Geldin! ✨'**
  String get onboardingHosGeldinBaslik;

  /// No description provided for @onboardingDolabiniDijitallestir.
  ///
  /// In tr, this message translates to:
  /// **'Dolabını Dijitalleştir'**
  String get onboardingDolabiniDijitallestir;

  /// No description provided for @onboardingDolapAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Kıyafetlerini saniyeler içinde ekle ve kendi sanal gardırobunu oluştur.'**
  String get onboardingDolapAciklama;

  /// No description provided for @onboardingHavaDurumu.
  ///
  /// In tr, this message translates to:
  /// **'Hava Durumuna Uygun'**
  String get onboardingHavaDurumu;

  /// No description provided for @onboardingHavaAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Bulunduğun konumun günlük hava durumuna en uygun kombin önerilerini al.'**
  String get onboardingHavaAciklama;

  /// No description provided for @onboardingYikama.
  ///
  /// In tr, this message translates to:
  /// **'Akıllı Yıkama Takibi'**
  String get onboardingYikama;

  /// No description provided for @onboardingYikamaAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Çok sık giydiğin kıyafetleri sistem otomatik algılar ve yıkama sepetine gönderir.'**
  String get onboardingYikamaAciklama;

  /// No description provided for @onboardingEksikParca.
  ///
  /// In tr, this message translates to:
  /// **'Eksik Parça Önerisi'**
  String get onboardingEksikParca;

  /// No description provided for @onboardingEksikAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Kombinini tamamlayacak eksik parçaları belirler ve anında alışveriş önerisi sunar.'**
  String get onboardingEksikAciklama;

  /// No description provided for @onboardingAnalitik.
  ///
  /// In tr, this message translates to:
  /// **'Gelişmiş Analitik'**
  String get onboardingAnalitik;

  /// No description provided for @onboardingAnalitikAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Dolabının toplam değerini, giyim başı maliyetini ve favori tarzını analiz et.'**
  String get onboardingAnalitikAciklama;

  /// No description provided for @onboardingStilist.
  ///
  /// In tr, this message translates to:
  /// **'Yapay Zeka Stilist'**
  String get onboardingStilist;

  /// No description provided for @onboardingStilistAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Sadece nereye gideceğini söyle, yapay zeka saniyeler içinde en şık kombini hazırlasın.'**
  String get onboardingStilistAciklama;

  /// No description provided for @onboardingAtla.
  ///
  /// In tr, this message translates to:
  /// **'Atla'**
  String get onboardingAtla;

  /// No description provided for @onboardingModaProfiliniz.
  ///
  /// In tr, this message translates to:
  /// **'Moda Profilin'**
  String get onboardingModaProfiliniz;

  /// No description provided for @onboardingKadin.
  ///
  /// In tr, this message translates to:
  /// **'Kadın'**
  String get onboardingKadin;

  /// No description provided for @onboardingErkek.
  ///
  /// In tr, this message translates to:
  /// **'Erkek'**
  String get onboardingErkek;

  /// No description provided for @onboardingBasla.
  ///
  /// In tr, this message translates to:
  /// **'Hemen Başla'**
  String get onboardingBasla;

  /// No description provided for @onboardingDevamEt.
  ///
  /// In tr, this message translates to:
  /// **'Devam Et'**
  String get onboardingDevamEt;

  /// No description provided for @cinsiyetBaslik.
  ///
  /// In tr, this message translates to:
  /// **'CİNSİYET'**
  String get cinsiyetBaslik;

  /// No description provided for @tarzBaslik.
  ///
  /// In tr, this message translates to:
  /// **'GÜNLÜK TARZINIZ (BİRDEN FAZLA)'**
  String get tarzBaslik;

  /// No description provided for @renkTercihiBaslik.
  ///
  /// In tr, this message translates to:
  /// **'RENK TERCİHİNİZ'**
  String get renkTercihiBaslik;

  /// No description provided for @tenRengiBaslik.
  ///
  /// In tr, this message translates to:
  /// **'TEN RENGİ TERCİHİNİZ'**
  String get tenRengiBaslik;

  /// No description provided for @kadin.
  ///
  /// In tr, this message translates to:
  /// **'Kadın'**
  String get kadin;

  /// No description provided for @erkek.
  ///
  /// In tr, this message translates to:
  /// **'Erkek'**
  String get erkek;

  /// No description provided for @cinsiyetBelirtilmemis.
  ///
  /// In tr, this message translates to:
  /// **'Belirtilmemiş'**
  String get cinsiyetBelirtilmemis;

  /// No description provided for @tarzSpor.
  ///
  /// In tr, this message translates to:
  /// **'Spor'**
  String get tarzSpor;

  /// No description provided for @tarzKlasik.
  ///
  /// In tr, this message translates to:
  /// **'Klasik'**
  String get tarzKlasik;

  /// No description provided for @tarzSokakModasi.
  ///
  /// In tr, this message translates to:
  /// **'Sokak Modası'**
  String get tarzSokakModasi;

  /// No description provided for @tarzMinimalist.
  ///
  /// In tr, this message translates to:
  /// **'Minimalist'**
  String get tarzMinimalist;

  /// No description provided for @renkKoyuTonlar.
  ///
  /// In tr, this message translates to:
  /// **'Koyu Tonlar'**
  String get renkKoyuTonlar;

  /// No description provided for @renkPastel.
  ///
  /// In tr, this message translates to:
  /// **'Pastel Renkler'**
  String get renkPastel;

  /// No description provided for @renkCanli.
  ///
  /// In tr, this message translates to:
  /// **'Canlı Renkler'**
  String get renkCanli;

  /// No description provided for @renkNotr.
  ///
  /// In tr, this message translates to:
  /// **'Nötr'**
  String get renkNotr;

  /// No description provided for @tenAcikBeyaz.
  ///
  /// In tr, this message translates to:
  /// **'Açık / Beyaz'**
  String get tenAcikBeyaz;

  /// No description provided for @tenBugday.
  ///
  /// In tr, this message translates to:
  /// **'Buğday'**
  String get tenBugday;

  /// No description provided for @tenEsmerKoyu.
  ///
  /// In tr, this message translates to:
  /// **'Esmer / Koyu'**
  String get tenEsmerKoyu;

  /// No description provided for @hesabinizaGirisYapin.
  ///
  /// In tr, this message translates to:
  /// **'Hesabınıza Giriş Yapın'**
  String get hesabinizaGirisYapin;

  /// No description provided for @yeniHesapOlusturun.
  ///
  /// In tr, this message translates to:
  /// **'Yeni Hesap Oluşturun'**
  String get yeniHesapOlusturun;

  /// No description provided for @stilDunyanaTekrarHosGeldin.
  ///
  /// In tr, this message translates to:
  /// **'Stil dünyana tekrar hoş geldin ✨'**
  String get stilDunyanaTekrarHosGeldin;

  /// No description provided for @kombinleriniSaklamakIcinKatil.
  ///
  /// In tr, this message translates to:
  /// **'Kombinlerini saklamak için aramıza katıl 🚀'**
  String get kombinleriniSaklamakIcinKatil;

  /// No description provided for @girisYap.
  ///
  /// In tr, this message translates to:
  /// **'Giriş Yap'**
  String get girisYap;

  /// No description provided for @girisYapGoogle.
  ///
  /// In tr, this message translates to:
  /// **'Google ile Giriş Yap'**
  String get girisYapGoogle;

  /// No description provided for @girisBeniHatirla.
  ///
  /// In tr, this message translates to:
  /// **'Beni hatırla'**
  String get girisBeniHatirla;

  /// No description provided for @girisVeya.
  ///
  /// In tr, this message translates to:
  /// **'veya'**
  String get girisVeya;

  /// No description provided for @kayitOl.
  ///
  /// In tr, this message translates to:
  /// **'Kayıt Ol'**
  String get kayitOl;

  /// No description provided for @adinizVeyaLakabiniz.
  ///
  /// In tr, this message translates to:
  /// **'Adınız veya Lakabınız'**
  String get adinizVeyaLakabiniz;

  /// No description provided for @epostaAdresiniz.
  ///
  /// In tr, this message translates to:
  /// **'E-posta Adresiniz'**
  String get epostaAdresiniz;

  /// No description provided for @sifreniz.
  ///
  /// In tr, this message translates to:
  /// **'Şifreniz'**
  String get sifreniz;

  /// No description provided for @girisYapVeBasla.
  ///
  /// In tr, this message translates to:
  /// **'Giriş Yap ve Başla'**
  String get girisYapVeBasla;

  /// No description provided for @kayitOlVeBasla.
  ///
  /// In tr, this message translates to:
  /// **'Kayıt Ol ve Başla'**
  String get kayitOlVeBasla;

  /// No description provided for @misafirOlarakDevamEt.
  ///
  /// In tr, this message translates to:
  /// **'Misafir Olarak Devam Et'**
  String get misafirOlarakDevamEt;

  /// No description provided for @lutfenEpostaVeSifreGiriniz.
  ///
  /// In tr, this message translates to:
  /// **'Lütfen e-posta adresinizi ve şifrenizi giriniz.'**
  String get lutfenEpostaVeSifreGiriniz;

  /// No description provided for @lutfenAdiniziGiriniz.
  ///
  /// In tr, this message translates to:
  /// **'Lütfen adınızı giriniz.'**
  String get lutfenAdiniziGiriniz;

  /// No description provided for @kullanimKosullariBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Kullanım Koşulları ve Sözleşme'**
  String get kullanimKosullariBaslik;

  /// No description provided for @onaylamakIcinKaydirin.
  ///
  /// In tr, this message translates to:
  /// **'Onaylamak için metnin sonuna kadar kaydırın'**
  String get onaylamakIcinKaydirin;

  /// No description provided for @okudumAnladimKabulEdiyorum.
  ///
  /// In tr, this message translates to:
  /// **'Okudum, Anladım ve Kabul Ediyorum'**
  String get okudumAnladimKabulEdiyorum;

  /// No description provided for @kullanimKosullarini.
  ///
  /// In tr, this message translates to:
  /// **'Kullanım Koşullarını'**
  String get kullanimKosullarini;

  /// No description provided for @okudumVeOnayliyorum.
  ///
  /// In tr, this message translates to:
  /// **' okudum ve onaylıyorum.'**
  String get okudumVeOnayliyorum;

  /// No description provided for @onaylamadanOnceKosullariOkuyun.
  ///
  /// In tr, this message translates to:
  /// **'Onaylamadan önce lütfen kullanım koşullarını okuyun.'**
  String get onaylamadanOnceKosullariOkuyun;

  /// No description provided for @devamEtmekIcinKosullariKabulEdin.
  ///
  /// In tr, this message translates to:
  /// **'Devam etmek için kullanım koşullarını kabul etmelisiniz.'**
  String get devamEtmekIcinKosullariKabulEdin;

  /// No description provided for @kullanimKosullariMetni.
  ///
  /// In tr, this message translates to:
  /// **'FITCHECK KULLANIM KOŞULLARI VE HİZMET SÖZLEŞMESİ\n\nSon Güncelleme Tarihi: 27 Ağustos 2026\n\nLütfen FitCheck mobil uygulamasını (“Uygulama”) kullanmadan önce bu Kullanım Koşulları’nı (“Sözleşme”) dikkatlice okuyunuz. Uygulamayı indirerek, erişerek veya kullanarak bu Sözleşme’de yer alan tüm şartları kabul etmiş sayılırsınız.\n\n1. TARAFLAR VE AMAÇ\nBu Sözleşme, FitCheck uygulamasının geliştiricisi ile Uygulama’yı indiren ve kullanan bireysel kullanıcı (\"Kullanıcı\") arasında akdedilmiştir. Uygulama; dijital gardırop oluşturma, kıyafet takibi, hava durumuna uygun kombin önerileri ve AI destekli stil danışmanlığı sunar.\n\n2. HİZMETİN KAPSAMI VE KULLANIM ŞARTLARI\n• Yaş Sınırı: Uygulamayı kullanmak için en az 13 yaşında olmanız gerekmektedir.\n• Kullanıcı Bilgileri: Kullanıcı, profil aşamasında sunduğu ad, cinsiyet, tarz ve renk tercihlerinin doğruluğundan sorumludur.\n• Tavsiye Niteliği: Yapay zeka tarafından sunulan stil puanları, satın alma önerileri ve çamaşır günü hatırlatmaları tamamen tavsiye niteliğindedir.\n• Hava Durumu Verileri: Hava durum bilgileri anlık konum bilgisine dayalı olarak sunulmaktadır. Olası sapmalardan Şirket sorumlu tutulamaz.\n\n3. FİKRİ MÜLKİYET VE İÇERİK HAKLARI\nYüklediğiniz kıyafet görsellerinin fikri mülkiyeti size aittir. FitCheck logosu, tasarımı, yazılım kodları ve algoritmaları tamamen FitCheck\'e aittir.\n\n4. GİZLİLİK VE VERİ GÜVENLİĞİ\nKıyafet görselleriniz ve kombin geçmişiniz öncelikli olarak cihazınızın yerel hafızasında saklanır. Konum verileri yalnızca anlık hava durumunu almak için kullanılır.\n\n5. SORUMLULUĞUN SINIRLANDIRILMASI\nFitCheck, hizmetin kesintisiz devam edeceğini garanti etmez. Cihaz değişikliği veya uygulama silinmesi sebebiyle veri kayıplarından sorumlu tutulamaz.\n\n6. İLETİŞİM\nSorularınız için bizimle Ayarlar sekmesindeki iletişim alanından veya destek@fitcheckapp.com adresinden iletişime geçebilirsiniz.\n\n--- 📜 SÖZLEŞMENİN SONU ---\nLütfen aşağıdaki butona basarak şartları onaylayınız.'**
  String get kullanimKosullariMetni;

  /// No description provided for @chatKarsilama.
  ///
  /// In tr, this message translates to:
  /// **'Selam! 👋 Bugün dışarısı {hava}. Senin tarzına uygun harika bir kombin hazırlayalım mı? ✨'**
  String chatKarsilama(Object hava);

  /// No description provided for @chatGorselGonderildi.
  ///
  /// In tr, this message translates to:
  /// **'Görsel gönderildi.'**
  String get chatGorselGonderildi;

  /// No description provided for @chatAsistanSohbeti.
  ///
  /// In tr, this message translates to:
  /// **'Asistan Sohbeti'**
  String get chatAsistanSohbeti;

  /// No description provided for @chatModHavaDuyarli.
  ///
  /// In tr, this message translates to:
  /// **'Hava durumuna göre akıllı stil önerileri'**
  String get chatModHavaDuyarli;

  /// No description provided for @chatStilistHazirliyor.
  ///
  /// In tr, this message translates to:
  /// **'Stilist kombin hazırlıyor...'**
  String get chatStilistHazirliyor;

  /// No description provided for @chatGorselEklendi.
  ///
  /// In tr, this message translates to:
  /// **'Görsel eklendi'**
  String get chatGorselEklendi;

  /// No description provided for @chatTekrarDene.
  ///
  /// In tr, this message translates to:
  /// **'Tekrar dene'**
  String get chatTekrarDene;

  /// No description provided for @chatKamera.
  ///
  /// In tr, this message translates to:
  /// **'Kamera'**
  String get chatKamera;

  /// No description provided for @chatGaleri.
  ///
  /// In tr, this message translates to:
  /// **'Galeriden görsel seç'**
  String get chatGaleri;

  /// No description provided for @chatMikrofon.
  ///
  /// In tr, this message translates to:
  /// **'Mikrofon'**
  String get chatMikrofon;

  /// No description provided for @chatGonder.
  ///
  /// In tr, this message translates to:
  /// **'Mesajı gönder'**
  String get chatGonder;

  /// No description provided for @chatOneriYagmur.
  ///
  /// In tr, this message translates to:
  /// **'🌧️ Yağmurlu Hava Kombini'**
  String get chatOneriYagmur;

  /// No description provided for @chatOneriOfis.
  ///
  /// In tr, this message translates to:
  /// **'💼 Ofis / Şık Tarz'**
  String get chatOneriOfis;

  /// No description provided for @chatOneriHaftaSonu.
  ///
  /// In tr, this message translates to:
  /// **'☕ Hafta Sonu Rahatlığı'**
  String get chatOneriHaftaSonu;

  /// No description provided for @chatOneriKirliSepeti.
  ///
  /// In tr, this message translates to:
  /// **'🧺 Kirli Sepeti Kontrolü'**
  String get chatOneriKirliSepeti;

  /// No description provided for @chatDinleniyor.
  ///
  /// In tr, this message translates to:
  /// **'Dinleniyor...'**
  String get chatDinleniyor;

  /// No description provided for @chatBirSeylerYazin.
  ///
  /// In tr, this message translates to:
  /// **'Asistana bir şeyler yazın...'**
  String get chatBirSeylerYazin;

  /// No description provided for @chatKombiniGiydim.
  ///
  /// In tr, this message translates to:
  /// **'Bu Kombini Giydim 👗'**
  String get chatKombiniGiydim;

  /// No description provided for @chatKombinIslendi.
  ///
  /// In tr, this message translates to:
  /// **'Kombin bugün giyilenlere işlendi! 📅'**
  String get chatKombinIslendi;

  /// No description provided for @chatGorselIncele.
  ///
  /// In tr, this message translates to:
  /// **'Bu görseli incele ve kombin öner.'**
  String get chatGorselIncele;

  /// No description provided for @profilAyarlariBaslik.
  ///
  /// In tr, this message translates to:
  /// **'PROFİL AYARLARI'**
  String get profilAyarlariBaslik;

  /// No description provided for @cinsiyetTercihiBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Cinsiyet Tercihi'**
  String get cinsiyetTercihiBaslik;

  /// No description provided for @stilAramaHint.
  ///
  /// In tr, this message translates to:
  /// **'Örn: \'Siyah ceketli spor şık kombin\', \'Yazlık elbise\'...'**
  String get stilAramaHint;

  /// No description provided for @stilFiltreTumu.
  ///
  /// In tr, this message translates to:
  /// **'Tüm Parçalar'**
  String get stilFiltreTumu;

  /// No description provided for @stilFiltreSadeceTemizler.
  ///
  /// In tr, this message translates to:
  /// **'Sadece Temizler'**
  String get stilFiltreSadeceTemizler;

  /// No description provided for @stilFiltreSadeceSepet.
  ///
  /// In tr, this message translates to:
  /// **'Sadece Yıkamadakiler'**
  String get stilFiltreSadeceSepet;

  /// No description provided for @profilFavoriKombinlerTitle.
  ///
  /// In tr, this message translates to:
  /// **'Favori Kombinlerim'**
  String get profilFavoriKombinlerTitle;

  /// No description provided for @profilFavoriKombinYok.
  ///
  /// In tr, this message translates to:
  /// **'Henüz favorilere eklenmiş bir kombin bulunmuyor.'**
  String get profilFavoriKombinYok;

  /// No description provided for @profilYikamaSepetimTitle.
  ///
  /// In tr, this message translates to:
  /// **'Çamaşır Sepetim'**
  String get profilYikamaSepetimTitle;

  /// No description provided for @profilYikamaSepetimBos.
  ///
  /// In tr, this message translates to:
  /// **'Yıkama sepetiniz boş, tüm kıyafetleriniz temiz! ✨'**
  String get profilYikamaSepetimBos;

  /// No description provided for @profilSepetiBosalt.
  ///
  /// In tr, this message translates to:
  /// **'Sepeti Boşalt'**
  String get profilSepetiBosalt;

  /// No description provided for @profilSepetiBosaltOnay.
  ///
  /// In tr, this message translates to:
  /// **'Tüm kıyafetler temizlendi olarak işaretlenecek. Onaylıyor musunuz?'**
  String get profilSepetiBosaltOnay;

  /// No description provided for @profilSepetiBosaltButon.
  ///
  /// In tr, this message translates to:
  /// **'Evet, Hepsini Yıka'**
  String get profilSepetiBosaltButon;

  /// No description provided for @profilTenRengi.
  ///
  /// In tr, this message translates to:
  /// **'Ten Rengi / Kompleksiyon'**
  String get profilTenRengi;

  /// No description provided for @profilTarzTercihi.
  ///
  /// In tr, this message translates to:
  /// **'Tarz Tercihi'**
  String get profilTarzTercihi;

  /// No description provided for @profilRenkPaleti.
  ///
  /// In tr, this message translates to:
  /// **'Sevdiğin Renk Paleti'**
  String get profilRenkPaleti;

  /// No description provided for @rehberGardiropEkleTitle.
  ///
  /// In tr, this message translates to:
  /// **'Fotoğraf Ekle'**
  String get rehberGardiropEkleTitle;

  /// No description provided for @rehberGardiropEkleDesc.
  ///
  /// In tr, this message translates to:
  /// **'Tekli veya toplu olarak kıyafetlerinin fotoğraflarını çekip yükleyebilirsin.'**
  String get rehberGardiropEkleDesc;

  /// No description provided for @rehberAiStilistTitle.
  ///
  /// In tr, this message translates to:
  /// **'AI Stilist Asistani'**
  String get rehberAiStilistTitle;

  /// No description provided for @rehberAiStilistDesc.
  ///
  /// In tr, this message translates to:
  /// **'Yapay zekaya istediğin kombini sorabilir veya tavsiye alabilirsin.'**
  String get rehberAiStilistDesc;

  /// No description provided for @rehberSesliTitle.
  ///
  /// In tr, this message translates to:
  /// **'Sesli Komut'**
  String get rehberSesliTitle;

  /// No description provided for @rehberSesliDesc.
  ///
  /// In tr, this message translates to:
  /// **'Konuşarak direkt olarak kombin önerisi isteyebilirsin.'**
  String get rehberSesliDesc;

  /// No description provided for @rehberAyarlarTitle.
  ///
  /// In tr, this message translates to:
  /// **'Ayarlar ve Profil'**
  String get rehberAyarlarTitle;

  /// No description provided for @rehberAyarlarDesc.
  ///
  /// In tr, this message translates to:
  /// **'Cinsiyet, stil tercihi ve ten rengi ayarlarını güncelleyebilirsin.'**
  String get rehberAyarlarDesc;

  /// No description provided for @rehberGardiropNavTitle.
  ///
  /// In tr, this message translates to:
  /// **'Gardırobum'**
  String get rehberGardiropNavTitle;

  /// No description provided for @rehberGardiropNavDesc.
  ///
  /// In tr, this message translates to:
  /// **'Tüm eklediğin kıyafetlerini kategorilerine göre burada görebilirsin.'**
  String get rehberGardiropNavDesc;

  /// No description provided for @rehberHaftalikNavTitle.
  ///
  /// In tr, this message translates to:
  /// **'Haftalık Planlayıcı'**
  String get rehberHaftalikNavTitle;

  /// No description provided for @rehberHaftalikNavDesc.
  ///
  /// In tr, this message translates to:
  /// **'7 günlük hava durumuna göre haftalık kombin planı oluşturabilirsin.'**
  String get rehberHaftalikNavDesc;

  /// No description provided for @rehberDolaptanNavTitle.
  ///
  /// In tr, this message translates to:
  /// **'Anlık Kombin Stilisti'**
  String get rehberDolaptanNavTitle;

  /// No description provided for @rehberDolaptanNavDesc.
  ///
  /// In tr, this message translates to:
  /// **'Gideceğin ortama özel anlık AI kombinleri oluşturabilirsin.'**
  String get rehberDolaptanNavDesc;

  /// No description provided for @rehberKendiNavTitle.
  ///
  /// In tr, this message translates to:
  /// **'Kendi Kombinim'**
  String get rehberKendiNavTitle;

  /// No description provided for @rehberKendiNavDesc.
  ///
  /// In tr, this message translates to:
  /// **'Parçaları kendin eşleştirip kendi kombinlerini tasarlayabilirsin.'**
  String get rehberKendiNavDesc;

  /// No description provided for @rehberProfilNavTitle.
  ///
  /// In tr, this message translates to:
  /// **'Profil ve Analiz'**
  String get rehberProfilNavTitle;

  /// No description provided for @rehberProfilNavDesc.
  ///
  /// In tr, this message translates to:
  /// **'Gardırobunun maliyet analizini ve çamaşır sepetini takip edebilirsin.'**
  String get rehberProfilNavDesc;

  /// No description provided for @simdilikAtla.
  ///
  /// In tr, this message translates to:
  /// **'Şimdilik Atla'**
  String get simdilikAtla;

  /// No description provided for @uygulamaIzinleri.
  ///
  /// In tr, this message translates to:
  /// **'Uygulama İzinleri'**
  String get uygulamaIzinleri;

  /// No description provided for @izinEkraniAciklama.
  ///
  /// In tr, this message translates to:
  /// **'FitCheck\'in size kişiselleştirilmiş kombinler sunabilmesi ve çamaşır/hava durumu hatırlatmaları gönderebilmesi için bu izinlere ihtiyacı var.'**
  String get izinEkraniAciklama;

  /// No description provided for @konumIzniAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Anlık hava durumuna göre kombin önerileri için'**
  String get konumIzniAciklama;

  /// No description provided for @kameraIzniAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Kıyafet fotoğraflarınızı gardırobunuza eklemek için'**
  String get kameraIzniAciklama;

  /// No description provided for @bildirimIzni.
  ///
  /// In tr, this message translates to:
  /// **'Bildirim İzni'**
  String get bildirimIzni;

  /// No description provided for @bildirimIzniAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Çamaşır günü ve hava durumu uyarıları için'**
  String get bildirimIzniAciklama;

  /// No description provided for @izinleriVerVeBasla.
  ///
  /// In tr, this message translates to:
  /// **'İzinleri Ver ve Başla'**
  String get izinleriVerVeBasla;

  /// No description provided for @dahaSonraAyarla.
  ///
  /// In tr, this message translates to:
  /// **'Daha Sonra Ayarla'**
  String get dahaSonraAyarla;

  /// No description provided for @gunlukHakBittiBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Günlük Hakkın Bitti!'**
  String get gunlukHakBittiBaslik;

  /// No description provided for @dahaSonra.
  ///
  /// In tr, this message translates to:
  /// **'Daha Sonra'**
  String get dahaSonra;

  /// No description provided for @reklamIzleHakKazan.
  ///
  /// In tr, this message translates to:
  /// **'Reklam İzle (+2 Hak)'**
  String get reklamIzleHakKazan;

  /// No description provided for @tebriklerHakEklendi.
  ///
  /// In tr, this message translates to:
  /// **'Tebrikler! +2 İşlem hakkı tanımlandı. ✨'**
  String get tebriklerHakEklendi;

  /// No description provided for @kombinIsaretlemeKaldirildi.
  ///
  /// In tr, this message translates to:
  /// **'\"{kombinAdi}\" kombini işaretlemesi kaldırıldı.'**
  String kombinIsaretlemeKaldirildi(String kombinAdi);

  /// No description provided for @kombinGiydimIsaretlendi.
  ///
  /// In tr, this message translates to:
  /// **'\"{kombinAdi}\" kombini bugün giyildi olarak işaretlendi! 👕✨'**
  String kombinGiydimIsaretlendi(String kombinAdi);

  /// No description provided for @kiyafetDetayi.
  ///
  /// In tr, this message translates to:
  /// **'Kıyafet Detayı'**
  String get kiyafetDetayi;

  /// No description provided for @parcaDetayiBaslik.
  ///
  /// In tr, this message translates to:
  /// **'PARÇA DETAYI'**
  String get parcaDetayiBaslik;

  /// No description provided for @farkliParcaSec.
  ///
  /// In tr, this message translates to:
  /// **'Farklı Parça Seç'**
  String get farkliParcaSec;

  /// No description provided for @farkliUstSec.
  ///
  /// In tr, this message translates to:
  /// **'Farklı Üst Giyim Seç 👕'**
  String get farkliUstSec;

  /// No description provided for @farkliAltSec.
  ///
  /// In tr, this message translates to:
  /// **'Farklı Alt Giyim Seç 👖'**
  String get farkliAltSec;

  /// No description provided for @farkliAyakkabiSec.
  ///
  /// In tr, this message translates to:
  /// **'Farklı Ayakkabı Seç 👟'**
  String get farkliAyakkabiSec;

  /// No description provided for @farkliDisSec.
  ///
  /// In tr, this message translates to:
  /// **'Farklı Dış Giyim Seç 🧥'**
  String get farkliDisSec;

  /// No description provided for @baskaTemizKiyafetYok.
  ///
  /// In tr, this message translates to:
  /// **'Bu kategoride değiştirebileceğiniz\nbaşka temiz kıyafetiniz yok.'**
  String get baskaTemizKiyafetYok;

  /// No description provided for @planiYenile.
  ///
  /// In tr, this message translates to:
  /// **'Planı Yenile'**
  String get planiYenile;

  /// No description provided for @havaEtiketi.
  ///
  /// In tr, this message translates to:
  /// **'HAVA'**
  String get havaEtiketi;

  /// No description provided for @yukleniyor.
  ///
  /// In tr, this message translates to:
  /// **'Yükleniyor...'**
  String get yukleniyor;

  /// No description provided for @temizle.
  ///
  /// In tr, this message translates to:
  /// **'Temizle'**
  String get temizle;

  /// No description provided for @yenidenDegerlendiriliyor.
  ///
  /// In tr, this message translates to:
  /// **'Yeniden değerlendiriliyor...'**
  String get yenidenDegerlendiriliyor;

  /// No description provided for @kombinParcalariBaslik.
  ///
  /// In tr, this message translates to:
  /// **'KOMBİN PARÇALARI'**
  String get kombinParcalariBaslik;

  /// No description provided for @parcalariKaydirIpucu.
  ///
  /// In tr, this message translates to:
  /// **'Kombindeki diğer parçalar için sağa/sola kaydırın 👈👉'**
  String get parcalariKaydirIpucu;

  /// No description provided for @zorunluParcaYorumu.
  ///
  /// In tr, this message translates to:
  /// **'✨ {parcaAdi} parçasını merkeze alarak bu kombini hazırladım!'**
  String zorunluParcaYorumu(Object parcaAdi);

  /// No description provided for @sihirliDokunus.
  ///
  /// In tr, this message translates to:
  /// **'Sihirli Dokunuş'**
  String get sihirliDokunus;

  /// No description provided for @dolabiKaristirEksikUyari.
  ///
  /// In tr, this message translates to:
  /// **'Dolabı karıştırabilmek için en az 1 temiz Üst, Alt ve Ayakkabı bulunmalı! 👕👖👟'**
  String get dolabiKaristirEksikUyari;

  /// No description provided for @zarlarAtildiYorumu.
  ///
  /// In tr, this message translates to:
  /// **'🎲 Zarlar atıldı! Yepyeni ve şaşırtıcı bir kombin keşfettin.'**
  String get zarlarAtildiYorumu;

  /// No description provided for @rastgeleKombinTuru.
  ///
  /// In tr, this message translates to:
  /// **'Rastgele'**
  String get rastgeleKombinTuru;

  /// No description provided for @temizAlternatifYok.
  ///
  /// In tr, this message translates to:
  /// **'Bu kategori için temiz başka alternatif yok! 🧺'**
  String get temizAlternatifYok;

  /// No description provided for @kisiselDokunus.
  ///
  /// In tr, this message translates to:
  /// **'Kişisel Dokunus'**
  String get kisiselDokunus;

  /// No description provided for @aiYeniParcaAnalizEdiyor.
  ///
  /// In tr, this message translates to:
  /// **'Yapay zeka yeni parçayı analiz ediyor... ✨'**
  String get aiYeniParcaAnalizEdiyor;

  /// No description provided for @parcaDegisimVarsayilanYorum.
  ///
  /// In tr, this message translates to:
  /// **'✨ Parçaları değiştirerek harika bir uyum yakaladın!'**
  String get parcaDegisimVarsayilanYorum;

  /// No description provided for @parcaDegisimHataYorum.
  ///
  /// In tr, this message translates to:
  /// **'✨ Parçaları değiştirerek kombini tamamen kendi tarzına uyarladın!'**
  String get parcaDegisimHataYorum;

  /// No description provided for @bilgileriDuzenleBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Bilgileri Düzenle'**
  String get bilgileriDuzenleBaslik;

  /// No description provided for @kiyafetAdiEtiketi.
  ///
  /// In tr, this message translates to:
  /// **'Kıyafet Adı'**
  String get kiyafetAdiEtiketi;

  /// No description provided for @renkEtiketi.
  ///
  /// In tr, this message translates to:
  /// **'Renk'**
  String get renkEtiketi;

  /// No description provided for @kaydet.
  ///
  /// In tr, this message translates to:
  /// **'Kaydet'**
  String get kaydet;

  /// No description provided for @yenidenZarAt.
  ///
  /// In tr, this message translates to:
  /// **'Yeniden Zar At'**
  String get yenidenZarAt;

  /// No description provided for @zarAtKaristir.
  ///
  /// In tr, this message translates to:
  /// **'Zar At (Karıştır)'**
  String get zarAtKaristir;

  /// No description provided for @zarPopupBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Sihirli Zarları Salla!'**
  String get zarPopupBaslik;

  /// No description provided for @zarPopupAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Telefonunu fiziksel olarak sallayarak veya aşağıdaki butona basarak zarları atabilir, dolabından rastgele kombinler oluşturabilirsin.'**
  String get zarPopupAciklama;

  /// No description provided for @zarlariAt.
  ///
  /// In tr, this message translates to:
  /// **'Zarları At'**
  String get zarlariAt;

  /// No description provided for @zarSalla.
  ///
  /// In tr, this message translates to:
  /// **'Zar Salla'**
  String get zarSalla;

  /// No description provided for @degistirmekIcinKaydirIpucu.
  ///
  /// In tr, this message translates to:
  /// **'Değiştirmek için parçaları sağa/sola kaydırın veya dokunun 👈👉'**
  String get degistirmekIcinKaydirIpucu;

  /// No description provided for @favorilerdeEtiketi.
  ///
  /// In tr, this message translates to:
  /// **'Favorilerde'**
  String get favorilerdeEtiketi;

  /// No description provided for @bugunGiydildiEtiketi.
  ///
  /// In tr, this message translates to:
  /// **'Bugün Giyildi ✨'**
  String get bugunGiydildiEtiketi;

  /// No description provided for @varsayilanKendiAnalizYorumu.
  ///
  /// In tr, this message translates to:
  /// **'Harika bir seçim! Parçalar renk tonlarıyla mükemmel bir denge oluşturmuş.'**
  String get varsayilanKendiAnalizYorumu;

  /// No description provided for @kendiTasarimimBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Kendi Tasarımım'**
  String get kendiTasarimimBaslik;

  /// No description provided for @parcaSecModalBaslik.
  ///
  /// In tr, this message translates to:
  /// **'{kategori} Seç'**
  String parcaSecModalBaslik(Object kategori);

  /// No description provided for @kendiKombininiTasarlaTitle.
  ///
  /// In tr, this message translates to:
  /// **'Kendi Kombinini Tasarla'**
  String get kendiKombininiTasarlaTitle;

  /// No description provided for @secimleriSifirla.
  ///
  /// In tr, this message translates to:
  /// **'Seçimleri Sıfırla'**
  String get secimleriSifirla;

  /// No description provided for @kombinHazirAiTavsiyesi.
  ///
  /// In tr, this message translates to:
  /// **'Kombin harika görünüyor! Yapay zeka ile analiz edip kaydet.'**
  String get kombinHazirAiTavsiyesi;

  /// No description provided for @kombinBaslaIpucu.
  ///
  /// In tr, this message translates to:
  /// **'Bugün ne giymek istersin? Parçaları seçerek başla.'**
  String get kombinBaslaIpucu;

  /// No description provided for @ustAltModu.
  ///
  /// In tr, this message translates to:
  /// **'Üst + Alt'**
  String get ustAltModu;

  /// No description provided for @tekParcaElbiseModu.
  ///
  /// In tr, this message translates to:
  /// **'Tek Parça (Elbise)'**
  String get tekParcaElbiseModu;

  /// No description provided for @tekParcaElbise.
  ///
  /// In tr, this message translates to:
  /// **'Tek Parça / Elbise'**
  String get tekParcaElbise;

  /// No description provided for @aksesuarOpsiyonel.
  ///
  /// In tr, this message translates to:
  /// **'Aksesuar (Opsiyonel)'**
  String get aksesuarOpsiyonel;

  /// No description provided for @stilistAnaliziBaslik.
  ///
  /// In tr, this message translates to:
  /// **'STİLİST ANALİZİ'**
  String get stilistAnaliziBaslik;

  /// No description provided for @stilistDegerlendiriyor.
  ///
  /// In tr, this message translates to:
  /// **'Stilist Değerlendiriyor...'**
  String get stilistDegerlendiriyor;

  /// No description provided for @aiIleAnalizEtKaydet.
  ///
  /// In tr, this message translates to:
  /// **'AI İle Analiz Et & Kaydet'**
  String get aiIleAnalizEtKaydet;

  /// No description provided for @bilinmiyor.
  ///
  /// In tr, this message translates to:
  /// **'Bilinmiyor'**
  String get bilinmiyor;

  /// No description provided for @karmasikSiklik.
  ///
  /// In tr, this message translates to:
  /// **'Karmaşık Şıklık'**
  String get karmasikSiklik;

  /// No description provided for @gecmisiTemizleTitle.
  ///
  /// In tr, this message translates to:
  /// **'Geçmişi Temizle'**
  String get gecmisiTemizleTitle;

  /// No description provided for @gecmisiTemizleOnayIcerik.
  ///
  /// In tr, this message translates to:
  /// **'Tüm giyilenler geçmişini silmek istediğinize emin misiniz? Bu işlem geri alınamaz.'**
  String get gecmisiTemizleOnayIcerik;

  /// No description provided for @gecmisBasariylaTemizlendi.
  ///
  /// In tr, this message translates to:
  /// **'Geçmiş başarıyla temizlendi 🗑️'**
  String get gecmisBasariylaTemizlendi;

  /// No description provided for @kayitGecmistenSilindi.
  ///
  /// In tr, this message translates to:
  /// **'Kayıt geçmişten silindi.'**
  String get kayitGecmistenSilindi;

  /// No description provided for @kombin.
  ///
  /// In tr, this message translates to:
  /// **'Kombin'**
  String get kombin;

  /// No description provided for @kombinDetayiUst.
  ///
  /// In tr, this message translates to:
  /// **'KOMBİN DETAYI'**
  String get kombinDetayiUst;

  /// No description provided for @giyilenParcalarUst.
  ///
  /// In tr, this message translates to:
  /// **'GİYİLEN PARÇALAR'**
  String get giyilenParcalarUst;

  /// No description provided for @detayBulunamadi.
  ///
  /// In tr, this message translates to:
  /// **'Detay bulunamadı.'**
  String get detayBulunamadi;

  /// No description provided for @henuzFavoriEklemediniz.
  ///
  /// In tr, this message translates to:
  /// **'Henüz favori kombin eklemediniz.'**
  String get henuzFavoriEklemediniz;

  /// No description provided for @camasirSepetiTitle.
  ///
  /// In tr, this message translates to:
  /// **'Çamaşır Sepeti'**
  String get camasirSepetiTitle;

  /// No description provided for @sepetBosTumKiyafetlerTemiz.
  ///
  /// In tr, this message translates to:
  /// **'Sepet tamamen boş, tüm kıyafetler temiz!'**
  String get sepetBosTumKiyafetlerTemiz;

  /// No description provided for @tumKiyafetlerTemizlendi.
  ///
  /// In tr, this message translates to:
  /// **'Tüm kıyafetler temizlendi ve dolaba eklendi 🧺✨'**
  String get tumKiyafetlerTemizlendi;

  /// No description provided for @tumunuTemizIsaretle.
  ///
  /// In tr, this message translates to:
  /// **'Tümünü Temiz İşaretle'**
  String get tumunuTemizIsaretle;

  /// No description provided for @profilVeAnalizTitle.
  ///
  /// In tr, this message translates to:
  /// **'Profil ve Analiz'**
  String get profilVeAnalizTitle;

  /// No description provided for @harikaGidiyorsun.
  ///
  /// In tr, this message translates to:
  /// **'Harika Gidiyorsun!'**
  String get harikaGidiyorsun;

  /// No description provided for @gundurSeridesin.
  ///
  /// In tr, this message translates to:
  /// **'{gun} Gündür Seridesin'**
  String gundurSeridesin(Object gun);

  /// No description provided for @tumuTemiz.
  ///
  /// In tr, this message translates to:
  /// **'Tümü Temiz'**
  String get tumuTemiz;

  /// No description provided for @kirliParcaSayisi.
  ///
  /// In tr, this message translates to:
  /// **'{sayi} Kirli Parça'**
  String kirliParcaSayisi(Object sayi);

  /// No description provided for @stilKimligin.
  ///
  /// In tr, this message translates to:
  /// **'Stil Kimliğin'**
  String get stilKimligin;

  /// No description provided for @dolapVerimliligi.
  ///
  /// In tr, this message translates to:
  /// **'Dolap Verimliliği'**
  String get dolapVerimliligi;

  /// No description provided for @renkPaletin.
  ///
  /// In tr, this message translates to:
  /// **'Renk Paletin'**
  String get renkPaletin;

  /// No description provided for @dolabinKahramanlari.
  ///
  /// In tr, this message translates to:
  /// **'Dolabın Kahramanları'**
  String get dolabinKahramanlari;

  /// No description provided for @derinlerdeUnutulanlar.
  ///
  /// In tr, this message translates to:
  /// **'Derinlerde Unutulanlar'**
  String get derinlerdeUnutulanlar;

  /// No description provided for @sonGiyilenler.
  ///
  /// In tr, this message translates to:
  /// **'Son Giyilenler'**
  String get sonGiyilenler;

  /// No description provided for @tumunuTemizle.
  ///
  /// In tr, this message translates to:
  /// **'Tümünü Temizle'**
  String get tumunuTemizle;

  /// No description provided for @henuzGecmisKaydiYok.
  ///
  /// In tr, this message translates to:
  /// **'Henüz geçmiş kaydı yok.'**
  String get henuzGecmisKaydiYok;

  /// No description provided for @kezGiyildi.
  ///
  /// In tr, this message translates to:
  /// **'{sayi} kez giyildi'**
  String kezGiyildi(Object sayi);

  /// No description provided for @ayarlarTitle.
  ///
  /// In tr, this message translates to:
  /// **'Ayarlar'**
  String get ayarlarTitle;

  /// No description provided for @hesapVeGuvenlikMerkeziUst.
  ///
  /// In tr, this message translates to:
  /// **'HESAP VE GÜVENLİK MERKEZİ'**
  String get hesapVeGuvenlikMerkeziUst;

  /// No description provided for @kullaniciHesabi.
  ///
  /// In tr, this message translates to:
  /// **'Kullanıcı Hesabı'**
  String get kullaniciHesabi;

  /// No description provided for @misafirKullanici.
  ///
  /// In tr, this message translates to:
  /// **'Misafir Kullanıcı'**
  String get misafirKullanici;

  /// No description provided for @epostaDogrulanmis.
  ///
  /// In tr, this message translates to:
  /// **'E-posta doğrulanmış'**
  String get epostaDogrulanmis;

  /// No description provided for @esitlemekIcinGirisYapin.
  ///
  /// In tr, this message translates to:
  /// **'Tüm cihazlarda eşitlemek için giriş yapın.'**
  String get esitlemekIcinGirisYapin;

  /// No description provided for @cikisYapTitle.
  ///
  /// In tr, this message translates to:
  /// **'Çıkış Yap'**
  String get cikisYapTitle;

  /// No description provided for @cikisYapOnayIcerik.
  ///
  /// In tr, this message translates to:
  /// **'Hesabınızdan çıkış yapmak istediğinize emin misiniz?'**
  String get cikisYapOnayIcerik;

  /// No description provided for @bagliHesaplarUst.
  ///
  /// In tr, this message translates to:
  /// **'BAĞLI HESAPLAR'**
  String get bagliHesaplarUst;

  /// No description provided for @googleHesabiBagli.
  ///
  /// In tr, this message translates to:
  /// **'Google Hesabı Bağlı'**
  String get googleHesabiBagli;

  /// No description provided for @googleHesabiniBagla.
  ///
  /// In tr, this message translates to:
  /// **'Google Hesabını Bağla'**
  String get googleHesabiniBagla;

  /// No description provided for @googleHesabiBaglandi.
  ///
  /// In tr, this message translates to:
  /// **'Google hesabınız başarıyla bağlandı! 🔗'**
  String get googleHesabiBaglandi;

  /// No description provided for @googleHesabiBaglantisiKesildi.
  ///
  /// In tr, this message translates to:
  /// **'Google hesabı bağlantısı kesildi.'**
  String get googleHesabiBaglantisiKesildi;

  /// No description provided for @sifreVeGuvenlik.
  ///
  /// In tr, this message translates to:
  /// **'Şifre ve Güvenlik'**
  String get sifreVeGuvenlik;

  /// No description provided for @sifreYenilemeBaglantisiIste.
  ///
  /// In tr, this message translates to:
  /// **'Şifre yenileme bağlantısı iste'**
  String get sifreYenilemeBaglantisiIste;

  /// No description provided for @sifremiUnuttum.
  ///
  /// In tr, this message translates to:
  /// **'Şifremi unuttum'**
  String get sifremiUnuttum;

  /// No description provided for @sifreDegistirTitle.
  ///
  /// In tr, this message translates to:
  /// **'Şifre Değiştir'**
  String get sifreDegistirTitle;

  /// No description provided for @sifreSifirlamaAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Hesabınıza bağlı e-posta adresine şifre sıfırlama bağlantısı gönderilecektir:'**
  String get sifreSifirlamaAciklama;

  /// No description provided for @epostaAdresi.
  ///
  /// In tr, this message translates to:
  /// **'E-posta Adresi'**
  String get epostaAdresi;

  /// No description provided for @gecerliBirEpostaGiriniz.
  ///
  /// In tr, this message translates to:
  /// **'Geçerli bir e-posta adresi giriniz'**
  String get gecerliBirEpostaGiriniz;

  /// No description provided for @sifreEpostasiGonderildi.
  ///
  /// In tr, this message translates to:
  /// **'{eposta} adresine şifre yenileme e-postası gönderildi! ✉️'**
  String sifreEpostasiGonderildi(Object eposta);

  /// No description provided for @baglantiGonder.
  ///
  /// In tr, this message translates to:
  /// **'Bağlantı Gönder'**
  String get baglantiGonder;

  /// No description provided for @hesabiKaliciSilTitle.
  ///
  /// In tr, this message translates to:
  /// **'Hesabı Kalıcı Olarak Sil'**
  String get hesabiKaliciSilTitle;

  /// No description provided for @hesabiSilGeriAlinamazUyari.
  ///
  /// In tr, this message translates to:
  /// **'Bu işlem geri alınamaz. Gardırop verileriniz ve profiliniz kalıcı olarak silinecektir.'**
  String get hesabiSilGeriAlinamazUyari;

  /// No description provided for @hesabiSilOnayKoduMetni.
  ///
  /// In tr, this message translates to:
  /// **'Onaylamak için aşağıya \"fitcheck\" yazın:'**
  String get hesabiSilOnayKoduMetni;

  /// No description provided for @vazgec.
  ///
  /// In tr, this message translates to:
  /// **'Vazgeç'**
  String get vazgec;

  /// No description provided for @hesabimiSil.
  ///
  /// In tr, this message translates to:
  /// **'Hesabımı Sil'**
  String get hesabimiSil;

  /// No description provided for @hesabinizSilindi.
  ///
  /// In tr, this message translates to:
  /// **'Hesabınız ve ilişkili veriler silindi.'**
  String get hesabinizSilindi;

  /// No description provided for @kisiselStilVeProfilUst.
  ///
  /// In tr, this message translates to:
  /// **'KİŞİSEL STİL VE PROFİL'**
  String get kisiselStilVeProfilUst;

  /// No description provided for @stilVeTarzTercihleri.
  ///
  /// In tr, this message translates to:
  /// **'Stil & Tarz Tercihleri'**
  String get stilVeTarzTercihleri;

  /// No description provided for @secili.
  ///
  /// In tr, this message translates to:
  /// **'Seçili'**
  String get secili;

  /// No description provided for @tenRengiTercihinizUst.
  ///
  /// In tr, this message translates to:
  /// **'TEN RENGİ TERCİHİNİZ'**
  String get tenRengiTercihinizUst;

  /// No description provided for @yapayZekaVeStilHassasiyetiUst.
  ///
  /// In tr, this message translates to:
  /// **'YAPAY ZEKÂ VE STİL HASSASİYETİ'**
  String get yapayZekaVeStilHassasiyetiUst;

  /// No description provided for @stilistKisiligiVeYantitTarziUst.
  ///
  /// In tr, this message translates to:
  /// **'STİLİST KİŞİLİĞİ VE YANIT TARZI'**
  String get stilistKisiligiVeYantitTarziUst;

  /// No description provided for @aiKisilikSamimiBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Samimi / Arkadaş Canlısı'**
  String get aiKisilikSamimiBaslik;

  /// No description provided for @aiKisilikSamimiAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Sıcak, motive edici ve modayı eğlenceli kılan sohbet dili'**
  String get aiKisilikSamimiAciklama;

  /// No description provided for @aiKisilikElestirmenBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Profesyonel Moda Eleştirmeni'**
  String get aiKisilikElestirmenBaslik;

  /// No description provided for @aiKisilikElestirmenAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Renk teorisi ve vücut tipine odaklanan teknik tavsiyeler'**
  String get aiKisilikElestirmenAciklama;

  /// No description provided for @aiKisilikMinimalistBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Minimalist & Kısa'**
  String get aiKisilikMinimalistBaslik;

  /// No description provided for @aiKisilikMinimalistAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Doğrudan sadede gelen, net ve vakit kaybettirmeyen öneriler'**
  String get aiKisilikMinimalistAciklama;

  /// No description provided for @sikiRenkTeorisiUyumModu.
  ///
  /// In tr, this message translates to:
  /// **'Sıkı Renk Teorisi Uyum Modu'**
  String get sikiRenkTeorisiUyumModu;

  /// No description provided for @sikiRenkTeorisiAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Açıkken yapay zeka sadece klasik renk kurallarına uyar'**
  String get sikiRenkTeorisiAciklama;

  /// No description provided for @bildirimlerVeHatirlaticiUst.
  ///
  /// In tr, this message translates to:
  /// **'BİLDİRİMLER VE HATIRLATICI'**
  String get bildirimlerVeHatirlaticiUst;

  /// No description provided for @sabahKombinOnerisi.
  ///
  /// In tr, this message translates to:
  /// **'Sabah Kombin Önerisi'**
  String get sabahKombinOnerisi;

  /// No description provided for @herSabahBildirimAl.
  ///
  /// In tr, this message translates to:
  /// **'Her sabah {saat} vaktinde bildirim al'**
  String herSabahBildirimAl(Object saat);

  /// No description provided for @bildirimSaatiniOzellestir.
  ///
  /// In tr, this message translates to:
  /// **'Bildirim Saatini Özelleştir'**
  String get bildirimSaatiniOzellestir;

  /// No description provided for @gunlukKombinBildirimSaati.
  ///
  /// In tr, this message translates to:
  /// **'Günlük kombin bildirim saati'**
  String get gunlukKombinBildirimSaati;

  /// No description provided for @sabahBildirimSaatiSec.
  ///
  /// In tr, this message translates to:
  /// **'Sabah bildirim saatini seç'**
  String get sabahBildirimSaatiSec;

  /// No description provided for @saatKaydedildiAksama.
  ///
  /// In tr, this message translates to:
  /// **'Saat kaydedildi ancak bildirim servisine ulaşılamadı.'**
  String get saatKaydedildiAksama;

  /// No description provided for @sabahBildirimiAyarlandi.
  ///
  /// In tr, this message translates to:
  /// **'Sabah bildirimi {saat} olarak ayarlandı. ⏰'**
  String sabahBildirimiAyarlandi(Object saat);

  /// No description provided for @bildirimIzinGerekliUyari.
  ///
  /// In tr, this message translates to:
  /// **'Bildirimleri açmak için cihaz ayarlarından izin vermeniz gerekiyor.'**
  String get bildirimIzinGerekliUyari;

  /// No description provided for @camasirSepetiUyarilari.
  ///
  /// In tr, this message translates to:
  /// **'Çamaşır Sepeti Uyarıları'**
  String get camasirSepetiUyarilari;

  /// No description provided for @camasirSepetiUyarilariAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Kirlenen kıyafetlerin için akıllı hatırlatma al'**
  String get camasirSepetiUyarilariAciklama;

  /// No description provided for @haftalikStilRaporu.
  ///
  /// In tr, this message translates to:
  /// **'Haftalık Stil Raporu'**
  String get haftalikStilRaporu;

  /// No description provided for @haftalikStilRaporuAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Her Pazar akşamı dolap kullanım özeti al'**
  String get haftalikStilRaporuAciklama;

  /// No description provided for @gorunumVeBolgeUst.
  ///
  /// In tr, this message translates to:
  /// **'GÖRÜNÜM VE BÖLGE'**
  String get gorunumVeBolgeUst;

  /// No description provided for @lokasyonVeBirimlerUst.
  ///
  /// In tr, this message translates to:
  /// **'LOKASYON VE BİRİMLER'**
  String get lokasyonVeBirimlerUst;

  /// No description provided for @sicaklikBirimi.
  ///
  /// In tr, this message translates to:
  /// **'Sıcaklık Birimi'**
  String get sicaklikBirimi;

  /// No description provided for @varsayilanSehirBolge.
  ///
  /// In tr, this message translates to:
  /// **'Varsayılan Şehir / Bölge'**
  String get varsayilanSehirBolge;

  /// No description provided for @sehirOrnekHint.
  ///
  /// In tr, this message translates to:
  /// **'Örn: İstanbul, Bursa, London'**
  String get sehirOrnekHint;

  /// No description provided for @gpsKullan.
  ///
  /// In tr, this message translates to:
  /// **'GPS Kullan'**
  String get gpsKullan;

  /// No description provided for @veriVeDepolamaYonetimiUst.
  ///
  /// In tr, this message translates to:
  /// **'VERİ VE DEPOLAMA YÖNETİMİ'**
  String get veriVeDepolamaYonetimiUst;

  /// No description provided for @gorselOnbelleginiTemizle.
  ///
  /// In tr, this message translates to:
  /// **'Görsel Önbelleğini Temizle'**
  String get gorselOnbelleginiTemizle;

  /// No description provided for @geciciFotografHafizasiAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Geçici fotoğraf hafızasını boşaltır'**
  String get geciciFotografHafizasiAciklama;

  /// No description provided for @onbellekTemizlendiBasari.
  ///
  /// In tr, this message translates to:
  /// **'Görsel önbelleği ve geçici dosyalar temizlendi! ✨'**
  String get onbellekTemizlendiBasari;

  /// No description provided for @onbellekTemizlerkenHata.
  ///
  /// In tr, this message translates to:
  /// **'Önbellek temizlenirken bir aksama oluştu.'**
  String get onbellekTemizlerkenHata;

  /// No description provided for @gardirobuDisaAktarYedekle.
  ///
  /// In tr, this message translates to:
  /// **'Gardırobu Dışa Aktar (Yedekle)'**
  String get gardirobuDisaAktarYedekle;

  /// No description provided for @tumKiyafetVeKombinJsonAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Tüm kıyafet ve kombin verilerini JSON al'**
  String get tumKiyafetVeKombinJsonAciklama;

  /// No description provided for @disaAktarilacakVeriYok.
  ///
  /// In tr, this message translates to:
  /// **'Dışa aktarılacak gardırop verisi bulunamadı. 📭'**
  String get disaAktarilacakVeriYok;

  /// No description provided for @gardiropVerisiKopyalandi.
  ///
  /// In tr, this message translates to:
  /// **'Tüm gardırop verileriniz JSON formatında panoya kopyalandı! 📋'**
  String get gardiropVerisiKopyalandi;

  /// No description provided for @destekVeDegerlendirmeUst.
  ///
  /// In tr, this message translates to:
  /// **'DESTEK VE DEĞERLENDİRME'**
  String get destekVeDegerlendirmeUst;

  /// No description provided for @uygulamayiDegerlendirin.
  ///
  /// In tr, this message translates to:
  /// **'Uygulamayı Değerlendirin'**
  String get uygulamayiDegerlendirin;

  /// No description provided for @googlePlay5YildizDestek.
  ///
  /// In tr, this message translates to:
  /// **'Google Play\'de 5 yıldız vererek destek olun ⭐'**
  String get googlePlay5YildizDestek;

  /// No description provided for @googlePlayAcilamadi.
  ///
  /// In tr, this message translates to:
  /// **'Google Play açılamadı.'**
  String get googlePlayAcilamadi;

  /// No description provided for @geriBildirimVeDestek.
  ///
  /// In tr, this message translates to:
  /// **'Geri Bildirim & Destek'**
  String get geriBildirimVeDestek;

  /// No description provided for @hataBildirVeyaOneri.
  ///
  /// In tr, this message translates to:
  /// **'Hata bildir veya yeni özellik öner'**
  String get hataBildirVeyaOneri;

  /// No description provided for @islemTamamlanamadi.
  ///
  /// In tr, this message translates to:
  /// **'İşlem tamamlanamadı. Lütfen tekrar deneyin.'**
  String get islemTamamlanamadi;

  /// No description provided for @epostaUygulamasiAcilamadi.
  ///
  /// In tr, this message translates to:
  /// **'E-posta uygulaması açılamadı. Lütfen ayberkzcn9@gmail.com adresine yazın.'**
  String get epostaUygulamasiAcilamadi;

  /// No description provided for @gizlilikPolitikasiTitle.
  ///
  /// In tr, this message translates to:
  /// **'Gizlilik Politikası'**
  String get gizlilikPolitikasiTitle;

  /// No description provided for @veriKullanimiVeGizlilikHaklari.
  ///
  /// In tr, this message translates to:
  /// **'Veri kullanımı ve gizlilik haklarınızı görün'**
  String get veriKullanimiVeGizlilikHaklari;

  /// No description provided for @sonGuncellemeTarihi.
  ///
  /// In tr, this message translates to:
  /// **'Son Güncelleme: 27 Ağustos 2026'**
  String get sonGuncellemeTarihi;

  /// No description provided for @gizlilikMadde1Baslik.
  ///
  /// In tr, this message translates to:
  /// **'1. Veri Toplama ve Kullanımı'**
  String get gizlilikMadde1Baslik;

  /// No description provided for @gizlilikMadde1Icerik.
  ///
  /// In tr, this message translates to:
  /// **'FitCheck uygulaması, kişisel gardırop yönetiminizi ve kombin önerilerinizi optimize etmek için çalışır. Uygulamaya eklediğiniz kıyafet fotoğrafları, tarz ve cinsiyet tercihleriniz cihazınızda yerel olarak saklanır.'**
  String get gizlilikMadde1Icerik;

  /// No description provided for @gizlilikMadde2Baslik.
  ///
  /// In tr, this message translates to:
  /// **'2. Konum İzinleri'**
  String get gizlilikMadde2Baslik;

  /// No description provided for @gizlilikMadde2Icerik.
  ///
  /// In tr, this message translates to:
  /// **'Hava durumuna uygun günlük kombin tavsiyeleri sunabilmek adına anlık konum bilginiz Open-Meteo servisleri ile anonim olarak işlenir. Konum verileriniz sunucularımızda saklanmaz veya üçüncü taraflarla paylaşılmaz.'**
  String get gizlilikMadde2Icerik;

  /// No description provided for @gizlilikMadde3Baslik.
  ///
  /// In tr, this message translates to:
  /// **'3. Sesli Asistan ve Mikrofon'**
  String get gizlilikMadde3Baslik;

  /// No description provided for @gizlilikMadde3Icerik.
  ///
  /// In tr, this message translates to:
  /// **'Sesli komut ile kombin oluşturma özelliğini kullandığınızda, sesiniz anlık olarak metne dönüştürülür ve işlenir. Ses kayıtlarınız kalıcı olarak depolanmaz.'**
  String get gizlilikMadde3Icerik;

  /// No description provided for @gizlilikMadde4Baslik.
  ///
  /// In tr, this message translates to:
  /// **'4. Üçüncü Taraf Servisler'**
  String get gizlilikMadde4Baslik;

  /// No description provided for @gizlilikMadde4Icerik.
  ///
  /// In tr, this message translates to:
  /// **'Uygulama performans analitiği ve reklam yayınları için Firebase ve Google AdMob altyapısı kullanılmaktadır.'**
  String get gizlilikMadde4Icerik;

  /// No description provided for @anladim.
  ///
  /// In tr, this message translates to:
  /// **'Anladım'**
  String get anladim;

  /// No description provided for @stilVeModaTercihleriniz.
  ///
  /// In tr, this message translates to:
  /// **'Stil & Moda Tercihleriniz'**
  String get stilVeModaTercihleriniz;

  /// No description provided for @stilModalAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Yapay zekâ kombin üretirken bu tarz ve kesim tercihlerinizi önceliklendirir.'**
  String get stilModalAciklama;

  /// No description provided for @favoriTarzinizUst.
  ///
  /// In tr, this message translates to:
  /// **'FAVORİ TARZINIZ'**
  String get favoriTarzinizUst;

  /// No description provided for @giyimKesimiFitUst.
  ///
  /// In tr, this message translates to:
  /// **'GİYİM KESİMİ (FIT)'**
  String get giyimKesimiFitUst;

  /// No description provided for @hesapSilmeUst.
  ///
  /// In tr, this message translates to:
  /// **'HESAP SİLME'**
  String get hesapSilmeUst;

  /// No description provided for @tumBulutVeYerelVeriTemizlenir.
  ///
  /// In tr, this message translates to:
  /// **'Tüm bulut ve yerel verilerinizi temizler'**
  String get tumBulutVeYerelVeriTemizlenir;

  /// No description provided for @hakkindaUst.
  ///
  /// In tr, this message translates to:
  /// **'HAKKINDA'**
  String get hakkindaUst;

  /// No description provided for @topluFotografEkleTooltip.
  ///
  /// In tr, this message translates to:
  /// **'Toplu Kıyafet Ekle'**
  String get topluFotografEkleTooltip;

  /// No description provided for @kuponKoduKullanTitle.
  ///
  /// In tr, this message translates to:
  /// **'Kupon Kodu Kullan'**
  String get kuponKoduKullanTitle;

  /// No description provided for @kuponKoduAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Ekstra kombin hakkı kazanmak için kupon kodunuzu aşağıya girin:'**
  String get kuponKoduAciklama;

  /// No description provided for @kuponKoduHint.
  ///
  /// In tr, this message translates to:
  /// **'Örn: VIP2026'**
  String get kuponKoduHint;

  /// No description provided for @kuponKullanButon.
  ///
  /// In tr, this message translates to:
  /// **'Kullan'**
  String get kuponKullanButon;

  /// No description provided for @kuponBasariliMesaji.
  ///
  /// In tr, this message translates to:
  /// **'🎉 Kupon başarıyla tanımlandı! Haklarınız yüklendi.'**
  String get kuponBasariliMesaji;

  /// No description provided for @kuponKullanilmisUyari.
  ///
  /// In tr, this message translates to:
  /// **'⚠️ Bu kupon kodunu daha önce kullandınız!'**
  String get kuponKullanilmisUyari;

  /// No description provided for @kuponGecersizUyari.
  ///
  /// In tr, this message translates to:
  /// **'❌ Geçersiz kupon kodu! Lütfen tekrar deneyin.'**
  String get kuponGecersizUyari;

  /// No description provided for @sinirsizIslemHakkiBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Sınırsız İşlem Hakkı 👑'**
  String get sinirsizIslemHakkiBaslik;

  /// No description provided for @kalanHakkinizBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Kalan Hakkınız: {hak} ⚡'**
  String kalanHakkinizBaslik(Object hak);

  /// No description provided for @sinirsizHakAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Premium ayrıcalığıyla tüm kombin ve stil analizlerini sınırsız kullanabilirsiniz.'**
  String get sinirsizHakAciklama;

  /// No description provided for @gunlukHakAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Günlük haklarınız her gün 00:00\'da yenilenir. Daha fazla hak için reklam izleyebilir veya kupon kullanabilirsiniz.'**
  String get gunlukHakAciklama;

  /// No description provided for @kuponKullan.
  ///
  /// In tr, this message translates to:
  /// **'Kupon Kullan'**
  String get kuponKullan;

  /// No description provided for @hakEklendiTebrikler.
  ///
  /// In tr, this message translates to:
  /// **'Tebrikler! +2 İşlem hakkı tanımlandı. ✨'**
  String get hakEklendiTebrikler;

  /// No description provided for @gardirobunDolduTitle.
  ///
  /// In tr, this message translates to:
  /// **'Gardırobun Doldu!'**
  String get gardirobunDolduTitle;

  /// No description provided for @gardirobunDolduIcerik.
  ///
  /// In tr, this message translates to:
  /// **'Mevcut limitin olan {limit} kıyafete ulaştın. Kısa bir video izleyerek gardırobuna +2 kıyafet yükleme alanı eklemek ister misin? 👕'**
  String gardirobunDolduIcerik(Object limit);

  /// No description provided for @reklamIzleSlotEkle.
  ///
  /// In tr, this message translates to:
  /// **'Reklam İzle (+2 Slot)'**
  String get reklamIzleSlotEkle;

  /// No description provided for @yeniSlotEklendiTebrikler.
  ///
  /// In tr, this message translates to:
  /// **'Tebrikler! Gardırobuna +2 yeni kıyafet alanı eklendi. 🎉'**
  String get yeniSlotEklendiTebrikler;

  /// No description provided for @gunlukHakBittiTitle.
  ///
  /// In tr, this message translates to:
  /// **'Günlük Hakkın Bitti!'**
  String get gunlukHakBittiTitle;

  /// No description provided for @gunlukHakBittiIcerik.
  ///
  /// In tr, this message translates to:
  /// **'Bugünlük ücretsiz işlem hakkını tamamladın. Kısa bir video izleyerek veya kupon girerek yeni haklar kazanabilirsin! 🛍️'**
  String get gunlukHakBittiIcerik;

  /// No description provided for @kuponGir.
  ///
  /// In tr, this message translates to:
  /// **'Kupon Gir'**
  String get kuponGir;

  /// No description provided for @anaSemsiyeBildirimBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Şemsiyeni Unutma! ☔'**
  String get anaSemsiyeBildirimBaslik;

  /// No description provided for @anaSemsiyeBildirimIcerik.
  ///
  /// In tr, this message translates to:
  /// **'Bugün hava yağmurlu görünüyor, kombinini buna göre seçmeyi unutma.'**
  String get anaSemsiyeBildirimIcerik;

  /// No description provided for @anaCamasirGunuBildirimBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Çamaşır Günü! 🧺'**
  String get anaCamasirGunuBildirimBaslik;

  /// No description provided for @anaCamasirGunuBildirimIcerik.
  ///
  /// In tr, this message translates to:
  /// **'Sepetinde yıkanmayı bekleyen kıyafetler birikti. Makineyi çalıştırma vakti!'**
  String get anaCamasirGunuBildirimIcerik;

  /// No description provided for @chatZorunluParcaMesaji.
  ///
  /// In tr, this message translates to:
  /// **'✨ Bu parçayla ne giyebilirim? ({parca})'**
  String chatZorunluParcaMesaji(Object parca);

  /// No description provided for @chatKombinHazirBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Kombinin Hazır ({ortam})'**
  String chatKombinHazirBaslik(Object ortam);

  /// No description provided for @chatKombiniGorButon.
  ///
  /// In tr, this message translates to:
  /// **'Kombini Gör'**
  String get chatKombiniGorButon;

  /// No description provided for @chatStilistKombinTasarlayor.
  ///
  /// In tr, this message translates to:
  /// **'Stilist kombini tasarlıyor...'**
  String get chatStilistKombinTasarlayor;

  /// No description provided for @chatStilistYaziyor.
  ///
  /// In tr, this message translates to:
  /// **'Stilist yazıyor...'**
  String get chatStilistYaziyor;

  /// No description provided for @pazartesi.
  ///
  /// In tr, this message translates to:
  /// **'Pazartesi'**
  String get pazartesi;

  /// No description provided for @sali.
  ///
  /// In tr, this message translates to:
  /// **'Salı'**
  String get sali;

  /// No description provided for @carsamba.
  ///
  /// In tr, this message translates to:
  /// **'Çarşamba'**
  String get carsamba;

  /// No description provided for @persembe.
  ///
  /// In tr, this message translates to:
  /// **'Perşembe'**
  String get persembe;

  /// No description provided for @cuma.
  ///
  /// In tr, this message translates to:
  /// **'Cuma'**
  String get cuma;

  /// No description provided for @cumartesi.
  ///
  /// In tr, this message translates to:
  /// **'Cumartesi'**
  String get cumartesi;

  /// No description provided for @pazar.
  ///
  /// In tr, this message translates to:
  /// **'Pazar'**
  String get pazar;

  /// No description provided for @rehberiAtla.
  ///
  /// In tr, this message translates to:
  /// **'REHBERİ ATLA'**
  String get rehberiAtla;

  /// No description provided for @rehberAnladimBasla.
  ///
  /// In tr, this message translates to:
  /// **'Anladım, Başla!'**
  String get rehberAnladimBasla;

  /// No description provided for @rehberSonrakiAdim.
  ///
  /// In tr, this message translates to:
  /// **'Sonraki Adım ➔'**
  String get rehberSonrakiAdim;

  /// No description provided for @rehberGardirobuDijitallestirBaslik.
  ///
  /// In tr, this message translates to:
  /// **'📸 Gardırobunu Dijitalleştir'**
  String get rehberGardirobuDijitallestirBaslik;

  /// No description provided for @rehberGardirobuDijitallestirAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Bu butona basarak kıyafetlerinin fotoğrafını çekebilir veya galerinden ekleyerek kendi dijital gardırobunu oluşturabilirsin.'**
  String get rehberGardirobuDijitallestirAciklama;

  /// No description provided for @rehberSesliAsistanBaslik.
  ///
  /// In tr, this message translates to:
  /// **'🎙️ Sesli Stil Asistanı'**
  String get rehberSesliAsistanBaslik;

  /// No description provided for @rehberSesliAsistanAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Sesli komut vererek ne giyeceğini sorabilir veya hızlıca kombin tavsiyesi alabilirsin.'**
  String get rehberSesliAsistanAciklama;

  /// No description provided for @rehberAiStilistBaslik.
  ///
  /// In tr, this message translates to:
  /// **'✨ AI Stilist Önerileri'**
  String get rehberAiStilistBaslik;

  /// No description provided for @rehberAiStilistAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Günün havasına, ten rengine ve tarzına en uygun kombin önerilerini tek tıkla yapay zekadan alabilirsin.'**
  String get rehberAiStilistAciklama;

  /// No description provided for @rehberAyarlarBaslik.
  ///
  /// In tr, this message translates to:
  /// **'⚙️ Kişiselleştirme & Ayarlar'**
  String get rehberAyarlarBaslik;

  /// No description provided for @rehberAyarlarAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Cinsiyet, ten rengi, renk ve tema tercihlerini ayarlayabilir veya kullanım rehberine tekrar ulaşabilirsin.'**
  String get rehberAyarlarAciklama;

  /// No description provided for @rehberNavGardirobumBaslik.
  ///
  /// In tr, this message translates to:
  /// **'👔 Gardırobum'**
  String get rehberNavGardirobumBaslik;

  /// No description provided for @rehberNavGardirobumAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Tüm kıyafetlerini kategorilerine göre görüntüle, filtrele ve pratik bir şekilde yönet.'**
  String get rehberNavGardirobumAciklama;

  /// No description provided for @rehberNavHaftalikBaslik.
  ///
  /// In tr, this message translates to:
  /// **'📅 Haftalık Planlayıcı'**
  String get rehberNavHaftalikBaslik;

  /// No description provided for @rehberNavHaftalikAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Önümüzdeki günlerin hava durumuna göre kombinlerini gün gün önceden planla.'**
  String get rehberNavHaftalikAciklama;

  /// No description provided for @rehberNavDolaptanBaslik.
  ///
  /// In tr, this message translates to:
  /// **'🤖 AI Dolaptan Kombin'**
  String get rehberNavDolaptanBaslik;

  /// No description provided for @rehberNavDolaptanAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Mevcut kıyafetlerin arasından günün şartlarına en uygun otomatik kombinleri yapay zekaya ürettir.'**
  String get rehberNavDolaptanAciklama;

  /// No description provided for @rehberNavKendiBaslik.
  ///
  /// In tr, this message translates to:
  /// **'🎨 Kendi Kombinini Yap'**
  String get rehberNavKendiBaslik;

  /// No description provided for @rehberNavKendiAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Üst, alt ve ayakkabı parçalarını manuel eşleştirerek kendi stilini oluştur ve kaydet.'**
  String get rehberNavKendiAciklama;

  /// No description provided for @rehberNavProfilBaslik.
  ///
  /// In tr, this message translates to:
  /// **'📊 Analiz & Çamaşır Sepeti'**
  String get rehberNavProfilBaslik;

  /// No description provided for @rehberNavProfilAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Kıyafet giyilme istatistiklerini incele ve kirlenen parçalarını çamaşır sepetinden takip et.'**
  String get rehberNavProfilAciklama;

  /// No description provided for @bildirimIzinGerekliBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Bildirim İzni Gerekli'**
  String get bildirimIzinGerekliBaslik;

  /// No description provided for @bildirimIzinGerekliIcerik.
  ///
  /// In tr, this message translates to:
  /// **'Çamaşır günü hatırlatıcıları, yağmurlu hava uyarıları ve günlük stil önerilerini alabilmek için bildirim izinlerini açmanız önerilir.'**
  String get bildirimIzinGerekliIcerik;

  /// No description provided for @bildirimGunaydinBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Günaydın! ☀️'**
  String get bildirimGunaydinBaslik;

  /// No description provided for @bildirimGunaydinIcerik.
  ///
  /// In tr, this message translates to:
  /// **'Bugünün hava durumuna göre harika bir kombin hazırladım. Görmek ister misin?'**
  String get bildirimGunaydinIcerik;

  /// No description provided for @bildirimKanalGenelBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Genel Bildirimler'**
  String get bildirimKanalGenelBaslik;

  /// No description provided for @bildirimKanalGenelAciklama.
  ///
  /// In tr, this message translates to:
  /// **'FitCheck genel bildirimleri'**
  String get bildirimKanalGenelAciklama;

  /// No description provided for @bildirimKanalGunlukBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Günlük Kombin Önerileri'**
  String get bildirimKanalGunlukBaslik;

  /// No description provided for @bildirimKanalGunlukAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Günlük kombin önerileri bildirimleri'**
  String get bildirimKanalGunlukAciklama;

  /// No description provided for @bildirimKanalYikamaBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Çamaşır Hatırlatıcıları'**
  String get bildirimKanalYikamaBaslik;

  /// No description provided for @bildirimKanalYikamaAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Çamaşır ve kıyafet bakım hatırlatıcıları'**
  String get bildirimKanalYikamaAciklama;

  /// No description provided for @bildirimKanalRaporBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Haftalık Stil Raporları'**
  String get bildirimKanalRaporBaslik;

  /// No description provided for @bildirimKanalRaporAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Haftalık gardırop ve stil raporları'**
  String get bildirimKanalRaporAciklama;

  /// No description provided for @tenRengiAcik.
  ///
  /// In tr, this message translates to:
  /// **'Açık / Beyaz'**
  String get tenRengiAcik;

  /// No description provided for @tenRengiBugday.
  ///
  /// In tr, this message translates to:
  /// **'Buğday'**
  String get tenRengiBugday;

  /// No description provided for @tenRengiEsmer.
  ///
  /// In tr, this message translates to:
  /// **'Esmer / Koyu'**
  String get tenRengiEsmer;

  /// No description provided for @stilStreetwear.
  ///
  /// In tr, this message translates to:
  /// **'Streetwear / Casual'**
  String get stilStreetwear;

  /// No description provided for @stilKlasik.
  ///
  /// In tr, this message translates to:
  /// **'Klasik / Ofis'**
  String get stilKlasik;

  /// No description provided for @stilMinimalist.
  ///
  /// In tr, this message translates to:
  /// **'Minimalist'**
  String get stilMinimalist;

  /// No description provided for @stilSpor.
  ///
  /// In tr, this message translates to:
  /// **'Spor / Athleisure'**
  String get stilSpor;

  /// No description provided for @stilVintage.
  ///
  /// In tr, this message translates to:
  /// **'Vintage / Retro'**
  String get stilVintage;

  /// No description provided for @fitSlim.
  ///
  /// In tr, this message translates to:
  /// **'Slim Fit'**
  String get fitSlim;

  /// No description provided for @fitRegular.
  ///
  /// In tr, this message translates to:
  /// **'Regular Fit'**
  String get fitRegular;

  /// No description provided for @fitOversize.
  ///
  /// In tr, this message translates to:
  /// **'Oversize / Relaxed'**
  String get fitOversize;

  /// No description provided for @gardirobumBosBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Dolabın Çok Boş!'**
  String get gardirobumBosBaslik;

  /// No description provided for @gardirobumGizlendiBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Gardırop Gizlendi'**
  String get gardirobumGizlendiBaslik;

  /// No description provided for @gardirobumGizlendiAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Görüntülemek için sağ üstteki göz simgesine dokunun'**
  String get gardirobumGizlendiAciklama;

  /// No description provided for @gardirobumGoster.
  ///
  /// In tr, this message translates to:
  /// **'İçeriği Göster'**
  String get gardirobumGoster;

  /// No description provided for @gardirobumGizle.
  ///
  /// In tr, this message translates to:
  /// **'İçeriği Gizle'**
  String get gardirobumGizle;

  /// No description provided for @kategoriUst.
  ///
  /// In tr, this message translates to:
  /// **'ÜST'**
  String get kategoriUst;

  /// No description provided for @kategoriAlt.
  ///
  /// In tr, this message translates to:
  /// **'ALT'**
  String get kategoriAlt;

  /// No description provided for @kategoriAyakkabi.
  ///
  /// In tr, this message translates to:
  /// **'AYAKKABI'**
  String get kategoriAyakkabi;

  /// No description provided for @kategoriAksesuar.
  ///
  /// In tr, this message translates to:
  /// **'AKSESUAR'**
  String get kategoriAksesuar;

  /// No description provided for @gardirobumBosAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Hemen ilk kıyafetini ekle ve yapay zekanın sihrini gör.'**
  String get gardirobumBosAciklama;

  /// No description provided for @gardirobumAiIslem1.
  ///
  /// In tr, this message translates to:
  /// **'Gardıroburuz taranıyor...'**
  String get gardirobumAiIslem1;

  /// No description provided for @gardirobumAiIslem2.
  ///
  /// In tr, this message translates to:
  /// **'Hava durumu analiz ediliyor...'**
  String get gardirobumAiIslem2;

  /// No description provided for @gardirobumAiIslem3.
  ///
  /// In tr, this message translates to:
  /// **'Renk uyumları hesaplanıyor...'**
  String get gardirobumAiIslem3;

  /// No description provided for @gardirobumAiIslem4.
  ///
  /// In tr, this message translates to:
  /// **'En iyi kombinler seçiliyor...'**
  String get gardirobumAiIslem4;

  /// No description provided for @gardirobumAiIslem5.
  ///
  /// In tr, this message translates to:
  /// **'Son dokunuşlar yapılıyor...'**
  String get gardirobumAiIslem5;

  /// No description provided for @gardirobumHakBittiBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Günlük Limit Doldu'**
  String get gardirobumHakBittiBaslik;

  /// No description provided for @gardirobumHakBittiAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Günlük kombin oluşturma limitinize ulaştınız.'**
  String get gardirobumHakBittiAciklama;

  /// No description provided for @gardirobumHakEklendiMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Tebrikler, yeni kombin hakkı kazanıldı!'**
  String get gardirobumHakEklendiMesaj;

  /// No description provided for @ayarlariAc.
  ///
  /// In tr, this message translates to:
  /// **'Ayarları Aç'**
  String get ayarlariAc;

  /// No description provided for @kiyafetEkle.
  ///
  /// In tr, this message translates to:
  /// **'Kıyafet Ekle'**
  String get kiyafetEkle;

  /// No description provided for @kameraIleCek.
  ///
  /// In tr, this message translates to:
  /// **'Kamera ile Çek'**
  String get kameraIleCek;

  /// No description provided for @galeridenSecToplu.
  ///
  /// In tr, this message translates to:
  /// **'Galeriden Toplu Seç'**
  String get galeridenSecToplu;

  /// No description provided for @kameraIzniGerekliBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Kamera İzni Gerekli'**
  String get kameraIzniGerekliBaslik;

  /// No description provided for @kameraIzniGerekliAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Fotoğraf çekebilmek için lütfen kamera izni verin.'**
  String get kameraIzniGerekliAciklama;

  /// No description provided for @kiyafetDuzenleBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Kıyafeti Düzenle'**
  String get kiyafetDuzenleBaslik;

  /// No description provided for @kategori.
  ///
  /// In tr, this message translates to:
  /// **'Kategori'**
  String get kategori;

  /// No description provided for @evetSil.
  ///
  /// In tr, this message translates to:
  /// **'Evet, Sil'**
  String get evetSil;

  /// No description provided for @favorilerdenCikarildi.
  ///
  /// In tr, this message translates to:
  /// **'Favorilerden çıkarıldı'**
  String get favorilerdenCikarildi;

  /// No description provided for @gardirobumHenuzYokEkle.
  ///
  /// In tr, this message translates to:
  /// **'Henüz kıyafet eklenmedi. Hemen ekleyin!'**
  String get gardirobumHenuzYokEkle;

  /// No description provided for @gardirobumMaksFotografUyari.
  ///
  /// In tr, this message translates to:
  /// **'En fazla {max} adet fotoğraf seçebilirsiniz.'**
  String gardirobumMaksFotografUyari(int max);

  /// No description provided for @gardirobumUrunSayisi.
  ///
  /// In tr, this message translates to:
  /// **'{count} Ürün'**
  String gardirobumUrunSayisi(int count);

  /// No description provided for @kombinUyumYuzdesi.
  ///
  /// In tr, this message translates to:
  /// **'%{oran} Uyum'**
  String kombinUyumYuzdesi(String oran);

  /// No description provided for @kombinSohbetAc.
  ///
  /// In tr, this message translates to:
  /// **'Kombin hakkında sohbet et'**
  String get kombinSohbetAc;

  /// No description provided for @kombinSohbetBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Kombin Sohbeti'**
  String get kombinSohbetBaslik;

  /// No description provided for @kombinSohbetAltBaslik.
  ///
  /// In tr, this message translates to:
  /// **'{gun} kombini üzerine sohbet'**
  String kombinSohbetAltBaslik(Object gun);

  /// No description provided for @kombinSohbetKarsilama.
  ///
  /// In tr, this message translates to:
  /// **'{kombin} kombinini birlikte inceleyelim! Renk uyumu, hava durumu ya da alternatif parçalar hakkında ne istersen sorabilirsin. ✨'**
  String kombinSohbetKarsilama(Object kombin);

  /// No description provided for @kombinSohbetOneriUyum.
  ///
  /// In tr, this message translates to:
  /// **'🤔 Bu kombin neden uyumlu?'**
  String get kombinSohbetOneriUyum;

  /// No description provided for @kombinSohbetOneriAlternatif.
  ///
  /// In tr, this message translates to:
  /// **'👟 Alternatif parça öner'**
  String get kombinSohbetOneriAlternatif;

  /// No description provided for @kombinSohbetOneriHava.
  ///
  /// In tr, this message translates to:
  /// **'🌦️ Hava değişirse ne giyerim?'**
  String get kombinSohbetOneriHava;

  /// No description provided for @kombinSohbetOneriAksesuar.
  ///
  /// In tr, this message translates to:
  /// **'💍 Aksesuar önerisi ver'**
  String get kombinSohbetOneriAksesuar;

  /// No description provided for @kombinSohbetAltBaslikAnlik.
  ///
  /// In tr, this message translates to:
  /// **'Anlık kombin üzerine sohbet'**
  String get kombinSohbetAltBaslikAnlik;

  /// No description provided for @chatKirliSepetiBos.
  ///
  /// In tr, this message translates to:
  /// **'🧺 Kirli sepetin boş! Tüm parçaların kullanıma hazır, istediğin zaman kombin hazırlayabilirim. ✨'**
  String get chatKirliSepetiBos;

  /// No description provided for @chatKirliSepetiDoluBaslik.
  ///
  /// In tr, this message translates to:
  /// **'🧺 Kirli sepetinde **{sayi}** parça yıkanmayı bekliyor:'**
  String chatKirliSepetiDoluBaslik(Object sayi);

  /// No description provided for @chatKirliSepetiDoluNot.
  ///
  /// In tr, this message translates to:
  /// **'Bu parçalar yıkanana kadar kombin önerilerine dahil edilmez. İstersen temiz parçalarınla hemen bir kombin hazırlayabilirim.'**
  String get chatKirliSepetiDoluNot;

  /// No description provided for @analitikVerileriPaylas.
  ///
  /// In tr, this message translates to:
  /// **'Analitik verileri paylaş'**
  String get analitikVerileriPaylas;

  /// No description provided for @analitikVerileriPaylasAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Uygulama deneyimini iyileştirmek için anonim kullanım verileri gönderilir. Kapatırsanız bu cihazdaki analitik veriler silinir.'**
  String get analitikVerileriPaylasAciklama;

  /// No description provided for @chatKarsilamaHavaYok.
  ///
  /// In tr, this message translates to:
  /// **'Selam! 👋 Senin tarzına uygun harika bir kombin hazırlayalım mı? ✨'**
  String get chatKarsilamaHavaYok;

  /// No description provided for @premiumBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Aylık reklamsız kullanım'**
  String get premiumBaslik;

  /// No description provided for @premiumAciklama.
  ///
  /// In tr, this message translates to:
  /// **'FitCheck deneyimini reklamsız kullan. Aboneliğin aktif olduğu sürece tüm reklamlar kaldırılır.'**
  String get premiumAciklama;

  /// No description provided for @premiumOzellikReklamsiz.
  ///
  /// In tr, this message translates to:
  /// **'Tüm reklamlar kaldırılır'**
  String get premiumOzellikReklamsiz;

  /// No description provided for @premiumOzellikAylik.
  ///
  /// In tr, this message translates to:
  /// **'Aylık otomatik yenilenir'**
  String get premiumOzellikAylik;

  /// No description provided for @premiumOzellikMagaza.
  ///
  /// In tr, this message translates to:
  /// **'Google Play üzerinden yönetilir'**
  String get premiumOzellikMagaza;

  /// No description provided for @premiumAktifMesaji.
  ///
  /// In tr, this message translates to:
  /// **'Premium aktif. Reklamlar hesabınız için kapalı.'**
  String get premiumAktifMesaji;

  /// No description provided for @premiumAboneOl.
  ///
  /// In tr, this message translates to:
  /// **'Aylık abone ol'**
  String get premiumAboneOl;

  /// No description provided for @premiumAboneOlFiyatli.
  ///
  /// In tr, this message translates to:
  /// **'Aylık abone ol • {fiyat}'**
  String premiumAboneOlFiyatli(String fiyat);

  /// No description provided for @premiumGeriYukle.
  ///
  /// In tr, this message translates to:
  /// **'Satın almayı geri yükle'**
  String get premiumGeriYukle;

  /// No description provided for @premiumMagazaHazirDegil.
  ///
  /// In tr, this message translates to:
  /// **'Google Play bağlantısı hazır değil. Lütfen tekrar deneyin.'**
  String get premiumMagazaHazirDegil;

  /// No description provided for @premiumSatinAlmaBaslatilamadi.
  ///
  /// In tr, this message translates to:
  /// **'Satın alma başlatılamadı.'**
  String get premiumSatinAlmaBaslatilamadi;

  /// No description provided for @premiumSatinAlmaBasarisiz.
  ///
  /// In tr, this message translates to:
  /// **'Satın alma başarısız oldu.'**
  String get premiumSatinAlmaBasarisiz;

  /// No description provided for @premiumAylikBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Aylık Reklamsız Premium'**
  String get premiumAylikBaslik;

  /// No description provided for @premiumAylikAltBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Aylık {fiyat} ile reklamları kaldır'**
  String premiumAylikAltBaslik(String fiyat);

  /// No description provided for @premiumGec.
  ///
  /// In tr, this message translates to:
  /// **'Premium’a geç • {fiyat}/ay'**
  String premiumGec(String fiyat);

  /// No description provided for @guncellemeBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Güncelleme gerekli'**
  String get guncellemeBaslik;

  /// No description provided for @guncellemeAciklama.
  ///
  /// In tr, this message translates to:
  /// **'FitCheck\'in yeni bir sürümü yayınlandı. Devam edebilmek için lütfen uygulamayı güncelle.'**
  String get guncellemeAciklama;

  /// No description provided for @guncellemeButonu.
  ///
  /// In tr, this message translates to:
  /// **'Şimdi güncelle'**
  String get guncellemeButonu;

  /// No description provided for @guncellemeYeniSurum.
  ///
  /// In tr, this message translates to:
  /// **'Yeni sürüm: {surum}'**
  String guncellemeYeniSurum(String surum);

  /// No description provided for @guncellemeMagazaUrlYok.
  ///
  /// In tr, this message translates to:
  /// **'Mağaza bağlantısı bulunamadı. Lütfen uygulamayı mağazadan güncelleyin.'**
  String get guncellemeMagazaUrlYok;

  /// No description provided for @premiumUrunBulunamadi.
  ///
  /// In tr, this message translates to:
  /// **'Abonelik bilgisi alınamadı. Daha sonra tekrar deneyin.'**
  String get premiumUrunBulunamadi;

  /// No description provided for @triviaQ1.
  ///
  /// In tr, this message translates to:
  /// **'Taba / Turuncu tonları ile renk çarkında tam zıt konumda yer alan ve güçlü bir kontrast oluşturan renk hangisidir?'**
  String get triviaQ1;

  /// No description provided for @triviaQ1o1.
  ///
  /// In tr, this message translates to:
  /// **'Saks Mavisi / Petrol Mavisi'**
  String get triviaQ1o1;

  /// No description provided for @triviaQ1o2.
  ///
  /// In tr, this message translates to:
  /// **'Zümrüt Yeşili'**
  String get triviaQ1o2;

  /// No description provided for @triviaQ1o3.
  ///
  /// In tr, this message translates to:
  /// **'Bordo'**
  String get triviaQ1o3;

  /// No description provided for @triviaQ1o4.
  ///
  /// In tr, this message translates to:
  /// **'Hardal Sarısı'**
  String get triviaQ1o4;

  /// No description provided for @triviaQ2.
  ///
  /// In tr, this message translates to:
  /// **'Modada \'Monokrom\' (Monochromatic) giyim tarzı ne anlama gelir?'**
  String get triviaQ2;

  /// No description provided for @triviaQ2o1.
  ///
  /// In tr, this message translates to:
  /// **'Tek bir rengin farklı tonlarını bir arada kullanmak'**
  String get triviaQ2o1;

  /// No description provided for @triviaQ2o2.
  ///
  /// In tr, this message translates to:
  /// **'Sadece siyah ve beyaz kıyafetler giyinmek'**
  String get triviaQ2o2;

  /// No description provided for @triviaQ2o3.
  ///
  /// In tr, this message translates to:
  /// **'En az 3 zıt rengi aynı anda harmanlamak'**
  String get triviaQ2o3;

  /// No description provided for @triviaQ2o4.
  ///
  /// In tr, this message translates to:
  /// **'Sadece desenli ve baskılı parçaları eşleştirmek'**
  String get triviaQ2o4;

  /// No description provided for @triviaQ3.
  ///
  /// In tr, this message translates to:
  /// **'Altın (Gold) takıların, kiremit ve zeytin yeşili gibi tonların en çok yakıştığı cilt alt tonu hangisidir?'**
  String get triviaQ3;

  /// No description provided for @triviaQ3o1.
  ///
  /// In tr, this message translates to:
  /// **'Soğuk (Cool) Alt Ton'**
  String get triviaQ3o1;

  /// No description provided for @triviaQ3o2.
  ///
  /// In tr, this message translates to:
  /// **'Sıcak (Warm) Alt Ton'**
  String get triviaQ3o2;

  /// No description provided for @triviaQ3o3.
  ///
  /// In tr, this message translates to:
  /// **'Mavi Alt Ton'**
  String get triviaQ3o3;

  /// No description provided for @triviaQ3o4.
  ///
  /// In tr, this message translates to:
  /// **'Pembe Alt Ton'**
  String get triviaQ3o4;

  /// No description provided for @triviaQ4.
  ///
  /// In tr, this message translates to:
  /// **'Kapsül gardırop oluştururken her renkle kolayca eşleşen \'Nötr Renkler\' grubunda hangisi YER ALMAZ?'**
  String get triviaQ4;

  /// No description provided for @triviaQ4o1.
  ///
  /// In tr, this message translates to:
  /// **'Bej / Krem'**
  String get triviaQ4o1;

  /// No description provided for @triviaQ4o2.
  ///
  /// In tr, this message translates to:
  /// **'Lacivert'**
  String get triviaQ4o2;

  /// No description provided for @triviaQ4o3.
  ///
  /// In tr, this message translates to:
  /// **'Flaş (Neon) Sarı'**
  String get triviaQ4o3;

  /// No description provided for @triviaQ4o4.
  ///
  /// In tr, this message translates to:
  /// **'Taba / Kahverengi'**
  String get triviaQ4o4;

  /// No description provided for @triviaQ5.
  ///
  /// In tr, this message translates to:
  /// **'Renk çarkında yan yana duran ve yumuşak, göz yormayan bir geçiş sağlayan renk grubuna ne ad verilir?'**
  String get triviaQ5;

  /// No description provided for @triviaQ5o1.
  ///
  /// In tr, this message translates to:
  /// **'Tamamlayıcı (Zıt) Renkler'**
  String get triviaQ5o1;

  /// No description provided for @triviaQ5o2.
  ///
  /// In tr, this message translates to:
  /// **'Analog Renkler'**
  String get triviaQ5o2;

  /// No description provided for @triviaQ5o3.
  ///
  /// In tr, this message translates to:
  /// **'Pastel Renkler'**
  String get triviaQ5o3;

  /// No description provided for @triviaQ5o4.
  ///
  /// In tr, this message translates to:
  /// **'Triadik Renkler'**
  String get triviaQ5o4;

  /// No description provided for @triviaQ6.
  ///
  /// In tr, this message translates to:
  /// **'Modada vücut oranını daha uzun ve dengeli göstermek için uygulanan \'Üçte Bir Kuralı\' (Rule of Thirds) hangisidir?'**
  String get triviaQ6;

  /// No description provided for @triviaQ6o1.
  ///
  /// In tr, this message translates to:
  /// **'1/2 Üst - 1/2 Alt (Gövde ve bacak eşit)'**
  String get triviaQ6o1;

  /// No description provided for @triviaQ6o2.
  ///
  /// In tr, this message translates to:
  /// **'1/3 Üst - 2/3 Alt (Yüksek bel / Kısa üst)'**
  String get triviaQ6o2;

  /// No description provided for @triviaQ6o3.
  ///
  /// In tr, this message translates to:
  /// **'2/3 Üst - 1/3 Alt (Uzun tunik / Kısa alt)'**
  String get triviaQ6o3;

  /// No description provided for @triviaQ6o4.
  ///
  /// In tr, this message translates to:
  /// **'3/3 Tam boy tek parça'**
  String get triviaQ6o4;

  /// No description provided for @triviaQ7.
  ///
  /// In tr, this message translates to:
  /// **'Fransızca moda terimi olan \'Ton-sür-ton\' giyim tekniği neyi ifade eder?'**
  String get triviaQ7;

  /// No description provided for @triviaQ7o1.
  ///
  /// In tr, this message translates to:
  /// **'Aynı rengin farklı doygunluk ve açık/koyu nüanslarını katmanlamak'**
  String get triviaQ7o1;

  /// No description provided for @triviaQ7o2.
  ///
  /// In tr, this message translates to:
  /// **'Tamamen zıt iki rengi keskin hatlarla birleştirmek'**
  String get triviaQ7o2;

  /// No description provided for @triviaQ7o3.
  ///
  /// In tr, this message translates to:
  /// **'Siyah ve beyaz desenleri karıştırmak'**
  String get triviaQ7o3;

  /// No description provided for @triviaQ7o4.
  ///
  /// In tr, this message translates to:
  /// **'Farklı kumaş dokularını tek renkte toplamak'**
  String get triviaQ7o4;

  /// No description provided for @triviaQ8.
  ///
  /// In tr, this message translates to:
  /// **'Klasik ve formal giyim kurallarına göre, deri kemer rengi hangisiyle birebir eşleşmelidir?'**
  String get triviaQ8;

  /// No description provided for @triviaQ8o1.
  ///
  /// In tr, this message translates to:
  /// **'Kravat veya Şal'**
  String get triviaQ8o1;

  /// No description provided for @triviaQ8o2.
  ///
  /// In tr, this message translates to:
  /// **'Gömlek'**
  String get triviaQ8o2;

  /// No description provided for @triviaQ8o3.
  ///
  /// In tr, this message translates to:
  /// **'Ayakkabı'**
  String get triviaQ8o3;

  /// No description provided for @triviaQ8o4.
  ///
  /// In tr, this message translates to:
  /// **'Ceket Astarı'**
  String get triviaQ8o4;

  /// No description provided for @triviaQ9.
  ///
  /// In tr, this message translates to:
  /// **'Renk çarkında eşit uzaklıktaki 3 rengin (Ör: Kırmızı, Sarı, Mavi) oluşturduğu canlı kombin tarzına ne denir?'**
  String get triviaQ9;

  /// No description provided for @triviaQ9o1.
  ///
  /// In tr, this message translates to:
  /// **'Triadik (Üçlü) Renk Uyumu'**
  String get triviaQ9o1;

  /// No description provided for @triviaQ9o2.
  ///
  /// In tr, this message translates to:
  /// **'Nötr Uyum'**
  String get triviaQ9o2;

  /// No description provided for @triviaQ9o3.
  ///
  /// In tr, this message translates to:
  /// **'Monokrom Uyum'**
  String get triviaQ9o3;

  /// No description provided for @triviaQ9o4.
  ///
  /// In tr, this message translates to:
  /// **'Kapsül Geçiş'**
  String get triviaQ9o4;

  /// No description provided for @triviaQ10.
  ///
  /// In tr, this message translates to:
  /// **'Ten rengine (Nude) veya giyilen pantolonun rengine tam uyan bir ayakkabı seçmek nasıl bir görsel etki yaratır?'**
  String get triviaQ10;

  /// No description provided for @triviaQ10o1.
  ///
  /// In tr, this message translates to:
  /// **'Bacak boyunu kesintisiz ve daha uzun gösterir'**
  String get triviaQ10o1;

  /// No description provided for @triviaQ10o2.
  ///
  /// In tr, this message translates to:
  /// **'Vücudu daha geniş gösterir'**
  String get triviaQ10o2;

  /// No description provided for @triviaQ10o3.
  ///
  /// In tr, this message translates to:
  /// **'Omuz genişliğini öne çıkarır'**
  String get triviaQ10o3;

  /// No description provided for @triviaQ10o4.
  ///
  /// In tr, this message translates to:
  /// **'Boyu olduğundan kısa gösterir'**
  String get triviaQ10o4;

  /// No description provided for @kombinOyunuBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Kombin Oyunu'**
  String get kombinOyunuBaslik;

  /// No description provided for @kombinMevcutKombin.
  ///
  /// In tr, this message translates to:
  /// **'Mevcut Kombin'**
  String get kombinMevcutKombin;

  /// No description provided for @kombinParcaUst.
  ///
  /// In tr, this message translates to:
  /// **'Üst'**
  String get kombinParcaUst;

  /// No description provided for @kombinParcaAlt.
  ///
  /// In tr, this message translates to:
  /// **'Alt'**
  String get kombinParcaAlt;

  /// No description provided for @kombinEksik_ayakkabi.
  ///
  /// In tr, this message translates to:
  /// **'Eksik: Ayakkabı'**
  String get kombinEksik_ayakkabi;

  /// No description provided for @kombinEksik_ceket.
  ///
  /// In tr, this message translates to:
  /// **'Eksik: Ceket'**
  String get kombinEksik_ceket;

  /// No description provided for @kombinEksik_aksesuar.
  ///
  /// In tr, this message translates to:
  /// **'Eksik: Aksesuar'**
  String get kombinEksik_aksesuar;

  /// No description provided for @kombinSoru_ayakkabi.
  ///
  /// In tr, this message translates to:
  /// **'Hangi ayakkabı en uygun?'**
  String get kombinSoru_ayakkabi;

  /// No description provided for @kombinSoru_ceket.
  ///
  /// In tr, this message translates to:
  /// **'Hangi ceket en uygun?'**
  String get kombinSoru_ceket;

  /// No description provided for @kombinSoru_aksesuar.
  ///
  /// In tr, this message translates to:
  /// **'Hangi aksesuar en uygun?'**
  String get kombinSoru_aksesuar;

  /// No description provided for @kombinKategoriAyakkabi.
  ///
  /// In tr, this message translates to:
  /// **'Ayakkabı'**
  String get kombinKategoriAyakkabi;

  /// No description provided for @kombinKategoriCeket.
  ///
  /// In tr, this message translates to:
  /// **'Ceket'**
  String get kombinKategoriCeket;

  /// No description provided for @kombinKategoriAksesuar.
  ///
  /// In tr, this message translates to:
  /// **'Aksesuar'**
  String get kombinKategoriAksesuar;

  /// No description provided for @kombinOrtamOfis.
  ///
  /// In tr, this message translates to:
  /// **'Ofis'**
  String get kombinOrtamOfis;

  /// No description provided for @kombinOrtamCasual.
  ///
  /// In tr, this message translates to:
  /// **'Casual'**
  String get kombinOrtamCasual;

  /// No description provided for @kombinOrtamDavet.
  ///
  /// In tr, this message translates to:
  /// **'Davet'**
  String get kombinOrtamDavet;

  /// No description provided for @kombinOrtamSpor.
  ///
  /// In tr, this message translates to:
  /// **'Spor'**
  String get kombinOrtamSpor;

  /// No description provided for @kombinHavaGunesli.
  ///
  /// In tr, this message translates to:
  /// **'Güneşli'**
  String get kombinHavaGunesli;

  /// No description provided for @kombinHavaYagmurlu.
  ///
  /// In tr, this message translates to:
  /// **'Yağmurlu'**
  String get kombinHavaYagmurlu;

  /// No description provided for @kombinHavaSoguk.
  ///
  /// In tr, this message translates to:
  /// **'Soğuk'**
  String get kombinHavaSoguk;

  /// No description provided for @kombinHavaSicak.
  ///
  /// In tr, this message translates to:
  /// **'Sıcak'**
  String get kombinHavaSicak;

  /// No description provided for @kombinRenkBeyaz.
  ///
  /// In tr, this message translates to:
  /// **'Beyaz'**
  String get kombinRenkBeyaz;

  /// No description provided for @kombinRenkSiyah.
  ///
  /// In tr, this message translates to:
  /// **'Siyah'**
  String get kombinRenkSiyah;

  /// No description provided for @kombinRenkKahverengi.
  ///
  /// In tr, this message translates to:
  /// **'Kahverengi'**
  String get kombinRenkKahverengi;

  /// No description provided for @kombinRenkLacivert.
  ///
  /// In tr, this message translates to:
  /// **'Lacivert'**
  String get kombinRenkLacivert;

  /// No description provided for @kombinRenkBej.
  ///
  /// In tr, this message translates to:
  /// **'Bej'**
  String get kombinRenkBej;

  /// No description provided for @kombinRenkKoyuYesil.
  ///
  /// In tr, this message translates to:
  /// **'Koyu Yeşil'**
  String get kombinRenkKoyuYesil;

  /// No description provided for @kombinRenkNude.
  ///
  /// In tr, this message translates to:
  /// **'Nude'**
  String get kombinRenkNude;

  /// No description provided for @kombinRenkAltin.
  ///
  /// In tr, this message translates to:
  /// **'Altın'**
  String get kombinRenkAltin;

  /// No description provided for @kombinRenkGri.
  ///
  /// In tr, this message translates to:
  /// **'Gri'**
  String get kombinRenkGri;

  /// No description provided for @kombinRenkPastelMavi.
  ///
  /// In tr, this message translates to:
  /// **'Pastel Mavi'**
  String get kombinRenkPastelMavi;

  /// No description provided for @kombinRenkKirmizi.
  ///
  /// In tr, this message translates to:
  /// **'Kırmızı'**
  String get kombinRenkKirmizi;

  /// No description provided for @kombinRenkMavi.
  ///
  /// In tr, this message translates to:
  /// **'Mavi'**
  String get kombinRenkMavi;

  /// No description provided for @kombinRenkGumus.
  ///
  /// In tr, this message translates to:
  /// **'Gümüş'**
  String get kombinRenkGumus;

  /// No description provided for @kombinRenkKoyuMavi.
  ///
  /// In tr, this message translates to:
  /// **'Koyu Mavi'**
  String get kombinRenkKoyuMavi;

  /// No description provided for @kombinRenkKamel.
  ///
  /// In tr, this message translates to:
  /// **'Kamel'**
  String get kombinRenkKamel;

  /// No description provided for @kombinRenkYesil.
  ///
  /// In tr, this message translates to:
  /// **'Yeşil'**
  String get kombinRenkYesil;

  /// No description provided for @kombinRenkAcikMavi.
  ///
  /// In tr, this message translates to:
  /// **'Açık Mavi'**
  String get kombinRenkAcikMavi;

  /// No description provided for @kombinRenkNavy.
  ///
  /// In tr, this message translates to:
  /// **'Navy'**
  String get kombinRenkNavy;

  /// No description provided for @kombinSecenekKahverengiOxford.
  ///
  /// In tr, this message translates to:
  /// **'Kahverengi Deri Oxford'**
  String get kombinSecenekKahverengiOxford;

  /// No description provided for @kombinSecenekSiyahDerby.
  ///
  /// In tr, this message translates to:
  /// **'Siyah Deri Derby'**
  String get kombinSecenekSiyahDerby;

  /// No description provided for @kombinSecenekBeyazSpor.
  ///
  /// In tr, this message translates to:
  /// **'Beyaz Spor Ayakkabı'**
  String get kombinSecenekBeyazSpor;

  /// No description provided for @kombinSecenekKahverengiCizme.
  ///
  /// In tr, this message translates to:
  /// **'Kahverengi Çizme'**
  String get kombinSecenekKahverengiCizme;

  /// No description provided for @kombinSecenekSiyahSuGecirmezBot.
  ///
  /// In tr, this message translates to:
  /// **'Siyah Su Geçirmez Bot'**
  String get kombinSecenekSiyahSuGecirmezBot;

  /// No description provided for @kombinSecenekNudeBallerina.
  ///
  /// In tr, this message translates to:
  /// **'Nude Ballerina'**
  String get kombinSecenekNudeBallerina;

  /// No description provided for @kombinSecenekAltinSandalet.
  ///
  /// In tr, this message translates to:
  /// **'Altın Sandalet'**
  String get kombinSecenekAltinSandalet;

  /// No description provided for @kombinSecenekSiyahBlazer.
  ///
  /// In tr, this message translates to:
  /// **'Siyah Blazer'**
  String get kombinSecenekSiyahBlazer;

  /// No description provided for @kombinSecenekKirmiziDeriCeket.
  ///
  /// In tr, this message translates to:
  /// **'Kırmızı Deri Ceket'**
  String get kombinSecenekKirmiziDeriCeket;

  /// No description provided for @kombinSecenekAltinDetayliCeket.
  ///
  /// In tr, this message translates to:
  /// **'Altın Detaylı Ceket'**
  String get kombinSecenekAltinDetayliCeket;

  /// No description provided for @kombinSecenekBeyazPufy.
  ///
  /// In tr, this message translates to:
  /// **'Beyaz Pufy Ceket'**
  String get kombinSecenekBeyazPufy;

  /// No description provided for @kombinSecenekBeyazKosu.
  ///
  /// In tr, this message translates to:
  /// **'Beyaz Koşu Ayakkabısı'**
  String get kombinSecenekBeyazKosu;

  /// No description provided for @kombinSecenekSiyahBasketbol.
  ///
  /// In tr, this message translates to:
  /// **'Siyah Basketbol Ayakkabısı'**
  String get kombinSecenekSiyahBasketbol;

  /// No description provided for @kombinSecenekMaviTerlik.
  ///
  /// In tr, this message translates to:
  /// **'Mavi Terlik'**
  String get kombinSecenekMaviTerlik;

  /// No description provided for @kombinSecenekKahverengiLoafer.
  ///
  /// In tr, this message translates to:
  /// **'Kahverengi Loafer'**
  String get kombinSecenekKahverengiLoafer;

  /// No description provided for @kombinSecenekBeyazBespan.
  ///
  /// In tr, this message translates to:
  /// **'Beyaz Beşpan'**
  String get kombinSecenekBeyazBespan;

  /// No description provided for @kombinSecenekSiyahGunes.
  ///
  /// In tr, this message translates to:
  /// **'Siyah Güneş Gözlüğü'**
  String get kombinSecenekSiyahGunes;

  /// No description provided for @kombinSecenekSiyahSirtCantasi.
  ///
  /// In tr, this message translates to:
  /// **'Siyah Sırt Çantası'**
  String get kombinSecenekSiyahSirtCantasi;

  /// No description provided for @kombinSecenekGumusAkilliSaat.
  ///
  /// In tr, this message translates to:
  /// **'Gümüş Akıllı Saat'**
  String get kombinSecenekGumusAkilliSaat;

  /// No description provided for @kombinSecenekKamelCifteYaka.
  ///
  /// In tr, this message translates to:
  /// **'Kamel Renkli Çifte Yaka'**
  String get kombinSecenekKamelCifteYaka;

  /// No description provided for @kombinSecenekSiyahBomber.
  ///
  /// In tr, this message translates to:
  /// **'Siyah Bomber'**
  String get kombinSecenekSiyahBomber;

  /// No description provided for @kombinSecenekKirmiziPufy.
  ///
  /// In tr, this message translates to:
  /// **'Kırmızı Pufy'**
  String get kombinSecenekKirmiziPufy;

  /// No description provided for @kombinSecenekYesilDenim.
  ///
  /// In tr, this message translates to:
  /// **'Yeşil Denim Ceket'**
  String get kombinSecenekYesilDenim;

  /// No description provided for @kombinSecenekKahverengiKemer.
  ///
  /// In tr, this message translates to:
  /// **'Kahverengi Kemer'**
  String get kombinSecenekKahverengiKemer;

  /// No description provided for @kombinSecenekSiyahKemer.
  ///
  /// In tr, this message translates to:
  /// **'Siyah Kemer'**
  String get kombinSecenekSiyahKemer;

  /// No description provided for @kombinSecenekNavyBlokSal.
  ///
  /// In tr, this message translates to:
  /// **'Navy Blok Şal'**
  String get kombinSecenekNavyBlokSal;

  /// No description provided for @kombinSecenekKahverengiGozluk.
  ///
  /// In tr, this message translates to:
  /// **'Kahverengi Gözlük'**
  String get kombinSecenekKahverengiGozluk;

  /// No description provided for @kombinSecenekGriSuGecirmez.
  ///
  /// In tr, this message translates to:
  /// **'Gri Su Geçirmez Koşu'**
  String get kombinSecenekGriSuGecirmez;

  /// No description provided for @kombinSecenekKahverengiTrekking.
  ///
  /// In tr, this message translates to:
  /// **'Kahverengi Trekking Botu'**
  String get kombinSecenekKahverengiTrekking;

  /// No description provided for @kombinSecenekSiyahTerlik.
  ///
  /// In tr, this message translates to:
  /// **'Siyah Terlik'**
  String get kombinSecenekSiyahTerlik;

  /// No description provided for @kombinSecenekBeyazTenis.
  ///
  /// In tr, this message translates to:
  /// **'Beyaz Tenis Ayakkabısı'**
  String get kombinSecenekBeyazTenis;

  /// No description provided for @kombinOyunBitti.
  ///
  /// In tr, this message translates to:
  /// **'Oyun Bitti'**
  String get kombinOyunBitti;

  /// No description provided for @kombinToplamPuan.
  ///
  /// In tr, this message translates to:
  /// **'Toplam Puan'**
  String get kombinToplamPuan;

  /// No description provided for @kombinBasariOrani.
  ///
  /// In tr, this message translates to:
  /// **'Başarı Oranı'**
  String get kombinBasariOrani;

  /// No description provided for @kombinTekrarOyna.
  ///
  /// In tr, this message translates to:
  /// **'Tekrar Oyna'**
  String get kombinTekrarOyna;

  /// No description provided for @kombinAnaSayfa.
  ///
  /// In tr, this message translates to:
  /// **'Ana Sayfa'**
  String get kombinAnaSayfa;

  /// No description provided for @kombinSonucUsta.
  ///
  /// In tr, this message translates to:
  /// **'Stil Ustası! 🏆'**
  String get kombinSonucUsta;

  /// No description provided for @kombinSonucUstaMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Renk ve uyum hissini ödüllemeye değer!'**
  String get kombinSonucUstaMesaj;

  /// No description provided for @kombinSonucIyi.
  ///
  /// In tr, this message translates to:
  /// **'İyi Gidiyorsun! 👍'**
  String get kombinSonucIyi;

  /// No description provided for @kombinSonucIyiMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Az pratikle mükemmel olacaksın.'**
  String get kombinSonucIyiMesaj;

  /// No description provided for @kombinSonucPratik.
  ///
  /// In tr, this message translates to:
  /// **'Pratik Lazım 📚'**
  String get kombinSonucPratik;

  /// No description provided for @kombinSonucPratikMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Renk teorisi ipuçları için \"Analiz\" sekmesine bak.'**
  String get kombinSonucPratikMesaj;

  /// No description provided for @degerlendirmeBaslik.
  ///
  /// In tr, this message translates to:
  /// **'FitCheck\'i beğendiniz mi?'**
  String get degerlendirmeBaslik;

  /// No description provided for @degerlendirmeIcerik.
  ///
  /// In tr, this message translates to:
  /// **'Uygulamayı seviyorsanız 5 saniyenizi ayırıp bize yorum bırakabilir misiniz? Küçük yorumlar büyük destek! ⭐ Değerlendirme yapanlara +3 hak hediye!'**
  String get degerlendirmeIcerik;

  /// No description provided for @degerlendirmeEvet.
  ///
  /// In tr, this message translates to:
  /// **'Evet, değerlendireyim'**
  String get degerlendirmeEvet;

  /// No description provided for @degerlendirmeBelkiSonra.
  ///
  /// In tr, this message translates to:
  /// **'Belki sonra'**
  String get degerlendirmeBelkiSonra;

  /// No description provided for @yakinda.
  ///
  /// In tr, this message translates to:
  /// **'Yakında'**
  String get yakinda;

  /// No description provided for @yakindaAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Bu özellik üzerinde çalışıyoruz, çok yakında sizlerle!'**
  String get yakindaAciklama;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'ar',
        'de',
        'en',
        'es',
        'fr',
        'it',
        'ja',
        'ko',
        'pt',
        'ru',
        'tr',
        'zh'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'tr':
      return AppLocalizationsTr();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
