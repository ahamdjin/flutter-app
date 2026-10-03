import 'package:flutter/material.dart';

import '../state/app_scope.dart';
import '../theme/app_theme.dart';
import '../widgets/task_editor_sheet.dart';
import '../widgets/ui.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String _dateLabel() {
    final now = DateTime.now();
    const weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${weekdays[now.weekday - 1]}, ${months[now.month - 1]} ${now.day}';
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);

    return SafeArea(
      child: AnimatedBuilder(
        animation: state,
        builder: (context, _) {
          final scheme = Theme.of(context).colorScheme;
          final nextTasks =
              state.tasks.where((task) => !task.completed).take(3).toList();

          return RefreshIndicator(
            onRefresh: () async {},
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 34),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _dateLabel(),
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                                  color: scheme.onSurfaceVariant,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Good day, ${state.userName}',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -0.8,
                                ),
                          ),
                        ],
                      ),
                    ),
                    IconButton.filledTonal(
                      tooltip: 'Add task',
                      onPressed: () => showTaskEditor(context),
                      icon: const Icon(Icons.add_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppTheme.brand,
                        Color.lerp(
                              AppTheme.brand,
                              AppTheme.accent,
                              0.52,
                            ) ??
                            AppTheme.brand,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.brand.withValues(alpha: 0.22),
                        blurRadius: 34,
                        offset: const Offset(0, 18),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'TODAY',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              state.openTasks == 0
                                  ? 'Everything is clear.'
                                  : '${state.openTasks} things deserve your attention.',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                    height: 1.15,
                                    letterSpacing: -0.7,
                                  ),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              '${state.completedTasks} of ${state.tasks.length} tasks complete',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 18),
                      SizedBox(
                        width: 92,
                        height: 92,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox.expand(
                              child: CircularProgressIndicator(
                                value: state.completionRate,
                                strokeWidth: 9,
                                strokeCap: StrokeCap.round,
                                color: Colors.white,
                                backgroundColor: Colors.white24,
                              ),
                            ),
                            Text(
                              '${(state.completionRate * 100).round()}%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    MetricCard(
                      icon: Icons.check_circle_outline_rounded,
                      value: '${state.completedTasks}',
                      label: 'Done',
                    ),
                    const SizedBox(width: 12),
                    MetricCard(
                      icon: Icons.timer_outlined,
                      value: '${state.focusMinutes}m',
                      label: 'Focused',
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                SectionTitle(
                  title: 'Up next',
                  action: nextTasks.isEmpty ? null : 'Add',
                  onAction: () => showTaskEditor(context),
                ),
                const SizedBox(height: 12),
                if (nextTasks.isEmpty)
                  const EmptyState(
                    icon: Icons.done_all_rounded,
                    title: 'You’re caught up',
                    message:
                        'A clear list is a feature, not a problem. Enjoy the space.',
                  )
                else
                  ...nextTasks.map(
                    (task) => TaskTile(
                      task: task,
                      onToggle: () => state.toggleTask(task.id),
                    ),
                  ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: scheme.secondaryContainer.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.lightbulb_outline_rounded,
                        color: scheme.onSecondaryContainer,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          'Small rule: finish the important thing before optimizing the system around it.',
                          style: TextStyle(
                            color: scheme.onSecondaryContainer,
                            height: 1.45,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
