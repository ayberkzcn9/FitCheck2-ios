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

  // Bildirim ID'leri
  static const int sabahBildirimId = 1;
  static const int yikamaBildirimId = 2;
  static const int haftalikRaporBildirimId = 3;

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
      );

      _initialized = result ?? false;

      // Android notification kanallarını oluştur.
      await _androidKanallariOlustur(context);

      debugPrint('Bildirim Servisi Başlatıldı: $_initialized');
    } catch (e) {
      debugPrint('Bildirim Servisi Başlatılırken Hata: $e');
      _initialized = false;
    }
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

      // Android 12+ için Hassas Alarm/Hatırlatıcı izni kontrolü
      if (await Permission.scheduleExactAlarm.isDenied) {
        await Permission.scheduleExactAlarm.request();
      }

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
                color: Colors.orange,
                size: 26,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.bildirimIzinGerekliBaslik,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            l10n.bildirimIzinGerekliIcerik,
            style: const TextStyle(
              fontSize: 14,
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
                  borderRadius: BorderRadius.circular(12),
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
        color: const Color(0xFF3B3B3B),
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
  // 2. GÜNLÜK SABAH BİLDİRİMİ (v22.3.0 UYUMU)
  // ============================================================

  Future<void> gunlukSabahBildirimiKur({
    int saat = 8,
    int dakika = 30,
    BuildContext? context,
  }) async {
    if (!_initialized) await init(context);

    try {
      saat = saat.clamp(0, 23);
      dakika = dakika.clamp(0, 59);

      final l10n = await l10nAl(context);

      final AndroidNotificationDetails androidDetay =
          AndroidNotificationDetails(
        gunlukKanalId,
        l10n.bildirimKanalGunlukBaslik,
        channelDescription: l10n.bildirimKanalGunlukAciklama,
        importance: Importance.max,
        priority: Priority.high,
        color: const Color(0xFF3B3B3B),
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

      final simdi = tz.TZDateTime.now(tz.local);

      var planlananZaman = tz.TZDateTime(
        tz.local,
        simdi.year,
        simdi.month,
        simdi.day,
        saat,
        dakika,
      );

      if (!planlananZaman.isAfter(simdi)) {
        planlananZaman = planlananZaman.add(const Duration(days: 1));
      }

      await _notificationsPlugin.cancel(id: sabahBildirimId);

      await _notificationsPlugin.zonedSchedule(
        id: sabahBildirimId,
        title: l10n.bildirimGunaydinBaslik,
        body: l10n.bildirimGunaydinIcerik,
        scheduledDate: planlananZaman,
        notificationDetails: detaylar,
        androidScheduleMode: AndroidScheduleMode.exact,
        matchDateTimeComponents: DateTimeComponents.time,
      );

      debugPrint(
        'Günlük sabah bildirimi ${saat.toString().padLeft(2, '0')}:${dakika.toString().padLeft(2, '0')} için kuruldu.',
      );
    } catch (e) {
      debugPrint('Günlük bildirim kurulamadı: $e');
    }
  }

  // ============================================================
  // 3. GÜNLÜK SABAH BİLDİRİMİNİ İPTAL ET
  // ============================================================

  Future<void> gunlukSabahBildiriminiIptalEt() async {
    if (!_initialized) await init();

    try {
      await _notificationsPlugin.cancel(id: sabahBildirimId);
      debugPrint('Günlük sabah bildirimi iptal edildi.');
    } catch (e) {
      debugPrint('Sabah bildirimi iptal edilirken hata: $e');
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
        color: const Color(0xFF3B3B3B),
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      );

      await _notificationsPlugin.cancel(id: haftalikRaporBildirimId);
      await _notificationsPlugin.zonedSchedule(
        id: haftalikRaporBildirimId,
        title: l10n.haftalikStilRaporu,
        body: l10n.haftalikStilRaporuAciklama,
        scheduledDate: planlanan,
        notificationDetails: detaylar,
        androidScheduleMode: AndroidScheduleMode.exact,
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
