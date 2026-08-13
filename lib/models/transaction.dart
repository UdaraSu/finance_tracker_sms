/// Whether a transaction reduces (expense) or increases (income) the
/// account balance. Derived purely from the debit/credit indicator
/// found in the SMS text.
enum TransactionType { expense, income }

/// Immutable domain model for a single parsed bank SMS transaction.
///
/// This model intentionally has NO Flutter/UI imports — it is pure
/// Dart so it can be unit-tested and reused independent of widgets.
class Transaction {
  final String id;
  final double amount;
  final TransactionType type;
  final String accountRef; // e.g. "**1114"
  final String merchant; // e.g. "KEELLS SUPER - KOTTAWA"
  final DateTime dateTime;
  final String category; // mutable via user override
  final String rawMessage; // original SMS text, kept for the details screen

  const Transaction({
    required this.id,
    required this.amount,
    required this.type,
    required this.accountRef,
    required this.merchant,
    required this.dateTime,
    required this.category,
    required this.rawMessage,
  });

  Transaction copyWith({
    String? id,
    double? amount,
    TransactionType? type,
    String? accountRef,
    String? merchant,
    DateTime? dateTime,
    String? category,
    String? rawMessage,
  }) {
    return Transaction(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      accountRef: accountRef ?? this.accountRef,
      merchant: merchant ?? this.merchant,
      dateTime: dateTime ?? this.dateTime,
      category: category ?? this.category,
      rawMessage: rawMessage ?? this.rawMessage,
    );
  }
}
