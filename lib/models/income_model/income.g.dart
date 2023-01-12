// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'income.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Income _$$_IncomeFromJson(Map<String, dynamic> json) => _$_Income(
      id: json['id'] as int,
      description: json['description'] as String,
      amount: json['amount'] as int,
      dateTime: json['dateTime'] as String,
    );

Map<String, dynamic> _$$_IncomeToJson(_$_Income instance) => <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'amount': instance.amount,
      'dateTime': instance.dateTime,
    };
