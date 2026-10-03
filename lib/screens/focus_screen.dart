import 'dart:async';

import 'package:flutter/material.dart';

import '../state/app_scope.dart';
import '../theme/app_theme.dart';
import '../widgets/ui.dart';

class FocusScreen extends StatefulWidget {
  const FocusScreen({super.key});

  @override
  State<FocusScreen> createState() => _FocusScreenState();
}

class _FocusScreenState extends State<FocusScreen> {
  Timer? _timer;
  int _selectedMinutes = 25;
  int _remainingSeconds = 25 * 60;
  bool _running = false;

  int get _totalSeconds => _selectedMinutes * 60;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _toggleTimer() {
    if (_running) {
      _timer?.cancel();
      setState(() => _running = false);
      return;
    }

    setState(() => _running = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (!mounted) return;
      if (_remainingSeconds <= 1) {
        timer.cancel();
        setState(() {
          _remainingSeconds = 0;
          _running = false;
        });
        await AppScope.of(context).completeFocusSession(_selectedMinutes);
        if (mounted) {
          _showCompletion();
        }
      } else {
        setState(() => _remainingSeconds -= 1);
      }
    });
  }

  void _reset() {
    _timer?.cancel();
    setState(() {
      _running = false;
      _remainingSeconds = _totalSeconds;
    });
  }

  void _selectMinutes(int minutes) {
    _timer?.cancel();
    setState(() {
      _selectedMinutes = minutes;
      _remainingSeconds = minutes * 60;
      _running = false;
    });
  }

  void _showCompletion() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.auto_awesome_rounded, size: 54),
              const SizedBox(height: 16),
              Text(
                'Focus block complete',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                '${_selectedMinutes} minutes of intentional work. Nice.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 22),
              FilledButton(
                onPressed: () {
                  Navigator.pop(context);
                  _reset();
                },
                child: const Text('Done'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final scheme = Theme.of(context).colorScheme;
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;
    final progress =
        _totalSeconds == 0 ? 0.0 : 1 - (_remainingSeconds / _totalSeconds);

    return SafeArea(
      child: AnimatedBuilder(
        animation: state,
        builder: (context, _) {
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 34),
            children: [
              Text(
                'Focus',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1.2,
                    ),
              ),
              const SizedBox(height: 6),
              Text(
                'Make room for one thing at a time.',
                style: TextStyle(color: scheme.onSurfaceVariant),
              ),
              const SizedBox(height: 34),
              Center(
                child: SizedBox(
                  width: 260,
                  height: 260,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox.expand(
                        child: CircularProgressIndicator(
                          value: progress,
                          strokeWidth: 12,
                          strokeCap: StrokeCap.round,
                          backgroundColor:
                              scheme.primaryContainer.withValues(alpha: 0.55),
                          valueColor:
                              const AlwaysStoppedAnimation(AppTheme.brand),
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -2,
                                ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _running ? 'In focus' : 'Ready when you are',
                            style: TextStyle(
                              color: scheme.onSurfaceVariant,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [25, 45, 60].map((value) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      selected: _selectedMinutes == value,
                      label: Text('${value} min'),
                      onSelected:
                          _running ? null : (_) => _selectMinutes(value),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed:
                          _remainingSeconds == 0 ? _reset : _toggleTimer,
                      icon: Icon(
                        _running ? Icons.pause_rounded : Icons.play_arrow_rounded,
                      ),
                      label: Text(
                        _remainingSeconds == 0
                            ? 'Restart'
                            : _running
                                ? 'Pause'
                                : 'Start focus',
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton.filledTonal(
                    tooltip: 'Reset timer',
                    onPressed: _reset,
                    icon: const Icon(Icons.refresh_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 34),
              const SectionTitle(title: 'Your momentum'),
              const SizedBox(height: 12),
              Row(
                children: [
                  MetricCard(
                    icon: Icons.bolt_rounded,
                    value: '${state.focusSessions}',
                    label: 'Sessions',
                  ),
                  const SizedBox(width: 12),
                  MetricCard(
                    icon: Icons.schedule_rounded,
                    value: '${state.focusMinutes}m',
                    label: 'Focused',
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
