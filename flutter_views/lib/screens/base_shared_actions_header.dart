import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/models/menu_item.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/cards/filled_card.dart';
import 'package:flutter_view_controller/providers/actions/action_viewabstract_provider.dart';
import 'package:flutter_view_controller/screens/base_shared_header_description.dart';
import 'package:flutter_view_controller/screens/base_shared_header_rating.dart';
import 'package:flutter_view_controller/screens/header_action_icon.dart';
import 'package:provider/provider.dart';

import 'base_shared_drawer_navigation.dart';

class BaseSharedHeaderViewDetailsActions extends StatelessWidget {
  ViewAbstract viewAbstract;
  BaseSharedHeaderViewDetailsActions({Key? key, required this.viewAbstract})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(kDefaultPadding),
            child: Row(
              children: [
                if (context
                        .watch<ActionViewAbstractProvider>()
                        .getStackedActions
                        .length >
                    1)
                  BackButton(
                    onPressed: () {
                      context.read<ActionViewAbstractProvider>().pop();
                    },
                  ),
                Expanded(
                    child: BaseSharedHeaderDescription(
                        viewAbstract: viewAbstract)),
                // Expanded(
                //   child: TabBar(
                //     labelColor: Colors.black87,
                //     tabs: tabs,
                //     controller: tabController,
                //   ),
                // ),
                // const Spacer(),
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
        ),

        // BaseSharedHeaderDescription(viewAbstract: viewAbstract),
        // BaseSharedDetailsRating(viewAbstract: viewAbstract),
        // const BaseSharedActionDrawerNavigation()
      ],
    );
  }

  Widget buildMenuItem(MenuItemBuild menuItemBuild) => HeaderIconBuilder(
        viewAbstract: viewAbstract,
        menuItemBuild: menuItemBuild,
      );

  Widget buildList(BuildContext context) {
    final action = context.watch<ActionViewAbstractProvider>().getServerActions;
    // final viewAbstract = context.watch<ActionViewAbstractProvider>().getObject;

    return FutureBuilder(
        future: action == ServerActions.view
            ? viewAbstract.getPopupMenuActionsView(context)
            : viewAbstract.getPopupMenuActionsEdit(context),
        builder: (BuildContext context,
            AsyncSnapshot<List<MenuItemBuild>> snapshot) {
          debugPrint("shared header build List ${snapshot.data}");
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
