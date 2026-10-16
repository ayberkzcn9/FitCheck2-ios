// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get chatOrtamCasual => 'Casual';

  @override
  String get chatOrtamOfis => 'Office';

  @override
  String get chatOrtamDavet => 'Party';

  @override
  String get chatOrtamSpor => 'Sport';

  @override
  String get chatOrtamGece => 'Night Out';

  @override
  String get chatOrtamRomantik => 'Romantic';

  @override
  String get chatOrtamHaftaSonu => 'Weekend';

  @override
  String get gardirobumAdimArkaplan => 'Removing Background';

  @override
  String get gardirobumAdimArkaplanAlt => 'Analyzing the image with AI';

  @override
  String get gardirobumAdimAnaliz => 'Analyzing the Garment';

  @override
  String get gardirobumAdimAnalizAlt => 'Detecting color, style and category';

  @override
  String get gardirobumAdimKaydet => 'Saving';

  @override
  String get gardirobumAdimKaydetAlt => 'Adding to your wardrobe';

  @override
  String get gardirobumLutfenBekleyin => 'Please wait...';

  @override
  String get authHataZayifSifre =>
      'The password is too weak. It must be at least 6 characters.';

  @override
  String get authHataEpostaKullanimda =>
      'This email address is already in use.';

  @override
  String get authHataGecersizEposta => 'You entered an invalid email address.';

  @override
  String get authHataKullaniciBulunamadi =>
      'No user found for this email address.';

  @override
  String get authHataYanlisSifre => 'Incorrect password, please try again.';

  @override
  String get authHataGecersizKimlik =>
      'Incorrect email or password. Please check your details.';

  @override
  String get authHataYontemIzinliDegil =>
      'This sign-in method is not enabled in the Firebase Console.';

  @override
  String get authHataFarkliYontem =>
      'This email is already registered with a different sign-in method.';

  @override
  String get authHataAgHatasi =>
      'Check your internet connection and try again.';

  @override
  String get authHataCokDeneme =>
      'Too many attempts. Please try again a little later.';

  @override
  String get authHataHesapDevreDisi => 'This account has been disabled.';

  @override
  String get authHataYenidenGiris =>
      'You need to sign in again to complete this action.';

  @override
  String get authHataGenel => 'Something went wrong. Please try again.';

  @override
  String get authHataSifreEpostasiGonderilemedi =>
      'Could not send the password reset email. Please try again.';

  @override
  String get authHataGoogleDogrulanamadi =>
      'Google sign-in could not be verified. Please try again.';

  @override
  String get authHataGoogleFarkliKullanici =>
      'This Google account is linked to another user.';

  @override
  String get authHataGoogleZatenBagli =>
      'This Google account is already linked.';

  @override
  String get authHataGoogleYapilandirilmamis =>
      'Google sign-in is not configured on this device. Please report this to support.';

  @override
  String get authHataGooglePencereAcik =>
      'The Google sign-in window is still open. Wait a few seconds and try again.';

  @override
  String get authHataGoogleTamamlanamadi =>
      'Google sign-in could not be completed. Please try again in a few seconds.';

  @override
  String get authHataGoogleHesapSec =>
      'You need to select your Google account to sign in.';

  @override
  String get authHataGoogleOnayBekliyor =>
      'There is a pending action on your Google account. Please try again.';

  @override
  String get authHataGoogleBeklenmeyen =>
      'An unexpected error occurred during Google sign-in. Please try again.';

  @override
  String get appTitle => 'FitCheck';

  @override
  String get gorunumVeTema => 'Appearance and Theme';

  @override
  String get karanlikMod => 'Dark Mode';

  @override
  String get koyuTemaAktif => 'Dark Theme Active';

  @override
  String get acikTemaAktif => 'Light Theme Active';

  @override
  String get dilAyarlari => 'Language and Region Settings';

  @override
  String get uygulamaDili => 'App Language';

  @override
  String get hakkinda => 'About App';

  @override
  String get surum => 'Version';

  @override
  String get ayarOtomatikCihazDili => '🌐 Automatic (Device Language)';

  @override
  String get iptal => 'Cancel';

  @override
  String get tamam => 'OK';

  @override
  String get gardirobumTitle => 'MY VIRTUAL WARDROBE';

  @override
  String get gardirobumYukleniyor => 'AI Analyzing...';

  @override
  String get gardirobumTopluEkle => 'Add Bulk Items';

  @override
  String gardirobumInceleniyor(Object kacinci, Object toplam) {
    return 'Analyzing ($kacinci/$toplam)';
  }

  @override
  String get gardirobumTemizleBaslik => 'Clear Wardrobe';

  @override
  String get gardirobumTemizleOnay =>
      'All items in your wardrobe will be deleted. Are you sure?';

  @override
  String get gardirobumEvet => 'Yes, Clear All';

  @override
  String get gardirobumHataMesaji => 'An error occurred while adding items.';

  @override
  String get gardirobumKategoriTumu => 'All';

  @override
  String get gardirobumKategoriUst => 'Tops';

  @override
  String get gardirobumKategoriAlt => 'Bottoms';

  @override
  String get gardirobumKategoriAyakkabi => 'Shoes';

  @override
  String get gardirobumKategoriAksesuar => 'Accessories';

  @override
  String get gardirobumBosKategori => 'No items found in this category.';

  @override
  String get gardirobumGiymeSayisi => 'Worn:';

  @override
  String gardirobumMaliyet(Object tutar) {
    return 'Cost: ₺$tutar / wear';
  }

  @override
  String get gardirobumDolabaAl => 'Put in Wardrobe';

  @override
  String get gardirobumSepeteAt => 'Move to Basket';

  @override
  String get gardirobumSepetteRozet => 'IN LAUNDRY';

  @override
  String get gardirobumGecersizParcaBaslik => 'Invalid Item Detected';

  @override
  String get gardirobumGecersizParcaIcerik =>
      'Our system could not detect any clothing, shoes, or accessories in this image (Wooden object, furniture, household item, or incompatible object detected). Please upload only wardrobe items.';

  @override
  String get gardirobumTamam => 'OK';

  @override
  String get stilistTitle => 'INSTANT OUTFIT STYLIST';

  @override
  String get gunlukKombinTitle => 'DAILY OUTFIT';

  @override
  String get gunlukKombinHazirBaslik => 'Ready For Your Outfit?';

  @override
  String get gunlukKombinHazirIcerik =>
      'Roll the dice or shake your phone to create today\'s outfit.';

  @override
  String get gunlukKombinKartBaslik => 'Today\'s Outfit';

  @override
  String get stilistAnlikHavaDurumu => 'Current Weather (Tap to refresh)';

  @override
  String get stilistKonumKontrol => 'Checking location...';

  @override
  String get stilistNereyeGidiyorsun => 'Where are you going?';

  @override
  String get stilistDusunuyor => 'Stylist Thinking...';

  @override
  String get stilistBugunNeGiymeliyim => 'What Should I Wear Today?';

  @override
  String get stilistKombiniTemizle => 'Clear Outfit';

  @override
  String stilistKombininTitle(Object ortam) {
    return 'Your $ortam Outfit';
  }

  @override
  String stilistUyum(Object puan) {
    return '🎨 Match: %$puan';
  }

  @override
  String get stilistUstGiyim => 'Top Wear';

  @override
  String get stilistAltGiyim => 'Bottom Wear';

  @override
  String get stilistAyakkabi => 'Shoes';

  @override
  String get stilistAksesuar => 'Accessories';

  @override
  String get stilistFavoriyeEkle => 'Add to Favorites';

  @override
  String get stilistBugunGiydim => 'Wore Today';

  @override
  String get bugunGiydimOnayIcerik => 'Did you wear this outfit today?';

  @override
  String get stilistTrendyolTamamla => 'Complete on Trendyol';

  @override
  String get stilistHata => 'An error occurred while generating the outfit.';

  @override
  String get ortamCasual => 'Casual / Everyday';

  @override
  String get ortamOfis => 'Office / Work';

  @override
  String get ortamDavet => 'Wedding / Event';

  @override
  String get ortamSpor => 'Sports / Workout';

  @override
  String get ortamGece => 'Night Out';

  @override
  String get ortamRomantik => 'Romantic Date';

  @override
  String get stilistUyariDolapBosBaslik =>
      'Your Wardrobe is Empty or All Items are in the Laundry! 🧺';

  @override
  String get stilistUyariDolapBosIcerik =>
      'To get personalized instant outfit recommendations, please add some clean clothes or accessories to your closet.';

  @override
  String get stilistUyariUstEksikBaslik => 'Missing Tops! 👕';

  @override
  String get stilistUyariUstEksikIcerik =>
      'You have no clean tops in your wardrobe. Add at least one top item to complete an outfit!';

  @override
  String get stilistUyariAltEksikBaslik => 'Missing Bottoms! 👖';

  @override
  String get stilistUyariAltEksikIcerik =>
      'You have no clean bottoms in your wardrobe. Add a bottom item to create a stylish outfit!';

  @override
  String get stilistUyariAyakkabiEksikBaslik => 'Missing Shoes! 👟';

  @override
  String get stilistUyariAyakkabiEksikIcerik =>
      'Your outfit looks great, but we couldn\'t find clean shoes to complete it. Add a pair of shoes to your wardrobe now!';

  @override
  String get stilistUyariButon => 'Got it, Adding!';

  @override
  String get anaHavaYukleniyor => 'Loading location weather...';

  @override
  String get anaDinliyor => '🎙️ FITCHECK is Listening... Speak now!';

  @override
  String get anaMikrofonHata =>
      'Microphone permission or speech recognition service is not ready.';

  @override
  String anaCinsiyetGuncellendi(Object cinsiyet) {
    return 'Your preference was updated to \"$cinsiyet\" ✨';
  }

  @override
  String get anaKonumKapaliBaslik => 'Location Service Disabled';

  @override
  String get anaKonumKapaliIcerik =>
      'You need to turn on GPS location to receive weather-based outfit recommendations.';

  @override
  String get anaKonumuAc => 'Enable Location';

  @override
  String get anaIzinVer => 'Allow';

  @override
  String get anaIptal => 'Cancel';

  @override
  String get anaKonumIzinRedBaslik => 'Location Permission Denied';

  @override
  String get anaKonumIzinRedIcerik1 =>
      'Unable to fetch forecast as permission was not granted.';

  @override
  String get anaKonumIzinRedIcerik2 =>
      'You must enable permissions in system settings.';

  @override
  String get anaKonumIzinGerekliBaslik => 'Location Permission Required';

  @override
  String get anaKonumIzinGerekliIcerik =>
      'You must activate location permissions in settings so the app can fetch the weather forecast.';

  @override
  String get anaHavaDurumuAlinamadi => 'Weather information unavailable';

  @override
  String get anaHavaTahminiYuklenemedi => 'Could not load weather forecast.';

  @override
  String get anaFavoriEklendi => 'Outfit added to favorites! ⭐';

  @override
  String get anaKombinTekrarUyari =>
      '⚠️ Warning: You\'ve worn these items or similar ones very often recently. Try a different style today!';

  @override
  String get anaKombinMukemmel =>
      '✨ Great choice! Your style is well-balanced and fresh today.';

  @override
  String get anaYikamaUyariBaslik => 'Smart Wash Alert';

  @override
  String anaYikamaUyariIcerik(Object parcalar) {
    return 'Because you wore this outfit, the item(s) \"$parcalar\" were used frequently and automatically moved to the laundry basket! 🧺';
  }

  @override
  String get anaTamam => 'OK';

  @override
  String get anaAyarlarTooltip => 'Settings';

  @override
  String get anaKadin => 'Woman';

  @override
  String get anaErkek => 'Man';

  @override
  String get anaSesleKonus => 'Voice Command';

  @override
  String get anaStilistAsistani => 'Stylist Assistant';

  @override
  String get anaSekmeGardirop => 'Wardrobe';

  @override
  String get anaSekmeHaftalik => 'Weekly';

  @override
  String get anaSekmeAnlik => 'Instant';

  @override
  String get anaSekmeYarismasi => 'Quiz';

  @override
  String get anaSekmeProfil => 'Profile & Insights';

  @override
  String get modaYarismasiBaslik => 'Fashion & Color Match';

  @override
  String get modaYarismasiGunlukTamamlandi => 'Today\'s quiz is complete';

  @override
  String get modaYarismasiYeniYarin =>
      'A new 5-question set will be available tomorrow.';

  @override
  String get modaYarismasiSonuc => 'Result';

  @override
  String modaYarismasiSkor(Object skor) {
    return 'Score: $skor / 10';
  }

  @override
  String modaYarismasiSoru(Object index) {
    return 'Question $index / 10';
  }

  @override
  String get modaYarismasiGeri => 'Back';

  @override
  String get modaYarismasiAnaEkrana => 'Back to Home';

  @override
  String get havaParcaliBulutlu => 'Partly Cloudy';

  @override
  String get havaSicakGunesli => 'Hot & Sunny';

  @override
  String get havaSogukKarli => 'Cold & Snowy';

  @override
  String get havaYagmurlu => 'Rainy';

  @override
  String get havaGunesli => 'Sunny';

  @override
  String get havaSoguk => 'Cold';

  @override
  String get gunPzt => 'Monday';

  @override
  String get gunSal => 'Tuesday';

  @override
  String get gunCar => 'Wednesday';

  @override
  String get gunPer => 'Thursday';

  @override
  String get gunCum => 'Friday';

  @override
  String get gunCmt => 'Saturday';

  @override
  String get gunPaz => 'Sunday';

  @override
  String get stilKahveBaslik => '☕ Coffee & Casual';

  @override
  String get stilKahveSoru =>
      'Suggest a stylish casual outfit for grabbing coffee with friends';

  @override
  String get stilOfisBaslik => '💼 Work / Office Elegance';

  @override
  String get stilOfisSoru =>
      'Suggest a modern, chic outfit suitable for an office environment';

  @override
  String get stilSporBaslik => '🏃 Sporty / Comfy Wear';

  @override
  String get stilSporSoru =>
      'Suggest a very comfortable and sporty outfit for a weekend trip';

  @override
  String get stilGeceBaslik => '🌙 Night Out / Evening Event';

  @override
  String get stilGeceSoru =>
      'Suggest a bold outfit for a dinner date or special event';

  @override
  String get ilkGorevBaslik => '🎯 First Mission: Pick Your Style!';

  @override
  String get ilkGorevAciklama =>
      'FitCheck AI will instantly generate an outfit for you. Where are you heading today?';

  @override
  String get haftalikUyariButon => 'Got it';

  @override
  String get haftalikUyariDolapBosBaslik => 'Your Wardrobe is Empty!';

  @override
  String get haftalikUyariDolapBosIcerik =>
      'You need to add clothes to your closet to create a weekly plan.';

  @override
  String get haftalikUyariUstEksikBaslik => 'Missing Tops!';

  @override
  String get haftalikUyariUstEksikIcerik =>
      'You have no clean tops in your closet.';

  @override
  String get haftalikUyariAltEksikBaslik => 'Missing Bottoms!';

  @override
  String get haftalikUyariAltEksikIcerik =>
      'You have no clean bottoms in your closet.';

  @override
  String get haftalikUyariAyakkabiEksikBaslik => 'Missing Shoes!';

  @override
  String get haftalikUyariAyakkabiEksikIcerik =>
      'There are no clean shoes in your closet.';

  @override
  String get haftalikHata =>
      'An error occurred while creating the weekly plan.';

  @override
  String get haftalikAjandaTitle => 'WEEKLY STYLE PLANNER';

  @override
  String get haftalikAnlikHavaDurumu => 'Weekly Weather Forecast';

  @override
  String get haftalikKonumKontrol => 'Loading weather...';

  @override
  String get haftalikTemizParca => 'Clean Items';

  @override
  String get haftalikSepette => 'In Laundry';

  @override
  String get haftalikPlanAciklama =>
      'Let AI prepare a 7-day outfit plan based on the weather forecast.';

  @override
  String get haftalikProgramOlustur => 'Create Weekly Schedule';

  @override
  String get haftalikPlaniTemizle => 'Clear Plan';

  @override
  String get haftalikAnalizEdiliyor => 'AI is Planning...';

  @override
  String get haftalikUyum => 'Match';

  @override
  String get haftalikFavoriEkle => 'Add to Favorites';

  @override
  String get haftalikGiyildiIsaretle => 'Wore Today';

  @override
  String get haftalikHava => 'Weather:';

  @override
  String get haftalikHavaUyarisi =>
      'Note: Some pieces in this outfit were updated to match the weather of that day.';

  @override
  String get haftalikUyumsuzParca => 'Missing Item';

  @override
  String get haftalikEksikParcaStilistNotu =>
      'The stylist worked around the missing piece and built the recommendations with the clean items you have.';

  @override
  String get haftalikEksikParcaYeterliParcaYok =>
      'There are not enough clean pieces left to fill this day. Add a new piece to your closet or do the laundry, and the stylist will suggest a new outfit here.';

  @override
  String get haftalikEksikParcaAiOnerisi => 'AI Outfit Suggestion';

  @override
  String get haftalikEksikParcaOneriYok =>
      'Refresh the plan to see a top, bottom and shoes combination that completes the missing piece.';

  @override
  String get haftalikEksikParcaOnerisiBaslik => 'AI Stylist Outfit Suggestion';

  @override
  String get haftalikEksikParcaOneriHazirlaniyor =>
      'The stylist is preparing an outfit suggestion…';

  @override
  String get haftalikEksikParcaPlanKurulamadi =>
      'An outfit cannot be built without a top and a bottom. The stylist prepared a suggestion above.';

  @override
  String get haftalikNot => 'Note';

  @override
  String get haftalikTrendyolAra => 'Search on Trendyol';

  @override
  String get izinZorunluMesaj =>
      'These permissions are required to use the application.';

  @override
  String get izinGerekliBaslik => 'Permissions Required';

  @override
  String get izinGerekliIcerik =>
      'Camera and location permissions were denied. Please enable them in settings.';

  @override
  String get ayarlaraGit => 'Go to Settings';

  @override
  String get izinAnaBaslik => 'Permissions Needed';

  @override
  String get izinAciklama =>
      'To provide you with the best outfit recommendations, we need location (weather) and camera (photo) permissions.';

  @override
  String get konumIzni => 'Location Permission';

  @override
  String get kameraIzni => 'Camera Permission';

  @override
  String get izinVerDevamEt => 'Allow and Continue';

  @override
  String get gunlukHavaMevcutDegil => 'Weather data unavailable';

  @override
  String get profilAnalizTitle => 'PROFILE & INSIGHTS';

  @override
  String get anlikDurum => 'Current Status';

  @override
  String get toplamParca => 'Total Items';

  @override
  String get favoriKombin => 'Favorite Outfit';

  @override
  String get gardiropDegeri => 'Wardrobe Value';

  @override
  String get ortalamaMaliyet => 'Average Cost';

  @override
  String get kategoriDagilimi => 'Category Breakdown';

  @override
  String get ustGiyim => 'Tops';

  @override
  String get altGiyim => 'Bottoms';

  @override
  String get ayakkabi => 'Shoes';

  @override
  String get disGiyim => 'Outerwear';

  @override
  String get aksesuar => 'Accessories';

  @override
  String get sonGiyecekGecmisi => 'Recently Worn History';

  @override
  String get kayit => 'Record';

  @override
  String get gecmisKombinYok => 'No outfit history recorded yet.';

  @override
  String get parca => 'Items';

  @override
  String get onboardingHosGeldinBaslik => 'Welcome to FitCheck! ✨';

  @override
  String get onboardingDolabiniDijitallestir => 'Digitize Your Wardrobe';

  @override
  String get onboardingDolapAciklama =>
      'Add your clothes in seconds and build your own virtual closet.';

  @override
  String get onboardingHavaDurumu => 'Weather Matching';

  @override
  String get onboardingHavaAciklama =>
      'Get outfit recommendations tailored to the daily weather at your location.';

  @override
  String get onboardingYikama => 'Smart Laundry Tracking';

  @override
  String get onboardingYikamaAciklama =>
      'The app automatically detects frequently worn items and sends them to the laundry basket.';

  @override
  String get onboardingEksikParca => 'Missing Item Suggestions';

  @override
  String get onboardingEksikAciklama =>
      'Identifies missing pieces needed to complete your outfit and offers instant shopping ideas.';

  @override
  String get onboardingAnalitik => 'Advanced Analytics';

  @override
  String get onboardingAnalitikAciklama =>
      'Analyze your closet\'s total value, cost-per-wear, and favorite styling trends.';

  @override
  String get onboardingStilist => 'AI Stylist Assistant';

  @override
  String get onboardingStilistAciklama =>
      'Just say where you\'re going, and AI will prepare the perfect outfit in seconds.';

  @override
  String get onboardingAtla => 'Skip';

  @override
  String get onboardingModaProfiliniz => 'Your Fashion Profile';

  @override
  String get onboardingKadin => 'Female';

  @override
  String get onboardingErkek => 'Male';

  @override
  String get onboardingBasla => 'Get Started';

  @override
  String get onboardingDevamEt => 'Continue';

  @override
  String get cinsiyetBaslik => 'GENDER';

  @override
  String get tarzBaslik => 'DAILY STYLE (MULTIPLE)';

  @override
  String get renkTercihiBaslik => 'COLOR PREFERENCE';

  @override
  String get tenRengiBaslik => 'SKIN TONE PREFERENCE';

  @override
  String get kadin => 'Female';

  @override
  String get erkek => 'Male';

  @override
  String get cinsiyetBelirtilmemis => 'Not specified';

  @override
  String get tarzSpor => 'Sporty';

  @override
  String get tarzKlasik => 'Classic';

  @override
  String get tarzSokakModasi => 'Streetwear';

  @override
  String get tarzMinimalist => 'Minimalist';

  @override
  String get renkKoyuTonlar => 'Dark Tones';

  @override
  String get renkPastel => 'Pastel Colors';

  @override
  String get renkCanli => 'Vibrant Colors';

  @override
  String get renkNotr => 'Neutral';

  @override
  String get tenAcikBeyaz => 'Fair / Light';

  @override
  String get tenBugday => 'Medium / Tan';

  @override
  String get tenEsmerKoyu => 'Dark / Deep';

  @override
  String get hesabinizaGirisYapin => 'Sign In to Your Account';

  @override
  String get yeniHesapOlusturun => 'Create a New Account';

  @override
  String get stilDunyanaTekrarHosGeldin => 'Welcome back to your style world ✨';

  @override
  String get kombinleriniSaklamakIcinKatil =>
      'Join us to save and sync your outfits 🚀';

  @override
  String get girisYap => 'Sign In';

  @override
  String get girisYapGoogle => 'Sign in with Google';

  @override
  String get girisBeniHatirla => 'Remember me';

  @override
  String get girisVeya => 'or';

  @override
  String get kayitOl => 'Sign Up';

  @override
  String get adinizVeyaLakabiniz => 'Your Name or Nickname';

  @override
  String get epostaAdresiniz => 'Email Address';

  @override
  String get sifreniz => 'Password';

  @override
  String get girisYapVeBasla => 'Sign In & Get Started';

  @override
  String get kayitOlVeBasla => 'Sign Up & Get Started';

  @override
  String get misafirOlarakDevamEt => 'Continue as Guest';

  @override
  String get lutfenEpostaVeSifreGiriniz =>
      'Please enter your email and password.';

  @override
  String get lutfenAdiniziGiriniz => 'Please enter your name.';

  @override
  String get kullanimKosullariBaslik => 'Terms of Use and Agreement';

  @override
  String get onaylamakIcinKaydirin => 'Scroll to the end of the text to accept';

  @override
  String get okudumAnladimKabulEdiyorum => 'I Have Read, Understood & Accept';

  @override
  String get kullanimKosullarini => 'the Terms of Use';

  @override
  String get okudumVeOnayliyorum => '.';

  @override
  String get onaylamadanOnceKosullariOkuyun =>
      'Please read the terms of use before agreeing.';

  @override
  String get devamEtmekIcinKosullariKabulEdin =>
      'You must accept the terms of use to continue.';

  @override
  String get kullanimKosullariMetni =>
      'FITCHECK TERMS OF USE AND SERVICE AGREEMENT\n\nLast Updated: August 27, 2026\n\nPlease read these Terms of Use (\"Agreement\") carefully before using the FitCheck mobile application (\"Application\"). By downloading, accessing, or using the Application, you agree to be bound by all the terms in this Agreement.\n\n1. PARTIES AND PURPOSE\nThis Agreement is concluded between the developer of the FitCheck application and the individual user (\"User\") who downloads and uses the Application. The Application offers digital wardrobe management, clothes tracking, weather-appropriate outfit suggestions, and AI-powered style consulting.\n\n2. SCOPE OF SERVICE AND TERMS OF USE\n• Age Limit: You must be at least 13 years old to use the Application.\n• User Information: The user is responsible for the accuracy of name, gender, style, and color preferences provided during profile setup.\n• Advisory Nature: Style scores, purchasing suggestions, and laundry reminders provided by artificial intelligence are strictly advisory.\n• Weather Data: Weather forecasts are fetched based on real-time location. The Company cannot be held liable for discrepancies.\n\n3. INTELLECTUAL PROPERTY AND CONTENT RIGHTS\nYou retain intellectual property rights to the clothing photos you upload. The FitCheck logo, design, software code, and algorithms belong entirely to FitCheck.\n\n4. PRIVACY AND DATA SECURITY\nYour uploaded photos and outfit history are stored locally on your device by default. Location data is only used for real-time weather inquiries.\n\n5. LIMITATION OF LIABILITY\nFitCheck does not guarantee uninterrupted service. It cannot be held responsible for data loss caused by changing devices or deleting the application.\n\n6. CONTACT\nFor questions, reach out via the contact section in the Settings tab or at support@fitcheckapp.com.\n\n--- 📜 END OF AGREEMENT ---\nPlease accept the terms by pressing the button below.';

  @override
  String chatKarsilama(Object hava) {
    return 'Hi there! 👋 It\'s $hava outside today. Shall we put together a great outfit that matches your style? ✨';
  }

  @override
  String get chatGorselGonderildi => 'Image sent.';

  @override
  String get chatAsistanSohbeti => 'Assistant Chat';

  @override
  String get chatModHavaDuyarli =>
      'Smart style suggestions based on the weather';

  @override
  String get chatStilistHazirliyor => 'Stylist is crafting an outfit...';

  @override
  String get chatGorselEklendi => 'Image attached';

  @override
  String get chatTekrarDene => 'Try again';

  @override
  String get chatKamera => 'Camera';

  @override
  String get chatGaleri => 'Choose an image from gallery';

  @override
  String get chatMikrofon => 'Microphone';

  @override
  String get chatGonder => 'Send message';

  @override
  String get chatOneriYagmur => '🌧️ Rainy Day Outfit';

  @override
  String get chatOneriOfis => '💼 Office / Smart Casual';

  @override
  String get chatOneriHaftaSonu => '☕ Weekend Comfort';

  @override
  String get chatOneriKirliSepeti => '🧺 Laundry Basket Check';

  @override
  String get chatDinleniyor => 'Listening...';

  @override
  String get chatBirSeylerYazin => 'Type a message to the assistant...';

  @override
  String get chatKombiniGiydim => 'I Wore This Outfit 👗';

  @override
  String get chatKombinIslendi => 'Outfit recorded for today! 📅';

  @override
  String get chatGorselIncele => 'Examine this image and suggest an outfit.';

  @override
  String get profilAyarlariBaslik => 'PROFILE SETTINGS';

  @override
  String get cinsiyetTercihiBaslik => 'Gender Preference';

  @override
  String get stilAramaHint =>
      'Ex: \'Smart casual with black jacket\', \'Summer dress\'...';

  @override
  String get stilFiltreTumu => 'All Items';

  @override
  String get stilFiltreSadeceTemizler => 'Clean Only';

  @override
  String get stilFiltreSadeceSepet => 'Laundry Only';

  @override
  String get profilFavoriKombinlerTitle => 'My Favorite Outfits';

  @override
  String get profilFavoriKombinYok => 'No favorite outfits added yet.';

  @override
  String get profilYikamaSepetimTitle => 'Laundry Basket';

  @override
  String get profilYikamaSepetimBos =>
      'Your laundry basket is empty, all clothes are clean! ✨';

  @override
  String get profilSepetiBosalt => 'Empty Basket';

  @override
  String get profilSepetiBosaltOnay =>
      'All items will be marked as clean. Do you confirm?';

  @override
  String get profilSepetiBosaltButon => 'Yes, Wash All';

  @override
  String get profilTenRengi => 'Skin Tone / Complexion';

  @override
  String get profilTarzTercihi => 'Style Preference';

  @override
  String get profilRenkPaleti => 'Favorite Color Palette';

  @override
  String get rehberGardiropEkleTitle => 'Add Photo';

  @override
  String get rehberGardiropEkleDesc =>
      'Take or upload photos of your clothing individually or in bulk.';

  @override
  String get rehberAiStilistTitle => 'AI Stylist Assistant';

  @override
  String get rehberAiStilistDesc =>
      'Ask the AI for custom outfits or styling advice.';

  @override
  String get rehberSesliTitle => 'Voice Command';

  @override
  String get rehberSesliDesc =>
      'Simply speak to request outfit recommendations hands-free.';

  @override
  String get rehberAyarlarTitle => 'Settings & Profile';

  @override
  String get rehberAyarlarDesc =>
      'Update your gender, style preferences, and skin tone settings.';

  @override
  String get rehberGardiropNavTitle => 'My Wardrobe';

  @override
  String get rehberGardiropNavDesc =>
      'View all added clothing items organized by categories.';

  @override
  String get rehberHaftalikNavTitle => 'Weekly Planner';

  @override
  String get rehberHaftalikNavDesc =>
      'Plan outfits for 7 days based on upcoming weather forecasts.';

  @override
  String get rehberDolaptanNavTitle => 'AI Outfit Generator';

  @override
  String get rehberDolaptanNavDesc =>
      'Generate instant AI outfit combinations suited for any occasion.';

  @override
  String get rehberKendiNavTitle => 'Custom Outfit Builder';

  @override
  String get rehberKendiNavDesc =>
      'Mix and match items manually to design your custom outfits.';

  @override
  String get rehberProfilNavTitle => 'Profile & Insights';

  @override
  String get rehberProfilNavDesc =>
      'Track wardrobe cost efficiency and manage your laundry basket.';

  @override
  String get simdilikAtla => 'Skip for Now';

  @override
  String get uygulamaIzinleri => 'App Permissions';

  @override
  String get izinEkraniAciklama =>
      'FitCheck needs these permissions to recommend personalized outfits and send laundry/weather alerts.';

  @override
  String get konumIzniAciklama =>
      'For real-time weather-based outfit suggestions';

  @override
  String get kameraIzniAciklama =>
      'To snap photos of clothes and add them to your closet';

  @override
  String get bildirimIzni => 'Notification Permission';

  @override
  String get bildirimIzniAciklama => 'For laundry reminders and weather alerts';

  @override
  String get izinleriVerVeBasla => 'Grant Permissions & Start';

  @override
  String get dahaSonraAyarla => 'Set Up Later';

  @override
  String get gunlukHakBittiBaslik => 'Daily Limit Reached!';

  @override
  String get dahaSonra => 'Later';

  @override
  String get reklamIzleHakKazan => 'Watch Ad (+3 Credit)';

  @override
  String get tebriklerHakEklendi => 'Congratulations! +3 Credit added. ✨';

  @override
  String kombinIsaretlemeKaldirildi(String kombinAdi) {
    return 'Outfit mark removed for \"$kombinAdi\".';
  }

  @override
  String kombinGiydimIsaretlendi(String kombinAdi) {
    return '\"$kombinAdi\" marked as worn today! 👕✨';
  }

  @override
  String get kiyafetDetayi => 'Clothing Details';

  @override
  String get parcaDetayiBaslik => 'ITEM DETAILS';

  @override
  String get farkliParcaSec => 'Choose Different Item';

  @override
  String get farkliUstSec => 'Choose Different Top 👕';

  @override
  String get farkliAltSec => 'Choose Different Bottom 👖';

  @override
  String get farkliAyakkabiSec => 'Choose Different Shoes 👟';

  @override
  String get farkliDisSec => 'Choose Different Outerwear 🧥';

  @override
  String get baskaTemizKiyafetYok =>
      'You don\'t have any other clean clothes\nin this category to swap.';

  @override
  String get planiYenile => 'Refresh Plan';

  @override
  String get havaEtiketi => 'WEATHER';

  @override
  String get yukleniyor => 'Loading...';

  @override
  String get temizle => 'Clear';

  @override
  String get yenidenDegerlendiriliyor => 'Re-evaluating...';

  @override
  String get kombinParcalariBaslik => 'OUTFIT ITEMS';

  @override
  String get parcalariKaydirIpucu =>
      'Swipe left/right for other items in this outfit 👈👉';

  @override
  String zorunluParcaYorumu(Object parcaAdi) {
    return '✨ I styled this outfit centered around $parcaAdi!';
  }

  @override
  String get sihirliDokunus => 'Magic Touch';

  @override
  String get dolabiKaristirEksikUyari =>
      'You need at least 1 clean Top, Bottom, and Shoes to shuffle your closet! 👕👖👟';

  @override
  String get zarlarAtildiYorumu =>
      '🎲 Dice rolled! You discovered a brand new surprising combination.';

  @override
  String get rastgeleKombinTuru => 'Random';

  @override
  String get temizAlternatifYok =>
      'No clean alternative left for this category! 🧺';

  @override
  String get kisiselDokunus => 'Personal Touch';

  @override
  String get aiYeniParcaAnalizEdiyor => 'AI is analyzing the new item... ✨';

  @override
  String get parcaDegisimVarsayilanYorum =>
      '✨ Swapping items created a great overall balance!';

  @override
  String get parcaDegisimHataYorum =>
      '✨ Swapping items tailored this outfit completely to your style!';

  @override
  String get bilgileriDuzenleBaslik => 'Edit Info';

  @override
  String get kiyafetAdiEtiketi => 'Item Name';

  @override
  String get renkEtiketi => 'Color';

  @override
  String get kaydet => 'Save';

  @override
  String get yenidenZarAt => 'Roll Again';

  @override
  String get zarAtKaristir => 'Roll Dice (Shuffle)';

  @override
  String get zarPopupBaslik => 'Shake the Magic Dice!';

  @override
  String get zarPopupAciklama =>
      'Shake your phone or tap the button below to roll the dice and let the app build random outfits from your wardrobe.';

  @override
  String get zarlariAt => 'Roll the Dice';

  @override
  String get zarSalla => 'Shake Dice';

  @override
  String get degistirmekIcinKaydirIpucu =>
      'Swipe left/right or tap items to swap 👈👉';

  @override
  String get favorilerdeEtiketi => 'In Favorites';

  @override
  String get bugunGiydildiEtiketi => 'Worn Today ✨';

  @override
  String get varsayilanKendiAnalizYorumu =>
      'Great choice! The items complement each other in tone and balance.';

  @override
  String get kendiTasarimimBaslik => 'My Own Design';

  @override
  String parcaSecModalBaslik(Object kategori) {
    return 'Select $kategori';
  }

  @override
  String get kendiKombininiTasarlaTitle => 'Design Your Outfit';

  @override
  String get secimleriSifirla => 'Reset Selections';

  @override
  String get kombinHazirAiTavsiyesi =>
      'The outfit looks fantastic! Analyze with AI and save.';

  @override
  String get kombinBaslaIpucu =>
      'What do you want to wear today? Start by selecting pieces.';

  @override
  String get ustAltModu => 'Top + Bottom';

  @override
  String get tekParcaElbiseModu => 'One Piece (Dress)';

  @override
  String get tekParcaElbise => 'One Piece / Dress';

  @override
  String get aksesuarOpsiyonel => 'Accessories (Optional)';

  @override
  String get stilistAnaliziBaslik => 'STYLIST ANALYSIS';

  @override
  String get stilistDegerlendiriyor => 'Stylist Reviewing...';

  @override
  String get aiIleAnalizEtKaydet => 'Analyze with AI & Save';

  @override
  String get bilinmiyor => 'Unknown';

  @override
  String get karmasikSiklik => 'Complex Elegance';

  @override
  String get gecmisiTemizleTitle => 'Clear History';

  @override
  String get gecmisiTemizleOnayIcerik =>
      'Are you sure you want to delete all outfit history? This action cannot be undone.';

  @override
  String get gecmisBasariylaTemizlendi => 'History successfully cleared 🗑️';

  @override
  String get kayitGecmistenSilindi => 'Record deleted from history.';

  @override
  String get kombin => 'Outfit';

  @override
  String get kombinDetayiUst => 'OUTFIT DETAILS';

  @override
  String get giyilenParcalarUst => 'WORN ITEMS';

  @override
  String get detayBulunamadi => 'No details found.';

  @override
  String get henuzFavoriEklemediniz =>
      'You haven\'t added any favorite outfits yet.';

  @override
  String get camasirSepetiTitle => 'Laundry Basket';

  @override
  String get sepetBosTumKiyafetlerTemiz =>
      'The basket is completely empty, all clothes are clean!';

  @override
  String get tumKiyafetlerTemizlendi =>
      'All clothes are washed and moved back to wardrobe 🧺✨';

  @override
  String get tumunuTemizIsaretle => 'Mark All as Clean';

  @override
  String get profilVeAnalizTitle => 'Profile and Analytics';

  @override
  String get harikaGidiyorsun => 'You\'re Doing Great!';

  @override
  String gundurSeridesin(Object gun) {
    return '$gun-Day Streak';
  }

  @override
  String get tumuTemiz => 'All Clean';

  @override
  String kirliParcaSayisi(Object sayi) {
    return '$sayi Dirty Items';
  }

  @override
  String get stilKimligin => 'Your Style Identity';

  @override
  String get dolapVerimliligi => 'Closet Efficiency';

  @override
  String get renkPaletin => 'Your Color Palette';

  @override
  String get dolabinKahramanlari => 'Wardrobe Heroes';

  @override
  String get derinlerdeUnutulanlar => 'Forgotten Staples';

  @override
  String get sonGiyilenler => 'Recently Worn';

  @override
  String get tumunuTemizle => 'Clear All';

  @override
  String get henuzGecmisKaydiYok => 'No history recorded yet.';

  @override
  String kezGiyildi(Object sayi) {
    return 'Worn $sayi times';
  }

  @override
  String get ayarlarTitle => 'Settings';

  @override
  String get hesapVeGuvenlikMerkeziUst => 'ACCOUNT & SECURITY CENTER';

  @override
  String get kullaniciHesabi => 'User Account';

  @override
  String get misafirKullanici => 'Guest User';

  @override
  String get epostaDogrulanmis => 'Email verified';

  @override
  String get esitlemekIcinGirisYapin => 'Sign in to sync across devices.';

  @override
  String get cikisYapTitle => 'Log Out';

  @override
  String get cikisYapOnayIcerik =>
      'Are you sure you want to log out of your account?';

  @override
  String get bagliHesaplarUst => 'CONNECTED ACCOUNTS';

  @override
  String get googleHesabiBagli => 'Google Account Connected';

  @override
  String get googleHesabiniBagla => 'Connect Google Account';

  @override
  String get googleHesabiBaglandi =>
      'Google account successfully connected! 🔗';

  @override
  String get googleHesabiBaglantisiKesildi => 'Google account disconnected.';

  @override
  String get sifreVeGuvenlik => 'Password & Security';

  @override
  String get sifreYenilemeBaglantisiIste => 'Request password reset link';

  @override
  String get sifremiUnuttum => 'Forgot password?';

  @override
  String get sifreDegistirTitle => 'Change Password';

  @override
  String get sifreSifirlamaAciklama =>
      'A password reset link will be sent to the email address linked to your account:';

  @override
  String get epostaAdresi => 'Email Address';

  @override
  String get gecerliBirEpostaGiriniz => 'Enter a valid email address';

  @override
  String sifreEpostasiGonderildi(Object eposta) {
    return 'Password reset email sent to $eposta! ✉️';
  }

  @override
  String get baglantiGonder => 'Send Link';

  @override
  String get hesabiKaliciSilTitle => 'Permanently Delete Account';

  @override
  String get hesabiSilGeriAlinamazUyari =>
      'This action cannot be undone. Your wardrobe data and profile will be permanently erased.';

  @override
  String get hesabiSilOnayKoduMetni => 'Type \"fitcheck\" below to confirm:';

  @override
  String get vazgec => 'Cancel';

  @override
  String get hesabimiSil => 'Delete My Account';

  @override
  String get hesabinizSilindi =>
      'Your account and associated data have been deleted.';

  @override
  String get kisiselStilVeProfilUst => 'PERSONAL STYLE & PROFILE';

  @override
  String get stilVeTarzTercihleri => 'Style & Fitting Preferences';

  @override
  String get secili => 'Selected';

  @override
  String get tenRengiTercihinizUst => 'SKIN TONE PREFERENCE';

  @override
  String get yapayZekaVeStilHassasiyetiUst => 'AI & STYLING ACCURACY';

  @override
  String get stilistKisiligiVeYantitTarziUst =>
      'STYLIST PERSONALITY & RESPONSE STYLE';

  @override
  String get aiKisilikSamimiBaslik => 'Friendly / Casual';

  @override
  String get aiKisilikSamimiAciklama =>
      'Warm, encouraging tone making fashion fun and accessible';

  @override
  String get aiKisilikElestirmenBaslik => 'Professional Fashion Critic';

  @override
  String get aiKisilikElestirmenAciklama =>
      'Technical advice focused on color theory and body proportions';

  @override
  String get aiKisilikMinimalistBaslik => 'Minimalist & Direct';

  @override
  String get aiKisilikMinimalistAciklama =>
      'Concise, straight-to-the-point suggestions without fluff';

  @override
  String get sikiRenkTeorisiUyumModu => 'Strict Color Theory Mode';

  @override
  String get sikiRenkTeorisiAciklama =>
      'When active, AI exclusively adheres to classical color rulebooks';

  @override
  String get bildirimlerVeHatirlaticiUst => 'NOTIFICATIONS & REMINDERS';

  @override
  String get sabahKombinOnerisi => 'Morning Outfit Suggestion';

  @override
  String herSabahBildirimAl(Object saat) {
    return 'Receive daily notifications at $saat';
  }

  @override
  String get bildirimSaatiniOzellestir => 'Customize Notification Time';

  @override
  String get gunlukKombinBildirimSaati => 'Daily outfit notification time';

  @override
  String get sabahBildirimSaatiSec => 'Select morning notification time';

  @override
  String get saatKaydedildiAksama =>
      'Time saved, but notification service could not be reached.';

  @override
  String sabahBildirimiAyarlandi(Object saat) {
    return 'Morning notification scheduled for $saat. ⏰';
  }

  @override
  String get bildirimIzinGerekliUyari =>
      'You need to grant permission in device settings to enable notifications.';

  @override
  String get camasirSepetiUyarilari => 'Laundry Basket Alerts';

  @override
  String get camasirSepetiUyarilariAciklama =>
      'Get smart alerts when your dirty clothes pile up';

  @override
  String get haftalikStilRaporu => 'Weekly Style Report';

  @override
  String get haftalikStilRaporuAciklama =>
      'Get a summary of closet usage every Sunday evening';

  @override
  String get gorunumVeBolgeUst => 'APPEARANCE & REGION';

  @override
  String get lokasyonVeBirimlerUst => 'LOCATION & UNITS';

  @override
  String get sicaklikBirimi => 'Temperature Unit';

  @override
  String get varsayilanSehirBolge => 'Default City / Region';

  @override
  String get sehirOrnekHint => 'Ex: London, New York, Istanbul';

  @override
  String get gpsKullan => 'Use GPS';

  @override
  String get veriVeDepolamaYonetimiUst => 'DATA & STORAGE MANAGEMENT';

  @override
  String get gorselOnbelleginiTemizle => 'Clear Image Cache';

  @override
  String get geciciFotografHafizasiAciklama =>
      'Frees up temporary photo storage space';

  @override
  String get onbellekTemizlendiBasari =>
      'Image cache and temporary files cleared! ✨';

  @override
  String get onbellekTemizlerkenHata =>
      'An issue occurred while clearing cache.';

  @override
  String get gardirobuDisaAktarYedekle => 'Export Wardrobe (Backup)';

  @override
  String get tumKiyafetVeKombinJsonAciklama =>
      'Export all clothing and outfit data as JSON';

  @override
  String get disaAktarilacakVeriYok => 'No wardrobe data found to export. 📭';

  @override
  String get gardiropVerisiKopyalandi =>
      'All wardrobe data copied to clipboard in JSON format! 📋';

  @override
  String get destekVeDegerlendirmeUst => 'SUPPORT & REVIEWS';

  @override
  String get uygulamayiDegerlendirin => 'Rate the App';

  @override
  String get googlePlay5YildizDestek =>
      'Support us by rating 5 stars on Google Play ⭐';

  @override
  String get googlePlayAcilamadi => 'Could not open Google Play.';

  @override
  String get geriBildirimVeDestek => 'Feedback & Support';

  @override
  String get hataBildirVeyaOneri => 'Report a bug or suggest new features';

  @override
  String get islemTamamlanamadi =>
      'The operation could not be completed. Please try again.';

  @override
  String get epostaUygulamasiAcilamadi =>
      'Could not open email app. Please write to ayberkzcn9@gmail.com.';

  @override
  String get gizlilikPolitikasiTitle => 'Privacy Policy';

  @override
  String get veriKullanimiVeGizlilikHaklari =>
      'View data usage and privacy rights';

  @override
  String get sonGuncellemeTarihi => 'Last Updated: August 27, 2026';

  @override
  String get gizlilikMadde1Baslik => '1. Data Collection and Usage';

  @override
  String get gizlilikMadde1Icerik =>
      'FitCheck processes information to optimize your wardrobe management and outfit recommendations. Photos, style, and gender preferences are stored locally on your device.';

  @override
  String get gizlilikMadde2Baslik => '2. Location Permissions';

  @override
  String get gizlilikMadde2Icerik =>
      'Real-time location is processed anonymously via Open-Meteo services solely to fetch weather conditions. Location data is never stored on servers or shared with third parties.';

  @override
  String get gizlilikMadde3Baslik => '3. Voice Assistant and Microphone';

  @override
  String get gizlilikMadde3Icerik =>
      'When using voice-command outfit creation, spoken input is processed instantly into text. Audio recordings are not permanently stored.';

  @override
  String get gizlilikMadde4Baslik => '4. Third-Party Services';

  @override
  String get gizlilikMadde4Icerik =>
      'Firebase and Google AdMob infrastructures are used for performance analytics and ad delivery.';

  @override
  String get anladim => 'Understood';

  @override
  String get stilVeModaTercihleriniz => 'Style & Fashion Preferences';

  @override
  String get stilModalAciklama =>
      'AI will prioritize these style and fit preferences when building outfits.';

  @override
  String get favoriTarzinizUst => 'FAVORITE STYLE';

  @override
  String get giyimKesimiFitUst => 'CLOTHING FIT';

  @override
  String get hesapSilmeUst => 'ACCOUNT DELETION';

  @override
  String get tumBulutVeYerelVeriTemizlenir =>
      'Clears all your cloud and local data';

  @override
  String get hakkindaUst => 'ABOUT';

  @override
  String get topluFotografEkleTooltip => 'Add Bulk Clothing';

  @override
  String get kuponKoduKullanTitle => 'Redeem Coupon Code';

  @override
  String get kuponKoduAciklama =>
      'Enter your coupon code below to get extra outfit credits:';

  @override
  String get kuponKoduHint => 'Ex: VIP2026';

  @override
  String get kuponKullanButon => 'Redeem';

  @override
  String get kuponBasariliMesaji =>
      '🎉 Coupon successfully applied! Credits loaded.';

  @override
  String get kuponKullanilmisUyari =>
      '⚠️ You have already redeemed this coupon code!';

  @override
  String get kuponGecersizUyari => '❌ Invalid coupon code! Please try again.';

  @override
  String get sinirsizIslemHakkiBaslik => 'Unlimited Credits 👑';

  @override
  String kalanHakkinizBaslik(Object hak) {
    return 'Remaining Credits: $hak ⚡';
  }

  @override
  String get sinirsizHakAciklama =>
      'Enjoy unlimited outfit generations and styling analyses with premium privileges.';

  @override
  String get gunlukHakAciklama =>
      'Daily credits reset every day at 00:00. You can watch ads or use coupons to earn more credits.';

  @override
  String get kuponKullan => 'Redeem Coupon';

  @override
  String get hakEklendiTebrikler => 'Congratulations! +3 Credit added. ✨';

  @override
  String get gardirobunDolduTitle => 'Wardrobe Full!';

  @override
  String gardirobunDolduIcerik(Object limit) {
    return 'You have reached your limit of $limit clothing items. Watch a short video to expand your wardrobe capacity by +3 items? 👕';
  }

  @override
  String get reklamIzleSlotEkle => 'Watch Ad (+3 Slots)';

  @override
  String get yeniSlotEklendiTebrikler =>
      'Congratulations! +3 new wardrobe slots added. 🎉';

  @override
  String get gunlukHakBittiTitle => 'Daily Limit Reached!';

  @override
  String get gunlukHakBittiIcerik =>
      'You have used your daily free operations. Watch a short video or enter a coupon code to get new credits! 🛍️';

  @override
  String get kuponGir => 'Enter Coupon';

  @override
  String get anaSemsiyeBildirimBaslik => 'Don\'t Forget Your Umbrella! ☔';

  @override
  String get anaSemsiyeBildirimIcerik =>
      'It looks rainy today, don\'t forget to pick an outfit suitable for wet weather.';

  @override
  String get anaCamasirGunuBildirimBaslik => 'Laundry Day! 🧺';

  @override
  String get anaCamasirGunuBildirimIcerik =>
      'Unwashed clothes have accumulated in your basket. Time to run a load!';

  @override
  String chatZorunluParcaMesaji(Object parca) {
    return '✨ What can I wear with this item? ($parca)';
  }

  @override
  String chatKombinHazirBaslik(Object ortam) {
    return 'Your Outfit is Ready ($ortam)';
  }

  @override
  String get chatKombiniGorButon => 'View Outfit';

  @override
  String get chatStilistKombinTasarlayor =>
      'Stylist is designing the outfit...';

  @override
  String get chatStilistYaziyor => 'Stylist is typing...';

  @override
  String get pazartesi => 'Monday';

  @override
  String get sali => 'Tuesday';

  @override
  String get carsamba => 'Wednesday';

  @override
  String get persembe => 'Thursday';

  @override
  String get cuma => 'Friday';

  @override
  String get cumartesi => 'Saturday';

  @override
  String get pazar => 'Sunday';

  @override
  String get rehberiAtla => 'SKIP GUIDE';

  @override
  String get rehberAnladimBasla => 'Got it, Start!';

  @override
  String get rehberSonrakiAdim => 'Next Step ➔';

  @override
  String get rehberGardirobuDijitallestirBaslik => '📸 Digitize Your Wardrobe';

  @override
  String get rehberGardirobuDijitallestirAciklama =>
      'Tap this button to snap pictures or upload photos from your gallery to build your digital wardrobe.';

  @override
  String get rehberSesliAsistanBaslik => '🎙️ Voice Style Assistant';

  @override
  String get rehberSesliAsistanAciklama =>
      'Use voice commands to ask what to wear or receive instant outfit recommendations.';

  @override
  String get rehberAiStilistBaslik => '✨ AI Stylist Recommendations';

  @override
  String get rehberAiStilistAciklama =>
      'Get tailor-made outfit recommendations based on weather, skin tone, and style preferences with one tap.';

  @override
  String get rehberAyarlarBaslik => '⚙️ Personalization & Settings';

  @override
  String get rehberAyarlarAciklama =>
      'Customize gender, skin tone, color, and theme preferences or revisit the onboarding walkthrough.';

  @override
  String get rehberNavGardirobumBaslik => '👔 My Wardrobe';

  @override
  String get rehberNavGardirobumAciklama =>
      'View, filter, and manage all your clothes cleanly by category.';

  @override
  String get rehberNavHaftalikBaslik => '📅 Weekly Planner';

  @override
  String get rehberNavHaftalikAciklama =>
      'Plan your daily outfits ahead of time matched to 7-day weather forecasts.';

  @override
  String get rehberNavDolaptanBaslik => '🤖 AI Wardrobe Outfits';

  @override
  String get rehberNavDolaptanAciklama =>
      'Let AI generate automatic outfit combinations using your existing clothes based on daily conditions.';

  @override
  String get rehberNavKendiBaslik => '🎨 Build Custom Outfit';

  @override
  String get rehberNavKendiAciklama =>
      'Mix and match tops, bottoms, and shoes manually to create and save your own look.';

  @override
  String get rehberNavProfilBaslik => '📊 Analytics & Laundry';

  @override
  String get rehberNavProfilAciklama =>
      'Check your clothing wear statistics and track unwashed items in the laundry basket.';

  @override
  String get bildirimIzinGerekliBaslik => 'Notification Permission Required';

  @override
  String get bildirimIzinGerekliIcerik =>
      'We recommend turning on notifications to receive laundry reminders, rainy day alerts, and daily styling tips.';

  @override
  String get bildirimGunaydinBaslik => 'Good Morning! ☀️';

  @override
  String get bildirimGunaydinIcerik =>
      'I\'ve tailored a great outfit for today\'s weather forecast. Want to take a look?';

  @override
  String get bildirimKanalGenelBaslik => 'General Notifications';

  @override
  String get bildirimKanalGenelAciklama =>
      'FitCheck general notification updates';

  @override
  String get bildirimKanalGunlukBaslik => 'Daily Outfit Suggestions';

  @override
  String get bildirimKanalGunlukAciklama =>
      'Daily outfit recommendation alerts';

  @override
  String get bildirimKanalYikamaBaslik => 'Laundry Reminders';

  @override
  String get bildirimKanalYikamaAciklama =>
      'Laundry tracking and clothing care reminders';

  @override
  String get bildirimKanalRaporBaslik => 'Weekly Style Reports';

  @override
  String get bildirimKanalRaporAciklama =>
      'Weekly wardrobe and styling summary reports';

  @override
  String get tenRengiAcik => 'Fair / Light';

  @override
  String get tenRengiBugday => 'Medium / Tan';

  @override
  String get tenRengiEsmer => 'Dark / Deep';

  @override
  String get stilStreetwear => 'Streetwear / Casual';

  @override
  String get stilKlasik => 'Classic / Formal';

  @override
  String get stilMinimalist => 'Minimalist';

  @override
  String get stilSpor => 'Sporty / Athleisure';

  @override
  String get stilVintage => 'Vintage / Retro';

  @override
  String get fitSlim => 'Slim Fit';

  @override
  String get fitRegular => 'Regular Fit';

  @override
  String get fitOversize => 'Oversize / Relaxed';

  @override
  String get gardirobumBosBaslik => 'Your Closet is Very Empty!';

  @override
  String get gardirobumGizlendiBaslik => 'Wardrobe Hidden';

  @override
  String get gardirobumGizlendiAciklama =>
      'Tap the eye icon at top-right to view contents';

  @override
  String get gardirobumGoster => 'Show Content';

  @override
  String get gardirobumGizle => 'Hide Content';

  @override
  String get kategoriUst => 'TOPS';

  @override
  String get kategoriAlt => 'BOTTOMS';

  @override
  String get kategoriAyakkabi => 'SHOES';

  @override
  String get kategoriAksesuar => 'ACCESSORIES';

  @override
  String get gardirobumBosAciklama =>
      'Add your first piece of clothing now and see the AI magic.';

  @override
  String get gardirobumAiIslem1 => 'Scanning your wardrobe...';

  @override
  String get gardirobumAiIslem2 => 'Analyzing weather conditions...';

  @override
  String get gardirobumAiIslem3 => 'Calculating color harmony...';

  @override
  String get gardirobumAiIslem4 => 'Selecting the best outfits...';

  @override
  String get gardirobumAiIslem5 => 'Applying finishing touches...';

  @override
  String get gardirobumHakBittiBaslik => 'Daily Limit Reached';

  @override
  String get gardirobumHakBittiAciklama =>
      'You have reached your daily outfit creation limit.';

  @override
  String get gardirobumHakEklendiMesaj =>
      'Congratulations, new outfit credit earned!';

  @override
  String get ayarlariAc => 'Open Settings';

  @override
  String get kiyafetEkle => 'Add Clothing';

  @override
  String get kameraIleCek => 'Take Photo';

  @override
  String get galeridenSecToplu => 'Bulk Select from Gallery';

  @override
  String get kameraIzniGerekliBaslik => 'Camera Permission Required';

  @override
  String get kameraIzniGerekliAciklama =>
      'Please enable camera permission to capture photos.';

  @override
  String get kiyafetDuzenleBaslik => 'Edit Clothing';

  @override
  String get kategori => 'Category';

  @override
  String get evetSil => 'Yes, Delete';

  @override
  String get favorilerdenCikarildi => 'Removed from favorites';

  @override
  String get gardirobumHenuzYokEkle => 'No clothing items added yet. Add now!';

  @override
  String gardirobumMaksFotografUyari(int max) {
    return 'You can select up to $max photos at once.';
  }

  @override
  String gardirobumUrunSayisi(int count) {
    return '$count Items';
  }

  @override
  String kombinUyumYuzdesi(String oran) {
    return '%$oran Match';
  }

  @override
  String get kombinSohbetAc => 'Chat about this outfit';

  @override
  String get kombinSohbetBaslik => 'Outfit Chat';

  @override
  String kombinSohbetAltBaslik(Object gun) {
    return 'Chat about your $gun outfit';
  }

  @override
  String kombinSohbetKarsilama(Object kombin) {
    return 'Let\'s take a closer look at your $kombin outfit together! Ask me anything about colour harmony, the weather or alternative pieces. ✨';
  }

  @override
  String get kombinSohbetOneriUyum => '🤔 Why does this outfit work?';

  @override
  String get kombinSohbetOneriAlternatif => '👟 Suggest an alternative piece';

  @override
  String get kombinSohbetOneriHava => '🌦️ What if the weather changes?';

  @override
  String get kombinSohbetOneriAksesuar => '💍 Give me accessory ideas';

  @override
  String get kombinSohbetAltBaslikAnlik => 'Chat about your instant outfit';

  @override
  String get chatKirliSepetiBos =>
      '🧺 Your laundry basket is empty! Every piece is ready to wear — I can build an outfit whenever you like. ✨';

  @override
  String chatKirliSepetiDoluBaslik(Object sayi) {
    return '🧺 You have **$sayi** items waiting in the laundry basket:';
  }

  @override
  String get chatKirliSepetiDoluNot =>
      'These pieces stay out of your outfit suggestions until they are washed. If you like, I can build a look from your clean items right away.';

  @override
  String get analitikVerileriPaylas => 'Share analytics data';

  @override
  String get analitikVerileriPaylasAciklama =>
      'Anonymous usage data is sent to improve the app experience. Turning this off deletes the analytics data stored on this device.';

  @override
  String get chatKarsilamaHavaYok =>
      'Hi there! 👋 Shall we put together a great outfit that matches your style? ✨';

  @override
  String get premiumBaslik => 'Monthly ad-free plan';

  @override
  String get premiumAciklama =>
      'Enjoy FitCheck without ads. All ads are removed for as long as your subscription is active.';

  @override
  String get premiumOzellikReklamsiz => 'All ads are removed';

  @override
  String get premiumOzellikAylik => 'Renews automatically every month';

  @override
  String get premiumOzellikMagaza => 'Managed through Google Play';

  @override
  String get premiumAktifMesaji =>
      'Premium is active. Ads are turned off for your account.';

  @override
  String get premiumAboneOl => 'Subscribe monthly';

  @override
  String premiumAboneOlFiyatli(String fiyat) {
    return 'Subscribe monthly • $fiyat';
  }

  @override
  String get premiumGeriYukle => 'Restore purchase';

  @override
  String get premiumMagazaHazirDegil =>
      'Google Play is not available right now. Please try again.';

  @override
  String get premiumSatinAlmaBaslatilamadi => 'Purchase could not be started.';

  @override
  String get premiumSatinAlmaBasarisiz => 'Purchase failed.';

  @override
  String get premiumAylikBaslik => 'Monthly Ad-Free Premium';

  @override
  String premiumAylikAltBaslik(String fiyat) {
    return 'Remove ads for $fiyat per month';
  }

  @override
  String premiumGec(String fiyat) {
    return 'Go Premium • $fiyat/month';
  }

  @override
  String get guncellemeBaslik => 'Update required';

  @override
  String get guncellemeAciklama =>
      'A new version of FitCheck is available. Please update the app to continue.';

  @override
  String get guncellemeButonu => 'Update now';

  @override
  String guncellemeYeniSurum(String surum) {
    return 'New version: $surum';
  }

  @override
  String get guncellemeMagazaUrlYok =>
      'The store link could not be opened. Please update the app from the store.';

  @override
  String get premiumUrunBulunamadi =>
      'Subscription info couldn\'t be loaded. Please try again later.';

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
  String get kombinOyunuBaslik => 'Combo Game';

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
  String get degerlendirmeBaslik => 'Enjoying FitCheck?';

  @override
  String get degerlendirmeIcerik =>
      'If you love the app, could you take 5 seconds to leave us a review? Small reviews are a big help! ⭐ Reviewers get +3 free credits as a gift!';

  @override
  String get degerlendirmeEvet => 'Yes, I\'ll review it';

  @override
  String get degerlendirmeBelkiSonra => 'Maybe later';

  @override
  String get yakinda => 'Coming Soon';

  @override
  String get yakindaAciklama =>
      'We\'re working on this feature, it\'s coming very soon!';

  @override
  String get aiOneriHazirlaniyor => 'Preparing a suggestion...';

  @override
  String get haftalikStilistOnerisiHazirlanamadi =>
      'Could not prepare the stylist suggestion. Try again.';

  @override
  String get haftalikAiServisHatasi =>
      'Could not reach the AI service. Check your internet connection and try again.';

  @override
  String get haftalikAiGecerliPlanYok =>
      'The AI did not return a valid plan. Try again.';

  @override
  String get haftalikPlanBeklenmeyenHata =>
      'An unexpected error occurred while creating the plan. Try again.';

  @override
  String get haftalikBugunGiyildi =>
      'Today’s outfit is already worn; no new outfit was created.';

  @override
  String get girisHataKullaniciAdiKisa => 'Enter at least 3 characters';

  @override
  String get girisHataEpostaGecersiz => 'Enter a valid email';

  @override
  String get girisHataSifreKisa => 'Enter at least 6 characters';

  @override
  String get googleKullanicisi => 'Google User';

  @override
  String get premiumEkranBaslik => 'FitCheck Premium';

  @override
  String get dilSecimBaslik => '🌐 Select Language';

  @override
  String get dilSecenekOtomatik => 'Automatic (Device Language)';

  @override
  String get kapat => 'Close';

  @override
  String get bildirimBaslik => 'Notification';

  @override
  String get ayarlarAltbilgi => 'Made with style';

  @override
  String get geriBildirimKonu => 'FitCheck Feedback';
}
