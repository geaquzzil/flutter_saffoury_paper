// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServerResponse _$ServerResponseFromJson(Map<String, dynamic> json) =>
    ServerResponse()
      ..activated = json['activated'] as int?
      ..permission = json['permission'] as bool?
      ..login = json['login'] as bool?
      ..error = json['error'] as bool?
      ..message = json['message'] as String?
      ..code = json['code'] as int?;

Map<String, dynamic> _$ServerResponseToJson(ServerResponse instance) =>
    <String, dynamic>{
      'activated': instance.activated,
      'permission': instance.permission,
      'login': instance.login,
      'error': instance.error,
      'message': instance.message,
      'code': instance.code,
    };
