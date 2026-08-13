# SMS Finance Tracker

A simple Flutter app that parses bank SMS transaction messages, extracts key transaction data, auto-categorizes it, and shows the results in a small finance tracker UI.

## Features

- Parse transaction SMS messages
- Extract amount, type, account, merchant, and date/time
- Auto-categorize expenses and income
- Show transactions in a list
- Open transaction details
- Update category from the details screen
- Keep state synchronized with Riverpod

## Tech used

- Flutter
- Dart
- Riverpod

## Run locally

```bash
flutter pub get
flutter run
```

## Project structure

```text
lib/
  data/
  models/
  providers/
  screens/
  services/
  widgets/

test/
```

## Testing

```bash
flutter test
```

## Notes

This app is built as a small MVP for the assignment brief and focuses on clean architecture and working functionality instead of advanced UI design.
