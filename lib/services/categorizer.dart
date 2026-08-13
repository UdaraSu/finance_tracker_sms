import '../models/category.dart';

class Categorizer {
  // first matching keyword wins
  static final List<_Rule> _rules = [
    const _Rule(
      keywords: ['interchange', 'transport', 'expressway', 'toll'],
      category: Category.transport,
    ),
    const _Rule(
      keywords: [
        'super',
        'supermarket',
        'keells',
        'cargills',
        'arpico',
        'grocery',
      ],
      category: Category.groceries,
    ),
    const _Rule(
      keywords: ['fuel', 'petrol', 'filling station', 'ioc', 'ceypetco'],
      category: Category.fuel,
    ),
  ];

//back to category = other if no match
  static String categorize(String merchant) {
    final normalized = merchant.toLowerCase();
    for (final rule in _rules) {
      if (rule.keywords.any((k) => normalized.contains(k))) {
        return rule.category;
      }
    }
    return Category.other;
  }
}

class _Rule {
  final List<String> keywords;
  final String category;
  const _Rule({required this.keywords, required this.category});
}
