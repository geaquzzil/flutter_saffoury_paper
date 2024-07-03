// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sizes.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductSize _$ProductSizeFromJson(Map<String, dynamic> json) => ProductSize()
  ..iD = ViewAbstractPermissions.convertToMinusOneIfNotFound(json['iD'])
  ..width = (json['width'] as num?)?.toInt()
  ..length = (json['length'] as num?)?.toInt();

Map<String, dynamic> _$ProductSizeToJson(ProductSize instance) =>
    <String, dynamic>{
      'iD': instance.iD,
      'delete': instance.delete,
      'width': instance.width,
      'length': instance.length,
    };
