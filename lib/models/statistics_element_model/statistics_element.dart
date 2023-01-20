import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kitty/models/category_icon_model/category_icon.dart';

part 'statistics_element.freezed.dart';

part 'statistics_element.g.dart';

@freezed
class StatisticsElement with _$StatisticsElement {
  @JsonSerializable(explicitToJson: true)
  const factory StatisticsElement({
    required String categoryTitle,
    required int countOfEntries,
    required int totalAmount,
    required double monthShare,
    required CategoryIcon icon,
  }) = _StatisticsElement;

  factory StatisticsElement.fromJson(Map<String, dynamic> json) =>
      _$StatisticsElementFromJson(json);
}
