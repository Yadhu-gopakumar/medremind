// import 'package:flutter/material.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/data/latest.dart' as tz;

// import 'models/user_settings.dart';
// import 'models/medicine.dart';
// import 'models/history_entry.dart';
// import 'constants/hive_keys.dart';
// import 'app.dart';

// // final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   await Hive.initFlutter();


//   await Hive.openBox<UserSettings>(settingsBox);
//   await Hive.openBox<Medicine>(medicinesBox);
//   await Hive.openBox<HistoryEntry>(historyBox);
//  // Register adapters
//   Hive.registerAdapter(MedicineAdapter());
//   Hive.registerAdapter(HistoryEntryAdapter());
//   Hive.registerAdapter(UserSettingsAdapter());


//   // Open boxes
//   await Hive.openBox<Medicine>('medicinesBox');
//   await Hive.openBox<HistoryEntry>('historyBox');
//   await Hive.openBox<UserSettings>('settingsBox');
//   // tz.initializeTimeZones();

//   // await initNotifications();

//   runApp(const MyApp());
// }

// Future<void> initNotifications() async {
//   const android = AndroidInitializationSettings('@mipmap/ic_launcher');
//   const settings = InitializationSettings(android: android);
//   await notificationsPlugin.initialize(settings);
// }
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'models/user_settings.dart';
import 'models/medicine.dart';
import 'models/history_entry.dart';
import 'constants/hive_keys.dart';
import 'app.dart';

final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  //  Register adapters BEFORE opening boxes
  Hive.registerAdapter(MedicineAdapter());
  Hive.registerAdapter(HistoryEntryAdapter());
  Hive.registerAdapter(UserSettingsAdapter());



  // // DELETE corrupted or old boxes
  // await Hive.deleteBoxFromDisk('historyBox');
  // await Hive.deleteBoxFromDisk('medicinesBox');
  // await Hive.deleteBoxFromDisk('settingsBox');

  //  Now open boxes
  await Hive.openBox<Medicine>(medicinesBox);
  await Hive.openBox<HistoryEntry>(historyBox);
  await Hive.openBox<UserSettings>(settingsBox);

  // tz.initializeTimeZones(); // Uncomment if using time zones
  // await initNotifications();

  runApp(const MyApp());
}

Future<void> initNotifications() async {
  const android = AndroidInitializationSettings('@mipmap/ic_launcher');
  const settings = InitializationSettings(android: android);
  await notificationsPlugin.initialize(settings);
}
