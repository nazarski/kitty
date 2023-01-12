
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kitty/models/category_icon_model/category_icon.dart';

part 'income_category.freezed.dart';
part 'income_category.g.dart';
@freezed
class IncomeCategory with _$IncomeCategory{
  @JsonSerializable(explicitToJson: true)
  const factory IncomeCategory({
    required String title,
    @Default(0.0) double totalAmount,
    @Default(0) int entries,
    required CategoryIcon icon,
  }) = _IncomeCategory;
  factory IncomeCategory.fromJson(Map<String, dynamic> json)=> _$IncomeCategoryFromJson(json);
}
