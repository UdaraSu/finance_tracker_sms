import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/transaction_provider.dart';
import '../services/sms_parser.dart';
import '../widgets/transaction_tile.dart';
import 'transaction_details_screen.dart';

/// Screen 1: Transaction list. Reads state via [transactionsProvider]
/// only — all parsing/categorization already happened before the
/// data reached this widget.
class TransactionListScreen extends ConsumerWidget {
  const TransactionListScreen({super.key});

  Future<void> _showAddSmsDialog(BuildContext context, WidgetRef ref) async {
    final rawMessage = await showDialog<String>(
      context: context,
      builder: (_) => const _AddSmsDialog(),
    );
    if (rawMessage == null) return;

    ref.read(transactionsProvider.notifier).addFromRawSms(rawMessage);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(transactionsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Transactions')),
      body: transactions.isEmpty
          ? const Center(child: Text('No transactions yet.'))
          : ListView.separated(
              itemCount: transactions.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                return TransactionTile(
                  transaction: transaction,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => TransactionDetailsScreen(
                          transactionId: transaction.id,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddSmsDialog(context, ref),
        icon: const Icon(Icons.sms),
        label: const Text('Add SMS'),
      ),
    );
  }
}

class _AddSmsDialog extends StatefulWidget {
  const _AddSmsDialog();

  @override
  State<_AddSmsDialog> createState() => _AddSmsDialogState();
}

class _AddSmsDialogState extends State<_AddSmsDialog> {
  late final TextEditingController _controller;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    try {
      SmsParser.parse(_controller.text);
    } on SmsParseException catch (e) {
      setState(() => _errorText = e.message);
      return;
    }
    Navigator.of(context).pop(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Paste SMS / OTP message'),
      content: TextField(
        controller: _controller,
        maxLines: 6,
        decoration: InputDecoration(
          hintText: 'Paste a bank transaction SMS here...',
          errorText: _errorText,
          border: const OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _submit,
          child: const Text('Parse & Add'),
        ),
      ],
    );
  }
}
