// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_auth.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthUser<T> _$AuthUserFromJson<T>(Map<String, dynamic> json) => AuthUser<T>()
  ..iD = ViewAbstractPermissions.convertToMinusOneIfNotFound(json['iD'])
  ..phone = json['phone'] as String?
  ..token = json['token'] as String?
  ..password = json['password'] as String?
  ..userlevels = json['userlevels'] == null
      ? null
      : PermissionLevelAbstract.fromJson(
          json['userlevels'] as Map<String, dynamic>)
  ..setting = json['setting'] == null
      ? null
      : Setting.fromJson(json['setting'] as Map<String, dynamic>)
  ..dealers = json['dealers'] == null
      ? null
      : Dealers.fromJson(json['dealers'] as Map<String, dynamic>);

Map<String, dynamic> _$AuthUserToJson<T>(AuthUser<T> instance) =>
    <String, dynamic>{
      'iD': instance.iD,
      'delete': instance.delete,
      'phone': instance.phone,
      'token': instance.token,
      'password': instance.password,
      'userlevels': instance.userlevels?.toJson(),
      'setting': instance.setting?.toJson(),
      'dealers': instance.dealers?.toJson(),
    };
