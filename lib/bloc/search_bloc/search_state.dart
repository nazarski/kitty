part of 'search_bloc.dart';

class SearchState {
  final List<int> searchCategories;
  final List<String> searchHistory;
  final String searchValue;
  final List<EntryCategory> availableCategories;

  SearchState({
    this.searchHistory = const [],
    this.searchCategories = const [],
    this.searchValue = '',
    this.availableCategories = const [],
  });

  SearchState copyWith({
    String? searchValue,
    List<String>? searchHistory,
    List<int>? searchCategories,
    List<EntryCategory>? availableCategories,
  }) {
    return SearchState(
      searchValue: searchValue ?? this.searchValue,
      searchHistory: searchHistory ?? this.searchHistory,
      searchCategories: searchCategories ?? this.searchCategories,
      availableCategories: availableCategories ?? this.availableCategories,
    );
  }
}
