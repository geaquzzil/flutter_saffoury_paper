// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'countries_manufactures.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CountryManufacture _$CountryManufactureFromJson(Map<String, dynamic> json) =>
    CountryManufacture()
      ..iD = json['iD'] as int
      ..delete = json['delete'] as bool?
      ..countries = json['countries'] == null
          ? null
          : Country.fromJson(json['countries'] as Map<String, dynamic>)
      ..manufactures = json['manufactures'] == null
          ? null
          : Manufacture.fromJson(json['manufactures'] as Map<String, dynamic>);

Map<String, dynamic> _$CountryManufactureToJson(CountryManufacture instance) =>
    <String, dynamic>{
      'iD': instance.iD,
      'delete': instance.delete,
      'countries': instance.countries?.toJson(),
      'manufactures': instance.manufactures?.toJson(),
    };
