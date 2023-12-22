import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/dashboards/balance_due.dart';
import 'package:flutter_saffoury_paper/models/dashboards/customer_dashboard.dart';
import 'package:flutter_saffoury_paper/models/dashboards/utils.dart';
import 'package:flutter_saffoury_paper/models/funds/credits.dart';
import 'package:flutter_saffoury_paper/models/invoices/cargo_transporters.dart';
import 'package:flutter_saffoury_paper/models/invoices/cuts_invoices/cut_requests.dart';
import 'package:flutter_saffoury_paper/models/invoices/orders.dart';
import 'package:flutter_saffoury_paper/models/invoices/priceless_invoices/customers_request_sizes.dart';
import 'package:flutter_saffoury_paper/models/invoices/priceless_invoices/products_inputs.dart';
import 'package:flutter_saffoury_paper/models/invoices/priceless_invoices/products_outputs.dart';
import 'package:flutter_saffoury_paper/models/invoices/priceless_invoices/reservation_invoice.dart';
import 'package:flutter_saffoury_paper/models/invoices/priceless_invoices/transfers.dart';
import 'package:flutter_saffoury_paper/models/invoices/purchases.dart';
import 'package:flutter_saffoury_paper/models/invoices/refund_invoices/orders_refunds.dart';
import 'package:flutter_saffoury_paper/models/invoices/refund_invoices/purchasers_refunds.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/interfaces/dashable_interface.dart';
import 'package:flutter_view_controller/models/apis/growth_rate.dart';
import 'package:flutter_view_controller/models/permissions/user_auth.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/tables_widgets/view_table_view_abstract.dart';
import 'package:flutter_view_controller/new_screens/dashboard2/components/chart_card_item_custom.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import '../funds/debits.dart';
import '../funds/incomes.dart';
import '../funds/spendings.dart';

class UserLists<T> extends AuthUser<T> {
  List<Credits>? credits;
  List<GrowthRate>? creditsAnalysis;

  List<Debits>? debits;
  List<GrowthRate>? debitsAnalysis;

  List<Spendings>? spendings;
  List<GrowthRate>? spendingsAnalysis;

  List<Incomes>? incomes;
  List<GrowthRate>? incomesAnalysis;

  List<CutRequest>? cut_requests;
  List<GrowthRate>? cut_requestsAnalysis;
  int? cut_requests_count;

  List<Order>? orders;
  List<GrowthRate>? ordersAnalysis;
  int? orders_count;

  List<Purchases>? purchases;
  List<GrowthRate>? purchasesAnalysis;
  int? purchases_count;

  List<OrderRefund>? orders_refunds;
  List<GrowthRate>? orders_refundsAnalysis;
  int? orders_refunds_count;

  List<PurchasesRefund>? purchases_refunds;
  List<GrowthRate>? purchases_refundsAnalysis;
  int? purchases_refunds_count;

  List<CustomerRequestSize>? customers_request_sizes;
  List<GrowthRate>? customers_request_sizesAnalysis;
  int? customers_request_sizes_count;

  List<ReservationInvoice>? reservation_invoice;
  List<GrowthRate>? reservation_invoiceAnalysis;
  int? reservation_invoice_count;

  List<ProductInput>? products_inputs; //employee only
  List<GrowthRate>? products_inputsAnalysis;
  int? products_inputs_count;

  List<ProductOutput>? products_outputs; //employee only
  List<GrowthRate>? products_outputsAnalysis;
  int? products_outputs_count;

  List<Transfers>? transfers; //employee only
  List<GrowthRate>? transfersAnalysis;
  int? transfers_count;

  List<CargoTransporter>? cargo_transporters; //employee only
  List<GrowthRate>? cargo_transportersAnalysis;
  int? cargo_transporters_count;

  UserLists() : super();
  @override
  UserLists getSelfNewInstance() {
    return UserLists();
  }

  bool checkList(List? list) {
    if (list == null) return false;
    if (list.isEmpty) return false;
    return true;
  }

  bool checkForEmptyList(List? list, bool checkForEmpty) {
    if (!checkForEmpty) return true;
    return checkList(list);
  }

  WidgetGridHelper getWidget(StaggeredGridTile gride,
      {WidgetDashboardType type = WidgetDashboardType.NORMAL}) {
    return WidgetGridHelper(widget: gride, widgetDashboardType: type);
  }

  String combineStrings(List<List<GrowthRate?>?> list) {
    return "";
  }

  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() =>
      super.getMirrorFieldsMapNewInstance()
        ..addAll({
          "cut_requests": List<CutRequest>.empty(),
          "cut_requstesAnalysis": List<GrowthRate>.empty(),
          "cut_requests_count": 0,
          "orders": List<Order>.empty(),
          "ordersAnalysis": List<GrowthRate>.empty(),
          "orders_count": 0,
          "purchases": List<Purchases>.empty(),
          "purchasesAnalysis": List<GrowthRate>.empty(),
          "purchases_count": 0,
          "orders_refunds": List<OrderRefund>.empty(),
          "orders_refundsAnalysis": List<GrowthRate>.empty(),
          "orders_refunds_count": 0,
          "purchases_refunds_count": 0,
          "purchases_refunds": List<PurchasesRefund>.empty(),
          "purchases_refundsAnalysis": List<GrowthRate>.empty(),
          "customers_request_sizes": List<CustomerRequestSize>.empty(),
          "customers_request_sizesAnalysis": List<GrowthRate>.empty(),
          "customers_request_sizes_count": 0,
          "reservation_invoice": List<ReservationInvoice>.empty(),
          "reservation_invoiceAnalysis": List<GrowthRate>.empty(),
          "reservation_invoice_count": 0,
          "products_inputs": List<ProductInput>.empty(),
          "products_inputsAnalysis": List<GrowthRate>.empty(),
          "products_inputs_count": 0,
          "products_outputs": List<ProductOutput>.empty(),
          "products_outputsAnalysis": List<GrowthRate>.empty(),
          "products_outputs_count": 0,
          "transfers": List<Transfers>.empty(),
          "transfersAnalysis": List<GrowthRate>.empty(),
          "transfers_count": 0,
          "cargo_transporters": List<CargoTransporter>.empty(),
          "cargo_transportersAnalysis": List<GrowthRate>.empty(),
          "cargo_transporters_count": 0
        });

  List<ViewAbstract> getAnalysisChartFundsTitle(BuildContext context) {
    return [
      if (creditsAnalysis != null) Credits(),
      if (debitsAnalysis != null) Debits(),
      if (spendingsAnalysis != null) Spendings(),
      if (incomesAnalysis != null) Incomes(),
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
    ];
  }

  List<ViewAbstract> getAnalysisChartTitle(BuildContext context) {
    return [
      if (ordersAnalysis != null) Order(),
      if (purchasesAnalysis != null) Purchases(),
      if (products_inputsAnalysis != null) ProductInput(),
      if (products_outputsAnalysis != null) ProductOutput(),
      if (transfersAnalysis != null) Transfers(),
      if (reservation_invoiceAnalysis != null) ReservationInvoice(),
      if (cut_requestsAnalysis != null) CutRequest(),
    ];
  }

  Map<String, double> getMapMinus(
      Map<String, double> first, Map<String, double> second) {
    Map<String, double> map = {};
    Map<String, double> mapPlus1 = {}..addAll(first);
    Map<String, double> mapPlus2 = {}..addAll(second);

    mapPlus1.forEach((key, value) {
      if (map.containsKey(key)) {
        map[key] = map[key]! - value;
      } else {
        map[key] = value;
      }
    });
    mapPlus2.forEach((key, value) {
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
    Map<String, double> mapPlus1 = {}
      ..addAll(first.getTotalGrouped(CashboxID: cashBoxID));
    Map<String, double> mapPlus2 = {}
      ..addAll(second.getTotalGrouped(CashboxID: cashBoxID));

    mapPlus1.forEach((key, value) {
      if (map.containsKey(key)) {
        map[key] = map[key]! + value;
      } else {
        map[key] = value;
      }
    });
    mapPlus2.forEach((key, value) {
      if (map.containsKey(key)) {
        map[key] = map[key]! + value;
      } else {
        map[key] = value;
      }
    });
    return map;
  }

  bool isCustomerDashboard() {
    return this is CustomerDashboard;
  }

  List<WidgetGridHelper> getFundWidgets(
      BuildContext context, int crossAxisCount,
      {bool checkForEmpty = false}) {
    bool isMezouj = crossAxisCount % 2 == 0;
    debugPrint(
        "isMezouj: $isMezouj   crossAxisCount $crossAxisCount crossAxisCount % 2= ${crossAxisCount % 2} crossAxisCount % 4 ${crossAxisCount % 4} ");
    int crossCountFund = crossAxisCount ~/ 4;
    int crossAxisCountMod = crossAxisCount % 4;
    int crossCountFundCalc = crossAxisCountMod == 0 ? crossCountFund : 1;

    debugPrint(
        "isMezouj: $isMezouj  crossCountFundCalc $crossCountFundCalc crossAxisCount $crossAxisCount crossAxisCount % 2= ${crossAxisCount % 2} crossAxisCount % 4 ${crossAxisCount % 4}  crossCountFundCalc + crossAxisCountMod =${crossCountFundCalc + crossAxisCountMod}");
    return [
      if (checkForEmptyList(credits, checkForEmpty))
        getWidget(StaggeredGridTile.count(
            crossAxisCellCount: crossCountFundCalc,
            mainAxisCellCount: 1,
            child: ChartCardItemCustom(
              list: credits,
              listGrowthRate: creditsAnalysis,
              icon: Icons.arrow_back_sharp,
              title: AppLocalizations.of(context)!.credits,
              description:
                  "${credits?.getTotalValue(currencyID: 2).toCurrencyFormat()}\n${credits?.getTotalValue(currencyID: 1).toCurrencyFormat()}",
              footer: credits?.length.toString(),
              footerRightWidget: creditsAnalysis.getGrowthRateText(context),
            ))),
      if (checkForEmptyList(debits, checkForEmpty))
        getWidget(StaggeredGridTile.count(
            crossAxisCellCount: crossCountFundCalc,
            mainAxisCellCount: 1,
            child: ChartCardItemCustom(
              color: Debits().getMainColor(),
              icon: Icons.arrow_forward_rounded,
              title: AppLocalizations.of(context)!.debits,
              listGrowthRate: debitsAnalysis,
              description: debits?.getTotalValue().toCurrencyFormat() ?? "",
              footer: debits?.length.toString(),
              footerRightWidget:
                  debitsAnalysis.getGrowthRateText(context, reverseTheme: true),
            ))),
      if (checkForEmptyList(spendings, checkForEmpty) && !isCustomerDashboard())
        getWidget(StaggeredGridTile.count(
            crossAxisCellCount: crossCountFundCalc,
            mainAxisCellCount: 1,
            child: ChartCardItemCustom(
              color: Spendings().getMainColor(),
              icon: Icons.arrow_forward_rounded,
              title: AppLocalizations.of(context)!.spendings,
              description: spendings?.getTotalValue().toCurrencyFormat() ?? "",
              listGrowthRate: spendingsAnalysis,
              footer: spendings?.length.toString(),
              footerRightWidget: spendingsAnalysis.getGrowthRateText(context,
                  reverseTheme: true),
            ))),
      if (checkForEmptyList(incomes, checkForEmpty) && !isCustomerDashboard())
        getWidget(StaggeredGridTile.count(
            crossAxisCellCount: crossCountFundCalc + crossAxisCountMod,
            mainAxisCellCount: 1,
            child: ChartCardItemCustom(
              icon: Icons.arrow_back_sharp,
              listGrowthRate: incomesAnalysis,
              title: AppLocalizations.of(context)!.incomes,
              description: incomes?.getTotalValue().toCurrencyFormat() ?? "",
              footer: incomes?.length.toString(),
              footerRightWidget: incomesAnalysis.getGrowthRateText(context),
            ))),
      //todo set this for dashboard only
      if (checkList(credits))
        getWidget(StaggeredGridTile.count(
            crossAxisCellCount: crossAxisCount,
            mainAxisCellCount: 2,
            child: Card(
              child: ViewableTableViewAbstractWidget(
                  usePag: false,
                  buildActions: true,
                  viewAbstract: [
                    ...credits ?? [],
                    ...debits ?? [],
                    ...spendings ?? [],
                    ...incomes ?? []
                  ]),
            ))),
    ];
  }

  List<WidgetGridHelper> getInvoicesWidgets(
      BuildContext context, int crossAxisCount,
      {bool checkForEmpty = false}) {
    bool isMezouj = crossAxisCount % 2 == 0;

    int crossCountFund = crossAxisCount ~/ 4;
    int crossAxisCountMod = crossAxisCount % 4;
    int crossCountFundCalc = crossAxisCountMod == 0 ? crossCountFund : 1;
    debugPrint(
        "isMezouj: $isMezouj  crossCountFundCalc $crossCountFundCalc crossAxisCount $crossAxisCount crossAxisCount % 2= ${crossAxisCount % 2} crossAxisCount % 4 ${crossAxisCount % 4}  crossCountFundCalc + crossAxisCountMod =${crossCountFundCalc + crossAxisCountMod}");
    return [
      if (checkForEmptyList(orders, checkForEmpty))
        getWidget(StaggeredGridTile.count(
            crossAxisCellCount: crossCountFundCalc + crossAxisCountMod,
            mainAxisCellCount: 1,
            child: ChartCardItemCustom(
              // color: Colors.green.withOpacity(0.2),
              icon: Order().getMainIconData(),
              listGrowthRate: ordersAnalysis,
              title: AppLocalizations.of(context)!.orders,
              description:
                  "${orders?.getTotalQuantityGroupedFormattedText(context)}",
              footer: orders?.length.toString(),
              footerRightWidget: ordersAnalysis.getGrowthRateText(context),
            ))),
      if (checkForEmptyList(purchases, checkForEmpty))
        getWidget(StaggeredGridTile.count(
            crossAxisCellCount: crossCountFundCalc,
            mainAxisCellCount: 1,
            child: ChartCardItemCustom(
              listGrowthRate: purchasesAnalysis,
              icon: Purchases().getMainIconData(),
              title: AppLocalizations.of(context)!.purchases,
              description:
                  "${purchases?.getTotalQuantityGroupedFormattedText(context)}",
              footer: purchases?.length.toString(),
              footerRightWidget: purchasesAnalysis.getGrowthRateText(context),
            ))),
      if (checkForEmptyList(cut_requests, checkForEmpty))
        getWidget(StaggeredGridTile.count(
            crossAxisCellCount: crossCountFundCalc,
            mainAxisCellCount: 1,
            child: ChartCardItemCustom(
              icon: CutRequest().getMainIconData(),
              listGrowthRate: cut_requestsAnalysis,
              title: CutRequest().getMainHeaderLabelTextOnly(context),
              description: "TEST",
              footer: cut_requests?.length.toString(),
              footerRightWidget:
                  cut_requestsAnalysis.getGrowthRateText(context),
            ))),
      if (checkForEmptyList(transfers, checkForEmpty) && !isCustomerDashboard())
        getWidget(StaggeredGridTile.count(
            crossAxisCellCount: crossCountFundCalc,
            mainAxisCellCount: 1,
            child: ChartCardItemCustom(
              icon: Transfers().getMainIconData(),
              title: Transfers().getMainHeaderLabelTextOnly(context),
              listGrowthRate: transfersAnalysis,
              description:
                  transfers.getTotalQuantityGroupedFormattedText(context),
              footer: transfers?.length.toString(),
              footerRightWidget: transfersAnalysis.getGrowthRateText(context),
            ))),
      // getWidget(StaggeredGridTile.count(
      //     crossAxisCellCount: 2,
      //     mainAxisCellCount: 3,
      //     child: TabBarByListWidget<TabControllerHelper>(
      //       tabs: [
      //         TabControllerHelper(
      //           "orders",
      //           widget:
      //               ListStaticWidget(list: orders!, emptyWidget: Text("Empty")),
      //         ),
      //         // TabControllerHelper(
      //         //   "deb",
      //         //   null,
      //         //   widget:
      //         //       ListStaticWidget(list: debits!, emptyWidget: Text("Empty")),
      //         // )
      //       ],
      //     ))),
      if (checkForEmptyList(products_inputs, checkForEmpty) &&
          !isCustomerDashboard())
        getWidget(StaggeredGridTile.count(
            crossAxisCellCount: 1,
            mainAxisCellCount: 1,
            child: ChartCardItemCustom(
              icon: ProductInput().getMainIconData(),
              title: ProductInput().getMainHeaderLabelTextOnly(context),
              description:
                  products_inputs.getTotalQuantityGroupedFormattedText(context),
              footer: products_inputs?.length.toString(),
              footerRightWidget:
                  products_inputsAnalysis.getGrowthRateText(context),
            ))),
      if (checkForEmptyList(products_outputs, checkForEmpty) &&
          !isCustomerDashboard())
        getWidget(StaggeredGridTile.count(
            crossAxisCellCount: 1,
            mainAxisCellCount: 1,
            child: ChartCardItemCustom(
              icon: ProductOutput().getMainIconData(),
              title: ProductOutput().getMainHeaderLabelTextOnly(context),
              description: products_outputs
                  .getTotalQuantityGroupedFormattedText(context),
              footer: products_outputs?.length.toString(),
              footerRightWidget:
                  products_outputsAnalysis.getGrowthRateText(context),
            ))),
      if (checkForEmptyList(reservation_invoice, checkForEmpty))
        getWidget(StaggeredGridTile.count(
            crossAxisCellCount: 1,
            mainAxisCellCount: 1,
            child: ChartCardItemCustom(
              icon: ReservationInvoice().getMainIconData(),
              title: ReservationInvoice().getMainHeaderLabelTextOnly(context),
              description: reservation_invoice
                  .getTotalQuantityGroupedFormattedText(context),
              footer: reservation_invoice?.length.toString(),
              footerRightWidget:
                  reservation_invoiceAnalysis.getGrowthRateText(context),
            ))),
      //todo this only on dashboard
      if (checkList(orders))
        getWidget(StaggeredGridTile.count(
            crossAxisCellCount: crossAxisCount,
            mainAxisCellCount: 2,
            child: Card(
              child: ViewableTableViewAbstractWidget(
                viewAbstract: orders!,
                usePag: true,
                buildActions: true,
              ),
            ))),
    ];
  }
}
