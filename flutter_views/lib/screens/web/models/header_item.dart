import 'package:flutter/material.dart';
import 'package:flutter_view_controller/screens/web/our_products.dart';
import 'package:flutter_view_controller/new_screens/sign_in.dart';

class HeaderItem {
  final String title;
  final bool isButton;
  final IconData iconData;
  final IconData? iconDataSelected;
  final Function()? onClick;

  HeaderItem({
    required this.title,
    required this.iconData,
    this.iconDataSelected,
    this.onClick,
    this.isButton = false,
  });
  Widget getIcon() {
    return Icon(iconData);
  }

  Widget getSelectedIcon() {
    return Icon(iconDataSelected ?? iconData);
  }

  void onHeaderItemClick(BuildContext context) {
    if (title == "OUR PRODUCTS") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProductWebPage()),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SignInPage(),
      ),
    );
  }
}
