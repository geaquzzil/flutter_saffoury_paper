// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'governorates.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Governorate _$GovernorateFromJson(Map<String, dynamic> json) =>
    Governorate()
      ..iD = ViewAbstractPermissions.convertToMinusOneIfNotFound(json['iD'])
      ..serverStatus = json['serverStatus'] as String?
      ..fb_edit = json['fb_edit'] as String?
      ..name = BaseWithNameString.intFromString(json['name']);

Map<String, dynamic> _$GovernorateToJson(Governorate instance) =>
    <String, dynamic>{
      'iD': instance.iD,
      'delete': instance.delete,
      'name': instance.name,
    };
