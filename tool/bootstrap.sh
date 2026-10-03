#!/usr/bin/env bash
set -euo pipefail

if ! command -v flutter >/dev/null 2>&1; then
  echo "Flutter is not installed or is not on PATH."
  exit 1
fi

flutter create \
  --platforms=android,ios \
  --project-name=flutter_app \
  --org=com.example \
  .

flutter pub get

echo
echo "Flutter platform projects are ready."
echo "Run: flutter run"
