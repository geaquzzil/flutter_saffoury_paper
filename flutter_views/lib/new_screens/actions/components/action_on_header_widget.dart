import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/menu_item.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/rounded_icon_button.dart';
import 'package:flutter_view_controller/providers/actions/action_viewabstract_provider.dart';
import 'package:flutter_view_controller/screens/base_shared_drawer_navigation.dart';
import 'package:flutter_view_controller/screens/header_action_icon.dart';
import 'package:provider/provider.dart';

class ActionsOnHeaderWidget extends StatelessWidget {
  ViewAbstract viewAbstract;
  bool useRoundedIcon;
  ServerActions? serverActions;
  SecoundPaneHelperWithParentValueNotifier? base;

  bool removeSharedWithFabs;
  ActionsOnHeaderWidget({
    super.key,
    required this.viewAbstract,
    this.serverActions,
    this.base,
    this.useRoundedIcon = false,
    this.removeSharedWithFabs = true,
  });

  @override
  Widget build(BuildContext context) {
    serverActions ??= context
        .watch<ActionViewAbstractProvider>()
        .getServerActions;
    // final viewAbstract = context.watch<ActionViewAbstractProvider>().getObject;
    List<MenuItemBuild> menuItems = serverActions == ServerActions.view
        ? viewAbstract.getPopupMenuActionsView(context)
        : viewAbstract.getPopupMenuActionsEdit(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (useRoundedIcon)
          ...menuItems.map((e) => buildMenuItemRounded(context, e))
        else
          ...menuItems.map(buildMenuItem),
      ],
    );
  }

  Widget buildMenuItemRounded(BuildContext context, MenuItemBuild m) =>
      RoundedIconButton(
        onTap: () => viewAbstract.onPopupMenuActionSelected(
          context,
          m,
          secPaneHelper: base,
        ),
        icon: m.icon,
      );
  Widget buildMenuItem(MenuItemBuild menuItemBuild) => HeaderIconBuilder(
    base:base,
    viewAbstract: viewAbstract,
    menuItemBuild: menuItemBuild,
  );
}
