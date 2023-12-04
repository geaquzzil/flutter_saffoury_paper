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
import 'package:flutter_view_controller/models/permissions/user_auth.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_view_controller/models/view_abstract_inputs_validaters.dart';
import 'package:flutter_view_controller/printing_generator/pdf_receipt_api.dart';
import 'package:flutter_view_controller/providers/auth_provider.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pdf;
import 'package:number_to_character/number_to_character.dart';
import 'package:provider/provider.dart';
import 'package:flutter_view_controller/models/view_abstract_permissions.dart';
import 'package:flutter_view_controller/models/view_abstract_permissions.dart';
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
  void onBeforeGenerateView(BuildContext context, {ServerActions? action}) {
    super.onBeforeGenerateView(context);
    if (action == ServerActions.edit && isNew()) {
      employees =
          context.read<AuthProvider<AuthUser>>().getSimpleUser as Employee;
    }
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
  Map<String, double> getTextInputMinValidateMap() => {"value": 0.1};

  @override
  Map<String, TextInputType?> getTextInputTypeMap() => {
        "value": TextInputType.numberWithOptions(decimal: true, signed: false),
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
    T c = getSelfNewInstance();
    (c as MoneyFunds).customers = Customer()..name = "Test";
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
  pdf.Widget? getPrintableRecieptCustomWidget(
          BuildContext context, PrintReceipt? pca, PdfReceipt generator) =>
      null;
  @override
  Map<int, List<RecieptHeaderTitleAndDescriptionInfo>>
      getPrintableRecieptFooterTitleAndDescription(
              BuildContext context, PrintReceipt? pca) =>
          {};
  @override
  Map<int, List<RecieptHeaderTitleAndDescriptionInfo>>
      getPrintableRecieptHeaderTitleAndDescription(
          BuildContext context, PrintReceipt? pca) {
    var converter = NumberToCharacterConverter('en');
    return {
      0: [
        RecieptHeaderTitleAndDescriptionInfo(
            title: AppLocalizations.of(context)!.mr,
            description: customers?.name ?? ""),
        RecieptHeaderTitleAndDescriptionInfo(
            title: AppLocalizations.of(context)!.iD,
            description: "${iD.toString()}\n${date.toString()}"),
      ],
      2: [
        RecieptHeaderTitleAndDescriptionInfo(
            title: AppLocalizations.of(context)!.payemntAmount,
            description: value?.toCurrencyFormat() ?? ""),
      ],
      3: [
        RecieptHeaderTitleAndDescriptionInfo(
            title: AppLocalizations.of(context)!.inWords.toUpperCase(),
            description: converter.convertDouble(value ?? 0)),
      ],
      4: [
        RecieptHeaderTitleAndDescriptionInfo(
            title: AppLocalizations.of(context)!.comments,
            description: comments ?? ""),
      ],
      if ((pca?.hideCustomerBalance == false))
        5: [
          RecieptHeaderTitleAndDescriptionInfo(
              title: AppLocalizations.of(context)!.balance,
              description: customers?.balance.toCurrencyFormat() ?? "")
        ],
      if ((pca?.hideEmployeeName == false))
        6: [
          RecieptHeaderTitleAndDescriptionInfo(
              title: AppLocalizations.of(context)!.employee,
              description: employees?.name ?? "")
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
  Color? getMainColor() {
    if (runtimeType == Credits) {
      return Colors.green;
    } else if (runtimeType == Debits) {
      return Colors.red;
    } else if (runtimeType == Spendings) {
      return Colors.red;
    } else {
      return Colors.green;
    }
  }

  @override
  String getPrintablePrimaryColor(PrintReceipt? setting) {
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
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss", 'en');

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
  String getPrintableSecondaryColor(PrintReceipt? setting) {
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

  @override
  pdf.Widget? getPrintableWatermark() => null;
}
