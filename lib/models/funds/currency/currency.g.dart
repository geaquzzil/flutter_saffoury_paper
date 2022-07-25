// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Currency _$CurrencyFromJson(Map<String, dynamic> json) => Currency()
  ..iD = json['iD'] as int
  ..name = json['name'] as String?
  ..nameAr = json['nameAr'] as String?;

Map<String, dynamic> _$CurrencyToJson(Currency instance) => <String, dynamic>{
      'iD': instance.iD,
      'name': instance.name,
      'nameAr': instance.nameAr,
    };
