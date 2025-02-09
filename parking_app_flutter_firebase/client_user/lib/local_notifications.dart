import 'dart:io';

import 'package:flutter/foundation.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:uuid/uuid.dart';

// Source: https://github.com/williamviktorsson/HFL24/blob/main/lectures/lecture_14/practice/admin_app/lib/main.dart

late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

Future<void> _configureLocalTimeZone() async {
  if (kIsWeb || Platform.isLinux) {
    return;
  }

  tz.initializeTimeZones();
  if (Platform.isWindows) {
    return;
  }

  final String timeZoneName = await FlutterTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName));
}

Future<void> initializeNotifications() async {
  await _configureLocalTimeZone();

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  var initializationSettingsAndroid = const AndroidInitializationSettings(
    "@mipmap/ic_launcher", // TODO: Change this to an icon of your choice if you want to fix it.
  );
  var initializationSettingsIOS = const DarwinInitializationSettings();

  // Add settings per platform
  var initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

Future<void> requestPermissions() async {
  if (Platform.isAndroid) {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    await androidImplementation?.requestNotificationsPermission();
  } else if (Platform.isIOS) {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  } else if (Platform.isMacOS) {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }
}

int notifications = 0;

Future<void> scheduleNotification({
  required String title,
  required String content,
  required DateTime time,
}) async {
  await requestPermissions();

  // id should be unique per message, but contents of the same
  // notification can be updated if you write to the same id
  String channelId = const Uuid().v4();

  // this can be anything, different channels can be configured to
  // have different colors, sound, vibration, we wont do that here
  const String channelName = "notifications_channel";
  // description is optional but shows up in user system settings
  String channelDescription = "Standard notifications";

  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    channelId,
    channelName,
    channelDescription: channelDescription,
    importance: Importance.max,
    priority: Priority.high,
    ticker: "ticker",
  );

  var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics);

  // from docs, not sure about specifics
  return await flutterLocalNotificationsPlugin.zonedSchedule(
    // id per notification is integer, can be reused to cancel notification
    notifications++,
    title,
    content,
    // TZDateTime required to take daylight savings into considerations.
    tz.TZDateTime.from(time, tz.local),
    platformChannelSpecifics,
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
  );
}

Future<void> cancelScheduledNotification(int id) async {
  await flutterLocalNotificationsPlugin.cancel(id);
}
