import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/home/base_home_shared_with_widget.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_controler.dart';
import 'package:provider/provider.dart';

import '../lists/components/search_components.dart';

class HomeNavigationPage extends BaseHomeSharedWithWidgets {
  ViewAbstract? viewAbstract;
  late DrawerMenuControllerProvider drawerMenuControllerProvider;
  HomeNavigationPage({super.key,this.viewAbstract});

  @override
  void init(BuildContext context) {
    drawerMenuControllerProvider = context.read<DrawerMenuControllerProvider>();
    viewAbstract ??= drawerMenuControllerProvider.getObjectCastViewAbstract;
  }

  @override
  Widget? getSilverAppBarTitle(BuildContext context) {
    return viewAbstract!.getHomeHeaderWidget(context);
  }

  @override
  Widget? getSliverHeader(BuildContext context) {
    return SearchWidgetComponent(
      heroTag:"home/search",

    );
  }

  @override
  List<Widget>? getSliverAppBarActions(BuildContext context) {
    // TODO: implement getSliverAppBarActions
    return null;
  }

  @override
  List<Widget> getSliverList(BuildContext context) {
    List<StaggeredGridTile> homeList =
        viewAbstract!.getHomeHorizotalList(context);
        
    return [
      SliverToBoxAdapter(
        child: StaggeredGrid.count(
          
            crossAxisCount: 2,
            mainAxisSpacing: 2,
            crossAxisSpacing: 2,
            children: homeList),
      ),
      // SliverApiMaster(),
    ];
  }

  @override
  Widget? getEndPane(BuildContext context) {
    return null;
  }

  @override
  EdgeInsets? hasBodyPadding(BuildContext context) {
    return null;
  }

  @override
  EdgeInsets? hasMainBodyPadding(BuildContext context) {
    return null;
  }
}
