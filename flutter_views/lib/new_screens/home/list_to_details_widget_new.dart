import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_base.dart';
import 'package:flutter_view_controller/new_components/tow_pane_ext.dart';
import 'package:flutter_view_controller/new_screens/actions/view/base_home_details_view.dart';
import 'package:flutter_view_controller/new_screens/base_page.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_api_master.dart';
import 'package:flutter_view_controller/screens/web/views/web_product_view.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:flutter/material.dart';

class ListToDetailsPageNew extends StatefulWidget {
  final String title;
  bool buildDrawer;

  ListToDetailsPageNew(
      {super.key, required this.title, this.buildDrawer = true});

  @override
  State<ListToDetailsPageNew> createState() => _ListToDetailsPageNewState();
}

class _ListToDetailsPageNewState extends BasePageState<ListToDetailsPageNew> {
  ValueNotifier<ViewAbstract?> dsada = ValueNotifier<ViewAbstract?>(null);

  @override
  void initState() {
    buildDrawer = widget.buildDrawer;
    super.initState();
  }

  @override
  Widget? getBaseAppbar() => null;

  @override
  Widget? getBaseBottomSheet() => null;

  @override
  Widget? getBaseFloatingActionButton() => null;

  @override
  getDesktopFirstPane({TabControllerHelper? tab}) => getFirstPane(tab: tab);

  @override
  getDesktopSecondPane(
          {TabControllerHelper? tab, TabControllerHelper? secoundTab}) =>
      getSecoundPane(tab: tab, secoundTab: secoundTab);

  @override
  getFirstPane({TabControllerHelper? tab}) {
    return SliverApiMaster(
      onSelectedCardChangeValueNotifier: dsada,
      // buildAppBar: false,
      buildSearchWidgetAsEditText: isDesktop(context),
    );
  }

  @override
  getSecoundPane({TabControllerHelper? tab, TabControllerHelper? secoundTab}) {
    return ValueListenableBuilder(
      valueListenable: dsada,
      builder: (context, value, child) {
        if (value == null) {
          return Text("NULL");
        }
        return WebProductView(
          onHorizontalItemClick: dsada,
          iD: int.parse(value.getIDString()),
          buildFooter: false,
          usePagePadding: false,
          buildHeader: false,
          tableName: value.getTableNameApi()!,
          extras: value,
        );
      },
    );
  }

  @override
  Widget? getFirstPaneAppbar({TabControllerHelper? tab}) => null;

  @override
  Widget? getFirstPaneBottomSheet({TabControllerHelper? tab}) => null;
  @override
  Widget? getFirstPaneFloatingActionButton({TabControllerHelper? tab}) => null;

  @override
  Widget? getSecondPaneAppbar({TabControllerHelper? tab}) => null;

  @override
  Widget? getSecondPaneBottomSheet({TabControllerHelper? tab}) => null;
  @override
  Widget? getSecondPaneFloatingActionButton({TabControllerHelper? tab}) => null;

  @override
  bool isPaneScaffoldOverlayColord(bool firstPane,
          {TabControllerHelper? tab}) =>
      false;

  @override
  bool isPanesIsSliver(bool firstPane, {TabControllerHelper? tab}) => false;

  @override
  bool setBodyPadding(bool firstPane, {TabControllerHelper? tab}) => !firstPane;

  @override
  bool setPaddingWhenTowPane(CurrentScreenSize currentScreenSize,
          {TabControllerHelper? tab}) =>
      false;

  @override
  bool setPaneClipRect(bool firstPane, {TabControllerHelper? tab}) => true;
}
