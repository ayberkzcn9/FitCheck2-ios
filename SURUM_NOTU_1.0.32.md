# FitCheck 1.0.32+38 — Sürüm Notu

Play Console'a yüklenecek 12 dilli kısa not. Her satır 500 UTF-16 karakterin
altında.

## tr
Reklam ödülü bildirimi düzeltildi: kazandığın hak artık ekranda doğru görünüyor. Onboarding ve izin ekranları yeni temaya uyarlandı.

## en
Fixed the rewarded-ad message: the credits you earn now show correctly. Onboarding and permission screens now match the new theme.

## de
Die Belohnungsanzeige für Werbevideos wurde korrigiert: Das Guthaben wird jetzt richtig angezeigt. Onboarding und Berechtigungen im neuen Design.

## fr
Message de récompense publicitaire corrigé : vos crédits s'affichent désormais correctement. Onboarding et autorisations adaptés au nouveau thème.

## es
Corregido el mensaje de recompensa por anuncio: los créditos ahora se muestran correctamente. Onboarding y permisos adaptados al nuevo tema.

## it
Corretto il messaggio del premio pubblicitario: i crediti ora sono mostrati correttamente. Onboarding e permessi adattati al nuovo tema.

## pt
Corrigida a mensagem de recompensa do anúncio: os créditos agora aparecem corretamente. Onboarding e permissões ajustados ao novo tema.

## ru
Исправлено сообщение о награде за рекламу: кредиты теперь отображаются верно. Онбординг и разрешения в новом оформлении.

## ar
تم تصحيح رسالة مكافأة الإعلان: أصبح الرصيد يظهر بشكل صحيح. تحديث شاشات البداية والأذونات بالتصميم الجديد.

## ja
広告報酬の表示を修正しました。獲得したクレジットが正しく表示されます。オンボーディングと権限画面も新しいテーマに対応しました。

## ko
광고 보상 안내를 수정했습니다. 획득한 크레딧이 이제 정확히 표시됩니다. 온보딩과 권한 화면도 새 테마에 맞췄습니다.

## zh
修复了广告奖励提示：获得的额度现在会正确显示。引导页和权限页已适配新主题。

---

## Kapalı test notu (Türkçe)

- Reklam ödülü metinleri kodda tek kaynağa bağlandı (`reklamOduluKredi`,
  `reklamOduluSlot`). Metinlerde sabit sayı kalmadı.
- 11 dildeki hatalı "+3" vaadi düzeltildi; artık ekranda gerçek ödül (+2)
  görünüyor.
- Yorum isteğinde "+3 ücretsiz kredi" vaadi kaldırıldı: uygulama bu krediyi
  vermiyordu ve Play politikası yorum karşılığı ödülü yasaklıyor.
- Bu hatanın tekrar oluşmaması için `test/odul_metni_test.dart` eklendi.
- `stil_gunlugu_ekrani_test.dart` sabit tarihli tohum verisi yüzünden
  kendiliğinden bozuluyordu; tarihler göreli hale getirildi.
