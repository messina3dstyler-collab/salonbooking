import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    debugPrint("Notification permission: ${settings.authorizationStatus}");

    final token = await _messaging.getToken(
      vapidKey:
          "BBvhRFZf0ISdEeiXACTaOkK1NYQTQ0I0RK_bz56Hg8KXWYsgji8fXOnZ08nxrBw0lLn4TeJ7n98A3WEftiFSWgA",
    );

    debugPrint("========== FCM TOKEN ==========");
    debugPrint(token);
    debugPrint("===============================");

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint("Titolo: ${message.notification?.title}");

      debugPrint("Body: ${message.notification?.body}");
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint("Notifica aperta");
    });
  }
}
