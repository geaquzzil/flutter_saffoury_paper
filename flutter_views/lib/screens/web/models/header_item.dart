import 'package:flutter/material.dart';
import 'package:flutter_view_controller/screens/web/our_products.dart';
import 'package:flutter_view_controller/new_screens/sign_in.dart';

class HeaderItem {
  final String title;
  final bool isButton;
  final Function()? onClick;

  HeaderItem({
    required this.title,
    this.onClick,
    this.isButton = false,
  });

  void onHeaderItemClick(BuildContext context) {
    if (title == "OUR PRODUCTS") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>  ProductWebPage()),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>  SignInPage(),
      ),
    );
  }
}
