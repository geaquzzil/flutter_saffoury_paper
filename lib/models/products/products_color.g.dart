// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'products_color.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductsColor _$ProductsColorFromJson(Map<String, dynamic> json) =>
    ProductsColor()
      ..iD = json['iD'] as int
      ..searchByAutoCompleteTextInput =
          json['searchByAutoCompleteTextInput'] as String?
      ..delete = json['delete'] as bool?
      ..top = json['top'] as String?
      ..middle = json['middle'] as String?
      ..back = json['back'] as String?;

Map<String, dynamic> _$ProductsColorToJson(ProductsColor instance) =>
    <String, dynamic>{
      'iD': instance.iD,
      'searchByAutoCompleteTextInput': instance.searchByAutoCompleteTextInput,
      'delete': instance.delete,
      'top': instance.top,
      'middle': instance.middle,
      'back': instance.back,
    };
