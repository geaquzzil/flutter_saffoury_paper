// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'countries.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Country _$CountryFromJson(Map<String, dynamic> json) =>
    Country()
      ..iD = convertToMinusOneIfNotFound(json['iD'])
      ..serverStatus = json['serverStatus'] as String?
      ..fb_edit = json['fb_edit'] as String?
      ..name = intFromString(json['name']);

Map<String, dynamic> _$CountryToJson(Country instance) => <String, dynamic>{
  'iD': instance.iD,
  'delete': instance.delete,
  'name': instance.name,
};
