// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customers_request_sizes.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerRequestSize _$CustomerRequestSizeFromJson(Map<String, dynamic> json) =>
    CustomerRequestSize()
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
      ..customers_request_sizes_details =
          (json['customers_request_sizes_details'] as List<dynamic>?)
              ?.map(
                (e) => CustomerRequestSizeDetails.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList()
      ..customers_request_sizes_details_count =
          (json['customers_request_sizes_details_count'] as num?)?.toInt();

Map<String, dynamic> _$CustomerRequestSizeToJson(
  CustomerRequestSize instance,
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
  'customers_request_sizes_details':
      instance.customers_request_sizes_details?.map((e) => e.toJson()).toList(),
  'customers_request_sizes_details_count':
      instance.customers_request_sizes_details_count,
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

CustomerRequestSizeDetails _$CustomerRequestSizeDetailsFromJson(
  Map<String, dynamic> json,
) =>
    CustomerRequestSizeDetails()
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
      ..customers_request_sizes =
          json['customers_request_sizes'] == null
              ? null
              : CustomerRequestSize.fromJson(
                json['customers_request_sizes'] as Map<String, dynamic>,
              )
      ..sizes =
          json['sizes'] == null
              ? null
              : ProductSize.fromJson(json['sizes'] as Map<String, dynamic>)
      ..date = json['date'] as String?;

Map<String, dynamic> _$CustomerRequestSizeDetailsToJson(
  CustomerRequestSizeDetails instance,
) => <String, dynamic>{
  'iD': instance.iD,
  'delete': instance.delete,
  'products': instance.products?.toJson(),
  'warehouse': instance.warehouse?.toJson(),
  'quantity': instance.quantity,
  'unitPrice': instance.unitPrice,
  'discount': instance.discount,
  'price': instance.price,
  'comments': instance.comments,
  'customers_request_sizes': instance.customers_request_sizes?.toJson(),
  'sizes': instance.sizes?.toJson(),
  'date': instance.date,
};
