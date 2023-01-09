import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_view_controller/new_components/tow_pane_ext.dart';
import 'package:flutter_view_controller/new_screens/actions/view/base_home_details_view.dart';
import 'package:flutter_view_controller/new_screens/actions/view/base_home_details_view_with_camera.dart';
import 'package:flutter_view_controller/new_screens/lists/list_api_searchable_widget.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_api_master.dart';
import 'package:provider/provider.dart';

import '../../providers/drawer/drawer_controler.dart';

class ListToDetailsPage extends StatelessWidget {
  ListToDetailsPage({super.key});
  Widget? firstPane;
  Widget? endPane;
  late DrawerMenuControllerProvider drawerMenuControllerProvider;
  @override
  Widget build(BuildContext context) {
    init(context);
    firstPane = getFirstPane(context);
    endPane ??= getEndPane();
    return TowPaneExt(
      startPane: firstPane!,
      endPane: endPane,
    );
  }

  Widget getEndPane() =>
      BaseSharedDetailsView();

  void init(BuildContext context) {
    drawerMenuControllerProvider = context.read<DrawerMenuControllerProvider>();
  }

  Widget getFirstPane(BuildContext context) {
    // ListApiSearchableWidget(
    //         key: context.read<ListActionsProvider>().getListStateKey),
    return SliverApiMaster();
  }
}
