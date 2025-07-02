import 'package:flutter/material.dart';

class MedicineTile extends StatelessWidget {
  final String name;
  final String time;
  final VoidCallback onTaken;
  final VoidCallback onSkipped;

  const MedicineTile({
    super.key,
    required this.name,
    required this.time,
    required this.onTaken,
    required this.onSkipped,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(name),
      subtitle: Text("Time: $time"),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(onPressed: onTaken, icon: const Icon(Icons.check, color: Colors.green)),
          IconButton(onPressed: onSkipped, icon: const Icon(Icons.close, color: Colors.red)),
        ],
      ),
    );
  }
}
