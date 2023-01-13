import 'package:flutter/material.dart';
import 'package:flutter_view_controller/new_components/tow_pane_ext.dart';
import 'package:flutter_view_controller/new_screens/cart/cart_description/cart_description.dart';
import 'package:flutter_view_controller/new_screens/cart/cart_list.dart';
import 'package:flutter_view_controller/providers/cart/cart_provider.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:provider/provider.dart';

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
        backgroundColor: Theme.of(context).colorScheme.surface,
        width: MediaQuery.of(context).size.width * 90,
        child: TowPaneExt(
          customPaneProportion: SizeConfig.getPaneProportion(context),
          startPane: CartList(),
          endPane: SubRowCartDescription(),
        )

        // Expanded(
        //   child: Row(children: [
        //     Expanded(
        //         flex: 3,
        //         child: Container(
        //           child: checkoutWidget ?? const CartList(),
        //         )),
        //     VerticalDivider(),
        //     Expanded(
        //       flex: 1,
        //       child: Container(
        //         child: const SubRowCartDescription(),
        //       ),
        //     ),
        //   ]),
        // ),
        );
  }
}
