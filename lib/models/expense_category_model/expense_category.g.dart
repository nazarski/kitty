// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ExpenseCategory _$$_ExpenseCategoryFromJson(Map<String, dynamic> json) =>
    _$_ExpenseCategory(
      categoryId: json['categoryId'] as int,
      title: json['title'] as String,
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      entries: json['entries'] as int? ?? 0,
      icon: CategoryIcon.fromJson(json['icon'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_ExpenseCategoryToJson(_$_ExpenseCategory instance) =>
    <String, dynamic>{
      'categoryId': instance.categoryId,
      'title': instance.title,
      'totalAmount': instance.totalAmount,
      'entries': instance.entries,
      'icon': instance.icon.toJson(),
    };
