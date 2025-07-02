import '../models/user_settings.dart';
import 'hive_services.dart';

class AuthService {
  final HiveService _hive = HiveService();

  bool isRegistered() => _hive.getUser() != null;

  bool validatePin(String pin) {
    final user = _hive.getUser();
    return user != null && user.pin == pin;
  }




  void register(String name, String pin, String sound,String selectedQuestion, String answer) {
    _hive.saveUserSettings(UserSettings(
      username: name,
      pin: pin,
      alarmSound: sound,
      securityQuestion: selectedQuestion,
      securityAnswer: answer,
    ));
  }
}
