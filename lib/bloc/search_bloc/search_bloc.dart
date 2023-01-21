import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'search_event.dart';

part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final List<int> selectedCategories = [];
  void _categories(CategorySearchEvent event, Emitter<SearchState> emit) {
    if(selectedCategories.contains(event.categoryId)){
      selectedCategories.remove(event.categoryId);
    }else{
      selectedCategories.add(event.categoryId);
    }
    emit(state.copyWith(searchCategories: selectedCategories));
  }

  SearchBloc() : super(SearchState()) {
    on<CategorySearchEvent>((event, emit) => _categories(event, emit));

  }
}
