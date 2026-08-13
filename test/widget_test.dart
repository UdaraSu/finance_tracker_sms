import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sms_finance_tracker/main.dart';

const _newSms = '''LKR 99.00 debited from AC **9999 via POS at TEST MERCHANT XYZ 12345678
01/01/2026 12:00:00
To Inq Call 0112303050
Get protected - Do not Share OTP''';

void main() {
  testWidgets('app launches and shows seeded transactions', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: SmsFinanceApp()));
    await tester.pumpAndSettle();

    expect(find.text('Transactions'), findsOneWidget);
    expect(find.text('Add SMS'), findsOneWidget);
    expect(find.text('KEELLS SUPER - KOTTAWA'), findsOneWidget);
  });

  testWidgets('add SMS dialog adds a parsed transaction', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: SmsFinanceApp()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add SMS'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), _newSms);
    await tester.tap(find.text('Parse & Add'));
    await tester.pumpAndSettle();

    expect(find.text('TEST MERCHANT XYZ'), findsOneWidget);
  });
}
