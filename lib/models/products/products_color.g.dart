// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'products_color.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductsColor _$ProductsColorFromJson(Map<String, dynamic> json) =>
    ProductsColor()
      ..iD = convertToMinusOneIfNotFound(json['iD'])
      ..serverStatus = json['serverStatus'] as String?
      ..fb_edit = json['fb_edit'] as String?
      ..top = json['top'] as String?
      ..middle = json['middle'] as String?
      ..back = json['back'] as String?;

Map<String, dynamic> _$ProductsColorToJson(ProductsColor instance) =>
    <String, dynamic>{
      'iD': instance.iD,
      'delete': instance.delete,
      'top': instance.top,
      'middle': instance.middle,
      'back': instance.back,
    };
