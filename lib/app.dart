import 'package:flutter/material.dart';

import 'screens/root_shell.dart';
import 'state/app_scope.dart';
import 'state/app_state.dart';
import 'theme/app_theme.dart';

class OrbitApp extends StatelessWidget {
  const OrbitApp({
    super.key,
    required this.state,
  });

  final AppState state;

  @override
  Widget build(BuildContext context) {
    return AppScope(
      state: state,
      child: AnimatedBuilder(
        animation: state,
        builder: (context, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Orbit',
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: state.darkMode ? ThemeMode.dark : ThemeMode.light,
            home: const RootShell(),
          );
        },
      ),
    );
  }
}
