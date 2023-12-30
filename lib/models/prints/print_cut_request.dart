import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/icon_data.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/services/text_input.dart';
import 'package:flutter_saffoury_paper/models/invoices/cuts_invoices/cut_requests.dart';
import 'package:flutter_saffoury_paper/models/products/products.dart';
import 'package:flutter_view_controller/models/prints/print_local_setting.dart';
import 'package:flutter_view_controller/models/prints/printer_options.dart';
import 'package:flutter_view_controller/models/prints/report_options.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_enum.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

import '../funds/money_funds.dart';
import 'package:flutter_view_controller/models/view_abstract_permissions.dart';
part 'print_cut_request.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class PrintCutRequest extends PrintLocalSetting<PrintCutRequest> {
  bool? hideCustomerName;
  bool? hideInvoiceDate;
  bool? hideEmployeeName;
  bool? skipWastedProduct;

  ProductNameOption? productNameOption;

  PrintCutRequestType? printCutRequestType;

  PrintCutRequest() : super();

  @override
  String? getPrintableSortByName(BuildContext context) => null;
  @override
  String? getPrintableGroupByName() => null;
  @override
  SortByType? getPrintableHasSortBy() => null;

  @override
  PrintCutRequest getSelfNewInstance() {
    return PrintCutRequest();
  }

  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() =>
      super.getMirrorFieldsMapNewInstance()
        ..addAll({
          "hideEmployeeName": false,
          "hideCustomerName": false,
          "hideInvoiceDate": false,
          "printCutRequestType": PrintCutRequestType.ALL
        });

  @override
  List<String> getMainFields({BuildContext? context}) =>
      super.getMainFields(context: context)
        ..addAll([
          "hideCustomerName",
          "hideEmployeeName",
          "hideInvoiceDate",
          "printCutRequestType"
        ]);
  @override
  String getTextCheckBoxDescription(BuildContext context, String field) {
    if (field == "hideCustomerName") {
      return AppLocalizations.of(context)!.hideCustomerNameDes;
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
          "hideCustomerName": AppLocalizations.of(context)!.hideCustomerName,
          "hideInvoiceDate": AppLocalizations.of(context)!.hideDate,
          "hideEmployeeName": AppLocalizations.of(context)!.hideEmployee,
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
  PrintCutRequest fromJsonViewAbstract(Map<String, dynamic> json) =>
      PrintCutRequest.fromJson(json);

  factory PrintCutRequest.fromJson(Map<String, dynamic> data) =>
      _$PrintCutRequestFromJson(data);

  Map<String, dynamic> toJson() => _$PrintCutRequestToJson(this);

  @override
  PrintCutRequest onSavedModiablePrintableLoaded(
      BuildContext context, ViewAbstract viewAbstractThatCalledPDF) {
    return this;
  }
}

enum PrintCutRequestType implements ViewAbstractEnum<PrintCutRequestType> {
  ALL,
  ONLY_PRODUCT_LABEL,
  ONLY_CUT_REQUEST;

  @override
  String getFieldLabelString(BuildContext context, PrintCutRequestType field) {
    switch (field) {
      case PrintCutRequestType.ALL:
        return AppLocalizations.of(context)!.all;
      case PrintCutRequestType.ONLY_PRODUCT_LABEL:
        return AppLocalizations.of(context)!.productLabel;
      case PrintCutRequestType.ONLY_CUT_REQUEST:
        return AppLocalizations.of(context)!.cutRequest;
    }
  }

  @override
  IconData getFieldLabelIconData(
      BuildContext context, PrintCutRequestType field) {
    switch (field) {
      case PrintCutRequestType.ALL:
        return Icons.all_inbox;
      case PrintCutRequestType.ONLY_PRODUCT_LABEL:
        return Product().getMainIconData();
      case PrintCutRequestType.ONLY_CUT_REQUEST:
        return CutRequest().getMainIconData();
    }
  }

  @override
  IconData getMainIconData() => Icons.abc;

  @override
  String getMainLabelText(BuildContext context) =>
      AppLocalizations.of(context)!.printOptionsEnum;

  @override
  List<PrintCutRequestType> getValues() => PrintCutRequestType.values;
}

enum ProductNameOption implements ViewAbstractEnum<ProductNameOption> {
  ALL,
  ONLY_CUT_REQUEST;

  @override
  String getFieldLabelString(BuildContext context, ProductNameOption field) {
    switch (field) {
      case ProductNameOption.ALL:
        return AppLocalizations.of(context)!.all;
      case ProductNameOption.ONLY_CUT_REQUEST:
        return AppLocalizations.of(context)!.changeOnlyCutRoll;
    }
  }

  @override
  IconData getFieldLabelIconData(
      BuildContext context, ProductNameOption field) {
    switch (field) {
      case ProductNameOption.ALL:
        return Icons.all_inbox;
      case ProductNameOption.ONLY_CUT_REQUEST:
        return CutRequest().getMainIconData();
    }
  }

  @override
  IconData getMainIconData() => Icons.abc;

  @override
  String getMainLabelText(BuildContext context) =>
      AppLocalizations.of(context)!.switchProductType;

  @override
  List<ProductNameOption> getValues() => ProductNameOption.values;
}
