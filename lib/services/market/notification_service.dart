import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin
  _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  // Initialize notifications
  static Future<void> init() async {
    const AndroidInitializationSettings
    androidSettings =
    AndroidInitializationSettings(
        '@mipmap/ic_launcher');

    const InitializationSettings settings =
    InitializationSettings(
      android: androidSettings,
    );

    await _notificationsPlugin.initialize(
      settings,
    );
  }

  // Show notification
  static Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails
    androidDetails =
    AndroidNotificationDetails(
      'market_channel',
      'Market Updates',
      channelDescription:
      'Notifications for market price updates',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails details =
    NotificationDetails(
      android: androidDetails,
    );

    await _notificationsPlugin.show(
      0,
      title,
      body,
      details,
    );
  }
}