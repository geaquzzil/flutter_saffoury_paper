import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/icon_data.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/services/text_input.dart';
import 'package:flutter_saffoury_paper/models/funds/currency/currency.dart';
import 'package:flutter_view_controller/models/prints/print_local_setting.dart';
import 'package:flutter_view_controller/models/prints/printer_options.dart';
import 'package:flutter_view_controller/models/prints/report_options.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_enum.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:flutter_view_controller/models/view_abstract_inputs_validaters.dart';
import 'package:flutter_view_controller/models/view_abstract_permissions.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

import '../funds/money_funds.dart';

part 'print_dashboard_setting.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class PrintDashboardSetting extends PrintLocalSetting<PrintDashboardSetting> {
  bool? hideInfoHeader;
  bool? hideTotalFooter;
  bool? hideCurrency;
  bool? showAsDetails;
  bool? includePreviousBalance;
  Currency? currency;
  PrintDashboardType? dashboardPrintType;

  PrintDashboardSetting() : super() {
    hasMultiplePageFormats = false;
    hideHeaderLogo=true;
  }

  @override
  ViewAbstractControllerInputType getInputType(String field) {
    if (field == "currency") {
      return ViewAbstractControllerInputType.DROP_DOWN_API;
    }
    return super.getInputType(field);
  }

  @override
  String? getPrintableSortByName(BuildContext context) =>
      AppLocalizations.of(context)!.date;

  @override
  String? getPrintableGroupByName() => null;

  @override
  SortByType? getPrintableHasSortBy() => null;

  @override
  PrintDashboardSetting getSelfNewInstance() {
    return PrintDashboardSetting();
  }

  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() =>
      super.getMirrorFieldsMapNewInstance()
        ..addAll({
          "hideInfoHeader": false,
          "hideTotalFooter": false,
          "hideCurrency": false,
          "showAsDetails": true,
          "includePreviousBalance": true,
          "dashboardPrintType": PrintDashboardType.ALL,
          "currency": Currency(),
          
        });

  @override
  List<String> getMainFields({BuildContext? context}) =>
      super.getMainFields(context: context)
        ..addAll([
          "hideInfoHeader",
          "hideTotalFooter",
          "hideCurrency",
          "currency",
          "dashboardPrintType",
          "includePreviousBalance",
          "showAsDetails",
          "hideHeaderLogo"
        ]);
  @override
  String getTextCheckBoxDescription(BuildContext context, String field) {
    if (field == "hideInfoHeader") {
      return "Hide Info Header description TODO";
    } else if (field == "hideTotalFooter") {
      return "hide Total Footer description TODO";
    } else if (field == "hideCurrency") {
      return AppLocalizations.of(context)!.hideCurrencyDes;
    } else if (field == "showAsDetails") {
      return "Show As Details description TODO";
    } else if (field == "includePreviousBalance") {
      return "${AppLocalizations.of(context)!.previousBalance} TYODO includePreviousBalance";
    }
    return super.getTextCheckBoxDescription(context, field);
  }

  @override
  Map<String, String> getFieldLabelMap(BuildContext context) =>
      super.getFieldLabelMap(context)
        ..addAll({
          "hideInfoHeader": "hide Info Header label todo",
          "hideTotalFooter": "hide Total Footer label todo",
          "hideCurrency": AppLocalizations.of(context)!.hideCurrency,
          "showAsDetails": "Show as Details label todo",
          "includePreviousBalance":
              AppLocalizations.of(context)!.previousBalance
        });
  @override
  Map<String, IconData> getFieldIconDataMap() => {};

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) => "";

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
  Map<String, dynamic> toJsonViewAbstract() => toJson();
  @override
  PrintDashboardSetting fromJsonViewAbstract(Map<String, dynamic> json) =>
      PrintDashboardSetting.fromJson(json);

  factory PrintDashboardSetting.fromJson(Map<String, dynamic> data) =>
      _$PrintDashboardSettingFromJson(data);

  Map<String, dynamic> toJson() => _$PrintDashboardSettingToJson(this);

  @override
  PrintDashboardSetting onSavedModiablePrintableLoaded(
      BuildContext context, ViewAbstract viewAbstractThatCalledPDF) {
    debugPrint(
        "onSavedModiablePrintableLoaded ${viewAbstractThatCalledPDF.runtimeType}");
    return this;
  }
}

enum PrintDashboardType implements ViewAbstractEnum<PrintDashboardType> {
  ALL,
  DAILY_INVOICE_ONLY,
  MONEY_FUND_ONLY;

  @override
  String getFieldLabelString(BuildContext context, PrintDashboardType field) {
    switch (field) {
      case PrintDashboardType.ALL:
        return AppLocalizations.of(context)!.all;
      case PrintDashboardType.DAILY_INVOICE_ONLY:
        return AppLocalizations.of(context)!.invoice;
      case PrintDashboardType.MONEY_FUND_ONLY:
        return AppLocalizations.of(context)!.money_fund;
    }
  }

  @override
  IconData getFieldLabelIconData(
      BuildContext context, PrintDashboardType field) {
    switch (field) {
      case PrintDashboardType.ALL:
        return Icons.all_inbox;
      case PrintDashboardType.DAILY_INVOICE_ONLY:
        return Icons.document_scanner;
      case PrintDashboardType.MONEY_FUND_ONLY:
        return Icons.money;
    }
  }

  @override
  IconData getMainIconData() => Icons.print;

  @override
  String getMainLabelText(BuildContext context) =>
      AppLocalizations.of(context)!.printOptionsEnum;

  @override
  List<PrintDashboardType> getValues() => PrintDashboardType.values;
}
