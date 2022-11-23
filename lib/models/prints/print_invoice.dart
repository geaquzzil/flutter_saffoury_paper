import 'package:flutter/src/widgets/icon_data.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/services/text_input.dart';
import 'package:flutter_view_controller/models/prints/print_local_setting.dart';
import 'package:flutter_view_controller/models/prints/printer_options.dart';
import 'package:flutter_view_controller/models/prints/report_options.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
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

  bool? hideTermsOfService = false;
  bool? hideAdditionalNotes = false;

  String? sortByField;
  SortByType? sortByType;
  PrintInvoice() : super();

  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() =>
      super.getMirrorFieldsMapNewInstance()
        ..addAll({
          "hideCustomerAddressInfo": false,
          "hideCustomerPhone": false,
          "hideCustomerBalance": false,
          "hideInvoicePaymentMethod": false,
          "hideUnitPriceAndTotalPrice": false,
          "hideTermsOfService": false,
          "hideInvoiceDate": false,
          "hideInvoiceDueDate": false,
          "hideAdditionalNotes": false,
          "hideQrCode": false,
          "sortByField": "",
          "sortByType": SortByType.ASC,
        });

  @override
  List<String> getMainFields() => super.getMainFields()
    ..addAll([
      "hideCustomerAddressInfo",
      "hideCustomerPhone",
      "hideCustomerBalance",
      "hideInvoicePaymentMethod",
      "hideUnitPriceAndTotalPrice",
      "hideInvoiceDate",
      "hideInvoiceDueDate",
      "hideTermsOfService",
      "hideAdditionalNotes",
      "hideQrCode",
      "sortByField",
      "sortByType",
    ]);
  @override
  Map<String, String> getFieldLabelMap(BuildContext context) =>
      super.getFieldLabelMap(context)
        ..addAll({
          "hideCustomerAddressInfo":
              AppLocalizations.of(context)!.hideAccountAddressAndPhone,
          "hideCustomerPhone": AppLocalizations.of(context)!.hideAccountPhone,
          "hideCustomerBalance":
              AppLocalizations.of(context)!.hideAccountBalance,
          "hideInvoiceDate": AppLocalizations.of(context)!.hideDate,
          "hideInvoiceDueDate": AppLocalizations.of(context)!.hideDueDate,
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
}
