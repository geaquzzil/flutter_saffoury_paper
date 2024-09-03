import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract_base.dart';
import 'package:flutter_view_controller/new_screens/base_page.dart';
import 'package:flutter_view_controller/screens/base_shared_drawer_navigation.dart';

class CutWorkerPage extends StatefulWidget {
  const CutWorkerPage({super.key});

  @override
  State<CutWorkerPage> createState() => _CutWorkerPageState();
}

class _CutWorkerPageState extends BasePageState<CutWorkerPage>
    with BasePageWithTicker {
  @override
  Widget? getBaseAppbar() => null;

  @override
  List<Widget>? getBaseBottomSheet() => null;

  @override
  Widget? getBaseFloatingActionButton() => null;

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
  getTickerFirstPane(bool isDesktop,
      {TabControllerHelper? tab, TabControllerHelper? secoundTab}) {
    return Center(
      child: Text(DateTime.now().toString()),
    );
  }

  @override
  getTickerSecondPane(bool isDesktop,
      {TabControllerHelper? tab, TabControllerHelper? secoundTab}) {
    return Center(
      child: Text(DateTime.now().toString()),
    );
  }

  @override
  ValueNotifierPane getTickerPane() => ValueNotifierPane.BOTH;

  @override
  int getTickerSecond() => 1;

  @override
  bool isPaneScaffoldOverlayColord(bool firstPane,
          {TabControllerHelper? tab}) =>
      false;

  @override
  bool isPanesIsSliver(bool firstPane, {TabControllerHelper? tab}) => false;

  @override
  bool setHorizontalDividerWhenTowPanes() => false;

  @override
  bool setMainPageSuggestionPadding() => false;

  @override
  bool setPaneBodyPadding(bool firstPane, {TabControllerHelper? tab}) => false;

  @override
  bool setPaneClipRect(bool firstPane, {TabControllerHelper? tab}) => false;
}
