// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'products.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) {
  return Product()
    ..iD = json['iD'] as String
    ..products_types = json['products_types'] == null
        ? null
        : ProductType.fromJson(json['products_types'] as Map<String, dynamic>)
    ..thisIsATest = json['thisIsATest'] as String?
    ..sizes = json['sizes'] == null
        ? null
        : Size.fromJson(json['sizes'] as Map<String, dynamic>)
    ..date = json['date'] as String?
    ..comments = json['comments'] as String?
    ..barcode = json['barcode'] as String?
    ..products_count = json['products_count'] as String?
    ..pending_reservation_invoice =
        (json['pending_reservation_invoice'] as num?)?.toDouble()
    ..cut_request_quantity = (json['cut_request_quantity'] as num?)?.toDouble();
}

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'iD': instance.iD,
      'products_types': instance.products_types?.toJson(),
      'thisIsATest': instance.thisIsATest,
      'sizes': instance.sizes?.toJson(),
      'date': instance.date,
      'comments': instance.comments,
      'barcode': instance.barcode,
      'products_count': instance.products_count,
      'pending_reservation_invoice': instance.pending_reservation_invoice,
      'cut_request_quantity': instance.cut_request_quantity,
    };
