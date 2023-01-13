import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'income.freezed.dart';
part 'income.g.dart';
@freezed
class Income with _$Income{
  const factory Income({
    required int incomeId,
    required String description,
    required int amount,
    required String dateTime,
    required int categoryId,
  }) = _Income;
  factory Income.fromJson(Map<String, dynamic> json)=> _$IncomeFromJson(json);
}