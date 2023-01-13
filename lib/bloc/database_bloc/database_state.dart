part of 'database_bloc.dart';

class DatabaseState extends Equatable {
  final List<ExpenseCategory> expCategories;
  final List<IncomeCategory> inCategories;
  final Balance balance;
  final List<Expense> expenses;
  final List<CategoryIcon> icons;
  final String categoryToAdd;
  final CategoryIcon? selectedIcon;

  const DatabaseState({
    this.expCategories = const [],
    this.inCategories = const [],
    this.balance =
        const Balance(income: 0, expenses: 0, balance: 0, date: '--'),
    this.expenses = const [],
    this.icons = const [],
    this.categoryToAdd = '',
    this.selectedIcon,
  });

  DatabaseState copyWith({
    List<ExpenseCategory>? expCategories,
    List<IncomeCategory>? inCategories,
    Balance? balance,
    List<Expense>? expenses,
    List<CategoryIcon>? icons,
    String? categoryToAdd,
    CategoryIcon? selectedIcon,
  }) {
    return DatabaseState(
      expCategories: expCategories ?? this.expCategories,
      inCategories: inCategories ?? this.inCategories,
      balance: balance ?? this.balance,
      expenses: expenses ?? this.expenses,
      icons: icons ?? this.icons,
      categoryToAdd: categoryToAdd ?? this.categoryToAdd,
      selectedIcon: selectedIcon ?? this.selectedIcon,
    );
  }

  @override
  List<Object?> get props =>
      [expCategories, inCategories, categoryToAdd, icons, selectedIcon];
}
