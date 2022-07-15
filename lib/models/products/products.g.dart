// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'products.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product()
  ..iD = json['iD'] as int
  ..products_types = json['products_types'] == null
      ? null
      : ProductType.fromJson(json['products_types'] as Map<String, dynamic>)
  ..sizes = json['sizes'] == null
      ? null
      : Size.fromJson(json['sizes'] as Map<String, dynamic>)
  ..grades = json['grades'] == null
      ? null
      : Grades.fromJson(json['grades'] as Map<String, dynamic>)
  ..products_colors = json['products_colors'] == null
      ? null
      : ProductsColor.fromJson(json['products_colors'] as Map<String, dynamic>)
  ..date = json['date'] as String?
  ..comments = json['comments'] as String?
  ..barcode = json['barcode'] as String?;

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'iD': instance.iD,
      'products_types': instance.products_types?.toJson(),
      'sizes': instance.sizes?.toJson(),
      'grades': instance.grades?.toJson(),
      'products_colors': instance.products_colors?.toJson(),
      'date': instance.date,
      'comments': instance.comments,
      'barcode': instance.barcode,
    };
