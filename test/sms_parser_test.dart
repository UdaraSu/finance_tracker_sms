import 'package:flutter_test/flutter_test.dart';
import 'package:sms_finance_tracker/models/transaction.dart';
import 'package:sms_finance_tracker/services/sms_parser.dart';

void main() {
  group('SmsParser', () {
    test('parses a debit (expense) message correctly', () {
      const raw = '''LKR 1,692.00 debited from AC **1114 via POS at KEELLS SUPER - KOTTAWA 10402483
25/03/2026 17:46:49
To Inq Call 0112303050
Get protected - Do not Share OTP''';

      final tx = SmsParser.parse(raw);

      expect(tx.amount, 1692.00);
      expect(tx.type, TransactionType.expense);
      expect(tx.accountRef, '**1114');
      expect(tx.merchant, 'KEELLS SUPER - KOTTAWA');
      expect(tx.category, 'Groceries');
      expect(tx.dateTime.year, 2026);
      expect(tx.dateTime.month, 3);
      expect(tx.dateTime.day, 25);
      expect(tx.dateTime.hour, 17);
      expect(tx.dateTime.minute, 46);
    });

    test('parses a credit (income) message correctly', () {
      const raw = '''LKR 45,000.00 credited to AC **1114 via POS at SALARY TRANSFER 10999812
30/03/2026 09:02:01
To Inq Call 0112303050
Get protected - Do not Share OTP''';

      final tx = SmsParser.parse(raw);

      expect(tx.type, TransactionType.income);
      expect(tx.category, 'Income');
    });

    test('categorizes fuel merchants as Fuel', () {
      const raw = '''LKR 5,970.00 debited from AC **1114 via POS at P AND B FUEL MART 10000759
25/03/2026 18:58:40
To Inq Call 0112303050
Get protected - Do not Share OTP''';

      final tx = SmsParser.parse(raw);
      expect(tx.category, 'Fuel');
    });

    test('categorizes interchange merchants as Transport', () {
      const raw = '''LKR 150.00 debited from AC **1111 via POS at KOTTAWA INTERCHANGE 10500302
28/03/2026 14:19:13
To Inq Call 0112303050
Get protected - Do not Share OTP''';

      final tx = SmsParser.parse(raw);
      expect(tx.category, 'Transport');
    });

    test('throws SmsParseException on garbage input', () {
      expect(
        () => SmsParser.parse('this is not a bank message'),
        throwsA(isA<SmsParseException>()),
      );
    });
  });
}
