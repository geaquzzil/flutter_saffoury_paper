// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_types.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductType _$ProductTypeFromJson(Map<String, dynamic> json) {
  return ProductType()
    ..iD = json['iD'] as String
    ..date = json['date'] as String?
    ..image = json['image'] as String?
    ..name = json['name'] as String?
    ..comments = json['comments'] as String?;
}

Map<String, dynamic> _$ProductTypeToJson(ProductType instance) =>
    <String, dynamic>{
      'iD': instance.iD,
      'date': instance.date,
      'image': instance.image,
      'name': instance.name,
      'comments': instance.comments,
    };
