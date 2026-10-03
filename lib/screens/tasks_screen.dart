import 'package:flutter/material.dart';

import '../models/task_item.dart';
import '../state/app_scope.dart';
import '../widgets/ui.dart';

enum TaskFilter { all, open, done }

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final _searchController = TextEditingController();
  TaskFilter _filter = TaskFilter.all;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_refresh);
  }

  void _refresh() => setState(() {});

  @override
  void dispose() {
    _searchController
      ..removeListener(_refresh)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final scheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: AnimatedBuilder(
        animation: state,
        builder: (context, _) {
          final query = _searchController.text.trim().toLowerCase();
          final visibleTasks = state.tasks.where((task) {
            final matchesSearch = query.isEmpty ||
                task.title.toLowerCase().contains(query) ||
                task.note.toLowerCase().contains(query);
            final matchesFilter = switch (_filter) {
              TaskFilter.all => true,
              TaskFilter.open => !task.completed,
              TaskFilter.done => task.completed,
            };
            return matchesSearch && matchesFilter;
          }).toList();

          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tasks',
                        style:
                            Theme.of(context).textTheme.displaySmall?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -1.2,
                                ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${state.openTasks} open · ${state.completedTasks} complete',
                        style: TextStyle(color: scheme.onSurfaceVariant),
                      ),
                      const SizedBox(height: 22),
                      TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search your tasks',
                          prefixIcon: const Icon(Icons.search_rounded),
                          suffixIcon: query.isEmpty
                              ? null
                              : IconButton(
                                  onPressed: _searchController.clear,
                                  icon: const Icon(Icons.close_rounded),
                                ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      SegmentedButton<TaskFilter>(
                        segments: const [
                          ButtonSegment(
                            value: TaskFilter.all,
                            label: Text('All'),
                          ),
                          ButtonSegment(
                            value: TaskFilter.open,
                            label: Text('Open'),
                          ),
                          ButtonSegment(
                            value: TaskFilter.done,
                            label: Text('Done'),
                          ),
                        ],
                        selected: {_filter},
                        showSelectedIcon: false,
                        onSelectionChanged: (selection) {
                          setState(() => _filter = selection.first);
                        },
                      ),
                      const SizedBox(height: 22),
                    ],
                  ),
                ),
              ),
              if (visibleTasks.isEmpty)
                const SliverToBoxAdapter(
                  child: EmptyState(
                    icon: Icons.inbox_rounded,
                    title: 'Nothing here',
                    message:
                        'Try another filter or add a fresh task to your day.',
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
                  sliver: SliverList.builder(
                    itemCount: visibleTasks.length,
                    itemBuilder: (context, index) {
                      final task = visibleTasks[index];
                      return Dismissible(
                        key: ValueKey(task.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 22),
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: scheme.errorContainer,
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: Icon(
                            Icons.delete_outline_rounded,
                            color: scheme.onErrorContainer,
                          ),
                        ),
                        onDismissed: (_) => state.deleteTask(task.id),
                        child: TaskTile(
                          task: task,
                          onToggle: () => state.toggleTask(task.id),
                          onMenu: () => _showTaskMenu(context, task),
                        ),
                      );
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _showTaskMenu(BuildContext context, TaskItem task) async {
    final state = AppScope.of(context);
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(
                    task.completed
                        ? Icons.radio_button_unchecked_rounded
                        : Icons.check_circle_outline_rounded,
                  ),
                  title: Text(
                    task.completed ? 'Mark as open' : 'Mark as complete',
                  ),
                  onTap: () async {
                    Navigator.pop(context);
                    await state.toggleTask(task.id);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete_outline_rounded),
                  title: const Text('Delete task'),
                  onTap: () async {
                    Navigator.pop(context);
                    await state.deleteTask(task.id);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
