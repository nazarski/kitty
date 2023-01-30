// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_User _$$_UserFromJson(Map<String, dynamic> json) => _$_User(
      name: json['name'] as String,
      email: json['email'] as String,
      pin: json['pin'] as String,
      biometrics: json['biometrics'] as bool,
      avatarLocalPath: json['avatarLocalPath'] as String,
    );

Map<String, dynamic> _$$_UserToJson(_$_User instance) => <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'pin': instance.pin,
      'biometrics': instance.biometrics,
      'avatarLocalPath': instance.avatarLocalPath,
    };
