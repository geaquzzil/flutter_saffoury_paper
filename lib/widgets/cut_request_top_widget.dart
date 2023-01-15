import 'package:animate_do/animate_do.dart' as animate;
import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/invoices/cuts_invoices/cut_request_results.dart';
import 'package:flutter_saffoury_paper/models/invoices/cuts_invoices/cut_requests.dart';
import 'package:flutter_saffoury_paper/models/invoices/cuts_invoices/sizes_cut_requests.dart';
import 'package:flutter_saffoury_paper/models/products/products.dart';
import 'package:flutter_saffoury_paper/models/products/sizes.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/new_components/header_description.dart';
import 'package:flutter_view_controller/new_components/header_description_as_expanstion.dart';
import 'package:flutter_view_controller/new_components/lists/list_card_item.dart';
import 'package:flutter_view_controller/new_screens/actions/view/view_card_item.dart';
import 'package:flutter_view_controller/screens/base_shared_header_rating.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class CutRequestTopWidget extends StatelessWidget {
  CutRequest object;
  CutRequestTopWidget({super.key, required this.object});

  ///weight per on sheet
  ///prie per on sheet
  ///total qantity
  ///total sheet
  ///total price
  @override
  Widget build(BuildContext context) {
    debugPrint("CutRequestTopWidget ${object.toString()}");
    TextStyle? titleStyle = Theme.of(context).textTheme.titleLarge;
    TextStyle? descriptionStyle = Theme.of(context).textTheme.caption;
    bool hasCutResult = ((object.cut_request_results_count ?? 0) > 0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        HeaderDescription(
          iconData: Icons.info_outline,
          title: AppLocalizations.of(context)!.overview,
          description: "Overview of the cut request requested sizes",
        ),
        ...object.sizes_cut_requests!
            .map((e) => getSizeWidget(context, e))
            .toList(),
        if (hasCutResult)
          HeaderDescriptionAsExpanstion(
            isTitleLarge: false,
            iconData: Icons.done,
            children: object.cut_request_results![0].products_inputs!
                .getProductsFromDetailList()!
                .map((e) => getCutResultWidtget(context, e))
                .toList(),
            title: AppLocalizations.of(context)!.cutRequestResult,
            description: "Overview of the cut request results sizes",
          )
      ],
    );
  }

  Widget getCutResultWidtget(BuildContext context, Product cutRequestResult) {
    return ListCardItem(object: cutRequestResult);
  }

  Widget getSizeWidget(BuildContext context, SizesCutRequest productSize) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(children: [
        HeaderDescription(
            isTitleLarge: false,
            title: productSize.sizes!.getMainHeaderLabelWithText(context)),
        getRow(context, [
          TitleAndDescription(
              title: AppLocalizations.of(context)!.weightPerSheet,
              description: object.getSheetWeightStirngFormat(
                  context: context, size: productSize)),
          TitleAndDescription(
              title: AppLocalizations.of(context)!.pricePerSheet,
              description: object.getOnSheetPriceSringFormat(
                  context: context, size: productSize))
        ]),
        getRow(context, [
          TitleAndDescription(
              title: AppLocalizations.of(context)!.quantity,
              description: productSize.quantity
                  .toCurrencyFormat(symbol: AppLocalizations.of(context)!.kg)),
          TitleAndDescription(
              title: AppLocalizations.of(context)!.sheets,
              description:
                  object.getSheetsNumber(productSize).toCurrencyFormat())
        ])
      ]),
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
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {}, icon: const Icon(Icons.email)),
                          IconButton(
                              onPressed: () {}, icon: const Icon(Icons.call)),
                          IconButton(
                              onPressed: () {}, icon: const Icon(Icons.share))
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
