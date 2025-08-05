import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/menu_item.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/screens/base_shared_drawer_navigation.dart';

class HeaderIconBuilder extends StatelessWidget {
  final MenuItemBuild menuItemBuild;
  final ViewAbstract viewAbstract;
  final SecoundPaneHelperWithParentValueNotifier? base;
  const HeaderIconBuilder({
    super.key,
    required this.viewAbstract,
    required this.menuItemBuild,
    this.base,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      mouseCursor: SystemMouseCursors.click,
      tooltip: menuItemBuild.title,
      icon: Icon(menuItemBuild.icon),
      onPressed: () => viewAbstract.onPopupMenuActionSelected(
        context,
        menuItemBuild,
        secPaneHelper: base,
      ),
    );
  }
}
