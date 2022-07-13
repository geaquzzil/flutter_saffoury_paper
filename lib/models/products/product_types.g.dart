// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_types.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductType _$ProductTypeFromJson(Map<String, dynamic> json) {
  return ProductType()
    ..iD = json['iD'] as int
    ..grades = json['grades'] == null
        ? null
        : Grades.fromJson(json['grades'] as Map<String, dynamic>)
    ..image = json['image'] as String?
    ..name = json['name'] as String?
    ..comments = json['comments'] as String?
    ..purchasePrice = (json['purchasePrice'] as num?)?.toDouble()
    ..sellPrice = (json['sellPrice'] as num?)?.toDouble();
}

Map<String, dynamic> _$ProductTypeToJson(ProductType instance) =>
    <String, dynamic>{
      'iD': instance.iD,
      'grades': instance.grades?.toJson(),
      'image': instance.image,
      'name': instance.name,
      'comments': instance.comments,
      'purchasePrice': instance.purchasePrice,
      'sellPrice': instance.sellPrice,
    };
