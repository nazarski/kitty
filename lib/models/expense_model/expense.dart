import 'package:freezed_annotation/freezed_annotation.dart';

part 'expense.freezed.dart';
part 'expense.g.dart';
@freezed
class Expense with _$Expense{
  const factory Expense({
    required int expenseId,
    required String description,
    required int amount,
    required String dateTime,
    required int categoryId,
  }) = _Expense;
  factory Expense.fromJson(Map<String, dynamic> json)=> _$ExpenseFromJson(json);
}