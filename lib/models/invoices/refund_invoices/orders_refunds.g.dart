// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'orders_refunds.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderRefund _$OrderRefundFromJson(Map<String, dynamic> json) =>
    OrderRefund()
      ..iD = ViewAbstractPermissions.convertToMinusOneIfNotFound(json['iD'])
      ..serverStatus = json['serverStatus'] as String?
      ..fb_edit = json['fb_edit'] as String?
      ..terms = $enumDecodeNullable(_$TermsEnumMap, json['terms'])
      ..TermsID = (json['TermsID'] as num?)?.toInt()
      ..date = json['date'] as String?
      ..billNo = InvoiceMaster.intFromString(json['billNo'])
      ..comments = ViewAbstractPermissions.convertToStringFromString(json['comments'])
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
      ..quantity = InvoiceMaster.convertToDouble(json['quantity'])
      ..extendedPrice = InvoiceMaster.convertToDouble(json['extendedPrice'])
      ..refundQuantity = InvoiceMaster.convertToDouble(json['refundQuantity'])
      ..extendedRefundPrice = InvoiceMaster.convertToDouble(
        json['extendedRefundPrice'],
      )
      ..extendedDiscount = InvoiceMaster.convertToDouble(
        json['extendedDiscount'],
      )
      ..extendedNetPrice = InvoiceMaster.convertToDouble(
        json['extendedNetPrice'],
      )
      ..extendedNetQuantity = InvoiceMaster.convertToDouble(
        json['extendedNetQuantity'],
      )
      ..orders =
          json['orders'] == null
              ? null
              : Order.fromJson(json['orders'] as Map<String, dynamic>)
      ..orders_refunds_order_details =
          (json['orders_refunds_order_details'] as List<dynamic>?)
              ?.map(
                (e) => OrderRefundDetails.fromJson(e as Map<String, dynamic>),
              )
              .toList()
      ..orders_refunds_order_details_count =
          (json['orders_refunds_order_details_count'] as num?)?.toInt();

Map<String, dynamic> _$OrderRefundToJson(
  OrderRefund instance,
) => <String, dynamic>{
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
  'orders': instance.orders?.toJson(),
  'orders_refunds_order_details':
      instance.orders_refunds_order_details?.map((e) => e.toJson()).toList(),
  'orders_refunds_order_details_count':
      instance.orders_refunds_order_details_count,
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

OrderRefundDetails _$OrderRefundDetailsFromJson(Map<String, dynamic> json) =>
    OrderRefundDetails()
      ..iD = ViewAbstractPermissions.convertToMinusOneIfNotFound(json['iD'])
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
      ..comments = ViewAbstractPermissions.convertToStringFromString(json['comments'])
      ..orders_refunds =
          json['orders_refunds'] == null
              ? null
              : OrderRefund.fromJson(
                json['orders_refunds'] as Map<String, dynamic>,
              )
      ..orders =
          json['orders'] == null
              ? null
              : Order.fromJson(json['orders'] as Map<String, dynamic>)
      ..orders_details =
          json['orders_details'] == null
              ? null
              : OrderDetails.fromJson(
                json['orders_details'] as Map<String, dynamic>,
              );

Map<String, dynamic> _$OrderRefundDetailsToJson(OrderRefundDetails instance) =>
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
      'orders_refunds': instance.orders_refunds?.toJson(),
      'orders': instance.orders?.toJson(),
      'orders_details': instance.orders_details?.toJson(),
    };
