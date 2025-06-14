import 'package:animate_do/animate_do.dart' as animate;
import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/products/products.dart';
import 'package:flutter_saffoury_paper/widgets/cut_request_top_widget.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/l10n/app_localization.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/new_components/header_description.dart';
import 'package:flutter_view_controller/new_screens/actions/components/action_on_header_widget.dart';
import 'package:flutter_view_controller/screens/base_shared_drawer_navigation.dart';
import 'package:flutter_view_controller/screens/base_shared_header_rating.dart';

class ProductTopWidget extends StatelessWidget {
  final Product product;
  final ValueNotifier<SecondPaneHelper?>? valueNotifier;
  const ProductTopWidget({
    super.key,
    required this.product,
    this.valueNotifier,
  });

  ///weight per on sheet
  ///prie per on sheet
  ///total qantity
  ///total sheet
  ///total price
  @override
  Widget build(BuildContext context) {
    TextStyle? titleStyle = Theme.of(context).textTheme.titleLarge;
    TextStyle? descriptionStyle = Theme.of(context).textTheme.bodySmall;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // ProductHeaderToggle(product: product),
        HeaderDescription(
          iconData: Icons.announcement_rounded,
          title: AppLocalizations.of(context)!.about,
          description:
              product.comments ?? AppLocalizations.of(context)!.no_content,
        ),
        const Divider(),
        // SizedBox(height: kDefaultPadding),

        HeaderDescription(
          iconData: Icons.info_outline,
          title: AppLocalizations.of(context)!.overview,
          // trailing: IconButton(
          //     icon: const Icon(Icons.calculate),
          //     onPressed: () {
          //       valueNotifier?.value = SecondPaneHelper(title: "Calc", value: [
          //         SliverToBoxAdapter(child: Text("dsadas")),
          //         SliverToBoxAdapter(child: Text("dasdadsa"))
          //       ]);
          //     }),
        ),
        getRow(context, [
          TitleAndDescription(
              title: product.sizes!.getMainHeaderLabelTextOnly(context),
              description: product.sizes!.getMainHeaderTextOnly(context)),
          TitleAndDescription(
              title: AppLocalizations.of(context)!.grainOn,
              description: product.getGrainOn())
        ]),
        if (!product.isRoll() && product.hasPermissionQuantityOrPrice(context))
          getRow(context, [
            if (product.hasPermissionQuantity(context))
              TitleAndDescription(
                  title: AppLocalizations.of(context)!.weightPerSheet,
                  description:
                      product.getSheetWeightStringFormat(context: context)),
            if (product.hasPermissionPrice(context))
              TitleAndDescription(
                  title: AppLocalizations.of(context)!.pricePerSheet,
                  description:
                      product.getOneSheetPriceStringFormat(context: context))
          ]),
        if (product.hasPermissionPrice(context))
          getRow(context, [
            TitleAndDescription(
                title:
                    "${AppLocalizations.of(context)!.unit_price} (${AppLocalizations.of(context)!.per_each} ${product.getProductTypeUnit(context)})",
                description:
                    product.getUnitSellPriceStringFormat(context: context)),
            TitleAndDescription(
              title: AppLocalizations.of(context)!.total_price,
              descriptionWidget: Text(
                product.getTotalSellPriceStringFormat(context: context),
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: Theme.of(context).colorScheme.primary),
              ),
            )
          ]),
        const Divider(),
        HeaderDescription(
          iconData: Icons.insert_drive_file_outlined,
          title: AppLocalizations.of(context)!.hideCargoInfo,
        ),
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
                  title: Text(e.title,
                      style: Theme.of(context).textTheme.bodySmall),
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
    super.key,
    required this.product,
  });

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
                        duration: const Duration(milliseconds: 500),
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
                      ActionsOnHeaderWidget(
                        viewAbstract: product,
                        serverActions: ServerActions.view,
                      ),
                      // Row(
                      //   children: [
                      //     IconButton(onPressed: () {}, icon: Icon(Icons.email)),
                      //     IconButton(onPressed: () {}, icon: Icon(Icons.call)),
                      //     IconButton(onPressed: () {}, icon: Icon(Icons.share))
                      //   ],
                      // )
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
