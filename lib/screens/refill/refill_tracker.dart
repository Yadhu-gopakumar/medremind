
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:medremind/screens/medicine/edit_medicine_screen.dart';
import '../../constants/hive_keys.dart';
import '../../models/medicine.dart';

class RefillTrackerPage extends StatelessWidget {
  const RefillTrackerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Color backgroundGreen = const Color(0xFF166D5B);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Refill Tracker",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Colors.green[700],
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ValueListenableBuilder(
          valueListenable: Hive.box<Medicine>(medicinesBox).listenable(),
          builder: (context, Box<Medicine> box, _) {
            if (box.isEmpty) {
              return const Center(child: Text("No medicines found."));
            }

            final medicines = box.values.toList();

            return ListView.separated(
              itemCount: medicines.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final med = medicines[index];
                final lowStock = med.quantityLeft <= med.refillThreshold;

                return Card(
                  color: Colors.teal[900],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: const Icon(Icons.medication,
                                color: Color(0xFF166D5B)),
                          ),
                          title: Text(
                            med.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${med.quantityLeft} of ${med.totalQuantity} left",
                                style: const TextStyle(color: Colors.white70),
                              ),
                              const SizedBox(height: 4),
                              LinearProgressIndicator(
                                value: med.quantityLeft / med.totalQuantity,
                                backgroundColor: Colors.white24,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  lowStock ? Colors.red : Colors.greenAccent,
                                ),
                              ),
                            ],
                          ),
                          trailing: _statusChip(
                            lowStock ? "Refill Soon" : "Sufficient",
                            lowStock ? Colors.red[400]! : Colors.green[100]!,
                            textColor:
                                lowStock ? Colors.white : Colors.green[800]!,
                          ),
                        ),
                        Row(
  mainAxisAlignment: MainAxisAlignment.end,
  children: [
    TextButton.icon(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => EditMedicinePage(
              medicine: med,
              medicineKey: med.key,
            ),
          ),
        );
      },
      icon: const Icon(Icons.edit, color: Colors.white),
      label: const Text("Edit", style: TextStyle(color: Colors.white)),
    ),
    const SizedBox(width: 8),
    TextButton.icon(
      onPressed: () {
        _showDeleteDialog(context, box, med.key);
      },
      icon: const Icon(Icons.delete, color: Colors.red),
      label: const Text("Delete", style: TextStyle(color: Colors.red)),
    ),
  ],
),

                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _statusChip(String text, Color color, {Color textColor = Colors.white}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, Box<Medicine> box, dynamic key) {
    final medicine = box.get(key);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Medicine"),
        content: Text("Are you sure you want to delete \"${medicine?.name}\"?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              box.delete(key);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("${medicine?.name} deleted.")),
              );
            },
            child: const Text(
              "Delete",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
