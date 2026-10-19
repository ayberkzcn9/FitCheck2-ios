// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get chatOrtamCasual => 'Casual';

  @override
  String get chatOrtamOfis => 'Büro';

  @override
  String get chatOrtamDavet => 'Einladung';

  @override
  String get chatOrtamSpor => 'Sport';

  @override
  String get chatOrtamGece => 'Abend';

  @override
  String get chatOrtamRomantik => 'Romantisch';

  @override
  String get chatOrtamHaftaSonu => 'Wochenende';

  @override
  String get gardirobumAdimArkaplan => 'Hintergrund wird entfernt';

  @override
  String get gardirobumAdimArkaplanAlt => 'Bild wird mit KI analysiert';

  @override
  String get gardirobumAdimAnaliz => 'Kleidungsstück wird analysiert';

  @override
  String get gardirobumAdimAnalizAlt =>
      'Farbe, Stil und Kategorie werden erkannt';

  @override
  String get gardirobumAdimKaydet => 'Wird gespeichert';

  @override
  String get gardirobumAdimKaydetAlt => 'Wird zur Garderobe hinzugefügt';

  @override
  String get gardirobumLutfenBekleyin => 'Bitte warten...';

  @override
  String get authHataZayifSifre =>
      'Das Passwort ist zu schwach. Es muss mindestens 6 Zeichen haben.';

  @override
  String get authHataEpostaKullanimda =>
      'Diese E-Mail-Adresse wird bereits verwendet.';

  @override
  String get authHataGecersizEposta =>
      'Sie haben eine ungültige E-Mail-Adresse eingegeben.';

  @override
  String get authHataKullaniciBulunamadi =>
      'Für diese E-Mail-Adresse wurde kein Benutzer gefunden.';

  @override
  String get authHataYanlisSifre =>
      'Falsches Passwort, bitte versuchen Sie es erneut.';

  @override
  String get authHataGecersizKimlik =>
      'E-Mail oder Passwort ist falsch. Bitte prüfen Sie Ihre Angaben.';

  @override
  String get authHataYontemIzinliDegil =>
      'Diese Anmeldemethode ist in der Firebase-Konsole nicht aktiviert.';

  @override
  String get authHataFarkliYontem =>
      'Diese E-Mail ist bereits mit einer anderen Anmeldemethode registriert.';

  @override
  String get authHataAgHatasi =>
      'Überprüfen Sie Ihre Internetverbindung und versuchen Sie es erneut.';

  @override
  String get authHataCokDeneme =>
      'Zu viele Versuche. Bitte versuchen Sie es später erneut.';

  @override
  String get authHataHesapDevreDisi => 'Dieses Konto wurde deaktiviert.';

  @override
  String get authHataYenidenGiris =>
      'Sie müssen sich erneut anmelden, um diese Aktion auszuführen.';

  @override
  String get authHataGenel =>
      'Ein Fehler ist aufgetreten. Bitte versuchen Sie es erneut.';

  @override
  String get authHataSifreEpostasiGonderilemedi =>
      'Die E-Mail zum Zurücksetzen des Passworts konnte nicht gesendet werden.';

  @override
  String get authHataGoogleDogrulanamadi =>
      'Die Google-Anmeldung konnte nicht bestätigt werden.';

  @override
  String get authHataGoogleFarkliKullanici =>
      'Dieses Google-Konto ist mit einem anderen Benutzer verknüpft.';

  @override
  String get authHataGoogleZatenBagli =>
      'Dieses Google-Konto ist bereits verknüpft.';

  @override
  String get authHataGoogleYapilandirilmamis =>
      'Die Google-Anmeldung ist auf diesem Gerät nicht konfiguriert. Bitte melden Sie dies dem Support.';

  @override
  String get authHataGooglePencereAcik =>
      'Das Google-Anmeldefenster ist noch geöffnet. Warten Sie kurz und versuchen Sie es erneut.';

  @override
  String get authHataGoogleTamamlanamadi =>
      'Die Google-Anmeldung konnte nicht abgeschlossen werden. Bitte versuchen Sie es gleich erneut.';

  @override
  String get authHataGoogleHesapSec =>
      'Sie müssen Ihr Google-Konto auswählen, um sich anzumelden.';

  @override
  String get authHataGoogleOnayBekliyor =>
      'In Ihrem Google-Konto steht eine Aktion aus. Bitte versuchen Sie es erneut.';

  @override
  String get authHataGoogleBeklenmeyen =>
      'Bei der Google-Anmeldung ist ein unerwarteter Fehler aufgetreten.';

  @override
  String get appTitle => 'FitCheck';

  @override
  String get gorunumVeTema => 'Aussehen und Design';

  @override
  String get karanlikMod => 'Dunkelmodus';

  @override
  String get koyuTemaAktif => 'Dunkles Design aktiv';

  @override
  String get acikTemaAktif => 'Helles Design aktiv';

  @override
  String get dilAyarlari => 'Sprach- und Regionseinstellungen';

  @override
  String get uygulamaDili => 'App-Sprache';

  @override
  String get hakkinda => 'Über die App';

  @override
  String get surum => 'Version';

  @override
  String get ayarOtomatikCihazDili => '🌐 Automatisch (Systemsprache)';

  @override
  String get iptal => 'Abbrechen';

  @override
  String get tamam => 'OK';

  @override
  String get gardirobumTitle => 'VIRTUELLER KLEIDERSCHRANK';

  @override
  String get gardirobumYukleniyor => 'KI prüft...';

  @override
  String get gardirobumTopluEkle => 'Mehrere Teile hinzufügen';

  @override
  String gardirobumInceleniyor(Object kacinci, Object toplam) {
    return 'Wird geprüft ($kacinci/$toplam)';
  }

  @override
  String get gardirobumTemizleBaslik => 'Kleiderschrank leeren';

  @override
  String get gardirobumTemizleOnay =>
      'Alle Kleidungsstücke in deinem Schrank werden gelöscht. Bist du sicher?';

  @override
  String get gardirobumEvet => 'Ja, leeren';

  @override
  String get gardirobumHataMesaji =>
      'Beim Hinzufügen der Teile ist ein Fehler aufgetreten.';

  @override
  String get gardirobumKategoriTumu => 'Alle';

  @override
  String get gardirobumKategoriUst => 'Oberteile';

  @override
  String get gardirobumKategoriAlt => 'Unterteile';

  @override
  String get gardirobumKategoriAyakkabi => 'Schuhe';

  @override
  String get gardirobumKategoriAksesuar => 'Accessoires';

  @override
  String get gardirobumBosKategori =>
      'Keine Artikel in dieser Kategorie gefunden.';

  @override
  String get gardirobumGiymeSayisi => 'Getragen:';

  @override
  String gardirobumMaliyet(Object tutar) {
    return 'Kosten: ₺$tutar / Tragen';
  }

  @override
  String get gardirobumDolabaAl => 'In den Schrank';

  @override
  String get gardirobumSepeteAt => 'In die Wäsche';

  @override
  String get gardirobumSepetteRozet => 'IN WÄSCHE';

  @override
  String get gardirobumGecersizParcaBaslik => 'Ungültiger Artikel erkannt';

  @override
  String get gardirobumGecersizParcaIcerik =>
      'Unser System konnte in diesem Bild keine Kleidung, Schuhe oder Accessoires erkennen (Holzgegenstand, Möbelstück, Haushaltsgegenstand oder inkompatibles Objekt erkannt). Bitte lade nur Kleidungsstücke hoch.';

  @override
  String get gardirobumTamam => 'OK';

  @override
  String get stilistTitle => 'SOFORT-OUTFIT-STYLIST';

  @override
  String get gunlukKombinTitle => 'TAGESOUTFIT';

  @override
  String get gunlukKombinHazirBaslik => 'Bereit für dein Outfit?';

  @override
  String get gunlukKombinHazirIcerik =>
      'Würfle oder schüttle dein Handy, um das heutige Outfit zu erstellen.';

  @override
  String get gunlukKombinKartBaslik => 'Heutiges Outfit';

  @override
  String get stilistAnlikHavaDurumu =>
      'Aktuelles Wetter (Zum Aktualisieren tippen)';

  @override
  String get stilistKonumKontrol => 'Standort wird überprüft...';

  @override
  String get stilistNereyeGidiyorsun => 'Wo gehst du hin?';

  @override
  String get stilistDusunuyor => 'Stylist denkt nach...';

  @override
  String get stilistBugunNeGiymeliyim => 'Was soll ich heute anziehen?';

  @override
  String get stilistKombiniTemizle => 'Outfit zurücksetzen';

  @override
  String stilistKombininTitle(Object ortam) {
    return 'Dein $ortam-Outfit';
  }

  @override
  String stilistUyum(Object puan) {
    return '🎨 Übereinstimmung: $puan%';
  }

  @override
  String get stilistUstGiyim => 'Oberteil';

  @override
  String get stilistAltGiyim => 'Unterteil';

  @override
  String get stilistAyakkabi => 'Schuhe';

  @override
  String get stilistAksesuar => 'Accessoire';

  @override
  String get stilistFavoriyeEkle => 'Zu Favoriten hinzufügen';

  @override
  String get stilistBugunGiydim => 'Heute getragen';

  @override
  String get bugunGiydimOnayIcerik => 'Hast du dieses Outfit heute getragen?';

  @override
  String get stilistTrendyolTamamla => 'Bei Trendyol vervollständigen';

  @override
  String get stilistHata =>
      'Beim Erstellen des Outfits ist ein Fehler aufgetreten.';

  @override
  String get ortamCasual => 'Freizeit / Casual';

  @override
  String get ortamOfis => 'Büro / Arbeit';

  @override
  String get ortamDavet => 'Hochzeit / Besonderer Anlass';

  @override
  String get ortamSpor => 'Sport / Laufen';

  @override
  String get ortamGece => 'Ausgehen / Nacht';

  @override
  String get ortamRomantik => 'Romantisches Date';

  @override
  String get stilistUyariDolapBosBaslik =>
      'Dein Kleiderschrank ist leer oder alles ist in der Wäsche! 🧺';

  @override
  String get stilistUyariDolapBosIcerik =>
      'Damit ich dir personalisierte Sofort-Outfits erstellen kann, musst du saubere Kleidung oder Accessoires in deinen Schrank legen.';

  @override
  String get stilistUyariUstEksikBaslik => 'Oberteil fehlt! 👕';

  @override
  String get stilistUyariUstEksikIcerik =>
      'Du hast noch keine sauberen Oberteile im Schrank. Füge mindestens ein Oberteil hinzu!';

  @override
  String get stilistUyariAltEksikBaslik => 'Unterteil fehlt! 👖';

  @override
  String get stilistUyariAltEksikIcerik =>
      'Du hast noch keine sauberen Unterteile im Schrank. Füge ein Unterteil hinzu für ein schickes Outfit!';

  @override
  String get stilistUyariAyakkabiEksikBaslik => 'Schuhe fehlen! 👟';

  @override
  String get stilistUyariAyakkabiEksikIcerik =>
      'Deine Kleidung sieht toll aus, aber ich konnte keine sauberen Schuhe finden. Füge sofort welche hinzu!';

  @override
  String get stilistUyariButon => 'Verstanden, füge ich hinzu!';

  @override
  String get anaHavaYukleniyor => 'Wetter für Standort wird geladen...';

  @override
  String get anaDinliyor => '🎙️ FITCHECK hört zu... Sprich!';

  @override
  String get anaMikrofonHata =>
      'Mikrofonberechtigung oder Spracherkennungsdienst nicht bereit.';

  @override
  String anaCinsiyetGuncellendi(Object cinsiyet) {
    return 'Präferenz aktualisiert zu \"$cinsiyet\" ✨';
  }

  @override
  String get anaKonumKapaliBaslik => 'Standortdienst deaktiviert';

  @override
  String get anaKonumKapaliIcerik =>
      'Bitte aktiviere die GPS-Ortung, um wetterbasierte Outfit-Empfehlungen zu erhalten.';

  @override
  String get anaKonumuAc => 'Standort aktivieren';

  @override
  String get anaIzinVer => 'Erlauben';

  @override
  String get anaIptal => 'Abbrechen';

  @override
  String get anaKonumIzinRedBaslik => 'Standortberechtigung verweigert';

  @override
  String get anaKonumIzinRedIcerik1 =>
      'Vorhersage konnte nicht abgerufen werden, da die Berechtigung verweigert wurde.';

  @override
  String get anaKonumIzinRedIcerik2 =>
      'Du musst die Berechtigung in den Einstellungen erteilen.';

  @override
  String get anaKonumIzinGerekliBaslik => 'Standortberechtigung erforderlich';

  @override
  String get anaKonumIzinGerekliIcerik =>
      'Du musst die Standortberechtigung in den Einstellungen aktivieren, damit die App das Wetter abrufen kann.';

  @override
  String get anaHavaDurumuAlinamadi => 'Wetter konnte nicht abgerufen werden';

  @override
  String get anaHavaTahminiYuklenemedi =>
      'Wettervorhersage konnte nicht geladen werden.';

  @override
  String get anaFavoriEklendi => 'Outfit zu Favoriten hinzugefügt! ⭐';

  @override
  String get anaKombinTekrarUyari =>
      '⚠️ Warnung: Du hast diese oder ähnliche Teile in letzter Zeit sehr oft getragen. Probier heute mal einen anderen Stil!';

  @override
  String get anaKombinMukemmel =>
      '✨ Große Klasse! Dein Stil ist heute sehr ausgewogen und frisch.';

  @override
  String get anaYikamaUyariBaslik => 'Smart-Wasch-Warnung';

  @override
  String anaYikamaUyariIcerik(Object parcalar) {
    return 'Weil du dieses Outfit getragen hast, wurden die Artikel \"$parcalar\" häufig verwendet und automatisch in den Wäschekorb gelegt! 🧺';
  }

  @override
  String get anaTamam => 'OK';

  @override
  String get anaAyarlarTooltip => 'Einstellungen';

  @override
  String get anaKadin => 'Weiblich';

  @override
  String get anaErkek => 'Männlich';

  @override
  String get anaSesleKonus => 'Sprachbefehl';

  @override
  String get anaStilistAsistani => 'Stylist-Assistent';

  @override
  String get anaSekmeGardirop => 'Schrank';

  @override
  String get anaSekmeHaftalik => 'Wöchentlich';

  @override
  String get anaSekmeAnlik => 'Sofort';

  @override
  String get anaSekmeYarismasi => 'Quiz';

  @override
  String get anaSekmeProfil => 'Profil & Analyse';

  @override
  String get modaYarismasiBaslik => 'Mode & Farbharmonie';

  @override
  String get modaYarismasiGunlukTamamlandi => 'Heutiges Quiz abgeschlossen';

  @override
  String get modaYarismasiYeniYarin =>
      'Ein neuer 5-Fragen-Set ist morgen verfügbar.';

  @override
  String get modaYarismasiSonuc => 'Ergebnis';

  @override
  String modaYarismasiSkor(Object skor) {
    return 'Punktzahl: $skor / 10';
  }

  @override
  String modaYarismasiSoru(Object index) {
    return 'Frage $index / 10';
  }

  @override
  String get modaYarismasiGeri => 'Zurück';

  @override
  String get modaYarismasiAnaEkrana => 'Zurück zur Startseite';

  @override
  String get havaParcaliBulutlu => 'Teilweise bewölkt';

  @override
  String get havaSicakGunesli => 'Heiß und sonnig';

  @override
  String get havaSogukKarli => 'Kalt und verschneit';

  @override
  String get havaYagmurlu => 'Regnerisch';

  @override
  String get havaGunesli => 'Sonnig';

  @override
  String get havaSoguk => 'Kalt';

  @override
  String get gunPzt => 'Montag';

  @override
  String get gunSal => 'Dienstag';

  @override
  String get gunCar => 'Mittwoch';

  @override
  String get gunPer => 'Donnerstag';

  @override
  String get gunCum => 'Freitag';

  @override
  String get gunCmt => 'Samstag';

  @override
  String get gunPaz => 'Sonntag';

  @override
  String get stilKahveBaslik => '☕ Kaffee & Casual';

  @override
  String get stilKahveSoru =>
      'Schlage ein schick-lässiges Outfit für einen Kaffeetrinken mit Freunden vor';

  @override
  String get stilOfisBaslik => '💼 Büro / Business-Schick';

  @override
  String get stilOfisSoru =>
      'Schlage ein modernes und elegantes Outfit für das Büro vor';

  @override
  String get stilSporBaslik => '🏃 Sportlich / Bequem';

  @override
  String get stilSporSoru =>
      'Schlage ein sehr bequemes, sportliches Outfit für einen Wochenendausflug vor';

  @override
  String get stilGeceBaslik => '🌙 Abend / Besonderer Anlass';

  @override
  String get stilGeceSoru =>
      'Schlage ein auffälliges Outfit für ein Abendessen oder Event vor';

  @override
  String get ilkGorevBaslik => '🎯 Erste Mission: Wähle deinen Vibe!';

  @override
  String get ilkGorevAciklama =>
      'Die FitCheck-KI erstellt sofort ein Outfit für dich. Wo gehst du heute hin?';

  @override
  String get haftalikUyariButon => 'Verstanden';

  @override
  String get haftalikUyariDolapBosBaslik => 'Dein Kleiderschrank ist leer!';

  @override
  String get haftalikUyariDolapBosIcerik =>
      'Du musst Kleidung hinzufügen, um einen Wochenplan zu erstellen.';

  @override
  String get haftalikUyariUstEksikBaslik => 'Oberteile fehlen!';

  @override
  String get haftalikUyariUstEksikIcerik =>
      'Du hast keine sauberen Oberteile im Schrank.';

  @override
  String get haftalikUyariAltEksikBaslik => 'Unterteile fehlen!';

  @override
  String get haftalikUyariAltEksikIcerik =>
      'Du hast keine sauberen Unterteile im Schrank.';

  @override
  String get haftalikUyariAyakkabiEksikBaslik => 'Schuhe fehlen!';

  @override
  String get haftalikUyariAyakkabiEksikIcerik =>
      'Es befinden sich keine sauberen Schuhe im Schrank.';

  @override
  String get haftalikHata => 'Fehler beim Erstellen des Wochenplans.';

  @override
  String get haftalikAjandaTitle => 'WÖCHENTLICHE STIL-AGENDA';

  @override
  String get haftalikAnlikHavaDurumu => 'Wöchentliche Wettervorhersage';

  @override
  String get haftalikKonumKontrol => 'Wetter wird geladen...';

  @override
  String get haftalikTemizParca => 'Saubere Teile';

  @override
  String get haftalikSepette => 'In der Wäsche';

  @override
  String get haftalikPlanAciklama =>
      'Lass die KI deinen 7-Tage-Outfit-Plan basierend auf dem Wetter erstellen.';

  @override
  String get haftalikProgramOlustur => 'Wochenplan erstellen';

  @override
  String get haftalikPlaniTemizle => 'Plan löschen';

  @override
  String get haftalikAnalizEdiliyor => 'KI plant...';

  @override
  String get haftalikUyum => 'Match';

  @override
  String get haftalikFavoriEkle => 'Zu Favoriten';

  @override
  String get haftalikGiyildiIsaretle => 'Heute getragen';

  @override
  String get haftalikHava => 'Wetter:';

  @override
  String get haftalikHavaUyarisi =>
      'Hinweis: Einige Teile dieses Outfits wurden an das Wetter des Tages angepasst.';

  @override
  String get haftalikUyumsuzParca => 'Fehlendes Teil';

  @override
  String get haftalikEksikParcaStilistNotu =>
      'Der Stylist hat das fehlende Teil berücksichtigt und die Vorschläge mit deinen sauberen Teilen erstellt.';

  @override
  String get haftalikEksikParcaYeterliParcaYok =>
      'Es sind nicht genug saubere Teile übrig, um diesen Tag zu füllen. Füge ein neues Teil hinzu oder wasche deine Kleidung – dann schlägt der Stylist hier ein neues Outfit vor.';

  @override
  String get haftalikEksikParcaAiOnerisi => 'KI-Outfit-Vorschlag';

  @override
  String get haftalikEksikParcaOneriYok =>
      'Erneuere den Plan, um eine Kombination aus Oberteil, Hose und Schuhen zu sehen, die das fehlende Teil ergänzt.';

  @override
  String get haftalikEksikParcaOnerisiBaslik => 'KI-Stylist-Outfit-Vorschlag';

  @override
  String get haftalikEksikParcaOneriHazirlaniyor =>
      'Der Stylist bereitet einen Outfit-Vorschlag vor…';

  @override
  String get haftalikEksikParcaPlanKurulamadi =>
      'Ohne Oberteil und Hose lässt sich kein Outfit zusammenstellen. Der Stylist hat oben einen Vorschlag vorbereitet.';

  @override
  String get haftalikNot => 'Notiz';

  @override
  String get haftalikTrendyolAra => 'Bei Trendyol suchen';

  @override
  String get izinZorunluMesaj =>
      'Diese Berechtigungen sind erforderlich, um die App zu nutzen.';

  @override
  String get izinGerekliBaslik => 'Berechtigung erforderlich';

  @override
  String get izinGerekliIcerik =>
      'Kamera- und Standortberechtigungen wurden verweigert. Du musst sie in den Einstellungen aktivieren.';

  @override
  String get ayarlaraGit => 'Zu den Einstellungen';

  @override
  String get izinAnaBaslik => 'Berechtigungen erforderlich';

  @override
  String get izinAciklama =>
      'Wir benötigen Standort- (Wetter) und Kamera- (Foto) Berechtigungen, um dir die besten Outfits anzubieten.';

  @override
  String get konumIzni => 'Standortberechtigung';

  @override
  String get kameraIzni => 'Kameraberechtigung';

  @override
  String get izinVerDevamEt => 'Erlauben und fortfahren';

  @override
  String get gunlukHavaMevcutDegil => 'Wetterdaten nicht verfügbar';

  @override
  String get profilAnalizTitle => 'PROFIL & ANALYSE';

  @override
  String get anlikDurum => 'Aktueller Status';

  @override
  String get toplamParca => 'Gesamtanzahl Artikel';

  @override
  String get favoriKombin => 'Lieblingsoutfit';

  @override
  String get gardiropDegeri => 'Schrankwert';

  @override
  String get ortalamaMaliyet => 'Durchschnittliche Kosten';

  @override
  String get kategoriDagilimi => 'Kategorienverteilung';

  @override
  String get ustGiyim => 'Oberteile';

  @override
  String get altGiyim => 'Unterteile';

  @override
  String get ayakkabi => 'Schuhe';

  @override
  String get disGiyim => 'Oberbekleidung';

  @override
  String get aksesuar => 'Accessoires';

  @override
  String get sonGiyecekGecmisi => 'Kürzlich getragen';

  @override
  String get kayit => 'Eintrag';

  @override
  String get gecmisKombinYok => 'Noch keine Outfit-Historie vorhanden.';

  @override
  String get parca => 'Artikel';

  @override
  String get onboardingHosGeldinBaslik => 'Willkommen bei FitCheck! ✨';

  @override
  String get onboardingDolabiniDijitallestir => 'Digitalisiere deinen Schrank';

  @override
  String get onboardingDolapAciklama =>
      'Füge deine Kleidung in Sekundenschnelle hinzu und baue deinen virtuellen Schrank auf.';

  @override
  String get onboardingHavaDurumu => 'Wetterangepasst';

  @override
  String get onboardingHavaAciklama =>
      'Erhalte Outfit-Empfehlungen, die perfekt zum täglichen Wetter deines Standorts passen.';

  @override
  String get onboardingYikama => 'Intelligente Wäscheverfolgung';

  @override
  String get onboardingYikamaAciklama =>
      'Das System erkennt oft getragene Kleidung automatisch und schickt sie in den Wäschekorb.';

  @override
  String get onboardingEksikParca => 'Fehlende Teile';

  @override
  String get onboardingEksikAciklama =>
      'Identifiziere fehlende Stücke zur Vervollständigung deines Outfits mit Sofort-Kaufvorschlägen.';

  @override
  String get onboardingAnalitik => 'Erweiterte Analytik';

  @override
  String get onboardingAnalitikAciklama =>
      'Analysiere den Gesamtwert deines Schranks, die Kosten pro Tragen und deinen Lieblingsstil.';

  @override
  String get onboardingStilist => 'KI-Stylist';

  @override
  String get onboardingStilistAciklama =>
      'Sag einfach, wo du hinwillst, und die KI erstellt in Sekunden das schickste Outfit.';

  @override
  String get onboardingAtla => 'Überspringen';

  @override
  String get onboardingModaProfiliniz => 'Dein Modeprofil';

  @override
  String get onboardingKadin => 'Weiblich';

  @override
  String get onboardingErkek => 'Männlich';

  @override
  String get onboardingBasla => 'Jetzt starten';

  @override
  String get onboardingDevamEt => 'Weiter';

  @override
  String get cinsiyetBaslik => 'GESCHLECHT';

  @override
  String get tarzBaslik => 'TÄGLICHER STIL (MEHRFACHWAHL)';

  @override
  String get renkTercihiBaslik => 'FARBPRÄFERENZ';

  @override
  String get tenRengiBaslik => 'HAUTTON-PRÄFERENZ';

  @override
  String get kadin => 'Weiblich';

  @override
  String get erkek => 'Männlich';

  @override
  String get cinsiyetBelirtilmemis => 'Nicht angegeben';

  @override
  String get tarzSpor => 'Sportlich';

  @override
  String get tarzKlasik => 'Klassisch';

  @override
  String get tarzSokakModasi => 'Streetwear';

  @override
  String get tarzMinimalist => 'Minimalistisch';

  @override
  String get renkKoyuTonlar => 'Dunkle Töne';

  @override
  String get renkPastel => 'Pastellfarben';

  @override
  String get renkCanli => 'Lebendige Farben';

  @override
  String get renkNotr => 'Neutral';

  @override
  String get tenAcikBeyaz => 'Hell / Weiß';

  @override
  String get tenBugday => 'Mittel / Weizen';

  @override
  String get tenEsmerKoyu => 'Dunkel / Gebräunt';

  @override
  String get hesabinizaGirisYapin => 'In dein Konto einloggen';

  @override
  String get yeniHesapOlusturun => 'Neues Konto erstellen';

  @override
  String get stilDunyanaTekrarHosGeldin =>
      'Willkommen zurück in deiner Stil-Welt ✨';

  @override
  String get kombinleriniSaklamakIcinKatil =>
      'Mach mit, um deine Outfits zu speichern 🚀';

  @override
  String get girisYap => 'Anmelden';

  @override
  String get girisYapGoogle => 'Mit Google anmelden';

  @override
  String get girisBeniHatirla => 'Angemeldet bleiben';

  @override
  String get girisVeya => 'oder';

  @override
  String get kayitOl => 'Registrieren';

  @override
  String get adinizVeyaLakabiniz => 'Dein Name oder Spitzname';

  @override
  String get epostaAdresiniz => 'Deine E-Mail-Adresse';

  @override
  String get sifreniz => 'Dein Passwort';

  @override
  String get girisYapVeBasla => 'Anmelden und starten';

  @override
  String get kayitOlVeBasla => 'Registrieren und starten';

  @override
  String get misafirOlarakDevamEt => 'Als Gast fortfahren';

  @override
  String get lutfenEpostaVeSifreGiriniz =>
      'Bitte gib deine E-Mail und dein Passwort ein.';

  @override
  String get lutfenAdiniziGiriniz => 'Bitte gib deinen Namen ein.';

  @override
  String get kullanimKosullariBaslik => 'Nutzungsbedingungen und Vereinbarung';

  @override
  String get onaylamakIcinKaydirin =>
      'Zum Bestätigen ans Ende des Textes scrollen';

  @override
  String get okudumAnladimKabulEdiyorum => 'Gelesen, verstanden und akzeptiert';

  @override
  String get kullanimKosullarini => 'Nutzungsbedingungen.';

  @override
  String get okudumVeOnayliyorum => 'Ich habe die ';

  @override
  String get onaylamadanOnceKosullariOkuyun =>
      'Bitte lies die Nutzungsbedingungen vor dem Bestätigen.';

  @override
  String get devamEtmekIcinKosullariKabulEdin =>
      'Du musst die Nutzungsbedingungen akzeptieren, um fortzufahren.';

  @override
  String get kullanimKosullariMetni =>
      'FITCHECK NUTZUNGSBEDINGUNGEN UND DIENSTLEISTUNGSVEREINBARUNG\n\nLetzte Aktualisierung: 27. August 2026\n\nBitte lies diese Nutzungsbedingungen („Vereinbarung“) sorgfältig durch, bevor du die mobile FitCheck-Anwendung („App“) nutzt. Durch das Herunterladen, den Zugriff oder die Nutzung der App stimmst du allen Bedingungen dieser Vereinbarung zu.\n\n1. PARTEIEN UND ZWECK\nDiese Vereinbarung wird zwischen dem Entwickler der FitCheck-App und dem einzelnen Nutzer („Nutzer“) geschlossen, der die App herunterlädt und nutzt. Die App bietet digitale Schrankverwaltung, Kleidungsverfolgung, wettergerechte Outfit-Vorschläge und KI-gestützte Stilberatung.\n\n2. UMFANG DES DIENSTES UND NUTZUNGSBEDINGUNGEN\n• Altersgrenze: Du musst mindestens 13 Jahre alt sein, um die App zu nutzen.\n• Nutzerinformationen: Der Nutzer ist für die Richtigkeit von Name, Geschlecht, Stil- und Farbpräferenzen bei der Profilerstellung verantwortlich.\n• Empfehlungscharakter: Von KI bereitgestellte Stilbewertungen, Kaufvorschläge und Waschtag-Erinnerungen dienen ausschließlich als Empfehlung.\n• Wetterdaten: Wetterinformationen basieren auf dem Echtzeit-Standort. Das Unternehmen haftet nicht für eventuelle Abweichungen.\n\n3. GEISTIGES EIGENTUM UND INHALTSRECHTE\nDas geistige Eigentum der hochgeladenen Kleiderfotos liegt bei dir. Das FitCheck-Logo, Design, Softwarecode und Algorithmen gehören vollständig zu FitCheck.\n\n4. DATENSCHUTZ UND SICHERHEIT\nDeine Kleiderfotos und Outfit-Historie werden primär im lokalen Speicher deines Geräts gespeichert. Standortdaten werden nur zum Abrufen des aktuellen Wetters verwendet.\n\n5. HAFTUNGSBESCHRÄNKUNG\nFitCheck garantiert keinen ununterbrochenen Betrieb und haftet nicht für Datenverluste durch Gerätewechsel oder Deinstallation der App.\n\n6. KONTAKT\nBei Fragen erreichst du uns über den Kontaktbereich im Einstellungs-Tab oder unter support@fitcheckapp.com.\n\n--- 📜 ENDE DER VEREINBARUNG ---\nBitte akzeptiere die Bedingungen durch Tippen auf den Button unten.';

  @override
  String chatKarsilama(Object hava) {
    return 'Hallo! 👋 Draußen ist es heute $hava. Sollen wir ein tolles Outfit zusammenstellen, das zu deinem Stil passt? ✨';
  }

  @override
  String get chatGorselGonderildi => 'Bild gesendet.';

  @override
  String get chatAsistanSohbeti => 'Assistenten-Chat';

  @override
  String get chatModHavaDuyarli => 'Clevere Styling-Tipps passend zum Wetter';

  @override
  String get chatStilistHazirliyor => 'Stylist stellt dein Outfit zusammen...';

  @override
  String get chatGorselEklendi => 'Bild angehängt';

  @override
  String get chatTekrarDene => 'Erneut versuchen';

  @override
  String get chatKamera => 'Kamera';

  @override
  String get chatGaleri => 'Bild aus Galerie auswählen';

  @override
  String get chatMikrofon => 'Mikrofon';

  @override
  String get chatGonder => 'Nachricht senden';

  @override
  String get chatOneriYagmur => '🌧️ Regenbogen- / Regenwetter-Outfit';

  @override
  String get chatOneriOfis => '💼 Büro / Schicker Stil';

  @override
  String get chatOneriHaftaSonu => '☕ Wochenend-Komfort';

  @override
  String get chatOneriKirliSepeti => '🧺 Wäschekorb-Check';

  @override
  String get chatDinleniyor => 'Hört zu...';

  @override
  String get chatBirSeylerYazin => 'Schreibe dem Assistenten etwas...';

  @override
  String get chatKombiniGiydim => 'Dieses Outfit getragen 👗';

  @override
  String get chatKombinIslendi =>
      'Outfit zur heutigen Historie hinzugefügt! 📅';

  @override
  String get chatGorselIncele =>
      'Analysiere dieses Bild und schlage ein Outfit vor.';

  @override
  String get profilAyarlariBaslik => 'PROFIL-EINSTELLUNGEN';

  @override
  String get cinsiyetTercihiBaslik => 'Geschlechterpräferenz';

  @override
  String get stilAramaHint =>
      'Z. B. \'Schickes Casual-Outfit mit schwarzer Jacke\', \'Sommerkleid\'...';

  @override
  String get stilFiltreTumu => 'Alle Artikel';

  @override
  String get stilFiltreSadeceTemizler => 'Nur Saubere';

  @override
  String get stilFiltreSadeceSepet => 'Nur im Wäschekorb';

  @override
  String get profilFavoriKombinlerTitle => 'Meine Lieblingsoutfits';

  @override
  String get profilFavoriKombinYok =>
      'Noch keine Lieblingsoutfits hinzugefügt.';

  @override
  String get profilYikamaSepetimTitle => 'Mein Wäschekorb';

  @override
  String get profilYikamaSepetimBos =>
      'Dein Wäschekorb ist leer, deine Kleidung ist sauber! ✨';

  @override
  String get profilSepetiBosalt => 'Korb leeren';

  @override
  String get profilSepetiBosaltOnay =>
      'Alle Artikel werden als sauber markiert. Bestätigst du das?';

  @override
  String get profilSepetiBosaltButon => 'Ja, alles waschen';

  @override
  String get profilTenRengi => 'Hautton / Teint';

  @override
  String get profilTarzTercihi => 'Stilpräferenz';

  @override
  String get profilRenkPaleti => 'Lieblings-Farbpalette';

  @override
  String get rehberGardiropEkleTitle => 'Foto hinzufügen';

  @override
  String get rehberGardiropEkleDesc =>
      'Du kannst Fotos deiner Kleidung einzeln oder gesammelt hochladen.';

  @override
  String get rehberAiStilistTitle => 'KI-Stylist-Assistent';

  @override
  String get rehberAiStilistDesc =>
      'Du kannst die KI nach Outfit-Kombinationen oder Ratschlägen fragen.';

  @override
  String get rehberSesliTitle => 'Sprachbefehl';

  @override
  String get rehberSesliDesc =>
      'Fordere Outfit-Vorschläge direkt per Sprache an.';

  @override
  String get rehberAyarlarTitle => 'Einstellungen & Profil';

  @override
  String get rehberAyarlarDesc =>
      'Du kannst Geschlecht, Stilpräferenz und Hautton aktualisieren.';

  @override
  String get rehberGardiropNavTitle => 'Mein Schrank';

  @override
  String get rehberGardiropNavDesc =>
      'Sieh dir all deine hinzugefügten Kleidungsstücke nach Kategorien an.';

  @override
  String get rehberHaftalikNavTitle => 'Wochenplaner';

  @override
  String get rehberHaftalikNavDesc =>
      'Erstelle 7-Tage-Outfit-Pläne basierend auf der Wettervorhersage.';

  @override
  String get rehberDolaptanNavTitle => 'Sofort-KI-Stylist';

  @override
  String get rehberDolaptanNavDesc =>
      'Generiere sofortige KI-Outfits für bestimmte Anlässe.';

  @override
  String get rehberKendiNavTitle => 'Eigenes Outfit';

  @override
  String get rehberKendiNavDesc =>
      'Kombiniere Stücke manuell, um eigene Outfits zu gestalten.';

  @override
  String get rehberProfilNavTitle => 'Profil & Analyse';

  @override
  String get rehberProfilNavDesc =>
      'Verfolge die Kostenanalyse deines Schranks und verwalte den Wäschekorb.';

  @override
  String get simdilikAtla => 'Erstmal überspringen';

  @override
  String get uygulamaIzinleri => 'App-Berechtigungen';

  @override
  String get izinEkraniAciklama =>
      'FitCheck benötigt diese Berechtigungen für personalisierte Outfits und Wäsche-/Wetter-Benachrichtigungen.';

  @override
  String get konumIzniAciklama =>
      'Für Outfit-Empfehlungen passend zum Live-Wetter';

  @override
  String get kameraIzniAciklama =>
      'Um Kleiderfotos in deinen virtuellen Schrank aufzunehmen';

  @override
  String get bildirimIzni => 'Benachrichtigungsberechtigung';

  @override
  String get bildirimIzniAciklama => 'Für Waschtage und Wetterwarnungen';

  @override
  String get izinleriVerVeBasla => 'Berechtigungen erteilen und starten';

  @override
  String get dahaSonraAyarla => 'Später einrichten';

  @override
  String get gunlukHakBittiBaslik => 'Tägliches Limit erreicht!';

  @override
  String get dahaSonra => 'Später';

  @override
  String get reklamIzleHakKazan => 'Video ansehen (+3 Guthaben)';

  @override
  String get tebriklerHakEklendi => 'Glückwunsch! +3 Guthaben vergeben. ✨';

  @override
  String kombinIsaretlemeKaldirildi(String kombinAdi) {
    return 'Markierung für Outfit \"$kombinAdi\" aufgehoben.';
  }

  @override
  String kombinGiydimIsaretlendi(String kombinAdi) {
    return 'Outfit \"$kombinAdi\" als heute getragen markiert! 👕✨';
  }

  @override
  String get kiyafetDetayi => 'Kleidungsdetail';

  @override
  String get parcaDetayiBaslik => 'ARTIKELDETAIL';

  @override
  String get farkliParcaSec => 'Anderes Teil wählen';

  @override
  String get farkliUstSec => 'Anderes Oberteil wählen 👕';

  @override
  String get farkliAltSec => 'Anderes Unterteil wählen 👖';

  @override
  String get farkliAyakkabiSec => 'Andere Schuhe wählen 👟';

  @override
  String get farkliDisSec => 'Andere Oberbekleidung wählen 🧥';

  @override
  String get baskaTemizKiyafetYok =>
      'Du hast keine anderen sauberen\nTeile zum Tauschen in dieser Kategorie.';

  @override
  String get planiYenile => 'Plan aktualisieren';

  @override
  String get havaEtiketi => 'WETTER';

  @override
  String get yukleniyor => 'Wird geladen...';

  @override
  String get temizle => 'Löschen';

  @override
  String get yenidenDegerlendiriliyor => 'Wird neu bewertet...';

  @override
  String get kombinParcalariBaslik => 'OUTFIT-TEILE';

  @override
  String get parcalariKaydirIpucu =>
      'Nach links/rechts wischen für andere Teile im Outfit 👈👉';

  @override
  String zorunluParcaYorumu(Object parcaAdi) {
    return '✨ Dieses Outfit wurde um das Teil $parcaAdi herum aufgebaut!';
  }

  @override
  String get sihirliDokunus => 'Magische Berührung';

  @override
  String get dolabiKaristirEksikUyari =>
      'Du brauchst mindestens 1 sauberes Oberteil, Unterteil und Schuhe zum Mischen! 👕👖👟';

  @override
  String get zarlarAtildiYorumu =>
      '🎲 Gewürfelt! Du hast eine brandneue, überraschende Outfit-Kombination entdeckt.';

  @override
  String get rastgeleKombinTuru => 'Zufällig';

  @override
  String get temizAlternatifYok =>
      'Keine saubere Alternative für diese Kategorie übrig! 🧺';

  @override
  String get kisiselDokunus => 'Persönliche Note';

  @override
  String get aiYeniParcaAnalizEdiyor => 'KI analysiert das neue Teil... ✨';

  @override
  String get parcaDegisimVarsayilanYorum =>
      '✨ Teile getauscht, um eine perfekte Harmonie zu erzielen!';

  @override
  String get parcaDegisimHataYorum =>
      '✨ Teile getauscht, um das Outfit komplett an deinen Stil anzupassen!';

  @override
  String get bilgileriDuzenleBaslik => 'Infos bearbeiten';

  @override
  String get kiyafetAdiEtiketi => 'Artikelname';

  @override
  String get renkEtiketi => 'Farbe';

  @override
  String get kaydet => 'Speichern';

  @override
  String get yenidenZarAt => 'Erneut würfeln';

  @override
  String get zarAtKaristir => 'Würfeln (Mischen)';

  @override
  String get zarPopupBaslik => 'Schüttle die magischen Würfel!';

  @override
  String get zarPopupAciklama =>
      'Schüttle dein Handy oder tippe auf die Schaltfläche unten, um die Würfel zu rollen und zufällige Outfits aus deinem Kleiderschrank zu erhalten.';

  @override
  String get zarlariAt => 'Würfel rollen';

  @override
  String get zarSalla => 'Würfel schütteln';

  @override
  String get degistirmekIcinKaydirIpucu =>
      'Nach links/rechts wischen oder tippen zum Tauschen 👈👉';

  @override
  String get favorilerdeEtiketi => 'In Favoriten';

  @override
  String get bugunGiydildiEtiketi => 'Heute getragen ✨';

  @override
  String get varsayilanKendiAnalizYorumu =>
      'Großartige Wahl! Die Stücke bilden eine perfekte Farbbalance.';

  @override
  String get kendiTasarimimBaslik => 'Mein eigenes Design';

  @override
  String parcaSecModalBaslik(Object kategori) {
    return '$kategori auswählen';
  }

  @override
  String get kendiKombininiTasarlaTitle => 'Entwirf dein Outfit';

  @override
  String get secimleriSifirla => 'Auswahl zurücksetzen';

  @override
  String get kombinHazirAiTavsiyesi =>
      'Outfit sieht toll aus! Mit KI analysieren und speichern.';

  @override
  String get kombinBaslaIpucu =>
      'Was möchtest du heute tragen? Fang an, Teile auszuwählen.';

  @override
  String get ustAltModu => 'Oberteil + Unterteil';

  @override
  String get tekParcaElbiseModu => 'Einteiler (Kleid)';

  @override
  String get tekParcaElbise => 'Einteiler / Kleid';

  @override
  String get aksesuarOpsiyonel => 'Accessoire (Optional)';

  @override
  String get stilistAnaliziBaslik => 'STYLIST-ANALYSE';

  @override
  String get stilistDegerlendiriyor => 'Stylist bewertet...';

  @override
  String get aiIleAnalizEtKaydet => 'Mit KI analysieren & speichern';

  @override
  String get bilinmiyor => 'Unbekannt';

  @override
  String get karmasikSiklik => 'Sophisticated Chic';

  @override
  String get gecmisiTemizleTitle => 'Verlauf löschen';

  @override
  String get gecmisiTemizleOnayIcerik =>
      'Mist du sicher, dass du den gesamten Trageverlauf löschen möchtest? Dies kann nicht rückgängig gemacht werden.';

  @override
  String get gecmisBasariylaTemizlendi => 'Verlauf erfolgreich gelöscht 🗑️';

  @override
  String get kayitGecmistenSilindi => 'Eintrag aus dem Verlauf gelöscht.';

  @override
  String get kombin => 'Outfit';

  @override
  String get kombinDetayiUst => 'OUTFIT-DETAIL';

  @override
  String get giyilenParcalarUst => 'GETRAGENE TEILE';

  @override
  String get detayBulunamadi => 'Keine Details gefunden.';

  @override
  String get henuzFavoriEklemediniz =>
      'Du hast noch keine Lieblingsoutfits hinzugefügt.';

  @override
  String get camasirSepetiTitle => 'Wäschekorb';

  @override
  String get sepetBosTumKiyafetlerTemiz =>
      'Korb ist komplett leer, alle Kleider sind sauber!';

  @override
  String get tumKiyafetlerTemizlendi =>
      'Alle Kleider gereinigt und zurück in den Schrank gelegt 🧺✨';

  @override
  String get tumunuTemizIsaretle => 'Alle als sauber markieren';

  @override
  String get profilVeAnalizTitle => 'Profil und Analyse';

  @override
  String get harikaGidiyorsun => 'Du machst das super!';

  @override
  String gundurSeridesin(Object gun) {
    return 'Du bist seit $gun Tagen im Streak!';
  }

  @override
  String get tumuTemiz => 'Alles sauber';

  @override
  String kirliParcaSayisi(Object sayi) {
    return '$sayi schmutzige Teile';
  }

  @override
  String get stilKimligin => 'Deine Stilidentität';

  @override
  String get dolapVerimliligi => 'Schrankeffizienz';

  @override
  String get renkPaletin => 'Deine Farbpalette';

  @override
  String get dolabinKahramanlari => 'Schrank-Helden';

  @override
  String get derinlerdeUnutulanlar => 'Vergessene Schätze';

  @override
  String get sonGiyilenler => 'Kürzlich getragen';

  @override
  String get tumunuTemizle => 'Alles löschen';

  @override
  String get henuzGecmisKaydiYok => 'Noch kein Verlauf vorhanden.';

  @override
  String kezGiyildi(Object sayi) {
    return '$sayi-mal getragen';
  }

  @override
  String get ayarlarTitle => 'Einstellungen';

  @override
  String get hesapVeGuvenlikMerkeziUst => 'KONTO- UND SICHERHEITSZENTRUM';

  @override
  String get kullaniciHesabi => 'Benutzerkonto';

  @override
  String get misafirKullanici => 'Gastbenutzer';

  @override
  String get epostaDogrulanmis => 'E-Mail verifiziert';

  @override
  String get esitlemekIcinGirisYapin =>
      'Einloggen, um auf allen Geräten zu synchronisieren.';

  @override
  String get cikisYapTitle => 'Abmelden';

  @override
  String get cikisYapOnayIcerik =>
      'Bist du sicher, dass du dich abmelden möchtest?';

  @override
  String get bagliHesaplarUst => 'VERKNÜPFTE KONTOS';

  @override
  String get googleHesabiBagli => 'Google-Konto verknüpft';

  @override
  String get googleHesabiniBagla => 'Google-Konto verknüpfen';

  @override
  String get googleHesabiBaglandi => 'Google-Konto erfolgreich verknüpft! 🔗';

  @override
  String get googleHesabiBaglantisiKesildi =>
      'Google-Konto-Verknüpfung aufgehoben.';

  @override
  String get sifreVeGuvenlik => 'Passwort & Sicherheit';

  @override
  String get sifreYenilemeBaglantisiIste =>
      'Passwort-Zurücksetzungslink anfordern';

  @override
  String get sifremiUnuttum => 'Passwort vergessen?';

  @override
  String get sifreDegistirTitle => 'Passwort ändern';

  @override
  String get sifreSifirlamaAciklama =>
      'Ein Link zum Zurücksetzen des Passworts wird an deine E-Mail gesendet:';

  @override
  String get epostaAdresi => 'E-Mail-Adresse';

  @override
  String get gecerliBirEpostaGiriniz =>
      'Geben Sie eine gültige E-Mail-Adresse ein';

  @override
  String sifreEpostasiGonderildi(Object eposta) {
    return 'Passwort-E-Mail gesendet an $eposta! ✉️';
  }

  @override
  String get baglantiGonder => 'Link senden';

  @override
  String get hesabiKaliciSilTitle => 'Konto permanent löschen';

  @override
  String get hesabiSilGeriAlinamazUyari =>
      'Dies kann nicht rückgängig gemacht werden. Schrankdaten und Profil werden unwiderruflich gelöscht.';

  @override
  String get hesabiSilOnayKoduMetni =>
      'Gib unten \"fitcheck\" ein, um zu bestätigen:';

  @override
  String get vazgec => 'Abbrechen';

  @override
  String get hesabimiSil => 'Mein Konto löschen';

  @override
  String get hesabinizSilindi =>
      'Dein Konto und zugehörige Daten wurden gelöscht.';

  @override
  String get kisiselStilVeProfilUst => 'PERSÖNLICHER STIL & PROFIL';

  @override
  String get stilVeTarzTercihleri => 'Stil- & Vibe-Präferenzen';

  @override
  String get secili => 'Ausgewählt';

  @override
  String get tenRengiTercihinizUst => 'HAUTTON-PRÄFERENZ';

  @override
  String get yapayZekaVeStilHassasiyetiUst => 'KI & STIL-EMPFINDLICHKEIT';

  @override
  String get stilistKisiligiVeYantitTarziUst =>
      'STYLIST-PERSÖNLICHKEIT & ANTWORTSTIL';

  @override
  String get aiKisilikSamimiBaslik => 'Freundlich / Lässig';

  @override
  String get aiKisilikSamimiAciklama =>
      'Warmer, motivierender Ton, der Mode spaßig macht';

  @override
  String get aiKisilikElestirmenBaslik => 'Professioneller Modekritiker';

  @override
  String get aiKisilikElestirmenAciklama =>
      'Technische Ratschläge mit Fokus auf Farbtheorie und Körpertyp';

  @override
  String get aiKisilikMinimalistBaslik => 'Minimalistisch & Kurz';

  @override
  String get aiKisilikMinimalistAciklama =>
      'Direkte, präzise Vorschläge ohne Zeitverschwendung';

  @override
  String get sikiRenkTeorisiUyumModu => 'Strenger Farbtheorie-Modus';

  @override
  String get sikiRenkTeorisiAciklama =>
      'Wenn aktiv, folgt die KI strengen klassischen Farbharmonieregeln';

  @override
  String get bildirimlerVeHatirlaticiUst => 'BENACHRICHTIGUNGEN & ERINNERUNGEN';

  @override
  String get sabahKombinOnerisi => 'Morgen-Outfit-Vorschlag';

  @override
  String herSabahBildirimAl(Object saat) {
    return 'Jeden Morgen um $saat Uhr benachrichtigen';
  }

  @override
  String get bildirimSaatiniOzellestir => 'Benachrichtigungszeit anpassen';

  @override
  String get gunlukKombinBildirimSaati =>
      'Tägliche Outfit-Benachrichtigungszeit';

  @override
  String get sabahBildirimSaatiSec => 'Morgen-Benachrichtigungszeit wählen';

  @override
  String get saatKaydedildiAksama =>
      'Zeit gespeichert, aber Benachrichtigungsdienst nicht erreichbar.';

  @override
  String sabahBildirimiAyarlandi(Object saat) {
    return 'Morgen-Benachrichtigung für $saat Uhr eingestellt. ⏰';
  }

  @override
  String get bildirimIzinGerekliUyari =>
      'Du musst Benachrichtigungen in den Gerätexeinstellungen erlauben.';

  @override
  String get camasirSepetiUyarilari => 'Wäschekorb-Warnungen';

  @override
  String get camasirSepetiUyarilariAciklama =>
      'Erhalte intelligente Erinnerungen für getragene Kleidung';

  @override
  String get haftalikStilRaporu => 'Wöchentlicher Stilbericht';

  @override
  String get haftalikStilRaporuAciklama =>
      'Erhalte jeden Sonntagabend eine Schranknutzungs-Zusammenfassung';

  @override
  String get gorunumVeBolgeUst => 'AUSSEHEN & REGION';

  @override
  String get lokasyonVeBirimlerUst => 'STANDORT & EINHEITEN';

  @override
  String get sicaklikBirimi => 'Temperatureinheit';

  @override
  String get varsayilanSehirBolge => 'Standardstadt / Region';

  @override
  String get sehirOrnekHint => 'Z. B. Berlin, Wien, Zürich';

  @override
  String get gpsKullan => 'GPS verwenden';

  @override
  String get veriVeDepolamaYonetimiUst => 'DATEN- UND SPEICHERMANAGEMENT';

  @override
  String get gorselOnbelleginiTemizle => 'Bildcache leeren';

  @override
  String get geciciFotografHafizasiAciklama =>
      'Gibt temporären Fotospeicher frei';

  @override
  String get onbellekTemizlendiBasari =>
      'Bildcache und temporäre Dateien gelöscht! ✨';

  @override
  String get onbellekTemizlerkenHata =>
      'Beim Leeren des Caches ist ein Fehler aufgetreten.';

  @override
  String get gardirobuDisaAktarYedekle => 'Schrank exportieren (Backup)';

  @override
  String get tumKiyafetVeKombinJsonAciklama =>
      'Alle Kleider- und Outfit-Daten als JSON exportieren';

  @override
  String get disaAktarilacakVeriYok =>
      'Keine Schrankdaten zum Exportieren gefunden. 📭';

  @override
  String get gardiropVerisiKopyalandi =>
      'Alle Schrankdaten im JSON-Format in die Zwischenablage kopiert! 📋';

  @override
  String get destekVeDegerlendirmeUst => 'SUPPORT & BEWERTUNG';

  @override
  String get uygulamayiDegerlendirin => 'App bewerten';

  @override
  String get googlePlay5YildizDestek =>
      'Unterstütze uns mit 5 Sternen auf Google Play ⭐';

  @override
  String get googlePlayAcilamadi => 'Google Play konnte nicht geöffnet werden.';

  @override
  String get geriBildirimVeDestek => 'Feedback & Support';

  @override
  String get hataBildirVeyaOneri =>
      'Fehler melden oder neue Funktion vorschlagen';

  @override
  String get islemTamamlanamadi =>
      'Der Vorgang konnte nicht abgeschlossen werden. Bitte versuchen Sie es erneut.';

  @override
  String get epostaUygulamasiAcilamadi =>
      'E-Mail-Programm konnte nicht geöffnet werden. Bitte schreibe an ayberkzcn9@gmail.com.';

  @override
  String get gizlilikPolitikasiTitle => 'Datenschutzrichtlinie';

  @override
  String get veriKullanimiVeGizlilikHaklari =>
      'Datennutzung und Datenschutzrechte ansehen';

  @override
  String get sonGuncellemeTarihi => 'Letzte Aktualisierung: 27. August 2026';

  @override
  String get gizlilikMadde1Baslik => '1. Datenerhebung und -nutzung';

  @override
  String get gizlilikMadde1Icerik =>
      'FitCheck optimiert deine persönliche Schrankverwaltung und Outfit-Empfehlungen. In die App hochgeladene Kleiderfotos, Stil- und Geschlechterpräferenzen werden lokal auf deinem Gerät gespeichert.';

  @override
  String get gizlilikMadde2Baslik => '2. Standortberechtigungen';

  @override
  String get gizlilikMadde2Icerik =>
      'Deine Echtzeit-Standortdaten werden anonym mit Open-Meteo-Diensten verarbeitet, um wettergerechte Outfit-Vorschläge zu liefern. Standortdaten werden nicht auf Servern gespeichert oder an Dritte weitergegeben.';

  @override
  String get gizlilikMadde3Baslik => '3. Sprachassistent und Mikrofon';

  @override
  String get gizlilikMadde3Icerik =>
      'Bei Verwendung der Sprachbefehl-Funktion wird deine Sprache sofort in Text umgewandelt und verarbeitet. Sprachaufnahmen werden nicht dauerhaft gespeichert.';

  @override
  String get gizlilikMadde4Baslik => '4. Dienste von Drittanbietern';

  @override
  String get gizlilikMadde4Icerik =>
      'Für App-Analysen und Werbung werden Firebase- und Google AdMob-Infrastrukturen genutzt.';

  @override
  String get anladim => 'Verstanden';

  @override
  String get stilVeModaTercihleriniz => 'Stil- & Modepräferenzen';

  @override
  String get stilModalAciklama =>
      'Die KI priorisiert diese Stil- und Passformpräferenzen beim Generieren von Outfits.';

  @override
  String get favoriTarzinizUst => 'LIEBLINGSSTIL';

  @override
  String get giyimKesimiFitUst => 'PASSFORM (FIT)';

  @override
  String get hesapSilmeUst => 'KONTOLÖSCHUNG';

  @override
  String get tumBulutVeYerelVeriTemizlenir =>
      'Löscht alle Cloud- und lokalen Daten';

  @override
  String get hakkindaUst => 'ÜBER';

  @override
  String get topluFotografEkleTooltip => 'Kleidung gesammelt hinzufügen';

  @override
  String get kuponKoduKullanTitle => 'Gutscheincode einlösen';

  @override
  String get kuponKoduAciklama =>
      'Gib deinen Gutscheincode unten ein, um extra Guthaben zu erhalten:';

  @override
  String get kuponKoduHint => 'Z. B. VIP2026';

  @override
  String get kuponKullanButon => 'Einlösen';

  @override
  String get kuponBasariliMesaji =>
      '🎉 Gutschein erfolgreich eingelöst! Guthaben hinzugefügt.';

  @override
  String get kuponKullanilmisUyari =>
      '⚠️ Du hast diesen Gutscheincode bereits verwendet!';

  @override
  String get kuponGecersizUyari =>
      '❌ Ungültiger Gutscheincode! Bitte versuche es erneut.';

  @override
  String get sinirsizIslemHakkiBaslik => 'Unbegrenzter Zugriff 👑';

  @override
  String kalanHakkinizBaslik(Object hak) {
    return 'Verbleibendes Guthaben: $hak ⚡';
  }

  @override
  String get sinirsizHakAciklama =>
      'Genieße unbegrenzte Outfit-Erstellung und Stilanalysen mit Premium-Vorteilen.';

  @override
  String get gunlukHakAciklama =>
      'Tägliches Guthaben wird täglich um 00:00 Uhr zurückgesetzt. Schau Videos oder löse Codes ein für mehr Guthaben.';

  @override
  String get kuponKullan => 'Code einlösen';

  @override
  String get hakEklendiTebrikler => 'Glückwunsch! +3 Guthaben vergeben. ✨';

  @override
  String get gardirobunDolduTitle => 'Schrank voll!';

  @override
  String gardirobunDolduIcerik(Object limit) {
    return 'Du hast dein Limit von $limit Kleidungsstücken erreicht. Möchtest du ein kurzes Video ansehen, um +3 neue Plätze hinzuzufügen? 👕';
  }

  @override
  String get reklamIzleSlotEkle => 'Video ansehen (+3 Plätze)';

  @override
  String get yeniSlotEklendiTebrikler =>
      'Glückwunsch! +3 neue Kleiderplätze hinzugefügt. 🎉';

  @override
  String get gunlukHakBittiTitle => 'Kein tägliches Guthaben mehr!';

  @override
  String get gunlukHakBittiIcerik =>
      'Du hast deine kostenlosen Credits für heute aufgebraucht. Schau ein kurzes Video oder gib einen Code ein, um neue zu erhalten! 🛍️';

  @override
  String get kuponGir => 'Code eingeben';

  @override
  String get anaSemsiyeBildirimBaslik => 'Vergiss deinen Regenschirm nicht! ☔';

  @override
  String get anaSemsiyeBildirimIcerik =>
      'Es sieht heute nach Regen aus – wähle dein Outfit am besten entsprechend aus.';

  @override
  String get anaCamasirGunuBildirimBaslik => 'Waschtag! 🧺';

  @override
  String get anaCamasirGunuBildirimIcerik =>
      'Kleidung, die auf das Waschen wartet, hat sich im Korb angesammelt. Zeit, die Maschine anzuwerfen!';

  @override
  String chatZorunluParcaMesaji(Object parca) {
    return '✨ Was kann ich zu diesem Teil anziehen? ($parca)';
  }

  @override
  String chatKombinHazirBaslik(Object ortam) {
    return 'Dein Outfit ist bereit ($ortam)';
  }

  @override
  String get chatKombiniGorButon => 'Outfit ansehen';

  @override
  String get chatStilistKombinTasarlayor => 'Stylist entwirft das Outfit...';

  @override
  String get chatStilistYaziyor => 'Stylist schreibt...';

  @override
  String get pazartesi => 'Montag';

  @override
  String get sali => 'Dienstag';

  @override
  String get carsamba => 'Mittwoch';

  @override
  String get persembe => 'Donnerstag';

  @override
  String get cuma => 'Freitag';

  @override
  String get cumartesi => 'Samstag';

  @override
  String get pazar => 'Sonntag';

  @override
  String get rehberiAtla => 'ANLEITUNG ÜBERSPRINGEN';

  @override
  String get rehberAnladimBasla => 'Verstanden, los geht\'s!';

  @override
  String get rehberSonrakiAdim => 'Nächster Schritt ➔';

  @override
  String get rehberGardirobuDijitallestirBaslik =>
      '📸 Digitalisiere deinen Schrank';

  @override
  String get rehberGardirobuDijitallestirAciklama =>
      'Tippe hierauf, um Fotos deiner Kleidung zu machen oder aus der Galerie hochzuladen.';

  @override
  String get rehberSesliAsistanBaslik => '🎙️ Sprach-Stilassistent';

  @override
  String get rehberSesliAsistanAciklama =>
      'Gib Sprachbefehle ein, um zu fragen, was du anziehen sollst, oder um Ratschläge zu erhalten.';

  @override
  String get rehberAiStilistBaslik => '✨ KI-Stylist-Vorschläge';

  @override
  String get rehberAiStilistAciklama =>
      'Erhalte mit einem Tipp KI-Outfits passend zu Wetter, Hautton und Stil.';

  @override
  String get rehberAyarlarBaslik => '⚙️ Anpassung & Einstellungen';

  @override
  String get rehberAyarlarAciklama =>
      'Passe Geschlecht, Hautton, Farbe und Designthemen an oder sieh dir das Tutorial an.';

  @override
  String get rehberNavGardirobumBaslik => '👔 Mein Schrank';

  @override
  String get rehberNavGardirobumAciklama =>
      'Alle Kleider nach Kategorien anzeigen, filtern und praktisch verwalten.';

  @override
  String get rehberNavHaftalikBaslik => '📅 Wochenplaner';

  @override
  String get rehberNavHaftalikAciklama =>
      'Plane deine Outfits für die kommenden Tage im Voraus je nach Wettervorhersage.';

  @override
  String get rehberNavDolaptanBaslik => '🤖 KI-Outfits aus dem Schrank';

  @override
  String get rehberNavDolaptanAciklama =>
      'Lass die KI automatisch die am besten passenden Outfits aus deinen Kleidern erstellen.';

  @override
  String get rehberNavKendiBaslik => '🎨 Eigenes Outfit erstellen';

  @override
  String get rehberNavKendiAciklama =>
      'Kombiniere Oberteile, Unterteile und Schuhe manuell und speichere deinen Look.';

  @override
  String get rehberNavProfilBaslik => '📊 Analyse & Wäschekorb';

  @override
  String get rehberNavProfilAciklama =>
      'Überprüfe Tragestatistiken und verwalte schmutzige Teile im Wäschekorb.';

  @override
  String get bildirimIzinGerekliBaslik =>
      'Benachrichtigungsberechtigung erforderlich';

  @override
  String get bildirimIzinGerekliIcerik =>
      'Wir empfehlen Benachrichtigungen zu aktivieren, um Waschtag-Erinnerungen und Wetterwarnungen zu erhalten.';

  @override
  String get bildirimGunaydinBaslik => 'Guten Morgen! ☀️';

  @override
  String get bildirimGunaydinIcerik =>
      'Ich habe ein tolles Outfit für das heutige Wetter zusammengestellt. Willst du es sehen?';

  @override
  String get bildirimKanalGenelBaslik => 'Allgemeine Benachrichtigungen';

  @override
  String get bildirimKanalGenelAciklama =>
      'FitCheck allgemeine Benachrichtigungen';

  @override
  String get bildirimKanalGunlukBaslik => 'Tägliche Outfit-Vorschläge';

  @override
  String get bildirimKanalGunlukAciklama =>
      'Benachrichtigungen für tägliche Outfit-Empfehlungen';

  @override
  String get bildirimKanalYikamaBaslik => 'Wäsche-Erinnerungen';

  @override
  String get bildirimKanalYikamaAciklama =>
      'Erinnerungen für Wäsche und Kleiderpflege';

  @override
  String get bildirimKanalRaporBaslik => 'Wöchentliche Stilberichte';

  @override
  String get bildirimKanalRaporAciklama =>
      'Wöchentliche Schrank- und Stilberichte';

  @override
  String get tenRengiAcik => 'Hell / Weiß';

  @override
  String get tenRengiBugday => 'Mittel / Weizen';

  @override
  String get tenRengiEsmer => 'Dunkel / Gebräunt';

  @override
  String get stilStreetwear => 'Streetwear / Casual';

  @override
  String get stilKlasik => 'Klassisch / Büro';

  @override
  String get stilMinimalist => 'Minimalistisch';

  @override
  String get stilSpor => 'Sportlich / Athleisure';

  @override
  String get stilVintage => 'Vintage / Retro';

  @override
  String get fitSlim => 'Slim Fit';

  @override
  String get fitRegular => 'Regular Fit';

  @override
  String get fitOversize => 'Oversize / Relaxed';

  @override
  String get gardirobumBosBaslik => 'Dein Schrank ist viel zu leer!';

  @override
  String get gardirobumGizlendiBaslik => 'Schrank ausgeblendet';

  @override
  String get gardirobumGizlendiAciklama =>
      'Tippe oben rechts auf das Augensymbol zum Anzeigen';

  @override
  String get gardirobumGoster => 'Inhalt anzeigen';

  @override
  String get gardirobumGizle => 'Inhalt ausblenden';

  @override
  String get kategoriUst => 'OBERTEILE';

  @override
  String get kategoriAlt => 'UNTERTEILE';

  @override
  String get kategoriAyakkabi => 'SCHUHE';

  @override
  String get kategoriAksesuar => 'ACCESSOIRES';

  @override
  String get gardirobumBosAciklama =>
      'Füge jetzt dein erstes Kleidungsstück hinzu und erlebe die KI-Magie.';

  @override
  String get gardirobumAiIslem1 => 'Kleiderschrank wird gescannt...';

  @override
  String get gardirobumAiIslem2 => 'Wetterbedingungen werden analysiert...';

  @override
  String get gardirobumAiIslem3 => 'Farbharmonie wird berechnet...';

  @override
  String get gardirobumAiIslem4 => 'Beste Outfits werden ausgewählt...';

  @override
  String get gardirobumAiIslem5 => 'Letzte Handgriffe werden ausgeführt...';

  @override
  String get gardirobumHakBittiBaslik => 'Tägliches Limit erreicht';

  @override
  String get gardirobumHakBittiAciklama =>
      'Du hast dein tägliches Limit zur Outfit-Erstellung erreicht.';

  @override
  String get gardirobumHakEklendiMesaj =>
      'Glückwunsch, neues Outfit-Guthaben erhalten!';

  @override
  String get ayarlariAc => 'Einstellungen öffnen';

  @override
  String get kiyafetEkle => 'Kleidung hinzufügen';

  @override
  String get kameraIleCek => 'Foto mit Kamera aufnehmen';

  @override
  String get galeridenSecToplu => 'Mehrfachauswahl aus Galerie';

  @override
  String get kameraIzniGerekliBaslik => 'Kameraberechtigung erforderlich';

  @override
  String get kameraIzniGerekliAciklama =>
      'Bitte erlaube den Kamerazugriff, um Fotos aufzunehmen.';

  @override
  String get kiyafetDuzenleBaslik => 'Kleidung bearbeiten';

  @override
  String get kategori => 'Kategorie';

  @override
  String get evetSil => 'Ja, löschen';

  @override
  String get favorilerdenCikarildi => 'Aus Favoriten entfernt';

  @override
  String get gardirobumHenuzYokEkle =>
      'Noch keine Kleidung hinzugefügt. Jetzt hinzufügen!';

  @override
  String gardirobumMaksFotografUyari(int max) {
    return 'Du kannst maximal $max Fotos auswählen.';
  }

  @override
  String gardirobumUrunSayisi(int count) {
    return '$count Artikel';
  }

  @override
  String kombinUyumYuzdesi(String oran) {
    return '$oran% Match';
  }

  @override
  String get kombinSohbetAc => 'Über das Outfit chatten';

  @override
  String get kombinSohbetBaslik => 'Outfit-Chat';

  @override
  String kombinSohbetAltBaslik(Object gun) {
    return 'Chat über dein $gun-Outfit';
  }

  @override
  String kombinSohbetKarsilama(Object kombin) {
    return 'Lass uns dein Outfit „$kombin“ gemeinsam unter die Lupe nehmen! Frag mich alles über Farbharmonie, das Wetter oder alternative Teile. ✨';
  }

  @override
  String get kombinSohbetOneriUyum => '🤔 Warum passt dieses Outfit?';

  @override
  String get kombinSohbetOneriAlternatif =>
      '👟 Schlage ein alternatives Teil vor';

  @override
  String get kombinSohbetOneriHava => '🌦️ Was, wenn das Wetter umschlägt?';

  @override
  String get kombinSohbetOneriAksesuar => '💍 Gib mir Accessoire-Ideen';

  @override
  String get kombinSohbetAltBaslikAnlik => 'Chat über dein spontanes Outfit';

  @override
  String get chatKirliSepetiBos =>
      '🧺 Dein Wäschekorb ist leer! Alle Teile sind einsatzbereit – ich kann dir jederzeit ein Outfit zusammenstellen. ✨';

  @override
  String chatKirliSepetiDoluBaslik(Object sayi) {
    return '🧺 Im Wäschekorb warten **$sayi** Teile auf die Wäsche:';
  }

  @override
  String get chatKirliSepetiDoluNot =>
      'Diese Teile werden erst nach dem Waschen für Outfit-Vorschläge genutzt. Wenn du möchtest, stelle ich dir sofort ein Outfit aus deinen sauberen Teilen zusammen.';

  @override
  String get analitikVerileriPaylas => 'Analysedaten teilen';

  @override
  String get analitikVerileriPaylasAciklama =>
      'Zur Verbesserung der App werden anonyme Nutzungsdaten gesendet. Beim Ausschalten werden die Analysedaten auf diesem Gerät gelöscht.';

  @override
  String get chatKarsilamaHavaYok =>
      'Hallo! 👋 Sollen wir ein tolles Outfit zusammenstellen, das zu deinem Stil passt? ✨';

  @override
  String get premiumBaslik => 'Unbegrenzter Stil, keine Werbung';

  @override
  String get premiumAciklama =>
      'Nutze Outfits und Stilanalysen unbegrenzt und entferne mit einem Abo alle Werbung.';

  @override
  String get premiumOzellikReklamsiz => 'Alle Anzeigen werden entfernt';

  @override
  String get premiumOzellikAylik => 'Verlängert sich automatisch jeden Monat';

  @override
  String get premiumOzellikMagaza => 'Verwaltung über Google Play';

  @override
  String get premiumAktifMesaji =>
      'Premium ist aktiv. Unbegrenzte Nutzung und keine Werbung.';

  @override
  String get premiumAboneOl => 'Abonnieren';

  @override
  String premiumAboneOlFiyatli(String fiyat) {
    return 'Abonnieren • $fiyat';
  }

  @override
  String get premiumGeriYukle => 'Kauf wiederherstellen';

  @override
  String get premiumMagazaHazirDegil =>
      'Google Play ist gerade nicht verfügbar. Bitte versuche es erneut.';

  @override
  String get premiumSatinAlmaBaslatilamadi =>
      'Der Kauf konnte nicht gestartet werden.';

  @override
  String get premiumSatinAlmaBasarisiz => 'Der Kauf ist fehlgeschlagen.';

  @override
  String get premiumAylikBaslik => 'FitCheck Premium';

  @override
  String premiumAylikAltBaslik(String fiyat) {
    return 'Unbegrenzte Outfits • $fiyat/Monat';
  }

  @override
  String premiumGec(String fiyat) {
    return 'Unbegrenzt nutzen • $fiyat/Monat';
  }

  @override
  String get guncellemeBaslik => 'Update erforderlich';

  @override
  String get guncellemeAciklama =>
      'Eine neue Version von FitCheck ist verfügbar. Bitte aktualisiere die App, um fortzufahren.';

  @override
  String get guncellemeButonu => 'Jetzt aktualisieren';

  @override
  String guncellemeYeniSurum(String surum) {
    return 'Neue Version: $surum';
  }

  @override
  String get guncellemeMagazaUrlYok =>
      'Der Store-Link konnte nicht geöffnet werden. Bitte aktualisiere die App im Store.';

  @override
  String get premiumUrunBulunamadi =>
      'Abo-Informationen konnten nicht geladen werden. Bitte später erneut versuchen.';

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
  String get kombinOyunuBaslik => 'Kombinationsspiel';

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
  String get degerlendirmeBaslik => 'Gefällt dir FitCheck?';

  @override
  String get degerlendirmeIcerik =>
      'Wenn dir die App gefällt, nimm dir doch 5 Sekunden Zeit für eine Bewertung! Kleine Bewertungen sind eine große Hilfe! ⭐ Bewerter erhalten +3 kostenlose Credits geschenkt!';

  @override
  String get degerlendirmeEvet => 'Ja, gerne bewerten';

  @override
  String get degerlendirmeBelkiSonra => 'Vielleicht später';

  @override
  String get yakinda => 'Bald';

  @override
  String get yakindaAciklama =>
      'Wir arbeiten an dieser Funktion, sie kommt sehr bald!';

  @override
  String get aiOneriHazirlaniyor => 'Empfehlung wird vorbereitet...';

  @override
  String get haftalikStilistOnerisiHazirlanamadi =>
      'Stilisten-Empfehlung konnte nicht erstellt werden. Erneut versuchen.';

  @override
  String get haftalikAiServisHatasi =>
      'KI-Dienst nicht erreichbar. Prüfe deine Internetverbindung und versuche es erneut.';

  @override
  String get haftalikAiGecerliPlanYok =>
      'Die KI hat keinen gültigen Plan zurückgegeben. Erneut versuchen.';

  @override
  String get haftalikPlanBeklenmeyenHata =>
      'Beim Erstellen des Plans ist ein unerwarteter Fehler aufgetreten. Erneut versuchen.';

  @override
  String get haftalikBugunGiyildi =>
      'Das heutige Outfit wurde bereits getragen; es wurde kein neues erstellt.';

  @override
  String get girisHataKullaniciAdiKisa => 'Geben Sie mindestens 3 Zeichen ein';

  @override
  String get girisHataEpostaGecersiz => 'Geben Sie eine gültige E-Mail ein';

  @override
  String get girisHataSifreKisa => 'Geben Sie mindestens 6 Zeichen ein';

  @override
  String get googleKullanicisi => 'Google-Nutzer';

  @override
  String get premiumEkranBaslik => 'FitCheck Premium';

  @override
  String get dilSecimBaslik => '🌐 Sprache wählen';

  @override
  String get dilSecenekOtomatik => 'Automatisch (Gerätesprache)';

  @override
  String get kapat => 'Schließen';

  @override
  String get bildirimBaslik => 'Benachrichtigung';

  @override
  String get ayarlarAltbilgi => 'Mit Stil gemacht';

  @override
  String get geriBildirimKonu => 'FitCheck Feedback';

  @override
  String get premiumOzelliklerBaslik => 'Das schaltet Premium frei';

  @override
  String get premiumOzellikSinirsizKombin => 'Unbegrenzt Outfits erstellen';

  @override
  String get premiumOzellikSinirsizAnaliz => 'Unbegrenzte KI-Stilanalyse';

  @override
  String get premiumOzellikSinirsizGardirob => 'Unbegrenzter Kleiderschrank';

  @override
  String get premiumPlanAylik => 'Monatlich';

  @override
  String get premiumPlanYillik => 'Jährlich';

  @override
  String get premiumEnAvantajli => 'BESTES ANGEBOT';

  @override
  String premiumTasarrufYuzde(int yuzde) {
    return '$yuzde % sparen';
  }

  @override
  String premiumDenemeRozeti(int gun) {
    return '$gun TAGE GRATIS';
  }

  @override
  String premiumDenemeSonrasi(String fiyat) {
    return 'Danach $fiyat';
  }

  @override
  String get premiumYenilemeNotu =>
      'Das Abo verlängert sich am Ende jeder Periode automatisch. Jederzeit kündbar.';

  @override
  String get kiyafetDondur => 'Drehen';

  @override
  String get stilistHafizasiBaslik => 'Stilisten-Gedächtnis';

  @override
  String stilistHafizasiAltBaslikNotlu(int sayi) {
    return 'Merkt sich $sayi Notizen';
  }

  @override
  String get stilistHafizasiAltBaslikBos => 'Merkt sich noch nichts';

  @override
  String get stilistHafizasiAciklama =>
      'Der Stilist speichert, was er in deinen Chats lernt, als dauerhafte Notizen und personalisiert damit seine Vorschläge. Die Notizen bleiben nur auf diesem Gerät.';

  @override
  String get stilistHafizasiNelerBiliyor => 'Was merkt er sich?';

  @override
  String get stilistHafizasiOzetBaslik =>
      'Zusammenfassung deiner letzten Chats';

  @override
  String get stilistHafizasiBos =>
      'Ich habe noch nichts gelernt. Ich lerne deinen Stil mit jedem Chat besser kennen.';

  @override
  String get stilistHafizasiTemizle => 'Gedächtnis löschen';

  @override
  String get stilistHafizasiTemizleOnay =>
      'Alles, was der Stilist über dich gespeichert hat, wird gelöscht. Das kann nicht rückgängig gemacht werden.';

  @override
  String get stilistHafizasiTemizlendi => 'Gedächtnis gelöscht 🧠';
}
