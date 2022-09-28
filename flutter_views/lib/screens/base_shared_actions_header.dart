import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/menu_item.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/providers/actions/action_viewabstract_provider.dart';
import 'package:flutter_view_controller/screens/header_action_icon.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:provider/provider.dart';

class BaseSharedHeaderViewDetailsActions extends StatelessWidget {
  TabController tabController;
  List<Tab> tabs;
  BaseSharedHeaderViewDetailsActions(
      {Key? key, required this.tabController, required this.tabs})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: SafeArea(
        child: Row(
          children: [
            // We need this back button on mobile only
            if (SizeConfig.isMobile(context)) const BackButton(),
            // Expanded(
            //   child: TabBar(
            //     labelColor: Colors.black87,
            //     tabs: tabs,
            //     controller: tabController,
            //   ),
            // ),
            const Spacer(),
            // We don't need print option on mobile
            buildList(context),
            IconButton(
              icon: const Icon(Icons.more_horiz),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem(MenuItemBuild menuItemBuild) => HeaderIconBuilder(
        menuItemBuild: menuItemBuild,
      );

  Widget buildList(BuildContext context) {
    final action = context.watch<ActionViewAbstractProvider>().getServerActions;
    final viewAbstract = context.watch<ActionViewAbstractProvider>().getObject;
    return FutureBuilder(
        future: action == ServerActions.view
            ? viewAbstract?.getPopupMenuActionsView(context)
            : viewAbstract?.getPopupMenuActionsEdit(context),
        builder: (BuildContext context,
            AsyncSnapshot<List<MenuItemBuild>> snapshot) {
          if (snapshot.hasData) {
            return Row(
              children: [...?snapshot.data?.map(buildMenuItem).toList()],
            );
            // return ListView.builder(

            //     shrinkWrap: true,
            //     itemCount: snapshot.data?.length,
            //     itemBuilder: (context, index) => HeaderIconBuilder(
            //           menuItemBuild: snapshot.data?[index] ??
            //               MenuItemBuild("", Icons.abc, ""),
            //         ));
          }
          return const Text("");
        });

    return const Text("");
  }
}
