// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expense_category.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ExpenseCategory _$ExpenseCategoryFromJson(Map<String, dynamic> json) {
  return _ExpenseCategory.fromJson(json);
}

/// @nodoc
mixin _$ExpenseCategory {
  String get title => throw _privateConstructorUsedError;
  double get totalAmount => throw _privateConstructorUsedError;
  int get entries => throw _privateConstructorUsedError;
  CategoryIcon get icon => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ExpenseCategoryCopyWith<ExpenseCategory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExpenseCategoryCopyWith<$Res> {
  factory $ExpenseCategoryCopyWith(
          ExpenseCategory value, $Res Function(ExpenseCategory) then) =
      _$ExpenseCategoryCopyWithImpl<$Res, ExpenseCategory>;
  @useResult
  $Res call({String title, double totalAmount, int entries, CategoryIcon icon});

  $CategoryIconCopyWith<$Res> get icon;
}

/// @nodoc
class _$ExpenseCategoryCopyWithImpl<$Res, $Val extends ExpenseCategory>
    implements $ExpenseCategoryCopyWith<$Res> {
  _$ExpenseCategoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? totalAmount = null,
    Object? entries = null,
    Object? icon = null,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      entries: null == entries
          ? _value.entries
          : entries // ignore: cast_nullable_to_non_nullable
              as int,
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as CategoryIcon,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $CategoryIconCopyWith<$Res> get icon {
    return $CategoryIconCopyWith<$Res>(_value.icon, (value) {
      return _then(_value.copyWith(icon: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_ExpenseCategoryCopyWith<$Res>
    implements $ExpenseCategoryCopyWith<$Res> {
  factory _$$_ExpenseCategoryCopyWith(
          _$_ExpenseCategory value, $Res Function(_$_ExpenseCategory) then) =
      __$$_ExpenseCategoryCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String title, double totalAmount, int entries, CategoryIcon icon});

  @override
  $CategoryIconCopyWith<$Res> get icon;
}

/// @nodoc
class __$$_ExpenseCategoryCopyWithImpl<$Res>
    extends _$ExpenseCategoryCopyWithImpl<$Res, _$_ExpenseCategory>
    implements _$$_ExpenseCategoryCopyWith<$Res> {
  __$$_ExpenseCategoryCopyWithImpl(
      _$_ExpenseCategory _value, $Res Function(_$_ExpenseCategory) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? totalAmount = null,
    Object? entries = null,
    Object? icon = null,
  }) {
    return _then(_$_ExpenseCategory(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      entries: null == entries
          ? _value.entries
          : entries // ignore: cast_nullable_to_non_nullable
              as int,
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as CategoryIcon,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_ExpenseCategory implements _ExpenseCategory {
  const _$_ExpenseCategory(
      {required this.title,
      this.totalAmount = 0.0,
      this.entries = 0,
      required this.icon});

  factory _$_ExpenseCategory.fromJson(Map<String, dynamic> json) =>
      _$$_ExpenseCategoryFromJson(json);

  @override
  final String title;
  @override
  @JsonKey()
  final double totalAmount;
  @override
  @JsonKey()
  final int entries;
  @override
  final CategoryIcon icon;

  @override
  String toString() {
    return 'ExpenseCategory(title: $title, totalAmount: $totalAmount, entries: $entries, icon: $icon)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ExpenseCategory &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.entries, entries) || other.entries == entries) &&
            (identical(other.icon, icon) || other.icon == icon));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, title, totalAmount, entries, icon);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ExpenseCategoryCopyWith<_$_ExpenseCategory> get copyWith =>
      __$$_ExpenseCategoryCopyWithImpl<_$_ExpenseCategory>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ExpenseCategoryToJson(
      this,
    );
  }
}

abstract class _ExpenseCategory implements ExpenseCategory {
  const factory _ExpenseCategory(
      {required final String title,
      final double totalAmount,
      final int entries,
      required final CategoryIcon icon}) = _$_ExpenseCategory;

  factory _ExpenseCategory.fromJson(Map<String, dynamic> json) =
      _$_ExpenseCategory.fromJson;

  @override
  String get title;
  @override
  double get totalAmount;
  @override
  int get entries;
  @override
  CategoryIcon get icon;
  @override
  @JsonKey(ignore: true)
  _$$_ExpenseCategoryCopyWith<_$_ExpenseCategory> get copyWith =>
      throw _privateConstructorUsedError;
}
