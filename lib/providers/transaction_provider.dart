import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/sample_messages.dart';
import '../models/transaction.dart';
import '../services/sms_parser.dart';

class TransactionsNotifier extends Notifier<List<Transaction>> {
  @override
  List<Transaction> build() {
    return SmsParser.parseAll(sampleSmsMessages);
  }

  void addFromRawSms(String rawMessage) {
    final transaction = SmsParser.parse(rawMessage);
    state = [transaction, ...state];
  }

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
