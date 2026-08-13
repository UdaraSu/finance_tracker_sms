import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../models/category.dart';
import '../models/transaction.dart';
import '../providers/transaction_provider.dart';

/// Screen 2: Full parsed detail for one transaction, plus the
/// category-edit control. Because it watches [transactionsProvider]
/// (not a snapshot passed via constructor), any category change made
/// here is instantly visible back on the list screen too.
class TransactionDetailsScreen extends ConsumerWidget {
  final String transactionId;

  const TransactionDetailsScreen({super.key, required this.transactionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(transactionsProvider);
    final transactionIndex =
        transactions.indexWhere((t) => t.id == transactionId);
    if (transactionIndex == -1) {
      return Scaffold(
        appBar: AppBar(title: const Text('Transaction Details')),
        body: const Center(child: Text('Transaction not found.')),
      );
    }
    final transaction = transactions[transactionIndex];

    final isExpense = transaction.type == TransactionType.expense;
    final currencyFormat =
        NumberFormat.currency(symbol: 'LKR ', decimalDigits: 2);
    final dateFormat = DateFormat('dd MMM yyyy, HH:mm:ss');

    return Scaffold(
      appBar: AppBar(title: const Text('Transaction Details')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currencyFormat.format(transaction.amount),
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: isExpense
                          ? Colors.red.shade700
                          : Colors.green.shade700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(isExpense ? 'Expense' : 'Income'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _DetailRow(label: 'Merchant', value: transaction.merchant),
          _DetailRow(label: 'Account', value: transaction.accountRef),
          _DetailRow(
            label: 'Date & Time',
            value: dateFormat.format(transaction.dateTime),
          ),
          const SizedBox(height: 8),
          const Text('Category', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          DropdownButtonFormField<String>(
            initialValue: transaction.category,
            items: Category.all
                .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                .toList(),
            onChanged: (newCategory) {
              if (newCategory == null) return;
              ref
                  .read(transactionsProvider.notifier)
                  .updateCategory(transaction.id, newCategory);
            },
            decoration: const InputDecoration(border: OutlineInputBorder()),
          ),
          const SizedBox(height: 24),
          const Text('Raw SMS', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Text(
              transaction.rawMessage,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(label, style: const TextStyle(color: Colors.grey)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
