// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResponseMessage<T> _$ResponseMessageFromJson<T>(Map<String, dynamic> json) {
  return ResponseMessage<T>()
    ..iD = json['iD'] as String
    ..login = json['login'] as bool?
    ..permission = json['permission'] as bool?
    ..response = json['response'] as int?;
}

Map<String, dynamic> _$ResponseMessageToJson<T>(ResponseMessage<T> instance) =>
    <String, dynamic>{
      'iD': instance.iD,
      'login': instance.login,
      'permission': instance.permission,
      'response': instance.response,
    };
