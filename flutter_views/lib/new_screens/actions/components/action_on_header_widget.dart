import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_view_controller/models/menu_item.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/providers/actions/action_viewabstract_provider.dart';
import 'package:flutter_view_controller/screens/header_action_icon.dart';
import 'package:provider/provider.dart';

class ActionsOnHeaderWidget extends StatelessWidget {
  ViewAbstract viewAbstract;
  ServerActions? serverActions;
  bool removeSharedWithFabs;
  ActionsOnHeaderWidget(
      {super.key,
      required this.viewAbstract,
      this.serverActions,
      this.removeSharedWithFabs = true});

  @override
  Widget build(BuildContext context) {
    serverActions ??=
        context.watch<ActionViewAbstractProvider>().getServerActions;
    // final viewAbstract = context.watch<ActionViewAbstractProvider>().getObject;
    List<MenuItemBuild> menuItems = serverActions == ServerActions.view
        ? viewAbstract.getPopupMenuActionsView(context)
        : viewAbstract.getPopupMenuActionsEdit(context);
    return Row(
      children: [...menuItems.map(buildMenuItem)],
    );
  }

  Widget buildMenuItem(MenuItemBuild menuItemBuild) => HeaderIconBuilder(
        viewAbstract: viewAbstract,
        menuItemBuild: menuItemBuild,
      );
}
