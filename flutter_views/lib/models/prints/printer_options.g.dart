// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'printer_options.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrinterOptions _$PrinterOptionsFromJson(Map<String, dynamic> json) {
  return PrinterOptions(
    language: _$enumDecode(_$LanguageEnumMap, json['language']),
    copies: json['copies'] as int,
    printPaperSize:
        _$enumDecode(_$PrintPaperSizeEnumMap, json['printPaperSize']),
  )
    ..iD = json['iD'] as int
    ..startEndPage = json['startEndPage'] as String?
    ..printerName = json['printerName'] as String?
    ..printerNameLabel = json['printerNameLabel'] as String?;
}

Map<String, dynamic> _$PrinterOptionsToJson(PrinterOptions instance) =>
    <String, dynamic>{
      'iD': instance.iD,
      'language': _$LanguageEnumMap[instance.language],
      'copies': instance.copies,
      'startEndPage': instance.startEndPage,
      'printerName': instance.printerName,
      'printerNameLabel': instance.printerNameLabel,
      'printPaperSize': _$PrintPaperSizeEnumMap[instance.printPaperSize],
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

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
