import 'package:flutter/material.dart';
import 'package:flutter_view_controller/components/title_text.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/new_screens/cart/cart_description/cart_summary_item.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_controler.dart';
import 'package:provider/provider.dart';

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
                  context
                      .read<DrawerMenuControllerProvider>()
                      .controlEndDrawerMenu();
                }),
          ),
          const TitleText(
            text: "Summary",
            fontSize: 27,
            fontWeight: FontWeight.w700,
          ),
          CartSummaryItem(title: "SubTitle", description: r"252.00 $"),
          const SizedBox(
            height: kDefaultPadding / 2,
          ),
          CartSummaryItem(title: "Shipping", description: r"0.00 $"),
          const SizedBox(
            height: kDefaultPadding / 2,
          ),
          CartSummaryItem(title: "Tax", description: r"39.30 $"),
          const SizedBox(
            height: kDefaultPadding / 2,
          ),
          const SizedBox(
            height: kDefaultPadding,
          ),
          CartSummaryItem(title: "Promocode", description: r"Enter code"),
          const Spacer(),
          CartSummaryItem(title: "Total", description: r"250 $", fontSize: 18),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: kDefaultPadding, vertical: kDefaultPadding),
            width: double.maxFinite,
            child: ElevatedButton(
                onPressed: () {},
                child: const Padding(
                  padding: EdgeInsets.all(kDefaultPadding),
                  child: Text("CHECKOUT"),
                )),
          )
        ],
      ),
    );
  }
}
