// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'income.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Income _$$_IncomeFromJson(Map<String, dynamic> json) => _$_Income(
      incomeId: json['incomeId'] as int,
      description: json['description'] as String,
      amount: json['amount'] as int,
      dateTime: json['dateTime'] as String,
      categoryId: json['categoryId'] as int,
    );

Map<String, dynamic> _$$_IncomeToJson(_$_Income instance) => <String, dynamic>{
      'incomeId': instance.incomeId,
      'description': instance.description,
      'amount': instance.amount,
      'dateTime': instance.dateTime,
      'categoryId': instance.categoryId,
    };
