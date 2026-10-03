# Flutter App

A clean Flutter starter app for **iOS and Android**.

## What's included

- Flutter + Dart
- Material 3 design
- Light and dark themes
- Bottom navigation with Home, Explore, and Profile starter screens
- A basic widget test
- No third-party state-management or backend dependency yet

## First-time setup

Install Flutter, clone this repository, then run:

```bash
chmod +x tool/bootstrap.sh
./tool/bootstrap.sh
flutter run
```

The bootstrap command generates the native Android and iOS project folders using your installed Flutter SDK. This keeps the native scaffolding aligned with the Flutter version you actually use.

You can also run the equivalent command manually:

```bash
flutter create --platforms=android,ios --project-name=flutter_app --org=com.example .
flutter pub get
flutter run
```

## Useful commands

```bash
flutter doctor
flutter test
flutter analyze
flutter run
```

## iOS note

Building or running the iOS version requires macOS with Xcode installed. Android development works on macOS, Windows, or Linux with the Android SDK configured.

## Project structure

```text
lib/
├── main.dart
├── app.dart
├── screens/
│   └── home_screen.dart
└── widgets/
    └── feature_card.dart
```

This is intentionally a simple foundation. The next step is to replace the starter content with the real app idea and connect any services the app needs.
