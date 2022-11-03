import 'dart:convert';

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
import 'package:flutter_view_controller/new_components/chart/multi_line_chart.dart';
import 'package:flutter_view_controller/new_components/chart/pie_chart.dart';
import 'package:flutter_view_controller/new_screens/dashboard2/components/chart_card_item_custom.dart';
import 'package:flutter_view_controller/new_screens/dashboard2/custom_storage_details.dart';
import 'package:flutter_view_controller/new_screens/dashboard2/storage_detail.dart';
import 'package:flutter_view_controller/test_var.dart';
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

  Dashboard() : super();

  Dashboard.init(int iD, {DateObject? dateObject}) {
    this.iD = iD;
    date = dateObject;
  }
  @override
  Future<Dashboard?> callApi() async {
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
        "date": jsonEncode(
            DateObject(from: "2022-02-02", to: "2022-02-03").toJson()),
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
  List<List<GrowthRate>> getAnalysisChart() {
    return [
      if (creditsAnalysis != null) creditsAnalysis ?? [],
      if (debitsAnalysis != null) debitsAnalysis ?? [],
      // if (spendingsAnalysis != null) spendingsAnalysis ?? [],
      // if (incomesAnalysis != null) incomesAnalysis ?? [],
    ];
  }

  double getTotalTodayBalance({int? CashBoxID, String? currency}) {
    return (creditsBalanceToday.getTotalValue(
                cashBoxID: CashBoxID, currencyName: currency) +
            incomesBalanceToday.getTotalValue(
                cashBoxID: CashBoxID, currencyName: currency)) -
        (debitsBalanceToday.getTotalValue(
                cashBoxID: CashBoxID, currencyName: currency) +
            spendingsBalanceToday.getTotalValue(
                cashBoxID: CashBoxID, currencyName: currency));
  }

  double getTotalBalanceDue({int? CashBoxID, String? currency}) {
    return (creditsDue.getTotalValue(
                cashBoxID: CashBoxID, currencyName: currency) +
            incomesDue.getTotalValue(
                cashBoxID: CashBoxID, currencyName: currency)) -
        (debitsDue.getTotalValue(cashBoxID: CashBoxID, currencyName: currency) +
            spendingsDue.getTotalValue(
                cashBoxID: CashBoxID, currencyName: currency));
  }

  List<StaggeredGridTile> getInvoicesWidgets(BuildContext context) {
    return [
      StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: ChartCardItemCustom(
            icon: Icons.arrow_back_sharp,
            title: AppLocalizations.of(context)!.orders,
            description:
                "${orders![0]?.orders_details.getTotalQuantityGrouped(unit: ProductTypeUnit.KG)}",
            footer: orders?.length.toString(),
            footerRightWidget: ordersAnalysis.getGrowthRateText(context),
          )),
      StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: ChartCardItemCustom(
            icon: Icons.arrow_forward_rounded,
            title: AppLocalizations.of(context)!.debits,
            description: debits?.getTotalValue().toCurrencyFormat() ?? "",
            footer: debits?.length.toString(),
            footerRightWidget: debitsAnalysis.getGrowthRateText(context),
          )),
      StaggeredGridTile.count(
          crossAxisCellCount: 2,
          mainAxisCellCount: 2,
          child: MultiLineChartItem<GrowthRate, DateTime>(
            title: "T",
            list: getAnalysisChart(),
            xValueMapper: (item, value, indexInsideList) =>
                DateTime(value.year ?? 0, value.month ?? 0, value.day ?? 0),
            yValueMapper: (item, n, indexInsideList) => n.total,
          )),
      StaggeredGridTile.count(
          crossAxisCellCount: 2,
          mainAxisCellCount: 3,
          child: StarageDetailsCustom(
            list: [],
            chart: CirculeChartItem<double, String>(
              list: [
                credits.getTotalValueEqualtiy(),
                debits.getTotalValueEqualtiy(),
                spendings.getTotalValueEqualtiy(),
                incomes.getTotalValueEqualtiy()
              ],
              title: "",
              xValueMapper: (item, value) {
                return item.toCurrencyFormat();
              },
              yValueMapper: (item, num) {
                return item;
              },
            ),
          )),
      StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: ChartCardItemCustom(
            icon: Icons.arrow_forward_rounded,
            title: AppLocalizations.of(context)!.spendings,
            description: spendings?.getTotalValue().toCurrencyFormat() ?? "",
            footer: spendings?.length.toString(),
            footerRightWidget: spendingsAnalysis.getGrowthRateText(context),
          )),
      StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: ChartCardItemCustom(
            icon: Icons.arrow_back_sharp,
            title: AppLocalizations.of(context)!.incomes,
            description: incomes?.getTotalValue().toCurrencyFormat() ?? "",
            footer: incomes?.length.toString(),
            footerRightWidget: incomesAnalysis.getGrowthRateText(context),
          )),
      StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: ChartCardItemCustom(
            icon: Icons.today,
            title: AppLocalizations.of(context)!.this_day,
            description: getTotalTodayBalance().toCurrencyFormat() ?? "",
            // footer: incomes?.length.toString(),
            // footerRightWidget: incomesAnalysis.getGrowthRateText(context),
          )),
      StaggeredGridTile.count(
          crossAxisCellCount: 3,
          mainAxisCellCount: 1,
          child: ChartCardItemCustom(
            icon: Icons.balance,
            title: AppLocalizations.of(context)!.balance_due,
            description: getTotalBalanceDue().toCurrencyFormat() ?? "",
            // footer: incomes?.length.toString(),
            // footerRightWidget: incomesAnalysis.getGrowthRateText(context),
          )),
    ];
  }

  List<StaggeredGridTile> getFundWidgets(BuildContext context) {
    return [
      StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: ChartCardItemCustom(
            icon: Icons.arrow_back_sharp,
            title: AppLocalizations.of(context)!.credits,
            description:
                "${credits?.getTotalValue(currencyID: 2).toCurrencyFormat()}\n${credits?.getTotalValue(currencyID: 1).toCurrencyFormat()}" ??
                    "",
            footer: credits?.length.toString(),
            footerRightWidget: creditsAnalysis.getGrowthRateText(context),
          )),
      StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: ChartCardItemCustom(
            icon: Icons.arrow_forward_rounded,
            title: AppLocalizations.of(context)!.debits,
            description: debits?.getTotalValue().toCurrencyFormat() ?? "",
            footer: debits?.length.toString(),
            footerRightWidget: debitsAnalysis.getGrowthRateText(context),
          )),
      StaggeredGridTile.count(
          crossAxisCellCount: 2,
          mainAxisCellCount: 2,
          child: MultiLineChartItem<GrowthRate, DateTime>(
            title: "T",
            list: getAnalysisChart(),
            xValueMapper: (item, value, indexInsideList) =>
                DateTime(value.year ?? 0, value.month ?? 0, value.day ?? 0),
            yValueMapper: (item, n, indexInsideList) => n.total,
          )),
      StaggeredGridTile.count(
          crossAxisCellCount: 2,
          mainAxisCellCount: 3,
          child: StarageDetailsCustom(
            list: [],
            chart: CirculeChartItem<double, String>(
              list: [
                credits.getTotalValueEqualtiy(),
                debits.getTotalValueEqualtiy(),
                spendings.getTotalValueEqualtiy(),
                incomes.getTotalValueEqualtiy()
              ],
              title: "",
              xValueMapper: (item, value) {
                return item.toCurrencyFormat();
              },
              yValueMapper: (item, num) {
                return item;
              },
            ),
          )),
      StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: ChartCardItemCustom(
            icon: Icons.arrow_forward_rounded,
            title: AppLocalizations.of(context)!.spendings,
            description: spendings?.getTotalValue().toCurrencyFormat() ?? "",
            footer: spendings?.length.toString(),
            footerRightWidget: spendingsAnalysis.getGrowthRateText(context),
          )),
      StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: ChartCardItemCustom(
            icon: Icons.arrow_back_sharp,
            title: AppLocalizations.of(context)!.incomes,
            description: incomes?.getTotalValue().toCurrencyFormat() ?? "",
            footer: incomes?.length.toString(),
            footerRightWidget: incomesAnalysis.getGrowthRateText(context),
          )),
      StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: ChartCardItemCustom(
            icon: Icons.today,
            title: AppLocalizations.of(context)!.this_day,
            description: getTotalTodayBalance().toCurrencyFormat() ?? "",
            // footer: incomes?.length.toString(),
            // footerRightWidget: incomesAnalysis.getGrowthRateText(context),
          )),
      StaggeredGridTile.count(
          crossAxisCellCount: 3,
          mainAxisCellCount: 1,
          child: ChartCardItemCustom(
            icon: Icons.balance,
            title: AppLocalizations.of(context)!.balance_due,
            description: getTotalBalanceDue().toCurrencyFormat() ?? "",
            // footer: incomes?.length.toString(),
            // footerRightWidget: incomesAnalysis.getGrowthRateText(context),
          )),
    ];
  }

  @override
  List<DashableGridHelper> getDashboardSections(BuildContext context) => [
        DashableGridHelper(AppLocalizations.of(context)!.overview,
            [...getFundWidgets(context), ...getInvoicesWidgets(context)])
      ];
}
