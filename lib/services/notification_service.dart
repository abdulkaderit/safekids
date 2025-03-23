import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static Future<void> showNotification(String title, String body) async {
    var androidDetails = AndroidNotificationDetails(
        'channel_id', // Channel ID
        'channel_name', // Channel Name
        channelDescription: 'channel_description', // Channel Description
        importance: Importance.high,
        priority: Priority.high
    );
    var generalNotificationDetails = NotificationDetails(android: androidDetails);
    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      title, // Title of the notification
      body, // Body of the notification
      generalNotificationDetails, // Notification details
    );
  }
}



