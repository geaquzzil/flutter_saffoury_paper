// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qualities.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Quality _$QualityFromJson(Map<String, dynamic> json) => Quality()
  ..iD = json['iD'] as int
  ..name = json['name'] as String?
  ..products = (json['products'] as List<dynamic>?)
      ?.map((e) => Product.fromJson(e as Map<String, dynamic>))
      .toList()
  ..products_count = json['products_count'] as int?;

Map<String, dynamic> _$QualityToJson(Quality instance) => <String, dynamic>{
      'iD': instance.iD,
      'name': instance.name,
      'products': instance.products?.map((e) => e.toJson()).toList(),
      'products_count': instance.products_count,
    };
