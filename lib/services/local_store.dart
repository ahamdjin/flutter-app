import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/task_item.dart';

class LocalStore {
  LocalStore({SharedPreferencesAsync? preferences})
      : _preferences = preferences ?? SharedPreferencesAsync();

  static const _tasksKey = 'orbit_tasks';
  static const _darkModeKey = 'orbit_dark_mode';
  static const _focusSessionsKey = 'orbit_focus_sessions';
  static const _focusMinutesKey = 'orbit_focus_minutes';
  static const _userNameKey = 'orbit_user_name';

  final SharedPreferencesAsync _preferences;

  Future<List<TaskItem>?> loadTasks() async {
    final raw = await _preferences.getString(_tasksKey);
    if (raw == null || raw.isEmpty) return null;

    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map(
          (item) => TaskItem.fromJson(
            Map<String, dynamic>.from(item as Map),
          ),
        )
        .toList();
  }

  Future<void> saveTasks(List<TaskItem> tasks) {
    return _preferences.setString(
      _tasksKey,
      jsonEncode(tasks.map((task) => task.toJson()).toList()),
    );
  }

  Future<bool> loadDarkMode() async =>
      await _preferences.getBool(_darkModeKey) ?? false;

  Future<void> saveDarkMode(bool value) =>
      _preferences.setBool(_darkModeKey, value);

  Future<int> loadFocusSessions() async =>
      await _preferences.getInt(_focusSessionsKey) ?? 0;

  Future<void> saveFocusSessions(int value) =>
      _preferences.setInt(_focusSessionsKey, value);

  Future<int> loadFocusMinutes() async =>
      await _preferences.getInt(_focusMinutesKey) ?? 0;

  Future<void> saveFocusMinutes(int value) =>
      _preferences.setInt(_focusMinutesKey, value);

  Future<String> loadUserName() async =>
      await _preferences.getString(_userNameKey) ?? 'Alex';

  Future<void> saveUserName(String value) =>
      _preferences.setString(_userNameKey, value);
}
