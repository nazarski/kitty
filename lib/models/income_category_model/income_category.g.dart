// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'income_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_IncomeCategory _$$_IncomeCategoryFromJson(Map<String, dynamic> json) =>
    _$_IncomeCategory(
      title: json['title'] as String,
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      entries: json['entries'] as int? ?? 0,
      icon: CategoryIcon.fromJson(json['icon'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_IncomeCategoryToJson(_$_IncomeCategory instance) =>
    <String, dynamic>{
      'title': instance.title,
      'totalAmount': instance.totalAmount,
      'entries': instance.entries,
      'icon': instance.icon.toJson(),
    };
