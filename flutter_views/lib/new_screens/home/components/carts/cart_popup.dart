import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/new_components/lists/search_card_item.dart';
import 'package:flutter_view_controller/new_screens/home/components/empty_widget.dart';
import 'package:flutter_view_controller/new_screens/lists/list_static_widget.dart';
import 'package:flutter_view_controller/providers/cart/cart_provider.dart';
import 'package:flutter_view_controller/screens/shopping_cart_page_new.dart';
import 'package:provider/provider.dart';

class CartPopupWidget extends StatelessWidget {
  String lottie = "https://assets8.lottiefiles.com/packages/lf20_3VDN1k.json";
  CartPopupWidget({Key? key}) : super(key: key);

  final CustomPopupMenuController _controller = CustomPopupMenuController();

  @override
  Widget build(BuildContext context) {
    String title = "No New Notifications";
    String subtitle =
        "Check this section for updates exclusively offer and general notifications";
    return CustomPopupMenu(
      arrowSize: 20,
      arrowColor: Colors.white,
      menuBuilder: () => popMenuBuilder(context, title, subtitle),
      pressType: PressType.singleClick,
      verticalMargin: -15,
      controller: _controller,
      child: Icon(
        Icons.shopping_cart_checkout_outlined,
      ),
    );
  }

  Widget popMenuBuilder(BuildContext context, String title, String subtitle) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
        color: Colors.white,
        child: IntrinsicWidth(
          child: SizedBox(
            width: 400,
            height: 400,
            child: getContentWidget(context, title, subtitle),
          ),
        ),
      ),
    );
  }

  Widget getContentWidget(BuildContext context, String title, String subtitle) {
    return ShoppingCartPageNew();
    return ListStaticWidget(
        listItembuilder: (item) =>
            SearchCardItem(viewAbstract: item, searchQuery: ""),
        list: context.watch<CartProvider>().getList,
        emptyWidget:
            EmptyWidget(lottiUrl: lottie, title: title, subtitle: subtitle));
  }
}
