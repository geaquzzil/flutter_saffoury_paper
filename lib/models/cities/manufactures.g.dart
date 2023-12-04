// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manufactures.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Manufacture _$ManufactureFromJson(Map<String, dynamic> json) => Manufacture()
  ..iD = ViewAbstractPermissions.convertToMinusOneIfNotFound(json['iD'])
  ..name = BaseWithNameString.intFromString(json['name']);

Map<String, dynamic> _$ManufactureToJson(Manufacture instance) =>
    <String, dynamic>{
      'iD': instance.iD,
      'delete': instance.delete,
      'name': instance.name,
    };
