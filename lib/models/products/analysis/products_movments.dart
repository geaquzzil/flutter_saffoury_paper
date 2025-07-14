import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/invoices/cuts_invoices/cut_requests.dart';
import 'package:flutter_saffoury_paper/models/invoices/priceless_invoices/products_inputs.dart';
import 'package:flutter_saffoury_paper/models/invoices/priceless_invoices/products_outputs.dart';
import 'package:flutter_saffoury_paper/models/invoices/priceless_invoices/reservation_invoice.dart';
import 'package:flutter_saffoury_paper/models/invoices/purchases.dart';
import 'package:flutter_saffoury_paper/models/invoices/refund_invoices/orders_refunds.dart';
import 'package:flutter_saffoury_paper/models/invoices/refund_invoices/purchasers_refunds.dart';
import 'package:flutter_saffoury_paper/models/products/products.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/l10n/app_localization.dart';
import 'package:flutter_view_controller/models/apis/growth_rate.dart';
import 'package:flutter_view_controller/models/auto_rest.dart';
import 'package:flutter_view_controller/models/request_options.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_stand_alone.dart';
import 'package:flutter_view_controller/new_components/chart/multi_line_chart.dart';
import 'package:flutter_view_controller/new_screens/dashboard2/components/chart_card_item_custom.dart';
import 'package:flutter_view_controller/new_screens/dashboard2/my_files.dart';

import '../../invoices/orders.dart';
import '../../invoices/priceless_invoices/transfers.dart';

class ProductMovments
    extends ViewAbstractStandAloneCustomViewApi<ProductMovments>
    implements CustomViewHorizontalListResponse<ProductMovments> {
  int? ProductID;
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

  List<ReservationInvoice>? reservation_invoice;
  List<GrowthRate>? reservation_invoiceAnalysis;

  ProductMovments();
  ProductMovments.init(int iD) {
    ProductID = iD;
  }

  @override
  ProductMovments getSelfNewInstance() {
    return ProductMovments();
  }

  @override
  String getCustomViewKey() => "products_movments$ProductID";

  @override
  List<String>? getCustomAction() {
    return ["products", "movement", "$ProductID"];
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

  @override
  bool getCustomStandAloneWidgetIsPadding() {
    return false;
  }

  // @override
  // Future<ProductMovments?> callApi() async {
  //   return fromJsonViewAbstract(jsonDecode(jsonEncode(productMovement)));
  // }

  @override
  Widget? getCustomViewListResponseWidget(
    BuildContext context,
    List<ProductMovments> item,
  ) => null;
  Widget wrapContainer({
    required String title,
    required String description,
    required BuildContext context,
    required List<ViewAbstract> list,
    Color? color,
    String? footer,
    String? footerRight,
    List<GrowthRate>? listGrowthRate,
  }) {
    return ChartCardItemCustom(
      title: title,
      color: list[0].getMainColor(),
      description: description,
      footer: footer,
      footerRightWidget: listGrowthRate.getGrowthRateText(
        context,
        reverseTheme: true,
      ),
      listGrowthRate: listGrowthRate,
      footerRight: footerRight,
      onTap: () {
        Navigator.pushNamed(context, "/list", arguments: list);
      },
    );
  }

  List<ViewAbstract> getAnalysisChartTitle(BuildContext context) {
    return [
      if (ordersAnalysis?.isNotEmpty ?? false) Order(),
      if (purchasesAnalysis?.isNotEmpty ?? false) Purchases(),
      if (purchases_refundsAnalysis?.isNotEmpty ?? false) PurchasesRefund(),
      if (orders_refundsAnalysis?.isNotEmpty ?? false) OrderRefund(),
      if (products_inputsAnalysis?.isNotEmpty ?? false) ProductInput(),
      if (products_outputsAnalysis?.isNotEmpty ?? false) ProductOutput(),
      if (transfersAnalysis?.isNotEmpty ?? false) Transfers(),
      if (reservation_invoiceAnalysis?.isNotEmpty ?? false)
        ReservationInvoice(),
      if (cut_requestsAnalysis?.isNotEmpty ?? false) CutRequest(),
      // if (spendingsAnalysis?.isNotEmpty ??false) spendingsAnalysis ?? [],
      // if (incomesAnalysis?.isNotEmpty ??false) incomesAnalysis ?? []
    ];
  }

  List<List<GrowthRate>> getAnalysisChart() {
    return [
      if (ordersAnalysis?.isNotEmpty ?? false) ordersAnalysis ?? [],
      if (purchasesAnalysis?.isNotEmpty ?? false) purchasesAnalysis ?? [],
      if (purchases_refundsAnalysis?.isNotEmpty ?? false)
        purchases_refundsAnalysis ?? [],
      if (orders_refundsAnalysis?.isNotEmpty ?? false)
        orders_refundsAnalysis ?? [],
      if (products_inputsAnalysis?.isNotEmpty ?? false)
        products_inputsAnalysis ?? [],
      if (products_outputsAnalysis?.isNotEmpty ?? false)
        products_outputsAnalysis ?? [],
      if (transfersAnalysis?.isNotEmpty ?? false) transfersAnalysis ?? [],
      if (cut_requestsAnalysis?.isNotEmpty ?? false) cut_requestsAnalysis ?? [],
      if (reservation_invoiceAnalysis?.isNotEmpty ?? false)
        cut_requestsAnalysis ?? [],
    ];
  }

  @override
  Widget? getCustomViewSingleResponseWidget(BuildContext context) {
    // return Text(products?.getIDFormat(context) ?? " dsa");
    return FileInfoStaggerdGridView(
      builder: (i, i2, i3, h) => getStaggeredGridTileList(context, i2, i3),
      wrapWithCard: false,
      // crossAxisCount: 2,
      childAspectRatio: 1.2,

      // width < 1400 ? 1.1 : 1.4,
    );
    // return
    //     // MultiLineChartItem<GrowthRate, DateTime>(
    //     //   title: "title",
    //     //   list: item.getAnalysisChart(),
    //     //   xValueMapper: (item, value, indexInsideList) =>
    //     //       DateTime(value.year ?? 0, value.month ?? 0, value.day ?? 0),
    //     //   yValueMapper: (item, n, indexInsideList) => n.total,
    //     // ),
    //     StaggeredGrid.count(
    //   crossAxisCount: 8,
    //   mainAxisSpacing: 2,
    //   crossAxisSpacing: 2,
    //   children: getStaggeredGridTileList(context),
    // );
  }

  List<StaggeredGridTile> getStaggeredGridTileList(
    BuildContext context,
    int calc,
    int mod,
  ) {
    return [
      StaggeredGridTile.count(
        crossAxisCellCount: calc + mod,
        mainAxisCellCount: 1,
        child: MultiLineChartItem<GrowthRate, DateTime>(
          title: "T",
          list: getAnalysisChart(),
          titles: getAnalysisChartTitle(context),
          dataLabelMapper: (item, idx) => item.total.toCurrencyFormat(),
          xValueMapper: (item, value, indexInsideList) =>
              DateTime(value.year ?? 2022, value.month ?? 1, value.day ?? 1),
          yValueMapper: (item, n, indexInsideList) => n.total,
        ),
      ),
      if (purchases?.isNotEmpty ?? false)
        StaggeredGridTile.count(
          crossAxisCellCount: calc,
          mainAxisCellCount: .5,
          child: wrapContainer(
            context: context,
            listGrowthRate: purchasesAnalysis,
            list: purchases?.cast() ?? [],
            title: purchases![0].getMainHeaderLabelTextOnly(context),
            description: "${purchases?.length}",
          ),
        ),
      if (purchases_refunds?.isNotEmpty ?? false)
        StaggeredGridTile.count(
          crossAxisCellCount: calc,
          mainAxisCellCount: .5,
          child: wrapContainer(
            context: context,
            listGrowthRate: purchases_refundsAnalysis,
            list: purchases_refunds?.cast() ?? [],
            title: purchases_refunds![0].getMainHeaderLabelTextOnly(context),
            description: "${purchases_refunds?.length}",
          ),
        ),
      if (orders?.isNotEmpty ?? false)
        StaggeredGridTile.count(
          crossAxisCellCount: calc,
          mainAxisCellCount: .5,
          child: wrapContainer(
            context: context,
            listGrowthRate: ordersAnalysis,
            list: orders?.cast() ?? [],
            title: orders![0].getMainHeaderLabelTextOnly(context),
            description:
                "${GrowthRate.getTotal(ordersAnalysis).toCurrencyFormat(symbol: "kg")} ",
            footer: "${orders?.length}",
            footerRight: "23%",
          ),
        ),
      if (orders_refunds?.isNotEmpty ?? false)
        StaggeredGridTile.count(
          crossAxisCellCount: calc,
          mainAxisCellCount: .5,
          child: wrapContainer(
            context: context,
            listGrowthRate: orders_refundsAnalysis,
            list: orders_refunds?.cast() ?? [],
            title: orders_refunds![0].getMainHeaderLabelTextOnly(context),
            description: "${orders_refunds?.length}",
          ),
        ),
      if (products_inputs?.isNotEmpty ?? false)
        StaggeredGridTile.count(
          crossAxisCellCount: calc,
          mainAxisCellCount: .5,
          child: wrapContainer(
            context: context,
            listGrowthRate: products_inputsAnalysis,
            list: products_inputs?.cast() ?? [],
            title: products_inputs![0].getMainHeaderLabelTextOnly(context),
            description: "${products_inputs?.length}",
          ),
        ),
      if (products_outputs?.isNotEmpty ?? false)
        StaggeredGridTile.count(
          crossAxisCellCount: calc,
          mainAxisCellCount: .5,
          child: wrapContainer(
            context: context,
            listGrowthRate: products_outputsAnalysis,
            list: products_outputs?.cast() ?? [],
            title: products_outputs![0].getMainHeaderLabelTextOnly(context),
            description: "${products_outputs?.length}",
          ),
        ),
      if (transfers?.isNotEmpty ?? false)
        StaggeredGridTile.count(
          crossAxisCellCount: calc,
          mainAxisCellCount: .5,
          child: wrapContainer(
            context: context,
            listGrowthRate: transfersAnalysis,
            list: transfers?.cast() ?? [],
            title: transfers![0].getMainHeaderLabelTextOnly(context),
            description: "${transfers?.length}",
          ),
        ),
      if (cut_requests?.isNotEmpty ?? false)
        StaggeredGridTile.count(
          crossAxisCellCount: calc,
          mainAxisCellCount: .5,
          child: wrapContainer(
            context: context,
            listGrowthRate: cut_requestsAnalysis,
            list: cut_requests?.cast() ?? [],
            title: cut_requests![0].getMainHeaderLabelTextOnly(context),
            description: "${cut_requests?.length}",
          ),
        ),
      if (reservation_invoice?.isNotEmpty ?? false)
        StaggeredGridTile.count(
          crossAxisCellCount: calc,
          mainAxisCellCount: .5,
          child: wrapContainer(
            context: context,
            listGrowthRate: reservation_invoiceAnalysis,
            list: reservation_invoice?.cast() ?? [],
            title: reservation_invoice![0].getMainHeaderLabelTextOnly(context),
            description: "${reservation_invoice?.length}",
          ),
        ),
    ];
  }

  @override
  ResponseType getCustomViewResponseType() => ResponseType.SINGLE;
  @override
  ResponseType getCustomStandAloneResponseType() => ResponseType.SINGLE;

  @override
  void onCustomViewCardClicked(BuildContext context, ProductMovments istem) {}

  @override
  Widget getCustomStandAloneWidget(BuildContext context) {
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

  @override
  double? getCustomViewHeight() => 700;

  @override
  Widget? getCustomViewTitleWidget(
    BuildContext context,
    ValueNotifier valueNotifier,
  ) {
    return null;
  }

  @override
  Widget? getCustomFloatingActionWidget(BuildContext context) {
    return null;
  }

  @override
  Widget? getCustomViewOnResponse(ProductMovments response) {
    // TODO: implement getCustomViewOnResponse
    throw UnimplementedError();
  }

  @override
  Widget? getCustomViewOnResponseAddWidget(ProductMovments response) {
    // TODO: implement getCustomViewOnResponseAddWidget
    throw UnimplementedError();
  }
}
