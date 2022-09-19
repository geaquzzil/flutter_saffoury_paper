// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'print_product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrintProduct _$PrintProductFromJson(Map<String, dynamic> json) => PrintProduct()
  ..iD = json['iD'] as int
  ..requestIDs = json['requestIDs']
  ..actionMessage = json['actionMessage']
  ..imgLinkAndroidQRCode = json['imgLinkAndroidQRCode'] as String?
  ..printerOptions = json['printerOptions'] == null
      ? null
      : PrinterOptions.fromJson(json['printerOptions'] as Map<String, dynamic>)
  ..reportOptions = json['reportOptions'] == null
      ? null
      : ReportOptions.fromJson(json['reportOptions'] as Map<String, dynamic>)
  ..fieldSortBy = json['fieldSortBy'] as String
  ..fieldSortByAscDesc = json['fieldSortByAscDesc'] as String
  ..fieldSortByMaster = json['fieldSortByMaster'] as String
  ..sortByType = $enumDecode(_$SortByTypeEnumMap, json['sortByType']);

Map<String, dynamic> _$PrintProductToJson(PrintProduct instance) =>
    <String, dynamic>{
      'iD': instance.iD,
      'requestIDs': instance.requestIDs,
      'actionMessage': instance.actionMessage,
      'imgLinkAndroidQRCode': instance.imgLinkAndroidQRCode,
      'printerOptions': instance.printerOptions?.toJson(),
      'reportOptions': instance.reportOptions?.toJson(),
      'fieldSortBy': instance.fieldSortBy,
      'fieldSortByAscDesc': instance.fieldSortByAscDesc,
      'fieldSortByMaster': instance.fieldSortByMaster,
      'sortByType': _$SortByTypeEnumMap[instance.sortByType]!,
    };

const _$SortByTypeEnumMap = {
  SortByType.ASC: 'ASC',
  SortByType.DESC: 'DESC',
};
