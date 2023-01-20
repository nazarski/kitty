import 'package:freezed_annotation/freezed_annotation.dart';

part 'entry_date.freezed.dart';
part 'entry_date.g.dart';
@freezed
class EntryDate with _$EntryDate{
  const factory EntryDate({
    required int expenseId,
    required DateTime dateTime,
  }) = _EntryDate;
  factory EntryDate.fromJson(Map<String, dynamic> json)=> _$EntryDateFromJson(json);
}