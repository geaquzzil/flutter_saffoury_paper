import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/funds/accounts/account_names.dart';
import 'package:flutter_saffoury_paper/models/funds/credits.dart';
import 'package:flutter_saffoury_paper/models/funds/currency/currency.dart';
import 'package:flutter_saffoury_paper/models/funds/currency/equalities.dart';
import 'package:flutter_saffoury_paper/models/funds/debits.dart';
import 'package:flutter_saffoury_paper/models/funds/incomes.dart';
import 'package:flutter_saffoury_paper/models/funds/spendings.dart';
import 'package:flutter_saffoury_paper/models/prints/print_dashboard_setting.dart';
import 'package:flutter_saffoury_paper/models/prints/print_reciept.dart';
import 'package:flutter_saffoury_paper/models/products/warehouse.dart';
import 'package:flutter_saffoury_paper/models/users/employees.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/helper_model/qr_code.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_bill_interface.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_master.dart';
import 'package:flutter_view_controller/interfaces/settings/ModifiableInterfaceAndPrintingSetting.dart';
import 'package:flutter_view_controller/interfaces/sharable_interface.dart';
import 'package:flutter_view_controller/interfaces/web/category_gridable_interface.dart';
import 'package:flutter_view_controller/l10n/app_localization.dart';
import 'package:flutter_view_controller/models/permissions/user_auth.dart';
import 'package:flutter_view_controller/models/prints/print_local_setting.dart';
import 'package:flutter_view_controller/models/request_options.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:flutter_view_controller/models/view_abstract_inputs_validaters.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_view_abstract_new.dart';
import 'package:flutter_view_controller/printing_generator/pdf_receipt_api.dart';
import 'package:flutter_view_controller/providers/auth_provider.dart';
import 'package:flutter_view_controller/screens/base_shared_drawer_navigation.dart';
import 'package:intl/intl.dart';
import 'package:number_to_character/number_to_character.dart';
import 'package:pdf/pdf.dart' as d;
import 'package:pdf/widgets.dart' as pdf;
import 'package:provider/provider.dart';

import '../users/customers.dart';

abstract class MoneyFunds<T extends ViewAbstract> extends ViewAbstract<T>
    with ModifiableInterface<PrintReceipt>
    implements
        PrintableReceiptInterface<PrintReceipt>,
        WebCategoryGridableInterface<T>,
        SharableInterface {
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
      employees = context.read<AuthProvider<AuthUser>>().getUser as Employee?;
    }
  }

  @override
  Widget? getCardTrailing(
    BuildContext context, {
    SecoundPaneHelperWithParentValueNotifier? secPaneHelper,
  }) {
    Widget? superWidget = super.getCardTrailing(
      context,
      secPaneHelper: secPaneHelper,
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value.toCurrencyFormat(),
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        SizedBox(width: 4),
        Text(
          equalities?.currency?.name ?? "-",
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        if (superWidget != null) superWidget,
      ],
    );
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
    "warehouse": Warehouse(),
    "account_names": AccountName(),
  };

  @override
  Map<String, IconData> getFieldIconDataMap() => {
    "value": Icons.attach_money_rounded,
    "date": Icons.date_range,
    "comments": Icons.notes,
  };

  @override
  Map<String, String> getFieldLabelMap(BuildContext context) => {
    "value": AppLocalizations.of(context)!.value,
    "date": AppLocalizations.of(context)!.date,
    "comments": AppLocalizations.of(context)!.comments,
  };

  @override
  String getMainHeaderTextOnly(BuildContext context) {
    return "${customers?.name}: $value";
  }

  @override
  IconData? getMainDrawerGroupIconData() => Icons.credit_card;

  @override
  RequestOptions? getRequestOption({
    required ServerActions action,
    RequestOptions? generatedOptionFromListCall,
  }) {
    if (action == ServerActions.list) {
      return RequestOptions(
        sortBy: SortFieldValue(field: "date", type: SortByType.DESC),
      ).addRequestObjcets(true);
    }

    return null;
  }

  @override
  List<String>? getRequestedForginListOnCall({required ServerActions action}) {
    return null;
  }

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
    "value": const TextInputType.numberWithOptions(
      decimal: true,
      signed: false,
    ),
    "date": TextInputType.datetime,
    "comments": TextInputType.multiline,
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

  // @override
  // PrintableMaster getModifiablePrintablePdfSetting(BuildContext context) {
  //   T c = getSelfNewInstance();
  //   (c as MoneyFunds).customers = Customer()..name = "Test";
  //   c.employees = Employee()..name = "Test";
  //   c.value = 29099;
  //   c.comments = "this is a comment";
  //   return c;
  // }

  @override
  String getPrintableInvoiceTitle(BuildContext context, PrintReceipt? pca) =>
      getMainHeaderLabelTextOnly(context);
  @override
  FormFieldControllerType getInputType(String field) {
    if (field == "warehouse" || field == "employees" || field == "customers") {
      return FormFieldControllerType.DROP_DOWN_API;
    }
    return FormFieldControllerType.EDIT_TEXT;
  }

  @override
  pdf.Widget? getPrintableRecieptCustomWidget(
    BuildContext context,
    PrintReceipt? pca,
    PdfReceipt generator,
  ) => null;
  @override
  Map<int, List<RecieptHeaderTitleAndDescriptionInfo>>
  getPrintableRecieptFooterTitleAndDescription(
    BuildContext context,
    PrintReceipt? pca,
  ) => {};
  @override
  Map<int, List<RecieptHeaderTitleAndDescriptionInfo>>
  getPrintableRecieptHeaderTitleAndDescription(
    BuildContext context,
    PrintReceipt? pca,
  ) {
    var converter = NumberToCharacterConverter('en');
    return {
      0: [
        RecieptHeaderTitleAndDescriptionInfo(
          title: AppLocalizations.of(context)!.mr,
          description: customers?.name ?? "",
        ),
        RecieptHeaderTitleAndDescriptionInfo(
          title: AppLocalizations.of(context)!.iD,
          description: "${iD.toString()}\n${date.toString()}",
        ),
      ],
      2: [
        RecieptHeaderTitleAndDescriptionInfo(
          title: AppLocalizations.of(context)!.payemntAmount,
          description: value?.toCurrencyFormat() ?? "",
        ),
      ],
      3: [
        RecieptHeaderTitleAndDescriptionInfo(
          title: AppLocalizations.of(context)!.inWords.toUpperCase(),
          description: converter.convertDouble(value ?? 0),
        ),
      ],
      4: [
        RecieptHeaderTitleAndDescriptionInfo(
          title: AppLocalizations.of(context)!.comments,
          description: comments ?? "",
        ),
      ],
      if ((pca?.hideCustomerBalance == false))
        5: [
          RecieptHeaderTitleAndDescriptionInfo(
            title: AppLocalizations.of(context)!.balance,
            description: customers?.balance.toCurrencyFormat() ?? "",
          ),
        ],
      if ((pca?.hideEmployeeName == false))
        6: [
          RecieptHeaderTitleAndDescriptionInfo(
            title: AppLocalizations.of(context)!.employee,
            description: employees?.name ?? "",
          ),
        ],
    };
  }

  /// get value multiply bt equality
  double getValue() {
    return value.toNonNullable() * (equalities?.value.toNonNullable() ?? 0);
  }

  @override
  String getPrintableQrCode() {
    var q = QRCodeID(iD: iD, action: getTableNameApi() ?? "");
    return q.getQrCode();
  }

  bool isCreditAndDebit() {
    return runtimeType == Debits || runtimeType == Credits;
  }

  bool isSpendingAndIncomes() {
    return runtimeType == Spendings || runtimeType == Incomes;
  }

  bool isSpendings() {
    return runtimeType == Debits || runtimeType == Spendings;
  }

  bool isIncomes() {
    return runtimeType == Incomes || runtimeType == Credits;
  }

  @override
  bool getPrintableSupportsLabelPrinting() => false;

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
  String getForeignKeyName() {
    if (runtimeType == Credits) {
      return "CreditID";
    } else if (runtimeType == Debits) {
      return "DebitID";
    } else if (runtimeType == Spendings) {
      return "SpendingID";
    } else {
      return "IncomesID";
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

  bool isDollar() {
    return equalities?.isDollar() ?? false;
  }

  @override
  pdf.Widget? getPrintableWatermark(d.PdfPageFormat? format) => null;

  String getIdWithLabelWithIsDollar(BuildContext context) {
    bool isD = isDollar();
    String addOn = "";
    if (!isD) {
      addOn = " -${equalities?.getMainHeaderTextOnly(context)}";
    }
    return "${getMainHeaderLabelTextOnly(context)} ${getIDFormat(context)}$addOn";
  }

  String getIdWithLabelWithIsDollarForDashboard(
    BuildContext context,
    PrintLocalSetting? pca,
  ) {
    bool isD = isDollar();
    String addOn = "";
    if (!isD) {
      addOn = " -${equalities?.getMainHeaderTextOnly(context)}";
    }
    return "${getMainHeaderLabelTextOnly(context)} ${getIDFormat(context)}$addOn";
  }

  double getValueForDashboard(BuildContext context, PrintLocalSetting? pca) {
    PrintDashboardSetting? setting;
    if (pca != null) {
      setting = pca as PrintDashboardSetting;
    }
    Currency? c = setting?.currency;
    if (c == null) {
      return value.toNonNullable();
    } else if (c.iD == 1) {
      return value.toNonNullable() * (equalities?.value.toNonNullable() ?? 0);
    } else {
      return value.toCurrencyFormatFromSettingDoubleFindSYPEquality(context);
    }
  }

  String getMoreFromFomrat(BuildContext context) {
    if (isCreditAndDebit()) {
      return customers!.getMainHeaderTextOnly(context);
    } else {
      if (runtimeType == Spendings) {
        Spendings ob = this as Spendings;
        return ob.account_names!.getMainHeaderTextOnly(context);
      } else {
        Incomes ob = this as Incomes;
        return ob.account_names!.getMainHeaderTextOnly(context);
      }
    }
  }

  @override
  DashboardContentItem? getPrintableInvoiceTableHeaderAndContentWhenDashboard(
    BuildContext context,
    PrintLocalSetting? pca,
  ) {
    return DashboardContentItem()
      ..credit = isIncomes() ? getValueForDashboard(context, pca) : 0
      ..debit = isSpendings() ? getValueForDashboard(context, pca) : 0
      ..date = date
      ..currency = equalities?.currency?.name
      ..currencyId = equalities?.currency?.iD
      ..description = getIdWithLabelWithIsDollarForDashboard(context, pca)
      ..iD = iD;
  }

  @override
  List<Widget>? getCustomBottomWidget(
    BuildContext context, {
    ServerActions? action,
    ValueNotifier<ViewAbstract?>? onHorizontalListItemClicked,
  }) {
    if (action == ServerActions.add ||
        action == ServerActions.edit ||
        action == ServerActions.list) {
      return null;
    }
    return [
      SliverApiMixinViewAbstractWidget(
        toListObject: getSelfNewInstance().getSelfInstanceWithSimilarOption(
          context: context,
          obj: this,
          copyWith: RequestOptions(countPerPage: 5),
        ),
      ),
    ];
  }

  @override
  RequestOptions getSimilarCustomParams({required BuildContext context}) {
    Map<String, String> hashMap = {};
    if (isCreditAndDebit()) {
      hashMap["<CustomerID>"] = ("${customers!.iD}");
    } else {
      if (runtimeType == Spendings) {
        Spendings ob = this as Spendings;
        hashMap["<NameID>"] = ("${ob.account_names!.iD}");
      } else {
        Incomes ob = this as Incomes;
        hashMap["<NameID>"] = ("${ob.account_names!.iD}");
      }
    }
    return RequestOptions(searchByField: hashMap);
  }

  @override
  String? getWebCategoryGridableDescription(BuildContext context) {
    return value.toCurrencyFormat(symbol: equalities?.currency?.name ?? "");
  }

  @override
  T getWebCategoryGridableInterface(BuildContext context) {
    return getSelfNewInstance();
  }

  @override
  ViewAbstract? getWebCategoryGridableIsMasterToList(BuildContext context) {
    return null;
  }

  @override
  String getWebCategoryGridableTitle(BuildContext context) {
    return getMainHeaderTextOnly(context);
  }

  @override
  String getContentSharable(BuildContext context, {ServerActions? action}) {
    String content = getPrintableInvoiceTitle(context, null);
    content = "$content\n\n";
    PrintReceipt setting = PrintReceipt().copyWithEnableAll();
    content =
        "$content ${getPrintableRecieptHeaderTitleAndDescription(context, setting).getString()}";
    return content;
  }
}
