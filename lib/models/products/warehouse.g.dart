// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'warehouse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Warehouse _$WarehouseFromJson(Map<String, dynamic> json) => Warehouse()
  ..iD = json['iD'] as int
  ..delete = json['delete'] as bool?
  ..name = BaseWithNameString.intFromString(json['name']);

Map<String, dynamic> _$WarehouseToJson(Warehouse instance) => <String, dynamic>{
      'iD': instance.iD,
      'delete': instance.delete,
      'name': instance.name,
    };
