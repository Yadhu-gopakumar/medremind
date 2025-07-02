import 'package:hive/hive.dart';
import '../models/medicine.dart';
import '../models/history_entry.dart';
import '../models/user_settings.dart';
import '../constants/hive_keys.dart';

class HiveService {
  final medicines = Hive.box<Medicine>(medicinesBox);
  final history = Hive.box<HistoryEntry>(historyBox);
  final settings = Hive.box<UserSettings>(settingsBox);

  void addMedicine(Medicine med) => medicines.add(med);

  void markHistory(HistoryEntry entry) => history.add(entry);

  void saveUserSettings(UserSettings user) {
    settings.clear();
    settings.add(user);
  }

  UserSettings? getUser() => settings.isNotEmpty ? settings.getAt(0) : null;

  bool isTaken(String medicineName, String time, DateTime date) {
    final historyBox = Hive.box<HistoryEntry>('historyBox');
    return historyBox.values.any((entry) =>
        entry.date.year == date.year &&
        entry.date.month == date.month &&
        entry.date.day == date.day &&
        entry.medicineName == "$medicineName@$time" &&
        entry.status == 'taken');
  }
}
