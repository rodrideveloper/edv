import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static final instance = UserPreferences._();
  UserPreferences._();

  late SharedPreferences _prefs;

  initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  int getLessons(String id) => _prefs.getInt('lessons_$id') ?? 0;

  void setLessons(String id, int value) {
    int lessons = getLessons(id);
    lessons = lessons + value;

    _prefs.setInt('lessons_$id', lessons);
  }
}
