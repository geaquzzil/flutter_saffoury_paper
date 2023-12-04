// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchasers_refunds.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PurchasesRefund _$PurchasesRefundFromJson(Map<String, dynamic> json) =>
    PurchasesRefund()
      ..iD = ViewAbstractPermissions.convertToMinusOneIfNotFound(json['iD'])
      ..terms = $enumDecodeNullable(_$TermsEnumMap, json['terms'])
      ..TermsID = json['TermsID'] as int?
      ..date = json['date'] as String?
      ..billNo = InvoiceMaster.intFromString(json['billNo'])
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
      ..purchases = json['purchases'] == null
          ? null
          : Purchases.fromJson(json['purchases'] as Map<String, dynamic>)
      ..purchases_refunds_purchases_details =
          (json['purchases_refunds_purchases_details'] as List<dynamic>?)
              ?.map((e) =>
                  PurchasesRefundDetails.fromJson(e as Map<String, dynamic>))
              .toList()
      ..purchases_refunds_purchases_details_count =
          json['purchases_refunds_purchases_details_count'] as int?;

Map<String, dynamic> _$PurchasesRefundToJson(PurchasesRefund instance) =>
    <String, dynamic>{
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
      'purchases': instance.purchases?.toJson(),
      'purchases_refunds_purchases_details': instance
          .purchases_refunds_purchases_details
          ?.map((e) => e.toJson())
          .toList(),
      'purchases_refunds_purchases_details_count':
          instance.purchases_refunds_purchases_details_count,
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

PurchasesRefundDetails _$PurchasesRefundDetailsFromJson(
        Map<String, dynamic> json) =>
    PurchasesRefundDetails()
      ..iD = ViewAbstractPermissions.convertToMinusOneIfNotFound(json['iD'])
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
      ..purchases = json['purchases'] == null
          ? null
          : Purchases.fromJson(json['purchases'] as Map<String, dynamic>)
      ..purchases_refunds = json['purchases_refunds'] == null
          ? null
          : PurchasesRefund.fromJson(
              json['purchases_refunds'] as Map<String, dynamic>)
      ..purchases_details = json['purchases_details'] == null
          ? null
          : PurchasesDetails.fromJson(
              json['purchases_details'] as Map<String, dynamic>);

Map<String, dynamic> _$PurchasesRefundDetailsToJson(
        PurchasesRefundDetails instance) =>
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
      'purchases': instance.purchases?.toJson(),
      'purchases_refunds': instance.purchases_refunds?.toJson(),
      'purchases_details': instance.purchases_details?.toJson(),
    };
