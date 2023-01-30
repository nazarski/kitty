part of 'entries_control_bloc.dart';

enum DatabaseStatus {
  initial,
  loading,
  loaded,
  test,
}

class EntriesControlState extends Equatable {
  final DateTime? reportDate;
  final List<EntryCategory> expCategories;
  final List<EntryCategory> inCategories;
  final Balance balance;
  final Map<String, List<Entry>> entries;
  final List<CategoryIcon> icons;
  final EntryCategory categoryToAdd;
  final CategoryIcon selectedIcon;
  final DatabaseStatus status;
  final List<StatisticsElement> statistics;

  const EntriesControlState({
    this.reportDate,
    this.expCategories = const [],
    this.inCategories = const [],
    this.balance = const Balance(
      income: 0,
      expenses: 0,
      balance: 0,
    ),
    this.entries = const {},
    this.icons = const [],
    this.categoryToAdd = EntriesControlBloc.zeroCategory,
    this.selectedIcon = EntriesControlBloc.zeroIcon,
    this.status = DatabaseStatus.initial,
    this.statistics = const [],
  });

  EntriesControlState copyWith({
    List<EntryCategory>? expCategories,
    List<EntryCategory>? inCategories,
    Balance? balance,
    Map<String, List<Entry>>? entries,
    List<CategoryIcon>? icons,
    EntryCategory? categoryToAdd,
    CategoryIcon? selectedIcon,
    DatabaseStatus? status,
    List<EntryDate>? entriesDates,
    List<StatisticsElement>? statistics,
    DateTime? reportDate,
  }) {
    return EntriesControlState(
      expCategories: expCategories ?? this.expCategories,
      inCategories: inCategories ?? this.inCategories,
      balance: balance ?? this.balance,
      entries: entries ?? this.entries,
      icons: icons ?? this.icons,
      categoryToAdd: categoryToAdd ?? this.categoryToAdd,
      selectedIcon: selectedIcon ?? this.selectedIcon,
      status: status ?? this.status,
      statistics: statistics ?? this.statistics,
      reportDate: reportDate ?? this.reportDate,
    );
  }

  @override
  List<Object?> get props => [
        expCategories,
        inCategories,
        categoryToAdd,
        icons,
        selectedIcon,
        entries,
        status,
        statistics,
        reportDate,
      ];
}
