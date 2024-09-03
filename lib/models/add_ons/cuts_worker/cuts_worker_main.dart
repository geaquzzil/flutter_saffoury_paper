import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/invoices/cuts_invoices/cut_requests.dart';
import 'package:flutter_view_controller/models/auto_rest.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract_base.dart';
import 'package:flutter_view_controller/new_screens/base_page.dart';
import 'package:flutter_view_controller/new_screens/lists/components/search_componenets_editable.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_auto_rest_new.dart';
import 'package:flutter_view_controller/screens/base_shared_drawer_navigation.dart';

class CutWorkerPage extends StatefulWidget {
  const CutWorkerPage({super.key});

  @override
  State<CutWorkerPage> createState() => _CutWorkerPageState();
}

class _CutWorkerPageState extends BasePageState<CutWorkerPage>
    with BasePageWithTicker {
  @override
  List<TabControllerHelper>? initTabBarList(
      {bool? firstPane, TabControllerHelper? tab}) {
    // if (firstPane == true) {
    //   return [
    //     TabControllerHelper(
    //        'Tab 1',
    //       icon: const Icon(Icons.home),
    //       extras: ,
    //     ),
    //     TabControllerHelper(
    //       title: 'Tab 2',
    //       icon: const Icon(Icons.add),
    //       selectedIcon: const Icon(Icons.add_circle),
    //     ),
    //   ];
    // }
    return null;
  }

  @override
  Widget? getBaseAppbar() => SearchWidgetComponentEditable(
        trailingIsCart: false,
        notiferSearchVoid: (value) {},
      );

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
  bool reverseCustomPane() {
    return true;
  }

  @override
  getTickerFirstPane(bool isDesktop,
      {TabControllerHelper? tab, TabControllerHelper? secoundTab}) {
    return SliverApiMixinAutoRestWidget(
      isSliver: false,
      autoRest: AutoRest<CutRequest>(
          obj: CutRequest()..setCustomMap({"<cut_status>": "PENDING"}),
          key: "CutRequest<Pending>"),
    );
  }

  @override
  getTickerSecondPane(bool isDesktop,
      {TabControllerHelper? tab, TabControllerHelper? secoundTab}) {
    return Card(
      child: Center(
        child: Text(DateTime.now().toString()),
      ),
    );
  }

  @override
  ValueNotifierPane getTickerPane() => ValueNotifierPane.BOTH;

  @override
  int getTickerSecond() => 10;

  @override
  bool isPaneScaffoldOverlayColord(bool firstPane,
          {TabControllerHelper? tab}) =>
      false;

  @override
  bool setHorizontalDividerWhenTowPanes() => false;

  @override
  bool setMainPageSuggestionPadding() => false;

  @override
  bool setPaneBodyPadding(bool firstPane, {TabControllerHelper? tab}) => false;

  @override
  bool setPaneClipRect(bool firstPane, {TabControllerHelper? tab}) => false;

  @override
  Future getCallApiFunctionIfNull(BuildContext context,
      {TabControllerHelper? tab}) {
    // TODO: implement getCallApiFunctionIfNull
    throw UnimplementedError();
  }

  @override
  ServerActions getServerActions() => ServerActions.list;
}
