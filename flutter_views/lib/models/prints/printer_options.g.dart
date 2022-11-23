// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'printer_options.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrinterOptions _$PrinterOptionsFromJson(Map<String, dynamic> json) =>
    PrinterOptions(
      language: $enumDecodeNullable(_$LanguageEnumMap, json['language']) ??
          Language.English,
      copies: json['copies'] as int? ?? 1,
      printPaperSize: $enumDecodeNullable(
              _$PrintPaperSizeEnumMap, json['printPaperSize']) ??
          PrintPaperSize.Default,
    )
      ..iD = json['iD'] as int
      ..delete = json['delete'] as bool?
      ..startEndPage = json['startEndPage'] as String?
      ..printerName = json['printerName'] as String?
      ..printerNameLabel = json['printerNameLabel'] as String?;

Map<String, dynamic> _$PrinterOptionsToJson(PrinterOptions instance) =>
    <String, dynamic>{
      'iD': instance.iD,
      'delete': instance.delete,
      'language': _$LanguageEnumMap[instance.language]!,
      'copies': instance.copies,
      'startEndPage': instance.startEndPage,
      'printerName': instance.printerName,
      'printerNameLabel': instance.printerNameLabel,
      'printPaperSize': _$PrintPaperSizeEnumMap[instance.printPaperSize]!,
    };

const _$LanguageEnumMap = {
  Language.English: 0,
  Language.Arabic: 1,
};

const _$PrintPaperSizeEnumMap = {
  PrintPaperSize.Default: 0,
  PrintPaperSize.A3Size: 1,
  PrintPaperSize.A4Size: 2,
  PrintPaperSize.A5Size: 3,
};
