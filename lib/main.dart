import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'screens/transaction_list_screen.dart';

void main() {
  runApp(const ProviderScope(child: SmsFinanceApp()));
}

class SmsFinanceApp extends StatelessWidget {
  const SmsFinanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SMS Finance Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const TransactionListScreen(),
    );
  }
}
