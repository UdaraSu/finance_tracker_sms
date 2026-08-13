/// Sample bank SMS messages taken directly from the assessment brief.
/// Kept separate from the parser/provider so it's obvious this is
/// swappable demo data, not part of the app's real logic.
const List<String> sampleSmsMessages = [
  '''LKR 150.00 debited from AC **1111 via POS at KOTTAWA INTERCHANGE 10500302
28/03/2026 14:19:13
To Inq Call 0112303050
Get protected - Do not Share OTP''',
  '''LKR 1,692.00 debited from AC **1114 via POS at KEELLS SUPER - KOTTAWA 10402483
25/03/2026 17:46:49
To Inq Call 0112303050
Get protected - Do not Share OTP''',
  '''LKR 5,970.00 debited from AC **1114 via POS at P AND B FUEL MART 10000759
25/03/2026 18:58:40
To Inq Call 0112303050
Get protected - Do not Share OTP''',
  '''LKR 45,000.00 credited to AC **1114 via POS at SALARY TRANSFER 10999812
30/03/2026 09:02:01
To Inq Call 0112303050
Get protected - Do not Share OTP''',
];
