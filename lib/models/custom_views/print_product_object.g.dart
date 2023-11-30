// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'print_product_object.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductPrintObject _$ProductPrintObjectFromJson(Map<String, dynamic> json) =>
    ProductPrintObject(
      ProductSize.fromJson(json['size'] as Map<String, dynamic>)
    )
      ..iD = json['iD'] as int
      ..description = json['description'] as String
      ..comments = json['comments'] as String
      ..customer = json['customer'] as String
      ..quantity = (json['quantity'] as num).toDouble()
      ..sheets = (json['sheets'] as num).toDouble();

Map<String, dynamic> _$ProductPrintObjectToJson(ProductPrintObject instance) =>
    <String, dynamic>{
      'iD': instance.iD,
      'delete': instance.delete,
      'description': instance.description,
      'gsm': instance.gsm,
      'size': instance.size.toJson(),
      'comments': instance.comments,
      'customer': instance.customer,
      'quantity': instance.quantity,
      'sheets': instance.sheets,
    };
