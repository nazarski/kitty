import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User{
const factory User({
  required String name,
  required String email,
  required String pin,
  required bool biometrics,
  required String avatarLocalPath,
}) = _User;
factory User.fromJson(Map<String, dynamic> json)=> _$UserFromJson(json);
}