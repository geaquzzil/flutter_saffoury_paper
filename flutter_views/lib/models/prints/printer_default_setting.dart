import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_view_controller/interfaces/settings/ModifiableInterfaceAndPrintingSetting.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';

class PrinterDefaultSetting extends ViewAbstract<PrinterDefaultSetting>
    implements ModifiableInterface<PrinterDefaultSetting> {
  String? defaultLabelPrinter;

  String? defaultPrinter;

  PrinterDefaultSetting({this.defaultLabelPrinter, this.defaultPrinter});

  @override
  PrinterDefaultSetting fromJsonViewAbstract(Map<String, dynamic> json) {
    return PrinterDefaultSetting.fromMap(json);
  }

  @override
  Map<String, IconData> getFieldIconDataMap() =>
      {"defaultLabelPrinter": Icons.qr_code, "defaultPrinter": Icons.print};

  @override
  Map<String, String> getFieldLabelMap(BuildContext context) => {};

  @override
  String? getMainDrawerGroupName(BuildContext context) => null;

  @override
  List<String> getMainFields({BuildContext? context}) =>
      ["defaultLabelPrinter,defaultPrinter"];
  @override
  String getMainHeaderLabelTextOnly(BuildContext context) =>
      //todo translate
      AppLocalizations.of(context)!.systemDefault;

  @override
  String getMainHeaderTextOnly(BuildContext context) =>
      //todo translate
      AppLocalizations.of(context)!.systemDefault;

  @override
  IconData getMainIconData() => Icons.drive_file_rename_outline_rounded;

  @override
  PrinterDefaultSetting getSelfNewInstance() => PrinterDefaultSetting();
  @override
  SortFieldValue? getSortByInitialType() => null;

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
  Map<String, TextInputType?> getTextInputTypeMap() => {};

  @override
  Map<String, bool> isFieldCanBeNullableMap() => {};

  @override
  Map<String, bool> isFieldRequiredMap() => {};

  @override
  Map<String, dynamic> toJsonViewAbstract() {
    return toMap();
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (defaultLabelPrinter != null) {
      result.addAll({'defaultLabelPrinter': defaultLabelPrinter});
    }
    if (defaultPrinter != null) {
      result.addAll({'defaultPrinter': defaultPrinter});
    }

    return result;
  }

  factory PrinterDefaultSetting.fromMap(Map<String, dynamic> map) {
    return PrinterDefaultSetting(
      defaultLabelPrinter: map['defaultLabelPrinter'],
      defaultPrinter: map['defaultPrinter'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PrinterDefaultSetting.fromJson(String source) =>
      PrinterDefaultSetting.fromMap(json.decode(source));

  @override
  String getModifiableMainGroupName(BuildContext context) {
    //todo translate
    return AppLocalizations.of(context)!.systemDefault;
  }

  @override
  IconData getModifibleIconData() => Icons.print;

  @override
  getModifibleSettingObject(BuildContext context) => this;

  @override
  String getModifibleTitleName(BuildContext context) =>
      getMainHeaderLabelTextOnly(context);
}
