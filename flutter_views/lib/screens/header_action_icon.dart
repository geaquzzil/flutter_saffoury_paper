import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/menu_item.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/providers/actions/action_viewabstract_provider.dart';
import 'package:provider/provider.dart';

class HeaderIconBuilder extends StatelessWidget {
  MenuItemBuild menuItemBuild;
  ViewAbstract viewAbstract;
  HeaderIconBuilder(
      {Key? key, required this.viewAbstract, required this.menuItemBuild})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      mouseCursor: SystemMouseCursors.click,
      tooltip: menuItemBuild.title,
      icon: Icon(menuItemBuild.icon),
      onPressed: () =>
          viewAbstract?.onMenuItemActionClickedView(context, menuItemBuild),
    );
  }
}
