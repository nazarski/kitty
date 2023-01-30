import 'package:freezed_annotation/freezed_annotation.dart';

part 'entry.freezed.dart';
part 'entry.g.dart';
@freezed
class Entry with _$Entry{
  const factory Entry({
    required int expenseId,
    required String description,
    required int amount,
    required DateTime dateTime,
    required int categoryId,
  }) = _Entry;
  factory Entry.fromJson(Map<String, dynamic> json)=> _$EntryFromJson(json);
}