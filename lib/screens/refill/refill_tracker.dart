import 'package:flutter/material.dart';
import 'package:medremind/screens/medicine/edit_medicine_screen.dart';

class RefillTrackerPage extends StatelessWidget {
  const RefillTrackerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Color backgroundGreen = const Color(0xFF166D5B);

    // Example dummy data
    final List<Map<String, dynamic>> medicines = [
      {
        "name": "Paracetamol",
        "icon": Icons.medication_liquid_rounded,
        "remaining": 4,
        "total": 30,
        "unit": "tablets",
        "low": true,
      },
      {
        "name": "Vitamin D",
        "icon": Icons.local_hospital,
        "remaining": 10,
        "total": 60,
        "unit": "capsules",
        "low": false,
      },
      {
        "name": "Aspirin",
        "icon": Icons.medical_services,
        "remaining": 2,
        "total": 20,
        "unit": "tablets",
        "low": true,
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text(
          "Refill Tracker",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.green[700],
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Text(
              "Medicine Stock",
              style: TextStyle(
                color: Color(0xFF166D5B),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 18),
            Expanded(
              child: ListView.separated(
                itemCount: medicines.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final med = medicines[index];
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
                              child: Icon(
                                med["icon"],
                                color: backgroundGreen,
                              ),
                            ),
                            title: Text(
                              med["name"],
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${med["remaining"]} of ${med["total"]} ${med["unit"]} left",
                                  style: const TextStyle(color: Colors.white70),
                                ),
                                const SizedBox(height: 4),
                                LinearProgressIndicator(
                                  value: med["remaining"] / med["total"],
                                  backgroundColor: Colors.white24,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    med["low"]
                                        ? Colors.red
                                        : Colors.greenAccent,
                                  ),
                                ),
                              ],
                            ),
                            trailing: med["low"]
                                ? _statusChip("Refill Soon", Colors.red[400]!)
                                : _statusChip("Sufficient", Colors.green[100]!,
                                    textColor: Colors.green),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => EditMedicinePage()),
                                  );
                                },
                                icon:
                                    const Icon(Icons.edit, color: Colors.white),
                                label: const Text("Edit",
                                    style: TextStyle(color: Colors.white)),
                              ),
                              const SizedBox(width: 8),
                              TextButton.icon(
                                onPressed: () {
                                  _showDeleteDialog(context, med["name"]);
                                },
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                label: const Text(
                                  "Delete",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
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

// Confirmation dialog for delete
void _showDeleteDialog(BuildContext context, String medicineName) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Delete Medicine"),
      content: Text("Are you sure you want to delete \"$medicineName\"?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            // TODO: Implement delete logic with Hive or backend
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("$medicineName deleted.")),
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
