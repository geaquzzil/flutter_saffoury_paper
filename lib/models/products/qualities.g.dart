// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qualities.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Quality _$QualityFromJson(Map<String, dynamic> json) =>
    Quality()
      ..iD = convertToMinusOneIfNotFound(json['iD'])
      ..serverStatus = json['serverStatus'] as String?
      ..fb_edit = json['fb_edit'] as String?
      ..name = intFromString(json['name'])
      ..products =
          (json['products'] as List<dynamic>?)
              ?.map((e) => Product.fromJson(e as Map<String, dynamic>))
              .toList()
      ..products_count = (json['products_count'] as num?)?.toInt();

Map<String, dynamic> _$QualityToJson(Quality instance) => <String, dynamic>{
  'iD': instance.iD,
  'delete': instance.delete,
  'name': instance.name,
  'products': instance.products?.map((e) => e.toJson()).toList(),
  'products_count': instance.products_count,
};
