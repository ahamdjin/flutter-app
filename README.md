# Orbit

Orbit is a polished, local-first productivity app built with Flutter for **iOS and Android**.

## What works

- Premium Material 3 light/dark UI
- Today dashboard with live completion progress
- Add, complete, search, filter, and delete tasks
- Persistent tasks and preferences using `shared_preferences`
- Focus timer with 25/45/60 minute presets
- Persistent focus-session and focus-minute stats
- Editable local profile name
- Bottom navigation designed for mobile
- Widget tests and GitHub Actions quality checks

## Run the app

Install a current Flutter stable SDK, clone the repository, then run:

```bash
chmod +x tool/bootstrap.sh
./tool/bootstrap.sh
flutter run
```

The bootstrap command generates the native Android and iOS project folders with the Flutter SDK installed on your machine and then gets dependencies.

Equivalent manual commands:

```bash
flutter create --platforms=android,ios --project-name=flutter_app --org=com.example .
flutter pub get
flutter run
```

## Quality checks

```bash
flutter analyze
flutter test
```

GitHub Actions runs both checks automatically on pushes and pull requests to `main`.

## Project structure

```text
lib/
├── app.dart
├── main.dart
├── models/
│   └── task_item.dart
├── screens/
│   ├── focus_screen.dart
│   ├── home_screen.dart
│   ├── profile_screen.dart
│   ├── root_shell.dart
│   └── tasks_screen.dart
├── services/
│   └── local_store.dart
├── state/
│   ├── app_scope.dart
│   └── app_state.dart
├── theme/
│   └── app_theme.dart
└── widgets/
    ├── task_editor_sheet.dart
    └── ui.dart
```

## Platform note

iOS builds require macOS with Xcode. Android builds work with the Android SDK on macOS, Windows, or Linux.

The app currently stores data locally on-device. A backend, authentication, cloud sync, push notifications, and App Store / Play Store production configuration can be added next.
