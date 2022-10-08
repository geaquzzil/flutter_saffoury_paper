import 'package:flutter/material.dart';
import 'package:flutter_view_controller/new_screens/cart/cart_description/cart_description.dart';
import 'package:flutter_view_controller/new_screens/cart/cart_list.dart';
import 'package:flutter_view_controller/providers/cart/cart_provider.dart';
import 'package:provider/provider.dart';

import '../../providers/drawer/drawer_controler.dart';

class BaseHomeCartPage extends StatefulWidget {
  const BaseHomeCartPage({Key? key}) : super(key: key);

  @override
  State<BaseHomeCartPage> createState() => _BaseHomeCartPageState();
}

class _BaseHomeCartPageState extends State<BaseHomeCartPage> {
  @override
  Widget build(BuildContext context) {
    Widget? checkoutWidget = context.watch<CartProvider>().getCheckoutWidget;
    return Drawer(
      width: MediaQuery.of(context).size.width * 90,
      child: Expanded(
        child: Row(children: [
          Expanded(
              flex: 3,
              child: Container(
                color: Colors.white,
                child: checkoutWidget ?? const CartList(),
              )),
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.grey.shade100,
              child: SubRowCartDescription(),
            ),
          ),
        ]),
      ),
    );
  }
}
