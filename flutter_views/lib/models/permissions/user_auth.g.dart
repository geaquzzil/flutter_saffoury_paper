// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_auth.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthUser<T> _$AuthUserFromJson<T>(Map<String, dynamic> json) {
  return AuthUser<T>()
    ..iD = json['iD'] as String
    ..login = json['login'] as bool?
    ..permission = json['permission'] as bool?
    ..response = json['response'] as int?
    ..phone = json['phone'] as String?
    ..password = json['password'] as String?;
}

Map<String, dynamic> _$AuthUserToJson<T>(AuthUser<T> instance) =>
    <String, dynamic>{
      'iD': instance.iD,
      'login': instance.login,
      'permission': instance.permission,
      'response': instance.response,
      'phone': instance.phone,
      'password': instance.password,
    };
