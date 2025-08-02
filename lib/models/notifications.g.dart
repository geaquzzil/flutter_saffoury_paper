// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationsClinet _$NotificationsClinetFromJson(Map<String, dynamic> json) =>
    NotificationsClinet()
      ..iD = convertToMinusOneIfNotFound(json['iD'])
      ..serverStatus = json['serverStatus'] as String?
      ..fb_edit = json['fb_edit'] as String?
      ..json = json['json'] as String?
      ..tokens = json['tokens'] as String?
      ..date = json['date'] as String?;

Map<String, dynamic> _$NotificationsClinetToJson(
  NotificationsClinet instance,
) => <String, dynamic>{
  'iD': instance.iD,
  'delete': instance.delete,
  'json': instance.json,
  'tokens': instance.tokens,
  'date': instance.date,
};
