import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:medremind/screens/calender/calender_screen.dart';
import 'package:medremind/screens/history/history_screen.dart';
import 'package:medremind/screens/medicine/add_medicine_screen.dart';
import 'package:medremind/screens/profile/profilepage.dart';
import 'package:medremind/screens/refill/refill_tracker.dart';

import '../../constants/hive_keys.dart';
import '../../models/medicine.dart';
import '../../models/history_entry.dart';
import '../../services/hive_services.dart';
import '../../utils/date_utils.dart';

// final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();

// void requestNotificationPermission() async {
//   final androidImpl = await notificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
//   if (androidImpl != null) {
//     final granted = await androidImpl.requestNotificationsPermission();
//     debugPrint("Notification permission granted: $granted");
//   }
// }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HiveService hive = HiveService();
  final today = DateTime.now();
  List<MapEntry<Medicine, String>> todayMeds = [];
  int takenCount = 0;

  @override
  void initState() {
    super.initState();
    // requestNotificationPermission();
    loadTodayMedicines();
  }

  void loadTodayMedicines() {
    todayMeds.clear();
    final box = Hive.box<Medicine>(medicinesBox);

    for (var med in box.values) {
      for (var time in med.dailyIntakeTimes) {
        if (med.expiryDate.isAfter(today)) {
          todayMeds.add(MapEntry(med, time));
        }
      }
    }

    final history = Hive.box<HistoryEntry>(historyBox);
    takenCount = history.values
        .where((e) =>
            e.date.year == today.year &&
            e.date.month == today.month &&
            e.date.day == today.day &&
            e.status == 'taken')
        .length;

    setState(() {});
  }

  void _markAs(String status, Medicine med, String time) {
    hive.markHistory(HistoryEntry(
      date: today,
      medicineName: "${med.name}@$time",
      status: status,
    ));
    loadTodayMedicines();
  }

  @override
  Widget build(BuildContext context) {
    final Color backgroundGreen = const Color(0xFF166D5B);

    return Scaffold(
      appBar: AppBar(
        title: const Text('MedRemind',
            style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2)),
        actions: [
          Container(
            decoration: BoxDecoration(
                color: Colors.green[300],
                borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.all(3),
            margin: const EdgeInsets.only(right: 10, top: 5, bottom: 5),
            child: IconButton(
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (_) => Profilepg())),
              icon: const Icon(Icons.person_3_outlined,
                  color: Colors.white, size: 28),
            ),
          )
        ],
        backgroundColor: Colors.green[800],
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: ValueListenableBuilder(
          valueListenable:
              Hive.box<Medicine>(medicinesBox).listenable(), // ✅ CORRECT
          // valueListenable: Hive.box<HistoryEntry>(historyBox).listenable(),

          // valueListenable: Hive.box<HistoryEntry>(historyBox).listenable(),

          builder: (context, Box<Medicine> box, _) {
            final List<MapEntry<Medicine, String>> updatedTodayMeds = [];
            final DateTime now = DateTime.now();

            for (var med in box.values) {
              for (var time in med.dailyIntakeTimes) {
                if (med.expiryDate.isAfter(now)) {
                  updatedTodayMeds.add(MapEntry(med, time));
                }
              }
            }

            // final localHistoryBox = Hive.box<HistoryEntry>(historyBox);
            final Box<HistoryEntry> localHistoryBox =
                Hive.box<HistoryEntry>(historyBox);
            final takenCount = localHistoryBox.values
                .where((e) =>
                    e.date.year == now.year &&
                    e.date.month == now.month &&
                    e.date.day == now.day &&
                    e.status == 'taken')
                .length;

            final double progress = updatedTodayMeds.isEmpty
                ? 0.0
                : takenCount / updatedTodayMeds.length;

            return ValueListenableBuilder(
              valueListenable: Hive.box<HistoryEntry>(historyBox).listenable(),
              builder: (context, Box<HistoryEntry> historyBox, _) {
                return ListView(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(top: 20, bottom: 10),
                      decoration: BoxDecoration(
                        color: Colors.green[800],
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
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
                                  child: CircularProgressIndicator(
                                    value: progress,
                                    strokeWidth: 10,
                                    backgroundColor: Colors.white24,
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                            Colors.white),
                                  ),
                                ),
                                Text("${(progress * 100).toInt()}%",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold)),
                                Positioned(
                                  bottom: 30,
                                  child: Text(
                                      "$takenCount of ${updatedTodayMeds.length} doses",
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            const Text("Today's Progress",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 1.1)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildQuickActions(context, const Color(0xFF166D5B)),
                    const Padding(
                      padding: EdgeInsets.only(left: 20.0, bottom: 4),
                      child: Text("Today's Schedule",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 10),
                    ...updatedTodayMeds.map((entry) {
                      final med = entry.key;
                      final time = entry.value;
                      return _scheduleTile(
                        context,
                        medicine: med.name,
                        dose: formatTime(time),
                        taken: hive.isTaken(med.name, time, now),
                        backgroundGreen: const Color(0xFF166D5B),
                        // onTap: () {
                        //   hive.markHistory(HistoryEntry(
                        //     date: now,
                        //     medicineName: "${med.name}@$time",
                        //     status: 'taken',
                        //   ));
                        // },
                        onTap: () {
                          hive.markHistory(HistoryEntry(
                            date: now,
                            medicineName: "${med.name}@$time",
                            status: 'taken',
                          ));
                        },
                      );
                    }).toList(),
                    const SizedBox(height: 20),
                  ],
                );
              },
            );
          }),
    );
  }
// @override
// Widget build(BuildContext context) {
//   final Color backgroundGreen = const Color(0xFF166D5B);

//   return Scaffold(
//     appBar: AppBar(
//       title: const Text('MedRemind',
//           style: TextStyle(
//               color: Colors.white,
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               letterSpacing: 1.2)),
//       actions: [
//         Container(
//           decoration: BoxDecoration(
//               color: Colors.green[300],
//               borderRadius: BorderRadius.circular(10)),
//           padding: const EdgeInsets.all(3),
//           margin: const EdgeInsets.only(right: 10, top: 5, bottom: 5),
//           child: IconButton(
//             onPressed: () => Navigator.push(
//                 context, MaterialPageRoute(builder: (_) => Profilepg())),
//             icon: const Icon(Icons.person_3_outlined,
//                 color: Colors.white, size: 28),
//           ),
//         )
//       ],
//       backgroundColor: Colors.green[800],
//       elevation: 0,
//     ),
//     backgroundColor: Colors.white,
//     body: ValueListenableBuilder(
//       valueListenable: Hive.box<Medicine>(medicinesBox).listenable(),
//       builder: (context, Box<Medicine> medBox, _) {
//         return ValueListenableBuilder(
//           valueListenable: Hive.box<HistoryEntry>(historyBox).listenable(),
//           builder: (context, Box<HistoryEntry> historyBox, _) {
//             final List<MapEntry<Medicine, String>> updatedTodayMeds = [];
//             final DateTime now = DateTime.now();

//             for (var med in medBox.values) {
//               for (var time in med.dailyIntakeTimes) {
//                 if (med.expiryDate.isAfter(now)) {
//                   updatedTodayMeds.add(MapEntry(med, time));
//                 }
//               }
//             }

//             final takenCount = historyBox.values
//                 .where((e) =>
//                     e.date.year == now.year &&
//                     e.date.month == now.month &&
//                     e.date.day == now.day &&
//                     e.status == 'taken')
//                 .length;

//             final double progress = updatedTodayMeds.isEmpty
//                 ? 0.0
//                 : takenCount / updatedTodayMeds.length;

//             return ListView(
//               children: [
//                 Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.only(top: 20, bottom: 10),
//                   decoration: BoxDecoration(
//                     color: Colors.green[800],
//                     borderRadius: const BorderRadius.only(
//                       bottomLeft: Radius.circular(30),
//                       bottomRight: Radius.circular(30),
//                     ),
//                   ),
//                   child: Center(
//                     child: Column(
//                       children: [
//                         Stack(
//                           alignment: Alignment.center,
//                           children: [
//                             SizedBox(
//                               width: 140,
//                               height: 140,
//                               child: CircularProgressIndicator(
//                                 value: progress,
//                                 strokeWidth: 10,
//                                 backgroundColor: Colors.white24,
//                                 valueColor:
//                                     const AlwaysStoppedAnimation<Color>(
//                                         Colors.white),
//                               ),
//                             ),
//                             Text("${(progress * 100).toInt()}%",
//                                 style: const TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 28,
//                                     fontWeight: FontWeight.bold)),
//                             Positioned(
//                               bottom: 30,
//                               child: Text(
//                                   "$takenCount of ${updatedTodayMeds.length} doses",
//                                   style: const TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 13,
//                                       fontWeight: FontWeight.bold)),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 20),
//                         const Text("Today's Progress",
//                             style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.w500,
//                                 letterSpacing: 1.1)),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 _buildQuickActions(context, backgroundGreen),
//                 const Padding(
//                   padding: EdgeInsets.only(left: 20.0, bottom: 4),
//                   child: Text("Today's Schedule",
//                       style:
//                           TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                 ),
//                 const SizedBox(height: 10),
//                 ...updatedTodayMeds.map((entry) {
//                   final med = entry.key;
//                   final time = entry.value;
//                   final isTaken = historyBox.values.any((e) =>
//                       e.medicineName == "${med.name}@$time" &&
//                       e.date.year == now.year &&
//                       e.date.month == now.month &&
//                       e.date.day == now.day &&
//                       e.status == 'taken');
//                   return _scheduleTile(
//                     context,
//                     medicine: med.name,
//                     dose: formatTime(time),
//                     taken: isTaken,
//                     backgroundGreen: backgroundGreen,
//                     onTap: () {
//                       hive.markHistory(HistoryEntry(
//                         date: now,
//                         medicineName: "${med.name}@$time",
//                         status: 'taken',
//                       ));
//                     },
//                   );
//                 }).toList(),
//                 const SizedBox(height: 20),
//               ],
//             );
//           },
//         );
//       },
//     ),
//   );
// }

  Widget _buildQuickActions(BuildContext context, Color backgroundGreen) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Quick Actions",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _quickActionCard(
                  context: context,
                  color: Colors.green,
                  icon: Icons.add_alert,
                  label: "Add Medicine",
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => AddMedicinePage()))),
              _quickActionCard(
                  context: context,
                  color: Colors.orange,
                  icon: Icons.calendar_month_outlined,
                  label: "Calendar View",
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => Calenderpg()))),
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
                      MaterialPageRoute(builder: (_) => HistoryLogPage()))),
              _quickActionCard(
                  context: context,
                  color: Colors.indigo,
                  icon: Icons.recycling_rounded,
                  label: "Refill Tracker",
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => RefillTrackerPage()))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _quickActionCard(
      {required Color color,
      required IconData icon,
      required String label,
      required VoidCallback onTap,
      required BuildContext context}) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Card(
        color: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.33,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 40, color: Colors.white),
                const SizedBox(height: 8),
                Text(label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14, color: Colors.white)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget _scheduleTile(BuildContext context,
  //     {required String medicine,
  //     required String dose,
  //     required bool taken,
  //     required VoidCallback onTap,
  //     required Color backgroundGreen}) {
  //   return Card(
  //     child: ListTile(
  //       leading: Icon(Icons.medical_services, color: backgroundGreen),
  //       title: Text(medicine,
  //           style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
  //       subtitle:
  //           Text(dose, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
  //       trailing: ElevatedButton(
  //         onPressed: taken ? null : onTap, // 👈 Now updates Hive and refreshes
  //         style: ElevatedButton.styleFrom(
  //           backgroundColor: taken ? backgroundGreen : Colors.yellow[700],
  //           foregroundColor: taken ? Colors.white : Colors.black,
  //           shape:
  //               RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  //         ),
  //         child: Text(taken ? "Taken" : "Take"),
  //       ),
  //     ),
  //   );
  // }
  Widget _scheduleTile(
  BuildContext context, {
  required String medicine,
  required String dose,
  required bool taken,
  required VoidCallback onTap,
  required Color backgroundGreen,
}) {
  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    child: ListTile(
      leading: Icon(Icons.medical_services, color: backgroundGreen),
      title: Text(
        medicine,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        dose,
        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
      ),
      trailing: taken
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, color: backgroundGreen, size: 22),
                const SizedBox(width: 6),
                ElevatedButton(
                  onPressed: null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: backgroundGreen,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text("Taken"),
                ),
              ],
            )
          : ElevatedButton(
              onPressed: () {
                onTap();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Marked as taken!"),
                    duration: const Duration(milliseconds: 900),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow[700],
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text("Take"),
            ),
    ),
  );
}

}
