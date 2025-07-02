import 'package:flutter/material.dart';

class HistoryLogPage extends StatefulWidget {
  const HistoryLogPage({super.key});

  @override
  State<HistoryLogPage> createState() => _HistoryLogPageState();
}

class _HistoryLogPageState extends State<HistoryLogPage> {
  String selectedFilter = 'All';

  // Dummy data format: date -> list of [medicine, taken]
  final Map<String, List<Map<String, dynamic>>> historyData = {
    '2025-07-01': [
      {'name': 'Paracetamol', 'taken': true},
      {'name': 'Vitamin C', 'taken': false},
    ],
    '2025-07-02': [
      {'name': 'Ibuprofen', 'taken': true},
    ],
    '2025-07-03': [
      {'name': 'B Complex', 'taken': false},
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text('History Log',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.green[700],
      ),
      body: Column(
        children: [
          // Filter Buttons
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: ['All', 'Taken', 'Missed'].map((filter) {
                final bool isSelected = selectedFilter == filter;
                return ElevatedButton(
                  onPressed: () {
                    setState(() => selectedFilter = filter);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isSelected ? Colors.green[700] : Colors.grey[300],
                    foregroundColor: isSelected ? Colors.white : Colors.black,
                  ),
                  child: Text(filter),
                );
              }).toList(),
            ),
          ),
          // History List
          Expanded(
            child: ListView(
              children: historyData.entries.map((entry) {
                final date = entry.key;
                final filteredMeds = entry.value.where((med) {
                  if (selectedFilter == 'All') return true;
                  if (selectedFilter == 'Taken') return med['taken'] == true;
                  if (selectedFilter == 'Missed') return med['taken'] == false;
                  return false;
                }).toList();

                if (filteredMeds.isEmpty)
                  return SizedBox(); // Skip if no matches

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(date,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          const Divider(),
                          ...filteredMeds.map((med) => ListTile(
                                leading: Icon(Icons.medication,
                                    color: med['taken']
                                        ? Colors.green
                                        : Colors.red),
                                title: Text(med['name']),
                                trailing: Text(
                                    med['taken'] ? 'Taken' : 'Missed',
                                    style: TextStyle(
                                        color: med['taken']
                                            ? Colors.green
                                            : Colors.red)),
                              )),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
