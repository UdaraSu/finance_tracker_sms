import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sms_finance_tracker/main.dart';

void main() {
  testWidgets('app launches and shows seeded transactions', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: SmsFinanceApp()));
    await tester.pumpAndSettle();

    expect(find.text('Transactions'), findsOneWidget);
    expect(find.text('Add SMS'), findsOneWidget);
    expect(find.text('KEELLS SUPER - KOTTAWA'), findsOneWidget);
  });
}
