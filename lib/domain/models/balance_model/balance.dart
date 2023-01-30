import 'package:freezed_annotation/freezed_annotation.dart';

part 'balance.freezed.dart';
part 'balance.g.dart';
@freezed
class Balance with _$Balance{
  const factory Balance({
    required int income,
    required int expenses,
    required int balance,
  }) = _Balance;
  factory Balance.fromJson(Map<String, dynamic> json)=> _$BalanceFromJson(json);
}