import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
part 'printer_options.g.dart';

@JsonSerializable()
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
        "printPaperSize": AppLocalizations.of(context)!.printType
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
        "reportFooter": TextInputType.text
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
}

enum Language {
  @JsonValue(0)
  English,
  @JsonValue(1)
  Arabic
}

enum PrintPaperSize {
  @JsonValue(0)
  Default,
  @JsonValue(1)
  A3Size,
  @JsonValue(2)
  A4Size,
  @JsonValue(3)
  A5Size
}
