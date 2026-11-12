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
  String get authHataAppleDogrulanamadi =>
      'Apple sign-in could not be verified. Please try again.';

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
  String get ayarOtomatikCihazDili => 'Automatic (Device Language)';

  @override
  String get iptal => 'Cancel';

  @override
  String get tamam => 'OK';

  @override
  String get gardirobumTitle => 'My Virtual Wardrobe';

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
  String get stilistTitle => 'Instant Outfit Stylist';

  @override
  String get gunlukKombinTitle => 'Daily Outfit';

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
    return 'Match: %$puan';
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
      'Your Wardrobe is Empty or All Items are in the Laundry';

  @override
  String get stilistUyariDolapBosIcerik =>
      'To get personalized instant outfit recommendations, please add some clean clothes or accessories to your closet.';

  @override
  String get stilistUyariUstEksikBaslik => 'Missing Tops';

  @override
  String get stilistUyariUstEksikIcerik =>
      'You have no clean tops in your wardrobe. Add at least one top item to complete an outfit';

  @override
  String get stilistUyariAltEksikBaslik => 'Missing Bottoms';

  @override
  String get stilistUyariAltEksikIcerik =>
      'You have no clean bottoms in your wardrobe. Add a bottom item to create a stylish outfit';

  @override
  String get stilistUyariAyakkabiEksikBaslik => 'Missing Shoes';

  @override
  String get stilistUyariAyakkabiEksikIcerik =>
      'Your outfit looks great, but we couldn\'t find clean shoes to complete it. Add a pair of shoes to your wardrobe now';

  @override
  String get stilistUyariButon => 'Got it, Adding';

  @override
  String get anaHavaYukleniyor => 'Loading location weather...';

  @override
  String get anaDinliyor => 'FITCHECK is Listening... Speak now';

  @override
  String get anaMikrofonHata =>
      'Microphone permission or speech recognition service is not ready.';

  @override
  String anaCinsiyetGuncellendi(Object cinsiyet) {
    return 'Your preference was updated to \"$cinsiyet\"';
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
  String get anaFavoriEklendi => 'Outfit added to favorites ⭐';

  @override
  String get anaKombinTekrarUyari =>
      'Warning: You\'ve worn these items or similar ones very often recently. Try a different style today';

  @override
  String get anaKombinMukemmel =>
      'Great choice Your style is well-balanced and fresh today.';

  @override
  String get anaYikamaUyariBaslik => 'Smart Wash Alert';

  @override
  String anaYikamaUyariIcerik(Object parcalar) {
    return 'Because you wore this outfit, the item(s) \"$parcalar\" were used frequently and automatically moved to the laundry basket';
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
  String get stilKahveBaslik => 'Coffee & Casual';

  @override
  String get stilKahveSoru =>
      'Suggest a stylish casual outfit for grabbing coffee with friends';

  @override
  String get stilOfisBaslik => 'Work / Office Elegance';

  @override
  String get stilOfisSoru =>
      'Suggest a modern, chic outfit suitable for an office environment';

  @override
  String get stilSporBaslik => 'Sporty / Comfy Wear';

  @override
  String get stilSporSoru =>
      'Suggest a very comfortable and sporty outfit for a weekend trip';

  @override
  String get stilGeceBaslik => 'Night Out / Evening Event';

  @override
  String get stilGeceSoru =>
      'Suggest a bold outfit for a dinner date or special event';

  @override
  String get ilkGorevBaslik => 'First Mission: Pick Your Style';

  @override
  String get ilkGorevAciklama =>
      'FitCheck AI will instantly generate an outfit for you. Where are you heading today?';

  @override
  String get haftalikUyariButon => 'Got it';

  @override
  String get haftalikUyariDolapBosBaslik => 'Your Wardrobe is Empty';

  @override
  String get haftalikUyariDolapBosIcerik =>
      'You need to add clothes to your closet to create a weekly plan.';

  @override
  String get haftalikUyariUstEksikBaslik => 'Missing Tops';

  @override
  String get haftalikUyariUstEksikIcerik =>
      'You have no clean tops in your closet.';

  @override
  String get haftalikUyariAltEksikBaslik => 'Missing Bottoms';

  @override
  String get haftalikUyariAltEksikIcerik =>
      'You have no clean bottoms in your closet.';

  @override
  String get haftalikUyariAyakkabiEksikBaslik => 'Missing Shoes';

  @override
  String get haftalikUyariAyakkabiEksikIcerik =>
      'There are no clean shoes in your closet.';

  @override
  String get haftalikHata =>
      'An error occurred while creating the weekly plan.';

  @override
  String get haftalikAjandaTitle => 'Weekly Style Planner';

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
  String get profilAnalizTitle => 'Profile & Insights';

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
  String get onboardingHosGeldinBaslik => 'Welcome to FitCheck';

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
  String get stilDunyanaTekrarHosGeldin => 'Welcome back to your style world';

  @override
  String get kombinleriniSaklamakIcinKatil =>
      'Join us to save and sync your outfits';

  @override
  String get girisYap => 'Sign In';

  @override
  String get girisYapGoogle => 'Sign in with Google';

  @override
  String get girisYapApple => 'Sign in with Apple';

  @override
  String get aiOnayVazgec => 'Not now';

  @override
  String get aiBildirimTesekkur => 'Your report was received. Thank you.';

  @override
  String get aiBildirimGonder => 'Report';

  @override
  String get aiBildirimIcerik =>
      'If this AI response seems inappropriate or misleading, report it. The response text is saved for review.';

  @override
  String get aiBildirimBaslik => 'Report response';

  @override
  String get aiYanitBildir => 'Report this response';

  @override
  String get aiOnayKabul => 'Accept and continue';

  @override
  String get aiOnayIcerik =>
      'Your garment photos and text are sent to Google (Gemini) and Groq AI services for style analysis and outfit suggestions. Photos are also processed on our server for background removal. Data is used only to answer your request and is not stored permanently by us. Your explicit consent is required to continue.';

  @override
  String get aiOnayBaslik => 'AI data sharing';

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
  String get kullanimKosullarini => 'Terms of Use';

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
      'FITCHECK TERMS OF USE AND SERVICE AGREEMENT\n\nLast Updated: August 27, 2026\n\nPlease read these Terms of Use (\"Agreement\") carefully before using the FitCheck mobile application (\"Application\"). By downloading, accessing, or using the Application, you agree to be bound by all the terms in this Agreement.\n\n1. PARTIES AND PURPOSE\nThis Agreement is concluded between the developer of the FitCheck application and the individual user (\"User\") who downloads and uses the Application. The Application offers digital wardrobe management, clothes tracking, weather-appropriate outfit suggestions, and AI-powered style consulting.\n\n2. SCOPE OF SERVICE AND TERMS OF USE\n• Age Limit: You must be at least 13 years old to use the Application.\n• User Information: The user is responsible for the accuracy of name, gender, style, and color preferences provided during profile setup.\n• Advisory Nature: Style scores, purchasing suggestions, and laundry reminders provided by artificial intelligence are strictly advisory.\n• Weather Data: Weather forecasts are fetched based on real-time location. The Company cannot be held liable for discrepancies.\n\n3. INTELLECTUAL PROPERTY AND CONTENT RIGHTS\nYou retain intellectual property rights to the clothing photos you upload. The FitCheck logo, design, software code, and algorithms belong entirely to FitCheck.\n\n4. PRIVACY AND DATA SECURITY\nYour uploaded photos and outfit history are stored on your device. When you use AI features, the data described in the Privacy Policy is sent to Gemini and Groq. Location data is only used for real-time weather inquiries. Location data is only used for real-time weather inquiries.\n\n5. LIMITATION OF LIABILITY\nFitCheck does not guarantee uninterrupted service. It cannot be held responsible for data loss caused by changing devices or deleting the application.\n\n6. CONTACT\nFor questions, reach out via the contact section in the Settings tab or at support@fitcheckapp.com.\n\n--- END OF AGREEMENT ---\nPlease accept the terms by pressing the button below.';

  @override
  String chatKarsilama(Object hava) {
    return 'Hi there It\'s $hava outside today. Shall we put together a great outfit that matches your style?';
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
  String get chatOneriYagmur => 'Rainy Day Outfit';

  @override
  String get chatOneriOfis => 'Office / Smart Casual';

  @override
  String get chatOneriHaftaSonu => 'Weekend Comfort';

  @override
  String get chatOneriKirliSepeti => 'Laundry Basket Check';

  @override
  String get chatDinleniyor => 'Listening...';

  @override
  String get chatBirSeylerYazin => 'Type a message to the assistant...';

  @override
  String get chatKombiniGiydim => 'I Wore This Outfit';

  @override
  String get chatKombinIslendi => 'Outfit recorded for today';

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
      'Your laundry basket is empty, all clothes are clean';

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
  String get gunlukHakBittiBaslik => 'Daily Limit Reached';

  @override
  String get dahaSonra => 'Later';

  @override
  String reklamIzleHakKazan(int adet) {
    return 'Watch Ad (+$adet Credit)';
  }

  @override
  String tebriklerHakEklendi(int adet) {
    return 'Congratulations +$adet Credit added.';
  }

  @override
  String kombinIsaretlemeKaldirildi(String kombinAdi) {
    return 'Outfit mark removed for \"$kombinAdi\".';
  }

  @override
  String kombinGiydimIsaretlendi(String kombinAdi) {
    return '\"$kombinAdi\" marked as worn today';
  }

  @override
  String get kiyafetDetayi => 'Clothing Details';

  @override
  String get parcaDetayiBaslik => 'ITEM DETAILS';

  @override
  String get farkliParcaSec => 'Choose Different Item';

  @override
  String get farkliUstSec => 'Choose Different Top';

  @override
  String get farkliAltSec => 'Choose Different Bottom';

  @override
  String get farkliAyakkabiSec => 'Choose Different Shoes';

  @override
  String get farkliDisSec => 'Choose Different Outerwear';

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
      'Swipe left/right for other items in this outfit';

  @override
  String zorunluParcaYorumu(Object parcaAdi) {
    return 'I styled this outfit centered around $parcaAdi';
  }

  @override
  String get sihirliDokunus => 'Magic Touch';

  @override
  String get dolabiKaristirEksikUyari =>
      'You need at least 1 clean Top, Bottom, and Shoes to shuffle your closet';

  @override
  String get zarlarAtildiYorumu =>
      'Dice rolled You discovered a brand new surprising combination.';

  @override
  String get rastgeleKombinTuru => 'Random';

  @override
  String get temizAlternatifYok =>
      'No clean alternative left for this category';

  @override
  String get kisiselDokunus => 'Personal Touch';

  @override
  String get aiYeniParcaAnalizEdiyor => 'AI is analyzing the new item...';

  @override
  String get parcaDegisimVarsayilanYorum =>
      'Swapping items created a great overall balance';

  @override
  String get parcaDegisimHataYorum =>
      'Swapping items tailored this outfit completely to your style';

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
  String get zarPopupBaslik => 'Shake the Magic Dice';

  @override
  String get zarPopupAciklama =>
      'Shake your phone or tap the button below to roll the dice and let the app build random outfits from your wardrobe.';

  @override
  String get zarlariAt => 'Roll the Dice';

  @override
  String get zarSalla => 'Shake Dice';

  @override
  String get degistirmekIcinKaydirIpucu =>
      'Swipe left/right or tap items to swap';

  @override
  String get favorilerdeEtiketi => 'In Favorites';

  @override
  String get bugunGiydildiEtiketi => 'Worn Today';

  @override
  String get varsayilanKendiAnalizYorumu =>
      'Great choice The items complement each other in tone and balance.';

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
      'The outfit looks fantastic Analyze with AI and save.';

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
  String get gecmisBasariylaTemizlendi => 'History successfully cleared';

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
      'The basket is completely empty, all clothes are clean';

  @override
  String get tumKiyafetlerTemizlendi =>
      'All clothes are washed and moved back to wardrobe';

  @override
  String get tumunuTemizIsaretle => 'Mark All as Clean';

  @override
  String get profilVeAnalizTitle => 'Profile and Analytics';

  @override
  String get harikaGidiyorsun => 'You\'re Doing Great';

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
  String get googleHesabiBaglandi => 'Google account successfully connected';

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
    return 'Password reset email sent to $eposta';
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
      'Image cache and temporary files cleared';

  @override
  String get onbellekTemizlerkenHata =>
      'An issue occurred while clearing cache.';

  @override
  String get gardirobuDisaAktarYedekle => 'Export Wardrobe (Backup)';

  @override
  String get tumKiyafetVeKombinJsonAciklama =>
      'Export all clothing and outfit data as JSON';

  @override
  String get disaAktarilacakVeriYok => 'No wardrobe data found to export.';

  @override
  String get gardiropVerisiKopyalandi =>
      'All wardrobe data copied to clipboard in JSON format';

  @override
  String get destekVeDegerlendirmeUst => 'SUPPORT & REVIEWS';

  @override
  String get uygulamayiDegerlendirin => 'Rate the App';

  @override
  String get googlePlay5YildizDestek =>
      'Support us by rating 5 stars on Google Play ⭐';

  @override
  String get appStoreDegerlendirAciklama =>
      'Support us by rating us on the App Store ⭐';

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
  String get gizlilikPolitikasiTamamiAc => 'Open full policy';

  @override
  String get veriKullanimiVeGizlilikHaklari =>
      'View data usage and privacy rights';

  @override
  String get sonGuncellemeTarihi => 'Last Updated: October 20, 2026';

  @override
  String get gizlilikMadde1Baslik => '1. Data Collection and Usage';

  @override
  String get gizlilikMadde1Icerik =>
      'FitCheck processes information to optimize your wardrobe management and outfit recommendations. Photos, style, and gender preferences are stored locally on your device. For AI features, the data described in section 5 is sent to Gemini and Groq.';

  @override
  String get gizlilikMadde2Baslik => '2. Location Permissions';

  @override
  String get gizlilikMadde2Icerik =>
      'When you grant location access, your latitude and longitude are sent to Open-Meteo for weather and to BigDataCloud to identify your city. FitCheck does not store these coordinates on its servers. Each provider\'s data processing is governed by its own privacy policy.';

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
  String get kuponKoduAciklama => 'Enter your coupon code below:';

  @override
  String get kuponKoduHint => 'Coupon code';

  @override
  String get kuponKullanButon => 'Redeem';

  @override
  String get kuponBasariliMesaji => 'Coupon applied';

  @override
  String get kuponKullanilmisUyari =>
      'You have already redeemed this coupon code';

  @override
  String get kuponGecersizUyari => 'Invalid coupon code Please try again.';

  @override
  String get sinirsizIslemHakkiBaslik => 'Unlimited Credits';

  @override
  String kalanHakkinizBaslik(Object hak) {
    return 'Remaining Credits: $hak';
  }

  @override
  String get sinirsizHakAciklama =>
      'Enjoy unlimited outfit generations and styling analyses with premium privileges.';

  @override
  String get gunlukHakAciklama =>
      'Daily credits reset every day at 00:00. You can watch ads to earn more credits.';

  @override
  String get kuponKullan => 'Redeem Coupon';

  @override
  String hakEklendiTebrikler(int adet) {
    return 'Congratulations +$adet Credit added.';
  }

  @override
  String get gardirobunDolduTitle => 'Wardrobe Full';

  @override
  String gardirobunDolduIcerik(int limit, int adet) {
    return 'You have reached your limit of $limit clothing items. Watch a short video to expand your wardrobe capacity by +$adet items?';
  }

  @override
  String reklamIzleSlotEkle(int adet) {
    return 'Watch Ad (+$adet Slots)';
  }

  @override
  String yeniSlotEklendiTebrikler(int adet) {
    return 'Congratulations +$adet new wardrobe slots added.';
  }

  @override
  String get gunlukHakBittiTitle => 'Daily Limit Reached';

  @override
  String get gunlukHakBittiIcerik =>
      'You have used your daily free operations. Watch a short video to get new credits';

  @override
  String get kuponGir => 'Enter Coupon';

  @override
  String get anaSemsiyeBildirimBaslik => 'Don\'t Forget Your Umbrella';

  @override
  String get anaSemsiyeBildirimIcerik =>
      'It looks rainy today, don\'t forget to pick an outfit suitable for wet weather.';

  @override
  String get anaCamasirGunuBildirimBaslik => 'Laundry Day';

  @override
  String get anaCamasirGunuBildirimIcerik =>
      'Unwashed clothes have accumulated in your basket. Time to run a load';

  @override
  String chatZorunluParcaMesaji(Object parca) {
    return 'What can I wear with this item? ($parca)';
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
  String get rehberAnladimBasla => 'Got it, Start';

  @override
  String get rehberSonrakiAdim => 'Next Step';

  @override
  String get rehberGardirobuDijitallestirBaslik => 'Digitize Your Wardrobe';

  @override
  String get rehberGardirobuDijitallestirAciklama =>
      'Tap this button to snap pictures or upload photos from your gallery to build your digital wardrobe.';

  @override
  String get rehberSesliAsistanBaslik => 'Voice Style Assistant';

  @override
  String get rehberSesliAsistanAciklama =>
      'Use voice commands to ask what to wear or receive instant outfit recommendations.';

  @override
  String get rehberAiStilistBaslik => 'AI Stylist Recommendations';

  @override
  String get rehberAiStilistAciklama =>
      'Get tailor-made outfit recommendations based on weather, skin tone, and style preferences with one tap.';

  @override
  String get rehberAyarlarBaslik => 'Personalization & Settings';

  @override
  String get rehberAyarlarAciklama =>
      'Customize gender, skin tone, color, and theme preferences or revisit the onboarding walkthrough.';

  @override
  String get rehberNavGardirobumBaslik => 'My Wardrobe';

  @override
  String get rehberNavGardirobumAciklama =>
      'View, filter, and manage all your clothes cleanly by category.';

  @override
  String get rehberNavHaftalikBaslik => 'Weekly Planner';

  @override
  String get rehberNavHaftalikAciklama =>
      'Plan your daily outfits ahead of time matched to 7-day weather forecasts.';

  @override
  String get rehberNavDolaptanBaslik => 'AI Wardrobe Outfits';

  @override
  String get rehberNavDolaptanAciklama =>
      'Let AI generate automatic outfit combinations using your existing clothes based on daily conditions.';

  @override
  String get rehberNavKendiBaslik => 'Build Custom Outfit';

  @override
  String get rehberNavKendiAciklama =>
      'Mix and match tops, bottoms, and shoes manually to create and save your own look.';

  @override
  String get rehberNavProfilBaslik => 'Analytics & Laundry';

  @override
  String get rehberNavProfilAciklama =>
      'Check your clothing wear statistics and track unwashed items in the laundry basket.';

  @override
  String get bildirimIzinGerekliBaslik => 'Notification Permission Required';

  @override
  String get bildirimIzinGerekliIcerik =>
      'We recommend turning on notifications to receive laundry reminders, rainy day alerts, and daily styling tips.';

  @override
  String get bildirimGunaydinBaslik => 'Good Morning';

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
  String get gardirobumBosBaslik => 'Your Closet is Very Empty';

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
      'Congratulations, new outfit credit earned';

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
  String get gardirobumHenuzYokEkle => 'No clothing items added yet. Add now';

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
    return 'Let\'s take a closer look at your $kombin outfit together Ask me anything about colour harmony, the weather or alternative pieces.';
  }

  @override
  String get kombinSohbetOneriUyum => 'Why does this outfit work?';

  @override
  String get kombinSohbetOneriAlternatif => 'Suggest an alternative piece';

  @override
  String get kombinSohbetOneriHava => 'What if the weather changes?';

  @override
  String get kombinSohbetOneriAksesuar => 'Give me accessory ideas';

  @override
  String get kombinSohbetAltBaslikAnlik => 'Chat about your instant outfit';

  @override
  String get chatKirliSepetiBos =>
      'Your laundry basket is empty Every piece is ready to wear — I can build an outfit whenever you like.';

  @override
  String chatKirliSepetiDoluBaslik(Object sayi) {
    return 'You have **$sayi** items waiting in the laundry basket:';
  }

  @override
  String get chatKirliSepetiDoluNot =>
      'These pieces stay out of your outfit suggestions until they are washed. If you like, I can build a look from your clean items right away.';

  @override
  String get analitikVerileriPaylas => 'Share analytics data';

  @override
  String get analitikVerileriPaylasAciklama =>
      'Usage analytics are sent to Firebase Analytics to understand app usage and improve the experience. This is optional and can be turned off at any time.';

  @override
  String get chatKarsilamaHavaYok =>
      'Hi there Shall we put together a great outfit that matches your style?';

  @override
  String get premiumBaslik => 'Unlimited style, zero ads';

  @override
  String get premiumAciklama =>
      'Use your outfits and style analyses without limits and remove all ads with a single subscription.';

  @override
  String get premiumOzellikReklamsiz => 'All ads are removed';

  @override
  String get premiumOzellikAylik => 'Renews automatically every month';

  @override
  String get premiumOzellikMagaza => 'Managed through Google Play';

  @override
  String get premiumAktifMesaji =>
      'Premium is active. Unlimited use and an ad-free experience are on.';

  @override
  String get premiumAboneOl => 'Subscribe';

  @override
  String premiumAboneOlFiyatli(String fiyat) {
    return 'Subscribe • $fiyat';
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
  String get premiumAylikBaslik => 'FitCheck Premium';

  @override
  String premiumAylikAltBaslik(String fiyat) {
    return 'Unlimited outfits • $fiyat/month';
  }

  @override
  String premiumGec(String fiyat) {
    return 'Go unlimited • $fiyat/mo';
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
      'Which color is in the exact opposite position on the color wheel with tan / orange tones and creates a strong contrast?';

  @override
  String get triviaQ1o1 => 'Sapphire Blue / Petrol Blue';

  @override
  String get triviaQ1o2 => 'Emerald Green';

  @override
  String get triviaQ1o3 => 'Burgundy';

  @override
  String get triviaQ1o4 => 'Mustard Yellow';

  @override
  String get triviaQ2 =>
      'What does the style of \'Monochromatic\' clothing mean in fashion?';

  @override
  String get triviaQ2o1 => 'Using different shades of a single color together';

  @override
  String get triviaQ2o2 => 'Wearing only black and white clothes';

  @override
  String get triviaQ2o3 =>
      'Blending at least 3 contrasting colors at the same time';

  @override
  String get triviaQ2o4 => 'Matching only patterned and printed pieces';

  @override
  String get triviaQ3 =>
      'What skin tone suits gold jewelry, terracotta and olive green best?';

  @override
  String get triviaQ3o1 => 'Cool Undertone';

  @override
  String get triviaQ3o2 => 'Warm Undertone';

  @override
  String get triviaQ3o3 => 'Blue Undertone';

  @override
  String get triviaQ3o4 => 'Pink Undertone';

  @override
  String get triviaQ4 =>
      'Which \'Neutral Colors\' group DOES NOT easily match each color when creating a capsule wardrobe?';

  @override
  String get triviaQ4o1 => 'Beige / Cream';

  @override
  String get triviaQ4o2 => 'Navy';

  @override
  String get triviaQ4o3 => 'Neon Yellow';

  @override
  String get triviaQ4o4 => 'Tan / Brown';

  @override
  String get triviaQ5 =>
      'What is the name of the color group that stands side by side on the color wheel and provides a smooth, eye-catching transition?';

  @override
  String get triviaQ5o1 => 'Complementary (Contrasting) Colors';

  @override
  String get triviaQ5o2 => 'Analog Colors';

  @override
  String get triviaQ5o3 => 'Pastel Colors';

  @override
  String get triviaQ5o4 => 'Triadic Colors';

  @override
  String get triviaQ6 =>
      'What is the \'Rule of Thirds\' applied in fashion to make the body ratio longer and more balanced?';

  @override
  String get triviaQ6o1 => '1/2 Top - 1/2 Bottom (Body and leg equal)';

  @override
  String get triviaQ6o2 => '1/3 Top - 2/3 Bottom (High waist / Short top)';

  @override
  String get triviaQ6o3 => '2/3 Top - 1/3 Bottom (Long tunic / Short bottom)';

  @override
  String get triviaQ6o4 => '3/3 Full-length one-piece';

  @override
  String get triviaQ7 =>
      'What does the French fashion term \'tone-on-tone\' mean?';

  @override
  String get triviaQ7o1 =>
      'Layering different saturation and light/dark nuances of the same color';

  @override
  String get triviaQ7o2 =>
      'Combining two completely opposite colors with sharp lines';

  @override
  String get triviaQ7o3 => 'Mixing black and white patterns';

  @override
  String get triviaQ7o4 => 'Collecting different fabric textures in one color';

  @override
  String get triviaQ8 =>
      'According to classic and formal clothing rules, which leather belt color should match exactly?';

  @override
  String get triviaQ8o1 => 'Tie or Shawl';

  @override
  String get triviaQ8o2 => 'Shirt';

  @override
  String get triviaQ8o3 => 'Shoes';

  @override
  String get triviaQ8o4 => 'Jacket Lining';

  @override
  String get triviaQ9 =>
      'What is the vivid combination style of 3 colors (Ex: Red, Yellow, Blue) evenly spaced on the color wheel?';

  @override
  String get triviaQ9o1 => 'Triadic Color Harmony';

  @override
  String get triviaQ9o2 => 'Neutral Harmony';

  @override
  String get triviaQ9o3 => 'Monochrome Harmony';

  @override
  String get triviaQ9o4 => 'Capsule Transition';

  @override
  String get triviaQ10 =>
      'What visual effect does a shoe that matches your skin tone (nude) or trousers create?';

  @override
  String get triviaQ10o1 => 'It makes the legs look longer and uninterrupted';

  @override
  String get triviaQ10o2 => 'It makes the body look wider';

  @override
  String get triviaQ10o3 => 'It emphasizes shoulder width';

  @override
  String get triviaQ10o4 => 'It makes you look shorter';

  @override
  String get kombinOyunuBaslik => 'Combo Game';

  @override
  String get kombinMevcutKombin => 'Current Outfit';

  @override
  String get kombinParcaUst => 'Top';

  @override
  String get kombinParcaAlt => 'Bottom';

  @override
  String get kombinEksik_ayakkabi => 'Missing: Shoes';

  @override
  String get kombinEksik_ceket => 'Missing: Jacket';

  @override
  String get kombinEksik_aksesuar => 'Missing: Accessories';

  @override
  String get kombinSoru_ayakkabi => 'Which shoes are the best match?';

  @override
  String get kombinSoru_ceket => 'Which jacket fits best?';

  @override
  String get kombinSoru_aksesuar => 'Which accessory fits best?';

  @override
  String get kombinKategoriAyakkabi => 'Shoes';

  @override
  String get kombinKategoriCeket => 'Jacket';

  @override
  String get kombinKategoriAksesuar => 'Accessories';

  @override
  String get kombinOrtamOfis => 'Office';

  @override
  String get kombinOrtamCasual => 'Everyday';

  @override
  String get kombinOrtamDavet => 'Party';

  @override
  String get kombinOrtamSpor => 'Sport';

  @override
  String get kombinHavaGunesli => 'Sunny';

  @override
  String get kombinHavaYagmurlu => 'Rainy';

  @override
  String get kombinHavaSoguk => 'Cold';

  @override
  String get kombinHavaSicak => 'Warm';

  @override
  String get kombinRenkBeyaz => 'White';

  @override
  String get kombinRenkSiyah => 'Black';

  @override
  String get kombinRenkKahverengi => 'Brown';

  @override
  String get kombinRenkLacivert => 'Navy Blue';

  @override
  String get kombinRenkBej => 'Beige';

  @override
  String get kombinRenkKoyuYesil => 'Dark Green';

  @override
  String get kombinRenkNude => 'Skin Tone';

  @override
  String get kombinRenkAltin => 'Gold';

  @override
  String get kombinRenkGri => 'Gray';

  @override
  String get kombinRenkPastelMavi => 'Pastel Blue';

  @override
  String get kombinRenkKirmizi => 'Red';

  @override
  String get kombinRenkMavi => 'Blue';

  @override
  String get kombinRenkGumus => 'Silver';

  @override
  String get kombinRenkKoyuMavi => 'Dark Blue';

  @override
  String get kombinRenkKamel => 'Camel';

  @override
  String get kombinRenkYesil => 'Green';

  @override
  String get kombinRenkAcikMavi => 'Light Blue';

  @override
  String get kombinRenkNavy => 'Navy Blue';

  @override
  String get kombinSecenekKahverengiOxford => 'Brown leather Oxford shoes';

  @override
  String get kombinSecenekSiyahDerby => 'Black Derby shoes';

  @override
  String get kombinSecenekBeyazSpor => 'White sneakers';

  @override
  String get kombinSecenekKahverengiCizme => 'Brown boots';

  @override
  String get kombinSecenekSiyahSuGecirmezBot => 'Black waterproof boots';

  @override
  String get kombinSecenekNudeBallerina => 'Nude ballet flats';

  @override
  String get kombinSecenekAltinSandalet => 'Gold sandals';

  @override
  String get kombinSecenekSiyahBlazer => 'Black blazer';

  @override
  String get kombinSecenekKirmiziDeriCeket => 'Red leather jacket';

  @override
  String get kombinSecenekAltinDetayliCeket => 'Jacket with gold details';

  @override
  String get kombinSecenekBeyazPufy => 'White Pufy puffer jacket';

  @override
  String get kombinSecenekBeyazKosu => 'White running shoes';

  @override
  String get kombinSecenekSiyahBasketbol => 'Black basketball shoes';

  @override
  String get kombinSecenekMaviTerlik => 'Blue slippers';

  @override
  String get kombinSecenekKahverengiLoafer => 'Brown loafers';

  @override
  String get kombinSecenekBeyazBespan => 'White Bespan shoes';

  @override
  String get kombinSecenekSiyahGunes => 'Black sunglasses';

  @override
  String get kombinSecenekSiyahSirtCantasi => 'Black backpack';

  @override
  String get kombinSecenekGumusAkilliSaat => 'Silver smartwatch';

  @override
  String get kombinSecenekKamelCifteYaka => 'Camel double-breasted jacket';

  @override
  String get kombinSecenekSiyahBomber => 'Black bomber jacket';

  @override
  String get kombinSecenekKirmiziPufy => 'Red Pufy puffer jacket';

  @override
  String get kombinSecenekYesilDenim => 'Green denim jacket';

  @override
  String get kombinSecenekKahverengiKemer => 'Brown belt';

  @override
  String get kombinSecenekSiyahKemer => 'Black belt';

  @override
  String get kombinSecenekNavyBlokSal => 'Navy color-block scarf';

  @override
  String get kombinSecenekKahverengiGozluk => 'Brown glasses';

  @override
  String get kombinSecenekGriSuGecirmez => 'Gray waterproof running shoes';

  @override
  String get kombinSecenekKahverengiTrekking => 'Brown trekking boots';

  @override
  String get kombinSecenekSiyahTerlik => 'Black sandals';

  @override
  String get kombinSecenekBeyazTenis => 'White tennis shoes';

  @override
  String get kombinOyunBitti => 'Game Over';

  @override
  String get kombinToplamPuan => 'Total Score';

  @override
  String get kombinBasariOrani => 'Accuracy';

  @override
  String get kombinTekrarOyna => 'Play Again';

  @override
  String get kombinAnaSayfa => 'Home';

  @override
  String get kombinSonucUsta => 'Style Master';

  @override
  String get kombinSonucUstaMesaj =>
      'Your sense of color and coordination deserves a reward';

  @override
  String get kombinSonucIyi => 'You’re Doing Great';

  @override
  String get kombinSonucIyiMesaj => 'A little practice will make you perfect.';

  @override
  String get kombinSonucPratik => 'Keep Practicing';

  @override
  String get kombinSonucPratikMesaj =>
      'Check the Analysis tab for color theory tips.';

  @override
  String get degerlendirmeBaslik => 'Enjoying FitCheck?';

  @override
  String get degerlendirmeIcerik =>
      'If you love the app, could you take 5 seconds to leave us a review? Small reviews are a big help';

  @override
  String get degerlendirmeEvet => 'Yes, I\'ll review it';

  @override
  String get degerlendirmeBelkiSonra => 'Maybe later';

  @override
  String get yakinda => 'Coming Soon';

  @override
  String get yakindaAciklama =>
      'We\'re working on this feature, it\'s coming very soon';

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
  String get dilSecimBaslik => 'Select Language';

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

  @override
  String get premiumOzelliklerBaslik => 'What you unlock with Premium';

  @override
  String get premiumOzellikSinirsizKombin => 'Unlimited outfit creation';

  @override
  String get premiumOzellikSinirsizAnaliz => 'Unlimited AI style analysis';

  @override
  String get premiumOzellikSinirsizGardirob => 'Unlimited wardrobe space';

  @override
  String get premiumPlanAylik => 'Monthly';

  @override
  String get premiumPlanYillik => 'Yearly';

  @override
  String get premiumEnAvantajli => 'BEST VALUE';

  @override
  String premiumTasarrufYuzde(int yuzde) {
    return 'Save $yuzde%';
  }

  @override
  String premiumDenemeRozeti(int gun) {
    return '$gun-DAY FREE TRIAL';
  }

  @override
  String premiumDenemeSonrasi(String fiyat) {
    return 'Then $fiyat';
  }

  @override
  String get premiumYenilemeNotu =>
      'Subscription renews automatically at the end of each period. Cancel anytime.';

  @override
  String get kiyafetDondur => 'Rotate';

  @override
  String get stilistHafizasiBaslik => 'Stylist Memory';

  @override
  String stilistHafizasiAltBaslikNotlu(int sayi) {
    return 'Remembers $sayi notes';
  }

  @override
  String get stilistHafizasiAltBaslikBos => 'Remembers nothing yet';

  @override
  String get stilistHafizasiAciklama =>
      'The stylist stores what it learns in your chats as permanent notes and personalises its suggestions. Notes stay on this device only.';

  @override
  String get stilistHafizasiNelerBiliyor => 'What does it remember?';

  @override
  String get stilistHafizasiOzetBaslik => 'Summary of your recent chats';

  @override
  String get stilistHafizasiBos =>
      'I haven\'t learned anything yet. I will get to know your style as we chat.';

  @override
  String get stilistHafizasiTemizle => 'Clear memory';

  @override
  String get stilistHafizasiTemizleOnay =>
      'Everything the stylist remembers about you will be deleted. This cannot be undone.';

  @override
  String get stilistHafizasiTemizlendi => 'Memory cleared';

  @override
  String get gardirobumArkaPlanSilinemediBaslik => 'Background not removed';

  @override
  String get gardirobumArkaPlanSilinemediAciklama =>
      'There may be a connection problem. Choose whether to try again, save the photo with its background, or skip this photo.';

  @override
  String get gardirobumArkaPlanliKaydet => 'Save with background';

  @override
  String get cekimIpucuBaslik => 'For a better cutout';

  @override
  String get cekimIpucu1 => 'Place the garment on a flat, plain surface.';

  @override
  String get cekimIpucu2 => 'Use a surface colour different from the garment.';

  @override
  String get cekimIpucu3 => 'Avoid shadows and patterned surfaces.';

  @override
  String kullanimKosullariOnayMetni(String terms) {
    return 'I have read and agree to the $terms.';
  }

  @override
  String get kendiTasarimimParcaSec => 'Pick a piece';

  @override
  String get hesapSilmeBasarisiz =>
      'Account deletion could not be completed. Check your connection and try again.';

  @override
  String get bildirimTamZamanAyar => 'Exact-time notifications';

  @override
  String get bildirimTamZamanAciklama =>
      'Allow \'Alarms & reminders\' on Android so notifications arrive exactly at the time you chose.';

  @override
  String get bildirimTamZamanAcik => 'Exact-time notifications are on.';

  @override
  String get premiumSatinAlmaDogrulamaHazirDegil =>
      'Secure store verification is not ready for this platform yet. Purchases are temporarily unavailable.';

  @override
  String get islemIptalEdildi =>
      'Processing cancelled. Clothes added so far remain in your wardrobe.';

  @override
  String get islemIptalEdiliyor => 'Cancelling…';

  @override
  String get sifreGoster => 'Show password';

  @override
  String get sifreGizle => 'Hide password';

  @override
  String get gunSayisiAzalt => 'Decrease number of days';

  @override
  String get gunSayisiArttir => 'Increase number of days';

  @override
  String get chatGorseliKaldir => 'Remove image';

  @override
  String get kesimUyarisiBaslik => 'The cutout may be inaccurate';

  @override
  String get kesimUyarisiAciklama =>
      'The garment colour is very close to the background. Background removal struggles here: some background may remain or part of the garment may be cut off. Retaking the photo on a surface of a different colour usually fixes it.';

  @override
  String get kesimUyarisiTekrarCek => 'Retake photo';

  @override
  String get kesimUyarisiYineDeKaydet => 'Save anyway';

  @override
  String get gizlilikMadde5Baslik => '5. AI Image Analysis';

  @override
  String get gizlilikMadde5Icerik =>
      'Garment photos are processed on our own server to remove the background and sent to Google (Gemini) and Groq AI services for style analysis and outfit suggestions. Photos are processed only to answer your request, are not stored permanently by us and are not used for advertising. The original photo is also sent only for the requested analysis and is not retained permanently by us.';

  @override
  String get bugunSekmesi => 'Today';

  @override
  String get bugunBaslik => 'Today';

  @override
  String get bugunGunaydin => 'Good morning';

  @override
  String get bugunIyiGunler => 'Good afternoon';

  @override
  String get bugunIyiAksamlar => 'Good evening';

  @override
  String get bugunBugununKombini => 'Today\'s outfit';

  @override
  String get bugunNedenBuKombin => 'Why this outfit?';

  @override
  String get bugunRenkUyumu => 'Color harmony';

  @override
  String get kombinHedefiBaslik => 'Your outfit goal';

  @override
  String get kombinHedefiAciklama =>
      'What should new outfit and weekly-plan suggestions prioritize?';

  @override
  String get kombinHedefiDenge => 'Balanced suggestions';

  @override
  String get kombinHedefiRenk => 'Explore color';

  @override
  String get kombinHedefiUnutulan => 'Wear less-used items';

  @override
  String get kombinHedefiCokYonlu => 'Versatile pieces';

  @override
  String get bugunHizliFotograf => 'Add a photo';

  @override
  String get bugunHizliKombin => 'Build an outfit';

  @override
  String get bugunHizliStilist => 'Ask the stylist';

  @override
  String get bugunHizliPlan => 'Plan the week';

  @override
  String get bugunHazirlaniyor => 'Preparing outfits…';

  @override
  String get bugunBosBaslik => 'Your wardrobe is empty';

  @override
  String get bugunBosAciklama =>
      'Add your first item; new outfit ideas will be here every morning.';

  @override
  String get bugunYenile => 'Refresh';

  @override
  String get bugunGiydim => 'Wore it';

  @override
  String get bugunKaydet => 'Save';

  @override
  String get bugunSeninIcin => 'For you';

  @override
  String get bugunGiyilmediRafi => 'Not worn in 2 weeks';

  @override
  String get bugunYeniRafi => 'Recently added';

  @override
  String get bugunHavaRafi => 'Right for today';

  @override
  String get bugunRafIpucu =>
      'Tap: wear it, build an outfit or open it in the wardrobe';

  @override
  String get duelloSekmesi => 'Duel';

  @override
  String get duelloBaslik => 'Outfit Duel';

  @override
  String get duelloAltBaslik =>
      'Pick one of two outfits and test your style eye.';

  @override
  String get duelloBaslat => 'Start the duel';

  @override
  String get duelloNasilOynanir => 'How to play';

  @override
  String get duelloKural1 => 'Each round shows two outfits.';

  @override
  String get duelloKural2 => 'Choose the one the question asks for.';

  @override
  String get duelloKural3 => 'A correct pick earns points and a streak.';

  @override
  String get duelloEnIyi => 'Best';

  @override
  String get duelloSeri => 'Streak';

  @override
  String duelloGunSerisi(int gun) {
    return '$gun days';
  }

  @override
  String get duelloSeviye => 'Level';

  @override
  String duelloSeviyeDegeri(int seviye) {
    return 'Level $seviye';
  }

  @override
  String duelloXp(int xp) {
    return '$xp XP';
  }

  @override
  String duelloTur(int tur, int toplam) {
    return 'Round $tur/$toplam';
  }

  @override
  String get duelloOlcuRenk => 'Which one has better colour harmony?';

  @override
  String get duelloOlcuHava => 'Which one suits today\'s weather?';

  @override
  String get duelloDokun => 'Tap an outfit';

  @override
  String get duelloDogru => 'Correct';

  @override
  String get duelloYanlis => 'Not quite';

  @override
  String get duelloDevam => 'Continue';

  @override
  String get duelloSonuc => 'See results';

  @override
  String get duelloBitti => 'Duel finished';

  @override
  String duelloSkor(int dogru, int toplam) {
    return '$dogru/$toplam correct';
  }

  @override
  String get duelloYeniden => 'Play again';

  @override
  String get duelloBugune => 'Back to Today';

  @override
  String duelloEnIyiSeri(int seri) {
    return 'Best streak: $seri';
  }

  @override
  String get duelloPaletNotu =>
      'Colour cards this round. Add more pieces to your wardrobe and the duels will use your own clothes.';

  @override
  String get duelloDolapEkle => 'Add pieces to wardrobe';

  @override
  String get duelloBugunOynadi =>
      'You played today. Come back tomorrow to keep the streak.';

  @override
  String get duelloSebepNotr => 'Neutral and earthy tones balance each other.';

  @override
  String get duelloSebepMonokrom =>
      'Staying in one colour family creates a cohesive look.';

  @override
  String get duelloSebepAnalog => 'Close tones create a soft transition.';

  @override
  String get duelloSebepVurgu => 'One accent colour against a neutral base.';

  @override
  String get duelloSebepZit => 'Opposite colours are used in balance.';

  @override
  String get duelloSebepDagink =>
      'Two distant colours with nothing to bridge them.';

  @override
  String get duelloSebepCokRenk =>
      'Three vivid colours compete with each other.';

  @override
  String get duelloSebepHavaUygun => 'The pieces suit today\'s temperature.';

  @override
  String get duelloSebepHavaAgir => 'Too heavy for this weather.';

  @override
  String get duelloSebepHavaHafif => 'Too light for this weather.';

  @override
  String bildirimSabahKombin(String kombin) {
    return 'Today\'s outfit is ready: $kombin. Tap to see it.';
  }

  @override
  String get bildirimPlanBaslik => 'Tomorrow\'s outfit is ready';

  @override
  String bildirimPlanKombin(String kombin) {
    return 'For tomorrow: $kombin. Take a look now, no rush in the morning.';
  }

  @override
  String get bildirimPlanBos =>
      'No outfit planned for tomorrow yet. Plan it in 2 minutes.';

  @override
  String get planHatirlatimiAyar => 'Evening plan reminder';

  @override
  String get planHatirlatimiAyarAciklama =>
      'Reminds you of tomorrow\'s outfit at 21:00';

  @override
  String get bugunPaylas => 'Share outfit';

  @override
  String get bugunPaylasMetni => 'I put today\'s outfit together with FitCheck';

  @override
  String get bugunPaylasHata => 'Couldn\'t open sharing. Try again.';

  @override
  String get bugunParcaGiydim => 'Wore it today';

  @override
  String get bugunParcaKombin => 'Build an outfit with this';

  @override
  String get bugunParcaDolapta => 'Open in wardrobe';

  @override
  String bugunParcaGiydimIsaretlendi(String parca) {
    return '\"$parca\" marked as worn today.';
  }

  @override
  String get stilGunluguBaslik => 'My Style Diary';

  @override
  String get stilGunluguTakvim => 'Calendar';

  @override
  String get stilGunluguGunluk => 'Diary';

  @override
  String get stilGunluguRapor => 'Report';

  @override
  String get stilGunluguGiyildi => 'Worn';

  @override
  String get stilGunluguPlanli => 'Planned';

  @override
  String get stilGunluguGunBos => 'No record for this day';

  @override
  String stilGunluguRaporOzet(String kombin) {
    return 'You wore $kombin outfits this week';
  }

  @override
  String stilGunluguRaporGecenHafta(String fark) {
    return 'Compared with last week: $fark';
  }

  @override
  String get stilGunluguRaporKullanim => 'Wardrobe usage';

  @override
  String get stilGunluguRaporEnCok => 'Most worn';

  @override
  String get stilGunluguRaporSeri => 'Daily streak';

  @override
  String get stilGunluguRaporHicGiyilmemis => 'Never worn';

  @override
  String get stilGunluguRaporPaylas => 'Share report';

  @override
  String stilGunluguRaporPaylasMetni(String ozet) {
    return 'My weekly style report: $ozet';
  }

  @override
  String get stilGunluguRaporBos =>
      'No outfits logged this week yet. They will show up here.';

  @override
  String get seyahatBaslik => 'Travel Mode';

  @override
  String get seyahatGunSayisi => 'Days';

  @override
  String get seyahatHava => 'Weather';

  @override
  String get seyahatHavaSicak => 'Hot';

  @override
  String get seyahatHavaIliman => 'Mild';

  @override
  String get seyahatHavaSoguk => 'Cold';

  @override
  String get seyahatAmac => 'Purpose';

  @override
  String get seyahatAmacGunluk => 'Everyday';

  @override
  String get seyahatAmacIs => 'Work';

  @override
  String get seyahatAmacOzel => 'Special';

  @override
  String get seyahatPlanBaslik => 'Packing Plan';

  @override
  String seyahatKombine(String adet) {
    return '$adet outfits';
  }

  @override
  String get seyahatDiger => 'Outerwear';

  @override
  String get seyahatEksikUst => 'No clean tops';

  @override
  String get seyahatEksikAlt => 'No clean bottoms';

  @override
  String get seyahatEksikAyakkabi => 'No shoes';

  @override
  String seyahatEksikKombin(String gun) {
    return 'Not enough outfits for $gun days';
  }

  @override
  String get seyahatPaylas => 'Share list';

  @override
  String get seyahatPaylasMetni => 'My FitCheck packing plan';

  @override
  String get geriAl => 'Undo';

  @override
  String get stilGunluguRaporSayiEtiketi => 'Outfits worn this week';

  @override
  String get stilGunluguRaporDortHafta => 'Last 4 weeks';

  @override
  String get stilGunluguRaporEnCokParcalar => 'Most worn pieces';

  @override
  String get navKombin => 'Outfits';

  @override
  String get navProfil => 'Profile';

  @override
  String get dolapAra => 'Search your wardrobe';

  @override
  String get dolapEslesmeYok => 'No pieces match your search.';

  @override
  String get dolapAramayiTemizle => 'Clear search';

  @override
  String get planGuneKombinSec => 'Choose an outfit for this day';

  @override
  String get planKombinSec => 'Pick an outfit';

  @override
  String get planDegistir => 'Change';

  @override
  String get planKaldir => 'Remove';

  @override
  String get planFavoriYok => 'No favourite outfits yet.';

  @override
  String get planKombinOlustur => 'Create an outfit';

  @override
  String get planGuneEklendi => 'Outfit added to the day';

  @override
  String get planKaldirildi => 'Plan removed';

  @override
  String get planHaftalikProgram => 'Weekly schedule';

  @override
  String planParcaSayisi(int count) {
    return '$count pieces';
  }

  @override
  String get planBugun => 'Your plan today';

  @override
  String get planTakvimdenDegistir => 'Change in calendar';

  @override
  String get planFavorilerim => 'My favourites';

  @override
  String get planSonGiyilenler => 'Recently worn';

  @override
  String get izinGerekceKameraBaslik => 'Add clothes with the camera';

  @override
  String get izinGerekceKameraAciklama =>
      'We use the camera to add your clothes as photos. The photo leaves your device; background removal and colour/style analysis happen on our server and are not stored permanently.';

  @override
  String get izinGerekceSimdiDegil => 'Not now';

  @override
  String get planOneriler => 'Suggestions';

  @override
  String get bilgiVerimlilik =>
      'Wardrobe efficiency shows how many of your pieces have been worn at least once. Above 60% is considered healthy for a wardrobe; lower means some pieces are unused or you own too many.';

  @override
  String get bilgiStil =>
      'Your style identity is derived from the most common traits of your wardrobe: colour, category and style tags. Outfit suggestions are ranked using this profile.';

  @override
  String get bilgiSeri =>
      'The streak is the number of consecutive days you have dressed. Each “worn today” adds to it; skipping a day resets it.';

  @override
  String get bilgiSepet =>
      'The laundry basket holds pieces you have worn but want to wash. Items in the basket are not used in the next outfit suggestion.';

  @override
  String get bilgiRenkPaleti =>
      'Your colour palette shows the distribution of the four colours that appear most in your wardrobe. Similar shades look more harmonious together.';

  @override
  String get bilgiKategoriDagilimi =>
      'Category distribution shows the balance between tops, bottoms, shoes and accessories. Too many pieces in one category makes outfits harder to build.';

  @override
  String get bilgiAnlikDurum =>
      'Instant status gives you a short suggestion based on the weather in your city and your wardrobe.';

  @override
  String get bilgiSeriBaslik => 'Wearing Streak';

  @override
  String get bilgiKahramanlar =>
      'Your wardrobe heroes are the pieces you wear most often. Frequently worn pieces show up in more outfits and keep your wardrobe in rotation.';

  @override
  String get bilgiUnutulanlar =>
      'Forgotten items are pieces you have never worn, or have not worn for a long time. Unused pieces can come back to life with new outfits.';

  @override
  String get bilgiBugunKombini =>
      'Your outfit of the day is picked from your wardrobe and the weather. At most one AI request is made per day and the result is kept for the day; if the AI is unavailable, rule-based suggestions take over.';

  @override
  String get bilgiRaporHafta =>
      'The number of outfits you recorded in the last 7 days. Every “worn today” mark counts as one outfit; you can record several outfits on the same day.';

  @override
  String get bilgiRaporDortHafta =>
      'The number of outfits per week over the last 4 weeks. The chart shows your weekly rhythm and whether it is rising or falling.';

  @override
  String get bilgiRaporEnCokParcalar =>
      'The pieces you wore most this week. Frequently worn pieces are the backbone of your wardrobe.';

  @override
  String get bilgiRaporKullanim =>
      'The share of your wardrobe used in the last 7 days. A low value means some pieces have not made it into an outfit yet.';

  @override
  String get bilgiRaporSeri =>
      'The number of days you have dressed in a row. It grows whenever you record an outfit and resets after a missed day.';

  @override
  String get bilgiRaporHicGiyilmemis =>
      'The number of pieces not worn at all in the last 7 days. You can put these back to use with new outfits.';

  @override
  String get bilgiDueloPuan =>
      'Each round shows two outfits and you pick one. A correct answer earns points and builds your streak; a wrong one resets the streak. Scoring is rule-based: colour harmony, category balance and seasonal consistency are measured. If your wardrobe has fewer than 4 pieces, a palette is built from your past outfits.';

  @override
  String get bilgiDolapCalisma =>
      'When you add a photo, the background is removed automatically and the colour, category, style and season are read by AI. Your clothes stay on your device; background removal and analysis run on our server.';

  @override
  String get duzenleArkaPlanBaslik => 'Background and placement';

  @override
  String get duzenleIpucu => 'Drag to place the item, pinch to resize it.';

  @override
  String get duzenleZeminBeyaz => 'White';

  @override
  String get duzenleZeminKirik => 'Off-white';

  @override
  String get duzenleZeminGri => 'Light grey';

  @override
  String get duzenleZeminSaydam => 'Transparent';

  @override
  String get duzenleKaydet => 'Save';

  @override
  String get duzenleVarsayilan => 'Default';

  @override
  String get arkaPlandaEkle => 'Add in background';

  @override
  String get arkaPlandaEkleAciklama =>
      'You can keep using the app; your pieces are added in the background.';

  @override
  String arkaPlandaBasladi(int count) {
    return '$count photos are being added in the background';
  }

  @override
  String arkaPlandaIlerleme(int count, int toplam) {
    return '$count of $toplam processed';
  }

  @override
  String arkaPlandaTamamlandi(int count) {
    return '$count pieces added to your wardrobe';
  }

  @override
  String arkaPlandaBaziAtlandi(int count) {
    return '$count photos could not be processed';
  }

  @override
  String get bugunKaydedildi => 'Saved';

  @override
  String get bugunGiydildi => 'Worn';

  @override
  String get ozellikYakinda => 'This feature is coming soon';

  @override
  String get duelloGeri => 'Back';

  @override
  String get premiumOzellikMagazaIos => 'Managed through the App Store';

  @override
  String get premiumMagazaHazirDegilIos =>
      'The App Store is not available right now. Please try again.';

  @override
  String get premiumKosullarLinki => 'Terms of Use (EULA)';

  @override
  String get erisimDogruCevap => 'correct answer';

  @override
  String get erisimYanlisCevap => 'wrong answer';

  @override
  String get renkTuruncu => 'Orange';

  @override
  String get renkSari => 'Yellow';

  @override
  String get renkMor => 'Purple';

  @override
  String get renkPembe => 'Pink';

  @override
  String get renkHaki => 'Khaki';

  @override
  String get renkEkru => 'Ecru';

  @override
  String get renkBordo => 'Burgundy';

  @override
  String get lansmanSinirsizAciklama =>
      'Launch special: all outfit and style analyses are unlimited and free for now.';
}
