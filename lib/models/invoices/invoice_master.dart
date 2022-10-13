import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/cities/governorates.dart';
import 'package:flutter_saffoury_paper/models/invoices/cargo_transporters.dart';
import 'package:flutter_saffoury_paper/models/invoices/purchases.dart';
import 'package:flutter_saffoury_paper/models/invoices/refund_invoices/orders_refunds.dart';
import 'package:flutter_saffoury_paper/models/invoices/refund_invoices/purchasers_refunds.dart';
import 'package:flutter_saffoury_paper/models/prints/print_product.dart';
import 'package:flutter_saffoury_paper/models/users/customers.dart';
import 'package:flutter_saffoury_paper/models/users/employees.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/helper_model/qr_code.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_invoice_interface.dart';
import 'package:flutter_view_controller/interfaces/settings/ModifiableInterfaceAndPrintingSetting.dart';
// import 'package:flutter_view_controller/interfaces/settings/printable_setting.dart';
import 'package:flutter_view_controller/models/prints/print_commad_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:number_to_character/number_to_character.dart';

import 'orders.dart';

abstract class InvoiceMaster<T> extends ViewAbstract<T>
    implements
        PrintableInvoiceInterface,
        ModifiablePrintableInterface<PrintProduct> {
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
  @JsonKey(fromJson: convertToDouble)
  double? quantity;
  @JsonKey(fromJson: convertToDouble)
  double? extendedPrice;
  @JsonKey(fromJson: convertToDouble)
  double? refundQuantity;
  @JsonKey(fromJson: convertToDouble)
  double? extendedRefundPrice;
  @JsonKey(fromJson: convertToDouble)
  double? extendedDiscount;
  @JsonKey(fromJson: convertToDouble)
  double? extendedNetPrice;

  InvoiceMaster() : super() {
    date = "".toDateTimeNowString();
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
  String getPrintableInvoiceTitle(
          BuildContext context, PrintCommandAbstract? pca) =>
      getMainHeaderLabelTextOnly(context).toUpperCase();
  @override
  List<List<InvoiceHeaderTitleAndDescriptionInfo>> getPrintableInvoiceInfo(
      BuildContext context, PrintCommandAbstract? pca) {
    return [
      getInvoicDesFirstRow(context, pca),
      getInvoiceDesSecRow(context, pca),
      getInvoiceDesTherdRow(context, pca)
    ];
  }

  @override
  List<InvoiceHeaderTitleAndDescriptionInfo>
      getPrintableInvoiceAccountInfoInBottom(
              BuildContext context, PrintCommandAbstract? pca) =>
          [
            if (customers != null)
              InvoiceHeaderTitleAndDescriptionInfo(
                title: "${AppLocalizations.of(context)!.name}: ",
                description: customers?.name ?? "",
                // icon: Icons.account_circle_rounded
              ),
            if (customers != null)
              InvoiceHeaderTitleAndDescriptionInfo(
                title: "${AppLocalizations.of(context)!.iD}: ",
                description: customers?.iD.toString() ?? "",
                // icon: Icons.numbers
              ),
            if (cargo_transporters != null)
              InvoiceHeaderTitleAndDescriptionInfo(
                title: "${AppLocalizations.of(context)!.transfers}: ",
                description:
                    "${cargo_transporters?.name.toString()}\n${cargo_transporters?.carNumber} ${cargo_transporters?.governorates?.name}",
                // icon: Icons.numbers
              )
          ];
  @override
  String getPrintableQrCodeID() {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

    String year = "${dateFormat.parse(date ?? "").year}";
    String invCode = "";

    if (runtimeType == Order) {
      invCode = "INV";
    } else if (runtimeType == Purchases) {
      invCode = "PURCH";
    } else if (runtimeType == OrderRefund) {
      invCode = "INV-R";
    } else if (runtimeType == PurchasesRefund) {
      invCode = "PURCH-R";
    }
    return "$invCode-$iD-$year";
  }

  @override
  String getPrintableQrCode() {
    var q = QRCodeID(
      iD: iD,
      action: getTableNameApi() ?? "",
    );
    return q.getQrCode();
  }

  @override
  String getPrintablePrimaryColor() {
    if (runtimeType == Order) {
      return Colors.green.value.toRadixString(16).substring(2, 8);
    }
    return "";
  }

  @override
  String getPrintableSecondaryColor() {
    if (runtimeType == Order) {
      return const Color.fromARGB(255, 33, 140, 39)
          .value
          .toRadixString(16)
          .substring(2, 8);
    }
    return "";
  }

  @override
  List<PrintableInvoiceInterfaceDetails> getPrintableInvoiceDetailsList() {
    if (runtimeType == Order) {
      return (this as Order).orders_details ?? [];
    }
    return [];
  }

  List<InvoiceHeaderTitleAndDescriptionInfo> getInvoiceDesSecRow(
      BuildContext context, PrintCommandAbstract? pca) {
    return [
      InvoiceHeaderTitleAndDescriptionInfo(
        title: AppLocalizations.of(context)!.iD,
        description: customers?.iD.toString() ?? "",
        // icon: Icons.numbers
      ),
      InvoiceHeaderTitleAndDescriptionInfo(
        title: AppLocalizations.of(context)!.date,
        description: customers?.date.toString() ?? "",
        // icon: Icons.date_range
      ),
    ];
  }

  List<InvoiceHeaderTitleAndDescriptionInfo> getInvoiceDesTherdRow(
      BuildContext context, PrintCommandAbstract? pca) {
    return [
      InvoiceHeaderTitleAndDescriptionInfo(
          title: AppLocalizations.of(context)!.total_price,
          description: extendedNetPrice?.toStringAsFixed(2) ?? "0",
          hexColor: Colors.green.toHex()
          // icon: Icons.tag
          ),
      InvoiceHeaderTitleAndDescriptionInfo(
          title: AppLocalizations.of(context)!.balance,
          description: customers?.balance?.toStringAsFixed(2) ?? "",
          hexColor: Colors.green.toHex()
          // icon: Icons.balance
          ),
      InvoiceHeaderTitleAndDescriptionInfo(
          title: AppLocalizations.of(context)!.paymentMethod,
          description: "payment on advanced",
          hexColor: Colors.green.toHex()
          // icon: Icons.credit_card
          ),
    ];
  }

  List<InvoiceHeaderTitleAndDescriptionInfo> getInvoicDesFirstRow(
      BuildContext context, PrintCommandAbstract? pca) {
    if (customers == null) return [];
    return [
      InvoiceHeaderTitleAndDescriptionInfo(
        title: AppLocalizations.of(context)!.mr,
        description: customers?.name ?? "",
        // icon: Icons.account_circle_rounded
      ),
      if (customers?.address != null)
        InvoiceHeaderTitleAndDescriptionInfo(
          title: AppLocalizations.of(context)!.addressInfo,
          description: customers?.name ?? "",
          // icon: Icons.map
        ),
      if (customers?.phone != null)
        InvoiceHeaderTitleAndDescriptionInfo(
          title: AppLocalizations.of(context)!.phone_number,
          description: customers?.phone ?? "",
          // icon: Icons.phone
        ),
    ];
  }

  @override
  List<InvoiceTotalTitleAndDescriptionInfo> getPrintableInvoiceTotalDescripton(
      BuildContext context, PrintCommandAbstract? pca) {
    var converter = NumberToCharacterConverter('en');
    return [
      InvoiceTotalTitleAndDescriptionInfo(
          size: 10,
          title: AppLocalizations.of(context)!.total_quantity.toUpperCase(),
          description: quantity?.toStringAsFixed(2) ?? "0",
          hexColor: Colors.grey.toHex()),
      InvoiceTotalTitleAndDescriptionInfo(
          size: 8,
          title: "Invoice total (in words)",
          hexColor: Colors.grey.toHex(leadingHashSign: false)),
      InvoiceTotalTitleAndDescriptionInfo(
        // size: 12,
        title: converter.convertDouble(quantity ?? 0),
        // hexColor: Colors.grey.toHex()
      ),
    ];
  }

  @override
  List<InvoiceTotalTitleAndDescriptionInfo> getPrintableInvoiceTotal(
      BuildContext context, PrintCommandAbstract? pca) {
    return [
      InvoiceTotalTitleAndDescriptionInfo(
          title: AppLocalizations.of(context)!.subTotal.toUpperCase(),
          description: extendedPrice?.toStringAsFixed(2) ?? "0"),
      InvoiceTotalTitleAndDescriptionInfo(
          title: AppLocalizations.of(context)!.discount.toUpperCase(),
          description: extendedDiscount?.toStringAsFixed(2) ?? "0"),
      InvoiceTotalTitleAndDescriptionInfo(
          title: AppLocalizations.of(context)!.grandTotal.toUpperCase(),
          description: extendedNetPrice?.toStringAsFixed(2) ?? "0",
          hexColor: getPrintablePrimaryColor()),
    ];
  }

  @override
  String getModifibleTitleName(BuildContext context) =>
      getMainHeaderLabelTextOnly(context);
  @override
  String getModifiableMainGroupName(BuildContext context) =>
      AppLocalizations.of(context)!.printerSetting;

  @override
  IconData getModifibleIconData() => Icons.print;

  @override
  PrintProduct getModifibleSettingObject(BuildContext context) {
    return PrintProduct(printObject: this);
  }

  @override
  PrintableInvoiceInterface getModifiablePrintablePdfSetting(
      BuildContext context) {
    Order o = Order();
    o.customers = Customer()..name = "TEST";
    o.customers?.address = "Damascus - Syria";
    o.customers?.phone = "099999999";
    o.cargo_transporters = CargoTransporter();
    o.cargo_transporters?.governorates = Governorate()..name = "Damascus";
    o.cargo_transporters?.name = "Test Driver";
    o.cargo_transporters?.carNumber = "123-435";
    o.employees = Employee()..name = "TEST";
    return o..orders_details?.add(OrderDetails());
  }

  static double? convertToDouble(dynamic number) =>
      number == null ? 0 : double.tryParse(number.toString());
}

enum InvoiceStatus { NONE, PENDING, PROCESSING, CANCELED, APPROVED }
