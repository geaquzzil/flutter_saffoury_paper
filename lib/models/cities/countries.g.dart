// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'countries.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Country _$CountryFromJson(Map<String, dynamic> json) => Country()
  ..iD = json['iD'] as int
  ..delete = json['delete'] as bool?
  ..name = BaseWithNameString.intFromString(json['name']);

Map<String, dynamic> _$CountryToJson(Country instance) => <String, dynamic>{
      'iD': instance.iD,
      'delete': instance.delete,
      'name': instance.name,
    };
