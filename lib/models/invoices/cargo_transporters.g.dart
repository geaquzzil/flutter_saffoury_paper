// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cargo_transporters.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CargoTransporter _$CargoTransporterFromJson(Map<String, dynamic> json) =>
    CargoTransporter()
      ..iD = convertToMinusOneIfNotFound(json['iD'])
      ..serverStatus = json['serverStatus'] as String?
      ..fb_edit = json['fb_edit'] as String?
      ..name = json['name'] as String?
      ..phone = (json['phone'] as num?)?.toInt()
      ..maxWeight = (json['maxWeight'] as num?)?.toDouble()
      ..carNumber = intFromString(json['carNumber'])
      ..governorates =
          json['governorates'] == null
              ? null
              : Governorate.fromJson(
                json['governorates'] as Map<String, dynamic>,
              );

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
