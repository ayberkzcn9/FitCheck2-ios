// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get chatOrtamCasual => 'Décontracté';

  @override
  String get chatOrtamOfis => 'Bureau';

  @override
  String get chatOrtamDavet => 'Soirée';

  @override
  String get chatOrtamSpor => 'Sport';

  @override
  String get chatOrtamGece => 'Nuit';

  @override
  String get chatOrtamRomantik => 'Romantique';

  @override
  String get chatOrtamHaftaSonu => 'Week-end';

  @override
  String get gardirobumAdimArkaplan => 'Suppression de l\'arrière-plan';

  @override
  String get gardirobumAdimArkaplanAlt => 'Analyse de l\'image par IA';

  @override
  String get gardirobumAdimAnaliz => 'Analyse du vêtement';

  @override
  String get gardirobumAdimAnalizAlt =>
      'Détection de la couleur, du style et de la catégorie';

  @override
  String get gardirobumAdimKaydet => 'Enregistrement';

  @override
  String get gardirobumAdimKaydetAlt => 'Ajout à votre garde-robe';

  @override
  String get gardirobumLutfenBekleyin => 'Veuillez patienter...';

  @override
  String get authHataZayifSifre =>
      'Le mot de passe est trop faible. Il doit comporter au moins 6 caractères.';

  @override
  String get authHataEpostaKullanimda =>
      'Cette adresse e-mail est déjà utilisée.';

  @override
  String get authHataGecersizEposta =>
      'Vous avez saisi une adresse e-mail invalide.';

  @override
  String get authHataKullaniciBulunamadi =>
      'Aucun utilisateur trouvé pour cette adresse e-mail.';

  @override
  String get authHataYanlisSifre =>
      'Mot de passe incorrect, veuillez réessayer.';

  @override
  String get authHataGecersizKimlik =>
      'E-mail ou mot de passe incorrect. Vérifiez vos informations.';

  @override
  String get authHataYontemIzinliDegil =>
      'Cette méthode de connexion n\'est pas activée dans la console Firebase.';

  @override
  String get authHataFarkliYontem =>
      'Cet e-mail est déjà enregistré avec une autre méthode de connexion.';

  @override
  String get authHataAgHatasi =>
      'Vérifiez votre connexion Internet et réessayez.';

  @override
  String get authHataCokDeneme =>
      'Trop de tentatives. Veuillez réessayer plus tard.';

  @override
  String get authHataHesapDevreDisi => 'Ce compte a été désactivé.';

  @override
  String get authHataYenidenGiris =>
      'Vous devez vous reconnecter pour effectuer cette action.';

  @override
  String get authHataGenel => 'Une erreur s\'est produite. Veuillez réessayer.';

  @override
  String get authHataSifreEpostasiGonderilemedi =>
      'Impossible d\'envoyer l\'e-mail de réinitialisation. Veuillez réessayer.';

  @override
  String get authHataGoogleDogrulanamadi =>
      'La connexion Google n\'a pas pu être vérifiée. Veuillez réessayer.';

  @override
  String get authHataGoogleFarkliKullanici =>
      'Ce compte Google est lié à un autre utilisateur.';

  @override
  String get authHataGoogleZatenBagli => 'Ce compte Google est déjà lié.';

  @override
  String get authHataGoogleYapilandirilmamis =>
      'La connexion Google n\'est pas configurée sur cet appareil. Veuillez le signaler au support.';

  @override
  String get authHataGooglePencereAcik =>
      'La fenêtre de connexion Google est encore ouverte. Attendez quelques secondes.';

  @override
  String get authHataGoogleTamamlanamadi =>
      'La connexion Google n\'a pas pu aboutir. Veuillez réessayer dans quelques secondes.';

  @override
  String get authHataGoogleHesapSec =>
      'Vous devez sélectionner votre compte Google pour vous connecter.';

  @override
  String get authHataGoogleOnayBekliyor =>
      'Une action est en attente sur votre compte Google. Veuillez réessayer.';

  @override
  String get authHataGoogleBeklenmeyen =>
      'Une erreur inattendue s\'est produite lors de la connexion Google.';

  @override
  String get appTitle => 'FitCheck';

  @override
  String get gorunumVeTema => 'Apparence et thème';

  @override
  String get karanlikMod => 'Mode sombre';

  @override
  String get koyuTemaAktif => 'Thème sombre actif';

  @override
  String get acikTemaAktif => 'Thème clair actif';

  @override
  String get dilAyarlari => 'Paramètres de langue et région';

  @override
  String get uygulamaDili => 'Langue de l\'application';

  @override
  String get hakkinda => 'À propos de l\'application';

  @override
  String get surum => 'Version';

  @override
  String get ayarOtomatikCihazDili => '🌐 Automatique (Langue de l\'appareil)';

  @override
  String get iptal => 'Annuler';

  @override
  String get tamam => 'OK';

  @override
  String get gardirobumTitle => 'MON DRESSING VIRTUEL';

  @override
  String get gardirobumYukleniyor => 'Analyse par IA...';

  @override
  String get gardirobumTopluEkle => 'Ajouter plusieurs articles';

  @override
  String gardirobumInceleniyor(Object kacinci, Object toplam) {
    return 'Analyse en cours ($kacinci/$toplam)';
  }

  @override
  String get gardirobumTemizleBaslik => 'Vider le dressing';

  @override
  String get gardirobumTemizleOnay =>
      'Tous les articles de votre dressing seront supprimés. Êtes-vous sûr ?';

  @override
  String get gardirobumEvet => 'Oui, tout vider';

  @override
  String get gardirobumHataMesaji =>
      'Une erreur est survenue lors de l\'ajout des articles.';

  @override
  String get gardirobumKategoriTumu => 'Tous';

  @override
  String get gardirobumKategoriUst => 'Hauts';

  @override
  String get gardirobumKategoriAlt => 'Bas';

  @override
  String get gardirobumKategoriAyakkabi => 'Chaussures';

  @override
  String get gardirobumKategoriAksesuar => 'Accessoires';

  @override
  String get gardirobumBosKategori =>
      'Aucun article trouvé dans cette catégorie.';

  @override
  String get gardirobumGiymeSayisi => 'Porté :';

  @override
  String gardirobumMaliyet(Object tutar) {
    return 'Coût : ₺$tutar / tenue';
  }

  @override
  String get gardirobumDolabaAl => 'Ranger dans le dressing';

  @override
  String get gardirobumSepeteAt => 'Mettre au panier à linge';

  @override
  String get gardirobumSepetteRozet => 'AU LINGE';

  @override
  String get gardirobumGecersizParcaBaslik => 'Article non valide détecté';

  @override
  String get gardirobumGecersizParcaIcerik =>
      'Notre système n\'a détecté aucun vêtement, chaussure ou accessoire sur cette image (Objet en bois, meuble, article ménager ou objet incompatible détecté). Veuillez télécharger uniquement des articles de dressing.';

  @override
  String get gardirobumTamam => 'OK';

  @override
  String get stilistTitle => 'STYLISTE DE TENUE INSTANTANÉ';

  @override
  String get gunlukKombinTitle => 'TENUE DU JOUR';

  @override
  String get gunlukKombinHazirBaslik => 'Prêt pour ta tenue ?';

  @override
  String get gunlukKombinHazirIcerik =>
      'Lance les dés ou secoue ton téléphone pour créer la tenue du jour.';

  @override
  String get gunlukKombinKartBaslik => 'Tenue du jour';

  @override
  String get stilistAnlikHavaDurumu =>
      'Météo actuelle (Appuyez pour actualiser)';

  @override
  String get stilistKonumKontrol => 'Vérification de la localisation...';

  @override
  String get stilistNereyeGidiyorsun => 'Où allez-vous ?';

  @override
  String get stilistDusunuyor => 'Le styliste réfléchit...';

  @override
  String get stilistBugunNeGiymeliyim => 'Que devrais-je porter aujourd\'hui ?';

  @override
  String get stilistKombiniTemizle => 'Effacer la tenue';

  @override
  String stilistKombininTitle(Object ortam) {
    return 'Votre tenue $ortam';
  }

  @override
  String stilistUyum(Object puan) {
    return '🎨 Harmonie : %$puan';
  }

  @override
  String get stilistUstGiyim => 'Hauts';

  @override
  String get stilistAltGiyim => 'Bas';

  @override
  String get stilistAyakkabi => 'Chaussures';

  @override
  String get stilistAksesuar => 'Accessoires';

  @override
  String get stilistFavoriyeEkle => 'Ajouter aux favoris';

  @override
  String get stilistBugunGiydim => 'Porté aujourd\'hui';

  @override
  String get bugunGiydimOnayIcerik => 'As-tu porté cette tenue aujourd’hui ?';

  @override
  String get stilistTrendyolTamamla => 'Compléter sur Trendyol';

  @override
  String get stilistHata =>
      'Une erreur est survenue lors de la création de la tenue.';

  @override
  String get ortamCasual => 'Décontracté / Quotidien';

  @override
  String get ortamOfis => 'Bureau / Travail';

  @override
  String get ortamDavet => 'Mariage / Événement';

  @override
  String get ortamSpor => 'Sport / Entraînement';

  @override
  String get ortamGece => 'Soirée';

  @override
  String get ortamRomantik => 'Rendez-vous romantique';

  @override
  String get stilistUyariDolapBosBaslik =>
      'Votre dressing est vide ou tous les vêtements sont au linge ! 🧺';

  @override
  String get stilistUyariDolapBosIcerik =>
      'Pour obtenir des recommandations de tenues personnalisées, veuillez ajouter des vêtements ou accessoires propres à votre armoire.';

  @override
  String get stilistUyariUstEksikBaslik => 'Hauts manquants ! 👕';

  @override
  String get stilistUyariUstEksikIcerik =>
      'Vous n\'avez aucun haut propre dans votre dressing. Ajoutez au moins un haut pour compléter une tenue !';

  @override
  String get stilistUyariAltEksikBaslik => 'Bas manquants ! 👖';

  @override
  String get stilistUyariAltEksikIcerik =>
      'Vous n\'avez aucun bas propre dans votre dressing. Ajoutez un bas pour créer un look élégant !';

  @override
  String get stilistUyariAyakkabiEksikBaslik => 'Chaussures manquantes ! 👟';

  @override
  String get stilistUyariAyakkabiEksikIcerik =>
      'Votre tenue est super, mais nous n\'avons pas trouvé de chaussures propres pour la compléter. Ajoutez une paire de chaussures dès maintenant !';

  @override
  String get stilistUyariButon => 'Compris, j\'ajoute !';

  @override
  String get anaHavaYukleniyor => 'Chargement de la météo locale...';

  @override
  String get anaDinliyor => '🎙️ FITCHECK écoute... Parlez maintenant !';

  @override
  String get anaMikrofonHata =>
      'L\'autorisation du microphone ou le service de reconnaissance vocale n\'est pas prêt.';

  @override
  String anaCinsiyetGuncellendi(Object cinsiyet) {
    return 'Votre préférence a été mise à jour : \"$cinsiyet\" ✨';
  }

  @override
  String get anaKonumKapaliBaslik => 'Service de localisation désactivé';

  @override
  String get anaKonumKapaliIcerik =>
      'Vous devez activer la géolocalisation GPS pour recevoir des recommandations adaptées à la météo.';

  @override
  String get anaKonumuAc => 'Activer la localisation';

  @override
  String get anaIzinVer => 'Autoriser';

  @override
  String get anaIptal => 'Annuler';

  @override
  String get anaKonumIzinRedBaslik => 'Autorisation de localisation refusée';

  @override
  String get anaKonumIzinRedIcerik1 =>
      'Impossible d\'obtenir la météo car la permission n\'a pas été accordée.';

  @override
  String get anaKonumIzinRedIcerik2 =>
      'Vous devez activer les autorisations dans les paramètres du système.';

  @override
  String get anaKonumIzinGerekliBaslik =>
      'Autorisation de localisation requise';

  @override
  String get anaKonumIzinGerekliIcerik =>
      'Vous devez activer l\'autorisation de localisation dans les paramètres pour charger les prévisions météo.';

  @override
  String get anaHavaDurumuAlinamadi => 'Informations météo indisponibles';

  @override
  String get anaHavaTahminiYuklenemedi =>
      'Impossible de charger les prévisions météo.';

  @override
  String get anaFavoriEklendi => 'Tenue ajoutée aux favoris ! ⭐';

  @override
  String get anaKombinTekrarUyari =>
      '⚠️ Attention : Vous avez porté ces vêtements ou des pièces similaires très souvent récemment. Essayez un autre style aujourd\'hui !';

  @override
  String get anaKombinMukemmel =>
      '✨ Excellent choix ! Votre style est bien équilibré et frais aujourd\'hui.';

  @override
  String get anaYikamaUyariBaslik => 'Alerte Linge Intelligent';

  @override
  String anaYikamaUyariIcerik(Object parcalar) {
    return 'Puisque vous avez porté cette tenue, les articles \"$parcalar\" ont été utilisés fréquemment et envoyés automatiquement au panier à linge ! 🧺';
  }

  @override
  String get anaTamam => 'OK';

  @override
  String get anaAyarlarTooltip => 'Paramètres';

  @override
  String get anaKadin => 'Femme';

  @override
  String get anaErkek => 'Homme';

  @override
  String get anaSesleKonus => 'Commande vocale';

  @override
  String get anaStilistAsistani => 'Assistant Styliste';

  @override
  String get anaSekmeGardirop => 'Dressing';

  @override
  String get anaSekmeHaftalik => 'Semaine';

  @override
  String get anaSekmeAnlik => 'Instant';

  @override
  String get anaSekmeYarismasi => 'Quiz';

  @override
  String get anaSekmeProfil => 'Profil & Analyses';

  @override
  String get modaYarismasiBaslik => 'Mode & Couleurs';

  @override
  String get modaYarismasiGunlukTamamlandi => 'Quiz du jour terminé';

  @override
  String get modaYarismasiYeniYarin =>
      'Un nouveau jeu de 5 questions sera disponible demain.';

  @override
  String get modaYarismasiSonuc => 'Résultat';

  @override
  String modaYarismasiSkor(Object skor) {
    return 'Score : $skor / 10';
  }

  @override
  String modaYarismasiSoru(Object index) {
    return 'Question $index / 10';
  }

  @override
  String get modaYarismasiGeri => 'Retour';

  @override
  String get modaYarismasiAnaEkrana => 'Retour à l\'accueil';

  @override
  String get havaParcaliBulutlu => 'Partiellement nuageux';

  @override
  String get havaSicakGunesli => 'Chaud & Ensoleillé';

  @override
  String get havaSogukKarli => 'Froid & Neigeux';

  @override
  String get havaYagmurlu => 'Pluvieux';

  @override
  String get havaGunesli => 'Ensoleillé';

  @override
  String get havaSoguk => 'Froid';

  @override
  String get gunPzt => 'Lundi';

  @override
  String get gunSal => 'Mardi';

  @override
  String get gunCar => 'Mercredi';

  @override
  String get gunPer => 'Jeudi';

  @override
  String get gunCum => 'Vendredi';

  @override
  String get gunCmt => 'Samedi';

  @override
  String get gunPaz => 'Dimanche';

  @override
  String get stilKahveBaslik => '☕ Pause Café & Décontracté';

  @override
  String get stilKahveSoru =>
      'Propose une tenue décontractée et stylée pour prendre un café entre amis';

  @override
  String get stilOfisBaslik => '💼 Élégance Travail / Bureau';

  @override
  String get stilOfisSoru =>
      'Propose une tenue chic et moderne adaptée au travail de bureau';

  @override
  String get stilSporBaslik => '🏃 Style Sportif / Confort';

  @override
  String get stilSporSoru =>
      'Propose une tenue très confortable et sportive pour une sortie le week-end';

  @override
  String get stilGeceBaslik => '🌙 Soirée / Événement nocturne';

  @override
  String get stilGeceSoru =>
      'Propose une tenue audacieuse pour un dîner romantique ou un événement spécial';

  @override
  String get ilkGorevBaslik => '🎯 Première mission : Choisissez votre style !';

  @override
  String get ilkGorevAciklama =>
      'FitCheck IA va créer instantanément une tenue pour vous. Où allez-vous aujourd\'hui ?';

  @override
  String get haftalikUyariButon => 'Compris';

  @override
  String get haftalikUyariDolapBosBaslik => 'Votre dressing est vide !';

  @override
  String get haftalikUyariDolapBosIcerik =>
      'Vous devez ajouter des vêtements à votre armoire pour planifier votre semaine.';

  @override
  String get haftalikUyariUstEksikBaslik => 'Hauts manquants !';

  @override
  String get haftalikUyariUstEksikIcerik =>
      'Vous n\'avez aucun haut propre dans votre dressing.';

  @override
  String get haftalikUyariAltEksikBaslik => 'Bas manquants !';

  @override
  String get haftalikUyariAltEksikIcerik =>
      'Vous n\'avez aucun bas propre dans votre dressing.';

  @override
  String get haftalikUyariAyakkabiEksikBaslik => 'Chaussures manquantes !';

  @override
  String get haftalikUyariAyakkabiEksikIcerik =>
      'Il n\'y a pas de chaussures propres dans votre dressing.';

  @override
  String get haftalikHata =>
      'Une erreur est survenue lors de la création du planning hebdomadaire.';

  @override
  String get haftalikAjandaTitle => 'PLANIFICATEUR DE STYLE HEBDOMADAIRE';

  @override
  String get haftalikAnlikHavaDurumu => 'Prévisions météo de la semaine';

  @override
  String get haftalikKonumKontrol => 'Chargement de la météo...';

  @override
  String get haftalikTemizParca => 'Articles propres';

  @override
  String get haftalikSepette => 'Au linge';

  @override
  String get haftalikPlanAciklama =>
      'Laissez l\'IA préparer un planning de tenues sur 7 jours basé sur la météo.';

  @override
  String get haftalikProgramOlustur => 'Créer le programme hebdomadaire';

  @override
  String get haftalikPlaniTemizle => 'Effacer le programme';

  @override
  String get haftalikAnalizEdiliyor => 'L\'IA planifie...';

  @override
  String get haftalikUyum => 'Harmonie';

  @override
  String get haftalikFavoriEkle => 'Ajouter aux favoris';

  @override
  String get haftalikGiyildiIsaretle => 'Porté aujourd\'hui';

  @override
  String get haftalikHava => 'Météo :';

  @override
  String get haftalikHavaUyarisi =>
      'Remarque : certaines pièces de cette tenue ont été modifiées pour correspondre à la météo du jour.';

  @override
  String get haftalikUyumsuzParca => 'Article manquant';

  @override
  String get haftalikEksikParcaStilistNotu =>
      'Le styliste a tenu compte de l\'article manquant et a préparé les recommandations avec vos pièces propres.';

  @override
  String get haftalikEksikParcaYeterliParcaYok =>
      'Il ne reste pas assez de pièces propres pour ce jour. Ajoutez un nouvel article ou faites une lessive : le styliste proposera ici une nouvelle tenue.';

  @override
  String get haftalikEksikParcaAiOnerisi => 'Suggestion de tenue par IA';

  @override
  String get haftalikEksikParcaOneriYok =>
      'Actualise le plan pour voir une combinaison haut, bas et chaussures qui complète la pièce manquante.';

  @override
  String get haftalikEksikParcaOnerisiBaslik =>
      'Suggestion de tenue du styliste IA';

  @override
  String get haftalikEksikParcaOneriHazirlaniyor =>
      'Le styliste prépare une suggestion de tenue…';

  @override
  String get haftalikEksikParcaPlanKurulamadi =>
      'Impossible de créer une tenue sans haut ni bas. Le styliste a préparé une suggestion ci-dessus.';

  @override
  String get haftalikNot => 'Note';

  @override
  String get haftalikTrendyolAra => 'Rechercher sur Trendyol';

  @override
  String get izinZorunluMesaj =>
      'Ces autorisations sont nécessaires pour utiliser l\'application.';

  @override
  String get izinGerekliBaslik => 'Autorisations requises';

  @override
  String get izinGerekliIcerik =>
      'Les autorisations d\'accès à la caméra et à la localisation ont été refusées. Veuillez les activer dans les paramètres.';

  @override
  String get ayarlaraGit => 'Aller dans les paramètres';

  @override
  String get izinAnaBaslik => 'Autorisations nécessaires';

  @override
  String get izinAciklama =>
      'Pour vous offrir les meilleures recommandations de tenues, nous avons besoin des autorisations de localisation (météo) et d\'appareil photo (photos).';

  @override
  String get konumIzni => 'Autorisation de localisation';

  @override
  String get kameraIzni => 'Autorisation de l\'appareil photo';

  @override
  String get izinVerDevamEt => 'Autoriser et continuer';

  @override
  String get gunlukHavaMevcutDegil => 'Données météo indisponibles';

  @override
  String get profilAnalizTitle => 'PROFIL & ANALYSES';

  @override
  String get anlikDurum => 'Statut actuel';

  @override
  String get toplamParca => 'Total des articles';

  @override
  String get favoriKombin => 'Tenue favorite';

  @override
  String get gardiropDegeri => 'Valeur du dressing';

  @override
  String get ortalamaMaliyet => 'Coût moyen';

  @override
  String get kategoriDagilimi => 'Répartition par catégorie';

  @override
  String get ustGiyim => 'Hauts';

  @override
  String get altGiyim => 'Bas';

  @override
  String get ayakkabi => 'Chaussures';

  @override
  String get disGiyim => 'Vêtements d\'extérieur';

  @override
  String get aksesuar => 'Accessoires';

  @override
  String get sonGiyecekGecmisi => 'Historique des tenues récentes';

  @override
  String get kayit => 'Enregistrement';

  @override
  String get gecmisKombinYok =>
      'Aucun historique de tenue enregistré pour le moment.';

  @override
  String get parca => 'Articles';

  @override
  String get onboardingHosGeldinBaslik => 'Bienvenue sur FitCheck ! ✨';

  @override
  String get onboardingDolabiniDijitallestir => 'Numérisez votre dressing';

  @override
  String get onboardingDolapAciklama =>
      'Ajoutez vos vêtements en quelques secondes et créez votre dressing virtuel.';

  @override
  String get onboardingHavaDurumu => 'Adapté à la météo';

  @override
  String get onboardingHavaAciklama =>
      'Obtenez des suggestions de tenues adaptées à la météo quotidienne de votre région.';

  @override
  String get onboardingYikama => 'Suivi intelligent du linge';

  @override
  String get onboardingYikamaAciklama =>
      'L\'application détecte automatiquement les vêtements souvent portés et les déplace vers le linge sale.';

  @override
  String get onboardingEksikParca => 'Suggestions d\'articles manquants';

  @override
  String get onboardingEksikAciklama =>
      'Identifiez les pièces manquantes pour compléter votre tenue et obtenez des idées d\'achats instantanées.';

  @override
  String get onboardingAnalitik => 'Analyses avancées';

  @override
  String get onboardingAnalitikAciklama =>
      'Analysez la valeur totale de votre armoire, le coût par utilisation et vos tendances préférées.';

  @override
  String get onboardingStilist => 'Assistant Styliste IA';

  @override
  String get onboardingStilistAciklama =>
      'Dites simplement où vous allez, et l\'IA préparera la tenue parfaite en quelques secondes.';

  @override
  String get onboardingAtla => 'Passer';

  @override
  String get onboardingModaProfiliniz => 'Votre profil mode';

  @override
  String get onboardingKadin => 'Femme';

  @override
  String get onboardingErkek => 'Homme';

  @override
  String get onboardingBasla => 'Commencer';

  @override
  String get onboardingDevamEt => 'Continuer';

  @override
  String get cinsiyetBaslik => 'GENRE';

  @override
  String get tarzBaslik => 'STYLE QUOTIDIEN (MULTIPLE)';

  @override
  String get renkTercihiBaslik => 'PRÉFÉRENCE DE COULEURS';

  @override
  String get tenRengiBaslik => 'CARNATION DE LA PEAU';

  @override
  String get kadin => 'Femme';

  @override
  String get erkek => 'Homme';

  @override
  String get cinsiyetBelirtilmemis => 'Non précisé';

  @override
  String get tarzSpor => 'Sportif';

  @override
  String get tarzKlasik => 'Classique';

  @override
  String get tarzSokakModasi => 'Streetwear';

  @override
  String get tarzMinimalist => 'Minimaliste';

  @override
  String get renkKoyuTonlar => 'Tons sombres';

  @override
  String get renkPastel => 'Couleurs pastels';

  @override
  String get renkCanli => 'Couleurs vives';

  @override
  String get renkNotr => 'Neutre';

  @override
  String get tenAcikBeyaz => 'Claire / Trés claire';

  @override
  String get tenBugday => 'Moyenne / Hâlée';

  @override
  String get tenEsmerKoyu => 'Mat / Foncée';

  @override
  String get hesabinizaGirisYapin => 'Connexion à votre compte';

  @override
  String get yeniHesapOlusturun => 'Créer un nouveau compte';

  @override
  String get stilDunyanaTekrarHosGeldin =>
      'Ravi de vous revoir dans votre univers mode ✨';

  @override
  String get kombinleriniSaklamakIcinKatil =>
      'Rejoignez-nous pour sauvegarder et synchroniser vos tenues 🚀';

  @override
  String get girisYap => 'Se connecter';

  @override
  String get girisYapGoogle => 'Se connecter avec Google';

  @override
  String get girisBeniHatirla => 'Se souvenir de moi';

  @override
  String get girisVeya => 'ou';

  @override
  String get kayitOl => 'S\'inscrire';

  @override
  String get adinizVeyaLakabiniz => 'Votre nom ou pseudo';

  @override
  String get epostaAdresiniz => 'Adresse e-mail';

  @override
  String get sifreniz => 'Mot de passe';

  @override
  String get girisYapVeBasla => 'Se connecter & Commencer';

  @override
  String get kayitOlVeBasla => 'S\'inscrire & Commencer';

  @override
  String get misafirOlarakDevamEt => 'Continuer en tant qu\'invité';

  @override
  String get lutfenEpostaVeSifreGiriniz =>
      'Veuillez saisir votre e-mail et votre mot de passe.';

  @override
  String get lutfenAdiniziGiriniz => 'Veuillez saisir votre nom.';

  @override
  String get kullanimKosullariBaslik => 'Conditions d\'utilisation et contrat';

  @override
  String get onaylamakIcinKaydirin =>
      'Faites défiler jusqu\'à la fin pour accepter';

  @override
  String get okudumAnladimKabulEdiyorum => 'J\'ai lu, compris et j\'accepte';

  @override
  String get kullanimKosullarini => 'les conditions d\'utilisation';

  @override
  String get okudumVeOnayliyorum => '.';

  @override
  String get onaylamadanOnceKosullariOkuyun =>
      'Veuillez lire les conditions d\'utilisation avant d\'accepter.';

  @override
  String get devamEtmekIcinKosullariKabulEdin =>
      'Vous devez accepter les conditions d\'utilisation pour continuer.';

  @override
  String get kullanimKosullariMetni =>
      'CONDITIONS D\'UTILISATION ET CONTRAT DE SERVICE FITCHECK\n\nDernière mise à jour : 27 août 2026\n\nVeuillez lire attentivement ces conditions d\'utilisation (« Contrat ») avant d\'utiliser l\'application mobile FitCheck (« Application »). En téléchargeant, accédant ou utilisant l\'Application, vous acceptez d\'être lié par toutes les conditions de ce Contrat.\n\n1. PARTIES ET OBJET\nCe Contrat est conclu entre le développeur de l\'application FitCheck et l\'utilisateur individuel (« Utilisateur ») qui télécharge et utilise l\'Application. L\'Application propose la gestion numérique de la garde-robe, le suivi des vêtements, des suggestions de tenues adaptées à la météo et du conseil en style alimenté par l\'IA.\n\n2. PORTÉE DU SERVICE ET CONDITIONS D\'UTILISATION\n• Limite d\'âge : Vous devez avoir au moins 13 ans pour utiliser l\'Application.\n• Informations utilisateur : L\'utilisateur est responsable de l\'exactitude du nom, du genre, du style et des préférences de couleur fournis lors de la configuration du profil.\n• Nature consultative : Les scores de style, les suggestions d\'achat et les rappels de lessive fournis par l\'intelligence artificielle sont strictement indicatifs.\n• Données météo : Les prévisions météo sont récupérées en fonction de la localisation en temps réel. La Société ne peut être tenue responsable des écarts.\n\n3. PROPRIÉTÉ INTELLECTUELLE ET DROITS SUR LE CONTENU\nVous conservez les droits de propriété intellectuelle sur les photos de vêtements que vous téléchargez. Le logo FitCheck, la conception, le code logiciel et les algorithmes appartiennent entièrement à FitCheck.\n\n4. CONFIDENTIALITÉ ET SÉCURITÉ DES DONNÉES\nVos photos téléchargées et l\'historique de vos tenues sont stockés localement sur votre appareil par défaut. Les données de localisation sont uniquement utilisées pour les demandes météo en temps réel.\n\n5. LIMITATION DE RESPONSABILITÉ\nFitCheck ne garantit pas un service ininterrompu. Elle ne peut être tenue responsable de la perte de données causée par un changement d\'appareil ou la suppression de l\'application.\n\n6. CONTACT\nPour toute question, contactez-nous via la section contact de l\'onglet Paramètres ou à support@fitcheckapp.com.\n\n--- 📜 FIN DU CONTRAT ---\nVeuillez accepter les conditions en appuyant sur le bouton ci-dessous.';

  @override
  String chatKarsilama(Object hava) {
    return 'Bonjour ! 👋 Il fait $hava dehors aujourd\'hui. On te compose une super tenue qui correspond à ton style ? ✨';
  }

  @override
  String get chatGorselGonderildi => 'Image envoyée.';

  @override
  String get chatAsistanSohbeti => 'Discussion avec l\'assistant';

  @override
  String get chatModHavaDuyarli =>
      'Des suggestions de style intelligentes selon la météo';

  @override
  String get chatStilistHazirliyor => 'Le styliste compose une tenue...';

  @override
  String get chatGorselEklendi => 'Image jointe';

  @override
  String get chatTekrarDene => 'Réessayer';

  @override
  String get chatKamera => 'Appareil photo';

  @override
  String get chatGaleri => 'Choisir une image dans la galerie';

  @override
  String get chatMikrofon => 'Microphone';

  @override
  String get chatGonder => 'Envoyer le message';

  @override
  String get chatOneriYagmur => '🌧️ Tenue pour jour de pluie';

  @override
  String get chatOneriOfis => '💼 Bureau / Smart Casual';

  @override
  String get chatOneriHaftaSonu => '☕ Confort du week-end';

  @override
  String get chatOneriKirliSepeti => '🧺 Vérification du panier à linge';

  @override
  String get chatDinleniyor => 'Écoute en cours...';

  @override
  String get chatBirSeylerYazin => 'Écrivez un message à l\'assistant...';

  @override
  String get chatKombiniGiydim => 'J\'ai porté cette tenue 👗';

  @override
  String get chatKombinIslendi => 'Tenue enregistrée pour aujourd\'hui ! 📅';

  @override
  String get chatGorselIncele => 'Examinez cette image et proposez une tenue.';

  @override
  String get profilAyarlariBaslik => 'PARAMÈTRES DU PROFIL';

  @override
  String get cinsiyetTercihiBaslik => 'Préférence de genre';

  @override
  String get stilAramaHint =>
      'Ex : \'Smart casual avec veste noire\', \'Robe d\'été\'...';

  @override
  String get stilFiltreTumu => 'Tous les articles';

  @override
  String get stilFiltreSadeceTemizler => 'Propres uniquement';

  @override
  String get stilFiltreSadeceSepet => 'Au linge uniquement';

  @override
  String get profilFavoriKombinlerTitle => 'Mes tenues favorites';

  @override
  String get profilFavoriKombinYok =>
      'Aucune tenue favorite ajoutée pour l\'instant.';

  @override
  String get profilYikamaSepetimTitle => 'Panier à linge';

  @override
  String get profilYikamaSepetimBos =>
      'Votre panier à linge est vide, tous vos vêtements sont propres ! ✨';

  @override
  String get profilSepetiBosalt => 'Vider le panier';

  @override
  String get profilSepetiBosaltOnay =>
      'Tous les articles seront marqués comme propres. Confirmez-vous ?';

  @override
  String get profilSepetiBosaltButon => 'Oui, tout laver';

  @override
  String get profilTenRengi => 'Teint / Carnation';

  @override
  String get profilTarzTercihi => 'Préférence de style';

  @override
  String get profilRenkPaleti => 'Palette de couleurs préférée';

  @override
  String get rehberGardiropEkleTitle => 'Ajouter une photo';

  @override
  String get rehberGardiropEkleDesc =>
      'Prenez ou téléchargez des photos de vos vêtements individuellement ou en lot.';

  @override
  String get rehberAiStilistTitle => 'Assistant Styliste IA';

  @override
  String get rehberAiStilistDesc =>
      'Demandez à l\'IA des tenues personnalisées ou des conseils de style.';

  @override
  String get rehberSesliTitle => 'Commande vocale';

  @override
  String get rehberSesliDesc =>
      'Parlez simplement pour demander des recommandations de tenues en mains libres.';

  @override
  String get rehberAyarlarTitle => 'Paramètres & Profil';

  @override
  String get rehberAyarlarDesc =>
      'Mettez à jour vos préférences de genre, de style et de carnation.';

  @override
  String get rehberGardiropNavTitle => 'Mon dressing';

  @override
  String get rehberGardiropNavDesc =>
      'Consultez tous vos vêtements ajoutés, organisés par catégories.';

  @override
  String get rehberHaftalikNavTitle => 'Planificateur hebdomadaire';

  @override
  String get rehberHaftalikNavDesc =>
      'Planifiez vos tenues pour 7 jours en fonction des prévisions météo.';

  @override
  String get rehberDolaptanNavTitle => 'Générateur de tenues IA';

  @override
  String get rehberDolaptanNavDesc =>
      'Générez des combinaisons automatiques par IA avec vos vêtements selon le temps.';

  @override
  String get rehberKendiNavTitle => 'Créateur de tenue personnalisé';

  @override
  String get rehberKendiNavDesc =>
      'Associez manuellement vos vêtements pour concevoir votre propre look.';

  @override
  String get rehberProfilNavTitle => 'Profil & Analyses';

  @override
  String get rehberProfilNavDesc =>
      'Suivez la rentabilité de votre dressing et gérez votre panier à linge.';

  @override
  String get simdilikAtla => 'Passer pour l\'instant';

  @override
  String get uygulamaIzinleri => 'Autorisations de l\'application';

  @override
  String get izinEkraniAciklama =>
      'FitCheck a besoin de ces autorisations pour recommander des tenues personnalisées et envoyer des alertes météo/linge.';

  @override
  String get konumIzniAciklama =>
      'Pour des suggestions de tenues en temps réel basées sur la météo';

  @override
  String get kameraIzniAciklama =>
      'Pour prendre des photos de vêtements et les ajouter à votre armoire';

  @override
  String get bildirimIzni => 'Autorisation de notification';

  @override
  String get bildirimIzniAciklama =>
      'Pour les rappels de lessive et les alertes météo';

  @override
  String get izinleriVerVeBasla => 'Accorder les autorisations & Commencer';

  @override
  String get dahaSonraAyarla => 'Configurer plus tard';

  @override
  String get gunlukHakBittiBaslik => 'Limite quotidienne atteinte !';

  @override
  String get dahaSonra => 'Plus tard';

  @override
  String get reklamIzleHakKazan => 'Regarder une pub (+3 crédit)';

  @override
  String get tebriklerHakEklendi => 'Félicitations ! +3 crédit ajouté. ✨';

  @override
  String kombinIsaretlemeKaldirildi(String kombinAdi) {
    return 'Marquage retiré pour la tenue \"$kombinAdi\".';
  }

  @override
  String kombinGiydimIsaretlendi(String kombinAdi) {
    return '\"$kombinAdi\" marqué comme porté aujourd\'hui ! 👕✨';
  }

  @override
  String get kiyafetDetayi => 'Détails du vêtement';

  @override
  String get parcaDetayiBaslik => 'DÉTAILS DE L\'ARTICLE';

  @override
  String get farkliParcaSec => 'Choisir un autre article';

  @override
  String get farkliUstSec => 'Choisir un autre haut 👕';

  @override
  String get farkliAltSec => 'Choisir un autre bas 👖';

  @override
  String get farkliAyakkabiSec => 'Choisir d\'autres chaussures 👟';

  @override
  String get farkliDisSec => 'Choisir un autre vêtement d\'extérieur 🧥';

  @override
  String get baskaTemizKiyafetYok =>
      'Vous n\'avez pas d\'autre vêtement propre\ndans cette catégorie pour effectuer un échange.';

  @override
  String get planiYenile => 'Actualiser le programme';

  @override
  String get havaEtiketi => 'MÉTÉO';

  @override
  String get yukleniyor => 'Chargement...';

  @override
  String get temizle => 'Effacer';

  @override
  String get yenidenDegerlendiriliyor => 'Réévaluation en cours...';

  @override
  String get kombinParcalariBaslik => 'ÉLÉMENTS DE LA TENUE';

  @override
  String get parcalariKaydirIpucu =>
      'Faites glisser vers la gauche/droite pour voir d\'autres articles 👈👉';

  @override
  String zorunluParcaYorumu(Object parcaAdi) {
    return '✨ J\'ai créé cette tenue autour de cet article : $parcaAdi !';
  }

  @override
  String get sihirliDokunus => 'Touche magique';

  @override
  String get dolabiKaristirEksikUyari =>
      'Vous devez avoir au moins 1 Haut, 1 Bas et 1 paire de Chaussures propres pour mélanger votre dressing ! 👕👖👟';

  @override
  String get zarlarAtildiYorumu =>
      '🎲 Dés jetés ! Vous avez découvert une combinaison surprenante.';

  @override
  String get rastgeleKombinTuru => 'Aleatoire';

  @override
  String get temizAlternatifYok =>
      'Plus d\'alternative propre dans cette catégorie ! 🧺';

  @override
  String get kisiselDokunus => 'Touche personnelle';

  @override
  String get aiYeniParcaAnalizEdiyor => 'L\'IA analyse le nouvel article... ✨';

  @override
  String get parcaDegisimVarsayilanYorum =>
      '✨ Échanger ces articles a créé une super harmonie globale !';

  @override
  String get parcaDegisimHataYorum =>
      '✨ Le changement d\'articles a adapté cette tenue à votre style !';

  @override
  String get bilgileriDuzenleBaslik => 'Modifier les infos';

  @override
  String get kiyafetAdiEtiketi => 'Nom de l\'article';

  @override
  String get renkEtiketi => 'Couleur';

  @override
  String get kaydet => 'Enregistrer';

  @override
  String get yenidenZarAt => 'Relancer les dés';

  @override
  String get zarAtKaristir => 'Lancer les dés (Mélanger)';

  @override
  String get zarPopupBaslik => 'Secoue les dés magiques !';

  @override
  String get zarPopupAciklama =>
      'Secoue ton téléphone ou appuie sur le bouton ci-dessous pour lancer les dés et créer des tenues aléatoires à partir de ta garde-robe.';

  @override
  String get zarlariAt => 'Lancer les dés';

  @override
  String get zarSalla => 'Secouer les dés';

  @override
  String get degistirmekIcinKaydirIpucu =>
      'Faites glisser ou appuyez sur un article pour l\'échanger 👈👉';

  @override
  String get favorilerdeEtiketi => 'Dans les favoris';

  @override
  String get bugunGiydildiEtiketi => 'Porté aujourd\'hui ✨';

  @override
  String get varsayilanKendiAnalizYorumu =>
      'Super choix ! Ces pièces s\'accordent très bien en ton et en style.';

  @override
  String get kendiTasarimimBaslik => 'Ma propre création';

  @override
  String parcaSecModalBaslik(Object kategori) {
    return 'Sélectionner $kategori';
  }

  @override
  String get kendiKombininiTasarlaTitle => 'Concevez votre tenue';

  @override
  String get secimleriSifirla => 'Réinitialiser la sélection';

  @override
  String get kombinHazirAiTavsiyesi =>
      'La tenue est fantastique ! Analysez avec l\'IA et enregistrez.';

  @override
  String get kombinBaslaIpucu =>
      'Que voulez-vous porter aujourd\'hui ? Commencez par choisir des articles.';

  @override
  String get ustAltModu => 'Haut + Bas';

  @override
  String get tekParcaElbiseModu => 'Pièce unique (Robe)';

  @override
  String get tekParcaElbise => 'Pièce unique / Robe';

  @override
  String get aksesuarOpsiyonel => 'Accessoires (Optionnel)';

  @override
  String get stilistAnaliziBaslik => 'ANALYSE DU STYLISTE';

  @override
  String get stilistDegerlendiriyor => 'Le styliste évalue...';

  @override
  String get aiIleAnalizEtKaydet => 'Analyser avec l\'IA & Enregistrer';

  @override
  String get bilinmiyor => 'Inconnu';

  @override
  String get karmasikSiklik => 'Élégance sophistiquée';

  @override
  String get gecmisiTemizleTitle => 'Effacer l\'historique';

  @override
  String get gecmisiTemizleOnayIcerik =>
      'Êtes-vous sûr de vouloir supprimer tout l\'historique des tenues ? Cette action est irrémédiable.';

  @override
  String get gecmisBasariylaTemizlendi => 'Historique effacé avec succès 🗑️';

  @override
  String get kayitGecmistenSilindi =>
      'Enregistrement supprimé de l\'historique.';

  @override
  String get kombin => 'Tenue';

  @override
  String get kombinDetayiUst => 'DÉTAILS DE LA TENUE';

  @override
  String get giyilenParcalarUst => 'ARTICLES PORTÉS';

  @override
  String get detayBulunamadi => 'Aucun détail trouvé.';

  @override
  String get henuzFavoriEklemediniz =>
      'Vous n\'avez pas encore ajouté de tenues favorites.';

  @override
  String get camasirSepetiTitle => 'Panier à linge';

  @override
  String get sepetBosTumKiyafetlerTemiz =>
      'Le panier est vide, tous les vêtements sont propres !';

  @override
  String get tumKiyafetlerTemizlendi =>
      'Tous les vêtements sont lavés et remis dans le dressing 🧺✨';

  @override
  String get tumunuTemizIsaretle => 'Tout marquer comme propre';

  @override
  String get profilVeAnalizTitle => 'Profil et Analyses';

  @override
  String get harikaGidiyorsun => 'Vous gérez super bien !';

  @override
  String gundurSeridesin(Object gun) {
    return 'Série de $gun jours';
  }

  @override
  String get tumuTemiz => 'Tout est propre';

  @override
  String kirliParcaSayisi(Object sayi) {
    return '$sayi articles sales';
  }

  @override
  String get stilKimligin => 'Votre identité de style';

  @override
  String get dolapVerimliligi => 'Efficacité du dressing';

  @override
  String get renkPaletin => 'Votre palette de couleurs';

  @override
  String get dolabinKahramanlari => 'Incontournables du dressing';

  @override
  String get derinlerdeUnutulanlar => 'Articles oubliés';

  @override
  String get sonGiyilenler => 'Récemment portés';

  @override
  String get tumunuTemizle => 'Tout effacer';

  @override
  String get henuzGecmisKaydiYok => 'Aucun historique enregistré.';

  @override
  String kezGiyildi(Object sayi) {
    return 'Porté $sayi fois';
  }

  @override
  String get ayarlarTitle => 'Paramètres';

  @override
  String get hesapVeGuvenlikMerkeziUst => 'CENTRE DE COMPTE ET SÉCURITÉ';

  @override
  String get kullaniciHesabi => 'Compte utilisateur';

  @override
  String get misafirKullanici => 'Utilisateur invité';

  @override
  String get epostaDogrulanmis => 'E-mail vérifié';

  @override
  String get esitlemekIcinGirisYapin =>
      'Connectez-vous pour synchroniser vos appareils.';

  @override
  String get cikisYapTitle => 'Se déconnecter';

  @override
  String get cikisYapOnayIcerik =>
      'Êtes-vous sûr de vouloir vous déconnecter de votre compte ?';

  @override
  String get bagliHesaplarUst => 'COMPTES ASSOCIÉS';

  @override
  String get googleHesabiBagli => 'Compte Google associé';

  @override
  String get googleHesabiniBagla => 'Associer un compte Google';

  @override
  String get googleHesabiBaglandi => 'Compte Google associé avec succès ! 🔗';

  @override
  String get googleHesabiBaglantisiKesildi => 'Compte Google dissocié.';

  @override
  String get sifreVeGuvenlik => 'Mot de passe & Sécurité';

  @override
  String get sifreYenilemeBaglantisiIste =>
      'Demander un lien de réinitialisation';

  @override
  String get sifremiUnuttum => 'Mot de passe oublié ?';

  @override
  String get sifreDegistirTitle => 'Changer le mot de passe';

  @override
  String get sifreSifirlamaAciklama =>
      'Un lien de réinitialisation de mot de passe sera envoyé à l\'adresse associée à votre compte :';

  @override
  String get epostaAdresi => 'Adresse e-mail';

  @override
  String get gecerliBirEpostaGiriniz => 'Saisissez une adresse e-mail valide';

  @override
  String sifreEpostasiGonderildi(Object eposta) {
    return 'E-mail de réinitialisation envoyé à $eposta ! ✉️';
  }

  @override
  String get baglantiGonder => 'Envoyer le lien';

  @override
  String get hesabiKaliciSilTitle => 'Supprimer définitivement le compte';

  @override
  String get hesabiSilGeriAlinamazUyari =>
      'Cette action est irréversible. Les données de votre dressing et votre profil seront définitivement effacés.';

  @override
  String get hesabiSilOnayKoduMetni =>
      'Tapez \"fitcheck\" ci-dessous pour confirmer :';

  @override
  String get vazgec => 'Annuler';

  @override
  String get hesabimiSil => 'Supprimer mon compte';

  @override
  String get hesabinizSilindi =>
      'Votre compte et vos données ont été supprimés.';

  @override
  String get kisiselStilVeProfilUst => 'STYLE PERSONNEL & PROFIL';

  @override
  String get stilVeTarzTercihleri => 'Préférences de style et coupe';

  @override
  String get secili => 'Sélectionné';

  @override
  String get tenRengiTercihinizUst => 'PRÉFÉRENCE DE CARNATION';

  @override
  String get yapayZekaVeStilHassasiyetiUst => 'IA & PRÉCISION DU STYLE';

  @override
  String get stilistKisiligiVeYantitTarziUst =>
      'PERSONNALITÉ DU STYLISTE & STYLE DE RÉPONSE';

  @override
  String get aiKisilikSamimiBaslik => 'Amical / Amical';

  @override
  String get aiKisilikSamimiAciklama =>
      'Ton chaleureux et encourageant rendant la mode ludique et accessible';

  @override
  String get aiKisilikElestirmenBaslik => 'Critique de mode professionnel';

  @override
  String get aiKisilikElestirmenAciklama =>
      'Conseils techniques axés sur la théorie des couleurs et les proportions';

  @override
  String get aiKisilikMinimalistBaslik => 'Minimaliste & Direct';

  @override
  String get aiKisilikMinimalistAciklama =>
      'Suggestions concises et directes, sans superflu';

  @override
  String get sikiRenkTeorisiUyumModu => 'Mode Théorie des couleurs stricte';

  @override
  String get sikiRenkTeorisiAciklama =>
      'S\'il est actif, l\'IA respecte exclusivement les règles classiques des couleurs';

  @override
  String get bildirimlerVeHatirlaticiUst => 'NOTIFICATIONS & RAPPELS';

  @override
  String get sabahKombinOnerisi => 'Suggestion de tenue du matin';

  @override
  String herSabahBildirimAl(Object saat) {
    return 'Recevoir des notifications quotidiennes à $saat';
  }

  @override
  String get bildirimSaatiniOzellestir =>
      'Personnaliser l\'heure de notification';

  @override
  String get gunlukKombinBildirimSaati =>
      'Heure de notification de la tenue quotidienne';

  @override
  String get sabahBildirimSaatiSec =>
      'Choisir l\'heure de notification du matin';

  @override
  String get saatKaydedildiAksama =>
      'Heure enregistrée, mais le service de notification est inaccessible.';

  @override
  String sabahBildirimiAyarlandi(Object saat) {
    return 'Notification du matin programmée pour $saat. ⏰';
  }

  @override
  String get bildirimIzinGerekliUyari =>
      'Activer les notifications dans les paramètres de votre appareil pour continuer.';

  @override
  String get camasirSepetiUyarilari => 'Alertes Panier à linge';

  @override
  String get camasirSepetiUyarilariAciklama =>
      'Recevez des alertes lorsque votre linge sale s\'accumule';

  @override
  String get haftalikStilRaporu => 'Rapport de style hebdomadaire';

  @override
  String get haftalikStilRaporuAciklama =>
      'Obtenez un résumé de l\'utilisation de votre garde-robe chaque dimanche soir';

  @override
  String get gorunumVeBolgeUst => 'APPARENCE & RÉGION';

  @override
  String get lokasyonVeBirimlerUst => 'LOCALISATION & UNITES';

  @override
  String get sicaklikBirimi => 'Unité de température';

  @override
  String get varsayilanSehirBolge => 'Ville / Région par défaut';

  @override
  String get sehirOrnekHint => 'Ex : Paris, Lyon, Marseille';

  @override
  String get gpsKullan => 'Utiliser le GPS';

  @override
  String get veriVeDepolamaYonetimiUst => 'GESTION DES DONNÉES & STOCKAGE';

  @override
  String get gorselOnbelleginiTemizle => 'Vider le cache d\'images';

  @override
  String get geciciFotografHafizasiAciklama =>
      'Libère de l\'espace mémoire temporaire réservé aux photos';

  @override
  String get onbellekTemizlendiBasari =>
      'Le cache d\'images et les fichiers temporaires ont été effacés ! ✨';

  @override
  String get onbellekTemizlerkenHata =>
      'Un problème est survenu lors du vidage du cache.';

  @override
  String get gardirobuDisaAktarYedekle => 'Exporter le dressing (Sauvegarde)';

  @override
  String get tumKiyafetVeKombinJsonAciklama =>
      'Exporter toutes les données de vêtements et de tenues au format JSON';

  @override
  String get disaAktarilacakVeriYok =>
      'Aucune donnée de dressing trouvée à exporter. 📭';

  @override
  String get gardiropVerisiKopyalandi =>
      'Toutes les données du dressing ont été copiées dans le presse-papier au format JSON ! 📋';

  @override
  String get destekVeDegerlendirmeUst => 'SUPPORT & AVIS';

  @override
  String get uygulamayiDegerlendirin => 'Évaluer l\'application';

  @override
  String get googlePlay5YildizDestek =>
      'Soutenez-nous en nous attribuant 5 étoiles sur Google Play ⭐';

  @override
  String get googlePlayAcilamadi => 'Impossible d\'ouvrir Google Play.';

  @override
  String get geriBildirimVeDestek => 'Commentaires & Support';

  @override
  String get hataBildirVeyaOneri =>
      'Signaler un bug ou suggérer de nouvelles fonctionnalités';

  @override
  String get islemTamamlanamadi =>
      'L\'opération n\'a pas pu être terminée. Veuillez réessayer.';

  @override
  String get epostaUygulamasiAcilamadi =>
      'Impossible d\'ouvrir l\'application e-mail. Écrivez-nous à ayberkzcn9@gmail.com.';

  @override
  String get gizlilikPolitikasiTitle => 'Politique de confidentialité';

  @override
  String get veriKullanimiVeGizlilikHaklari =>
      'Voir l\'utilisation des données et les droits à la confidentialité';

  @override
  String get sonGuncellemeTarihi => 'Dernière mise à jour : 27 août 2026';

  @override
  String get gizlilikMadde1Baslik => '1. Collecte et utilisation des données';

  @override
  String get gizlilikMadde1Icerik =>
      'FitCheck traite des informations pour optimiser la gestion de votre garde-robe et les recommandations de tenues. Vos photos, votre style et vos préférences de genre sont stockés localement sur votre appareil.';

  @override
  String get gizlilikMadde2Baslik => '2. Autorisations de localisation';

  @override
  String get gizlilikMadde2Icerik =>
      'La localisation en temps réel est traitée de manière anonyme via les services Open-Meteo dans le seul but de récupérer les conditions météo. Les données ne sont jamais stockées ni partagées.';

  @override
  String get gizlilikMadde3Baslik => '3. Assistant vocal et microphone';

  @override
  String get gizlilikMadde3Icerik =>
      'Lors de l\'utilisation de la commande vocale, vos paroles sont converties en texte instantanément. Les enregistrements audio ne sont pas stockés de façon permanente.';

  @override
  String get gizlilikMadde4Baslik => '4. Services tiers';

  @override
  String get gizlilikMadde4Icerik =>
      'Les infrastructures Firebase et Google AdMob sont utilisées pour l\'analyse des performances et la diffusion de publicités.';

  @override
  String get anladim => 'J\'ai compris';

  @override
  String get stilVeModaTercihleriniz => 'Préférences de style et mode';

  @override
  String get stilModalAciklama =>
      'L\'IA donnera la priorité à ces préférences de style et de coupe pour créer vos tenues.';

  @override
  String get favoriTarzinizUst => 'STYLE PRÉFÉRÉ';

  @override
  String get giyimKesimiFitUst => 'COUPE DES VÊTEMENTS';

  @override
  String get hesapSilmeUst => 'SUPPRESSION DU COMPTE';

  @override
  String get tumBulutVeYerelVeriTemizlenir =>
      'Efface l\'intégralité de vos données locales et dans le cloud';

  @override
  String get hakkindaUst => 'À PROPOS';

  @override
  String get topluFotografEkleTooltip => 'Ajout groupé de vêtements';

  @override
  String get kuponKoduKullanTitle => 'Utiliser un code promo';

  @override
  String get kuponKoduAciklama =>
      'Saisissez votre code promo ci-dessous pour obtenir des crédits de tenue supplémentaires :';

  @override
  String get kuponKoduHint => 'Ex : VIP2026';

  @override
  String get kuponKullanButon => 'Utiliser';

  @override
  String get kuponBasariliMesaji =>
      '🎉 Code promo appliqué avec succès ! Crédits ajoutés.';

  @override
  String get kuponKullanilmisUyari =>
      '⚠️ Vous avez déjà utilisé ce code promo !';

  @override
  String get kuponGecersizUyari =>
      '❌ Code promo invalide ! Veuillez réessayer.';

  @override
  String get sinirsizIslemHakkiBaslik => 'Crédits illimités 👑';

  @override
  String kalanHakkinizBaslik(Object hak) {
    return 'Crédits restants : $hak ⚡';
  }

  @override
  String get sinirsizHakAciklama =>
      'Profitez de créations de tenues et d\'analyses de style illimitées avec les avantages premium.';

  @override
  String get gunlukHakAciklama =>
      'Les crédits quotidiens sont réinitialisés chaque jour à 00:00. Vous pouvez regarder des publicités ou utiliser des codes promo pour en obtenir d\'autres.';

  @override
  String get kuponKullan => 'Utiliser un code promo';

  @override
  String get hakEklendiTebrikler => 'Félicitations ! +3 crédit ajouté. ✨';

  @override
  String get gardirobunDolduTitle => 'Dressing plein !';

  @override
  String gardirobunDolduIcerik(Object limit) {
    return 'Vous avez atteint votre limite de $limit vêtements. Regarder une courte vidéo pour augmenter la capacité de votre dressing de +3 articles ? 👕';
  }

  @override
  String get reklamIzleSlotEkle => 'Regarder une pub (+3 emplacements)';

  @override
  String get yeniSlotEklendiTebrikler =>
      'Félicitations ! +3 nouveaux emplacements ajoutés à votre dressing. 🎉';

  @override
  String get gunlukHakBittiTitle => 'Limite quotidienne atteinte !';

  @override
  String get gunlukHakBittiIcerik =>
      'Vous avez utilisé vos actions gratuites du jour. Regardez une vidéo ou entrez un code promo pour obtenir de nouveaux crédits ! 🛍️';

  @override
  String get kuponGir => 'Saisir un code';

  @override
  String get anaSemsiyeBildirimBaslik => 'N\'oubliez pas votre parapluie ! ☔';

  @override
  String get anaSemsiyeBildirimIcerik =>
      'Le temps semble pluvieux aujourd\'hui, pensez à choisir une tenue adaptée à la pluie.';

  @override
  String get anaCamasirGunuBildirimBaslik => 'Jour de lessive ! 🧺';

  @override
  String get anaCamasirGunuBildirimIcerik =>
      'Les vêtements sales s\'accumulent dans le panier. C\'est le moment de lancer une machine !';

  @override
  String chatZorunluParcaMesaji(Object parca) {
    return '✨ Que puis-je porter avec cet article ? ($parca)';
  }

  @override
  String chatKombinHazirBaslik(Object ortam) {
    return 'Votre tenue est prête ($ortam)';
  }

  @override
  String get chatKombiniGorButon => 'Voir la tenue';

  @override
  String get chatStilistKombinTasarlayor => 'Le styliste conçoit la tenue...';

  @override
  String get chatStilistYaziyor => 'Le styliste écrit...';

  @override
  String get pazartesi => 'Lundi';

  @override
  String get sali => 'Mardi';

  @override
  String get carsamba => 'Mercredi';

  @override
  String get persembe => 'Jeudi';

  @override
  String get cuma => 'Vendredi';

  @override
  String get cumartesi => 'Samedi';

  @override
  String get pazar => 'Dimanche';

  @override
  String get rehberiAtla => 'PASSER LE GUIDE';

  @override
  String get rehberAnladimBasla => 'Compris, c\'est parti !';

  @override
  String get rehberSonrakiAdim => 'Étape suivante ➔';

  @override
  String get rehberGardirobuDijitallestirBaslik =>
      '📸 Numérisez votre dressing';

  @override
  String get rehberGardirobuDijitallestirAciklama =>
      'Appuyez sur ce bouton pour prendre des photos ou télécharger depuis votre galerie afin de constituer votre dressing virtuel.';

  @override
  String get rehberSesliAsistanBaslik => '🎙️ Assistant de style vocal';

  @override
  String get rehberSesliAsistanAciklama =>
      'Utilisez les commandes vocales pour demander quoi porter ou recevoir des recommandations de tenues instantanées.';

  @override
  String get rehberAiStilistBaslik => '✨ Recommandations du styliste IA';

  @override
  String get rehberAiStilistAciklama =>
      'Obtenez en un seul geste des tenues sur mesure selon la météo, votre teint et vos préférences de style.';

  @override
  String get rehberAyarlarBaslik => '⚙️ Personnalisation & Paramètres';

  @override
  String get rehberAyarlarAciklama =>
      'Personnalisez votre genre, votre carnation, vos couleurs et votre thème, ou revoyez la présentation de démarrage.';

  @override
  String get rehberNavGardirobumBaslik => '👔 Mon dressing';

  @override
  String get rehberNavGardirobumAciklama =>
      'Affichez, filtrez et gérez facilement tous vos vêtements par catégorie.';

  @override
  String get rehberNavHaftalikBaslik => '📅 Planificateur hebdomadaire';

  @override
  String get rehberNavHaftalikAciklama =>
      'Planifiez vos tenues quotidiennes à l\'avance en fonction des prévisions météo sur 7 jours.';

  @override
  String get rehberNavDolaptanBaslik => '🤖 Tenues IA du dressing';

  @override
  String get rehberNavDolaptanAciklama =>
      'Laissez l\'IA générer automatiquement des tenues avec vos vêtements existants selon la journée.';

  @override
  String get rehberNavKendiBaslik => '🎨 Créer une tenue personnalisée';

  @override
  String get rehberNavKendiAciklama =>
      'Associez manuellement haut, bas et chaussures pour créer et enregistrer votre propre style.';

  @override
  String get rehberNavProfilBaslik => '📊 Analyses & Linge';

  @override
  String get rehberNavProfilAciklama =>
      'Consultez les statistiques de port de vos vêtements et suivez les articles non lavés dans le panier à linge.';

  @override
  String get bildirimIzinGerekliBaslik =>
      'Autorisation de notification requise';

  @override
  String get bildirimIzinGerekliIcerik =>
      'Nous vous recommandons d\'activer les notifications pour recevoir les rappels de lessive, les alertes pluie et les conseils de style quotidiens.';

  @override
  String get bildirimGunaydinBaslik => 'Bonjour ! ☀️';

  @override
  String get bildirimGunaydinIcerik =>
      'J\'ai préparé une super tenue pour la météo d\'aujourd\'hui. Voulez-vous y jeter un œil ?';

  @override
  String get bildirimKanalGenelBaslik => 'Notifications générales';

  @override
  String get bildirimKanalGenelAciklama =>
      'Mises à jour des notifications générales FitCheck';

  @override
  String get bildirimKanalGunlukBaslik => 'Suggestions de tenues quotidiennes';

  @override
  String get bildirimKanalGunlukAciklama =>
      'Alertes quotidiennes de recommandations de tenues';

  @override
  String get bildirimKanalYikamaBaslik => 'Rappels de lessive';

  @override
  String get bildirimKanalYikamaAciklama =>
      'Suivi du linge et rappels d\'entretien des vêtements';

  @override
  String get bildirimKanalRaporBaslik => 'Rapports de style hebdomadaires';

  @override
  String get bildirimKanalRaporAciklama =>
      'Résumés hebdomadaires de l\'utilisation de la garde-robe et du style';

  @override
  String get tenRengiAcik => 'Claire / Très claire';

  @override
  String get tenRengiBugday => 'Moyenne / Hâlée';

  @override
  String get tenRengiEsmer => 'Mat / Foncée';

  @override
  String get stilStreetwear => 'Streetwear / Décontracté';

  @override
  String get stilKlasik => 'Classique / Formel';

  @override
  String get stilMinimalist => 'Minimaliste';

  @override
  String get stilSpor => 'Sportif / Athleisure';

  @override
  String get stilVintage => 'Vintage / Rétro';

  @override
  String get fitSlim => 'Ajusté (Slim Fit)';

  @override
  String get fitRegular => 'Coupe droite (Regular)';

  @override
  String get fitOversize => 'Ample / Oversize';

  @override
  String get gardirobumBosBaslik => 'Votre dressing est bien vide !';

  @override
  String get gardirobumGizlendiBaslik => 'Dressing masqué';

  @override
  String get gardirobumGizlendiAciklama =>
      'Appuyez sur l\'icône de l\'œil en haut à droite pour afficher le contenu';

  @override
  String get gardirobumGoster => 'Afficher le contenu';

  @override
  String get gardirobumGizle => 'Masquer le contenu';

  @override
  String get kategoriUst => 'HAUTS';

  @override
  String get kategoriAlt => 'BAS';

  @override
  String get kategoriAyakkabi => 'CHAUSSURES';

  @override
  String get kategoriAksesuar => 'ACCESSOIRES';

  @override
  String get gardirobumBosAciklama =>
      'Ajoutez votre premier vêtement dès maintenant et observez la magie de l\'IA.';

  @override
  String get gardirobumAiIslem1 => 'Analyse de votre dressing...';

  @override
  String get gardirobumAiIslem2 => 'Vérification des conditions météo...';

  @override
  String get gardirobumAiIslem3 => 'Calcul de l\'harmonie des couleurs...';

  @override
  String get gardirobumAiIslem4 => 'Sélection des meilleures tenues...';

  @override
  String get gardirobumAiIslem5 => 'Finalisation des détails...';

  @override
  String get gardirobumHakBittiBaslik => 'Limite quotidienne atteinte';

  @override
  String get gardirobumHakBittiAciklama =>
      'Vous avez atteint votre limite quotidienne de création de tenues.';

  @override
  String get gardirobumHakEklendiMesaj =>
      'Félicitations, nouveau crédit de tenue obtenu !';

  @override
  String get ayarlariAc => 'Ouvrir les paramètres';

  @override
  String get kiyafetEkle => 'Ajouter un vêtement';

  @override
  String get kameraIleCek => 'Prendre une photo';

  @override
  String get galeridenSecToplu => 'Sélectionner depuis la galerie';

  @override
  String get kameraIzniGerekliBaslik => 'Autorisation de la caméra requise';

  @override
  String get kameraIzniGerekliAciklama =>
      'Veuillez activer l\'autorisation de l\'appareil photo pour prendre des photos.';

  @override
  String get kiyafetDuzenleBaslik => 'Modifier le vêtement';

  @override
  String get kategori => 'Catégorie';

  @override
  String get evetSil => 'Oui, supprimer';

  @override
  String get favorilerdenCikarildi => 'Retiré des favoris';

  @override
  String get gardirobumHenuzYokEkle =>
      'Aucun vêtement ajouté pour le moment. Ajoutez-en un dès maintenant !';

  @override
  String gardirobumMaksFotografUyari(int max) {
    return 'Vous pouvez sélectionner jusqu\'à $max photos à la fois.';
  }

  @override
  String gardirobumUrunSayisi(int count) {
    return '$count articles';
  }

  @override
  String kombinUyumYuzdesi(String oran) {
    return '%$oran d\'harmonie';
  }

  @override
  String get kombinSohbetAc => 'Discuter de la tenue';

  @override
  String get kombinSohbetBaslik => 'Chat de la tenue';

  @override
  String kombinSohbetAltBaslik(Object gun) {
    return 'Discussion sur votre tenue du $gun';
  }

  @override
  String kombinSohbetKarsilama(Object kombin) {
    return 'Analysons ensemble votre tenue « $kombin » ! Posez-moi vos questions sur l\'harmonie des couleurs, la météo ou des pièces alternatives. ✨';
  }

  @override
  String get kombinSohbetOneriUyum =>
      '🤔 Pourquoi cette tenue fonctionne-t-elle ?';

  @override
  String get kombinSohbetOneriAlternatif => '👟 Propose une pièce alternative';

  @override
  String get kombinSohbetOneriHava => '🌦️ Et si la météo change ?';

  @override
  String get kombinSohbetOneriAksesuar =>
      '💍 Donne-moi des idées d\'accessoires';

  @override
  String get kombinSohbetAltBaslikAnlik => 'Discussion sur ta tenue du moment';

  @override
  String get chatKirliSepetiBos =>
      '🧺 Ton panier à linge est vide ! Toutes tes pièces sont prêtes à être portées — je peux te composer une tenue quand tu veux. ✨';

  @override
  String chatKirliSepetiDoluBaslik(Object sayi) {
    return '🧺 **$sayi** pièces attendent dans ton panier à linge :';
  }

  @override
  String get chatKirliSepetiDoluNot =>
      'Ces pièces restent exclues de tes suggestions de tenues jusqu’au lavage. Si tu veux, je peux te composer une tenue avec tes pièces propres tout de suite.';

  @override
  String get analitikVerileriPaylas => 'Partager les données d\'analyse';

  @override
  String get analitikVerileriPaylasAciklama =>
      'Des données d\'usage anonymes sont envoyées pour améliorer l\'application. Si vous désactivez cette option, les données d\'analyse de cet appareil sont supprimées.';

  @override
  String get chatKarsilamaHavaYok =>
      'Bonjour ! 👋 On te compose une super tenue qui correspond à ton style ? ✨';

  @override
  String get premiumBaslik => 'Style illimité, zéro pub';

  @override
  String get premiumAciklama =>
      'Utilise tes tenues et tes analyses de style sans limite et supprime toutes les publicités avec un seul abonnement.';

  @override
  String get premiumOzellikReklamsiz => 'Toutes les publicités sont supprimées';

  @override
  String get premiumOzellikAylik => 'Renouvellement automatique chaque mois';

  @override
  String get premiumOzellikMagaza => 'Géré via Google Play';

  @override
  String get premiumAktifMesaji =>
      'Premium est actif. Utilisation illimitée et sans publicité.';

  @override
  String get premiumAboneOl => 'S\'abonner';

  @override
  String premiumAboneOlFiyatli(String fiyat) {
    return 'S\'abonner • $fiyat';
  }

  @override
  String get premiumGeriYukle => 'Restaurer l’achat';

  @override
  String get premiumMagazaHazirDegil =>
      'Google Play n’est pas disponible pour le moment. Réessaie plus tard.';

  @override
  String get premiumSatinAlmaBaslatilamadi => 'L’achat n’a pas pu démarrer.';

  @override
  String get premiumSatinAlmaBasarisiz => 'L’achat a échoué.';

  @override
  String get premiumAylikBaslik => 'FitCheck Premium';

  @override
  String premiumAylikAltBaslik(String fiyat) {
    return 'Tenues illimitées • $fiyat/mois';
  }

  @override
  String premiumGec(String fiyat) {
    return 'Passe à l\'illimité • $fiyat/mois';
  }

  @override
  String get guncellemeBaslik => 'Mise à jour requise';

  @override
  String get guncellemeAciklama =>
      'Une nouvelle version de FitCheck est disponible. Veuillez mettre à jour l\'application pour continuer.';

  @override
  String get guncellemeButonu => 'Mettre à jour';

  @override
  String guncellemeYeniSurum(String surum) {
    return 'Nouvelle version : $surum';
  }

  @override
  String get guncellemeMagazaUrlYok =>
      'Le lien du store n\'a pas pu être ouvert. Veuillez mettre à jour l\'application depuis le store.';

  @override
  String get premiumUrunBulunamadi =>
      'Les informations d\'abonnement n\'ont pas pu être chargées. Réessayez plus tard.';

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
  String get kombinOyunuBaslik => 'Jeu de Combinaisons';

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
  String get degerlendirmeBaslik => 'Vous aimez FitCheck ?';

  @override
  String get degerlendirmeIcerik =>
      'Si vous aimez l\'application, prenez 5 secondes pour nous laisser un avis ! Les petits avis sont d\'une grande aide ! ⭐ Les évaluateurs reçoivent +3 crédits gratuits en cadeau !';

  @override
  String get degerlendirmeEvet => 'Oui, je vais l\'évaluer';

  @override
  String get degerlendirmeBelkiSonra => 'Peut-être plus tard';

  @override
  String get yakinda => 'Bientôt';

  @override
  String get yakindaAciklama =>
      'Nous travaillons sur cette fonctionnalité, elle arrive très bientôt !';

  @override
  String get aiOneriHazirlaniyor => 'Préparation d’une suggestion...';

  @override
  String get haftalikStilistOnerisiHazirlanamadi =>
      'Impossible de préparer la suggestion du styliste. Réessayez.';

  @override
  String get haftalikAiServisHatasi =>
      'Impossible d’atteindre le service IA. Vérifiez votre connexion Internet et réessayez.';

  @override
  String get haftalikAiGecerliPlanYok =>
      'L’IA n’a pas renvoyé de plan valide. Réessayez.';

  @override
  String get haftalikPlanBeklenmeyenHata =>
      'Une erreur inattendue est survenue lors de la création du plan. Réessayez.';

  @override
  String get haftalikBugunGiyildi =>
      'La tenue d’aujourd’hui est déjà portée ; aucune nouvelle tenue n’a été créée.';

  @override
  String get girisHataKullaniciAdiKisa => 'Saisissez au moins 3 caractères';

  @override
  String get girisHataEpostaGecersiz => 'Saisissez un e-mail valide';

  @override
  String get girisHataSifreKisa => 'Saisissez au moins 6 caractères';

  @override
  String get googleKullanicisi => 'Utilisateur Google';

  @override
  String get premiumEkranBaslik => 'FitCheck Premium';

  @override
  String get dilSecimBaslik => '🌐 Choisir la langue';

  @override
  String get dilSecenekOtomatik => 'Automatique (langue de l’appareil)';

  @override
  String get kapat => 'Fermer';

  @override
  String get bildirimBaslik => 'Notification';

  @override
  String get ayarlarAltbilgi => 'Fait avec style';

  @override
  String get geriBildirimKonu => 'FitCheck Avis';

  @override
  String get premiumOzelliklerBaslik => 'Ce que Premium débloque';

  @override
  String get premiumOzellikSinirsizKombin => 'Création de tenues illimitée';

  @override
  String get premiumOzellikSinirsizAnaliz => 'Analyse de style IA illimitée';

  @override
  String get premiumOzellikSinirsizGardirob => 'Espace dressing illimité';

  @override
  String get premiumPlanAylik => 'Mensuel';

  @override
  String get premiumPlanYillik => 'Annuel';

  @override
  String get premiumEnAvantajli => 'MEILLEUR CHOIX';

  @override
  String premiumTasarrufYuzde(int yuzde) {
    return 'Économisez $yuzde %';
  }

  @override
  String premiumDenemeRozeti(int gun) {
    return '$gun JOURS GRATUITS';
  }

  @override
  String premiumDenemeSonrasi(String fiyat) {
    return 'Puis $fiyat';
  }

  @override
  String get premiumYenilemeNotu =>
      'L\'abonnement se renouvelle automatiquement à la fin de chaque période. Annulable à tout moment.';

  @override
  String get kiyafetDondur => 'Pivoter';

  @override
  String get stilistHafizasiBaslik => 'Mémoire du styliste';

  @override
  String stilistHafizasiAltBaslikNotlu(int sayi) {
    return 'Retient $sayi notes';
  }

  @override
  String get stilistHafizasiAltBaslikBos => 'Ne retient rien pour l\'instant';

  @override
  String get stilistHafizasiAciklama =>
      'Le styliste enregistre sous forme de notes permanentes ce qu\'il apprend dans tes conversations et personnalise ses suggestions. Les notes restent uniquement sur cet appareil.';

  @override
  String get stilistHafizasiNelerBiliyor => 'Que retient-il ?';

  @override
  String get stilistHafizasiOzetBaslik =>
      'Résumé de tes conversations récentes';

  @override
  String get stilistHafizasiBos =>
      'Je n\'ai encore rien appris. Je découvrirai ton style au fil des conversations.';

  @override
  String get stilistHafizasiTemizle => 'Effacer la mémoire';

  @override
  String get stilistHafizasiTemizleOnay =>
      'Tout ce que le styliste retient de toi sera supprimé. Cette action est irréversible.';

  @override
  String get stilistHafizasiTemizlendi => 'Mémoire effacée 🧠';
}
