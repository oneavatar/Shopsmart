import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  Future<void> initialize() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    debugPrint('User granted permission: ${settings.authorizationStatus}');

    //get the token for this device
    String? token = await _messaging.getToken();
    debugPrint('Firebase Messaging Token: $token');

    //foreground message
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Received a message while in the foreground');
      debugPrint(message.notification?.title);
    });

    //background open
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('Message clicked!');
    });
  }
}
