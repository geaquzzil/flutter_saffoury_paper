import 'package:animations/animations.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/products/products.dart';
import 'package:flutter_view_controller/l10n/app_localization.dart';
import 'package:flutter_view_controller/new_screens/actions/master_to_list_page.dart';
import 'package:palette_generator/palette_generator.dart';

import '../models/products/products_types.dart';

class ListItemProductTypeCategory extends StatelessWidget {
  ProductType productType;
  ListItemProductTypeCategory({super.key, required this.productType});
  PaletteGenerator? color;
  String? imgUrl;
  @override
  Widget build(BuildContext context) {
    init(context);
    if (imgUrl != null) {
      return FutureBuilder<PaletteGenerator>(
        future: PaletteGenerator.fromImageProvider(
          FastCachedImageProvider(imgUrl!),
        ),
        builder: (context, snapshot) =>
            openContainer(context, color: snapshot.data),
      );
    }

    return openContainer(context);
  }

  Widget openContainer(BuildContext context, {PaletteGenerator? color}) {
    return OpenContainer(
        closedColor: Colors.transparent,
        transitionDuration: const Duration(milliseconds: 500),
        transitionType: ContainerTransitionType.fade,
        closedBuilder: (context, action) => getBody(context, color: color),
        openBuilder: (context, action) => MasterToListPage(
            master: productType,
            detail: Product()
              ..products_types = productType
              ..setProductsByCategoryCustomParams(context, productType),
            color: color));
  }

  Widget getBody(BuildContext context, {PaletteGenerator? color}) {
    return Container(
        width: 200,
        margin: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
            image: imgUrl == null
                ? null
                : DecorationImage(
                    image: FastCachedImageProvider(imgUrl!),
                    fit: BoxFit.contain),
            color: imgUrl == null
                ? Theme.of(context).colorScheme.primary
                : color?.darkVibrantColor?.color,
            borderRadius: const BorderRadius.all(Radius.circular(20.0))),
        child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  productType.name!,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: color?.darkVibrantColor?.titleTextColor),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "${productType.availability?.toStringAsFixed(0)} ${AppLocalizations.of(context)!.itemCount}",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: color?.darkVibrantColor?.bodyTextColor),
                ),
              ],
            )));
  }

  void init(BuildContext context) async {
    imgUrl = productType.getImageUrl(context);
    if (imgUrl == null) return;
  }
}
