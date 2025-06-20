import 'package:flutter/material.dart';
import 'package:flutter_view_controller/l10n/app_localization.dart';
import 'package:flutter_view_controller/models/prints/print_local_setting.dart';
import 'package:flutter_view_controller/models/prints/printer_options.dart';
import 'package:flutter_view_controller/models/prints/report_options.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:flutter_view_controller/models/view_abstract_permissions.dart';
import 'package:json_annotation/json_annotation.dart';

import '../funds/money_funds.dart';

part 'print_reciept.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class PrintReceipt extends PrintLocalSetting<PrintReceipt> {
  bool? hideCustomerBalance;
  bool? hideInvoiceDate;
  bool? hideEmployeeName;

  @JsonKey(includeFromJson: false, includeToJson: false)
  MoneyFunds? moneyFund;

  PrintReceipt() : super();

  @override
  String? getPrintableSortByName(BuildContext context) => null;

  @override
  String? getPrintableGroupByName() => null;

  @override
  SortByType? getPrintableHasSortBy() => SortByType.ASC;

  @override
  PrintReceipt getSelfNewInstance() {
    return PrintReceipt();
  }

  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() =>
      super.getMirrorFieldsMapNewInstance()
        ..addAll({
          "hideEmployeeName": false,
          "hideCustomerBalance": false,
          "hideInvoiceDate": false,
        });

  @override
  List<String> getMainFields({BuildContext? context}) =>
      super.getMainFields(context: context)
        ..addAll([
          "hideCustomerBalance",
          "hideEmployeeName",
          "hideInvoiceDate",
        ]);

  @override
  String getTextCheckBoxDescription(BuildContext context, String field) {
    if (field == "hideCustomerBalance") {
      return AppLocalizations.of(context)!.hideAccountBalanceDes;
    } else if (field == "hideInvoiceDate") {
      return AppLocalizations.of(context)!.hideDateDes;
    } else if (field == "hideEmployeeName") {
      return AppLocalizations.of(context)!.hideEmployeeDes;
    }
    return super.getTextCheckBoxDescription(context, field);
  }

  @override
  Map<String, String> getFieldLabelMap(BuildContext context) =>
      super.getFieldLabelMap(context)
        ..addAll({
          "hideCustomerBalance":
              AppLocalizations.of(context)!.hideAccountBalance,
          "hideInvoiceDate": AppLocalizations.of(context)!.hideDate,
          "hideEmployeeName": AppLocalizations.of(context)!.hideEmployee,
        });

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
  PrintReceipt fromJsonViewAbstract(Map<String, dynamic> json) =>
      PrintReceipt.fromJson(json);

  factory PrintReceipt.fromJson(Map<String, dynamic> data) =>
      _$PrintReceiptFromJson(data);

  Map<String, dynamic> toJson() => _$PrintReceiptToJson(this);

  @override
  PrintReceipt onSavedModiablePrintableLoaded(
      BuildContext context, ViewAbstract viewAbstractThatCalledPDF) {
    debugPrint(
        "onSavedModiablePrintableLoaded ${viewAbstractThatCalledPDF.runtimeType}");
    return this;
  }
}
