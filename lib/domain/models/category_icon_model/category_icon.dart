import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_icon.freezed.dart';
part 'category_icon.g.dart';

@freezed
class CategoryIcon with _$CategoryIcon{
  const factory CategoryIcon({
    required int iconId,
    required String localPath,
    required String color,
  }) = _CategoryIcon;
  factory CategoryIcon.fromJson(Map<String, dynamic> json)=> _$CategoryIconFromJson(json);
}