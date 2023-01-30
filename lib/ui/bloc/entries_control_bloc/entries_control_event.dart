part of 'entries_control_bloc.dart';

@immutable
abstract class EntriesControlEvent {}

class InitialDatabaseEvent extends EntriesControlEvent {}

class CallAllDataEvent extends EntriesControlEvent {}

class CallEntryCategoriesEvent extends EntriesControlEvent {}

class GetCategoryEvent extends EntriesControlEvent {
  final EntryCategory category;

  GetCategoryEvent(this.category);
}

class GetIconEvent extends EntriesControlEvent {
  final CategoryIcon icon;

  GetIconEvent(this.icon);
}

class CreateExpenseCategoryEvent extends EntriesControlEvent {
  final String categoryName;
  final CategoryIcon selectedIcon;

  CreateExpenseCategoryEvent(
      {required this.selectedIcon, required this.categoryName});
}

class CreateEntryEvent extends EntriesControlEvent {
  final String amount;
  final String description;
  CreateEntryEvent(
      {required this.amount, required this.description});
}
class SelectEntriesByDateEvent extends EntriesControlEvent{
  final DateTime monthYear;

  SelectEntriesByDateEvent(this.monthYear);

}
class SetDateToEntriesEvent extends EntriesControlEvent{
  final String type;
  final int year;
  final int month;

  SetDateToEntriesEvent({required this.type, required this.year, required this.month});
}
class SearchEntries extends EntriesControlEvent{
  final List<int> categoryIds;
  final String searchValue;

  SearchEntries(this.categoryIds, this.searchValue);
}
class DeleteEntryEvent extends EntriesControlEvent{
  final int entryId;
  DeleteEntryEvent(this.entryId);
}
class ReorderCategoriesEvent extends EntriesControlEvent{
  final int oldIndex;
  final int newIndex;

  ReorderCategoriesEvent({required this.oldIndex, required this.newIndex});
}
class EditCategoryEvent extends EntriesControlEvent{
  final String newTitle;
  final CategoryIcon icon;

  EditCategoryEvent({required this.newTitle,required this.icon});
}