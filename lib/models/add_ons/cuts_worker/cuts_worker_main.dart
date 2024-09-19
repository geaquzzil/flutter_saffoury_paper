import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_saffoury_paper/models/add_ons/cuts_worker/cut_request_list_card.dart';
import 'package:flutter_saffoury_paper/models/invoices/cuts_invoices/cut_requests.dart';
import 'package:flutter_saffoury_paper/models/invoices/cuts_invoices/sizes_cut_requests.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/extensions.dart';
import 'package:flutter_view_controller/models/auto_rest.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_base.dart';
import 'package:flutter_view_controller/new_components/cards/outline_card.dart';
import 'package:flutter_view_controller/new_components/lists/list_card_item.dart';
import 'package:flutter_view_controller/new_components/today_text.dart';
import 'package:flutter_view_controller/new_screens/base_page.dart';
import 'package:flutter_view_controller/new_screens/lists/components/search_componenets_editable.dart';
import 'package:flutter_view_controller/new_screens/lists/list_static_widget.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_auto_rest_new.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_view_abstract_new.dart';
import 'package:flutter_view_controller/screens/base_shared_drawer_navigation.dart';

import 'package:flutter_gen/gen_l10n/app_localization.dart';

class CutRequestWorker extends CutRequest {
  CutRequestWorker();
  @override
  Map<ServerActions, List<String>>? canGetObjectWithoutApiCheckerList() => {
        ServerActions.edit: ["cut_request_results", "sizes_cut_requests"],
        ServerActions.view: ["cut_request_results", "sizes_cut_requests"],
        ServerActions.list: ["cut_request_results", "sizes_cut_requests"],
        ServerActions.search: ["cut_request_results", "sizes_cut_requests"],
      };
}

class CutWorkerPage extends StatefulWidget {
  const CutWorkerPage({super.key});

  @override
  State<CutWorkerPage> createState() => _CutWorkerPageState();
}

class _CutWorkerPageState extends BasePageState<CutWorkerPage>
    with BasePageWithTicker {
  String? _searchQuery;

  @override
  Widget? getAppbarTitle(
      {bool? firstPane,
      TabControllerHelper? tab,
      TabControllerHelper? secoundTab}) {
    if (firstPane == null) {
      return ListTile(
        leading: TodayTextTicker(
          requireTime: true,
        ),
        title: Card(
          child: SearchWidgetComponentEditable(
            initialSearch: _searchQuery,
            trailingIsCart: false,
            notiferSearchVoid: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
        ),
      );
    }
    return null;
  }

  @override
  bool reverseCustomPane() {
    return true;
  }

  Widget getPrimaryText(String text, {withPadding = true}) {
    Widget t = Text(
      //TODO translate
      text,
      style: Theme.of(context)
          .textTheme
          .bodyLarge!
          .copyWith(color: Theme.of(context).colorScheme.secondary),
    );
    if (withPadding) {
      return t.padding();
    }
    return t;
  }

  @override
  getTickerPaneWidget(bool isDesktop,
      {required bool firstPane,
      TabControllerHelper? tab,
      TabControllerHelper? secoundTab}) {
    if (firstPane) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          getPrimaryText(
              "PENDING CUT REQUEST\n SCAN WITH Code Scanner to begin progress "),
          Expanded(
            child: SliverApiMixinViewAbstractWidget(
              isGridView: false,
              scrollDirection: Axis.vertical,
              enableSelection: false,
              // hasCustomSeperater: Divider(),
              isSliver: false,
              searchString: _searchQuery,
              hasCustomCardBuilder: (index, item) {
                CutRequest cutRequest = item as CutRequest;
                return CutRequestListCard(
                  item: cutRequest,
                );
              },
              toListObject: CutRequestWorker()
                ..setCustomMapOnListAndSearch({"<cut_status>": "PENDING"}),
            ),
          ),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getPrimaryText("ON PROGRESS"),
        Expanded(
          child: Card(
            child: SliverApiMixinViewAbstractWidget(
              searchString: _searchQuery,
              isSliver: false,
              scrollDirection: Axis.vertical,
              toListObject: CutRequestWorker()
                ..setCustomMapOnListAndSearch({"<cut_status>": "PROCESSING"}),
            ),
          ),
        ),
        getPrimaryText("COMPLETED WITH IN A WEEK"),
        Expanded(
          child: SliverApiMixinViewAbstractWidget(
            searchString: _searchQuery,
            isSliver: false,
            scrollDirection: Axis.vertical,
            toListObject: CutRequestWorker()
              ..setCustomMapOnListAndSearch({"<cut_status>": "COMPLETED"}),
          ),
        ),
      ],
    );
  }

  @override
  ValueNotifierPane getTickerPane() => ValueNotifierPane.BOTH;

  @override
  int getTickerSecond() => 1000;

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
  Widget? getFloatingActionButton(
      {bool? firstPane,
      TabControllerHelper? tab,
      TabControllerHelper? secoundTab}) {
    return null;
  }
}
