import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract_base.dart';
import 'package:flutter_view_controller/new_components/tow_pane_ext.dart';
import 'package:flutter_view_controller/new_screens/actions/view/base_home_details_view.dart';
import 'package:flutter_view_controller/new_screens/base_page.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_api_master.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:flutter/material.dart';

class ListToDetailsPage extends StatefulWidget {
  final String title;

  const ListToDetailsPage({
    super.key,
    required this.title,
  });

  @override
  State<ListToDetailsPage> createState() => _ListToDetailsPageState();
}

class _ListToDetailsPageState extends BasePageState<ListToDetailsPage> {
  @override
  List<TabControllerHelper>? initTabBarList() {
    // TODO: implement initTabBarList
    return super.initTabBarList();
  }

  @override
  Widget? getBaseAppbar() => null;

  @override
  List<Widget>? getBaseBottomSheet() => null;

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
    return SliverApiMaster();
  }

  @override
  getSecoundPane({TabControllerHelper? tab, TabControllerHelper? secoundTab}) {
    return BaseSharedDetailsView();
  }

  @override
  Widget? getFirstPaneAppbar({TabControllerHelper? tab}) => null;

  @override
  List<Widget>? getFirstPaneBottomSheet({TabControllerHelper? tab}) => null;
  @override
  Widget? getFirstPaneFloatingActionButton({TabControllerHelper? tab}) => null;

  @override
  Widget? getSecondPaneAppbar({TabControllerHelper? tab}) => null;

  @override
  List<Widget>? getSecondPaneBottomSheet({TabControllerHelper? tab}) => null;
  @override
  Widget? getSecondPaneFloatingActionButton({TabControllerHelper? tab}) => null;

  @override
  bool isPaneScaffoldOverlayColord(bool firstPane,
          {TabControllerHelper? tab}) =>
      false;

  @override
  bool isPanesIsSliver(bool firstPane, {TabControllerHelper? tab}) => false;

  @override
  bool setPaneBodyPadding(bool firstPane, {TabControllerHelper? tab}) => false;

  @override
  bool setMainPageSuggestionPadding() => false;

  @override
  bool setHorizontalDividerWhenTowPanes() => false;

  @override
  bool setPaneClipRect(bool firstPane, {TabControllerHelper? tab}) => false;
}
