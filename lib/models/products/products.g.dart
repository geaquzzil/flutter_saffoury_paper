// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'products.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product()
  ..iD = ViewAbstractPermissions.convertToMinusOneIfNotFound(json['iD'])
  ..status = $enumDecodeNullable(_$ProductStatusEnumMap, json['status'])
  ..date = json['date'] as String?
  ..sheets = (json['sheets'] as num?)?.toInt()
  ..barcode = Product.intFromString(json['barcode'])
  ..fiberLines = json['fiberLines'] as String?
  ..comments = json['comments'] as String?
  ..pending_reservation_invoice =
      (json['pending_reservation_invoice'] as num?)?.toDouble()
  ..pending_cut_requests = (json['pending_cut_requests'] as num?)?.toDouble()
  ..cut_request_quantity = (json['cut_request_quantity'] as num?)?.toDouble()
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
      : ProductSize.fromJson(json['sizes'] as Map<String, dynamic>)
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
      .toList()
  ..products = json['products'] == null
      ? null
      : Product.fromJson(json['products'] as Map<String, dynamic>)
  ..cut_requests = (json['cut_requests'] as List<dynamic>?)
      ?.map((e) => CutRequest.fromJson(e as Map<String, dynamic>))
      .toList()
  ..cut_requests_count = (json['cut_requests_count'] as num?)?.toInt()
  ..order_refunds_order_details =
      (json['order_refunds_order_details'] as List<dynamic>?)
          ?.map((e) => OrderRefundDetails.fromJson(e as Map<String, dynamic>))
          .toList()
  ..order_refunds_order_details_count =
      (json['order_refunds_order_details_count'] as num?)?.toInt()
  ..orders_details = (json['orders_details'] as List<dynamic>?)
      ?.map((e) => OrderDetails.fromJson(e as Map<String, dynamic>))
      .toList()
  ..orders_details_count = (json['orders_details_count'] as num?)?.toInt()
  ..products_inputs_details =
      (json['products_inputs_details'] as List<dynamic>?)
          ?.map((e) => ProductInputDetails.fromJson(e as Map<String, dynamic>))
          .toList()
  ..products_inputs_details_count =
      (json['products_inputs_details_count'] as num?)?.toInt()
  ..products_outputs_details =
      (json['products_outputs_details'] as List<dynamic>?)
          ?.map((e) => ProductOutputDetails.fromJson(e as Map<String, dynamic>))
          .toList()
  ..products_outputs_details_count =
      (json['products_outputs_details_count'] as num?)?.toInt()
  ..purchases_details = (json['purchases_details'] as List<dynamic>?)
      ?.map((e) => PurchasesDetails.fromJson(e as Map<String, dynamic>))
      .toList()
  ..purchases_details_count = (json['purchases_details_count'] as num?)?.toInt()
  ..purchases_refunds_purchases_details =
      (json['purchases_refunds_purchases_details'] as List<dynamic>?)
          ?.map(
              (e) => PurchasesRefundDetails.fromJson(e as Map<String, dynamic>))
          .toList()
  ..purchases_refunds_purchases_details_count =
      (json['purchases_refunds_purchases_details_count'] as num?)?.toInt()
  ..reservation_invoice_details = (json['reservation_invoice_details']
          as List<dynamic>?)
      ?.map(
          (e) => ReservationInvoiceDetails.fromJson(e as Map<String, dynamic>))
      .toList()
  ..reservation_invoice_details_count =
      (json['reservation_invoice_details_count'] as num?)?.toInt()
  ..transfers_details = (json['transfers_details'] as List<dynamic>?)
      ?.map((e) => TransfersDetails.fromJson(e as Map<String, dynamic>))
      .toList()
  ..transfers_details_count =
      (json['transfers_details_count'] as num?)?.toInt();

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'iD': instance.iD,
      'delete': instance.delete,
      'status': _$ProductStatusEnumMap[instance.status],
      'date': instance.date,
      'sheets': instance.sheets,
      'barcode': instance.barcode,
      'fiberLines': instance.fiberLines,
      'comments': instance.comments,
      'pending_reservation_invoice': instance.pending_reservation_invoice,
      'pending_cut_requests': instance.pending_cut_requests,
      'cut_request_quantity': instance.cut_request_quantity,
      'products_types': instance.products_types?.toJson(),
      'customs_declarations': instance.customs_declarations?.toJson(),
      'countries_manufactures': instance.countries_manufactures?.toJson(),
      'sizes': instance.sizes?.toJson(),
      'gsms': instance.gsms?.toJson(),
      'qualities': instance.qualities?.toJson(),
      'grades': instance.grades?.toJson(),
      'products_colors': instance.products_colors?.toJson(),
      'inStock': instance.inStock?.map((e) => e.toJson()).toList(),
      'products': instance.products?.toJson(),
      'cut_requests': instance.cut_requests?.map((e) => e.toJson()).toList(),
      'cut_requests_count': instance.cut_requests_count,
      'order_refunds_order_details':
          instance.order_refunds_order_details?.map((e) => e.toJson()).toList(),
      'order_refunds_order_details_count':
          instance.order_refunds_order_details_count,
      'orders_details':
          instance.orders_details?.map((e) => e.toJson()).toList(),
      'orders_details_count': instance.orders_details_count,
      'products_inputs_details':
          instance.products_inputs_details?.map((e) => e.toJson()).toList(),
      'products_inputs_details_count': instance.products_inputs_details_count,
      'products_outputs_details':
          instance.products_outputs_details?.map((e) => e.toJson()).toList(),
      'products_outputs_details_count': instance.products_outputs_details_count,
      'purchases_details':
          instance.purchases_details?.map((e) => e.toJson()).toList(),
      'purchases_details_count': instance.purchases_details_count,
      'purchases_refunds_purchases_details': instance
          .purchases_refunds_purchases_details
          ?.map((e) => e.toJson())
          .toList(),
      'purchases_refunds_purchases_details_count':
          instance.purchases_refunds_purchases_details_count,
      'reservation_invoice_details':
          instance.reservation_invoice_details?.map((e) => e.toJson()).toList(),
      'reservation_invoice_details_count':
          instance.reservation_invoice_details_count,
      'transfers_details':
          instance.transfers_details?.map((e) => e.toJson()).toList(),
      'transfers_details_count': instance.transfers_details_count,
    };

const _$ProductStatusEnumMap = {
  ProductStatus.NONE: 'NONE',
  ProductStatus.PENDING: 'PENDING',
  ProductStatus.RETURNED: 'RETURNED',
  ProductStatus.WASTED: 'WASTED',
};
