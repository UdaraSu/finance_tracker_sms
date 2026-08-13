# SMS Finance Tracker (Flutter Intern Assessment)

A small MVP that parses bank SMS/OTP transaction messages, extracts
structured data, auto-categorizes each transaction, and displays them
in a Riverpod-powered Flutter app.

## Getting started

```bash
flutter pub get
flutter run
```

Requires Flutter 3.19+ (Dart 3.3+). No backend, no API keys, no
network access needed — everything runs on bundled sample data plus
whatever you paste in through the "Add SMS" button.

## How to use it

1. App launches with 4 sample transactions already parsed (3 expenses,
   1 income) — this is the data from the assessment brief.
2. Tap **Add SMS** (bottom-right) to paste any other bank SMS and see
   it parsed live.
3. Tap any row to open **Transaction Details**.
4. On the details screen, change the **Category** dropdown — go back
   to the list and the new category is already there.

## Architecture

```
lib/
  models/
    transaction.dart      # Transaction + TransactionType — pure Dart, no Flutter imports
    category.dart          # Single source of truth for the category list
  services/
    sms_parser.dart        # Regex extraction: amount, direction, account, merchant, date/time
    categorizer.dart       # Keyword-based auto-categorization rules
  data/
    sample_messages.dart   # The 3 sample SMS strings from the brief, plus 1 credit example
  providers/
    transaction_provider.dart  # Riverpod Notifier — the only place state is mutated
  screens/
    transaction_list_screen.dart     # Screen 1 + "Add SMS" dialog
    transaction_details_screen.dart  # Screen 2 + category editor
  widgets/
    transaction_tile.dart  # Presentational list row, no logic
test/
  sms_parser_test.dart     # Unit tests for parsing + categorization
```

**Separation of concerns:**
- Widgets never parse strings or contain business rules — they only
  read `transactionsProvider` and call methods on the notifier.
- `SmsParser` and `Categorizer` are plain Dart classes, independently
  unit-testable (`flutter test`), with zero Flutter dependency.
- `TransactionsNotifier` is the single source of truth. Every screen
  watches the same provider, so a category edit on the details screen
  is instantly reflected on the list — no manual refresh, no passed-
  down callbacks between screens.

## Parsing logic

The parser targets this message shape (from the brief):

```
LKR 1,692.00 debited from AC **1114 via POS at KEELLS SUPER - KOTTAWA 10402483
25/03/2026 17:46:49
To Inq Call 0112303050
Get protected - Do not Share OTP
```

It extracts, via targeted regexes (see `lib/services/sms_parser.dart`):
- **Amount** — after `LKR`
- **Direction** — `debited` → Expense, `credited` → Income
- **Account reference** — the masked `AC **NNNN`
- **Merchant** — text between `via POS at` and the trailing POS
  reference number
- **Date & time** — `dd/MM/yyyy HH:mm:ss`

Malformed input raises `SmsParseException` rather than crashing, so
the "Add SMS" dialog can show a friendly inline error.

## Categorization rules

| Merchant keyword contains...              | Category   |
|--------------------------------------------|------------|
| interchange, transport, expressway, toll   | Transport  |
| super, supermarket, keells, cargills, arpico | Groceries |
| fuel, petrol, filling station               | Fuel       |
| (credited transactions)                     | Income     |
| anything else                               | Other      |

Rules live in `Categorizer._rules` — easy to extend without touching
the parser.

## Tests

```bash
flutter test
```

Covers: amount/date/merchant extraction, expense vs. income
classification, keyword-based categorization, and error handling on
garbage input.

## Deliverables checklist (for submission)

- [ ] Push this to a **public GitHub repository**
- [ ] Record a screen capture showing:
  - [ ] App running (sample transactions on the list screen)
  - [ ] Adding a new SMS via the "Add SMS" dialog
  - [ ] Tapping into transaction details
  - [ ] Changing a category on the details screen
  - [ ] Going back to the list and showing the updated category there

## Notes on scope

This was built to match the brief exactly: standard Material widgets
only, no custom UI/UX polish, no backend. The regex parser targets the
specific bank SMS format given in the brief; a production version
would want a more tolerant/multi-bank parser and persistence (e.g.
`shared_preferences` or a local DB), which is intentionally left out
per "No backend required."
