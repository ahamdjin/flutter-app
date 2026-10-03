import 'package:flutter/material.dart';

import '../models/task_item.dart';
import '../state/app_scope.dart';

Future<void> showTaskEditor(BuildContext context) async {
  final titleController = TextEditingController();
  final noteController = TextEditingController();
  var priority = TaskPriority.medium;
  var dueLabel = 'Today · Flexible';

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (sheetContext) {
      return StatefulBuilder(
        builder: (context, setSheetState) {
          final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
          return Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, bottomInset + 24),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'New task',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.6,
                        ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: titleController,
                    autofocus: true,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'What needs to happen?',
                      prefixIcon: Icon(Icons.check_circle_outline_rounded),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: noteController,
                    minLines: 2,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Notes (optional)',
                      prefixIcon: Icon(Icons.notes_rounded),
                      alignLabelWithHint: true,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Priority',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: TaskPriority.values.map((value) {
                      return ChoiceChip(
                        selected: priority == value,
                        label: Text(
                          value.name[0].toUpperCase() + value.name.substring(1),
                        ),
                        onSelected: (_) =>
                            setSheetState(() => priority = value),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: dueLabel,
                    decoration: const InputDecoration(
                      labelText: 'When',
                      prefixIcon: Icon(Icons.schedule_rounded),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'Today · Flexible',
                        child: Text('Today · Flexible'),
                      ),
                      DropdownMenuItem(
                        value: 'Today · Morning',
                        child: Text('Today · Morning'),
                      ),
                      DropdownMenuItem(
                        value: 'Today · Afternoon',
                        child: Text('Today · Afternoon'),
                      ),
                      DropdownMenuItem(
                        value: 'Tomorrow',
                        child: Text('Tomorrow'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setSheetState(() => dueLabel = value);
                      }
                    },
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: () async {
                      final title = titleController.text.trim();
                      if (title.isEmpty) return;
                      final state = AppScope.of(sheetContext);
                      await state.addTask(
                        title: title,
                        note: noteController.text,
                        dueLabel: dueLabel,
                        priority: priority,
                      );
                      if (sheetContext.mounted) {
                        Navigator.of(sheetContext).pop();
                      }
                    },
                    icon: const Icon(Icons.add_rounded),
                    label: const Text('Add task'),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );

  titleController.dispose();
  noteController.dispose();
}
