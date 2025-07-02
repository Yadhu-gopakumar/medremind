import 'package:flutter/material.dart';

class Profilepg extends StatefulWidget {
  const Profilepg({super.key});

  @override
  State<Profilepg> createState() => _ProfilepgState();
}

class _ProfilepgState extends State<Profilepg> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        backgroundColor: Colors.green[800],
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Text(
          'Profile Page',
          style: TextStyle(fontSize: 24, color: Colors.green[800]),
        ),
      ),
    );
  }
}