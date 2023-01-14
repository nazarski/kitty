part of 'database_bloc.dart';

@immutable
abstract class DatabaseEvent {}

class InitialDatabaseEvent extends DatabaseEvent {}

class CallAllDataEvent extends DatabaseEvent {}

class CallEntryCategoriesEvent extends DatabaseEvent {}

class GetCategoryEvent extends DatabaseEvent {
  final EntryCategory category;

  GetCategoryEvent(this.category);
}

class GetIconEvent extends DatabaseEvent {
  final CategoryIcon icon;

  GetIconEvent(this.icon);
}

class CreateExpenseCategoryEvent extends DatabaseEvent {
  final String categoryName;
  final CategoryIcon selectedIcon;

  CreateExpenseCategoryEvent(
      {required this.selectedIcon, required this.categoryName});
}

class CreateEntryEvent extends DatabaseEvent {
  final String amount;
  final String description;
  CreateEntryEvent(
      {required this.amount, required this.description});
}
