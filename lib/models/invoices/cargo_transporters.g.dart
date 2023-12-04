// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cargo_transporters.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CargoTransporter _$CargoTransporterFromJson(Map<String, dynamic> json) =>
    CargoTransporter()
      ..iD = ViewAbstractPermissions.convertToMinusOneIfNotFound(json['iD'])
      ..name = json['name'] as String?
      ..phone = json['phone'] as String?
      ..maxWeight = (json['maxWeight'] as num?)?.toDouble()
      ..carNumber = CargoTransporter.intFromString(json['carNumber'])
      ..governorates = json['governorates'] == null
          ? null
          : Governorate.fromJson(json['governorates'] as Map<String, dynamic>);

Map<String, dynamic> _$CargoTransporterToJson(CargoTransporter instance) =>
    <String, dynamic>{
      'iD': instance.iD,
      'delete': instance.delete,
      'name': instance.name,
      'phone': instance.phone,
      'maxWeight': instance.maxWeight,
      'carNumber': instance.carNumber,
      'governorates': instance.governorates?.toJson(),
    };
