import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

/// Purely presentational — takes a [Transaction] and a tap callback,
/// no business logic, no provider access. This keeps it trivially
/// reusable and testable in isolation.
class TransactionTile extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback onTap;

  const TransactionTile({
    super.key,
    required this.transaction,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isExpense = transaction.type == TransactionType.expense;
    final amountColor = isExpense ? Colors.red.shade700 : Colors.green.shade700;
    final sign = isExpense ? '-' : '+';
    final currencyFormat = NumberFormat.currency(symbol: 'LKR ', decimalDigits: 2);
    final dateFormat = DateFormat('dd MMM yyyy, HH:mm');

    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: amountColor.withValues(alpha: 0.15),
        child: Icon(
          isExpense ? Icons.arrow_upward : Icons.arrow_downward,
          color: amountColor,
        ),
      ),
      title: Text(
        transaction.merchant,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        '${dateFormat.format(transaction.dateTime)} · ${transaction.category}',
      ),
      trailing: Text(
        '$sign${currencyFormat.format(transaction.amount)}',
        style: TextStyle(color: amountColor, fontWeight: FontWeight.bold),
      ),
    );
  }
}
