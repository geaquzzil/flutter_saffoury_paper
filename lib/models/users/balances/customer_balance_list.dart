import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/icon_data.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_saffoury_paper/models/users/balances/customer_balance_single.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_invoice_interface.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_master.dart';
import 'package:flutter_view_controller/interfaces/settings/ModifiableInterfaceAndPrintingSetting.dart';
import 'package:flutter_view_controller/models/auto_rest.dart';
import 'package:flutter_view_controller/models/prints/print_commad_abstract.dart';
import 'package:flutter_view_controller/models/prints/print_local_setting.dart';
import 'package:flutter_view_controller/models/view_abstract_non_list.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import '../../prints/print_customer_balances.dart';
import 'customer_terms.dart';
import '../customers.dart';

class CustomerBalanceList
    extends ViewAbstractStandAloneCustomView<CustomerBalanceList>
    implements PrintableInvoiceInterface<PrintCustomerBalances> {
  List<CustomerBalanceSingle>? customers;
  double? totalBalance;
  int? termsBreakCount;
  int? nextPaymentCount;

  CustomerBalanceList();
  @override
  CustomerBalanceList fromJsonViewAbstract(Map<String, dynamic> json) =>
      CustomerBalanceList();
  // ..totalBalance = json['totalBalance'] as double?
  // ..termsBreakCount = json['termsBreakCount'] as int?
  // ..nextPaymentCount = json['nextPaymentCount'] as int?
  // ..customers = (json['customers'] as List<dynamic>?)
  //     ?.map((e) =>
  //         CustomerBalanceSingle.fromJson(e as Map<String, dynamic>))
  //     .toList();

  @override
  Map<String, IconData> getFieldIconDataMap() => {};

  @override
  Map<String, String> getFieldLabelMap(BuildContext context) => {};

  @override
  String? getMainDrawerGroupName(BuildContext context) =>
      AppLocalizations.of(context)!.users;

  @override
  List<String> getMainFields() => [];

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) =>
      AppLocalizations.of(context)!.customerBalances;

  @override
  String getMainHeaderTextOnly(BuildContext context) =>
      getMainHeaderLabelTextOnly(context);

  @override
  IconData getMainIconData() => Icons.balance;

  @override
  String? getTableNameApi() => null;

  @override
  String? getCustomAction() => "list_customers_balances";
  @override
  Map<String, String> get getCustomMap => {"requireTerms": "true"};

  @override
  Map<String, dynamic> toJsonViewAbstract() => {};

  @override
  List<InvoiceHeaderTitleAndDescriptionInfo>
      getPrintableInvoiceAccountInfoInBottom(
              BuildContext context, PrintCustomerBalances? pca) =>
          [];

  @override
  List<PrintableInvoiceInterfaceDetails<PrintLocalSetting>>
      getPrintableInvoiceDetailsList() {
    return customers ?? [];
  }

  @override
  List<List<InvoiceHeaderTitleAndDescriptionInfo>> getPrintableInvoiceInfo(
          BuildContext context, PrintCustomerBalances? pca) =>
      [];
  @override
  String getPrintableInvoiceTitle(
          BuildContext context, PrintCustomerBalances? pca) =>
      getMainHeaderLabelTextOnly(context);

  @override
  List<InvoiceTotalTitleAndDescriptionInfo> getPrintableInvoiceTotal(
          BuildContext context, PrintCustomerBalances? pca) =>
      [];

  @override
  List<InvoiceTotalTitleAndDescriptionInfo> getPrintableInvoiceTotalDescripton(
          BuildContext context, PrintCustomerBalances? pca) =>
      [];

  @override
  String getPrintablePrimaryColor() => Colors.orange.toHex();
  @override
  String getPrintableSecondaryColor() => Colors.orange.shade500.toHex();

  @override
  String getPrintableQrCode() => "TODO";

  @override
  String getPrintableQrCodeID() => "TODO";

  @override
  ResponseType getCustomStandAloneResponseType() => ResponseType.SINGLE;

  @override
  Widget getCustomStandAloneWidget(BuildContext context) {
    return Text("dsad");
  }
}
