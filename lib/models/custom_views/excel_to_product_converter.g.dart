// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'excel_to_product_converter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExcelToProductConverter _$ExcelToProductConverterFromJson(
        Map<String, dynamic> json) =>
    ExcelToProductConverter()
      ..iD = ViewAbstractPermissions.convertToMinusOneIfNotFound(json['iD'])
      ..product = json['product'] as String?
      ..quantity = ExcelToProductConverter.convertToDouble(json['quantity']);

Map<String, dynamic> _$ExcelToProductConverterToJson(
        ExcelToProductConverter instance) =>
    <String, dynamic>{
      'iD': instance.iD,
      'delete': instance.delete,
      'product': instance.product,
      'quantity': instance.quantity,
    };
