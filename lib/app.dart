import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'models/user_settings.dart';
import 'constants/hive_keys.dart';
import 'screens/auth/lock_screen.dart';
import 'screens/auth/register.dart';
// import 'screens/home/home_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> initNotifications() async {
  const android = AndroidInitializationSettings('@mipmap/ic_launcher');

  const settings = InitializationSettings(android: android);
  await notificationsPlugin.initialize(settings);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ Rename this to avoid shadowing the global constant
    final Box<UserSettings> userBox = Hive.box<UserSettings>(settingsBox);

    final bool isRegistered = userBox.isNotEmpty;

   return MaterialApp(
  title: 'Medicine Reminder',
  debugShowCheckedModeBanner: false,
  theme: ThemeData(primarySwatch: Colors.teal),
  home: isRegistered ? const LockScreen() : const RegisterScreen(),
  
);

  }
}
