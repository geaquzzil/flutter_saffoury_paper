import 'package:flutter/material.dart';
import 'package:flutter_view_controller/new_screens/cart/cart_data_table.dart';
import 'package:flutter_view_controller/new_screens/cart/cart_list_header.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_controler.dart';
import 'package:provider/provider.dart';

class CartList extends StatelessWidget {
  const CartList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Align(
          //   alignment: AlignmentDirectional.centerStart,
          //   child: IconButton(
          //       icon: Icon(Icons.arrow_back_ios_sharp
          //       onPressed: () {
          //         context
          //             .read<DrawerMenuControllerProvider>()
          //             .controlEndDrawerMenu();
          //       }),
          // )),
          IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back_ios_sharp)),
          CartListHeader(),
          Container(width: double.infinity, child: CartDataTable())
        ],
      ),
    );
  }
}
