import 'package:flutter/material.dart';
import 'package:flutter_view_controller/components/title_text.dart';
import 'package:flutter_view_controller/providers/cart/cart_provider.dart';
import 'package:provider/provider.dart';

class CartListHeader extends StatelessWidget {
  const CartListHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Row(children: [
        TitleText(
          text: 'Shopping',
          fontSize: 27,
          fontWeight: FontWeight.w400,
        ),
        TitleText(
          text: 'Cart',
          fontSize: 27,
          fontWeight: FontWeight.w700,
        ),
        Spacer(),
        TitleText(
          text: context.watch<CartProvider>().getCount.toString(),
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        TitleText(
          text: 'Items',
          fontSize: 20,
          fontWeight: FontWeight.w400,
        ),
      ]),
    );
  }
}
