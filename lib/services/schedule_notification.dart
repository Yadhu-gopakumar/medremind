import 'dart:typed_data';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import '../main.dart'; // where flutterLocalNotificationsPlugin is defined

Future<void> scheduleMedicineNotification({
  required int id,
  required String title,
  required String body,
  required DateTime dateTime,
}) async {
  await flutterLocalNotificationsPlugin.zonedSchedule(
    id,
    title,
    body,
    tz.TZDateTime.from(dateTime, tz.local),
    NotificationDetails(
      android: AndroidNotificationDetails(
        'new_med_channel_id', // unique channel ID
        'Medicine Reminder', // channel name
        channelDescription: 'Reminder to take your medicine',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        sound: RawResourceAndroidNotificationSound(
            'alarm'), // alarm.mp3 in android/app/src/main/res/raw/
        audioAttributesUsage:
            AudioAttributesUsage.alarm, // Ensures alarm stream
        enableVibration: true,
        vibrationPattern: Int64List.fromList([0, 1000, 500, 1000]),
      ),
    ),
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
  );
}
