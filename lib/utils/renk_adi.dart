import '../l10n/app_localizations.dart';

/// Kayıtlı renk adını (ör. "bordo", "Lacivert") kullanıcının diline çevirir.
///
/// Kıyafet rengi, kıyafet eklendiği andaki dilde saklanır; uygulama dili
/// sonradan değişince İngilizce ekranda Türkçe renk adı kalıyordu. Bilinen
/// Türkçe renk adları yerelleştirilir, bilinmeyenler olduğu gibi gösterilir.
String renkAdiYerellestir(AppLocalizations l10n, String renk) {
  final anahtar = renk.trim().toLowerCase();
  return switch (anahtar) {
    'lacivert' => l10n.kombinRenkLacivert,
    'beyaz' => l10n.kombinRenkBeyaz,
    'kahverengi' => l10n.kombinRenkKahverengi,
    'siyah' => l10n.kombinRenkSiyah,
    'bej' => l10n.kombinRenkBej,
    'gri' => l10n.kombinRenkGri,
    'yeşil' || 'yesil' => l10n.kombinRenkYesil,
    'kırmızı' || 'kirmizi' => l10n.kombinRenkKirmizi,
    'mavi' => l10n.kombinRenkMavi,
    'turuncu' => l10n.renkTuruncu,
    'sarı' || 'sari' => l10n.renkSari,
    'mor' => l10n.renkMor,
    'pembe' => l10n.renkPembe,
    'haki' => l10n.renkHaki,
    'ekru' => l10n.renkEkru,
    'bordo' => l10n.renkBordo,
    _ => renk,
  };
}
