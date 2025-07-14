import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/menu_item.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';

class HeaderIconBuilder extends StatelessWidget {
  MenuItemBuild menuItemBuild;
  ViewAbstract viewAbstract;
  HeaderIconBuilder(
      {super.key, required this.viewAbstract, required this.menuItemBuild});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      mouseCursor: SystemMouseCursors.click,
      tooltip: menuItemBuild.title,
      icon: Icon(menuItemBuild.icon),
      onPressed: () =>
          viewAbstract.onMenuItemActionClickedView(context, menuItemBuild),
    );
  }
}
