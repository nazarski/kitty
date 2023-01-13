part of 'database_bloc.dart';

class DatabaseState extends Equatable {
  final List<ExpenseCategory> expCategories;
  final List<IncomeCategory> inCategories;
  final Balance balance;
  final List<Expense> expenses;
  final List<CategoryIcon> icons;
  final String categoryToAdd;

  DatabaseState({
    this.expCategories = const [],
    this.inCategories = const [],
    this.balance =
        const Balance(income: 0, expenses: 0, balance: 0, date: '--'),
    this.expenses = const [],
    this.icons = const [],
    this.categoryToAdd = '',
  });

  DatabaseState copyWith({
    List<ExpenseCategory>? expCategories,
    List<IncomeCategory>? inCategories,
    Balance? balance,
    List<Expense>? expenses,
    List<CategoryIcon>? icons,
    String? categoryToAdd,
  }) {
    return DatabaseState(
      expCategories: expCategories ?? this.expCategories,
      inCategories: inCategories ?? this.inCategories,
      balance: balance ?? this.balance,
      expenses: expenses ?? this.expenses,
      icons: icons ?? this.icons,
      categoryToAdd: categoryToAdd ?? this.categoryToAdd,
    );
  }

  @override
  List<Object?> get props => [expCategories, inCategories, categoryToAdd, icons];
}
