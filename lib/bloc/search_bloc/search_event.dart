part of 'search_bloc.dart';

@immutable
abstract class SearchEvent {}

class CategorySearchEvent extends SearchEvent{
  final int categoryId;

  CategorySearchEvent(this.categoryId);
}
class SearchByValueEvent extends SearchEvent{
  final String searchValue;

  SearchByValueEvent(this.searchValue);
}
class SaveSearchValueEvent extends SearchEvent{
  final String searchValue;

  SaveSearchValueEvent(this.searchValue);
}