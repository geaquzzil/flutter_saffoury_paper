// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sizes.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductSize _$ProductSizeFromJson(Map<String, dynamic> json) =>
    ProductSize()
      ..iD = convertToMinusOneIfNotFound(json['iD'])
      ..serverStatus = json['serverStatus'] as String?
      ..fb_edit = json['fb_edit'] as String?
      ..width = (json['width'] as num?)?.toInt()
      ..length = (json['length'] as num?)?.toInt();

Map<String, dynamic> _$ProductSizeToJson(ProductSize instance) =>
    <String, dynamic>{
      'iD': instance.iD,
      'delete': instance.delete,
      'width': instance.width,
      'length': instance.length,
    };
