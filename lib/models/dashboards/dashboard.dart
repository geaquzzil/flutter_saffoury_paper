import 'dart:convert';
import 'dart:ffi';
import 'package:flutter_view_controller/models/auto_rest.dart';
import 'package:flutter_view_controller/models/view_abstract_permissions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_saffoury_paper/models/dashboards/utils.dart';
import 'package:flutter_saffoury_paper/models/funds/money_funds.dart';
import 'package:flutter_saffoury_paper/models/users/user_analysis_lists.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/interfaces/dashable_interface.dart';
import 'package:flutter_view_controller/models/apis/date_object.dart';
import 'package:flutter_view_controller/models/dealers/dealer.dart';
import 'package:flutter_view_controller/models/permissions/permission_level_abstract.dart';
import 'package:flutter_view_controller/models/permissions/setting.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_view_controller/models/view_abstract_base.dart';
import 'package:flutter_view_controller/new_components/chart/line_chart.dart';
import 'package:flutter_view_controller/new_components/chart/multi_line_chart.dart';
import 'package:flutter_view_controller/new_components/chart/pie_chart.dart';
import 'package:flutter_view_controller/new_components/tab_bar/tab_bar_by_list.dart';
import 'package:flutter_view_controller/new_screens/dashboard2/components/chart_card_item_custom.dart';
import 'package:flutter_view_controller/new_screens/dashboard2/custom_storage_details.dart';
import 'package:flutter_view_controller/new_screens/dashboard2/storage_detail.dart';
import 'package:flutter_view_controller/new_screens/lists/list_api_auto_rest_horizontal.dart';
import 'package:flutter_view_controller/new_screens/lists/list_static_widget.dart';
import 'package:flutter_view_controller/test_var.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import '../invoices/cuts_invoices/cut_requests.dart';
import '../invoices/priceless_invoices/reservation_invoice.dart';
import '../products/products_types.dart';
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
part 'dashboard.g.dart';

//TODO on publish do not forget that the iD gives error messages because the response of dashboard iD not found
@JsonSerializable(explicitToJson: true)
@reflector
class Dashboard extends UserLists<Dashboard> implements DashableInterface {
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

  List<String> getAnalysisChartFundsTitle(BuildContext context) {
    return [
      if (creditsAnalysis != null)
        Credits().getMainHeaderLabelTextOnly(context),
      if (debitsAnalysis != null) Debits().getMainHeaderLabelTextOnly(context),
      if (spendingsAnalysis != null)
        Spendings().getMainHeaderLabelTextOnly(context),
      if (incomesAnalysis != null)
        Incomes().getMainHeaderLabelTextOnly(context),
    ];
  }

  List<List<ViewAbstract>> getListOfTabbarFunds() {
    return [
      if (credits?.isNotEmpty ?? false) credits!,
      if (debits?.isNotEmpty ?? false) debits!,
      if (spendings?.isNotEmpty ?? false) spendings!,
      if (incomes?.isNotEmpty ?? false) incomes!,
    ];
  }

  List<List<GrowthRate>> getAnalysisChartFunds() {
    return [
      if (creditsAnalysis != null) creditsAnalysis ?? [],
      if (debitsAnalysis != null) debitsAnalysis ?? [],
      if (spendingsAnalysis != null) spendingsAnalysis ?? [],
      if (incomesAnalysis != null) incomesAnalysis ?? [],
    ];
  }

  List<List<GrowthRate>> getAnalysisChart() {
    return [
      if (ordersAnalysis != null) ordersAnalysis ?? [],
      if (purchasesAnalysis != null) purchasesAnalysis ?? [],
      if (products_inputsAnalysis != null) products_inputsAnalysis ?? [],
      if (products_outputsAnalysis != null) products_outputsAnalysis ?? [],
      if (transfersAnalysis != null) transfersAnalysis ?? [],
      if (reservation_invoiceAnalysis != null)
        reservation_invoiceAnalysis ?? [],
      if (cut_requestsAnalysis != null) cut_requestsAnalysis ?? []

      // if (spendingsAnalysis != null) spendingsAnalysis ?? [],
      // if (incomesAnalysis != null) incomesAnalysis ?? []
    ];
  }

  List<String> getAnalysisChartTitle(BuildContext context) {
    return [
      if (ordersAnalysis != null) Order().getMainHeaderLabelTextOnly(context),
      if (purchasesAnalysis != null)
        Purchases().getMainHeaderLabelTextOnly(context),

      if (products_inputsAnalysis != null)
        ProductInput().getMainHeaderLabelTextOnly(context),
      if (products_outputsAnalysis != null)
        ProductOutput().getMainHeaderLabelTextOnly(context),
      if (transfersAnalysis != null)
        Transfers().getMainHeaderLabelTextOnly(context),
      if (reservation_invoiceAnalysis != null)
        ReservationInvoice().getMainHeaderLabelTextOnly(context),
      if (cut_requestsAnalysis != null)
        CutRequest().getMainHeaderLabelTextOnly(context),
      // if (spendingsAnalysis != null) spendingsAnalysis ?? [],
      // if (incomesAnalysis != null) incomesAnalysis ?? []
    ];
  }

  String getTotalPreviousBalance({int? cashBoxID}) {
    var incomes = getMapPlus(previouscreditsDue, previousincomesDue,
        cashBoxID: cashBoxID);
    var spendings = getMapPlus(previousdebitsDue, previousspendingsDue,
        cashBoxID: cashBoxID);

    return getTotalGroupedFormattedText(getMapMinus(incomes, spendings));
  }

  String getTotalDueBalance({int? cashBoxID}) {
    var incomes = getMapPlus(creditsDue, incomesDue, cashBoxID: cashBoxID);
    var spendings = getMapPlus(debitsDue, spendingsDue, cashBoxID: cashBoxID);

    return getTotalGroupedFormattedText(getMapMinus(incomes, spendings));
  }

  String getTotalTodayBalance({int? cashBoxID}) {
    var incomes = getMapPlus(creditsBalanceToday, incomesBalanceToday,
        cashBoxID: cashBoxID);
    var spendings = getMapPlus(debitsBalanceToday, spendingsBalanceToday,
        cashBoxID: cashBoxID);

    return getTotalGroupedFormattedText(getMapMinus(incomes, spendings));
  }

  Map<String, double> getMapMinus(
      Map<String, double> first, Map<String, double> second) {
    Map<String, double> map = {};
    Map<String, double> mapPlus = {}
      ..addAll(first)
      ..addAll(second);
    mapPlus.forEach((key, value) {
      if (map.containsKey(key)) {
        map[key] = map[key]! - value;
      } else {
        map[key] = value;
      }
    });
    return map;
  }

  Map<String, double> getMapPlus(
      List<BalanceDue>? first, List<BalanceDue>? second,
      {int? cashBoxID}) {
    Map<String, double> map = {};
    Map<String, double> mapPlus = {}
      ..addAll(first.getTotalGrouped(CashboxID: cashBoxID))
      ..addAll(second.getTotalGrouped(CashboxID: cashBoxID));

    mapPlus.forEach((key, value) {
      if (map.containsKey(key)) {
        map[key] = map[key]! + value;
      } else {
        map[key] = value;
      }
    });
    return map;
  }

  List<WidgetGridHelper> getInvoicesWidgets(BuildContext context) {
    return [
      getWidget(StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: ChartCardItemCustom(
            color: Order().getMainColor(),
            // color: Colors.green.withOpacity(0.2),
            icon: Order().getMainIconData(),
            title: AppLocalizations.of(context)!.orders,
            description:
                "${orders?.getTotalQuantityGroupedFormattedText(context)}",
            footer: orders?.length.toString(),
            footerRightWidget: ordersAnalysis.getGrowthRateText(context),
          ))),
      getWidget(StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: ChartCardItemCustom(
            color: Purchases().getMainColor(),
            icon: Purchases().getMainIconData(),
            title: AppLocalizations.of(context)!.purchases,
            description:
                "${purchases?.getTotalQuantityGroupedFormattedText(context)}",
            footer: purchases?.length.toString(),
            footerRightWidget: purchasesAnalysis.getGrowthRateText(context),
          ))),
      getWidget(StaggeredGridTile.count(
          crossAxisCellCount: 2,
          mainAxisCellCount: 3,
          child: TabBarByListWidget<TabControllerHelper>(
            tabs: [
              TabControllerHelper(
                "orders",
                widget:
                    ListStaticWidget(list: orders!, emptyWidget: Text("Empty")),
              ),
              // TabControllerHelper(
              //   "deb",
              //   null,
              //   widget:
              //       ListStaticWidget(list: debits!, emptyWidget: Text("Empty")),
              // )
            ],
          ))),
      getWidget(StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: ChartCardItemCustom(
            icon: ProductInput().getMainIconData(),
            title: ProductInput().getMainHeaderLabelTextOnly(context),
            description:
                "${products_inputs.getTotalQuantityGroupedFormattedText(context)}",
            footer: products_inputs?.length.toString(),
            footerRightWidget:
                products_inputsAnalysis.getGrowthRateText(context),
          ))),
      getWidget(StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: ChartCardItemCustom(
            icon: ProductOutput().getMainIconData(),
            title: ProductOutput().getMainHeaderLabelTextOnly(context),
            description:
                "${products_outputs.getTotalQuantityGroupedFormattedText(context)}",
            footer: products_outputs?.length.toString(),
            footerRightWidget:
                products_outputsAnalysis.getGrowthRateText(context),
          ))),
      getWidget(StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: ChartCardItemCustom(
            icon: ReservationInvoice().getMainIconData(),
            title: ReservationInvoice().getMainHeaderLabelTextOnly(context),
            description:
                "${reservation_invoice.getTotalQuantityGroupedFormattedText(context)}",
            footer: reservation_invoice?.length.toString(),
            footerRightWidget:
                reservation_invoiceAnalysis.getGrowthRateText(context),
          ))),
      getWidget(StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: ChartCardItemCustom(
            icon: Transfers().getMainIconData(),
            title: Transfers().getMainHeaderLabelTextOnly(context),
            description:
                "${transfers.getTotalQuantityGroupedFormattedText(context)}",
            footer: transfers?.length.toString(),
            footerRightWidget: transfersAnalysis.getGrowthRateText(context),
          ))),
      getWidget(StaggeredGridTile.count(
          crossAxisCellCount: 2,
          mainAxisCellCount: 1,
          child: ChartCardItemCustom(
            icon: CutRequest().getMainIconData(),
            title: CutRequest().getMainHeaderLabelTextOnly(context),
            description: "TEST",
            footer: cut_requests?.length.toString(),
            footerRightWidget: cut_requestsAnalysis.getGrowthRateText(context),
          ))),
      getWidget(StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: ChartCardItemCustom(
            icon: Icons.arrow_back_sharp,
            title: AppLocalizations.of(context)!.incomes,
            description: incomes?.getTotalValue().toCurrencyFormat() ?? "",
            footer: incomes?.length.toString(),
            footerRightWidget: incomesAnalysis.getGrowthRateText(context),
          ))),
      getWidget(StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: ChartCardItemCustom(
            icon: Icons.today,
            title: AppLocalizations.of(context)!.this_day,
            description: getTotalTodayBalance(),
            // footer: incomes?.length.toString(),
            // footerRightWidget: incomesAnalysis.getGrowthRateText(context),
          ))),
      getWidget(StaggeredGridTile.count(
          crossAxisCellCount: 3,
          mainAxisCellCount: 1,
          child: ChartCardItemCustom(
            icon: Icons.balance,
            title: AppLocalizations.of(context)!.balance_due,
            description: getTotalDueBalance(cashBoxID: 1),
            // footer: incomes?.length.toString(),
            // footerRightWidget: incomesAnalysis.getGrowthRateText(context),
          ))),
    ];
  }

  WidgetGridHelper getWidget(StaggeredGridTile gride,
      {WidgetDashboardType type = WidgetDashboardType.NORMAL}) {
    return WidgetGridHelper(widget: gride, widgetDashboardType: type);
  }

  List<WidgetGridHelper> getFundWidgets(
      BuildContext context, int crossAxisCount) {
    bool isMezouj = crossAxisCount % 2 == 0;
    debugPrint(
        "isMezouj: $isMezouj   crossAxisCount $crossAxisCount crossAxisCount % 2= ${crossAxisCount % 2} crossAxisCount % 4 ${crossAxisCount % 4} ");
    return [
      getWidget(StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: ChartCardItemCustom(
            list: credits,
            listGrowthRate: creditsAnalysis,
            color: Credits().getMainColor(),
            icon: Icons.arrow_back_sharp,
            title: AppLocalizations.of(context)!.credits,
            description:
                "${credits?.getTotalValue(currencyID: 2).toCurrencyFormat()}\n${credits?.getTotalValue(currencyID: 1).toCurrencyFormat()}",
            footer: credits?.length.toString(),
            footerRightWidget: creditsAnalysis.getGrowthRateText(context),
          ))),
      getWidget(StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: ChartCardItemCustom(
            color: Debits().getMainColor(),
            icon: Icons.arrow_forward_rounded,
            title: AppLocalizations.of(context)!.debits,
            listGrowthRate: debitsAnalysis,
            description: debits?.getTotalValue().toCurrencyFormat() ?? "",
            footer: debits?.length.toString(),
            footerRightWidget: debitsAnalysis.getGrowthRateText(context),
          ))),
      // getWidget(StaggeredGridTile.count(
      //     crossAxisCellCount: 2,
      //     mainAxisCellCount: 3,
      //     child: StorageDetailsCustom(list: [
      //       StorageInfoCardCustom(
      //           title: AppLocalizations.of(context)!.previousBalance,
      //           description: getTotalPreviousBalance(),
      //           trailing: Text(""),
      //           svgSrc: Icons.preview),
      //       StorageInfoCardCustom(
      //           title: AppLocalizations.of(context)!.this_day,
      //           description: getTotalTodayBalance(),
      //           trailing: Text(""),
      //           svgSrc: Icons.today),
      //       StorageInfoCardCustom(
      //           title: AppLocalizations.of(context)!.balance_due,
      //           description: getTotalDueBalance(),
      //           trailing: Text(""),
      //           svgSrc: Icons.balance)
      //     ], chart: Text("")))),
      getWidget(StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: ChartCardItemCustom(
            color: Spendings().getMainColor(),
            icon: Icons.arrow_forward_rounded,
            title: AppLocalizations.of(context)!.spendings,
            description: spendings?.getTotalValue().toCurrencyFormat() ?? "",
            listGrowthRate: spendingsAnalysis,
            footer: spendings?.length.toString(),
            footerRightWidget: spendingsAnalysis.getGrowthRateText(context),
          ))),
      getWidget(StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: ChartCardItemCustom(
            icon: Icons.arrow_back_sharp,
            color: Incomes().getMainColor(),
            listGrowthRate: incomesAnalysis,
            title: AppLocalizations.of(context)!.incomes,
            description: incomes?.getTotalValue().toCurrencyFormat() ?? "",
            footer: incomes?.length.toString(),
            footerRightWidget: incomesAnalysis.getGrowthRateText(context),
          ))),
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
          crossAxisCellCount: 2,
          mainAxisCellCount: .75,
          child: ChartCardItemCustom(
            icon: Icons.balance,
            color: Colors.orange,
            title: AppLocalizations.of(context)!.balance_due,
            description: getTotalDueBalance(),
            // footer: incomes?.length.toString(),
            // footerRightWidget: incomesAnalysis.getGrowthRateText(context),
          ))),
    ];
  }

  bool checkList(List? list) {
    if (list == null) return false;
    if (list.isEmpty) return false;
    return true;
  }

  @override
  List<DashableGridHelper> getDashboardSectionsFirstPane(
          BuildContext context, int crossAxisCount) =>
      [
        DashableGridHelper(
            sectionsListToTabbar: getListOfTabbarFunds(),
            headerListToAdd: [Credits(), Debits(), Spendings(), Incomes()],
            title: AppLocalizations.of(context)!.overview,
            widgets: [
              ...getFundWidgets(context, crossAxisCount),
              // ...getInvoicesWidgets(context)
            ]),
        DashableGridHelper(
            title: AppLocalizations.of(context)!.invoice,
            headerListToAdd: [Credits(), Debits(), Spendings(), Incomes()],
            widgets: [...getInvoicesWidgets(context)]),
        if (checkList(pending_cut_requests))
          DashableGridHelper(
              title: AppLocalizations.of(context)!.pendingCutRequest,
              widgets: [
                getWidget(StaggeredGridTile.count(
                    crossAxisCellCount: crossAxisCount - 2,
                    mainAxisCellCount: 1.5,
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
                getWidget(
                    StaggeredGridTile.count(
                        crossAxisCellCount: 2,
                        mainAxisCellCount: 1.5,
                        child: LineChartItem<GrowthRate, String>(
                          list: cut_requestsAnalysis ?? [],
                          // title:
                          //     CutRequest().getMainHeaderLabelTextOnly(context),
                          dataLabelMapper: (item, idx) => item.total
                              .toCurrencyFormat(
                                  symbol: AppLocalizations.of(context)!.kg),
                          xValueMapper: (item, value) {
                            debugPrint("ChartItem $item");
                            return DateFormat.MMM().format(DateTime(
                                item.year!, item.month!, item.day ?? 1));
                          },
                          yValueMapper: (item, n) => item.total,
                        )),
                    type: WidgetDashboardType.CHART),
              ])
        // ...getInvoicesWidgets(context)
        ,
      ];

  @override
  List<DashableGridHelper> getDashboardSectionsSecoundPane(
      BuildContext context, int crossAxisCount) {
    return [
      DashableGridHelper(
          title: AppLocalizations.of(context)!.chart,
          wrapWithCard: true,
          widgets: [
            getWidget(
              StaggeredGridTile.count(
                  crossAxisCellCount: 1,
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
            getWidget(
              StaggeredGridTile.count(
                  crossAxisCellCount: 1,
                  mainAxisCellCount: 1.5,
                  child: MultiLineChartItem<GrowthRate, DateTime>(
                    title: "T",
                    list: getAnalysisChart(),
                    titles: getAnalysisChartTitle(context),
                    dataLabelMapper: (item, idx) =>
                        item.total.toCurrencyFormat(),
                    xValueMapper: (item, value, indexInsideList) => DateTime(
                        value.year ?? 2022, value.month ?? 1, value.day ?? 1),
                    yValueMapper: (item, n, indexInsideList) => n.total,
                  )),
            ),
            // ...getInvoicesWidgets(context)
          ]),
    ];
  }

  @override
  void setDate(DateObject? date) {
    this.date = date;
    debitsDue = null;
  }
}
