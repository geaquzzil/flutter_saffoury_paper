import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_view_controller/models/menu_item.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/providers/actions/action_viewabstract_provider.dart';
import 'package:provider/provider.dart';

class ActionsOnHeaderPopupWidget extends StatelessWidget {
  ViewAbstract viewAbstract;
  ServerActions? serverActions;
  ActionsOnHeaderPopupWidget(
      {super.key, required this.viewAbstract, this.serverActions});

  @override
  Widget build(BuildContext context) {
    serverActions ??=
        context.watch<ActionViewAbstractProvider>().getServerActions;
    return viewAbstract.onFutureBuilder<List<MenuItemBuildGenirc>>(
      context,
      function:
          viewAbstract.getPopupMenuActionsThreeDot(context, serverActions),
      onHasPermissionWidget: (data) {
        return PopupMenuButton<MenuItemBuildGenirc>(
          onSelected: (MenuItemBuildGenirc result) {
            Navigator.pushNamed(context, result.route, arguments: result.value);
            // viewAbstract.onPopupMenuActionSelected(c, result);
          },
          itemBuilder: (BuildContext context) =>
              data.map(buildPopupMenuItem).toList(),
        );
      },
    );
  }

  PopupMenuItem<MenuItemBuildGenirc> buildPopupMenuItem(
          MenuItemBuildGenirc e) =>
      PopupMenuItem(
        value: e,
        child: Row(
          children: [
            Icon(
              e.icon,
              // color: Colors.black,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(e.title),
          ],
        ),
      );
}
