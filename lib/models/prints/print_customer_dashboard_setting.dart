import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/funds/currency/currency.dart';
import 'package:flutter_view_controller/models/prints/printer_options.dart';
import 'package:flutter_view_controller/models/prints/report_options.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_permissions.dart';
import 'package:json_annotation/json_annotation.dart';
import 'print_dashboard_setting.dart';

part 'print_customer_dashboard_setting.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class PrintCustomerDashboardSetting extends PrintDashboardSetting {
  bool? hideCustomerTerms = true;
  bool? hideCustomersNotCreditsInvoices = true;

  // bool? hide

  PrintCustomerDashboardSetting() : super();
  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() =>
      super.getMirrorFieldsMapNewInstance()
        ..addAll({
          "hideCustomersNotCreditsInvoices": true
          //todo add self properties
        });

  @override
  List<String> getMainFields({BuildContext? context}) =>
      super.getMainFields(context: context)
        ..addAll(["hideCustomersNotCreditsInvoices"]);
  @override
  String getTextCheckBoxDescription(BuildContext context, String field) {
    if (field == "hideCustomersNotCreditsInvoices") {}

    return super.getTextCheckBoxDescription(context, field);
  }

  @override
  Map<String, String> getFieldLabelMap(BuildContext context) =>
      super.getFieldLabelMap(context)
        ..addAll({
          "hideCustomersNotCreditsInvoices":
              "TODO hideCustomersNotCreditsInvoices"
        });

  @override
  Map<String, dynamic> toJsonViewAbstract() => toJson();
  @override
  PrintCustomerDashboardSetting fromJsonViewAbstract(
          Map<String, dynamic> json) =>
      PrintCustomerDashboardSetting.fromJson(json);

  factory PrintCustomerDashboardSetting.fromJson(Map<String, dynamic> data) =>
      _$PrintCustomerDashboardSettingFromJson(data);

  @override
  Map<String, dynamic> toJson() => _$PrintCustomerDashboardSettingToJson(this);

  @override
  PrintCustomerDashboardSetting onSavedModiablePrintableLoaded(
      BuildContext context, ViewAbstract viewAbstractThatCalledPDF) {
    debugPrint(
        "onSavedModiablePrintableLoaded ${viewAbstractThatCalledPDF.runtimeType}");
    return this;
  }
}
