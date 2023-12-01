import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_view_controller/components/title_text.dart';
import 'package:flutter_view_controller/models/apis/date_object.dart';
import 'package:flutter_view_controller/models/apis/growth_rate.dart';
import 'package:flutter_view_controller/models/auto_rest.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_view_controller/models/view_abstract_stand_alone.dart';
import 'package:flutter_view_controller/new_components/chart/line_chart.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/new_screens/dashboard2/components/chart_card_item_custom.dart';
import 'package:flutter_view_controller/new_screens/dashboard2/custom_storage_details.dart';
import 'package:flutter_view_controller/new_screens/lists/list_static_widget.dart';
import '../customers.dart';

class CustomerByEmployeeAnanlysis
    extends ViewAbstractStandAloneCustomViewApi<CustomerByEmployeeAnanlysis>
    implements CustomViewHorizontalListResponse<CustomerByEmployeeAnanlysis> {
  List<Customer>? customers;

  List<GrowthRate>? ordersAnalysisGeneral;
  List<GrowthRate>? purchasesAnalysisGeneral;
  List<GrowthRate>? creditsAnalysisGeneral;
  List<GrowthRate>? debitsAnalysisGeneral;

  DateObject? dateObject;

  CustomerByEmployeeAnanlysis();
  CustomerByEmployeeAnanlysis.init(int iD, {DateObject? dateObject}) {
    this.iD = iD;
    this.dateObject = dateObject;
  }

  @override
  CustomerByEmployeeAnanlysis getSelfNewInstance() {
    return CustomerByEmployeeAnanlysis();
  }

  @override
  Map<ServerActions, List<String>>? isRequiredObjectsList() => {
        ServerActions.list: ["orders"],
      };
  @override
  Widget getCustomStandAloneWidget(BuildContext context) {
    throw UnimplementedError();
  }

  @override
  List<Widget>? getCustomeStandAloneSideWidget(BuildContext context) => null;

  @override
  String? getMainDrawerGroupName(BuildContext context) => null;

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) =>
      AppLocalizations.of(context)!.dashboard_and_rep;
  @override
  bool getCustomStandAloneWidgetIsPadding() {
    return false;
  }

  @override
  String getMainHeaderTextOnly(BuildContext context) =>
      AppLocalizations.of(context)!.dashboard_and_rep;

  @override
  IconData getMainIconData() => Icons.analytics;
  @override
  String? getTableNameApi() => null;
  @override
  String? getCustomAction() => "view_customer_statment_by_employee";

  @override
  Map<String, String> get getCustomMap => {
        "<iD>": iD.toString(),
        "date": jsonEncode(dateObject?.toJson() ??
            DateObject(from: "2022-09-01", to: "2022-11-01").toJson()),
      };

  @override
  double? getCustomViewHeight() => null;

  @override
  String getCustomViewKey() => "customer_by_employee$iD";

  @override
  ResponseType getCustomViewResponseType() => ResponseType.SINGLE;
  @override
  ResponseType getCustomStandAloneResponseType() => ResponseType.SINGLE;
  Widget wrapContainer(
      {required String title,
      required String description,
      Color? color,
      String? footer,
      String? footerRight}) {
    return Container(
      // color: color,
      child: ChartCardItemCustom(
        title: title,
        description: description,
        footer: footer,
        footerRight: footerRight,
      ),
    );
  }

  @override
  Widget? getCustomViewSingleResponseWidget(BuildContext context) {
    return Column(
      children: [
        LineChartItem<GrowthRate, DateTime>(
          title: "title",
          list: ordersAnalysisGeneral ?? [],
          xValueMapper: (item, value) =>
              DateTime(item.year ?? 0, item.month ?? 0, item.day ?? 0),
          yValueMapper: (item, n) => item.total,
        ),
        StorageInfoCardCustom(
            title: AppLocalizations.of(context)!.total,
            description:
                GrowthRate.getTotal(ordersAnalysisGeneral).toCurrencyFormat(),
            trailing:
                GrowthRate.getGrowthRateText(context, ordersAnalysisGeneral),
            svgSrc: Icons.monitor_weight),
        // ExpansionTile(
        //   initiallyExpanded: true,
        //   title: TitleText(
        //       text: AppLocalizations.of(context)!.mostPopular,
        //       fontWeight: FontWeight.bold),
        //   children: [
        //     ListStaticWidget<Customer>(
        //       list: customers
        //               ?.where((c) =>
        //                   c.ordersAnalysis != null &&
        //                   (c.ordersAnalysis?.isNotEmpty ?? false))
        //               .toList() ??
        //           [],
        //       emptyWidget: const Text("no customers"),
        //       listItembuilder: (cust) => ListTile(
        //         leading: cust.getCardLeading(context),
        //         title: Text(cust.name ?? ""),
        //         trailing:
        //             GrowthRate.getGrowthRateText(context, cust.ordersAnalysis),
        //         subtitle: Text(cust
        //             .getTotalAnalsis(cust.ordersAnalysis)
        //             .toCurrencyFormat()),
        //       ),
        //     )
        //   ],
        // )
        // StaggeredGrid.count(
        //   crossAxisCount: 2,
        //   crossAxisSpacing: 2,
        //   mainAxisSpacing: 2,
        //   children: [

        //            StaggeredGridTile.count(
        //           crossAxisCellCount: 1,
        //           mainAxisCellCount: 1,
        //           child: wrapContainer(
        //               title: item.purchases![0]
        //                   .getMainHeaderLabelTextOnly(context),
        //               description: "${item.purchases?.length}")
        //   ],
        // )
        // // StaggeredGrid.count(
        //   crossAxisCount: 2,
        //   mainAxisSpacing: 2,
        //   crossAxisSpacing: 2,
        //   children: [
        //     if (item.purchases!.isNotEmpty)
        //       StaggeredGridTile.count(
        //           crossAxisCellCount: 1,
        //           mainAxisCellCount: 1,
        //           child: wrapContainer(
        //               title: item.purchases![0]
        //                   .getMainHeaderLabelTextOnly(context),
        //               description: "${item.purchases?.length}")),
        //     if (item.purchases_refunds!.isNotEmpty)
        //       StaggeredGridTile.count(
        //           crossAxisCellCount: 1,
        //           mainAxisCellCount: 1,
        //           child: wrapContainer(
        //               title: item.purchases_refunds![0]
        //                   .getMainHeaderLabelTextOnly(context),
        //               description: "${item.purchases_refunds?.length}")),
        //     if (item.orders!.isNotEmpty)
        //       StaggeredGridTile.count(
        //           crossAxisCellCount: 1,
        //           mainAxisCellCount: 1,
        //           child: wrapContainer(
        //               title:
        //                   item.orders![0].getMainHeaderLabelTextOnly(context),
        //               description:
        //                   "${GrowthRate.getTotal(item.ordersAnalysis).toCurrencyFormat(symbol: "kg")} ",
        //               footer: "${item.orders?.length}",
        //               footerRight: "23%")),
        //     if (item.orders_refunds!.isNotEmpty)
        //       StaggeredGridTile.count(
        //           crossAxisCellCount: 1,
        //           mainAxisCellCount: 1,
        //           child: wrapContainer(
        //               title: item.orders_refunds![0]
        //                   .getMainHeaderLabelTextOnly(context),
        //               description: "${item.orders_refunds?.length}")),
        //     if (item.products_inputs!.isNotEmpty)
        //       StaggeredGridTile.count(
        //           crossAxisCellCount: 1,
        //           mainAxisCellCount: 1,
        //           child: wrapContainer(
        //               title: item.products_inputs![0]
        //                   .getMainHeaderLabelTextOnly(context),
        //               description: "${item.products_inputs?.length}")),
        //     if (item.products_outputs!.isNotEmpty)
        //       StaggeredGridTile.count(
        //           crossAxisCellCount: 1,
        //           mainAxisCellCount: 1,
        //           child: wrapContainer(
        //               title: item.products_outputs![0]
        //                   .getMainHeaderLabelTextOnly(context),
        //               description: "${item.products_outputs?.length}")),
        //     if (item.transfers!.isNotEmpty)
        //       StaggeredGridTile.count(
        //           crossAxisCellCount: 1,
        //           mainAxisCellCount: 1,
        //           child: wrapContainer(
        //               title: item.transfers![0]
        //                   .getMainHeaderLabelTextOnly(context),
        //               description: "${item.transfers?.length}")),
        //     if (item.cut_requests!.isNotEmpty)
        //       StaggeredGridTile.count(
        //           crossAxisCellCount: 1,
        //           mainAxisCellCount: 1,
        //           child: wrapContainer(
        //               title: item.cut_requests![0]
        //                   .getMainHeaderLabelTextOnly(context),
        //               description: "${item.cut_requests?.length}")),
        //   ],
        // ),
      ],
    );
  }

  @override
  void onCustomViewCardClicked(
      BuildContext context, CustomerByEmployeeAnanlysis istem) {
    // TODO: implement onCustomViewCardClicked
  }
  @override
  Map<String, dynamic> toJsonViewAbstract() => {};

  @override
  CustomerByEmployeeAnanlysis fromJsonViewAbstract(Map<String, dynamic> json) =>
      CustomerByEmployeeAnanlysis()
        ..customers = (json['customers'] as List<dynamic>?)
            ?.map((e) => Customer.fromJson(e as Map<String, dynamic>))
            .toList()
        ..creditsAnalysisGeneral =
            (json['creditsAnalysisGeneral'] as List<dynamic>?)
                ?.map((e) => GrowthRate.fromJson(e as Map<String, dynamic>))
                .toList()
        ..debitsAnalysisGeneral =
            (json['debitsAnalysisGeneral'] as List<dynamic>?)
                ?.map((e) => GrowthRate.fromJson(e as Map<String, dynamic>))
                .toList()
        ..purchasesAnalysisGeneral =
            (json['purchasesAnalysisGeneral'] as List<dynamic>?)
                ?.map((e) => GrowthRate.fromJson(e as Map<String, dynamic>))
                .toList()
        ..ordersAnalysisGeneral =
            (json['ordersAnalysisGeneral'] as List<dynamic>?)
                ?.map((e) => GrowthRate.fromJson(e as Map<String, dynamic>))
                .toList();

  @override
  Widget? getCustomViewListResponseWidget(
      BuildContext context, List<CustomerByEmployeeAnanlysis> item) {
    return null;
  }

  @override
  Widget? getCustomViewTitleWidget(
      BuildContext context, ValueNotifier valueNotifier) {
    return null;
  }

  @override
  Widget? getCustomFloatingActionWidget(BuildContext context) {
    return null;
  }
}
