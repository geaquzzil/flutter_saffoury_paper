import 'dart:convert';
import 'package:flutter_saffoury_paper/models/prints/print_dashboard_setting.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_invoice_interface.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_master.dart';
import 'package:flutter_view_controller/interfaces/settings/ModifiableInterfaceAndPrintingSetting.dart';
import 'package:flutter_view_controller/models/auto_rest.dart';
import 'package:flutter_view_controller/models/prints/print_local_setting.dart';
import 'package:flutter_view_controller/models/view_abstract_base.dart';
import 'package:flutter_view_controller/models/view_abstract_permissions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_saffoury_paper/models/dashboards/utils.dart';
import 'package:flutter_saffoury_paper/models/users/user_analysis_lists.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/interfaces/dashable_interface.dart';
import 'package:flutter_view_controller/models/apis/date_object.dart';
import 'package:flutter_view_controller/models/dealers/dealer.dart';
import 'package:flutter_view_controller/models/permissions/permission_level_abstract.dart';
import 'package:flutter_view_controller/models/permissions/setting.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_view_controller/new_components/chart/multi_line_chart.dart';
import 'package:flutter_view_controller/new_components/tables_widgets/view_table_view_abstract.dart';
import 'package:flutter_view_controller/new_screens/actions/dashboard/compontents/header.dart';
import 'package:flutter_view_controller/new_screens/base_page.dart';
import 'package:flutter_view_controller/new_screens/dashboard2/components/chart_card_item_custom.dart';
import 'package:flutter_view_controller/new_screens/lists/list_api_auto_rest_horizontal.dart';
import 'package:flutter_view_controller/printing_generator/pdf_dashboard_api.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:flutter_view_controller/test_var.dart';
import 'package:json_annotation/json_annotation.dart';
import '../invoices/cuts_invoices/cut_requests.dart';
import '../invoices/priceless_invoices/reservation_invoice.dart';
import '../users/balances/customer_terms.dart';
import 'package:flutter_saffoury_paper/models/invoices/cargo_transporters.dart';
import 'package:flutter_saffoury_paper/models/invoices/orders.dart';
import 'package:flutter_saffoury_paper/models/invoices/priceless_invoices/customers_request_sizes.dart';
import 'package:flutter_saffoury_paper/models/invoices/priceless_invoices/products_inputs.dart';
import 'package:flutter_saffoury_paper/models/invoices/priceless_invoices/products_outputs.dart';
import 'package:flutter_saffoury_paper/models/invoices/priceless_invoices/transfers.dart';
import 'package:flutter_saffoury_paper/models/invoices/purchases.dart';
import 'package:flutter_saffoury_paper/models/invoices/refund_invoices/orders_refunds.dart';
import 'package:flutter_saffoury_paper/models/invoices/refund_invoices/purchasers_refunds.dart';
import 'package:flutter_view_controller/models/apis/growth_rate.dart';
import 'balance_due.dart';
import '../funds/credits.dart';
import '../funds/debits.dart';
import '../funds/incomes.dart';
import '../funds/spendings.dart';
import 'package:pdf/widgets.dart' as pdf;
part 'dashboard.g.dart';

//TODO on publish do not forget that the iD gives error messages because the response of dashboard iD not found
@JsonSerializable(explicitToJson: true)
@reflector
class Dashboard extends UserLists<Dashboard>
    implements
        DashableInterface,
        PrintableDashboardInterface<PrintDashboardSetting>,
        ModifiablePrintableInterface<PrintDashboardSetting> {
  List<BalanceDue>? debitsDue;
  List<BalanceDue>? creditsDue;
  List<BalanceDue>? incomesDue;
  List<BalanceDue>? spendingsDue;

  List<BalanceDue>? debitsBalanceToday;
  List<BalanceDue>? creditsBalanceToday;
  List<BalanceDue>? incomesBalanceToday;
  List<BalanceDue>? spendingsBalanceToday;

  List<BalanceDue>? previousdebitsDue;
  List<BalanceDue>? previouscreditsDue;
  List<BalanceDue>? previousincomesDue;
  List<BalanceDue>? previousspendingsDue;

  List<CustomerTerms>? notPayedCustomers;
  List<CustomerTerms>? customerToPayNext;

  DateObject? date;

  List<CustomerTerms>? modifiedNotPayedCustomers;

  List<CustomerTerms>? modifiedCustomerToPayNext;

  List<ReservationInvoice>? overdue_reservation_invoice;

  List<ReservationInvoice>? pending_reservation_invoice;
  List<CutRequest>? pending_cut_requests;

  Dashboard() : super() {
    date = DateObject();
  }

  Dashboard.init(int iD, {DateObject? dateObject}) {
    this.iD = iD;
    date = dateObject;
  }
  @override
  Dashboard getSelfNewInstance() {
    return Dashboard();
  }

  @override
  Future<Dashboard?> callApi() async {
    // debugPrint("DashboardPage callApi  ${jsonEncode(dashboard)}");
    return fromJsonViewAbstract(jsonDecode(jsonEncode(dashboard)));
  }

  @override
  IconData getMainIconData() {
    return Icons.dashboard_sharp;
  }

  @override
  String? getCustomAction() => "list_dashboard";

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) =>
      AppLocalizations.of(context)!.dashboard_and_rep;

  @override
  String getMainHeaderTextOnly(BuildContext context) =>
      AppLocalizations.of(context)!.dashboard_and_rep;
  @override
  Map<String, String> get getCustomMap => {
        "date": jsonEncode(date?.toJson() ?? DateObject().toJson()),
        if (setInterval()) "interval": "daily"
      };

  @override
  String? getMainDrawerGroupName(BuildContext context) =>
      AppLocalizations.of(context)!.title_dashboard;

  factory Dashboard.fromJson(Map<String, dynamic> data) =>
      _$DashboardFromJson(data);

  @override
  Map<String, dynamic> toJson() => _$DashboardToJson(this);

  @override
  Map<String, dynamic> toJsonViewAbstract() => toJson();

  @override
  Dashboard fromJsonViewAbstract(Map<String, dynamic> json) =>
      Dashboard.fromJson(json);

  @override
  bool isRequiredObjectsListChecker() {
    return debitsDue != null;
  }

  String getTotalPreviousBalance({int? cashBoxID}) {
    var incomes = getMapPlus(previouscreditsDue, previousincomesDue,
        cashBoxID: cashBoxID);
    var spendings = getMapPlus(previousdebitsDue, previousspendingsDue,
        cashBoxID: cashBoxID);

    debugPrint("getTotalPreviousBalance getTotoC $incomes $spendings");

    return getTotalGroupedFormattedText(getMapMinus(incomes, spendings));
  }

  String getTotalDueBalance({int? cashBoxID}) {
    var incomes = getMapPlus(creditsDue, incomesDue, cashBoxID: cashBoxID);
    var spendings = getMapPlus(debitsDue, spendingsDue, cashBoxID: cashBoxID);

    debugPrint("getTotalPreviousBalance getTotoC b $incomes $spendings");

    return getTotalGroupedFormattedText(getMapMinus(incomes, spendings));
  }

  String getTotalTodayBalance({int? cashBoxID}) {
    var incomes = getMapPlus(creditsBalanceToday, incomesBalanceToday,
        cashBoxID: cashBoxID);
    var spendings = getMapPlus(debitsBalanceToday, spendingsBalanceToday,
        cashBoxID: cashBoxID);

    return getTotalGroupedFormattedText(getMapMinus(incomes, spendings));
  }

  @override
  List<DashableGridHelper> getDashboardSectionsFirstPane(
          BuildContext context, int crossAxisCount,
          {GlobalKey<BasePageWithApi>? globalKey, TabControllerHelper? tab}) =>
      [
        DashableGridHelper(
            sectionsListToTabbar: getListOfTabbarFunds(),
            headerListToAdd: [Credits(), Debits(), Spendings(), Incomes()],
            title: AppLocalizations.of(context)!.overview,
            widgets: [
              ...getFundWidgets(context, crossAxisCount, globalKey: globalKey),
              // ...getInvoicesWidgets(context)
            ]),
        DashableGridHelper(
            title: AppLocalizations.of(context)!.invoice,
            headerListToAdd: [
              Order(),
              Purchases(),
              CutRequest(),
              Transfers(),
              ProductInput(),
              ProductOutput(),
              ReservationInvoice()
            ],
            widgets: [
              ...getInvoicesWidgets(context, crossAxisCount,
                  globalKey: globalKey)
            ]),
        DashableGridHelper(
            title: AppLocalizations.of(context)!.pendingFormat(
                AppLocalizations.of(context)!.orders.toLowerCase()),
            headerListToAdd: [
              Order(),
            ],
            widgets: [
              getWidget(
                StaggeredGridTile.count(
                  crossAxisCellCount: crossAxisCount,
                  mainAxisCellCount: 1.2,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height -
                        MediaQuery.of(context).size.height * .2,
                    child: ListHorizontalApiAutoRestWidget(
                      isSliver: true,

                      // titleString: "Today",
                      // listItembuilder: (v) => SizedBox(
                      //     width: 100, height: 100, child: POSListCardItem(object: v)),
                      autoRest: AutoRest<Order>(
                          obj: Order()
                            ..setCustomMap({
                              "<status>": "[\"PENDING\"]",
                            }),
                          key: "Order<status>PENDING"),
                    ),
                  ),
                ),
              ),
            ]),
        if (checkList(pending_cut_requests))
          DashableGridHelper(
              title: AppLocalizations.of(context)!.pendingCutRequest,
              widgets: [
                getWidget(StaggeredGridTile.count(
                    crossAxisCellCount: crossAxisCount,
                    mainAxisCellCount: 1.2,
                    child: ListHorizontalApiAutoRestWidget(
                      isSliver: true,
                      // titleString: "Pending",
                      list: pending_cut_requests,
                      // listItembuilder: (v) =>
                      //     ListItemProductTypeCategory(productType: v as ProductType),
                      // autoRest: AutoRest<CutRequest>(
                      //     obj: CutRequest()
                      //       ..setCustomMap({"<cut_status>": "PENDING"}),
                      //     key: "CutRequest<Pending>"),
                    ))),

                //                  return LineChartItem<ChangesRecordGroup, String>(
                //   title: "${AppLocalizations.of(context)!.total}: ${totalGrouped?.length} ",
                //   list: totalGrouped ?? [],
                //   xValueMapper: (item, value) => "${item.groupBy}",
                //   yValueMapper: (item, n) => item.count,
                // );
                // getWidget(
                //     StaggeredGridTile.count(
                //         crossAxisCellCount: 2,
                //         mainAxisCellCount: 1.5,
                //         child: LineChartItem<GrowthRate, String>(
                //           list: cut_requestsAnalysis ?? [],
                //           // title:
                //           //     CutRequest().getMainHeaderLabelTextOnly(context),
                //           dataLabelMapper: (item, idx) => item.total
                //               .toCurrencyFormat(
                //                   symbol: AppLocalizations.of(context)!.kg),
                //           xValueMapper: (item, value) {
                //             // debugPrint("ChartItem $item");
                //             return DateFormat.MMM().format(DateTime(
                //                 item.year!, item.month!, item.day ?? 1));
                //           },
                //           yValueMapper: (item, n) => item.total,
                //         )),
                //     type: WidgetDashboardType.CHART),
              ]),
        if (checkList(pending_reservation_invoice))
          DashableGridHelper(
              title: AppLocalizations.of(context)!.pendingReservationInvoices,
              widgets: [
                getWidget(StaggeredGridTile.count(
                    crossAxisCellCount: crossAxisCount,
                    mainAxisCellCount: 1.2,
                    child: ListHorizontalApiAutoRestWidget(
                      isSliver: true,
                      list: pending_reservation_invoice,
                    ))),
              ])
        // ...getInvoicesWidgets(context)
        ,
        if (checkList(overdue_reservation_invoice))
          DashableGridHelper(
              title: AppLocalizations.of(context)!.overDueFormat(
                  AppLocalizations.of(context)!
                      .reservationInvoice
                      .toLowerCase()),
              widgets: [
                getWidget(StaggeredGridTile.count(
                    crossAxisCellCount: crossAxisCount,
                    mainAxisCellCount: 1.2,
                    child: ListHorizontalApiAutoRestWidget(
                      isSliver: true,
                      // titleString: "Pending",
                      list: overdue_reservation_invoice,
                      // listItembuilder: (v) =>
                      //     ListItemProductTypeCategory(productType: v as ProductType),
                      // autoRest: AutoRest<CutRequest>(
                      //     obj: CutRequest()
                      //       ..setCustomMap({"<cut_status>": "PENDING"}),
                      //     key: "CutRequest<Pending>"),
                    ))),
              ])
      ];

  @override
  getDashboardSectionsSecoundPane(BuildContext context, int crossAxisCount,
      {GlobalKey<BasePageWithApi>? globalKey,
      TabControllerHelper? tab,
      TabControllerHelper? tabSecondPane}) {
    // return [];
    if (tabSecondPane != null && tabSecondPane.extras != null) {
      return [
        // LineChartItem(list: , xValueMapper: xValueMapper, yValueMapper: yValueMapper)
        getSliverListFromExtrasTabbar(context, tabSecondPane)
      ];
    }
    return [
      DashableGridHelper(
          title: AppLocalizations.of(context)!.chart,
          wrapWithCard: false,
          widgets: [
            getWidget(
              StaggeredGridTile.count(
                  crossAxisCellCount: 2,
                  mainAxisCellCount: 1.5,
                  child: MultiLineChartItem<GrowthRate, DateTime>(
                    title: "T",
                    list: getAnalysisChartFunds(),
                    titles: getAnalysisChartFundsTitle(context),
                    dataLabelMapper: (item, idx) =>
                        item.total.toCurrencyFormat(),
                    xValueMapper: (item, value, indexInsideList) => DateTime(
                        value.year ?? 2022, value.month ?? 1, value.day ?? 1),
                    yValueMapper: (item, n, indexInsideList) => n.total,
                  )),
              type: WidgetDashboardType.CHART,
            ),
            getWidget(StaggeredGridTile.count(
                crossAxisCellCount: 2,
                mainAxisCellCount: .75,
                child: ChartCardItemCustom(
                  color: Colors.blue,
                  icon: Icons.today,
                  title: AppLocalizations.of(context)!.this_day,
                  description: getTotalTodayBalance(),
                  // footer: incomes?.length.toString(),
                  // footerRightWidget: incomesAnalysis.getGrowthRateText(context),
                ))),
            getWidget(StaggeredGridTile.count(
                crossAxisCellCount: 1,
                mainAxisCellCount: .75,
                child: ChartCardItemCustom(
                  icon: Icons.balance,
                  color: Colors.orange,
                  title: AppLocalizations.of(context)!.previousBalance,
                  description: getTotalPreviousBalance(),
                  // footer: incomes?.length.toString(),
                  // footerRightWidget: incomesAnalysis.getGrowthRateText(context),
                ))),
            getWidget(StaggeredGridTile.count(
                crossAxisCellCount: 1,
                mainAxisCellCount: .75,
                child: ChartCardItemCustom(
                  icon: Icons.account_balance,
                  title: AppLocalizations.of(context)!.balance_due,
                  description: getTotalDueBalance(),
                  // footer: incomes?.length.toString(),
                  // footerRightWidget: incomesAnalysis.getGrowthRateText(context),
                ))),

            // getWidget(
            //   StaggeredGridTile.count(
            //     crossAxisCellCount: 2,
            //     mainAxisCellCount: 2,
            //     child: SizedBox(
            //       height: MediaQuery.of(context).size.height -
            //           MediaQuery.of(context).size.height * .2,
            //       child: ListHorizontalCustomViewApiAutoRestWidget(
            //           onResponseAddWidget: ((response) {
            //             ChangesRecords i = response as ChangesRecords;
            //             return Column(
            //               children: [
            //                 // ListHorizontalCustomViewApiAutoRestWidget<CustomerTerms>(
            //                 //     titleString: "TEST1 ",
            //                 //     autoRest: CustomerTerms.init(customers?.iD ?? 1)),
            //                 OutlinedCard(
            //                     child: ListTile(
            //                   title: Text(AppLocalizations.of(context)!.total),
            //                   subtitle: Text(i.total.toCurrencyFormat()),
            //                   leading: const Icon(Icons.monitor_weight),
            //                   trailing: const Text("SYP"),
            //                 )),
            //                 OutlinedCard(
            //                     child: ListTile(
            //                   title: Text(AppLocalizations.of(context)!.total),
            //                   subtitle: Text(i.total.toCurrencyFormat()),
            //                   leading: const Icon(Icons.monitor_weight),
            //                   trailing: const Text("SYP"),
            //                 )),
            //                 OutlinedCard(
            //                     child: ListTile(
            //                   title: Text(AppLocalizations.of(context)!.total),
            //                   subtitle: Text(i.total.toCurrencyFormat()),
            //                   leading: const Icon(Icons.monitor_weight),
            //                   trailing: const Text("SYP"),
            //                 )),
            //                 OutlinedCard(
            //                     child: ListTile(
            //                   title: Text(AppLocalizations.of(context)!.total),
            //                   subtitle: Text(i.total.toCurrencyFormat()),
            //                   leading: const Icon(Icons.monitor_weight),
            //                   trailing: const Text("SYP"),
            //                 )),
            //                 StorageInfoCardCustom(
            //                     title: AppLocalizations.of(context)!.total,
            //                     description: i.total.toCurrencyFormat(),
            //                     trailing: const Text("SYP"),
            //                     svgSrc: Icons.monitor_weight),
            //                 StorageInfoCardCustom(
            //                     title: AppLocalizations.of(context)!.balance,
            //                     description: "0",
            //                     trailing: const Text("trailing"),
            //                     svgSrc: Icons.balance),
            //               ],
            //             );
            //           }),
            //           autoRest: ChangesRecords.init(Spendings(), "NameID",
            //               fieldToSumBy: "value", pieChartEnabled: true)),
            //     ),
            //   ),
            //   type: WidgetDashboardType.CHART,
            // ),

            // getWidget(
            //   StaggeredGridTile.count(
            //       crossAxisCellCount: 1,
            //       mainAxisCellCount: 1.5,
            //       child: CirculeChartItem<GrowthRate, DateTime>(
            //         title: "T",
            //         list: getAnalysisChartFunds(),
            //         // titles: getAnalysisChartFundsTitle(context),
            //         // dataLabelMapper: (item, idx) =>
            //         //     item.total.toCurrencyFormat(),
            //         xValueMapper: (item, value, indexInsideList) => DateTime(
            //             value.year ?? 2022, value.month ?? 1, value.day ?? 1),
            //         yValueMapper: (item, n, indexInsideList) => n.total,
            //       )),
            //   type: WidgetDashboardType.CHART,
            // ),
            // getWidget(
            //   StaggeredGridTile.count(
            //       crossAxisCellCount: 2,
            //       mainAxisCellCount: 1.5,
            //       child: MultiLineChartItem<GrowthRate, DateTime>(
            //         title: "T",
            //         list: getAnalysisChartFunds(),
            //         titles: getAnalysisChartFundsTitle(context),
            //         dataLabelMapper: (item, idx) =>
            //             item.total.toCurrencyFormat(),
            //         xValueMapper: (item, value, indexInsideList) => DateTime(
            //             value.year ?? 2022, value.month ?? 1, value.day ?? 1),
            //         yValueMapper: (item, n, indexInsideList) => n.total,
            //       )),
            //   type: WidgetDashboardType.CHART,
            // ),
            // getWidget(
            //   StaggeredGridTile.count(
            //       crossAxisCellCount: 2,
            //       mainAxisCellCount: 1.5,
            //       child: MultiLineChartItem<GrowthRate, DateTime>(
            //         title: "T",
            //         list: getAnalysisChart(),
            //         titles: getAnalysisChartTitle(context),
            //         dataLabelMapper: (item, idx) =>
            //             item.total.toCurrencyFormat(),
            //         xValueMapper: (item, value, indexInsideList) => DateTime(
            //             value.year ?? 2022, value.month ?? 1, value.day ?? 1),
            //         yValueMapper: (item, n, indexInsideList) => n.total,
            //       )),
            // ),
            // ...getInvoicesWidgets(context)
          ]),
      if (checkList(customerToPayNext))
        DashableGridHelper(
            title: AppLocalizations.of(context)!.customer,
            widgets: [
              getWidget(StaggeredGridTile.count(
                  crossAxisCellCount: crossAxisCount,
                  mainAxisCellCount: 2,
                  child: Card(
                    child: ViewableTableViewAbstractWidget(
                        usePag: true,
                        buildActions: false,
                        viewAbstract: [
                          ...customerToPayNext ?? [],
                          ...debits ?? []
                        ]),
                  )))
            ]),
      if (checkList(notPayedCustomers))
        DashableGridHelper(
            title: AppLocalizations.of(context)!.customer,
            widgets: [
              getWidget(StaggeredGridTile.count(
                  crossAxisCellCount: crossAxisCount,
                  mainAxisCellCount: 2,
                  child: Card(
                    child: ViewableTableViewAbstractWidget(
                        usePag: true, viewAbstract: [...notPayedCustomers!]),
                  )))
            ]),
    ];
  }

  @override
  List<TabControllerHelper>? getDashboardTabbarSectionSecoundPaneList(
          BuildContext context) =>
      getTabBarSecondPane(context);

  @override
  void setDate(DateObject? date) {
    this.date = date;
    debitsDue = null;
  }

  bool setInterval() {
    if (date != null) {
      DateTime from = date!.from.toDateTimeOnlyDate();
      DateTime to = date!.to.toDateTimeOnlyDate();
      int days = from.difference(to).inDays;
      return days <= 30;
    }
    return false;
  }

  @override
  Widget? getDashboardAppbar(BuildContext context,
      {bool? firstPane,
      GlobalKey<BasePageWithApi<StatefulWidget>>? globalKey,
      TabControllerHelper? tab}) {
    if (firstPane == false) return null;
    return DashboardHeader(
      object: this,
      date: date ?? DateObject(),
      current_screen_size: getCurrentScreenSizeStatic(context),
      onSelectedDate: (d) {
        if (d == null) return;
        date = d;
        debitsDue = null;
        globalKey?.currentState?.refresh(extras: this, tab: tab);
        // getExtras().setDate(d);
        // refresh(extras: extras);
      },
    );
  }

  @override
  getDashboardShouldWaitBeforeRequest(BuildContext context,
      {bool? firstPane,
      GlobalKey<BasePageWithApi<StatefulWidget>>? globalKey,
      TabControllerHelper? tab}) {
    return null;
  }

  @override
  List<InvoiceHeaderTitleAndDescriptionInfo>
      getPrintableDashboardAccountInfoInBottom(
          BuildContext context, PrintDashboardSetting? pca) {
    // TODO: implement getPrintableDashboardAccountInfoInBottom
    return [];
  }

  @override
  pdf.Widget? getPrintableDashboardCustomWidgetBottom(
          BuildContext context,
          PrintDashboardSetting? pca,
          PdfDashnoardApi<PrintableDashboardInterface<PrintLocalSetting>,
                  PrintLocalSetting>
              generator) =>
      null;

  @override
  pdf.Widget? getPrintableDashboardCustomWidgetTop(
          BuildContext context,
          PrintDashboardSetting? pca,
          PdfDashnoardApi<PrintableDashboardInterface<PrintLocalSetting>,
                  PrintLocalSetting>
              generator) =>
      null;

  @override
  List<InvoiceTotalTitleAndDescriptionInfo> getPrintableDashboardFooterTotal(
          BuildContext context, PrintDashboardSetting? pca) =>
      [];

  @override
  List<List<InvoiceHeaderTitleAndDescriptionInfo>>
      getPrintableDashboardHeaderInfo(
          BuildContext context, PrintDashboardSetting? pca) {
    return [];
  }

  @override
  List<InvoiceTotalTitleAndDescriptionInfo>
      getPrintableDashboardTotalDescripton(
              BuildContext context, PrintDashboardSetting? pca) =>
          [];
  @override
   DashboardContentItem? getPrintableInvoiceTableHeaderAndContentWhenDashboard(
          BuildContext context, PrintLocalSetting? dashboardSetting) =>
      null;

  @override
  String getPrintableInvoiceTitle(
      BuildContext context, PrintDashboardSetting? pca) {
    return getMainHeaderTextOnly(context);
  }

  @override
  String getPrintablePrimaryColor(PrintDashboardSetting? pca) =>
      Colors.orange.toHex();

  @override
  String getPrintableQrCode() => "";

  @override
  String getPrintableQrCodeID() => "";

  @override
  List<PrintableMaster<PrintLocalSetting>>
      getPrintableRecieptMasterDashboardLists(
              BuildContext context, PrintDashboardSetting? pca) =>
          [
            ...credits?.cast() ?? [],
            ...debits?.cast() ?? [],
            ...spendings?.cast() ?? [],
            ...incomes?.cast() ?? [],
            ...orders?.cast() ?? [],
            ...purchases?.cast() ?? [],
            ...orders_refunds?.cast() ?? [],
            ...purchases_refunds?.cast() ?? [],
            ...cut_requests?.cast() ?? []

            // if (debits?.isNotEmpty ?? false) debits!,
            // if (spendings?.isNotEmpty ?? false) spendings!,
            // if (incomes?.isNotEmpty ?? false) incomes!,
          ];
  @override
  String getPrintableSecondaryColor(PrintDashboardSetting? pca) =>
      Colors.orange[700]!.toHex();

  @override
  pdf.Widget? getPrintableWatermark() => null;

  @override
  List<String> getPrintableDashboardTableHeaders(
      BuildContext context,
      PrintDashboardSetting? pca,
      PdfDashnoardApi<PrintableDashboardInterface<PrintLocalSetting>,
              PrintLocalSetting>
          generator) {
    return [
      AppLocalizations.of(context)!.date,
      AppLocalizations.of(context)!.description,
      if (pca?.hideCurrency == false) AppLocalizations.of(context)!.currency,
      AppLocalizations.of(context)!.credits,
      AppLocalizations.of(context)!.debits,
      AppLocalizations.of(context)!.balance,
    ].map((e) => e.toUpperCase()).toList();
  }

  int getPrintableDashboardCreditIndex(PrintDashboardSetting? pca, r) {
    if (pca?.hideCurrency == false) {
      return 3;
    } else {
      return 2;
    }
  }

  int getPrintableDashboardDebitIndex(
    PrintDashboardSetting? pca,
  ) {
    if (pca?.hideCurrency == false) {
      return 4;
    } else {
      return 3;
    }
  }

  @override
  String getModifiableMainGroupName(BuildContext context) => "";

  @override
  PrintableMaster<PrintLocalSetting> getModifiablePrintablePdfSetting(
          BuildContext context) =>
      this;

  @override
  IconData getModifibleIconData() => getMainIconData();

  @override
  PrintDashboardSetting getModifibleSettingObject(BuildContext context) {
    return PrintDashboardSetting();
  }

  @override
  String getModifibleTitleName(BuildContext context) => "sdad";

  @override
  List<String> getPrintableDashboardRowContentConverter(
      BuildContext context,
      PrintDashboardSetting? pca,
      PdfDashnoardApi<PrintableDashboardInterface<PrintLocalSetting>,
              PrintLocalSetting>
          generator,
      List dynamicList) {
    double debitsDouble =
        dynamicList[getPrintableDashboardCreditIndex(pca)].toDouble();
    double creditsDouble =
        dynamicList[getPrintableDashboardDebitIndex(pca)].toDouble();
    generator.lastBalance =
        generator.lastBalance + (creditsDouble - debitsDouble);
    return [
      dynamicList[0].toString(),
      dynamicList[1].toString(),
      creditsDouble.toCurrencyFormat(),
      debitsDouble.toCurrencyFormat(),
      generator.lastBalance.toCurrencyFormat()
    ];
  }
}
