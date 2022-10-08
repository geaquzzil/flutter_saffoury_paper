import 'package:flutter/material.dart';
import 'package:flutter_view_controller/new_screens/cart/cart_data_table.dart';
import 'package:flutter_view_controller/new_screens/cart/cart_data_table_master.dart';
import 'package:flutter_view_controller/new_screens/cart/cart_list_header.dart';

class CartList extends StatelessWidget {
  const CartList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios_sharp)),
          const CartListHeader(),
          const SizedBox(width: double.infinity, child: CartDataTableMaster())
        ],
      ),
    );
  }
}
