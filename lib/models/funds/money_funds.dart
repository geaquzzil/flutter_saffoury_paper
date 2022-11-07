import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/funds/credits.dart';
import 'package:flutter_saffoury_paper/models/funds/currency/equalities.dart';
import 'package:flutter_saffoury_paper/models/funds/debits.dart';
import 'package:flutter_saffoury_paper/models/funds/incomes.dart';
import 'package:flutter_saffoury_paper/models/funds/spendings.dart';
import 'package:flutter_saffoury_paper/models/prints/print_reciept.dart';
import 'package:flutter_saffoury_paper/models/products/warehouse.dart';
import 'package:flutter_saffoury_paper/models/users/employees.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/helper_model/qr_code.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_bill_interface.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_master.dart';
import 'package:flutter_view_controller/interfaces/settings/ModifiableInterfaceAndPrintingSetting.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_view_controller/models/view_abstract_inputs_validaters.dart';
import 'package:intl/intl.dart';
import 'package:number_to_character/number_to_character.dart';
import '../users/customers.dart';

abstract class MoneyFunds<T> extends ViewAbstract<T>
    implements
        ModifiablePrintableInterface<PrintReceipt>,
        PrintableReceiptInterface<PrintReceipt> {
  // int? CashBoxID;
  // int? EmployeeID;
  // int? CustomerID;
  // int? EqualitiesID;

  int? fromBox;
  int? isDirect;

  String? date;
  double? value;

  String? comments;

  Customer? customers;
  Employee? employees;
  Equalities? equalities;
  Warehouse? warehouse;

  MoneyFunds() : super() {
    date = "".toDateTimeNowString();
  }

  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() => {
        "fromBox": 0.toInt(),
        "isDirect": 0.toInt(),
        "date": "",
        "value": 0.toDouble(),
        "comments": "",
        "customers": Customer(),
        "employees": Employee(),
        "equalities": Equalities(),
        "warehouse": Warehouse()
      };

  @override
  Map<String, IconData> getFieldIconDataMap() => {
        "value": Icons.attach_money_rounded,
        "date": Icons.date_range,
        "comments": Icons.notes
      };

  @override
  Map<String, String> getFieldLabelMap(BuildContext context) => {
        "value": AppLocalizations.of(context)!.value,
        "date": AppLocalizations.of(context)!.date,
        "comments": AppLocalizations.of(context)!.comments
      };

  @override
  String getMainHeaderTextOnly(BuildContext context) {
    return "${customers?.name}: $value";
  }

  @override
  IconData? getMainDrawerGroupIconData() => Icons.credit_card;
  @override
  String? getSortByFieldName() => "date";

  @override
  SortByType getSortByType() => SortByType.DESC;

  @override
  Map<String, bool> getTextInputIsAutoCompleteMap() => {};

  @override
  Map<String, bool> getTextInputIsAutoCompleteViewAbstractMap() => {};

  @override
  Map<String, int> getTextInputMaxLengthMap() => {"value": 12};

  @override
  Map<String, double> getTextInputMaxValidateMap() => {};

  @override
  Map<String, double> getTextInputMinValidateMap() => {};

  @override
  Map<String, TextInputType?> getTextInputTypeMap() => {
        "value": TextInputType.number,
        "date": TextInputType.datetime,
        "comments": TextInputType.text
      };

  @override
  Map<String, bool> isFieldCanBeNullableMap() => {};

  @override
  Map<String, bool> isFieldRequiredMap() => {"value": true};

  @override
  String? getMainDrawerGroupName(BuildContext context) =>
      AppLocalizations.of(context)!.money_fund;

  @override
  String getModifiableMainGroupName(BuildContext context) =>
      AppLocalizations.of(context)!.money_fund;

  @override
  IconData getModifibleIconData() => Icons.receipt;
  @override
  PrintReceipt getModifibleSettingObject(BuildContext context) =>
      PrintReceipt();

  @override
  PrintableMaster getModifiablePrintablePdfSetting(BuildContext context) {
    Credits c = Credits();
    c.customers = Customer()..name = "Test";
    c.employees = Employee()..name = "Test";
    c.value = 29099;
    c.comments = "this is a comment";
    return c;
  }

  @override
  String getPrintableInvoiceTitle(BuildContext context, PrintReceipt? pca) =>
      getMainHeaderLabelTextOnly(context);
  @override
  ViewAbstractControllerInputType getInputType(String field) {
    if (field == "warehouse" || field == "employees" || field == "customers")
      return ViewAbstractControllerInputType.DROP_DOWN_API;
    return ViewAbstractControllerInputType.EDIT_TEXT;
  }

  @override
  Map<int, List<RecieptHeaderTitleAndDescriptionInfo>>
      getPrintableRecieptHeaderTitleAndDescription(
          BuildContext context, PrintReceipt? pca) {
    var converter = NumberToCharacterConverter('en');
    return {
      0: [
        RecieptHeaderTitleAndDescriptionInfo(
            title: AppLocalizations.of(context)!.iD,
            description: iD.toString()),
        // RecieptHeaderTitleAndDescriptionInfo(
        //     title: AppLocalizations.of(context)!.date,
        //     description: date.toString()),
      ],
      10: [
        // RecieptHeaderTitleAndDescriptionInfo(
        //     title: AppLocalizations.of(context)!.iD,
        //     description: iD.toString()),
        RecieptHeaderTitleAndDescriptionInfo(
            title: AppLocalizations.of(context)!.date,
            description: date.toString()),
      ],
      1: [
        RecieptHeaderTitleAndDescriptionInfo(
            title: AppLocalizations.of(context)!.mr,
            description: customers?.name ?? ""),
      ],
      2: [
        RecieptHeaderTitleAndDescriptionInfo(
            title: AppLocalizations.of(context)!.payemntAmount,
            description: value?.toStringAsFixed(2) ?? ""),
      ],
      3: [
        RecieptHeaderTitleAndDescriptionInfo(
            title: "IN WORDS",
            description: converter.convertDouble(value ?? 0)),
      ],
      4: [
        RecieptHeaderTitleAndDescriptionInfo(
            title: AppLocalizations.of(context)!.comments,
            description: comments ?? ""),
      ],
    };
  }

  /// get value multiply bt equality
  double getValue() {
    return value.toNonNullable() * (equalities?.value.toNonNullable() ?? 0);
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
    if (runtimeType == Credits) {
      return Colors.green.toHex();
    } else if (runtimeType == Debits) {
      return Colors.red.toHex();
    } else if (runtimeType == Spendings) {
      return Colors.red.toHex();
    } else {
      return Colors.green.toHex();
    }
  }

  @override
  String getPrintableQrCodeID() {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

    String year = "${dateFormat.parse(date ?? "").year}";
    String invCode = "";

    if (runtimeType == Credits) {
      invCode = "CRD";
    } else if (runtimeType == Debits) {
      invCode = "DIB";
    } else if (runtimeType == Spendings) {
      invCode = "SP";
    } else if (runtimeType == Incomes) {
      invCode = "INC";
    }
    return "$invCode-$iD-$year";
  }

  @override
  String getPrintableSecondaryColor() {
    if (runtimeType == Credits) {
      return Colors.green.toHex();
    } else if (runtimeType == Debits) {
      return Colors.red.toHex();
    } else if (runtimeType == Spendings) {
      return Colors.red.toHex();
    } else {
      return Colors.green.toHex();
    }
  }

  @override
  String getModifibleTitleName(BuildContext context) =>
      getMainHeaderLabelTextOnly(context);
}
