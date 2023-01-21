part of 'search_bloc.dart';

class SearchState {
  final List<int> searchCategories;
final List<String> searchHistory;
  SearchState({
    this.searchHistory = const [],
    this.searchCategories = const [],
  });

  SearchState copyWith({
    List<String>? searchHistory,
    List<int>? searchCategories,
  }) {
    return SearchState(
      searchHistory: searchHistory ?? this.searchHistory,
      searchCategories: searchCategories ?? this.searchCategories,
    );
  }
}

