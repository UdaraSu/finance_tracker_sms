import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/sample_messages.dart';
import '../models/transaction.dart';
import '../services/sms_parser.dart';

/// Owns the in-memory list of transactions. This is the ONLY place
/// that mutates transaction state — screens/widgets only ever read
/// via [transactionsProvider] and call methods on this notifier,
/// they never mutate lists directly. That's what keeps "updates
/// reflect on the list screen immediately" trivial: every consumer
/// watching the provider rebuilds automatically on any change.
class TransactionsNotifier extends Notifier<List<Transaction>> {
  @override
  List<Transaction> build() {
    // Seed with the bundled sample messages on startup.
    return SmsParser.parseAll(sampleSmsMessages);
  }

  /// Parses a raw SMS string and adds the resulting transaction to
  /// the top of the list. Throws [SmsParseException] on bad input —
  /// the UI layer is expected to catch and display it.
  void addFromRawSms(String rawMessage) {
    final transaction = SmsParser.parse(rawMessage);
    state = [transaction, ...state];
  }

  /// Updates the category of a single transaction by id. Rebuilds
  /// state immutably so every watcher (list screen, details screen)
  /// updates in sync.
  void updateCategory(String id, String newCategory) {
    state = [
      for (final t in state)
        if (t.id == id) t.copyWith(category: newCategory) else t,
    ];
  }
}

final transactionsProvider =
    NotifierProvider<TransactionsNotifier, List<Transaction>>(
  TransactionsNotifier.new,
);
