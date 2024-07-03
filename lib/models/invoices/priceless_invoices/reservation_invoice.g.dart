// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation_invoice.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReservationInvoice _$ReservationInvoiceFromJson(Map<String, dynamic> json) =>
    ReservationInvoice()
      ..iD = ViewAbstractPermissions.convertToMinusOneIfNotFound(json['iD'])
      ..terms = $enumDecodeNullable(_$TermsEnumMap, json['terms'])
      ..TermsID = (json['TermsID'] as num?)?.toInt()
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
      ..extendedNetQuantity =
          InvoiceMaster.convertToDouble(json['extendedNetQuantity'])
      ..reservation_invoice_details =
          (json['reservation_invoice_details'] as List<dynamic>?)
              ?.map((e) =>
                  ReservationInvoiceDetails.fromJson(e as Map<String, dynamic>))
              .toList()
      ..reservation_invoice_details_count =
          (json['reservation_invoice_details_count'] as num?)?.toInt();

Map<String, dynamic> _$ReservationInvoiceToJson(ReservationInvoice instance) =>
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
      'extendedNetQuantity': instance.extendedNetQuantity,
      'reservation_invoice_details':
          instance.reservation_invoice_details?.map((e) => e.toJson()).toList(),
      'reservation_invoice_details_count':
          instance.reservation_invoice_details_count,
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

ReservationInvoiceDetails _$ReservationInvoiceDetailsFromJson(
        Map<String, dynamic> json) =>
    ReservationInvoiceDetails()
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
      ..reservation_invoice = json['reservation_invoice'] == null
          ? null
          : ReservationInvoice.fromJson(
              json['reservation_invoice'] as Map<String, dynamic>);

Map<String, dynamic> _$ReservationInvoiceDetailsToJson(
        ReservationInvoiceDetails instance) =>
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
      'reservation_invoice': instance.reservation_invoice?.toJson(),
    };
