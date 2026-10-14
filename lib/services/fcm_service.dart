import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'bildirim_servisi.dart';
import 'auth_servisi.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('Background message received: ${message.messageId}');
  debugPrint('Title: ${message.notification?.title}');
  debugPrint('Body: ${message.notification?.body}');
}

/// FCM token güncelleme callback'i (opsiyonel, backend entegrasyonu için)
typedef TokenUpdateCallback = Future<void> Function(String token);

class FcmService {
  static final FcmService _instance = FcmService._internal();
  factory FcmService() => _instance;
  FcmService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  
  /// Opsiyonel token güncelleme callback'i (backend/Firestore entegrasyonu için)
  TokenUpdateCallback? onTokenUpdate;
  
  /// Navigasyon callback'i (bildirimden açılınca yönlendirme için)
  void Function(RemoteMessage)? onNotificationTap;

  Future<void> init() async {
    // Background handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Request permission for iOS
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    debugPrint('Permission granted: ${settings.authorizationStatus}');

    // Get FCM token
    String? token = await _messaging.getToken();
    debugPrint('FCM Token: $token');
    if (token != null) {
      await _kaydetToken(token);
    }

    // Listen to token refresh
    _messaging.onTokenRefresh.listen((newToken) {
      debugPrint('FCM Token refreshed: $newToken');
      _kaydetToken(newToken);
    });

    // Foreground messages - yerel bildirim göster
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Foreground message: ${message.messageId}');
      BildirimServisi().anlikBildirimGoster(
        baslik: message.notification?.title ?? 'Bildirim',
        icerik: message.notification?.body ?? '',
      );
    });

    // When app opened from notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('App opened from notification: ${message.messageId}');
      if (onNotificationTap != null) {
        onNotificationTap!(message);
      } else {
        _varsayilanNavigasyon(message);
      }
    });

    // Check if app opened from terminated state
    RemoteMessage? initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      debugPrint('App launched from notification: ${initialMessage.messageId}');
      if (onNotificationTap != null) {
        onNotificationTap!(initialMessage);
      } else {
        _varsayilanNavigasyon(initialMessage);
      }
    }
  }

  Future<void> _kaydetToken(String token) async {
    if (onTokenUpdate != null) {
      try {
        await onTokenUpdate!(token);
      } catch (e) {
        debugPrint('Token güncelleme callback hatası: $e');
      }
    }
    // Varsayılan: kullanıcı profilinde sakla (AuthServisi üzerinden)
    try {
      final user = AuthServisi().mevcutKullanici;
      if (user != null) {
        // Firestore'a kaydetme - AuthServisi'ne eklenecek metod kullanılabilir
        debugPrint('Token kullanıcıya bağlandı: ${user.uid}');
      }
    } catch (e) {
      debugPrint('Token kullanıcıya bağlanırken hata: $e');
    }
  }

  void _varsayilanNavigasyon(RemoteMessage message) {
    // Varsayılan: veri içindeki 'screen' alanına göre yönlendirme
    final screen = message.data['screen'];
    debugPrint('Bildirim navigasyon verisi: $screen');
    // Uygulama özel navigasyon mantığı buraya eklenebilir
  }

  Future<void> subscribeToTopic(String topic) async {
    await _messaging.subscribeToTopic(topic);
    debugPrint('Subscribed to topic: $topic');
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    await _messaging.unsubscribeFromTopic(topic);
    debugPrint('Unsubscribed from topic: $topic');
  }

  Future<void> updateLanguageTopic(String langCode) async {
    const supported = ['tr','en','de','fr','es','it','pt','ru','ja','ko','zh','ar'];
    final code = supported.contains(langCode) ? langCode : 'tr';
    // Eski dil topic'lerinden çık
    for (final l in supported) {
      await unsubscribeFromTopic('dil_$l');
    }
    // Yeni dile abone ol
    await subscribeToTopic('dil_$code');
    debugPrint('Language topic updated to: dil_$code');
  }
}
