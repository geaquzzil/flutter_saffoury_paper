// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'orders.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Order _$OrderFromJson(Map<String, dynamic> json) =>
    Order()
      ..iD = convertToMinusOneIfNotFound(json['iD'])
      ..serverStatus = json['serverStatus'] as String?
      ..fb_edit = json['fb_edit'] as String?
      ..terms = $enumDecodeNullable(_$TermsEnumMap, json['terms'])
      ..TermsID = (json['TermsID'] as num?)?.toInt()
      ..date = json['date'] as String?
      ..billNo = json['billNo'] as String?
      ..comments = json['comments'] as String?
      ..employees =
          json['employees'] == null
              ? null
              : Employee.fromJson(json['employees'] as Map<String, dynamic>)
      ..customers =
          json['customers'] == null
              ? null
              : Customer.fromJson(json['customers'] as Map<String, dynamic>)
      ..cargo_transporters =
          json['cargo_transporters'] == null
              ? null
              : CargoTransporter.fromJson(
                json['cargo_transporters'] as Map<String, dynamic>,
              )
      ..status = $enumDecodeNullable(_$InvoiceStatusEnumMap, json['status'])
      ..quantity = convertToDouble(json['quantity'])
      ..extendedPrice = convertToDouble(json['extendedPrice'])
      ..refundQuantity = convertToDouble(json['refundQuantity'])
      ..extendedRefundPrice = convertToDouble(
        json['extendedRefundPrice'],
      )
      ..extendedDiscount = convertToDouble(
        json['extendedDiscount'],
      )
      ..extendedNetPrice = convertToDouble(
        json['extendedNetPrice'],
      )
      ..extendedNetQuantity = convertToDouble(
        json['extendedNetQuantity'],
      )
      ..orders_details =
          (json['orders_details'] as List<dynamic>?)
              ?.map((e) => OrderDetails.fromJson(e as Map<String, dynamic>))
              .toList()
      ..orders_details_count = (json['orders_details_count'] as num?)?.toInt()
      ..orders_refunds =
          (json['orders_refunds'] as List<dynamic>?)
              ?.map((e) => OrderRefund.fromJson(e as Map<String, dynamic>))
              .toList()
      ..orders_refunds_count = (json['orders_refunds_count'] as num?)?.toInt();

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
  'iD': instance.iD,
  'delete': instance.delete,
  'terms': _$TermsEnumMap[instance.terms],
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
  'extendedNetQuantity': instance.extendedNetQuantity,
  'orders_details': instance.orders_details?.map((e) => e.toJson()).toList(),
  'orders_details_count': instance.orders_details_count,
  'orders_refunds': instance.orders_refunds?.map((e) => e.toJson()).toList(),
  'orders_refunds_count': instance.orders_refunds_count,
};

const _$TermsEnumMap = {
  Terms.none: '0',
  Terms.pay1: '-1',
  Terms.pay2: '-7',
  Terms.pay3: '7',
  Terms.pay4: '10',
  Terms.pay5: '30',
  Terms.pay6: '-30',
  Terms.pay7: '1',
  Terms.pay8: '80',
};

const _$InvoiceStatusEnumMap = {
  InvoiceStatus.NONE: 'NONE',
  InvoiceStatus.PENDING: 'PENDING',
  InvoiceStatus.PROCESSING: 'PROCESSING',
  InvoiceStatus.CANCELED: 'CANCELED',
  InvoiceStatus.APPROVED: 'APPROVED',
};

OrderDetails _$OrderDetailsFromJson(Map<String, dynamic> json) =>
    OrderDetails()
      ..iD = convertToMinusOneIfNotFound(json['iD'])
      ..serverStatus = json['serverStatus'] as String?
      ..fb_edit = json['fb_edit'] as String?
      ..products =
          json['products'] == null
              ? null
              : Product.fromJson(json['products'] as Map<String, dynamic>)
      ..warehouse =
          json['warehouse'] == null
              ? null
              : Warehouse.fromJson(json['warehouse'] as Map<String, dynamic>)
      ..quantity = (json['quantity'] as num?)?.toDouble()
      ..unitPrice = (json['unitPrice'] as num?)?.toDouble()
      ..discount = (json['discount'] as num?)?.toDouble()
      ..price = (json['price'] as num?)?.toDouble()
      ..comments = json['comments'] as String?
      ..orders =
          json['orders'] == null
              ? null
              : Order.fromJson(json['orders'] as Map<String, dynamic>);

Map<String, dynamic> _$OrderDetailsToJson(OrderDetails instance) =>
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
      'orders': instance.orders?.toJson(),
    };
