import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/products/products.dart';
import 'package:flutter_saffoury_paper/models/products/sizes.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/models/request_options.dart';
import 'package:flutter_view_controller/new_components/lists/list_card_item_master.dart';
import 'package:flutter_view_controller/screens/base_shared_drawer_navigation.dart';

class ProductSizeAnalyzerCard extends StatelessWidget {
  final Product product;
  final RequestOptions requestOptions;
  final SecoundPaneHelperWithParentValueNotifier? state;
  const ProductSizeAnalyzerCard({
    super.key,
    required this.product,
    required this.requestOptions,
    this.state,
  });

  @override
  Widget build(BuildContext context) {

    double waste = (product).findWastePercentage(
      size: ProductSize()
        ..width = (requestOptions.extras['width'] )
        ..length = requestOptions.extras['length'],
      gsm: requestOptions.extras['gsm'],
    );
    Widget? superWidget = product.getCardTrailing(
      context,
      secPaneHelper: state,
    );

    Widget traling = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "$waste%-${((waste / 100) * product.getQuantity()).toCurrencyFormat(symbol: product.getProductTypeUnit(context))}",
        ),
        if (superWidget != null) superWidget,
      ],
    );
    return ListCardItemMaster(state: state, object: product, traling: traling);
  }
}
