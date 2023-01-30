part of 'search_bloc.dart';

@immutable
abstract class SearchEvent {}

class CategorySearchEvent extends SearchEvent{
  final int categoryId;

  CategorySearchEvent({required this.categoryId});
}
class SearchByValueEvent extends SearchEvent{
  final String searchValue;

  SearchByValueEvent({required this.searchValue});
}
class SaveSearchValueEvent extends SearchEvent{
  final String searchValue;

  SaveSearchValueEvent({required this.searchValue});
}
class GetAvailableSearchData extends SearchEvent{}
class SaveRecentSearchValue extends SearchEvent{
  final String searchValue;

  SaveRecentSearchValue(this.searchValue);
}