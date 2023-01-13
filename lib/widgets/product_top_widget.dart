import 'package:animate_do/animate_do.dart' as animate;
import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/products/products.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/screens/base_shared_header_rating.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class ProductTopWidget extends StatelessWidget {
  final Product product;
  const ProductTopWidget({super.key, required this.product});

  ///weight per on sheet
  ///prie per on sheet
  ///total qantity
  ///total sheet
  ///total price
  @override
  Widget build(BuildContext context) {
    TextStyle? titleStyle = Theme.of(context).textTheme.titleLarge;
    TextStyle? descriptionStyle = Theme.of(context).textTheme.caption;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // ProductHeaderToggle(product: product),
        ListTile(
          title: Text(
            "About",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          subtitle: Text(
            "dsadasdkasjdlk;jaskldjalskjdklasjdaskljlawskjlaskjsdklajsladkjlaskasdjsakjdasjdjkhaskjdhjkashdjksahjkashjkashjkasdhjkashdjksahsdjkahjkasdhkj",
            // style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        SizedBox(height: kDefaultPadding),
        ListTile(
          title: Text(
            "Overview",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          leading: Icon(Icons.info_outline),
          trailing: IconButton(icon: Icon(Icons.calculate), onPressed: () {}),
        ),
        getRow(context, [
          TitleAndDescription(
              title: product.sizes!.getMainHeaderLabelTextOnly(context),
              description: product.sizes!.getMainHeaderTextOnly(context)),
          TitleAndDescription(
              title: AppLocalizations.of(context)!.grainOn,
              description: product.getGrainOn())
        ]),
        if (!product.isRoll())
          getRow(context, [
            TitleAndDescription(
                title: AppLocalizations.of(context)!.weightPerSheet,
                description:
                    product.getSheetWeight().toCurrencyFormat(symbol: "g ")),
            TitleAndDescription(
                title: AppLocalizations.of(context)!.pricePerSheet,
                description: product
                    .getOneSheetPrice()
                    .toCurrencyFormatFromSetting(context))
          ]),
        getRow(context, [
          TitleAndDescription(
              title:
                  "${AppLocalizations.of(context)!.unit_price} (${AppLocalizations.of(context)!.per_each} ${product.getProductTypeUnit(context)})",
              description: product
                  .getUnitSellPrice()
                  .toCurrencyFormatFromSetting(context)),
          TitleAndDescription(
            title: AppLocalizations.of(context)!.total_price,
            descriptionWidget: Text(
              product.getTotalSellPrice().toCurrencyFormatFromSetting(context),
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: Theme.of(context).colorScheme.primary),
            ),
          )
        ]),
        SizedBox(height: kDefaultPadding),

        // BottomWidgetOnViewIfCartable(viewAbstract: product),
        Text(
          "More info",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        // BottomWidgetOnViewIfCartable(
        //   viewAbstract: product,
        // )
      ],
    );
  }

  Widget getRow(BuildContext context, List<TitleAndDescription> tile) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      // crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: tile
          .map((e) => Expanded(
                child: ListTile(
                  title:
                      Text(e.title, style: Theme.of(context).textTheme.caption),
                  subtitle: e.descriptionWidget ??
                      Text(
                        e.description ?? "",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                  leading: e.icon == null ? null : Icon(e.icon),
                ),
              ))
          .toList(),
    );
  }
}

class ProductHeaderToggle extends StatelessWidget {
  const ProductHeaderToggle({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: SizedBox(
                      height: 100, child: product.getCardLeadingImage(context)),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      // FadeInLeftBig(child: child)
                      animate.FadeInLeft(
                        duration: Duration(milliseconds: 500),
                        child: ListTile(
                          title: Text(
                            product.products_types!.name ?? "",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          subtitle: Text(
                            product.products_types!.comments ?? "",
                            // style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ),
                      BaseSharedDetailsRating(
                        viewAbstract: product,
                      ),
                      Row(
                        children: [
                          IconButton(onPressed: () {}, icon: Icon(Icons.email)),
                          IconButton(onPressed: () {}, icon: Icon(Icons.call)),
                          IconButton(onPressed: () {}, icon: Icon(Icons.share))
                        ],
                      )
                      // Spacer(),
                      // ElevatedButton(
                      //   child: Text("Add to Card"),
                      //   onPressed: () {},
                      // )
                    ],
                  ),
                ),
              ]),
        ),
      ],
    );
  }
}

class TitleAndDescription {
  String title;
  String? description;
  Widget? descriptionWidget;
  IconData? icon;
  TitleAndDescription(
      {required this.title,
      this.description,
      this.descriptionWidget,
      this.icon});
}
