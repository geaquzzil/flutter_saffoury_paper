import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract_base.dart';
import 'package:flutter_view_controller/new_screens/base_page.dart';

class GoodsInventoryPage extends StatefulWidget {
  const GoodsInventoryPage({super.key});

  @override
  State<GoodsInventoryPage> createState() => _GoodsInventoryPageState();
}

class _GoodsInventoryPageState extends BasePageWithApi<GoodsInventoryPage>
    with BasePageWithTicker {
  @override
  Widget? getBaseAppbar() {
    // TODO: implement getBaseAppbar
    throw UnimplementedError();
  }

  @override
  List<Widget>? getBaseBottomSheet() {
    // TODO: implement getBaseBottomSheet
    throw UnimplementedError();
  }

  @override
  Widget? getBaseFloatingActionButton() {
    // TODO: implement getBaseFloatingActionButton
    throw UnimplementedError();
  }

  @override
  Future getCallApiFunctionIfNull(BuildContext context, {TabControllerHelper? tab}) {
    // TODO: implement getCallApiFunctionIfNull
    throw UnimplementedError();
  }

  @override
  getDesktopFirstPane({TabControllerHelper? tab}) {
    // TODO: implement getDesktopFirstPane
    throw UnimplementedError();
  }

  @override
  getDesktopSecondPane({TabControllerHelper? tab, TabControllerHelper? secoundTab}) {
    // TODO: implement getDesktopSecondPane
    throw UnimplementedError();
  }

  @override
  getFirstPane({TabControllerHelper? tab}) {
    // TODO: implement getFirstPane
    throw UnimplementedError();
  }

  @override
  Widget? getFirstPaneAppbar({TabControllerHelper? tab}) {
    // TODO: implement getFirstPaneAppbar
    throw UnimplementedError();
  }

  @override
  List<Widget>? getFirstPaneBottomSheet({TabControllerHelper? tab}) {
    // TODO: implement getFirstPaneBottomSheet
    throw UnimplementedError();
  }

  @override
  Widget? getFirstPaneFloatingActionButton({TabControllerHelper? tab}) {
    // TODO: implement getFirstPaneFloatingActionButton
    throw UnimplementedError();
  }

  @override
  Widget? getSecondPaneAppbar({TabControllerHelper? tab}) {
    // TODO: implement getSecondPaneAppbar
    throw UnimplementedError();
  }

  @override
  List<Widget>? getSecondPaneBottomSheet({TabControllerHelper? tab}) {
    // TODO: implement getSecondPaneBottomSheet
    throw UnimplementedError();
  }

  @override
  Widget? getSecondPaneFloatingActionButton({TabControllerHelper? tab}) {
    // TODO: implement getSecondPaneFloatingActionButton
    throw UnimplementedError();
  }

  @override
  getSecoundPane({TabControllerHelper? tab, TabControllerHelper? secoundTab}) {
    // TODO: implement getSecoundPane
    throw UnimplementedError();
  }

  @override
  ServerActions getServerActions() {
    // TODO: implement getServerActions
    throw UnimplementedError();
  }

  @override
  int getTickerSecond() {
    // TODO: implement getTickerSecond
    throw UnimplementedError();
  }

  @override
  bool isPaneScaffoldOverlayColord(bool firstPane, {TabControllerHelper? tab}) {
    // TODO: implement isPaneScaffoldOverlayColord
    throw UnimplementedError();
  }

  @override
  bool isPanesIsSliver(bool firstPane, {TabControllerHelper? tab}) {
    // TODO: implement isPanesIsSliver
    throw UnimplementedError();
  }

  @override
  bool setHorizontalDividerWhenTowPanes() {
    // TODO: implement setHorizontalDividerWhenTowPanes
    throw UnimplementedError();
  }

  @override
  bool setMainPageSuggestionPadding() {
    // TODO: implement setMainPageSuggestionPadding
    throw UnimplementedError();
  }

  @override
  bool setPaneBodyPadding(bool firstPane, {TabControllerHelper? tab}) {
    // TODO: implement setPaneBodyPadding
    throw UnimplementedError();
  }

  @override
  bool setPaneClipRect(bool firstPane, {TabControllerHelper? tab}) {
    // TODO: implement setPaneClipRect
    throw UnimplementedError();
  }


    }
