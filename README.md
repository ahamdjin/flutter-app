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
- Native Android and iOS projects committed to the repository
- Widget tests and GitHub Actions quality checks

## Run the app

Install a current Flutter stable SDK, clone this repository, then run:

```bash
flutter pub get
flutter run
```

Choose an Android emulator/device or an iOS simulator/device when Flutter asks.

## Quality checks

```bash
flutter analyze
flutter test
```

GitHub Actions runs analysis, tests, and an Android debug build automatically on pushes and pull requests to `main`.

## Project structure

```text
android/                 # Native Android project
ios/                     # Native iOS project
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

iOS builds require macOS with Xcode. Android builds require the Android SDK.

The app currently stores data locally on-device. Authentication, cloud sync, push notifications, and store-release configuration can be added when the product direction is finalized.
