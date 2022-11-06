import 'package:flutter/material.dart';
import 'package:flutter_view_controller/interfaces/cartable_interface.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/home/components/empty_widget.dart';
import 'package:flutter_view_controller/new_screens/pos/pos_cart_item.dart';
import 'package:flutter_view_controller/providers/cart/cart_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class POSCartList extends StatelessWidget {
  const POSCartList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CartProvider cart = context.watch<CartProvider>();
    List<CartableInvoiceDetailsInterface> list = cart.getList;
    if (list.isEmpty) {
      return EmptyWidget(
          lottiUrl:
              "https://assets7.lottiefiles.com/packages/lf20_0s6tfbuc.json",
          title: AppLocalizations.of(context)!.noItems,
          subtitle: AppLocalizations.of(context)!.startAddingToCartHint);
    }
    return ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) =>
            POSListCardItem<ViewAbstract>(object: list[index] as ViewAbstract));
  }
}
