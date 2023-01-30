import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kitty/domain/models/entry_category_model/entry_category.dart';
import 'package:kitty/domain/repository/database_repository.dart';

part 'search_event.dart';

part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final DatabaseRepository databaseRepository;
  final List<int> selectedCategories = [];

  void _categories(CategorySearchEvent event, Emitter<SearchState> emit) {
    if (selectedCategories.contains(event.categoryId)) {
      selectedCategories.remove(event.categoryId);
    } else {
      selectedCategories.add(event.categoryId);
    }
    emit(state.copyWith(searchCategories: selectedCategories));
  }

  Future<void> _getSearchData(Emitter emit) async {
    final categories = await databaseRepository.getUsedCategories();
    final searchValues = await databaseRepository.getRecentSearchValues();
    emit(state.copyWith(
        searchHistory: searchValues, availableCategories: categories));
  }

  SearchBloc(this.databaseRepository) : super(SearchState()) {
    on<CategorySearchEvent>((event, emit) => _categories(event, emit));
    on<GetAvailableSearchData>((_, emit) async => _getSearchData(emit));
    on<SearchByValueEvent>((event, emit) {
      emit(state.copyWith(searchValue: event.searchValue));
    });
    on<SaveRecentSearchValue>((event, emit) async {
      await databaseRepository.saveSearchValue(event.searchValue);
    });
  }
}
