part of 'entries_control_bloc.dart';

enum DatabaseStatus {
  initial,
  loading,
  loaded,
  test,
}

class EntriesControl extends Equatable {
  final List<EntryCategory> expCategories;
  final List<EntryCategory> inCategories;
  final Balance balance;
  final Map<String, List<Entry>> entries;
  final List<EntryDate> entriesDates;
  final List<CategoryIcon> icons;
  final EntryCategory? categoryToAdd;
  final CategoryIcon? selectedIcon;
  final DatabaseStatus status;
  final List<StatisticsElement> statistics;


  const EntriesControl({
    this.expCategories = const [],
    this.inCategories = const [],
    this.balance = const Balance(
      income: 0,
      expenses: 0,
      balance: 0,
    ),
    this.entries = const {},
    this.icons = const [],
    this.categoryToAdd,
    this.selectedIcon,
    this.status = DatabaseStatus.initial,
    this.entriesDates = const [],
    this.statistics = const [],
  });

  EntriesControl copyWith({
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
  }) {
    return EntriesControl(
      expCategories: expCategories ?? this.expCategories,
      inCategories: inCategories ?? this.inCategories,
      balance: balance ?? this.balance,
      entries: entries ?? this.entries,
      icons: icons ?? this.icons,
      categoryToAdd: categoryToAdd ?? this.categoryToAdd,
      selectedIcon: selectedIcon ?? this.selectedIcon,
      status: status ?? this.status,
      entriesDates: entriesDates ?? this.entriesDates,
      statistics: statistics ?? this.statistics,
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
        entriesDates,
        statistics,
      ];
}
