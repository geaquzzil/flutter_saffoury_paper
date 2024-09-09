import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/products/products.dart';
import 'package:flutter_saffoury_paper/models/products/warehouse.dart';

class GoodsInventoryListCard extends StatelessWidget {
  Product product;
  Warehouse? selectedWarehouse;
  GoodsInventoryListCard(
      {super.key, required this.product, this.selectedWarehouse});

  @override
  Widget build(BuildContext context) {
    // ()
    return Card(
      child: ExpansionTile(
        leading: product.getCardLeading(context),
        title: product.getMainHeaderText(context),
        subtitle: product.getMainLabelSubtitleText(context),
        children: [product.getFullDescription()],
        // isThreeLine: true,
      ),
    );
  }
}
