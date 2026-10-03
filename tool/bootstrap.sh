#!/usr/bin/env bash
set -euo pipefail

if ! command -v flutter >/dev/null 2>&1; then
  echo "Flutter is not installed or is not on PATH."
  exit 1
fi

if [ ! -d android ] || [ ! -d ios ]; then
  echo "Native project folders are missing; regenerating them..."
  flutter create     --platforms=android,ios     --project-name=flutter_app     --org=com.orbitproductivity     .
fi

flutter pub get

echo
echo "Orbit is ready."
echo "Run: flutter run"
