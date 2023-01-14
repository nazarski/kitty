part of 'database_bloc.dart';

class DatabaseState extends Equatable {
  final List<EntryCategory> expCategories;
  final List<EntryCategory> inCategories;
  final Balance balance;
  final List<Entry> entries;
  final List<CategoryIcon> icons;
  final EntryCategory? categoryToAdd;
  final CategoryIcon? selectedIcon;

  const DatabaseState({
    this.expCategories = const [],
    this.inCategories = const [],
    this.balance =
        const Balance(income: 0, expenses: 0, balance: 0, date: '--'),
    this.entries = const [],
    this.icons = const [],
    this.categoryToAdd,
    this.selectedIcon,
  });

  DatabaseState copyWith({
    List<EntryCategory>? expCategories,
    List<EntryCategory>? inCategories,
    Balance? balance,
    List<Entry>? entries,
    List<CategoryIcon>? icons,
    EntryCategory? categoryToAdd,
    CategoryIcon? selectedIcon,
  }) {
    return DatabaseState(
      expCategories: expCategories ?? this.expCategories,
      inCategories: inCategories ?? this.inCategories,
      balance: balance ?? this.balance,
      entries: entries ?? this.entries,
      icons: icons ?? this.icons,
      categoryToAdd: categoryToAdd ?? this.categoryToAdd,
      selectedIcon: selectedIcon ?? this.selectedIcon,
    );
  }

  @override
  List<Object?> get props =>
      [expCategories, inCategories, categoryToAdd, icons, selectedIcon];
}
