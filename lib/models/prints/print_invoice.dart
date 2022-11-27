import 'package:flutter/src/widgets/icon_data.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/services/text_input.dart';
import 'package:flutter_saffoury_paper/models/invoices/invoice_master.dart';
import 'package:flutter_saffoury_paper/models/prints/print_cut_request.dart';
import 'package:flutter_view_controller/models/prints/print_local_setting.dart';
import 'package:flutter_view_controller/models/prints/printer_options.dart';
import 'package:flutter_view_controller/models/prints/report_options.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:flutter_view_controller/models/view_abstract_inputs_validaters.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

part 'print_invoice.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class PrintInvoice extends PrintLocalSetting<PrintInvoice> {
  bool? hideCustomerAddressInfo;
  bool? hideCustomerPhone;
  bool? hideCustomerBalance;
  bool? hideInvoicePaymentMethod;
  bool? hideInvoiceDate;
  bool? hideInvoiceDueDate;
  bool? hideUnitPriceAndTotalPrice;
  bool? hideEmployeeName;
  bool? hideCargoInfo;
  bool? hideTermsOfService = false;
  bool? hideAdditionalNotes = false;

  String? changeProductNameTo;
  ProductNameOption? productNameOption;

  String? sortByField;
  SortByType? sortByType;

  @JsonKey(ignore: true)
  InvoiceMaster? invoice;

  PrintInvoice() : super();

  @override
  String? getPrintableSortByName() => sortByField;

  @override
  SortByType getPrintableHasSortBy() => sortByType ?? SortByType.ASC;

  @override
  PrintInvoice getSelfNewInstance() {
    return PrintInvoice();
  }

  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() =>
      super.getMirrorFieldsMapNewInstance()
        ..addAll({
          "hideCustomerAddressInfo": false,
          "hideCustomerPhone": false,
          "hideEmployeeName": false,
          "hideCargoInfo": false,
          "hideCustomerBalance": false,
          "hideInvoicePaymentMethod": false,
          "hideUnitPriceAndTotalPrice": false,
          "hideTermsOfService": false,
          "hideInvoiceDate": false,
          "hideInvoiceDueDate": false,
          "hideAdditionalNotes": false,
          "sortByField": "",
          "productNameOption": ProductNameOption.ALL,
          "changeProductNameTo": "",
          "sortByType": SortByType.ASC,
        });

  @override
  ViewAbstractControllerInputType getInputType(String field) {
    if (field == "changeProductNameTo") {
      return ViewAbstractControllerInputType.EDIT_TEXT;
    }
    return super.getInputType(field);
  }

  @override
  String? getTextInputHint(BuildContext context, {String? field}) {
    if (field == "changeProductNameTo") {
      return AppLocalizations.of(context)!.changeInvoiceProductNameDes;
    }
    return super.getTextInputHint(context, field: field);
  }

  bool isPricelessInvoice() {
    if (invoice == null) return false;
    return invoice!.isPricelessInvoice();
  }

  @override
  List<String> getMainFields() => super.getMainFields()
    ..addAll([
      "sortByField",
      "sortByType",
      "productNameOption",
      "changeProductNameTo",
      "hideCustomerAddressInfo",
      "hideCustomerPhone",
      if (isPricelessInvoice() == false) "hideCustomerBalance",
      "hideEmployeeName",
      "hideCargoInfo",
      "hideInvoicePaymentMethod",
      if (isPricelessInvoice() == false) "hideUnitPriceAndTotalPrice",
      "hideInvoiceDate",
      if (isPricelessInvoice() == false) "hideInvoiceDueDate",
      if (isPricelessInvoice() == false) "hideTermsOfService",
      "hideAdditionalNotes",
    ]);
  @override
  String getTextCheckBoxDescription(BuildContext context, String field) {
    if (field == "hideCustomerAddressInfo") {
      return AppLocalizations.of(context)!.hideAccountAdressDes;
    } else if (field == "hideCustomerPhone") {
      return AppLocalizations.of(context)!.hideCustomerNameDes;
    } else if (field == "hideCustomerBalance") {
      return AppLocalizations.of(context)!.hideAccountBalanceDes;
    } else if (field == "hideInvoicePaymentMethod") {
      return AppLocalizations.of(context)!.hidePaymentMethodDes;
    } else if (field == "hideUnitPriceAndTotalPrice") {
      return AppLocalizations.of(context)!.hideInvoiceUnitAndTotalPriceDes;
    } else if (field == "hideInvoiceDate") {
      return AppLocalizations.of(context)!.hideDateDes;
    } else if (field == "hideInvoiceDueDate") {
      return AppLocalizations.of(context)!.hideDueDateDes;
    } else if (field == "hideTermsOfService") {
      return AppLocalizations.of(context)!.hideCompanyTermsDes;
    } else if (field == "hideAdditionalNotes") {
      return AppLocalizations.of(context)!.hideCompanyNotesDes;
    } else if (field == "hideEmployeeName") {
      return AppLocalizations.of(context)!.hideEmployeeDes;
    } else if (field == "hideCargoInfo") {
      return AppLocalizations.of(context)!.hideCargoInfoDes;
    } else if (field == "changeProductNameTo") {
      return AppLocalizations.of(context)!.change;
    }

    return super.getTextCheckBoxDescription(context, field);
  }

  @override
  Map<String, String> getFieldLabelMap(BuildContext context) =>
      super.getFieldLabelMap(context)
        ..addAll({
          "hideCustomerAddressInfo":
              AppLocalizations.of(context)!.hideAccountAdress,
          "hideCustomerPhone": AppLocalizations.of(context)!.hideAccountPhone,
          "hideCustomerBalance":
              AppLocalizations.of(context)!.hideAccountBalance,
          "hideInvoiceDate": AppLocalizations.of(context)!.hideDate,
          "hideInvoiceDueDate": AppLocalizations.of(context)!.hideDueDate,
          "hideEmployeeName": AppLocalizations.of(context)!.hideEmployee,
          "hideCargoInfo": AppLocalizations.of(context)!.hideCargoInfo,
          "hideInvoicePaymentMethod":
              AppLocalizations.of(context)!.hidePaymentMethod,
          "hideUnitPriceAndTotalPrice":
              AppLocalizations.of(context)!.hideInvoiceUnitAndTotalPrice,
          "hideTermsOfService": AppLocalizations.of(context)!.hideCompanyTerms,
          "hideAdditionalNotes": AppLocalizations.of(context)!.hideCompanyNotes,
          "sortByField": AppLocalizations.of(context)!.sortBy,
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
  Map<String, List> getTextInputIsAutoCompleteCustomListMap(
          BuildContext context) =>
      {
        "sortByField": invoice
                ?.getDetailMasterNewInstance()
                .getPrintableInvoiceTableHeaderAndContent(context, this)
                .keys
                .toList() ??
            []
      };

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
  PrintInvoice fromJsonViewAbstract(Map<String, dynamic> json) =>
      PrintInvoice.fromJson(json);

  factory PrintInvoice.fromJson(Map<String, dynamic> data) =>
      _$PrintInvoiceFromJson(data);

  Map<String, dynamic> toJson() => _$PrintInvoiceToJson(this);

  @override
  PrintInvoice onSavedModiablePrintableLoaded(
      BuildContext context, ViewAbstract viewAbstractThatCalledPDF) {
    debugPrint(
        "onSavedModiablePrintableLoaded ${viewAbstractThatCalledPDF.runtimeType}");
    invoice = viewAbstractThatCalledPDF as InvoiceMaster;
    return this;
  }
}
