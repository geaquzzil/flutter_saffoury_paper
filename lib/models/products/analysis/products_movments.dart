import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/icon_data.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/services/text_input.dart';
import 'package:flutter_saffoury_paper/models/invoices/cuts_invoices/cut_requests.dart';
import 'package:flutter_saffoury_paper/models/invoices/priceless_invoices/products_inputs.dart';
import 'package:flutter_saffoury_paper/models/invoices/priceless_invoices/products_outputs.dart';
import 'package:flutter_saffoury_paper/models/invoices/purchases.dart';
import 'package:flutter_saffoury_paper/models/invoices/refund_invoices/orders_refunds.dart';
import 'package:flutter_saffoury_paper/models/invoices/refund_invoices/purchasers_refunds.dart';
import 'package:flutter_saffoury_paper/models/products/products.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_view_controller/models/apis/growth_rate.dart';
import 'package:flutter_view_controller/models/auto_rest.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:flutter_view_controller/models/view_abstract_non_list.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_view_controller/new_components/chart/multi_line_chart.dart';
import 'package:flutter_view_controller/new_screens/dashboard2/components/chart_card_item.dart';
import 'package:flutter_view_controller/new_screens/dashboard2/components/chart_card_item_custom.dart';
import 'package:flutter_view_controller/new_screens/dashboard2/custom_storage_details.dart';
import 'package:flutter_view_controller/test_var.dart';
import '../../invoices/orders.dart';
import '../../invoices/priceless_invoices/transfers.dart';

class ProductMovments extends ViewAbstractStandAloneCustomView<ProductMovments>
    implements CustomViewHorizontalListResponse<ProductMovments> {
  Product? products;

  List<Purchases>? purchases;
  List<GrowthRate>? purchasesAnalysis;

  List<PurchasesRefund>? purchases_refunds;
  List<GrowthRate>? purchases_refundsAnalysis;

  List<Order>? orders;
  List<GrowthRate>? ordersAnalysis;

  List<OrderRefund>? orders_refunds;
  List<GrowthRate>? orders_refundsAnalysis;

  List<ProductInput>? products_inputs;
  List<GrowthRate>? products_inputsAnalysis;

  List<ProductOutput>? products_outputs;
  List<GrowthRate>? products_outputsAnalysis;

  List<Transfers>? transfers;
  List<GrowthRate>? transfersAnalysis;

  List<CutRequest>? cut_requests;
  List<GrowthRate>? cut_requestsAnalysis;

  ProductMovments();
  ProductMovments.init(int iD) {
    this.iD = iD;
  }

  @override
  double getCustomViewHeight() => 500;

  @override
  String getCustomViewKey() => "products_movments$iD";
  @override
  String? getCustomAction() => "list_products_movements";
  @override
  Map<String, String> get getCustomMap => {"<ProductID>": iD.toString()};

  @override
  Future<ProductMovments?> callApi() async {
    return fromJsonViewAbstract(jsonDecode(jsonEncode(productMovement)));
  }

  @override
  Widget? getCustomViewListResponseWidget(
          BuildContext context, List<ProductMovments> item) =>
      null;
  Widget wrapContainer(
      {required String title, required String description, Color? color}) {
    return Container(
      // color: color,
      child: ChartCardItemCustom(title: title, description: description),
    );
  }

  List<List<GrowthRate>> getAnalysisChart() {
    return [
      if (ordersAnalysis != null) ordersAnalysis ?? [],
      if (purchasesAnalysis != null) purchasesAnalysis ?? [],
      if (purchases_refundsAnalysis != null) purchases_refundsAnalysis ?? [],
      if (orders_refundsAnalysis != null) orders_refundsAnalysis ?? [],
      if (products_inputsAnalysis != null) products_inputsAnalysis ?? [],
      if (products_outputsAnalysis != null) products_outputsAnalysis ?? [],
      if (transfersAnalysis != null) transfersAnalysis ?? [],
      if (cut_requestsAnalysis != null) cut_requestsAnalysis ?? []
    ];
  }

  @override
  Widget? getCustomViewSingleResponseWidget(
      BuildContext context, ProductMovments item) {
    return Column(
      children: [
        MultiLineChartItem<GrowthRate, DateTime>(
          title: "title",
          list: item.getAnalysisChart(),
          xValueMapper: (item, value, indexInsideList) =>
              DateTime(value.year ?? 0, value.month ?? 0, value.day ?? 0),
          yValueMapper: (item, n, indexInsideList) => n.total,
        ),
        StaggeredGrid.count(
          crossAxisCount: 2,
          mainAxisSpacing: 2,
          crossAxisSpacing: 2,
          children: [
            if (item.purchases!.isNotEmpty)
              StaggeredGridTile.count(
                  crossAxisCellCount: 1,
                  mainAxisCellCount: 1,
                  child: wrapContainer(
                      title: item.purchases![0]
                          .getMainHeaderLabelTextOnly(context),
                      description: "${item.purchases?.length}")),
            if (item.purchases_refunds!.isNotEmpty)
              StaggeredGridTile.count(
                  crossAxisCellCount: 1,
                  mainAxisCellCount: 1,
                  child: wrapContainer(
                      title: item.purchases_refunds![0]
                          .getMainHeaderLabelTextOnly(context),
                      description: "${item.purchases_refunds?.length}")),
            if (item.orders!.isNotEmpty)
              StaggeredGridTile.count(
                  crossAxisCellCount: 1,
                  mainAxisCellCount: 1,
                  child: wrapContainer(
                      title:
                          item.orders![0].getMainHeaderLabelTextOnly(context),
                      description: "${item.orders?.length}")),
            if (item.orders_refunds!.isNotEmpty)
              StaggeredGridTile.count(
                  crossAxisCellCount: 1,
                  mainAxisCellCount: 1,
                  child: wrapContainer(
                      title: item.orders_refunds![0]
                          .getMainHeaderLabelTextOnly(context),
                      description: "${item.orders_refunds?.length}")),
            if (item.products_inputs!.isNotEmpty)
              StaggeredGridTile.count(
                  crossAxisCellCount: 1,
                  mainAxisCellCount: 1,
                  child: wrapContainer(
                      title: item.products_inputs![0]
                          .getMainHeaderLabelTextOnly(context),
                      description: "${item.products_inputs?.length}")),
            if (item.products_outputs!.isNotEmpty)
              StaggeredGridTile.count(
                  crossAxisCellCount: 1,
                  mainAxisCellCount: 1,
                  child: wrapContainer(
                      title: item.products_outputs![0]
                          .getMainHeaderLabelTextOnly(context),
                      description: "${item.products_outputs?.length}")),
            if (item.transfers!.isNotEmpty)
              StaggeredGridTile.count(
                  crossAxisCellCount: 1,
                  mainAxisCellCount: 1,
                  child: wrapContainer(
                      title: item.transfers![0]
                          .getMainHeaderLabelTextOnly(context),
                      description: "${item.transfers?.length}")),
            if (item.cut_requests!.isNotEmpty)
              StaggeredGridTile.count(
                  crossAxisCellCount: 1,
                  mainAxisCellCount: 1,
                  child: wrapContainer(
                      title: item.cut_requests![0]
                          .getMainHeaderLabelTextOnly(context),
                      description: "${item.cut_requests?.length}")),
          ],
        ),
      ],
    );
  }

  @override
  ResponseType getCustomViewResponseType() => ResponseType.SINGLE;
  @override
  ResponseType getCustomStandAloneResponseType() => ResponseType.SINGLE;

  @override
  void onCustomViewCardClicked(BuildContext context, ProductMovments istem) {
    // TODO: implement onCustomViewCardClicked
  }

  @override
  Widget getCustomStandAloneWidget(BuildContext context) {
    // TODO: implement getCustomStandAloneWidget
    throw UnimplementedError();
  }

  @override
  List<Widget>? getCustomeStandAloneSideWidget(BuildContext context) {
    // TODO: implement getCustomeStandAloneSideWidget
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toJsonViewAbstract() => {};
  @override
  ProductMovments fromJsonViewAbstract(Map<String, dynamic> json) =>
      ProductMovments()
        ..cut_requests = (json['cut_requests'] as List<dynamic>?)
            ?.map((e) => CutRequest.fromJson(e as Map<String, dynamic>))
            .toList()
        ..products = Product.fromJson(json['products'])
        ..purchases = (json['purchases'] as List<dynamic>?)
            ?.map((e) => Purchases.fromJson(e as Map<String, dynamic>))
            .toList()
        ..purchasesAnalysis = (json['purchasesAnalysis'] as List<dynamic>?)
            ?.map((e) => GrowthRate.fromJson(e as Map<String, dynamic>))
            .toList()
        ..purchases_refunds = (json['purchases_refunds'] as List<dynamic>?)
            ?.map((e) => PurchasesRefund.fromJson(e as Map<String, dynamic>))
            .toList()
        ..purchases_refundsAnalysis =
            (json['purchases_refundsAnalysis'] as List<dynamic>?)
                ?.map((e) => GrowthRate.fromJson(e as Map<String, dynamic>))
                .toList()
        ..orders = (json['orders'] as List<dynamic>?)
            ?.map((e) => Order.fromJson(e as Map<String, dynamic>))
            .toList()
        ..ordersAnalysis = (json['ordersAnalysis'] as List<dynamic>?)
            ?.map((e) => GrowthRate.fromJson(e as Map<String, dynamic>))
            .toList()
        ..orders_refunds = (json['orders_refunds'] as List<dynamic>?)
            ?.map((e) => OrderRefund.fromJson(e as Map<String, dynamic>))
            .toList()
        ..orders_refundsAnalysis =
            (json['orders_refundsAnalysis'] as List<dynamic>?)
                ?.map((e) => GrowthRate.fromJson(e as Map<String, dynamic>))
                .toList()
        ..products_inputs = (json['products_inputs'] as List<dynamic>?)
            ?.map((e) => ProductInput.fromJson(e as Map<String, dynamic>))
            .toList()
        ..products_inputsAnalysis =
            (json['products_inputsAnalysis'] as List<dynamic>?)
                ?.map((e) => GrowthRate.fromJson(e as Map<String, dynamic>))
                .toList()
        ..products_outputs = (json['products_outputs'] as List<dynamic>?)
            ?.map((e) => ProductOutput.fromJson(e as Map<String, dynamic>))
            .toList()
        ..products_outputsAnalysis =
            (json['products_outputsAnalysis'] as List<dynamic>?)
                ?.map((e) => GrowthRate.fromJson(e as Map<String, dynamic>))
                .toList()
        ..transfers = (json['transfers'] as List<dynamic>?)
            ?.map((e) => Transfers.fromJson(e as Map<String, dynamic>))
            .toList()
        ..transfersAnalysis = (json['transfersAnalysis'] as List<dynamic>?)
            ?.map((e) => GrowthRate.fromJson(e as Map<String, dynamic>))
            .toList()
        ..cut_requests = (json['cut_requests'] as List<dynamic>?)
            ?.map((e) => CutRequest.fromJson(e as Map<String, dynamic>))
            .toList()
        ..cut_requestsAnalysis =
            (json['cut_requestsAnalysis'] as List<dynamic>?)
                ?.map((e) => GrowthRate.fromJson(e as Map<String, dynamic>))
                .toList();

  @override
  String? getMainDrawerGroupName(BuildContext context) => null;

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) =>
      AppLocalizations.of(context)!.movments;

  @override
  String getMainHeaderTextOnly(BuildContext context) =>
      getMainHeaderLabelTextOnly(context);

  @override
  IconData getMainIconData() => Icons.move_down;
  @override
  String? getTableNameApi() => null;
}
