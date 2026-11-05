import '../l10n/app_localizations.dart';

/// Oyun ekranlarında dinamik anahtarlarla üretilen metinleri gerçek
/// yerelleştirme getter'larına bağlar.
///
/// Anahtarlar tek bir switch altında toplanır; bilinmeyen bir anahtar
/// geldiğinde anahtarın kendisi döner (ham anahtar görünür, çökme olmaz).
extension AppLocalizationsComboExt on AppLocalizations {
  String tr(String key) {
    switch (key) {
      // Ortam
      case 'kombinOrtamOfis':
        return kombinOrtamOfis;
      case 'kombinOrtamCasual':
        return kombinOrtamCasual;
      case 'kombinOrtamDavet':
        return kombinOrtamDavet;
      case 'kombinOrtamSpor':
        return kombinOrtamSpor;

      // Hava
      case 'kombinHavaGunesli':
        return kombinHavaGunesli;
      case 'kombinHavaYagmurlu':
        return kombinHavaYagmurlu;
      case 'kombinHavaSoguk':
        return kombinHavaSoguk;
      case 'kombinHavaSicak':
        return kombinHavaSicak;

      // Renkler
      case 'kombinRenkBeyaz':
        return kombinRenkBeyaz;
      case 'kombinRenkSiyah':
        return kombinRenkSiyah;
      case 'kombinRenkKahverengi':
        return kombinRenkKahverengi;
      case 'kombinRenkLacivert':
        return kombinRenkLacivert;
      case 'kombinRenkBej':
        return kombinRenkBej;
      case 'kombinRenkKoyuYesil':
        return kombinRenkKoyuYesil;
      case 'kombinRenkNude':
        return kombinRenkNude;
      case 'kombinRenkAltin':
        return kombinRenkAltin;
      case 'kombinRenkGri':
        return kombinRenkGri;
      case 'kombinRenkPastelMavi':
        return kombinRenkPastelMavi;
      case 'kombinRenkKirmizi':
        return kombinRenkKirmizi;
      case 'kombinRenkMavi':
        return kombinRenkMavi;
      case 'kombinRenkGumus':
        return kombinRenkGumus;
      case 'kombinRenkKoyuMavi':
        return kombinRenkKoyuMavi;
      case 'kombinRenkKamel':
        return kombinRenkKamel;
      case 'kombinRenkYesil':
        return kombinRenkYesil;
      case 'kombinRenkAcikMavi':
        return kombinRenkAcikMavi;
      case 'kombinRenkNavy':
        return kombinRenkNavy;

      // Kategori
      case 'kombinKategoriAyakkabi':
        return kombinKategoriAyakkabi;
      case 'kombinKategoriCeket':
        return kombinKategoriCeket;
      case 'kombinKategoriAksesuar':
        return kombinKategoriAksesuar;

      // Eksik kategori
      case 'kombinEksik_ayakkabi':
        return kombinEksik_ayakkabi;
      case 'kombinEksik_ceket':
        return kombinEksik_ceket;
      case 'kombinEksik_aksesuar':
        return kombinEksik_aksesuar;

      // Soru
      case 'kombinSoru_ayakkabi':
        return kombinSoru_ayakkabi;
      case 'kombinSoru_ceket':
        return kombinSoru_ceket;
      case 'kombinSoru_aksesuar':
        return kombinSoru_aksesuar;

      // Seçenekler
      case 'kombinSecenekKahverengiOxford':
        return kombinSecenekKahverengiOxford;
      case 'kombinSecenekSiyahDerby':
        return kombinSecenekSiyahDerby;
      case 'kombinSecenekBeyazSpor':
        return kombinSecenekBeyazSpor;
      case 'kombinSecenekKahverengiCizme':
        return kombinSecenekKahverengiCizme;
      case 'kombinSecenekSiyahSuGecirmezBot':
        return kombinSecenekSiyahSuGecirmezBot;
      case 'kombinSecenekNudeBallerina':
        return kombinSecenekNudeBallerina;
      case 'kombinSecenekAltinSandalet':
        return kombinSecenekAltinSandalet;
      case 'kombinSecenekSiyahBlazer':
        return kombinSecenekSiyahBlazer;
      case 'kombinSecenekKirmiziDeriCeket':
        return kombinSecenekKirmiziDeriCeket;
      case 'kombinSecenekAltinDetayliCeket':
        return kombinSecenekAltinDetayliCeket;
      case 'kombinSecenekBeyazPufy':
        return kombinSecenekBeyazPufy;
      case 'kombinSecenekBeyazKosu':
        return kombinSecenekBeyazKosu;
      case 'kombinSecenekSiyahBasketbol':
        return kombinSecenekSiyahBasketbol;
      case 'kombinSecenekMaviTerlik':
        return kombinSecenekMaviTerlik;
      case 'kombinSecenekKahverengiLoafer':
        return kombinSecenekKahverengiLoafer;
      case 'kombinSecenekBeyazBespan':
        return kombinSecenekBeyazBespan;
      case 'kombinSecenekSiyahGunes':
        return kombinSecenekSiyahGunes;
      case 'kombinSecenekSiyahSirtCantasi':
        return kombinSecenekSiyahSirtCantasi;
      case 'kombinSecenekGumusAkilliSaat':
        return kombinSecenekGumusAkilliSaat;
      case 'kombinSecenekKamelCifteYaka':
        return kombinSecenekKamelCifteYaka;
      case 'kombinSecenekSiyahBomber':
        return kombinSecenekSiyahBomber;
      case 'kombinSecenekKirmiziPufy':
        return kombinSecenekKirmiziPufy;
      case 'kombinSecenekYesilDenim':
        return kombinSecenekYesilDenim;
      case 'kombinSecenekKahverengiKemer':
        return kombinSecenekKahverengiKemer;
      case 'kombinSecenekSiyahKemer':
        return kombinSecenekSiyahKemer;
      case 'kombinSecenekNavyBlokSal':
        return kombinSecenekNavyBlokSal;
      case 'kombinSecenekKahverengiGozluk':
        return kombinSecenekKahverengiGozluk;
      case 'kombinSecenekGriSuGecirmez':
        return kombinSecenekGriSuGecirmez;
      case 'kombinSecenekKahverengiTrekking':
        return kombinSecenekKahverengiTrekking;
      case 'kombinSecenekSiyahTerlik':
        return kombinSecenekSiyahTerlik;
      case 'kombinSecenekBeyazTenis':
        return kombinSecenekBeyazTenis;

      // Parça etiketleri
      case 'kombinParcaUst':
        return kombinParcaUst;
      case 'kombinParcaAlt':
        return kombinParcaAlt;

      // Sonuç ekranı
      case 'kombinOyunBitti':
        return kombinOyunBitti;
      case 'kombinToplamPuan':
        return kombinToplamPuan;
      case 'kombinBasariOrani':
        return kombinBasariOrani;
      case 'kombinTekrarOyna':
        return kombinTekrarOyna;
      case 'kombinAnaSayfa':
        return kombinAnaSayfa;
      case 'kombinSonucUsta':
        return kombinSonucUsta;
      case 'kombinSonucUstaMesaj':
        return kombinSonucUstaMesaj;
      case 'kombinSonucIyi':
        return kombinSonucIyi;
      case 'kombinSonucIyiMesaj':
        return kombinSonucIyiMesaj;
      case 'kombinSonucPratik':
        return kombinSonucPratik;
      case 'kombinSonucPratikMesaj':
        return kombinSonucPratikMesaj;

      // Genel
      case 'kombinOyunuBaslik':
        return kombinOyunuBaslik;
      case 'kombinMevcutKombin':
        return kombinMevcutKombin;

      default:
        return key;
    }
  }
}
