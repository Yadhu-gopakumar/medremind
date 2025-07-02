import 'package:flutter/material.dart';

class CircularProgress extends StatelessWidget {
  final int taken;
  final int total;

  const CircularProgress({super.key, required this.taken, required this.total});

  @override
  Widget build(BuildContext context) {
    final percent = total == 0 ? 0.0 : taken / total;
    return Stack(
      alignment: Alignment.center,
      children: [
        CircularProgressIndicator(value: percent, strokeWidth: 10),
        Text("${(percent * 100).toInt()}%", style: const TextStyle(fontSize: 18)),
      ],
    );
  }
}
