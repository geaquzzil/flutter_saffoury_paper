import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/add_ons/cuts_worker/cut_request_list_card.dart';
import 'package:flutter_saffoury_paper/models/invoices/cuts_invoices/cut_requests.dart';
import 'package:flutter_view_controller/extensions.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract_base.dart';
import 'package:flutter_view_controller/new_components/today_text.dart';
import 'package:flutter_view_controller/new_screens/base_page.dart';
import 'package:flutter_view_controller/new_screens/lists/components/search_componenets_editable.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_view_abstract_new.dart';

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

class CutWorkerPage extends BasePage {
  CutWorkerPage({super.key});

  @override
  State<CutWorkerPage> createState() => _CutWorkerPageState();
}

class _CutWorkerPageState extends BasePageState<CutWorkerPage> {
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
  Future<void>? getPaneIsRefreshIndicator({required bool firstPane}) {
    return null;
  }

  @override
  bool reverseCustomPane() {
    return true;
  }

  Widget getPrimaryText(String text, {withPadding = true}) {
    Widget t = Text(
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
  bool isPaneScaffoldOverlayColord(bool firstPane) => false;

  @override
  bool setHorizontalDividerWhenTowPanes() => false;

  @override
  bool setMainPageSuggestionPadding() => false;

  @override
  bool setPaneBodyPaddingHorizontal(bool firstPane) => false;

  @override
  bool setClipRect(bool? firstPane) => false;

  @override
  Widget? getFloatingActionButton(
      {bool? firstPane,
      TabControllerHelper? tab,
      TabControllerHelper? secoundTab}) {
    return null;
  }

  @override
  Widget? getPaneDraggableExpandedHeader(
      {required bool firstPane, TabControllerHelper? tab}) {
    return null;
  }

  @override
  Widget? getPaneDraggableHeader(
      {required bool firstPane, TabControllerHelper? tab}) {
    return null;
  }

  @override
  List<Widget>? getPane(
      {required bool firstPane,
      ScrollController? controler,
      TabControllerHelper? tab}) {
    if (firstPane) {
      return [
        SliverToBoxAdapter(
          child: getPrimaryText(
              "PENDING CUT REQUEST\n SCAN WITH Code Scanner to begin progress "),
        ),
        SliverApiMixinViewAbstractWidget(
          isGridView: false,
          scrollDirection: Axis.vertical,
          enableSelection: false,
          // hasCustomSeperater: Divider(),
          isSliver: true,
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
      ];
    }
    return [
      SliverFillRemaining(
        child: Column(
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
                    ..setCustomMapOnListAndSearch(
                        {"<cut_status>": "PROCESSING"}),
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
        ),
      )
    ];
  }
}
