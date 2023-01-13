// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Expense _$$_ExpenseFromJson(Map<String, dynamic> json) => _$_Expense(
      expenseId: json['expenseId'] as int,
      description: json['description'] as String,
      amount: json['amount'] as int,
      dateTime: json['dateTime'] as String,
      categoryId: json['categoryId'] as int,
    );

Map<String, dynamic> _$$_ExpenseToJson(_$_Expense instance) =>
    <String, dynamic>{
      'expenseId': instance.expenseId,
      'description': instance.description,
      'amount': instance.amount,
      'dateTime': instance.dateTime,
      'categoryId': instance.categoryId,
    };
