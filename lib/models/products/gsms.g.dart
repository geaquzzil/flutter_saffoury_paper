// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gsms.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GSM _$GSMFromJson(Map<String, dynamic> json) => GSM()
  ..iD = json['iD'] as int
  ..searchByAutoCompleteTextInput =
      json['searchByAutoCompleteTextInput'] as String?
  ..delete = json['delete'] as bool?
  ..gsm = json['gsm'] as int?
  ..products = (json['products'] as List<dynamic>?)
      ?.map((e) => Product.fromJson(e as Map<String, dynamic>))
      .toList()
  ..products_count = json['products_count'] as int?;

Map<String, dynamic> _$GSMToJson(GSM instance) => <String, dynamic>{
      'iD': instance.iD,
      'searchByAutoCompleteTextInput': instance.searchByAutoCompleteTextInput,
      'delete': instance.delete,
      'gsm': instance.gsm,
      'products': instance.products?.map((e) => e.toJson()).toList(),
      'products_count': instance.products_count,
    };
