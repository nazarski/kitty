
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kitty/domain/models/category_icon_model/category_icon.dart';

part 'entry_category.freezed.dart';
part 'entry_category.g.dart';
@freezed
class EntryCategory with _$EntryCategory{
  @JsonSerializable(explicitToJson: true)
  const factory EntryCategory({
    required int categoryId,
    required String title,
    required String type,
    required int orderNum,
    required CategoryIcon icon,
  }) = _EntryCategory;
  factory EntryCategory.fromJson(Map<String, dynamic> json)=> _$EntryCategoryFromJson(json);
}
