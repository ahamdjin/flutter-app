import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/task_item.dart';

class LocalStore {
  LocalStore({SharedPreferencesAsync? preferences})
      : _preferences = preferences ?? SharedPreferencesAsync();

  LocalStore.memory() : _preferences = null;

  static const _tasksKey = 'orbit_tasks';
  static const _darkModeKey = 'orbit_dark_mode';
  static const _focusSessionsKey = 'orbit_focus_sessions';
  static const _focusMinutesKey = 'orbit_focus_minutes';
  static const _userNameKey = 'orbit_user_name';

  final SharedPreferencesAsync? _preferences;

  Future<List<TaskItem>?> loadTasks() async {
    final preferences = _preferences;
    if (preferences == null) return null;

    final raw = await preferences.getString(_tasksKey);
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

  Future<void> saveTasks(List<TaskItem> tasks) async {
    final preferences = _preferences;
    if (preferences == null) return;

    await preferences.setString(
      _tasksKey,
      jsonEncode(tasks.map((task) => task.toJson()).toList()),
    );
  }

  Future<bool> loadDarkMode() async {
    final preferences = _preferences;
    if (preferences == null) return false;
    return await preferences.getBool(_darkModeKey) ?? false;
  }

  Future<void> saveDarkMode(bool value) async {
    await _preferences?.setBool(_darkModeKey, value);
  }

  Future<int> loadFocusSessions() async {
    final preferences = _preferences;
    if (preferences == null) return 0;
    return await preferences.getInt(_focusSessionsKey) ?? 0;
  }

  Future<void> saveFocusSessions(int value) async {
    await _preferences?.setInt(_focusSessionsKey, value);
  }

  Future<int> loadFocusMinutes() async {
    final preferences = _preferences;
    if (preferences == null) return 0;
    return await preferences.getInt(_focusMinutesKey) ?? 0;
  }

  Future<void> saveFocusMinutes(int value) async {
    await _preferences?.setInt(_focusMinutesKey, value);
  }

  Future<String> loadUserName() async {
    final preferences = _preferences;
    if (preferences == null) return 'Alex';
    return await preferences.getString(_userNameKey) ?? 'Alex';
  }

  Future<void> saveUserName(String value) async {
    await _preferences?.setString(_userNameKey, value);
  }
}
