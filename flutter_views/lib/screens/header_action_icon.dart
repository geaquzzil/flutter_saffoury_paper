import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/menu_item.dart';
import 'package:flutter_view_controller/providers/actions/action_view_abstract_provider.dart';
import 'package:provider/provider.dart';

class HeaderIconBuilder extends StatelessWidget {
  MenuItemBuild menuItemBuild;
  HeaderIconBuilder({Key? key, required this.menuItemBuild}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewAbstract = context.read<ActionViewAbstractProvider>().getObject;
    return IconButton(
      mouseCursor: SystemMouseCursors.click,
      tooltip: menuItemBuild.title,
      hoverColor: Colors.green,
      icon: Icon(menuItemBuild.icon),
      onPressed: () =>
          viewAbstract?.onMenuItemActionClickedView(context, menuItemBuild),
    );
  }
}
