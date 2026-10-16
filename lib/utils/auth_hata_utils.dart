import '../l10n/app_localizations.dart';

/// `AuthServisi`'nin fırlattığı `authHata*` yerelleştirme anahtarlarını
/// (ör. 'authHataZayifSifre') seçili dile çevirir.
///
/// Servis katmanı BuildContext'e erişemediği için orada yalnızca anahtar
/// üretilir; kullanıcıya gösterilecek metin burada, arayüz katmanında
/// oluşturulur. Anahtar olmayan (gerçek bir istisna) değerler olduğu gibi
/// döner ve böylece mevcut davranış korunur.
String authHatasiMetni(Object hata, AppLocalizations l10n) {
  final mesaj = hata is String ? hata : hata.toString();
  switch (mesaj) {
    case 'authHataZayifSifre':
      return l10n.authHataZayifSifre;
    case 'authHataEpostaKullanimda':
      return l10n.authHataEpostaKullanimda;
    case 'authHataGecersizEposta':
      return l10n.authHataGecersizEposta;
    case 'authHataKullaniciBulunamadi':
      return l10n.authHataKullaniciBulunamadi;
    case 'authHataYanlisSifre':
      return l10n.authHataYanlisSifre;
    case 'authHataGecersizKimlik':
      return l10n.authHataGecersizKimlik;
    case 'authHataYontemIzinliDegil':
      return l10n.authHataYontemIzinliDegil;
    case 'authHataFarkliYontem':
      return l10n.authHataFarkliYontem;
    case 'authHataAgHatasi':
      return l10n.authHataAgHatasi;
    case 'authHataCokDeneme':
      return l10n.authHataCokDeneme;
    case 'authHataHesapDevreDisi':
      return l10n.authHataHesapDevreDisi;
    case 'authHataYenidenGiris':
      return l10n.authHataYenidenGiris;
    case 'authHataGenel':
      return l10n.authHataGenel;
    case 'authHataSifreEpostasiGonderilemedi':
      return l10n.authHataSifreEpostasiGonderilemedi;
    case 'authHataGoogleDogrulanamadi':
      return l10n.authHataGoogleDogrulanamadi;
    case 'authHataGoogleFarkliKullanici':
      return l10n.authHataGoogleFarkliKullanici;
    case 'authHataGoogleZatenBagli':
      return l10n.authHataGoogleZatenBagli;
    case 'authHataGoogleYapilandirilmamis':
      return l10n.authHataGoogleYapilandirilmamis;
    case 'authHataGooglePencereAcik':
      return l10n.authHataGooglePencereAcik;
    case 'authHataGoogleTamamlanamadi':
      return l10n.authHataGoogleTamamlanamadi;
    case 'authHataGoogleHesapSec':
      return l10n.authHataGoogleHesapSec;
    case 'authHataGoogleOnayBekliyor':
      return l10n.authHataGoogleOnayBekliyor;
    case 'authHataGoogleBeklenmeyen':
      return l10n.authHataGoogleBeklenmeyen;
    default:
      return mesaj;
  }
}
