
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kitty/models/category_icon_model/category_icon.dart';

part 'expense_category.freezed.dart';
part 'expense_category.g.dart';
@freezed
class ExpenseCategory with _$ExpenseCategory{
  @JsonSerializable(explicitToJson: true)
  const factory ExpenseCategory({
    required String title,
    @Default(0.0) double totalAmount,
    @Default(0) int entries,
    required CategoryIcon icon,
  }) = _ExpenseCategory;
  factory ExpenseCategory.fromJson(Map<String, dynamic> json)=> _$ExpenseCategoryFromJson(json);
}
