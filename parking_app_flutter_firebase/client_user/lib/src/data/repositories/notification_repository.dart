import 'package:flutter/foundation.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../../local_notifications.dart';

class NotificationRepository {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      flutterLocalNotificationsPlugin;

  Future<void> scheduleParkingReminder({
    required int id,
    required DateTime endTime,
    Duration duration = const Duration(minutes: 10),
  }) async {
    await requestPermissions();

    final notificationTime = endTime.subtract(duration);
    // final notificationTime = endTime.subtract(const Duration(seconds: 10));

    // Ensure the notification is in the future
    if (notificationTime.isAfter(DateTime.now())) {
      await _notificationsPlugin.zonedSchedule(
        id,
        "Parkheim Reminder",
        "Your parking session will end in 10 minutes.",
        tz.TZDateTime.from(notificationTime, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            "parking_reminders",
            "Parking Reminders",
            channelDescription: "Notifications for parking session reminders",
            importance: Importance.max,
            priority: Priority.high,
            ticker: "ticker",
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    } else {
      debugPrint(
        "❌ -> Notification time is in the past. Notification not scheduled.",
      );
    }
  }

  Future<void> rescheduleParkingReminder(int id, DateTime newEndTime) async {
    // Cancel existing notification
    await cancelParkingReminder(id);

    // Schedule new notification with updated endTime
    await scheduleParkingReminder(id: id, endTime: newEndTime);
  }

  Future<void> cancelParkingReminder(int id) async {
    await _notificationsPlugin.cancel(id);
  }
}
