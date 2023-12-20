// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/icon_data.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/services/text_input.dart';
import 'package:flutter_saffoury_paper/models/funds/credits.dart';
import 'package:flutter_saffoury_paper/models/funds/debits.dart';
import 'package:flutter_saffoury_paper/models/funds/incomes.dart';
import 'package:flutter_saffoury_paper/models/funds/spendings.dart';
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
import 'package:flutter_saffoury_paper/models/products/products.dart';
import 'package:flutter_saffoury_paper/models/users/user_analysis_lists.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/interfaces/dashable_interface.dart';
import 'package:flutter_view_controller/models/apis/date_object.dart';
import 'package:flutter_view_controller/models/apis/growth_rate.dart';
import 'package:flutter_view_controller/models/dealers/dealer.dart';
import 'package:flutter_view_controller/models/permissions/permission_level_abstract.dart';
import 'package:flutter_view_controller/models/permissions/setting.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:flutter_view_controller/models/view_abstract_permissions.dart';
import 'package:flutter_view_controller/new_components/chart/line_chart.dart';
import 'package:flutter_view_controller/new_screens/dashboard2/components/chart_card_item_custom.dart';
import 'package:flutter_view_controller/new_screens/lists/list_api_auto_rest_horizontal.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

import '../invoices/invoice_master.dart';

part 'sales_analysis_dashboard.g.dart';

//TODO on publish change $FROM Date "2022-01-01"
@JsonSerializable(explicitToJson: true)
@reflector
class SalesAnalysisDashboard extends UserLists<SalesAnalysisDashboard>
    implements DashableInterface {
  DateObject? dateObject;

  // List<Product>? bestSellingSize;

  // List<Product>? bestSellingGSM;

  // List<Product>? bestSellingTYPE;

  // List<Product>? bestProfitableType;

  List<GrowthRate>? orders_offline_count;
  List<GrowthRate>? orders_online_count;
  List<GrowthRate>? customers_count;
  List<GrowthRate>? products;

  List<GrowthRate>? totalSalesQuantity;
  List<GrowthRate>? totalReturnsQuantity;
  List<GrowthRate>? totalNetSalesQuantity;

  List<GrowthRate>? totalSalesPrice;
  List<GrowthRate>? totalReturnsPrice;
  List<GrowthRate>? totalNetSalesPrice;

  List<GrowthRate>? profitsByOrder;
  List<GrowthRate>? profitsByCutRequests;
  List<GrowthRate>? wastesByCutRequests;

  List<AccountNamesBalance>? incomesDue;
  List<AccountNamesBalance>? spendingsDue;

  List<GrowthRate>? calculatedNetProfit;

  SalesAnalysisDashboard();

  @override
  String? getTableNameApi() => "list_sales";

  @override
  String? getCustomAction() => "list_sales";

  SalesAnalysisDashboard.init({this.dateObject});
  @override
  SalesAnalysisDashboard getSelfNewInstance() {
    return SalesAnalysisDashboard();
  }

  @override
  IconData getMainIconData() {
    return Icons.ssid_chart_sharp;
  }

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) =>
      AppLocalizations.of(context)!.dashboard_and_rep;

  @override
  String getMainHeaderTextOnly(BuildContext context) =>
      AppLocalizations.of(context)!.dashboard_and_rep;
  @override
  Map<String, String> get getCustomMap => {
        "date": jsonEncode(dateObject?.toJson() ?? DateObject().toJson()),
      };

  // @override
  // Future<SalesAnalysisDashboard?> callApi() async {
  //   // debugPrint("DashboardPage callApi  ${jsonEncode(dashboard)}");
  //   await Future.delayed(Duration(seconds: 2));
  //   return fromJsonViewAbstract(jsonDecode(jsonEncode(dashboard)));
  // }

  factory SalesAnalysisDashboard.fromJson(Map<String, dynamic> data) =>
      _$SalesAnalysisDashboardFromJson(data);

  @override
  Map<String, dynamic> toJson() => _$SalesAnalysisDashboardToJson(this);

  @override
  Map<String, dynamic> toJsonViewAbstract() => toJson();

  @override
  SalesAnalysisDashboard fromJsonViewAbstract(Map<String, dynamic> json) =>
      SalesAnalysisDashboard.fromJson(json);

  @override
  List<DashableGridHelper> getDashboardSectionsFirstPane(
      BuildContext context, int crossAxisCount) {
    return [
      DashableGridHelper(
          title: AppLocalizations.of(context)!.profit_analysis,
          widgets: [
            getWidget(StaggeredGridTile.count(
                crossAxisCellCount: 2,
                mainAxisCellCount: 1,
                child: ChartCardItemCustom(
                  // list: incomesDue,
                  listGrowthRate: totalSalesPrice,
                  icon: Icons.monetization_on,
                  title:
                      AppLocalizations.of(context)!.total_sales.toUpperCase(),
                  description: totalSalesPrice.getTotalTextFromSetting(context),
                  footer: totalSalesQuantity.getTotalText(
                      symple: AppLocalizations.of(context)!.quantity),
                  footerRightWidget: totalSalesPrice.getGrowthRateText(context),
                ))),
            getWidget(StaggeredGridTile.count(
                crossAxisCellCount: 1,
                mainAxisCellCount: 2,
                child: ChartCardItemCustom(
                  // list: incomesDue,
                  listGrowthRate: incomesAnalysis,
                  icon: Icons.arrow_back_sharp,
                  title:
                      AppLocalizations.of(context)!.total_incomes.toUpperCase(),
                  description: incomesAnalysis.getTotalTextFromSetting(context),
                  // footer: credits?.length.toString(),
                  footerRightWidget: incomesAnalysis.getGrowthRateText(context),
                ))),
            getWidget(StaggeredGridTile.count(
                crossAxisCellCount: 1,
                mainAxisCellCount: 2,
                child: ChartCardItemCustom(
                  // list: spendingsDue,
                  icon: Icons.arrow_forward,
                  listGrowthRate: spendingsAnalysis,

                  color: Theme.of(context).colorScheme.error,
                  title: AppLocalizations.of(context)!
                      .total_expenses
                      .toUpperCase(),
                  description:
                      spendingsAnalysis.getTotalTextFromSetting(context),
                  // footer: credits?.length.toString(),
                  footerRightWidget: spendingsAnalysis
                      .getGrowthRateText(context, reverseTheme: true),
                ))),
            getWidget(StaggeredGridTile.count(
                crossAxisCellCount: 2,
                mainAxisCellCount: 3.5,
                child: ChartCardItemCustom(
                  // list: incomesDue,
                  // listGrowthRate: spendingsAnalysis,
                  icon: Icons.monetization_on,
                  title: AppLocalizations.of(context)!
                      .total_net_profit
                      .toUpperCase(),
                  description: "TODO total_net_profit ",
                  footer: spendingsAnalysis?.length.toString(),
                  footerRightWidget:
                      spendingsAnalysis.getGrowthRateText(context),
                ))),
            getWidget(StaggeredGridTile.count(
                crossAxisCellCount: 2,
                mainAxisCellCount: 1,
                child: ChartCardItemCustom(
                  // list: spendingsDue,
                  listGrowthRate: profitsByOrder,
                  icon: Icons.currency_exchange_sharp,
                  title: AppLocalizations.of(context)!
                      .total_sales_Revenue
                      .toUpperCase(),
                  description: profitsByOrder.getTotalTextFromSetting(context),
                  footer: profitsByOrder.getLastRecordTextFromSetting(context),
                  footerRightWidget: profitsByOrder.getGrowthRateText(context),
                ))),
            getWidget(
              StaggeredGridTile.count(
                  crossAxisCellCount: 2,
                  mainAxisCellCount: 1.5,
                  child: ChartCardItemCustom(
                    // list: spendingsDue,
                    listGrowthRate: profitsByCutRequests,
                    icon: Icons.shopping_cart,
                    title:
                        AppLocalizations.of(context)!.cutRequest.toUpperCase(),
                    description:
                        profitsByCutRequests.getTotalTextFromSetting(context),
                    footer: profitsByCutRequests
                        .getLastRecordTextFromSetting(context),
                    footerRightWidget:
                        profitsByCutRequests.getGrowthRateText(context),
                  )),
            ),
            getWidget(
              StaggeredGridTile.count(
                  crossAxisCellCount: 2,
                  mainAxisCellCount: 1.5,
                  child: ChartCardItemCustom(
                    // list: spendingsDue,
                    color: Theme.of(context).colorScheme.error,
                    listGrowthRate: wastesByCutRequests,
                    icon: Icons.delete,
                    title:
                        AppLocalizations.of(context)!.totalWaste.toUpperCase(),
                    description:
                        wastesByCutRequests.getTotalTextFromSetting(context),
                    footer: wastesByCutRequests
                        .getLastRecordTextFromSetting(context),
                    footerRightWidget: wastesByCutRequests
                        .getGrowthRateText(context, reverseTheme: true),
                  )),
            ),
          ])
    ];
  }

  @override
  List<DashableGridHelper> getDashboardSectionsSecoundPane(
      BuildContext context, int crossAxisCount) {
    debugPrint("getDashboardSectionsSecoundPane $this");
    return [
      // if (checkList(profits))
      DashableGridHelper(
          title: AppLocalizations.of(context)!.sales_analysis,
          widgets: [
            getWidget(
                StaggeredGridTile.count(
                    crossAxisCellCount: 2,
                    mainAxisCellCount: 1.5,
                    child: LineChartItem<GrowthRate, String>(
                      list: wastesByCutRequests ?? [],
                      // title:
                      //     CutRequest().getMainHeaderLabelTextOnly(context),
                      dataLabelMapper: (item, idx) => item.total
                          ?.toCurrencyFormat(
                              symbol: AppLocalizations.of(context)!.kg),
                      xValueMapper: (item, value) {
                        // debugPrint("ChartItem $item");
                        return DateFormat.MMM().format(
                            DateTime(item.year!, item.month!, item.day ?? 1));
                      },
                      yValueMapper: (item, n) => item.total,
                    )),
                type: WidgetDashboardType.CHART),
            getWidget(
              StaggeredGridTile.count(
                  crossAxisCellCount: 1,
                  mainAxisCellCount: 1,
                  child: ChartCardItemCustom(
                    // list: spendingsDue,
                    listGrowthRate: orders_offline_count,
                    icon: Icons.shopping_cart,
                    title: AppLocalizations.of(context)!
                        .offlineOrder
                        .toUpperCase(),
                    description: AppLocalizations.of(context)!
                        .itemsFormat(orders_offline_count.getTotalText())
                        .toUpperCase(),
                    // footer: orders_offline_count?.length.toString(),
                    footerRightWidget:
                        orders_offline_count.getGrowthRateText(context),
                  )),
            ),
            getWidget(
              StaggeredGridTile.count(
                  crossAxisCellCount: 1,
                  mainAxisCellCount: 1,
                  child: ChartCardItemCustom(
                    // list: spendingsDue,
                    listGrowthRate: orders_online_count,
                    icon: Icons.shopping_cart,
                    title:
                        AppLocalizations.of(context)!.onlineOrder.toUpperCase(),

                    description: AppLocalizations.of(context)!
                        .itemsFormat(orders_online_count.getTotalText())
                        .toUpperCase(),
                    // footer: orders_offline_count?.length.toString(),
                    footerRightWidget:
                        orders_online_count.getGrowthRateText(context),
                  )),
            ),
            getWidget(
              StaggeredGridTile.count(
                  crossAxisCellCount: 1,
                  mainAxisCellCount: 1,
                  child: ChartCardItemCustom(
                    // list: spendingsDue,
                    listGrowthRate: customers_count,
                    icon: Icons.shopping_cart,
                    title: AppLocalizations.of(context)!
                        .totalFormat(AppLocalizations.of(context)!.customers)
                        .toUpperCase(),

                    description: AppLocalizations.of(context)!
                        .itemsFormat(customers_count.getTotalText())
                        .toUpperCase(),
                    // footer: orders_offline_count?.length.toString(),
                    footerRightWidget:
                        customers_count.getGrowthRateText(context),
                  )),
            ),
            getWidget(
              StaggeredGridTile.count(
                  crossAxisCellCount: 1,
                  mainAxisCellCount: 1,
                  child: ChartCardItemCustom(
                    // list: spendingsDue,
                    listGrowthRate: products,
                    icon: Icons.shopping_cart,
                    title: AppLocalizations.of(context)!
                        .totalFormat(AppLocalizations.of(context)!.products)
                        .toUpperCase(),
                    description: AppLocalizations.of(context)!
                        .itemsFormat(products.getTotalText())
                        .toUpperCase(),
                    // footer: orders_offline_count?.length.toString(),
                    footerRightWidget: products.getGrowthRateText(context),
                  )),
            ),
          ])
    ];
  }

  @override
  bool isRequiredObjectsListChecker() {
    return wastesByCutRequests != null;
  }

  @override
  void setDate(DateObject? date) {
    dateObject = date;
    wastesByCutRequests = null;
  }

  @override
  Map<String, IconData> getFieldIconDataMap() => {};

  @override
  Map<String, String> getFieldLabelMap(BuildContext context) => {};
  @override
  String? getMainDrawerGroupName(BuildContext context) =>
      AppLocalizations.of(context)!.users;

  @override
  List<String> getMainFields({BuildContext? context}) => [];
}

class AccountNamesBalance {
  String? name;
  double? sum;

  AccountNamesBalance();

  factory AccountNamesBalance.fromJson(Map<String, dynamic> data) =>
      AccountNamesBalance()
        ..name = data['name'] as String?
        ..sum = InvoiceMaster.convertToDouble(data['sum']);

  Map<String, dynamic> toJson() => {};
}
