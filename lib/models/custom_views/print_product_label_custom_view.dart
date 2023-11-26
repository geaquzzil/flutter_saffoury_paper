import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/prints/print_product.dart';
import 'package:flutter_saffoury_paper/models/products/products.dart';
import 'package:flutter_saffoury_paper/models/users/balances/customer_balance_single.dart';
import 'package:flutter_view_controller/components/title_text.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_invoice_interface.dart';
import 'package:flutter_view_controller/models/auto_rest.dart';
import 'package:flutter_view_controller/models/prints/print_local_setting.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_view_controller/models/view_abstract_stand_alone.dart';
import 'package:flutter_view_controller/new_screens/actions/edit_new/base_edit_main_page.dart';
import 'package:flutter_view_controller/new_screens/lists/list_static_searchable_widget.dart';
import 'package:flutter_view_controller/new_screens/lists/list_static_widget.dart';
import 'package:flutter_view_controller/test_var.dart';

class PrintProductLabelCustomView
    extends ViewAbstractStandAloneCustomView<PrintProductLabelCustomView>
    implements PrintableInvoiceInterface<PrintProduct> {
  List<CustomerBalanceSingle>? customers;
  double? totalBalance;
  int? termsBreakCount;
  int? nextPaymentCount;

  PrintProductLabelCustomView();

  @override
  PrintProductLabelCustomView getSelfNewInstance() {
    return PrintProductLabelCustomView();
  }

  @override
  Map<String, IconData> getFieldIconDataMap() => {};

  @override
  Map<String, String> getFieldLabelMap(BuildContext context) => {};

  @override
  String? getMainDrawerGroupName(BuildContext context) =>
      AppLocalizations.of(context)!.print;

  @override
  List<String> getMainFields({BuildContext? context}) => [];

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) =>
      AppLocalizations.of(context)!.print;

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
              BuildContext context, PrintProduct? pca) =>
          [];

  @override
  List<PrintableInvoiceInterfaceDetails<PrintLocalSetting>>
      getPrintableInvoiceDetailsList() {
    return customers ?? [];
  }

  @override
  List<List<InvoiceHeaderTitleAndDescriptionInfo>> getPrintableInvoiceInfo(
          BuildContext context, PrintProduct? pca) =>
      [];
  @override
  String getPrintableInvoiceTitle(BuildContext context, PrintProduct? pca) =>
      getMainHeaderLabelTextOnly(context);

  @override
  List<InvoiceTotalTitleAndDescriptionInfo> getPrintableInvoiceTotal(
          BuildContext context, PrintProduct? pca) =>
      [];

  @override
  List<InvoiceTotalTitleAndDescriptionInfo> getPrintableInvoiceTotalDescripton(
          BuildContext context, PrintProduct? pca) =>
      [];

  @override
  String getPrintablePrimaryColor(PrintProduct? setting) =>
      Colors.blueGrey.toHex();
  @override
  String getPrintableSecondaryColor(PrintProduct? setting) =>
      Colors.blueGrey.shade500.toHex();

  @override
  String getPrintableQrCode() => "TODO";

  @override
  String getPrintableQrCodeID() => "TODO";

  @override
  ResponseType getCustomStandAloneResponseType() =>
      ResponseType.NONE_RESPONSE_TYPE;

  @override
  Widget getCustomStandAloneWidget(BuildContext context) {
    return BaseEditNewPage(viewAbstract: Product());
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
  }

  @override
  PrintProductLabelCustomView fromJsonViewAbstract(Map<String, dynamic> json) {
    return this;
  }
}
