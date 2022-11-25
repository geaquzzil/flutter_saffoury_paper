import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

import '../view_abstract_enum.dart';
part 'printer_options.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class PrinterOptions extends ViewAbstract<PrinterOptions> {
  Language language;
  int copies;
  String? startEndPage;
  String? printerName;
  String? printerNameLabel;
  PrintPaperSize printPaperSize;

  PrinterOptions(
      {this.language = Language.English,
      this.copies = 1,
      this.printPaperSize = PrintPaperSize.Default})
      : super();
  @override
  PrinterOptions getSelfNewInstance() {
    return PrinterOptions();
  }

  @override
  List<String> getMainFields() =>
      ["language", "copies", "startEndPage", "printPaperSize"];

  @override
  Map<String, IconData> getFieldIconDataMap() => {
        "language": Icons.language,
        "copies": Icons.copy,
        "startEndPage": Icons.date_range_rounded,
        "printPaperSize": Icons.photo_size_select_large_sharp
      };

  @override
  Map<String, String> getFieldLabelMap(BuildContext context) => {
        "language": AppLocalizations.of(context)!.language,
        "copies": AppLocalizations.of(context)!.copies,
        "startEndPage": AppLocalizations.of(context)!.startEndPage,
        "printPaperSize": AppLocalizations.of(context)!.size
      };

  @override
  String? getMainDrawerGroupName(BuildContext context) => null;

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) =>
      AppLocalizations.of(context)!.printerSetting;

  @override
  String getMainHeaderTextOnly(BuildContext context) =>
      getMainHeaderLabelTextOnly(context);

  @override
  IconData getMainIconData() => Icons.print;

  @override
  String? getSortByFieldName() => null;
  @override
  SortByType getSortByType() => SortByType.DESC;

  @override
  String? getTableNameApi() => null;

  @override
  Map<String, bool> getTextInputIsAutoCompleteMap() => {};

  @override
  Map<String, bool> getTextInputIsAutoCompleteViewAbstractMap() => {};

  @override
  Map<String, int> getTextInputMaxLengthMap() => {};

  @override
  Map<String, double> getTextInputMaxValidateMap() => {};

  @override
  Map<String, double> getTextInputMinValidateMap() => {};

  @override
  Map<String, TextInputType?> getTextInputTypeMap() => {
        "copies": const TextInputType.numberWithOptions(
            signed: false, decimal: false),
        "startEndPage": TextInputType.text
      };

  @override
  Map<String, bool> isFieldCanBeNullableMap() => {};

  @override
  Map<String, bool> isFieldRequiredMap() => {};

  @override
  Map<String, dynamic> toJsonViewAbstract() => toJson();

  @override
  PrinterOptions fromJsonViewAbstract(Map<String, dynamic> json) =>
      PrinterOptions.fromJson(json);

  factory PrinterOptions.fromJson(Map<String, dynamic> data) =>
      _$PrinterOptionsFromJson(data);

  Map<String, dynamic> toJson() => _$PrinterOptionsToJson(this);

  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() => {
        "language": Language.English,
        "copies": 0,
        "startEndPage": "",
        "printPaperSize": PrintPaperSize.Default
      };

  // @override
  // Map<String, Type> getMirrorFieldsTypeMap() => {
  //       "language": Language,
  //       "copies": int,
  //       "startEndPage": String,
  //       "printPaperSize": PrintPaperSize
  //     };
}

// enum Language {
//   @JsonValue(0)
//   English,
//   @JsonValue(1)
//   Arabic
// }

// enum PrintPaperSize {
//   @JsonValue(0)
//   Default,
//   @JsonValue(1)
//   A3Size,
//   @JsonValue(2)
//   A4Size,
//   @JsonValue(3)
//   A5Size
// }

enum PrintPaperSize implements ViewAbstractEnum<PrintPaperSize> {
  @JsonValue(0)
  Default,
  @JsonValue(1)
  A3Size,
  @JsonValue(2)
  A4Size,
  @JsonValue(3)
  A5Size;

  @override
  IconData getMainIconData() => Icons.format_size_outlined;
  @override
  String getMainLabelText(BuildContext context) =>
      AppLocalizations.of(context)!.size;

  @override
  String getFieldLabelString(BuildContext context, PrintPaperSize field) {
    switch (field) {
      case PrintPaperSize.Default:
        return AppLocalizations.of(context)!.defaultReportSize;
      case PrintPaperSize.A3Size:
        return AppLocalizations.of(context)!.a3ProductLabel;
      case PrintPaperSize.A4Size:
        return AppLocalizations.of(context)!.a4ProductLabel;
      case PrintPaperSize.A5Size:
        return AppLocalizations.of(context)!.a5ProductLabel;
    }
  }

  @override
  List<PrintPaperSize> getValues() {
    return PrintPaperSize.values;
  }
}

enum Language implements ViewAbstractEnum<Language> {
  @JsonValue(0)
  English,
  @JsonValue(1)
  Arabic;

  @override
  IconData getMainIconData() => Icons.language;
  @override
  String getMainLabelText(BuildContext context) =>
      AppLocalizations.of(context)!.language;

  @override
  String getFieldLabelString(BuildContext context, Language field) {
    switch (field) {
      case English:
        return AppLocalizations.of(context)!.english;
      case Arabic:
        return AppLocalizations.of(context)!.arabic;
    }
  }

  @override
  List<Language> getValues() {
    return Language.values;
  }
}
