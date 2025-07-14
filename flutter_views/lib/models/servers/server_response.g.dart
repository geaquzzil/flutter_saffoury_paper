// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServerResponse _$ServerResponseFromJson(Map<String, dynamic> json) =>
    ServerResponse()
      ..message = json['message'] as String?
      ..className = json['className'] as String?
      ..trace = json['trace'] as String?
      ..status = json['status'] as String?
      ..code = (json['code'] as num?)?.toInt()
      ..requestCount = (json['requestCount'] as num?)?.toInt()
      ..requestIDS = (json['requestIDS'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList()
      ..serverCount = (json['serverCount'] as num?)?.toInt()
      ..serverStatus = json['serverStatus'] as bool?
      ..activated = (json['activated'] as num?)?.toInt()
      ..permission = json['permission'] as bool?
      ..login = json['login'] as bool?
      ..error = json['error'] as bool?;

Map<String, dynamic> _$ServerResponseToJson(ServerResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'className': instance.className,
      'trace': instance.trace,
      'status': instance.status,
      'code': instance.code,
      'requestCount': instance.requestCount,
      'requestIDS': instance.requestIDS,
      'serverCount': instance.serverCount,
      'serverStatus': instance.serverStatus,
      'activated': instance.activated,
      'permission': instance.permission,
      'login': instance.login,
      'error': instance.error,
    };
