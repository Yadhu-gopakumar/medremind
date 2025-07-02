import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:medremind/screens/auth/lock_screen.dart';

import '../../models/user_settings.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _pinController = TextEditingController();
  final _answerController = TextEditingController();

  // Example security questions
  final List<String> _questions = [
    'What is your mother\'s name?',
    'What is your pet\'s name?',
    'What is your favorite color?',
    'What is your favorite food?',
  ];
  String? _selectedQuestion;

  @override
  void initState() {
    super.initState();
    _selectedQuestion = _questions[0];
  }

  void _register() async {
    final name = _nameController.text.trim();
    final pin = _pinController.text.trim();
    final answer = _answerController.text.trim();

    if (name.isEmpty ||
        pin.length != 4 ||
        int.tryParse(pin) == null ||
        answer.isEmpty ||
        _selectedQuestion == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields correctly.")),
      );
      return;
    }

    final userBox = Hive.box<UserSettings>('settingsBox');

    final user = UserSettings(
      username: name,
      pin: pin,
      alarmSound: 'alarm.mp3', // Default sound
      securityQuestion: _selectedQuestion!,
      securityAnswer: answer,
    );

    await userBox.put('user', user);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LockScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color backgroundGreen = Color(0xFF166D5B);
    const Color iconGreen = Color(0xFF388A6D);

    return Scaffold(
      backgroundColor: backgroundGreen,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: iconGreen,
                    child: Icon(
                      Icons.medication_liquid_rounded,
                      size: 70,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 32),
                  // App Name
                  const Text(
                    "MedRemind",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Welcome Text
                  const Text(
                    "Welcome!",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Please register with your details",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 28),
                  // Name Field
                  TextField(
                    controller: _nameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "Name",
                      labelStyle: const TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.white10,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon:
                          const Icon(Icons.person, color: Colors.white70),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // PIN Field
                  TextField(
                    controller: _pinController,
                    obscureText: true,
                    maxLength: 4,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(
                        color: Colors.white, letterSpacing: 16, fontSize: 22),
                    decoration: InputDecoration(
                      labelText: "4-digit PIN",
                      labelStyle: const TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.white10,
                      counterText: "",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(Icons.lock, color: Colors.white70),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Security Question Dropdown
                  DropdownButtonFormField<String>(
                    value: _selectedQuestion,
                    isExpanded: true,
                    dropdownColor: backgroundGreen,
                    items: _questions
                        .map(
                          (q) => DropdownMenuItem(
                              value: q,
                              child: Text(q,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 14))),
                        )
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectedQuestion = val;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: "Security Question",
                      labelStyle: const TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.white10,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon:
                          const Icon(Icons.security, color: Colors.white70),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  // Security Answer
                  TextField(
                    controller: _answerController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "Your Answer",
                      labelStyle: const TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.white10,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(Icons.question_answer,
                          color: Colors.white70),
                    ),
                  ),
                  const SizedBox(height: 28),
                  // Save & Continue Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: iconGreen,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Save & Continue",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
