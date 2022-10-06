import 'package:flutter/material.dart';
import 'package:flutter_view_controller/components/title_text.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/new_screens/cart/cart_description/cart_summary_item.dart';
import 'package:flutter_view_controller/providers/cart/cart_provider.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_controler.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class SubRowCartDescription extends StatelessWidget {
  const SubRowCartDescription({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  debugPrint("close clicked");
                  context
                      .read<DrawerMenuControllerProvider>()
                      .controlEndDrawerMenu();
                }),
          ),
          TitleText(
            text: AppLocalizations.of(context)!.no_summary,
            fontSize: 27,
            fontWeight: FontWeight.w700,
          ),
          CartSummaryItem(title: "SubTitle", description: r"252.00 $"),
          const SizedBox(
            height: kDefaultPadding / 2,
          ),
          CartSummaryItem(
              title: AppLocalizations.of(context)!.shipping,
              description: r"0.00"),
          const SizedBox(
            height: kDefaultPadding / 2,
          ),
          CartSummaryItem(
              title: AppLocalizations.of(context)!.tax, description: r"0"),
          const SizedBox(
            height: kDefaultPadding / 2,
          ),
          const SizedBox(
            height: kDefaultPadding,
          ),
          // CartSummaryItem(title: "Promocode", description: r"Enter code"),
          const Spacer(),
          CartSummaryItem(
              title: AppLocalizations.of(context)!.total,
              description:
                  context.watch<CartProvider>().getTotalPrice.toString(),
              fontSize: 18),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: kDefaultPadding, vertical: kDefaultPadding),
            width: double.maxFinite,
            child: ElevatedButton(
                onPressed: () {},
                child: Padding(
                  padding: const EdgeInsets.all(kDefaultPadding),
                  child: Text(AppLocalizations.of(context)!.checkout),
                )),
          )
        ],
      ),
    );
  }
}
