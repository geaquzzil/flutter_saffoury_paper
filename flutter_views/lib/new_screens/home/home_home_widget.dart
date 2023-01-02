import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/tow_pane_ext.dart';
import 'package:flutter_view_controller/new_screens/actions/view/base_home_details_view.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_controler.dart';
import 'package:provider/provider.dart';

import '../../providers/actions/action_viewabstract_provider.dart';

class HomeNavigationPage extends StatelessWidget {
  Widget? firstPane;
  Widget? endPane;
  ViewAbstract? viewAbstract;
  late DrawerMenuControllerProvider drawerMenuControllerProvider;
  HomeNavigationPage({super.key});

  @override
  Widget build(BuildContext context) {
    init(context);
    firstPane = getFirstPane(context);
    return TowPaneExt(
      startPane: firstPane!,
      endPane: endPane,
    );
  }

  void init(BuildContext context) {
    drawerMenuControllerProvider = context.read<DrawerMenuControllerProvider>();
    viewAbstract ??= drawerMenuControllerProvider.getObject;
  }

  FlexibleSpaceBar getSilverAppBarBackground(BuildContext context) {
    return FlexibleSpaceBar(
      stretchModes: const [StretchMode.fadeTitle],
      centerTitle: true,
      titlePadding: const EdgeInsets.only(bottom: 62),
      title: viewAbstract!.getHomeHeaderWidget(context),
    );
  }

  Widget getFirstPane(BuildContext context) {
    List<StaggeredGridTile> homeList =
        viewAbstract!.getHomeHorizotalList(context);
    return CustomScrollView(
      slivers: [
        SliverAppBar.large(
          elevation: 4,
          surfaceTintColor: Theme.of(context).colorScheme.background,
          automaticallyImplyLeading: false,
          actions: [],
          leading: SizedBox(),
          flexibleSpace: getSilverAppBarBackground(context),
        ),
        SliverToBoxAdapter(
          child: StaggeredGrid.count(
              crossAxisCount: 2,
              mainAxisSpacing: 2,
              crossAxisSpacing: 2,
              children: homeList),
        ),
        SliverGrid.count(
            childAspectRatio: 1,
            crossAxisCount: 2,
            mainAxisSpacing: 2,
            crossAxisSpacing: 2,
            children: homeList),
        SliverToBoxAdapter(
          child: Container(
            color: Colors.yellow,
            padding: const EdgeInsets.all(8.0),
            child: Text('Grid Header', style: TextStyle(fontSize: 24)),
          ),
        ),
        SliverGrid.count(
          crossAxisCount: 3,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
          childAspectRatio: 4.0,
          children: <Widget>[
            Container(color: Colors.red),
            Container(color: Colors.green),
            Container(color: Colors.blue),
            Container(color: Colors.red),
            Container(color: Colors.green),
            Container(color: Colors.blue),
          ],
        ),
        SliverGrid.extent(
          maxCrossAxisExtent: 2,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
          childAspectRatio: 4.0,
          children: <Widget>[
            Container(color: Colors.pink),
            Container(color: Colors.indigo),
            Container(color: Colors.orange),
            Container(color: Colors.pink),
            Container(color: Colors.indigo),
            Container(color: Colors.orange),
          ],
        ),
      ],
    );
  }
}
