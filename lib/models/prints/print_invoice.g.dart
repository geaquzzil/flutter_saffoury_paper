// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'print_invoice.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrintInvoice _$PrintInvoiceFromJson(Map<String, dynamic> json) => PrintInvoice()
  ..iD = json['iD'] as int
  ..printerOptions = json['printerOptions'] == null
      ? null
      : PrinterOptions.fromJson(json['printerOptions'] as Map<String, dynamic>)
  ..reportOptions = json['reportOptions'] == null
      ? null
      : ReportOptions.fromJson(json['reportOptions'] as Map<String, dynamic>)
  ..hideQrCode = json['hideQrCode'] as bool?
  ..primaryColor = json['primaryColor'] as String?
  ..secondaryColor = json['secondaryColor'] as String?
  ..hasMultiplePageFormats = json['hasMultiplePageFormats'] as bool
  ..hideTermsOfService = json['hideTermsOfService'] as bool?
  ..hideAdditionalNotes = json['hideAdditionalNotes'] as bool?
  ..hideCustomerAddressInfo = json['hideCustomerAddressInfo'] as bool?
  ..hideCustomerPhone = json['hideCustomerPhone'] as bool?
  ..hideCustomerBalance = json['hideCustomerBalance'] as bool?
  ..hideInvoicePaymentMethod = json['hideInvoicePaymentMethod'] as bool?
  ..hideInvoiceDate = json['hideInvoiceDate'] as bool?
  ..hideInvoiceDueDate = json['hideInvoiceDueDate'] as bool?
  ..hideUnitPriceAndTotalPrice = json['hideUnitPriceAndTotalPrice'] as bool?
  ..hideEmployeeName = json['hideEmployeeName'] as bool?
  ..hideCargoInfo = json['hideCargoInfo'] as bool?
  ..changeProductNameTo = json['changeProductNameTo'] as String?
  ..productNameOption =
      $enumDecodeNullable(_$ProductNameOptionEnumMap, json['productNameOption'])
  ..sortByField = json['sortByField'] as String?
  ..sortByType = $enumDecodeNullable(_$SortByTypeEnumMap, json['sortByType']);

Map<String, dynamic> _$PrintInvoiceToJson(PrintInvoice instance) =>
    <String, dynamic>{
      'iD': instance.iD,
      'delete': instance.delete,
      'printerOptions': instance.printerOptions?.toJson(),
      'reportOptions': instance.reportOptions?.toJson(),
      'hideQrCode': instance.hideQrCode,
      'primaryColor': instance.primaryColor,
      'secondaryColor': instance.secondaryColor,
      'hasMultiplePageFormats': instance.hasMultiplePageFormats,
      'hideTermsOfService': instance.hideTermsOfService,
      'hideAdditionalNotes': instance.hideAdditionalNotes,
      'hideCustomerAddressInfo': instance.hideCustomerAddressInfo,
      'hideCustomerPhone': instance.hideCustomerPhone,
      'hideCustomerBalance': instance.hideCustomerBalance,
      'hideInvoicePaymentMethod': instance.hideInvoicePaymentMethod,
      'hideInvoiceDate': instance.hideInvoiceDate,
      'hideInvoiceDueDate': instance.hideInvoiceDueDate,
      'hideUnitPriceAndTotalPrice': instance.hideUnitPriceAndTotalPrice,
      'hideEmployeeName': instance.hideEmployeeName,
      'hideCargoInfo': instance.hideCargoInfo,
      'changeProductNameTo': instance.changeProductNameTo,
      'productNameOption':
          _$ProductNameOptionEnumMap[instance.productNameOption],
      'sortByField': instance.sortByField,
      'sortByType': _$SortByTypeEnumMap[instance.sortByType],
    };

const _$ProductNameOptionEnumMap = {
  ProductNameOption.ALL: 'ALL',
  ProductNameOption.ONLY_CUT_REQUEST: 'ONLY_CUT_REQUEST',
};

const _$SortByTypeEnumMap = {
  SortByType.ASC: 'ASC',
  SortByType.DESC: 'DESC',
};
