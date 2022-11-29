// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'print_cut_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrintCutRequest _$PrintCutRequestFromJson(Map<String, dynamic> json) =>
    PrintCutRequest()
      ..iD = json['iD'] as int
      ..delete = json['delete'] as bool?
      ..printerOptions = json['printerOptions'] == null
          ? null
          : PrinterOptions.fromJson(
              json['printerOptions'] as Map<String, dynamic>)
      ..reportOptions = json['reportOptions'] == null
          ? null
          : ReportOptions.fromJson(
              json['reportOptions'] as Map<String, dynamic>)
      ..hideQrCode = json['hideQrCode'] as bool?
      ..primaryColor = json['primaryColor'] as String?
      ..secondaryColor = json['secondaryColor'] as String?
      ..hideTermsOfService = json['hideTermsOfService'] as bool?
      ..hideAdditionalNotes = json['hideAdditionalNotes'] as bool?
      ..hideCustomerName = json['hideCustomerName'] as bool?
      ..hideInvoiceDate = json['hideInvoiceDate'] as bool?
      ..hideEmployeeName = json['hideEmployeeName'] as bool?
      ..skipWastedProduct = json['skipWastedProduct'] as bool?
      ..productNameOption = $enumDecodeNullable(
          _$ProductNameOptionEnumMap, json['productNameOption'])
      ..printCutRequestType = $enumDecodeNullable(
          _$PrintCutRequestTypeEnumMap, json['printCutRequestType']);

Map<String, dynamic> _$PrintCutRequestToJson(PrintCutRequest instance) =>
    <String, dynamic>{
      'iD': instance.iD,
      'delete': instance.delete,
      'printerOptions': instance.printerOptions?.toJson(),
      'reportOptions': instance.reportOptions?.toJson(),
      'hideQrCode': instance.hideQrCode,
      'primaryColor': instance.primaryColor,
      'secondaryColor': instance.secondaryColor,
      'hideTermsOfService': instance.hideTermsOfService,
      'hideAdditionalNotes': instance.hideAdditionalNotes,
      'hideCustomerName': instance.hideCustomerName,
      'hideInvoiceDate': instance.hideInvoiceDate,
      'hideEmployeeName': instance.hideEmployeeName,
      'skipWastedProduct': instance.skipWastedProduct,
      'productNameOption':
          _$ProductNameOptionEnumMap[instance.productNameOption],
      'printCutRequestType':
          _$PrintCutRequestTypeEnumMap[instance.printCutRequestType],
    };

const _$ProductNameOptionEnumMap = {
  ProductNameOption.ALL: 'ALL',
  ProductNameOption.ONLY_CUT_REQUEST: 'ONLY_CUT_REQUEST',
};

const _$PrintCutRequestTypeEnumMap = {
  PrintCutRequestType.ALL: 'ALL',
  PrintCutRequestType.ONLY_PRODUCT_LABEL: 'ONLY_PRODUCT_LABEL',
  PrintCutRequestType.ONLY_CUT_REQUEST: 'ONLY_CUT_REQUEST',
};
