part of 'database_bloc.dart';

@immutable
abstract class DatabaseEvent {}
class InitialDatabaseEvent extends DatabaseEvent{}
class CallAllDataEvent extends DatabaseEvent {}

class CallIncomeCategoriesEvent extends DatabaseEvent {}

class CallExpenseCategoriesEvent extends DatabaseEvent {}

class GetExpenseCategoryEvent extends DatabaseEvent {
  final ExpenseCategory category;

  GetExpenseCategoryEvent(this.category);
}

class GetIncomeCategoryEvent extends DatabaseEvent {
  final IncomeCategory category;

  GetIncomeCategoryEvent(this.category);
}
class GetIconEvent extends DatabaseEvent{
  final Map<String, String> icon;

  GetIconEvent(this.icon);
}
class CreateExpenseCategoryEvent extends DatabaseEvent{
  final String categoryName;

  CreateExpenseCategoryEvent({required this.categoryName});

}