// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'governorates.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Governorate _$GovernorateFromJson(Map<String, dynamic> json) => Governorate()
  ..iD = json['iD'] as int
  ..name = BaseWithNameString.intFromString(json['name']);

Map<String, dynamic> _$GovernorateToJson(Governorate instance) =>
    <String, dynamic>{
      'iD': instance.iD,
      'name': instance.name,
    };
