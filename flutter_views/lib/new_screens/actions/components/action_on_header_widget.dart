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
  ActionsOnHeaderWidget(
      {super.key, required this.viewAbstract, this.serverActions});

  @override
  Widget build(BuildContext context) {
    serverActions ??=
        context.watch<ActionViewAbstractProvider>().getServerActions;
    // final viewAbstract = context.watch<ActionViewAbstractProvider>().getObject;

    return FutureBuilder(
        future: serverActions == ServerActions.view
            ? viewAbstract.getPopupMenuActionsView(context)
            : viewAbstract.getPopupMenuActionsEdit(context),
        builder: (BuildContext context,
            AsyncSnapshot<List<MenuItemBuild>> snapshot) {
          debugPrint("shared header build List ${snapshot.data}");
          if (snapshot.hasData) {
            return Row(
              children: [...?snapshot.data?.map(buildMenuItem).toList()],
            );
          }
          return const Icon(Icons.error);
        });
  }

  Widget buildMenuItem(MenuItemBuild menuItemBuild) => HeaderIconBuilder(
        viewAbstract: viewAbstract,
        menuItemBuild: menuItemBuild,
      );
}
