import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class NotificationController {
  /// Use this method to detect when a new notification or a schedule is created
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
      ReceivedNotification receivedNotification) async {
    print('Notification Received');
  }
}

Future<void> init_notification() async {
  await AwesomeNotifications().initialize(
      'resource://drawable/ic_stat_bicycle',
      [
        NotificationChannel(
            channelGroupKey: 'simple_group',
            channelKey: 'simple_channel',
            channelName: 'simple notifications',
            channelDescription: 'simple notifications',
            defaultColor: Colors.redAccent,
            ledColor: Colors.white,
            channelShowBadge: true,
            importance: NotificationImportance.High)
      ],
      debug: true);
  await AwesomeNotifications().requestPermissionToSendNotifications();
}

Future<void> notifyNow({required String title, required body}) async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 10,
      channelKey: 'simple_channel',
      title: title,
      body: body,
      // icon: "@drawable/ic_stat_bicycle",
    ),
  );
}
