// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'warehouse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Warehouse _$WarehouseFromJson(Map<String, dynamic> json) =>
    Warehouse()
      ..iD = ViewAbstractPermissions.convertToMinusOneIfNotFound(json['iD'])
      ..serverStatus = json['serverStatus'] as String?
      ..fb_edit = json['fb_edit'] as String?
      ..name = BaseWithNameString.intFromString(json['name']);

Map<String, dynamic> _$WarehouseToJson(Warehouse instance) => <String, dynamic>{
  'iD': instance.iD,
  'delete': instance.delete,
  'name': instance.name,
};
