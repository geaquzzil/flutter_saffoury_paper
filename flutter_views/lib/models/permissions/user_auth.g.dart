// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_auth.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthUser<T> _$AuthUserFromJson<T>(Map<String, dynamic> json) => AuthUser<T>()
  ..iD = ViewAbstractPermissions.convertToMinusOneIfNotFound(json['iD'])
  ..serverStatus = json['serverStatus'] as String?
  ..fb_edit = json['fb_edit'] as String?
  ..phone = (json['phone'] as num?)?.toInt()
  ..password = json['password'] as String?
  ..token = json['token'] as String?
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
      'password': instance.password,
      'token': instance.token,
      'userlevels': instance.userlevels?.toJson(),
      'setting': instance.setting?.toJson(),
      'dealers': instance.dealers?.toJson(),
    };
