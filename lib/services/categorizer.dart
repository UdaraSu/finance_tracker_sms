import '../models/category.dart';

/// Pure keyword-matching categorizer.
///
/// Kept as its own class (rather than baked into the parser) so the
/// rule set can be extended or swapped out — e.g. for a smarter
/// classifier later — without touching the SMS-parsing logic.
class Categorizer {
  /// Ordered list of (keywords, category). First match wins, so put
  /// more specific rules before broader ones.
  static final List<_Rule> _rules = [
    _Rule(
      keywords: ['interchange', 'transport', 'expressway', 'toll'],
      category: Category.transport,
    ),
    _Rule(
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
    _Rule(
      keywords: ['fuel', 'petrol', 'filling station', 'ioc', 'ceypetco'],
      category: Category.fuel,
    ),
  ];

  /// Returns the best-guess category for a merchant string. Falls
  /// back to [Category.other] when nothing matches.
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
