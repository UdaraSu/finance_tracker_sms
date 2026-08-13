enum TransactionType { expense, income }

class Transaction {
  final String id;
  final double amount;
  final TransactionType type;
  final String accountRef;
  final String merchant;
  final DateTime dateTime;
  final String category; //mutable
  final String rawMessage;

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
