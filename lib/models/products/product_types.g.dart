// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_types.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductType _$ProductTypeFromJson(Map<String, dynamic> json) => ProductType()
  ..iD = json['iD'] as int
  ..name = json['name'] as String?
  ..grades = json['grades'] == null
      ? null
      : Grades.fromJson(json['grades'] as Map<String, dynamic>)
  ..unit = $enumDecodeNullable(_$ProductTypeUnitEnumMap, json['unit'])
  ..purchasePrice = (json['purchasePrice'] as num?)?.toDouble()
  ..sellPrice = (json['sellPrice'] as num?)?.toDouble()
  ..image = json['image'] as String?
  ..comments = json['comments'] as String?
  ..availability = (json['availability'] as num?)?.toDouble();

Map<String, dynamic> _$ProductTypeToJson(ProductType instance) =>
    <String, dynamic>{
      'iD': instance.iD,
      'name': instance.name,
      'grades': instance.grades?.toJson(),
      'unit': _$ProductTypeUnitEnumMap[instance.unit],
      'purchasePrice': instance.purchasePrice,
      'sellPrice': instance.sellPrice,
      'image': instance.image,
      'comments': instance.comments,
      'availability': instance.availability,
    };

const _$ProductTypeUnitEnumMap = {
  ProductTypeUnit.KG: 'KG',
  ProductTypeUnit.Sheet: 'Sheet',
};
