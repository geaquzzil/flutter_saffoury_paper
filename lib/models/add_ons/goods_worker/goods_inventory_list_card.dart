import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_saffoury_paper/models/products/products.dart';
import 'package:flutter_saffoury_paper/models/products/warehouse.dart';
import 'package:flutter_view_controller/components/expansion_tile_custom_expand_to_card.dart';
import 'package:flutter_view_controller/ext_utils.dart';

class GoodsInventoryListCard extends StatelessWidget {
  Product product;
  Warehouse? selectedWarehouse;
  GoodsInventoryListCard(
      {super.key, required this.product, this.selectedWarehouse});

  String getWareHouseText(BuildContext context) {
    return selectedWarehouse == null
        ? AppLocalizations.of(context)!.all
        : selectedWarehouse!.getMainHeaderTextOnly(context);
  }

  String getRemainigWeight(BuildContext context) {
    return (product.getQuantity(warehouse: selectedWarehouse) -
            product.qrQuantity.toNonNullable())
        .toCurrencyFormat(symbol: AppLocalizations.of(context)!.kg);
  }

  bool isValidate(BuildContext context) {
    return (product.getQuantity(warehouse: selectedWarehouse) -
            product.qrQuantity.toNonNullable()) ==
        0;
  }

  bool hasErrors(BuildContext context) {
    return (product.getQuantity(warehouse: selectedWarehouse) -
            product.qrQuantity.toNonNullable()) <
        0;
  }

  Color? getCardColor(BuildContext context) {
    if (hasErrors(context)) {
      return Theme.of(context).colorScheme.errorContainer;
    } else if (isValidate(context)) {
      return Theme.of(context).colorScheme.tertiary;
    }
    return null;
  }

  Widget? getTrailing(BuildContext context) {
    if (hasErrors(context)) {
      return Icon(
        Icons.close,
        color: getCardColor(context),
      );
    } else if (isValidate(context)) {
      return Icon(
        Icons.check,
        color: getCardColor(context),
      );
    }
    return null;
  }

  Widget getText(BuildContext context, String title, String subtitle) {
    return ListTile(
      title: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .bodyMedium!
            .copyWith(color: Theme.of(context).colorScheme.primary),
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(context)
            .textTheme
            .bodyLarge!
            .copyWith(color: Theme.of(context).colorScheme.primary),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ()
    return Card(
      elevation: 10,
      // color: getCardColor(context),
      child: ExpansionTileCard(
        context: context,
        leading: product.getCardLeading(context),
        title: product.getMainHeaderText(context),
        trailing: getTrailing(context),
        subtitle: Row(children: [
          Expanded(
              child: getText(
                  context,
                   //TODO Translate
                  "CurrentQuantity",
                  product.qrQuantity.toNonNullable().toCurrencyFormat(
                      symbol: AppLocalizations.of(context)!.kg))),
          Expanded(
              child: getText(
                  context,
                  getWareHouseText(context),
                  product
                      .getQuantity(warehouse: selectedWarehouse)
                      .toCurrencyFormat(
                          symbol: AppLocalizations.of(context)!.kg))),
          Expanded(
              child: getText(
                  context,
                  AppLocalizations.of(context)!.remaining_weight_label,
                  getRemainigWeight(context))),
        ]),
        // trailing: Text(product
        //     .getQuantity(warehouse: selectedWarehouse)
        //     .toCurrencyFormat()),
        children: [product.getFullDescription()],
        // isThreeLine: true,
      ),
    );
  }
}
