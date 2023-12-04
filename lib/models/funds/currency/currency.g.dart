// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Currency _$CurrencyFromJson(Map<String, dynamic> json) => Currency()
  ..iD = ViewAbstractPermissions.convertToMinusOneIfNotFound(json['iD'])
  ..name = BaseWithNameString.intFromString(json['name'])
  ..nameAr = json['nameAr'] as String?;

Map<String, dynamic> _$CurrencyToJson(Currency instance) => <String, dynamic>{
      'iD': instance.iD,
      'delete': instance.delete,
      'name': instance.name,
      'nameAr': instance.nameAr,
    };
