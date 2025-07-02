import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'models/user_settings.dart';
import 'models/medicine.dart';
import 'models/history_entry.dart';
import 'constants/hive_keys.dart';
import 'app.dart';

// final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(UserSettingsAdapter());
  if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(MedicineAdapter());
  if (!Hive.isAdapterRegistered(2)) Hive.registerAdapter(HistoryEntryAdapter());

  await Hive.openBox<UserSettings>(settingsBox);
  await Hive.openBox<Medicine>(medicinesBox);
  await Hive.openBox<HistoryEntry>(historyBox);

  tz.initializeTimeZones();

  // await initNotifications();

  runApp(const MyApp());
}

Future<void> initNotifications() async {
  const android = AndroidInitializationSettings('@mipmap/ic_launcher');
  const settings = InitializationSettings(android: android);
  await notificationsPlugin.initialize(settings);
}
