import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/dashboards/customer_dashboard.dart';
import 'package:flutter_saffoury_paper/models/users/balances/customer_balance_single.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_view_controller/components/title_text.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/interfaces/dashable_interface.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_invoice_interface.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_master.dart';
import 'package:flutter_view_controller/l10n/app_localization.dart';
import 'package:flutter_view_controller/models/apis/date_object.dart';
import 'package:flutter_view_controller/models/auto_rest.dart';
import 'package:flutter_view_controller/models/prints/print_local_setting.dart';
import 'package:flutter_view_controller/models/request_options.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract_base.dart';
import 'package:flutter_view_controller/models/view_abstract_stand_alone.dart';
import 'package:flutter_view_controller/new_screens/base_page.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_static_list_new.dart';
import 'package:flutter_view_controller/test_var.dart';
import 'package:pdf/pdf.dart' as d;
import 'package:pdf/widgets.dart' as pdf;

import '../../prints/print_customer_balances.dart';

class CustomerBalanceList
    extends ViewAbstractStandAloneCustomViewApi<CustomerBalanceList>
    implements
        PrintableInvoiceInterface<PrintCustomerBalances>,
        DashableInterface {
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
  Future<CustomerBalanceList?> callApi({required BuildContext context}) async {
    return fromJsonViewAbstract(jsonDecode(jsonEncode(customerbalances)));
  }

  @override
  bool getPrintableSupportsLabelPrinting() => false;
  @override
  bool getCustomStandAloneWidgetIsPadding() {
    return false;
  }

  @override
  CustomerBalanceList fromJsonViewAbstract(Map<String, dynamic> json) =>
      CustomerBalanceList()
        ..totalBalance = json['totalBalance'] as double?
        ..termsBreakCount = json['termsBreakCount'] as int?
        ..nextPaymentCount = json['nextPaymentCount'] as int?
        ..customers = (json['customers'] as List<dynamic>?)
            ?.map(
              (e) => CustomerBalanceSingle.fromJson(e as Map<String, dynamic>),
            )
            .toList();

  @override
  Map<String, IconData> getFieldIconDataMap() => {};

  @override
  Map<String, String> getFieldLabelMap(BuildContext context) => {};

  @override
  String? getMainDrawerGroupName(BuildContext context) =>
      AppLocalizations.of(context)!.users;

  @override
  List<String> getMainFields({BuildContext? context}) => [];

  @override
  Widget? getDashboardAppbar(
    BuildContext context, {
    bool? firstPane,
    GlobalKey<BasePageStateWithApi>? globalKey,
    TabControllerHelper? tab,
  }) {
    return null;
  }

  @override
  getDashboardShouldWaitBeforeRequest(
    BuildContext context, {
    bool? firstPane,
    GlobalKey<BasePageStateWithApi>? globalKey,
    TabControllerHelper? tab,
  }) {
    return null;
  }

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) =>
      AppLocalizations.of(context)!.customerBalances;

  @override
  String getMainHeaderTextOnly(BuildContext context) =>
      getMainHeaderLabelTextOnly(context);

  @override
  IconData getMainIconData() => Icons.balance;
  @override
  List<String>? getCustomAction() {
    return ["customers", "balance"];
  }

  @override
  Map<String, dynamic> toJsonViewAbstract() => {};

  @override
  List<InvoiceHeaderTitleAndDescriptionInfo>
  getPrintableInvoiceAccountInfoInBottom(
    BuildContext context,
    PrintCustomerBalances? pca,
  ) => [];

  @override
  List<PrintableInvoiceInterfaceDetails<PrintLocalSetting>>
  getPrintableInvoiceDetailsList() {
    return customers ?? [];
  }

  @override
  List<List<InvoiceHeaderTitleAndDescriptionInfo>> getPrintableInvoiceInfo(
    BuildContext context,
    PrintCustomerBalances? pca,
  ) => [];
  @override
  String getPrintableInvoiceTitle(
    BuildContext context,
    PrintCustomerBalances? pca,
  ) => getMainHeaderLabelTextOnly(context);

  @override
  List<InvoiceTotalTitleAndDescriptionInfo> getPrintableInvoiceTotal(
    BuildContext context,
    PrintCustomerBalances? pca,
  ) => [];

  @override
  List<InvoiceTotalTitleAndDescriptionInfo> getPrintableInvoiceTotalDescripton(
    BuildContext context,
    PrintCustomerBalances? pca,
  ) => [];

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
    return Text("TODO");
    // return Expanded(
    //   // height: 200,
    //   child: ListStaticSearchableWidget<CustomerBalanceSingle>(
    //     list: customers ?? [],
    //     listItembuilder: (item) => ListTile(
    //       onTap: () {},
    //       leading: item.getCardLeading(context),
    //       title: Text(item.name ?? ""),
    //       subtitle: Text(item.balance.toCurrencyFormat()),
    //     ),
    //     onSearchTextChanged: (query) =>
    //         customers
    //             ?.where(
    //               (element) =>
    //                   element.name?.toLowerCase().contains(query) ?? false,
    //             )
    //             .toList() ??
    //         [],
    //   ),
    // );
  }

  Widget getHeaderWidget(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              const Spacer(),
              Text(
                DateTime.now().toDateTimeString(),
                style: const TextStyle(fontWeight: FontWeight.w200),
              ),
            ],
          ),
          Text(
            AppLocalizations.of(context)!.balance,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            totalBalance?.toCurrencyFormat() ?? "0",
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              color: Colors.orange,
              fontSize: 32,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: getListTile(
                  context,
                  color: Colors.green,
                  icon: Icons.trending_up_rounded,
                  title: AppLocalizations.of(context)!.incomes,
                  subtitle: "213,232 SYP",
                ),
              ),
              Expanded(
                child: getListTile(
                  context,
                  icon: Icons.trending_down_rounded,
                  color: Colors.red,
                  title: AppLocalizations.of(context)!.spendings,
                  subtitle: "231,332 SYP",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget getListTile(
    BuildContext context, {
    IconData? icon,
    String? title,
    String? subtitle,
    Color? color,
  }) {
    // return Text(title ?? "");
    return ListTile(
      leading: Icon(icon, color: color),
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
          fontWeight: FontWeight.bold,
        ),
        children: [getHeaderWidget(context)],
      ),
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
          fontWeight: FontWeight.bold,
        ),
        children: [
          SliverApiMixinStaticList<CustomerBalanceSingle>(
            list: customers?.sublist(0, 10) ?? [],

            hasCustomCardItemBuilder: (i, item) => ListTile(
              leading: item.getCardLeading(context),
              title: Text(item.name ?? ""),
              subtitle: Text(item.balance.toCurrencyFormat()),
            ),
          ),
        ],
      ),
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

  @override
  Widget? getCustomFloatingActionWidget(BuildContext context) {
    return null;
  }

  @override
  pdf.Widget? getPrintableWatermark(d.PdfPageFormat? format) => null;
  bool checkList(List? list) {
    if (list == null) return false;
    if (list.isEmpty) return false;
    return true;
  }

  WidgetGridHelper getWidget(
    StaggeredGridTile gride, {
    WidgetDashboardType type = WidgetDashboardType.NORMAL,
  }) {
    return WidgetGridHelper(widget: gride, widgetDashboardType: type);
  }

  @override
  getDashboardSectionsFirstPane(
    BuildContext context,
    int crossAxisCount, {
    GlobalKey<BasePageStateWithApi>? globalKey,
    TabControllerHelper? tab,
  }) {
    return [
      SliverFillRemaining(
        // /ListStaticSearchableWidget
        child: SliverApiMixinStaticList<CustomerBalanceSingle>(
          list: customers ?? [],
          hasCustomCardItemBuilder: (_, item) => ListTile(
            onTap: () {
              debugPrint("_tabController clicked");
              if (globalKey == null) return;
              debugPrint("_tabController clicked2");
              TabControllerHelper? value = globalKey.currentState
                  ?.findExtrasViaType(CustomerDashboard().runtimeType);
              debugPrint("_tabController value $value");
              if (value == null) return;
              int index = globalKey.currentState!.findExtrasIndexFromTab(
                CustomerDashboard().runtimeType,
              );
              if (index == -1) return;
              CustomerDashboard newCustomerDashboard = CustomerDashboard();
              newCustomerDashboard.iD = item.iD;
              //todo change date
              newCustomerDashboard.dateObject = DateObject(
                from: "2020-01-01",
                to: "2023-01-01",
              );
              value.extras = newCustomerDashboard;
              globalKey.currentState?.refresh(
                extras: newCustomerDashboard,
                tab: value,
              );

              globalKey.currentState?.changeTabIndex(index);
            },
            leading: item.getCardLeading(context),
            title: Text(item.name ?? ""),
            subtitle: Text(item.balance.toCurrencyFormat()),
          ),
          // onSearchTextChanged: (query) =>
          //     customers
          //         ?.where(
          //           (element) =>
          //               element.name?.toLowerCase().contains(query) ?? false,
          //         )
          //         .toList() ??
          //     [],
        ),
      ),
    ];
  }

  @override
  List<DashableGridHelper> getDashboardSectionsSecoundPane(
    BuildContext context,
    int crossAxisCount, {
    GlobalKey<BasePageStateWithApi>? globalKey,
    TabControllerHelper? tab,
    TabControllerHelper? tabSecondPane,
  }) {
    return [
      DashableGridHelper(
        title: AppLocalizations.of(context)!.overview,
        widgets: [
          getWidget(
            StaggeredGridTile.count(
              crossAxisCellCount: crossAxisCount,
              mainAxisCellCount: 2,
              child: getHeaderWidget(context),
            ),
          ),
          // ...getInvoicesWidgets(context)
        ],
      ),
      DashableGridHelper(
        title: AppLocalizations.of(context)!.overview,
        widgets: [
          getWidget(
            StaggeredGridTile.count(
              crossAxisCellCount: crossAxisCount,
              mainAxisCellCount: 1,
              child: SliverApiMixinStaticList<CustomerBalanceSingle>(
                list: customers?.sublist(0, 10) ?? [],

                hasCustomCardItemBuilder: (_, item) => ListTile(
                  leading: item.getCardLeading(context),
                  title: Text(item.name ?? ""),
                  subtitle: Text(item.balance.toCurrencyFormat()),
                ),
              ),
            ),
          ),
          // ...getInvoicesWidgets(context)
        ],
      ),
    ];
  }

  @override
  List<TabControllerHelper>? getDashboardTabbarSectionSecoundPaneList(
    BuildContext context,
  ) => null;

  @override
  void setDate(DateObject? date) {
    //TODO this.date = date;TODO
    customers = null;
  }

  @override
  String? getTableNameApi() {
    return "list_customers_balances";
  }

  @override
  DashboardContentItem? getPrintableInvoiceTableHeaderAndContentWhenDashboard(
    BuildContext context,
    PrintLocalSetting? dashboardSetting,
  ) {
    return null;
  }

  @override
  RequestOptions? getRequestOption({
    required ServerActions action,
    RequestOptions? generatedOptionFromListCall,
  }) {
    return null;
  }

  @override
  List<String>? getRequestedForginListOnCall({required ServerActions action}) {
    return null;
  }
}
