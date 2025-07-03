import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../constants/hive_keys.dart';
import '../../models/medicine.dart';
import '../../models/history_entry.dart';
import '../../screens/calender/calender_screen.dart';
import '../../screens/history/history_screen.dart';
import '../../screens/medicine/add_medicine_screen.dart';
import '../../screens/profile/profilepage.dart';
import '../../screens/refill/refill_tracker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DateTime today = DateTime.now();
  @override
  void initState() {
    super.initState();

    final history = Hive.box<HistoryEntry>(historyBox);
    final medicines = Hive.box<Medicine>(medicinesBox);

    final now = DateTime.now();
    final todayKey = "${now.year}-${now.month}-${now.day}";

    // Fill missed entries for today if not already taken
    for (var med in medicines.values) {
      for (var time in med.dailyIntakeTimes) {
        final doseKey = "${med.name}@$time@$todayKey";
        if (!history.containsKey(doseKey)) {
          history.put(
            doseKey,
            HistoryEntry(
              date: now,
              medicineName: "${med.name}@$time",
              status: 'missed', // default as missed if not taken
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color backgroundGreen = Color(0xFF166D5B);

    return Scaffold(
      appBar: AppBar(
        title: const Text('MedRemind',
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0, top: 5, bottom: 5),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.green[300],
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(3),
              // margin: const EdgeInsets.only(right: 12, top: 7, bottom: 7),
              child: IconButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => Profilepg()),
                ),
                icon: const Icon(Icons.person_3_outlined,
                    color: Colors.white, size: 28),
              ),
            ),
          )
        ],
        backgroundColor: Colors.green[800],
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Medicine>(medicinesBox).listenable(),
        builder: (context, Box<Medicine> medicineBox, _) {
          return ValueListenableBuilder(
            valueListenable: Hive.box<HistoryEntry>(historyBox).listenable(),
            builder: (context, Box<HistoryEntry> historyBox, _) {
              final DateTime now = DateTime.now();

              final todayMeds = medicineBox.values.expand((med) {
                return med.dailyIntakeTimes
                    .where((time) => med.expiryDate.isAfter(now))
                    .map((time) => MapEntry(med, time));
              }).toList();

              final takenCount = historyBox.values
                  .where((e) =>
                      e.date.year == now.year &&
                      e.date.month == now.month &&
                      e.date.day == now.day &&
                      e.status == 'taken')
                  .length;

              final double progress =
                  todayMeds.isEmpty ? 0.0 : takenCount / todayMeds.length;

              return ListView(
                children: [
                  _buildProgressBar(progress, takenCount, todayMeds.length),
                  _buildQuickActions(context, backgroundGreen),
                  const Padding(
                    padding: EdgeInsets.only(left: 20.0, bottom: 3, top: 18),
                    child: Text("Today's Schedule",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 10),
                  ...todayMeds.map((entry) {
                    final med = entry.key;
                    final time = entry.value;
                    final doseKey =
                        "${med.name}@$time@${now.year}-${now.month}-${now.day}";
                    final isTaken = historyBox.get(doseKey)?.status == 'taken';

                    return _scheduleTile(
                      context,
                      medicine: med.name,
                      dose: formatTime(time),
                      taken: isTaken,
                      backgroundGreen: backgroundGreen,
                      onTap: () async {
                        historyBox.put(
                          doseKey,
                          HistoryEntry(
                            date: now,
                            medicineName: "${med.name}@$time",
                            status: 'taken',
                          ),
                        );
                        // Decrease quantityLeft and save it
                        final key = med.key;
                        if (key != null) {
                          med.quantityLeft =
                              (med.quantityLeft > 0) ? med.quantityLeft - 1 : 0;
                          await med
                              .save(); // This triggers ValueListenableBuilder refresh
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Marked as taken!')),
                        );
                      },
                    );
                  }).toList(),
                  const SizedBox(height: 20),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildProgressBar(double progress, int taken, int total) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade800, Colors.green.shade400],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            offset: Offset(0, 6), // x=0, y=6 (bottom shadow)
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Center(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 140,
                  height: 140,
                  //   child: CircularProgressIndicator(
                  //     value: progress,
                  //     strokeWidth: 12,
                  //     backgroundColor: Colors.white24,
                  //     valueColor:
                  //          AlwaysStoppedAnimation<Color>(Colors.yellow),
                  //   ),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green[800],
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 12,
                      backgroundColor: Colors.white24,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                ),
                Text("${(progress * 100).toInt()}%",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold)),
                Positioned(
                  bottom: 30,
                  child: Text("$taken of $total doses",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 15),
            const Padding(
              padding: EdgeInsets.only(top: 10.0, bottom: 10),
              child: Text("Today's Progress",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.1)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, Color backgroundGreen) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 14),
          const Text("Quick Actions",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 13),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _quickActionCard(
                context: context,
                color: Colors.green,
                icon: Icons.add_alert,
                label: "Add Medicine",
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => AddMedicinePage())),
              ),
              _quickActionCard(
                context: context,
                color: Colors.orange,
                icon: Icons.calendar_month_outlined,
                label: "Calendar View",
                onTap: () => Navigator.push(
                    context, MaterialPageRoute(builder: (_) => Calenderpg())),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _quickActionCard(
                context: context,
                color: Colors.red,
                icon: Icons.av_timer_outlined,
                label: "History Log",
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => HistoryLogPage())),
              ),
              _quickActionCard(
                context: context,
                color: Colors.indigo,
                icon: Icons.recycling_rounded,
                label: "Refill Tracker",
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => RefillTrackerPage())),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _quickActionCard({
    required BuildContext context,
    required Color color,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Card(
        elevation: 5,
        color: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.35,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 33, color: Colors.white),
                const SizedBox(height: 8),
                Text(label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, color: Colors.white)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _scheduleTile(
    BuildContext context, {
    required String medicine,
    required String dose,
    required bool taken,
    required VoidCallback onTap,
    required Color backgroundGreen,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.medical_services, color: backgroundGreen),
        title: Text(medicine,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        subtitle:
            Text(dose, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
        trailing: ElevatedButton(
          onPressed: taken ? null : onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: taken ? backgroundGreen : Colors.yellow[700],
            foregroundColor: taken ? Colors.white : Colors.black,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          child: Text(taken ? "Taken" : "Take"),
        ),
      ),
    );
  }
}

// Time formatter
String formatTime(String time24h) {
  try {
    final parts = time24h.split(":");
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    final time = TimeOfDay(hour: hour, minute: minute);
    return time
        .format(navigatorKey.currentContext ?? BuildContextPlaceholder());
  } catch (e) {
    return time24h;
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class BuildContextPlaceholder extends BuildContext {
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
