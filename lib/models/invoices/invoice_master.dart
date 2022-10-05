import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/invoices/cargo_transporters.dart';
import 'package:flutter_saffoury_paper/models/users/customers.dart';
import 'package:flutter_saffoury_paper/models/users/employees.dart';
import 'package:flutter_view_controller/interfaces/printable_interface.dart';
import 'package:flutter_view_controller/models/prints/print_commad_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_view_controller/printing_generator/pdf_invoice_api.dart';

import 'orders.dart';

abstract class InvoiceMaster<T> extends ViewAbstract<T>
    implements PrintableInterface {
  // int? EmployeeID;
  // int? CargoTransID;
  // int? CustomerID;
  int? TermsID;

  String? date;
  String? billNo; //255
  String? comments;

  Employee? employees;
  Customer? customers;
  CargoTransporter? cargo_transporters;

  InvoiceStatus? status;

  InvoiceMaster() : super();
  @override
  String? getListableFieldName() {
    debugPrint("getListableFieldName $runtimeType");
    if (runtimeType == Order) {
      return "orders_details";
    }
    return super.getListableFieldName();
  }

  @override
  IconData? getMainDrawerGroupIconData() => Icons.receipt_long_rounded;
  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() => {
        "TermsID": 0,
        "date": "",
        "billNo": "",
        "comments": "",
        "employees": Employee(),
        "customers": Customer(),
        "cargo_transporters": CargoTransporter(),
        "status": InvoiceStatus.NONE
      };
  // @override
  // Map<String, dynamic> getMirrorFieldsMapNewInstance() => {
  //       "TermsID": 0,
  //       "date": "",
  //       "billNo": "",
  //       "comments": "",
  //       "employees": Employee(),
  //       "customers": Customer(),
  //       "cargo_transporters": CargoTransporter(),
  //       "status": InvoiceStatus.NONE,
  //     };

  // @override
  // Map<String, Type> getMirrorFieldsTypeMap() =>
  //    {
  //       "TermsID": int,
  //       "date": "",
  //       "billNo": "",
  //       "comments": "",
  //       "employees": Employee(),
  //       "customers": Customer(),
  //       "cargo_transporters": CargoTransporter(),
  //       "status": InvoiceStatus.NONE,
  //     };

  @override
  List<String> getMainFields() => [
        "customers",
        "cargo_transporters",
        "employees",
        "date",
        "billNo",
        "status",
        "comments"
      ];
  @override
  Map<String, String> getFieldLabelMap(BuildContext context) => {
        "date": AppLocalizations.of(context)!.date,
        "billNo": AppLocalizations.of(context)!.product_bill,
        "status": AppLocalizations.of(context)!.status,
        "comments": AppLocalizations.of(context)!.comments
      };
  @override
  Map<String, IconData> getFieldIconDataMap() => {
        "date": Icons.date_range,
        "billNo": Icons.onetwothree,
        "status": Icons.credit_card,
        "comments": Icons.comment
      };
  @override
  Map<String, TextInputType?> getTextInputTypeMap() => {
        "date": TextInputType.datetime,
        "billNo": TextInputType.text,
        "comments": TextInputType.text
      };
  @override
  String getMainHeaderTextOnly(BuildContext context) => getIDFormat(context);

  @override
  String? getSortByFieldName() => "date";

  @override
  SortByType getSortByType() => SortByType.DESC;

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
  Map<String, bool> isFieldRequiredMap() => {};
  @override
  Map<String, bool> isFieldCanBeNullableMap() => {
        "cargo_transporters": true,
        "warehouse": false // if there are warehouse then it cant be null
      };

  @override
  IconData getMainIconData() => Icons.receipt;
  @override
  String? getMainDrawerGroupName(BuildContext context) =>
      AppLocalizations.of(context)!.invoices;

  @override
  String getInvoiceTitle(BuildContext context, PrintCommandAbstract? pca) =>
      getMainHeaderLabelTextOnly(context).toUpperCase();
  @override
  List<List<TitleAndDescriptionInfoWithIcon>> getInvoiceInfo(
      BuildContext context, PrintCommandAbstract? pca) {
    return [
      getInvoicDesFirstRow(context, pca),
      getInvoiceDesSecRow(context, pca)
    ];
  }

  @override
  List<PrintableInterfaceDetails> getInvoiceDetailsList() {
    if (runtimeType == Order) {
      return (this as Order).orders_details ?? [];
    }
    return [];
  }

  List<TitleAndDescriptionInfoWithIcon> getInvoiceDesSecRow(
      BuildContext context, PrintCommandAbstract? pca) {
    return [
      TitleAndDescriptionInfoWithIcon(AppLocalizations.of(context)!.iD,
          customers?.iD.toString() ?? "", Icons.numbers),
      TitleAndDescriptionInfoWithIcon(AppLocalizations.of(context)!.date,
          customers?.date.toString() ?? "", Icons.date_range),
    ];
  }

  List<TitleAndDescriptionInfoWithIcon> getInvoicDesFirstRow(
      BuildContext context, PrintCommandAbstract? pca) {
    if (customers == null) return [];
    return [
      TitleAndDescriptionInfoWithIcon(AppLocalizations.of(context)!.mr,
          customers?.name ?? "", Icons.account_circle_rounded),
      if (customers?.address != null)
        TitleAndDescriptionInfoWithIcon(
            AppLocalizations.of(context)!.addressInfo,
            customers?.name ?? "",
            Icons.map),
      if (customers?.phone != null)
        TitleAndDescriptionInfoWithIcon(
            AppLocalizations.of(context)!.phone_number,
            customers?.phone ?? "",
            Icons.phone),
    ];
  }

  @override
  List<TitleAndDescriptionInfo> getInvoiceTotal(
      BuildContext context, PrintCommandAbstract? pca) {
    return [
      TitleAndDescriptionInfo("TOTAL", "@132!"),
      TitleAndDescriptionInfo("SUB TOTAL", "@132!"),
    ];
  }
}

enum InvoiceStatus { NONE, PENDING, PROCESSING, CANCELED, APPROVED }
