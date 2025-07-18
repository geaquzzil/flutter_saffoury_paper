import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/cities/countries_manufactures.dart';
import 'package:flutter_saffoury_paper/models/customs/customs_declarations.dart';
import 'package:flutter_saffoury_paper/models/invoices/cuts_invoices/cut_requests.dart';
import 'package:flutter_saffoury_paper/models/invoices/orders.dart';
import 'package:flutter_saffoury_paper/models/invoices/priceless_invoices/products_inputs.dart';
import 'package:flutter_saffoury_paper/models/invoices/priceless_invoices/products_outputs.dart';
import 'package:flutter_saffoury_paper/models/invoices/priceless_invoices/reservation_invoice.dart';
import 'package:flutter_saffoury_paper/models/invoices/priceless_invoices/transfers.dart';
import 'package:flutter_saffoury_paper/models/invoices/purchases.dart';
import 'package:flutter_saffoury_paper/models/invoices/refund_invoices/orders_refunds.dart';
import 'package:flutter_saffoury_paper/models/invoices/refund_invoices/purchasers_refunds.dart';
import 'package:flutter_saffoury_paper/models/products/grades.dart';
import 'package:flutter_saffoury_paper/models/products/gsms.dart';
import 'package:flutter_saffoury_paper/models/products/products.dart';
import 'package:flutter_saffoury_paper/models/products/products_color.dart';
import 'package:flutter_saffoury_paper/models/products/products_types.dart';
import 'package:flutter_saffoury_paper/models/products/qualities.dart';
import 'package:flutter_saffoury_paper/models/products/sizes.dart';
import 'package:flutter_saffoury_paper/models/products/stocks.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/models/apis/date_object.dart';
import 'package:flutter_view_controller/models/auto_rest.dart';
import 'package:flutter_view_controller/models/request_options.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_permissions.dart';
import 'package:flutter_view_controller/new_components/cards/cards.dart';
import 'package:flutter_view_controller/new_components/chart/line_chart.dart';
import 'package:flutter_view_controller/new_screens/dashboard2/my_files.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_api_master_new.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_static_list_new.dart';
import 'package:json_annotation/json_annotation.dart';

part 'products_expected_to_buy.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class ProductsExcpectedToBuy extends Product
    implements CustomViewHorizontalListResponse<ProductsExcpectedToBuy> {
  ProductsExcpectedToBuy() : super();
  @override
  String? getTableNameApi() {
    return null;
  }

  @override
  ProductsExcpectedToBuy fromJsonViewAbstract(Map<String, dynamic> json) {
    return ProductsExcpectedToBuy.fromJson(json);
  }

  @override
  RequestOptions? getRequestOption({
    required ServerActions action,
    RequestOptions? generatedOptionFromListCall,
  }) {
    return RequestOptions().addDate(DateObject()).setDisablePaging();
  }

  @override
  List<String>? getCustomAction() {
    return ["products", "expectedToBuy"];
  }

  @override
  String getCustomViewKey() {
    return "";
  }

  @override
  ResponseType getCustomViewResponseType() => ResponseType.LIST;
  @override
  getCustomViewResponseWidget(
    BuildContext context, {
    required SliverApiWithStaticMixin<SliverApiMixinWithStaticStateful> state,
    List? items,
  }) {
    return Padding(
      padding: state.defaultSliverGridPadding,
      child: StaggerdGridViewWidget(
        builder: (i, i2, i3, h) => [
          StaggeredGridTile.count(
            crossAxisCellCount: i2,
            mainAxisCellCount: h,
            child: Card(
              child: SliverApiMixinStaticList(
                list: items?.cast<ViewAbstract>() ?? [],
                scrollDirection: Axis.vertical,
                cardType: CardItemType.list,
                isSliver: false,
              ),
            ),
          ),

          StaggeredGridTile.count(
            crossAxisCellCount: i - (i2),
            mainAxisCellCount: h,
            child: Cards(
              type: CardType.outline,
              child: (_) => Padding(
                padding: const EdgeInsets.all(kDefaultPadding),
                child: LineChartItem<ProductsExcpectedToBuy, String>(
                  title: "totla: ${items?.length} ",
                  list: items?.cast() ?? [],
                  dataLabelMapper: (item, idx) {
                    return item.getMainHeaderTextOnly(context);
                  },
                  xValueMapper: (item, value) =>
                      item.orders_details_count.toString(),
                  yValueMapper: (item, n) => item.inventory_count,
                ),
              ),
            ),
          ),
        ],
        wrapWithCard: false,
        // crossAxisCount: 2,
        childAspectRatio: 1,

        // width < 1400 ? 1.1 : 1.4,
      ),
    );
    // StaggerdGridViewWidget()
    return SliverPadding(
      padding: state.defaultSliverGridPadding,
      sliver: SliverGrid(
        gridDelegate: SliverStairedGridDelegate(
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,

          pattern: [StairedGridTile(.5, 3 / 2), StairedGridTile(.5, 3 / 2)],
        ),

        ///Lazy building of list
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            /// To convert this infinite list to a list with "n" no of items,
            /// uncomment the following line:
            /// if (index > n) return null;
            if (index == 0) {
              return Card(
                child: SliverApiMixinStaticList(
                  list: items?.cast<ViewAbstract>() ?? [],
                  scrollDirection: Axis.vertical,
                  cardType: CardItemType.list,
                  isSliver: false,
                ),
              );
            }
            return Column(children: []);
          },

          childCount: 2,

          /// Set childCount to limit no.of items
          /// childCount: 100,
        ),
      ),
    );
  }

  @override
  void onCustomViewCardClicked(BuildContext context, ViewAbstract istem) {}

  factory ProductsExcpectedToBuy.fromJson(Map<String, dynamic> data) =>
      _$ProductsExcpectedToBuyFromJson(data);
  @override
  Map<String, dynamic> toJson() => _$ProductsExcpectedToBuyToJson(this);
}
