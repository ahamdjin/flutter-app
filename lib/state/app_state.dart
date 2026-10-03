import 'package:flutter/foundation.dart';

import '../models/task_item.dart';
import '../services/local_store.dart';

class AppState extends ChangeNotifier {
  AppState._({
    required LocalStore store,
    required List<TaskItem> tasks,
    required bool darkMode,
    required int focusSessions,
    required int focusMinutes,
    required String userName,
  })  : _store = store,
        _tasks = tasks,
        _darkMode = darkMode,
        _focusSessions = focusSessions,
        _focusMinutes = focusMinutes,
        _userName = userName;

  final LocalStore _store;
  List<TaskItem> _tasks;
  bool _darkMode;
  int _focusSessions;
  int _focusMinutes;
  String _userName;

  List<TaskItem> get tasks => List.unmodifiable(_tasks);
  bool get darkMode => _darkMode;
  int get focusSessions => _focusSessions;
  int get focusMinutes => _focusMinutes;
  String get userName => _userName;

  int get completedTasks => _tasks.where((task) => task.completed).length;
  int get openTasks => _tasks.length - completedTasks;

  double get completionRate {
    if (_tasks.isEmpty) return 0;
    return completedTasks / _tasks.length;
  }

  static Future<AppState> load() async {
    final store = LocalStore();
    final tasks = await store.loadTasks() ?? _starterTasks;
    return AppState._(
      store: store,
      tasks: tasks,
      darkMode: await store.loadDarkMode(),
      focusSessions: await store.loadFocusSessions(),
      focusMinutes: await store.loadFocusMinutes(),
      userName: await store.loadUserName(),
    );
  }

  factory AppState.demo() {
    return AppState._(
      store: LocalStore.memory(),
      tasks: List.of(_starterTasks),
      darkMode: false,
      focusSessions: 7,
      focusMinutes: 190,
      userName: 'Alex',
    );
  }

  Future<void> addTask({
    required String title,
    required String note,
    required String dueLabel,
    required TaskPriority priority,
  }) async {
    final task = TaskItem(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title.trim(),
      note: note.trim(),
      dueLabel: dueLabel,
      priority: priority,
    );
    _tasks = [task, ..._tasks];
    notifyListeners();
    await _store.saveTasks(_tasks);
  }

  Future<void> toggleTask(String id) async {
    _tasks = _tasks
        .map(
          (task) => task.id == id
              ? task.copyWith(completed: !task.completed)
              : task,
        )
        .toList();
    notifyListeners();
    await _store.saveTasks(_tasks);
  }

  Future<void> deleteTask(String id) async {
    _tasks = _tasks.where((task) => task.id != id).toList();
    notifyListeners();
    await _store.saveTasks(_tasks);
  }

  Future<void> clearCompleted() async {
    _tasks = _tasks.where((task) => !task.completed).toList();
    notifyListeners();
    await _store.saveTasks(_tasks);
  }

  Future<void> setDarkMode(bool value) async {
    _darkMode = value;
    notifyListeners();
    await _store.saveDarkMode(value);
  }

  Future<void> setUserName(String value) async {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return;
    _userName = trimmed;
    notifyListeners();
    await _store.saveUserName(trimmed);
  }

  Future<void> completeFocusSession(int minutes) async {
    _focusSessions += 1;
    _focusMinutes += minutes;
    notifyListeners();
    await Future.wait([
      _store.saveFocusSessions(_focusSessions),
      _store.saveFocusMinutes(_focusMinutes),
    ]);
  }

  static const List<TaskItem> _starterTasks = [
    TaskItem(
      id: 'starter-1',
      title: 'Plan the day',
      note: 'Pick the three outcomes that matter most.',
      dueLabel: 'Today · 9:00 AM',
      priority: TaskPriority.high,
    ),
    TaskItem(
      id: 'starter-2',
      title: 'Deep work sprint',
      note: 'One focused block with notifications off.',
      dueLabel: 'Today · 11:30 AM',
      priority: TaskPriority.high,
    ),
    TaskItem(
      id: 'starter-3',
      title: 'Review progress',
      note: 'Close loops and move unfinished work forward.',
      dueLabel: 'Today · 5:30 PM',
      priority: TaskPriority.medium,
      completed: true,
    ),
    TaskItem(
      id: 'starter-4',
      title: 'Walk and reset',
      note: 'A short break before the evening.',
      dueLabel: 'Today · 6:30 PM',
      priority: TaskPriority.low,
    ),
  ];
}
