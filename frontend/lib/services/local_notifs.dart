import 'package:flutter_local_notifications/flutter_local_notifications.dart';

//only for andoird, will add something later for ios
class LocalNotification {
  FlutterLocalNotificationsPlugin flnp;
  LocalNotification(this.flnp);


  Future<void> initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    InitializationSettings initializationSettings =
        const InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flnp.initialize(initializationSettings);
  }

   Future<void> showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'com.oandb.tech.chat.defaultId',
      'com.oandb.tech.chat.defaultId',
      importance: Importance.max,
      priority: Priority.high,
      actions: [
        AndroidNotificationAction(
          'open',
          'Open',
        ),
      ],
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flnp.show(
      0,
      title,
      body,
      platformChannelSpecifics,
    );
  }

   Future<void> onNotificationActionButtonTapped(String actionId) async {
    print('Action button tapped! Action ID: $actionId');
  }
}
