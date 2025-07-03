import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../models/user_settings.dart';

class Profilepg extends StatefulWidget {
  const Profilepg({super.key});

  @override
  State<Profilepg> createState() => _ProfilepgState();
}

class _ProfilepgState extends State<Profilepg> {
  String username = 'User';

  @override
  void initState() {
    super.initState();
    final box = Hive.box<UserSettings>('settingsBox');
    final settings = box.get('user');
    if (settings != null && settings.username.isNotEmpty) {
      username = settings.username;
    }
  }

  @override
  Widget build(BuildContext context) {
    final mainGreen = Colors.green[800];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: mainGreen,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: mainGreen,
                child: const Icon(Icons.person, size: 60, color: Colors.white),
              ),
              const SizedBox(height: 16),
              Text(
                username,
                style: TextStyle(
                  fontSize: 24,
                  color: mainGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: _changePinDialog,
                icon: const Icon(Icons.lock_reset),
                label: const Text("Change PIN"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainGreen,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  textStyle: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _changePinDialog() {
    final box = Hive.box<UserSettings>('settingsBox');
    final settings = box.get('user');
    final pinController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Change PIN"),
        content: TextField(
          controller: pinController,
          obscureText: true,
          maxLength: 4,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            hintText: "Enter new 4-digit PIN",
            counterText: "",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              final newPin = pinController.text.trim();
              if (newPin.length == 4 && settings != null) {
                settings.pin = newPin;
                box.put('user', settings);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("PIN updated")),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Enter a valid 4-digit PIN")),
                );
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}
