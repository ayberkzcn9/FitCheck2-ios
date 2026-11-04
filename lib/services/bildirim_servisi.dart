import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../l10n/app_localizations.dart';
import '../utils/l10n_yardimcilari.dart';
import '../../theme/design_tokens.dart';

class BildirimServisi {
  static final BildirimServisi _instance = BildirimServisi._internal();

  factory BildirimServisi() => _instance;

  BildirimServisi._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  /// Bildirime dokunulduğunda açılacak sekme.
  ///
  /// Değerler: `bugun`, `plan`, `duello`. AnaEkran bunu dinler; tüketince
  /// null'a çeker.
  final ValueNotifier<String?> hedefSekme = ValueNotifier<String?>(null);

  // Bildirim ID'leri
  static const int sabahBildirimId = 1;
  static const int yikamaBildirimId = 2;
  static const int haftalikRaporBildirimId = 3;

  // Yedi günlük seriler: 10-16 sabah, 20-26 akşam plan hatırlatıcısı.
  static const int sabahSeriIlkId = 10;
  static const int planSeriIlkId = 20;
  static const int seriUzunlugu = 7;

  // Kanal ID'leri
  static const String genelKanalId = 'fitcheck_genel';
  static const String gunlukKanalId = 'fitcheck_gunluk';
  static const String yikamaKanalId = 'fitcheck_yikama';
  static const String raporKanalId = 'fitcheck_rapor';

  // ============================================================
  // BAŞLATMA
  // ============================================================

  Future<void> init([BuildContext? context]) async {
    if (_initialized) return;

    try {
      // Timezone veritabanını başlat.
      tz.initializeTimeZones();

      try {
        tz.setLocalLocation(tz.getLocation('Europe/Istanbul'));
      } catch (_) {
        tz.setLocalLocation(tz.local);
      }

      // ANDROID
      const AndroidInitializationSettings androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      // iOS
      const DarwinInitializationSettings iosSettings =
          DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      // GENEL
      const InitializationSettings initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      final bool? result = await _notificationsPlugin.initialize(
        settings: initSettings,
        onDidReceiveNotificationResponse: _bildirimeDokunuldu,
      );

      _initialized = result ?? false;

      // Uygulama kapalıyken bildirime dokunulup açıldıysa hedefi yakala.
      try {
        final baslatma =
            await _notificationsPlugin.getNotificationAppLaunchDetails();
        if (baslatma?.didNotificationLaunchApp ?? false) {
          final hedef = baslatma?.notificationResponse?.payload;
          if (hedef != null && hedef.isNotEmpty) {
            hedefSekme.value = hedef;
          }
        }
      } catch (e) {
        debugPrint('Bildirim başlatma bilgisi okunamadı: $e');
      }

      // Android notification kanallarını oluştur.
      await _androidKanallariOlustur(context);

      debugPrint('Bildirim Servisi Başlatıldı: $_initialized');
    } catch (e) {
      debugPrint('Bildirim Servisi Başlatılırken Hata: $e');
      _initialized = false;
    }
  }

  /// Bildirime dokunulduğunda çalışır; hedef sekmeyi not eder.
  void _bildirimeDokunuldu(NotificationResponse yanit) {
    final hedef = yanit.payload;
    if (hedef == null || hedef.isEmpty) return;
    hedefSekme.value = hedef;
  }

  // ============================================================
  // ANDROID KANALLARI
  // ============================================================

  Future<void> _androidKanallariOlustur([BuildContext? context]) async {
    final androidPlugin = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin == null) return;

    final l10n = await l10nAl(context);

    final AndroidNotificationChannel genelKanal = AndroidNotificationChannel(
      genelKanalId,
      l10n.bildirimKanalGenelBaslik,
      description: l10n.bildirimKanalGenelAciklama,
      importance: Importance.high,
    );

    final AndroidNotificationChannel gunlukKanal = AndroidNotificationChannel(
      gunlukKanalId,
      l10n.bildirimKanalGunlukBaslik,
      description: l10n.bildirimKanalGunlukAciklama,
      importance: Importance.high,
    );

    final AndroidNotificationChannel yikamaKanal = AndroidNotificationChannel(
      yikamaKanalId,
      l10n.bildirimKanalYikamaBaslik,
      description: l10n.bildirimKanalYikamaAciklama,
      importance: Importance.high,
    );

    final AndroidNotificationChannel raporKanal = AndroidNotificationChannel(
      raporKanalId,
      l10n.bildirimKanalRaporBaslik,
      description: l10n.bildirimKanalRaporAciklama,
      importance: Importance.high,
    );

    await androidPlugin.createNotificationChannel(genelKanal);
    await androidPlugin.createNotificationChannel(gunlukKanal);
    await androidPlugin.createNotificationChannel(yikamaKanal);
    await androidPlugin.createNotificationChannel(raporKanal);
  }

  // ============================================================
  // BİLDİRİM İZNİ
  // ============================================================

  Future<bool> bildirimIzniKontrolEtVeIste(BuildContext context) async {
    try {
      PermissionStatus status = await Permission.notification.status;

      if (status.isDenied) {
        status = await Permission.notification.request();
      }

      if (status.isPermanentlyDenied || status.isRestricted) {
        if (!context.mounted) return false;
        await _bildirimIzinUyarisiGoster(context);
        return false;
      }

      // Android 12+ "tam zamanlı alarm" izni (Alarms & reminders) bilerek
      // burada istenmiyor: anahtarı çevirirken kullanıcıyı sistem
      // ayarlarına atlamak akışı bölüyor. Izin yoksa bildirimler yine
      // gelir, sadece birkaç dakika geç gelir. Kullanıcı isterse Ayarlar >
      // Bildirimler bölümünden kendisi verir.

      if (status.isGranted || status.isLimited) {
        return true;
      }

      return false;
    } catch (e) {
      debugPrint('Bildirim izni kontrol edilirken hata: $e');
      return false;
    }
  }

  // ============================================================
  // 1.5 ZAMANLAMA (TAM ZAMANLI ALARM İZNİ)
  // ============================================================
  //
  // Android 12+ cihazlarda "tam zamanlı alarm" izni verilmeden `exact`
  // modu kullanılırsa eklenti `exact_alarms_not_permitted` hatası
  // fırlatır ve bildirim HİÇ kurulmaz. Bu yüzden:
  //   1) izin varsa tam saatinde (exactAllowWhileIdle),
  //   2) izin yoksa birkaç dakika geç ama MUTLAKA gelir (inexact).
  //
  // İzin "Alarms & reminders" (Özel izin > Alarmlar ve hatırlatıcılar)
  // ekranından verilir; Ayarlar > Bildirimler bölümünden istenebilir.

  /// Tam zamanlı alarm izni var mı? (Android 12+ özel izin)
  Future<bool> tamZamanliAlarmIzinVar() async {
    try {
      final androidPlugin = _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      if (androidPlugin == null) return false;
      final sonuc = await androidPlugin.canScheduleExactNotifications();
      return sonuc ?? false;
    } catch (e) {
      debugPrint('Tam zamanlı alarm izni okunamadı: $e');
      return false;
    }
  }

  /// Android'de "Alarms & reminders" ekranını açar; kullanıcı izin verirse
  /// bildirimler tam seçtiği saatte gelir.
  Future<bool> tamZamanliAlarmIzinIste() async {
    try {
      final androidPlugin = _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      if (androidPlugin == null) return false;
      final sonuc = await androidPlugin.requestExactAlarmsPermission();
      return sonuc ?? false;
    } catch (e) {
      debugPrint('Tam zamanlı alarm izni istenemedi: $e');
      return false;
    }
  }

  /// Zamanlama modunu seçer (saf fonksiyon, test edilebilir).
  ///
  /// İzin varsa tam saatinde, yoksa `inexact`: birkaç dakika geç gelebilir
  /// ama bildirim ASLA kaybolmaz.
  @visibleForTesting
  static AndroidScheduleMode alarmModuSec({required bool tamZamanliIzinVar}) {
    return tamZamanliIzinVar
        ? AndroidScheduleMode.exactAllowWhileIdle
        : AndroidScheduleMode.inexactAllowWhileIdle;
  }

  // ============================================================
  // BİLDİRİM İZNİ UYARISI
  // ============================================================

  Future<void> _bildirimIzinUyarisiGoster(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.xlRadius,
          ),
          title: Row(
            children: [
              const Icon(
                Icons.notifications_off_rounded,
                color: AppAccents.warning,
                size: 26,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.bildirimIzinGerekliBaslik,
                  style: const TextStyle(
                    fontSize: AppText.sizeBodyLarge,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            l10n.bildirimIzinGerekliIcerik,
            style: const TextStyle(
              fontSize: AppText.sizeBodySmall,
              height: 1.4,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                l10n.iptal,
                style: TextStyle(color: colors.onSurfaceVariant),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadius.mdRadius,
                ),
              ),
              onPressed: () async {
                Navigator.pop(dialogContext);
                await openAppSettings();
              },
              child: Text(
                l10n.ayarlaraGit,
                style: TextStyle(
                  color: colors.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // 1. ANLIK BİLDİRİM
  // ============================================================

  Future<void> anlikBildirimGoster({
    required String baslik,
    required String icerik,
    BuildContext? context,
  }) async {
    if (!_initialized) await init(context);

    try {
      final l10n = await l10nAl(context);

      final AndroidNotificationDetails androidDetay =
          AndroidNotificationDetails(
        genelKanalId,
        l10n.bildirimKanalGenelBaslik,
        channelDescription: l10n.bildirimKanalGenelAciklama,
        importance: Importance.max,
        priority: Priority.high,
        color: AppAccents.primary,
      );

      const DarwinNotificationDetails iosDetay = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      final NotificationDetails detaylar = NotificationDetails(
        android: androidDetay,
        iOS: iosDetay,
      );

      await _notificationsPlugin.show(
        id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
        title: baslik,
        body: icerik,
        notificationDetails: detaylar,
      );

      debugPrint('Anlık bildirim gönderildi.');
    } catch (e) {
      debugPrint('Anlık bildirim gösterilemedi: $e');
    }
  }

  // ============================================================
  // 2. GÜNLÜK SABAH BİLDİRİMİ — YEDİ GÜNLÜK SERİ
  // ============================================================
  //
  // Tekrarlayan (matchDateTimeComponents) tek bildirim yerine her gün için
  // ayrı bir bildirim kuruluyor: böylece gövdeye o günün gerçek kombini
  // yazılabiliyor. Uygulama her açıldığında seri tazelenir.

  Future<void> sabahBildirimleriKur({
    required List<BildirimIcerigi> bildirimler,
    BuildContext? context,
  }) async {
    final l10n = await l10nAl(context);
    await _seriKur(
      bildirimler: bildirimler,
      ilkId: sabahSeriIlkId,
      kanalId: gunlukKanalId,
      kanalBaslik: l10n.bildirimKanalGunlukBaslik,
      kanalAciklama: l10n.bildirimKanalGunlukAciklama,
    );
  }

  /// Akşam "yarınki kombinin hazır" hatırlatıcıları.
  Future<void> planHatirlatmalariniKur({
    required List<BildirimIcerigi> bildirimler,
    BuildContext? context,
  }) async {
    final l10n = await l10nAl(context);
    await _seriKur(
      bildirimler: bildirimler,
      ilkId: planSeriIlkId,
      kanalId: genelKanalId,
      kanalBaslik: l10n.bildirimKanalGenelBaslik,
      kanalAciklama: l10n.bildirimKanalGenelAciklama,
    );
  }

  /// Bildirimi zamanlar.
  ///
  /// Önce tam zamanlı alarm dener; izin yoksa veya hata verirse
  /// `inexactAllowWhileIdle` moda düşer. Böylece bildirim uygulama kapalıyken
  /// de gelir; en kötü ihtimalle birkaç dakika geç gelir.
  Future<void> _zamanla({
    required int id,
    required String? title,
    required String? body,
    required tz.TZDateTime scheduledDate,
    required NotificationDetails notificationDetails,
    String? payload,
    DateTimeComponents? matchDateTimeComponents,
  }) async {
    final androidPlugin = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    // iOS / web / masaüstü: mod yok, doğrudan zamanla.
    if (androidPlugin == null) {
      await _notificationsPlugin.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: scheduledDate,
        notificationDetails: notificationDetails,
        payload: payload,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: matchDateTimeComponents,
      );
      return;
    }

    final mod = alarmModuSec(
      tamZamanliIzinVar: await tamZamanliAlarmIzinVar(),
    );

    try {
      await _notificationsPlugin.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: scheduledDate,
        notificationDetails: notificationDetails,
        payload: payload,
        androidScheduleMode: mod,
        matchDateTimeComponents: matchDateTimeComponents,
      );
    } catch (e) {
      // İzin tam zamanlı sırada geldiyse bir kez inexact ile dene.
      if (mod == AndroidScheduleMode.inexactAllowWhileIdle) rethrow;
      debugPrint('Tam zamanlı alarm kurulamadı ($id), inexact deneniyor: $e');
      await _notificationsPlugin.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: scheduledDate,
        notificationDetails: notificationDetails,
        payload: payload,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: matchDateTimeComponents,
      );
    }
  }

  Future<void> _seriKur({
    required List<BildirimIcerigi> bildirimler,
    required int ilkId,
    required String kanalId,
    required String kanalBaslik,
    required String kanalAciklama,
  }) async {
    if (!_initialized) await init();

    try {
      await _seriyiIptalEt(ilkId);

      final NotificationDetails detaylar = NotificationDetails(
        android: AndroidNotificationDetails(
          kanalId,
          kanalBaslik,
          channelDescription: kanalAciklama,
          importance: Importance.high,
          priority: Priority.high,
          color: AppAccents.primary,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      );

      final simdi = tz.TZDateTime.now(tz.local);
      var kurulan = 0;

      for (var i = 0; i < bildirimler.length && i < seriUzunlugu; i++) {
        final icerik = bildirimler[i];
        final zaman = tz.TZDateTime(
          tz.local,
          icerik.zaman.year,
          icerik.zaman.month,
          icerik.zaman.day,
          icerik.zaman.hour,
          icerik.zaman.minute,
        );
        // Geçmiş saatteki bildirim hemen düşerdi; atla.
        if (!zaman.isAfter(simdi)) continue;

        await _zamanla(
          id: ilkId + i,
          title: icerik.baslik,
          body: icerik.icerik,
          scheduledDate: zaman,
          notificationDetails: detaylar,
          payload: icerik.hedef,
        );
        kurulan++;
      }

      debugPrint('Bildirim serisi kuruldu ($ilkId): $kurulan adet.');
    } catch (e) {
      debugPrint('Bildirim serisi kurulamadı ($ilkId): $e');
    }
  }

  Future<void> _seriyiIptalEt(int ilkId) async {
    for (var i = 0; i < seriUzunlugu; i++) {
      try {
        await _notificationsPlugin.cancel(id: ilkId + i);
      } catch (_) {
        // Tek tek iptal başarısız olsa da devam et.
      }
    }
  }

  // ============================================================
  // 3. BİLDİRİMLERİ İPTAL ET
  // ============================================================

  Future<void> gunlukSabahBildiriminiIptalEt() async {
    if (!_initialized) await init();

    try {
      await _notificationsPlugin.cancel(id: sabahBildirimId);
      await _seriyiIptalEt(sabahSeriIlkId);
      debugPrint('Sabah bildirimleri iptal edildi.');
    } catch (e) {
      debugPrint('Sabah bildirimi iptal edilirken hata: $e');
    }
  }

  Future<void> planHatirlatmalariniIptalEt() async {
    if (!_initialized) await init();
    try {
      await _seriyiIptalEt(planSeriIlkId);
      debugPrint('Akşam plan hatırlatıcıları iptal edildi.');
    } catch (e) {
      debugPrint('Plan hatırlatıcıları iptal edilemedi: $e');
    }
  }

  // Haftalık stil raporu: her pazar akşamı yeniden planlanır.
  Future<void> haftalikRaporBildiriminiKur({
    int saat = 20,
    int dakika = 0,
    BuildContext? context,
  }) async {
    if (!_initialized) await init(context);

    try {
      final l10n = await l10nAl(context);
      final simdi = tz.TZDateTime.now(tz.local);
      var planlanan = tz.TZDateTime(
        tz.local,
        simdi.year,
        simdi.month,
        simdi.day,
        saat,
        dakika,
      );

      // DateTime.monday = 1, pazar = 7.
      var gunFarki = DateTime.sunday - simdi.weekday;
      if (gunFarki < 0) gunFarki += 7;
      planlanan = planlanan.add(Duration(days: gunFarki));
      if (!planlanan.isAfter(simdi)) {
        planlanan = planlanan.add(const Duration(days: 7));
      }

      final detaylar = NotificationDetails(
        android: AndroidNotificationDetails(
          raporKanalId,
          l10n.bildirimKanalRaporBaslik,
          channelDescription: l10n.bildirimKanalRaporAciklama,
          importance: Importance.high,
          priority: Priority.high,
        color: AppAccents.primary,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      );

      await _notificationsPlugin.cancel(id: haftalikRaporBildirimId);
      await _zamanla(
        id: haftalikRaporBildirimId,
        title: l10n.haftalikStilRaporu,
        body: l10n.haftalikStilRaporuAciklama,
        scheduledDate: planlanan,
        notificationDetails: detaylar,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      );
    } catch (e) {
      debugPrint('Haftalık rapor bildirimi kurulamadı: $e');
    }
  }

  Future<void> haftalikRaporBildiriminiIptalEt() async {
    if (!_initialized) await init();
    try {
      await _notificationsPlugin.cancel(id: haftalikRaporBildirimId);
    } catch (e) {
      debugPrint('Haftalık rapor bildirimi iptal edilemedi: $e');
    }
  }

  // ============================================================
  // 4. TÜM FITCHECK BİLDİRİMLERİNİ İPTAL ET
  // ============================================================

  Future<void> tumBildirimleriIptalEt() async {
    if (!_initialized) await init();

    try {
      await _notificationsPlugin.cancelAll();
      debugPrint('Tüm FitCheck bildirimleri iptal edildi.');
    } catch (e) {
      debugPrint('Bildirimler iptal edilirken hata: $e');
    }
  }

  // ============================================================
  // 5. BEKLEYEN BİLDİRİMLER
  // ============================================================

  Future<List<PendingNotificationRequest>> bekleyenBildirimleriGetir() async {
    if (!_initialized) await init();

    try {
      return await _notificationsPlugin.pendingNotificationRequests();
    } catch (e) {
      debugPrint('Bekleyen bildirimler alınamadı: $e');
      return [];
    }
  }
}

/// Tek bir bildirimin içeriği ve zamanı.
///
/// [zaman] yerel saat diliminde duvar saatidir (gün + saat + dakika).
class BildirimIcerigi {
  const BildirimIcerigi({
    required this.zaman,
    required this.baslik,
    required this.icerik,
    this.hedef,
  });

  final DateTime zaman;
  final String baslik;
  final String icerik;

  /// Dokununca açılacak sekme: ugun, plan, duello.
  final String? hedef;
}
