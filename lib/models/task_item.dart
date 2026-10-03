enum TaskPriority { low, medium, high }

class TaskItem {
  const TaskItem({
    required this.id,
    required this.title,
    required this.note,
    required this.dueLabel,
    required this.priority,
    this.completed = false,
  });

  final String id;
  final String title;
  final String note;
  final String dueLabel;
  final TaskPriority priority;
  final bool completed;

  TaskItem copyWith({bool? completed}) {
    return TaskItem(
      id: id,
      title: title,
      note: note,
      dueLabel: dueLabel,
      priority: priority,
      completed: completed ?? this.completed,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'note': note,
        'dueLabel': dueLabel,
        'priority': priority.name,
        'completed': completed,
      };

  factory TaskItem.fromJson(Map<String, dynamic> json) {
    return TaskItem(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? 'Untitled task',
      note: json['note'] as String? ?? '',
      dueLabel: json['dueLabel'] as String? ?? 'Anytime',
      priority: TaskPriority.values.firstWhere(
        (value) => value.name == json['priority'],
        orElse: () => TaskPriority.medium,
      ),
      completed: json['completed'] as bool? ?? false,
    );
  }
}
