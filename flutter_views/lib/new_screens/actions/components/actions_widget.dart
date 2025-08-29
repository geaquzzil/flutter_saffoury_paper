import 'package:flutter/material.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_master.dart';
import 'package:flutter_view_controller/models/menu_item.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/lists/list_card_item_master.dart';
import 'package:flutter_view_controller/new_components/rounded_icon_button.dart';
import 'package:flutter_view_controller/screens/base_shared_drawer_navigation.dart';
import 'package:flutter_view_controller/screens/header_action_icon.dart';

enum ActionType { HEADER, LIST, FLOAT, THREE_DOT }

class ActionsWidget extends StatelessWidget {
  final ViewAbstract viewAbstract;
  final ServerActions serverActions;
  final SecoundPaneHelperWithParentValueNotifier? base;
  final SecondPaneHelper? lastSecondPaneItem;
  final ActionType type;
  final bool removeSharedWithFabs;
  final List<Widget>? addOnList;
  const ActionsWidget({
    super.key,
    required this.viewAbstract,
    required this.serverActions,
    this.base,
    this.type = ActionType.HEADER,
    this.removeSharedWithFabs = true,
    this.addOnList,
    this.lastSecondPaneItem,
  });

  @override
  Widget build(BuildContext context) {
    List<MenuItemBuild> menuItems = viewAbstract.getActions(
      action: serverActions,
      context: context,
    );
    if (type == ActionType.LIST) {
      return getList(menuItems, context);
    } else if (type == ActionType.THREE_DOT) {
      return viewAbstract.getPopupMenuActionWidget(
        context,
        serverActions,
        secPaneHelper: base,
      );
    } else {
      return getRow(menuItems, context);
    }
  }

  Row getRow(List<MenuItemBuild> menuItems, BuildContext context) {
    return Row(
      mainAxisAlignment: type == ActionType.HEADER
          ? MainAxisAlignment.spaceEvenly
          : MainAxisAlignment.end,
      children: [
        if (type == ActionType.HEADER)
          ...menuItems.map(
            (e) => viewAbstract.buildIconItem(context, e, secPaneHelper: base),
          )
        else if (type == ActionType.LIST)
          ...menuItems.map(
            (e) => viewAbstract.buildListActionItem(
              context,
              e,
              secPaneHelper: base,
              lastSecondPaneItem: lastSecondPaneItem,
            ),
          )
        else
          ...menuItems.map(
            (e) => viewAbstract.buildFloatItem(context, e, secPaneHelper: base),
          ),
        if (addOnList != null) ...addOnList!,
      ],
    );
  }

  SliverList getList(List<MenuItemBuild> menuItems, BuildContext context) {
    return SliverList.list(
      children: menuItems
          .map(
            (e) => viewAbstract.buildListActionItem(
              context,
              e,
              lastSecondPaneItem: lastSecondPaneItem,
              secPaneHelper: base,
            ),
          )
          .toList(),
    );
  }
}
