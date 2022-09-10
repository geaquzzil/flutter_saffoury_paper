// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'products.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product()
  ..iD = json['iD'] as int
  ..status = json['status']
  ..date = json['date'] as String?
  ..sheets = json['sheets'] as int?
  ..barcode = json['barcode'] as String?
  ..fiberLines = json['fiberLines'] as String?
  ..comments = json['comments'] as String?
  ..pending_reservation_invoice =
      (json['pending_reservation_invoice'] as num?)?.toDouble()
  ..pending_cut_requests = (json['pending_cut_requests'] as num?)?.toDouble()
  ..products_types = json['products_types'] == null
      ? null
      : ProductType.fromJson(json['products_types'] as Map<String, dynamic>)
  ..customs_declarations = json['customs_declarations'] == null
      ? null
      : CustomsDeclaration.fromJson(
          json['customs_declarations'] as Map<String, dynamic>)
  ..countries_manufactures = json['countries_manufactures'] == null
      ? null
      : CountryManufacture.fromJson(
          json['countries_manufactures'] as Map<String, dynamic>)
  ..sizes = json['sizes'] == null
      ? null
      : Size.fromJson(json['sizes'] as Map<String, dynamic>)
  ..gsms = json['gsms'] == null
      ? null
      : GSM.fromJson(json['gsms'] as Map<String, dynamic>)
  ..qualities = json['qualities'] == null
      ? null
      : Quality.fromJson(json['qualities'] as Map<String, dynamic>)
  ..grades = json['grades'] == null
      ? null
      : Grades.fromJson(json['grades'] as Map<String, dynamic>)
  ..products_colors = json['products_colors'] == null
      ? null
      : ProductsColor.fromJson(json['products_colors'] as Map<String, dynamic>)
  ..inStock = (json['inStock'] as List<dynamic>?)
      ?.map((e) => Stocks.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'iD': instance.iD,
      'status': instance.status,
      'date': instance.date,
      'sheets': instance.sheets,
      'barcode': instance.barcode,
      'fiberLines': instance.fiberLines,
      'comments': instance.comments,
      'pending_reservation_invoice': instance.pending_reservation_invoice,
      'pending_cut_requests': instance.pending_cut_requests,
      'products_types': instance.products_types?.toJson(),
      'customs_declarations': instance.customs_declarations?.toJson(),
      'countries_manufactures': instance.countries_manufactures?.toJson(),
      'sizes': instance.sizes?.toJson(),
      'gsms': instance.gsms?.toJson(),
      'qualities': instance.qualities?.toJson(),
      'grades': instance.grades?.toJson(),
      'products_colors': instance.products_colors?.toJson(),
      'inStock': instance.inStock?.map((e) => e.toJson()).toList(),
    };
