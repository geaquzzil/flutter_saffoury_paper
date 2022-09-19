// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'printer_options.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrinterOptions _$PrinterOptionsFromJson(Map<String, dynamic> json) =>
    PrinterOptions(
      language: json['language'] ?? Language.English,
      copies: json['copies'] as int? ?? 1,
      printPaperSize: json['printPaperSize'] ?? PrintPaperSize.Default,
    )
      ..iD = json['iD'] as int
      ..startEndPage = json['startEndPage'] as String?
      ..printerName = json['printerName'] as String?
      ..printerNameLabel = json['printerNameLabel'] as String?;

Map<String, dynamic> _$PrinterOptionsToJson(PrinterOptions instance) =>
    <String, dynamic>{
      'iD': instance.iD,
      'language': instance.language,
      'copies': instance.copies,
      'startEndPage': instance.startEndPage,
      'printerName': instance.printerName,
      'printerNameLabel': instance.printerNameLabel,
      'printPaperSize': instance.printPaperSize,
    };
