import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    // permission

    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    debugPrint('Permission: ${settings.authorizationStatus}');

    // token

    String? token = await _messaging.getToken();

    debugPrint('FCM Token: $token');

    // local notification setup

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: androidSettings);

    await _localNotifications.initialize(settings: initializationSettings);

    // foreground message

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      debugPrint('Foreground notification');

      await _showNotification(
        title: message.notification?.title ?? 'ShopSmart',

        body: message.notification?.body ?? '',
      );
    });

    // notification clicked

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      debugPrint('Notification clicked');
    });
  }

  Future<void> _showNotification({
    required String title,

    required String body,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'shopsmart_channel',

          'ShopSmart Notifications',

          importance: Importance.max,

          priority: Priority.high,
        );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await _localNotifications.show(
      id: 0,
      title: title,
      body: body,
      notificationDetails: notificationDetails,
    );
  }
}
