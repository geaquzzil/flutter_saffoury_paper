import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/users/balances/customer_balance_single.dart';
import 'package:flutter_view_controller/components/title_text.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_invoice_interface.dart';
import 'package:flutter_view_controller/models/auto_rest.dart';
import 'package:flutter_view_controller/models/prints/print_local_setting.dart';
import 'package:flutter_view_controller/models/view_abstract_non_list.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_view_controller/new_screens/lists/list_static_searchable_widget.dart';
import 'package:flutter_view_controller/new_screens/lists/list_static_widget.dart';
import 'package:flutter_view_controller/test_var.dart';
import '../../prints/print_customer_balances.dart';

class CustomerBalanceList
    extends ViewAbstractStandAloneCustomView<CustomerBalanceList>
    implements PrintableInvoiceInterface<PrintCustomerBalances> {
  List<CustomerBalanceSingle>? customers;
  double? totalBalance;
  int? termsBreakCount;
  int? nextPaymentCount;

  CustomerBalanceList();

  @override
  CustomerBalanceList getSelfNewInstance() {
    return CustomerBalanceList();
  }

  @override
  Future<CustomerBalanceList?> callApi() async {
    // TODO: implement callApi
    return fromJsonViewAbstract(jsonDecode(jsonEncode(customerbalances)));
  }

  @override
  CustomerBalanceList fromJsonViewAbstract(Map<String, dynamic> json) =>
      CustomerBalanceList()
        ..totalBalance = json['totalBalance'] as double?
        ..termsBreakCount = json['termsBreakCount'] as int?
        ..nextPaymentCount = json['nextPaymentCount'] as int?
        ..customers = (json['customers'] as List<dynamic>?)
            ?.map((e) =>
                CustomerBalanceSingle.fromJson(e as Map<String, dynamic>))
            .toList();

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
  String getPrintablePrimaryColor(PrintCustomerBalances? setting) =>
      Colors.orange.toHex();
  @override
  String getPrintableSecondaryColor(PrintCustomerBalances? setting) =>
      Colors.orange.shade500.toHex();

  @override
  String getPrintableQrCode() => "TODO";

  @override
  String getPrintableQrCodeID() => "TODO";

  @override
  ResponseType getCustomStandAloneResponseType() => ResponseType.SINGLE;

  @override
  Widget getCustomStandAloneWidget(BuildContext context) {
    return Expanded(
      // height: 200,
      child: ListStaticSearchableWidget<CustomerBalanceSingle>(
        list: customers ?? [],
        listItembuilder: (item) => ListTile(
          onTap: () {},
          leading: item.getCardLeading(context),
          title: Text(item.name ?? ""),
          subtitle: Text(item.balance.toCurrencyFormat()),
        ),
        onSearchTextChanged: (query) =>
            customers
                ?.where((element) =>
                    element.name?.toLowerCase().contains(query) ?? false)
                .toList() ??
            [],
      ),
    );
  }

  Widget getHeaderWidget(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(20),
      child: Column(children: [
        Row(
          children: [
            const Spacer(),
            Text(
              DateTime.now().toDateTimeString(),
              style: const TextStyle(fontWeight: FontWeight.w200),
            )
          ],
        ),
        Text(
          AppLocalizations.of(context)!.balance,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(
          totalBalance?.toCurrencyFormat() ?? "0",
          style: const TextStyle(
              fontWeight: FontWeight.w900, color: Colors.orange, fontSize: 32),
        ),
        Row(
          children: [
            Expanded(
                child: getListTile(context,
                    color: Colors.green,
                    icon: Icons.trending_up_rounded,
                    title: AppLocalizations.of(context)!.incomes,
                    subtitle: "213,232 SYP")),
            Expanded(
                child: getListTile(context,
                    icon: Icons.trending_down_rounded,
                    color: Colors.red,
                    title: AppLocalizations.of(context)!.spendings,
                    subtitle: "231,332 SYP")),
          ],
        )
      ]),
    );
  }

  Widget getListTile(BuildContext context,
      {IconData? icon, String? title, String? subtitle, Color? color}) {
    // return Text(title ?? "");
    return ListTile(
      leading: Icon(
        icon,
        color: color,
      ),
      title: Text(title ?? ""),
      subtitle: Text(subtitle ?? ""),
    );
  }

  @override
  List<Widget>? getCustomeStandAloneSideWidget(BuildContext context) {
    debugPrint("getCustomeStandAloneSideWidget ${toString()}");
    return [
      ExpansionTile(
          title: TitleText(
              text: AppLocalizations.of(context)!.balance,
              fontWeight: FontWeight.bold),
          children: [getHeaderWidget(context)]),
      // CirculeChartItem<CustomerBalanceSingle, String>(
      //   title: "${AppLocalizations.of(context)!.balance}: $totalBalance ",
      //   list: customers ?? [],
      //   xValueMapper: (item, value) => item.name,
      //   yValueMapper: (item, n) => item.balance,
      // ),
      ExpansionTile(
        initiallyExpanded: true,
        title: TitleText(
            text: AppLocalizations.of(context)!.mostPopular,
            fontWeight: FontWeight.bold),
        children: [
          ListStaticWidget<CustomerBalanceSingle>(
            list: customers?.sublist(0, 10) ?? [],
            emptyWidget: const Text("null"),
            listItembuilder: (item) => ListTile(
              leading: item.getCardLeading(context),
              title: Text(item.name ?? ""),
              subtitle: Text(item.balance.toCurrencyFormat()),
            ),
          )
        ],
      )
    ];

    // return Expanded(
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.center,
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: [
    //       // HeaderMain(),
    //       CirculeChartItem<CustomerBalanceSingle, String>(
    //         title: "${AppLocalizations.of(context)!.balance}: $totalBalance ",
    //         list: customers ?? [],
    //         xValueMapper: (item, value) => item.name,
    //         yValueMapper: (item, n) => item.balance,
    //       ),
    //       LineChartItem<CustomerBalanceSingle, String>(
    //         title: "${AppLocalizations.of(context)!.balance}: $totalBalance ",
    //         list: customers ?? [],
    //         xValueMapper: (item, value) => item.name,
    //         yValueMapper: (item, n) => item.balance,
    //       )
    //     ],
    //   ),
    // );
  }
}
