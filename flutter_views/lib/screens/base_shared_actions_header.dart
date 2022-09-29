import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/menu_item.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/providers/actions/action_viewabstract_provider.dart';
import 'package:flutter_view_controller/screens/base_shared_header_description.dart';
import 'package:flutter_view_controller/screens/base_shared_header_rating.dart';
import 'package:flutter_view_controller/screens/header_action_icon.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../models/permissions/permission_level_abstract.dart';
import 'base_shared_drawer_navigation.dart';

class BaseSharedHeaderViewDetailsActions extends StatelessWidget {
  ViewAbstract viewAbstract;
  BaseSharedHeaderViewDetailsActions({Key? key, required this.viewAbstract})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            // We need this back button on mobile only
            // if (SizeConfig.isMobile(context))
            const BackButton(),
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
        BaseSharedHeaderDescription(viewAbstract: viewAbstract),
        BaseSharedDetailsRating(viewAbstract: viewAbstract),
        BaseSharedActionDrawerNavigation()
      ],
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
  }
}
