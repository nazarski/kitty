// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'category_icon.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

CategoryIcon _$CategoryIconFromJson(Map<String, dynamic> json) {
  return _CategoryIcon.fromJson(json);
}

/// @nodoc
mixin _$CategoryIcon {
  String get pathToIcon => throw _privateConstructorUsedError;
  String get color => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CategoryIconCopyWith<CategoryIcon> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategoryIconCopyWith<$Res> {
  factory $CategoryIconCopyWith(
          CategoryIcon value, $Res Function(CategoryIcon) then) =
      _$CategoryIconCopyWithImpl<$Res, CategoryIcon>;
  @useResult
  $Res call({String pathToIcon, String color});
}

/// @nodoc
class _$CategoryIconCopyWithImpl<$Res, $Val extends CategoryIcon>
    implements $CategoryIconCopyWith<$Res> {
  _$CategoryIconCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pathToIcon = null,
    Object? color = null,
  }) {
    return _then(_value.copyWith(
      pathToIcon: null == pathToIcon
          ? _value.pathToIcon
          : pathToIcon // ignore: cast_nullable_to_non_nullable
              as String,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_CategoryIconCopyWith<$Res>
    implements $CategoryIconCopyWith<$Res> {
  factory _$$_CategoryIconCopyWith(
          _$_CategoryIcon value, $Res Function(_$_CategoryIcon) then) =
      __$$_CategoryIconCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String pathToIcon, String color});
}

/// @nodoc
class __$$_CategoryIconCopyWithImpl<$Res>
    extends _$CategoryIconCopyWithImpl<$Res, _$_CategoryIcon>
    implements _$$_CategoryIconCopyWith<$Res> {
  __$$_CategoryIconCopyWithImpl(
      _$_CategoryIcon _value, $Res Function(_$_CategoryIcon) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pathToIcon = null,
    Object? color = null,
  }) {
    return _then(_$_CategoryIcon(
      pathToIcon: null == pathToIcon
          ? _value.pathToIcon
          : pathToIcon // ignore: cast_nullable_to_non_nullable
              as String,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_CategoryIcon implements _CategoryIcon {
  const _$_CategoryIcon({required this.pathToIcon, required this.color});

  factory _$_CategoryIcon.fromJson(Map<String, dynamic> json) =>
      _$$_CategoryIconFromJson(json);

  @override
  final String pathToIcon;
  @override
  final String color;

  @override
  String toString() {
    return 'CategoryIcon(pathToIcon: $pathToIcon, color: $color)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_CategoryIcon &&
            (identical(other.pathToIcon, pathToIcon) ||
                other.pathToIcon == pathToIcon) &&
            (identical(other.color, color) || other.color == color));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, pathToIcon, color);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_CategoryIconCopyWith<_$_CategoryIcon> get copyWith =>
      __$$_CategoryIconCopyWithImpl<_$_CategoryIcon>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_CategoryIconToJson(
      this,
    );
  }
}

abstract class _CategoryIcon implements CategoryIcon {
  const factory _CategoryIcon(
      {required final String pathToIcon,
      required final String color}) = _$_CategoryIcon;

  factory _CategoryIcon.fromJson(Map<String, dynamic> json) =
      _$_CategoryIcon.fromJson;

  @override
  String get pathToIcon;
  @override
  String get color;
  @override
  @JsonKey(ignore: true)
  _$$_CategoryIconCopyWith<_$_CategoryIcon> get copyWith =>
      throw _privateConstructorUsedError;
}
