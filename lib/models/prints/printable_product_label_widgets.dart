import 'package:flutter/material.dart' as material;
import 'package:pdf/widgets.dart';

import 'package:flutter_gen/gen_l10n/app_localization.dart';
import '../products/products.dart';

class ProductLabelPDF {
  material.BuildContext context;
  Product product;
  ProductLabelPDF(this.context, this.product);

  Widget generate() {
    return GridView(crossAxisCount: 3, children: [
      buildLabelAndText(AppLocalizations.of(context)!.products_type,
          product.getProductTypeNameString()),
           buildLabelAndText(AppLocalizations.of(context)!.products_type,
          product.getProductTypeNameString()),
    ]);
  }

  Widget buildLabelAndText(String label, String value) {
    return Column(children: [
      Text(label, style: TextStyle(fontSize: 8)),
      Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
    ]);
  }
}
