// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'print_product_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrintProductList _$PrintProductListFromJson(Map<String, dynamic> json) =>
    PrintProductList()
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
      ..hasMultiplePageFormats = json['hasMultiplePageFormats'] as bool
      ..hideTermsOfService = json['hideTermsOfService'] as bool?
      ..hideAdditionalNotes = json['hideAdditionalNotes'] as bool?
      ..hideDate = json['hideDate'] as bool?
      ..hideQuantity = json['hideQuantity'] as bool?
      ..hideWarehouse = json['hideWarehouse'] as bool?
      ..skipOutOfStock = json['skipOutOfStock'] as bool?
      ..hideUnitPriceAndTotalPrice = json['hideUnitPriceAndTotalPrice'] as bool?
      ..sortByField = json['sortByField'] as String?
      ..sortByType =
          $enumDecodeNullable(_$SortByTypeEnumMap, json['sortByType']);

Map<String, dynamic> _$PrintProductListToJson(PrintProductList instance) =>
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
      'hideDate': instance.hideDate,
      'hideQuantity': instance.hideQuantity,
      'hideWarehouse': instance.hideWarehouse,
      'skipOutOfStock': instance.skipOutOfStock,
      'hideUnitPriceAndTotalPrice': instance.hideUnitPriceAndTotalPrice,
      'sortByField': instance.sortByField,
      'sortByType': _$SortByTypeEnumMap[instance.sortByType],
    };

const _$SortByTypeEnumMap = {
  SortByType.ASC: 'ASC',
  SortByType.DESC: 'DESC',
};
