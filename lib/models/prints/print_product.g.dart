// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'print_product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrintProduct _$PrintProductFromJson(Map<String, dynamic> json) => PrintProduct()
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
  ..hasMultiplePageFormats = json['hasMultiplePageFormats'] as bool?
  ..hideTermsOfService = json['hideTermsOfService'] as bool?
  ..hideAdditionalNotes = json['hideAdditionalNotes'] as bool?
  ..currentGroupNameFromList = json['currentGroupNameFromList'] as String?
  ..currentGroupNameIndex = json['currentGroupNameIndex'] as int?
  ..currentGroupList = json['currentGroupList'] as List<dynamic>?
  ..hideCustomerBalance = json['hideCustomerBalance'] as bool?
  ..hideInvoiceDate = json['hideInvoiceDate'] as bool?
  ..hideEmployeeName = json['hideEmployeeName'] as bool?
  ..hideCountry = json['hideCountry'] as bool?
  ..hideManufacture = json['hideManufacture'] as bool?
  ..customerName = json['customerName'] as String?
  ..cutRequestID = json['cutRequestID'] as String?
  ..country = json['country'] as String?
  ..manufacture = json['manufacture'] as String?
  ..description = json['description'] as String?;

Map<String, dynamic> _$PrintProductToJson(PrintProduct instance) =>
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
      'currentGroupNameFromList': instance.currentGroupNameFromList,
      'currentGroupNameIndex': instance.currentGroupNameIndex,
      'currentGroupList': instance.currentGroupList,
      'hideCustomerBalance': instance.hideCustomerBalance,
      'hideInvoiceDate': instance.hideInvoiceDate,
      'hideEmployeeName': instance.hideEmployeeName,
      'hideCountry': instance.hideCountry,
      'hideManufacture': instance.hideManufacture,
      'customerName': instance.customerName,
      'cutRequestID': instance.cutRequestID,
      'country': instance.country,
      'manufacture': instance.manufacture,
      'description': instance.description,
    };
