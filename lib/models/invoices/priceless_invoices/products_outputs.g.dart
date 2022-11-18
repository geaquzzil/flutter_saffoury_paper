// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'products_outputs.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductOutput _$ProductOutputFromJson(Map<String, dynamic> json) =>
    ProductOutput()
      ..iD = json['iD'] as int
      ..delete = json['delete'] as bool?
      ..TermsID = json['TermsID'] as int?
      ..date = json['date'] as String?
      ..billNo = json['billNo'] as String?
      ..comments = json['comments'] as String?
      ..employees = json['employees'] == null
          ? null
          : Employee.fromJson(json['employees'] as Map<String, dynamic>)
      ..customers = json['customers'] == null
          ? null
          : Customer.fromJson(json['customers'] as Map<String, dynamic>)
      ..cargo_transporters = json['cargo_transporters'] == null
          ? null
          : CargoTransporter.fromJson(
              json['cargo_transporters'] as Map<String, dynamic>)
      ..status = $enumDecodeNullable(_$InvoiceStatusEnumMap, json['status'])
      ..quantity = InvoiceMaster.convertToDouble(json['quantity'])
      ..extendedPrice = InvoiceMaster.convertToDouble(json['extendedPrice'])
      ..refundQuantity = InvoiceMaster.convertToDouble(json['refundQuantity'])
      ..extendedRefundPrice =
          InvoiceMaster.convertToDouble(json['extendedRefundPrice'])
      ..extendedDiscount =
          InvoiceMaster.convertToDouble(json['extendedDiscount'])
      ..extendedNetPrice =
          InvoiceMaster.convertToDouble(json['extendedNetPrice'])
      ..products_outputs_details = (json['products_outputs_details']
              as List<dynamic>?)
          ?.map((e) => ProductOutputDetails.fromJson(e as Map<String, dynamic>))
          .toList()
      ..products_outputs_details_count =
          json['products_outputs_details_count'] as int?
      ..warehouse = json['warehouse'] == null
          ? null
          : Warehouse.fromJson(json['warehouse'] as Map<String, dynamic>);

Map<String, dynamic> _$ProductOutputToJson(ProductOutput instance) =>
    <String, dynamic>{
      'iD': instance.iD,
      'delete': instance.delete,
      'TermsID': instance.TermsID,
      'date': instance.date,
      'billNo': instance.billNo,
      'comments': instance.comments,
      'employees': instance.employees?.toJson(),
      'customers': instance.customers?.toJson(),
      'cargo_transporters': instance.cargo_transporters?.toJson(),
      'status': _$InvoiceStatusEnumMap[instance.status],
      'quantity': instance.quantity,
      'extendedPrice': instance.extendedPrice,
      'refundQuantity': instance.refundQuantity,
      'extendedRefundPrice': instance.extendedRefundPrice,
      'extendedDiscount': instance.extendedDiscount,
      'extendedNetPrice': instance.extendedNetPrice,
      'products_outputs_details':
          instance.products_outputs_details?.map((e) => e.toJson()).toList(),
      'products_outputs_details_count': instance.products_outputs_details_count,
      'warehouse': instance.warehouse?.toJson(),
    };

const _$InvoiceStatusEnumMap = {
  InvoiceStatus.NONE: 'NONE',
  InvoiceStatus.PENDING: 'PENDING',
  InvoiceStatus.PROCESSING: 'PROCESSING',
  InvoiceStatus.CANCELED: 'CANCELED',
  InvoiceStatus.APPROVED: 'APPROVED',
};

ProductOutputDetails _$ProductOutputDetailsFromJson(
        Map<String, dynamic> json) =>
    ProductOutputDetails()
      ..iD = json['iD'] as int
      ..delete = json['delete'] as bool?
      ..products = json['products'] == null
          ? null
          : Product.fromJson(json['products'] as Map<String, dynamic>)
      ..warehouse = json['warehouse'] == null
          ? null
          : Warehouse.fromJson(json['warehouse'] as Map<String, dynamic>)
      ..quantity = (json['quantity'] as num?)?.toDouble()
      ..unitPrice = (json['unitPrice'] as num?)?.toDouble()
      ..discount = (json['discount'] as num?)?.toDouble()
      ..price = (json['price'] as num?)?.toDouble()
      ..comments = json['comments'] as String?
      ..products_outputs = json['products_outputs'] == null
          ? null
          : ProductOutput.fromJson(
              json['products_outputs'] as Map<String, dynamic>);

Map<String, dynamic> _$ProductOutputDetailsToJson(
        ProductOutputDetails instance) =>
    <String, dynamic>{
      'iD': instance.iD,
      'delete': instance.delete,
      'products': instance.products?.toJson(),
      'warehouse': instance.warehouse?.toJson(),
      'quantity': instance.quantity,
      'unitPrice': instance.unitPrice,
      'discount': instance.discount,
      'price': instance.price,
      'comments': instance.comments,
      'products_outputs': instance.products_outputs?.toJson(),
    };
