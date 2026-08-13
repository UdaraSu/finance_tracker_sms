/// Central list of categories the app knows about. Keeping this as a
/// single source of truth means the auto-categorizer, the manual
/// category-edit dropdown, and any future analytics screen all agree
/// on the same set of values.
class Category {
  static const String transport = 'Transport';
  static const String groceries = 'Groceries';
  static const String fuel = 'Fuel';
  static const String income = 'Income';
  static const String other = 'Other';

  static const List<String> all = [
    transport,
    groceries,
    fuel,
    income,
    other,
  ];
}
