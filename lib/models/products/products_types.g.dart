// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'products_types.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductType _$ProductTypeFromJson(Map<String, dynamic> json) =>
    ProductType()
      ..iD = ViewAbstractPermissions.convertToMinusOneIfNotFound(json['iD'])
      ..serverStatus = json['serverStatus'] as String?
      ..fb_edit = json['fb_edit'] as String?
      ..name = json['name'] as String?
      ..unit = $enumDecodeNullable(_$ProductTypeUnitEnumMap, json['unit'])
      ..purchasePrice = (json['purchasePrice'] as num?)?.toDouble()
      ..sellPrice = (json['sellPrice'] as num?)?.toDouble()
      ..image = json['image'] as String?
      ..comments = ViewAbstractPermissions.convertToStringFromString(json['comments'])
      ..availability = (json['availability'] as num?)?.toDouble()
      ..grades =
          json['grades'] == null
              ? null
              : Grades.fromJson(json['grades'] as Map<String, dynamic>)
      ..products =
          (json['products'] as List<dynamic>?)
              ?.map((e) => Product.fromJson(e as Map<String, dynamic>))
              .toList()
      ..products_count = (json['products_count'] as num?)?.toInt();

Map<String, dynamic> _$ProductTypeToJson(ProductType instance) =>
    <String, dynamic>{
      'iD': instance.iD,
      'delete': instance.delete,
      'name': instance.name,
      'unit': _$ProductTypeUnitEnumMap[instance.unit],
      'purchasePrice': instance.purchasePrice,
      'sellPrice': instance.sellPrice,
      'image': instance.image,
      'comments': instance.comments,
      'availability': instance.availability,
      'grades': instance.grades?.toJson(),
      'products': instance.products?.map((e) => e.toJson()).toList(),
      'products_count': instance.products_count,
      'requestAvailablity': instance.requestAvailablity,
    };

const _$ProductTypeUnitEnumMap = {
  ProductTypeUnit.KG: 'KG',
  ProductTypeUnit.Sheet: 'Sheet',
  ProductTypeUnit.Ream: 'Ream',
};
