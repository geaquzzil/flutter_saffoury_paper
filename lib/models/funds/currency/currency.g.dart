// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Currency _$CurrencyFromJson(Map<String, dynamic> json) => Currency()
  ..iD = json['iD'] as int
  ..searchByAutoCompleteTextInput =
      json['searchByAutoCompleteTextInput'] as String?
  ..delete = json['delete'] as bool?
  ..name = BaseWithNameString.intFromString(json['name'])
  ..nameAr = json['nameAr'] as String?;

Map<String, dynamic> _$CurrencyToJson(Currency instance) => <String, dynamic>{
      'iD': instance.iD,
      'searchByAutoCompleteTextInput': instance.searchByAutoCompleteTextInput,
      'delete': instance.delete,
      'name': instance.name,
      'nameAr': instance.nameAr,
    };
