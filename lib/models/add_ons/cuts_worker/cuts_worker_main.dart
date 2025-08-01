import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/add_ons/cuts_worker/cut_request_list_card.dart';
import 'package:flutter_saffoury_paper/models/invoices/cuts_invoices/cut_requests.dart';
import 'package:flutter_view_controller/extensions.dart';
import 'package:flutter_view_controller/models/request_options.dart';
import 'package:flutter_view_controller/models/view_abstract_base.dart';
import 'package:flutter_view_controller/new_components/today_text.dart';
import 'package:flutter_view_controller/new_screens/base_page.dart';
import 'package:flutter_view_controller/new_screens/lists/components/search_componenets_editable.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_api_master_new.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_view_abstract_new.dart';

class CutRequestWorker extends CutRequest {
  CutRequestWorker();
}

class CutWorkerPage extends BasePage {
  CutWorkerPage({super.key});

  @override
  State<CutWorkerPage> createState() => _CutWorkerPageState();
}

class _CutWorkerPageState extends BasePageState<CutWorkerPage> {
  String? _searchQuery;

  @override
  Widget? getAppbarTitle({
    bool? firstPane,
    TabControllerHelper? tab,
    TabControllerHelper? secoundTab,
  }) {
    if (firstPane == null) {
      return ListTile(
        leading: TodayTextTicker(requireTime: true),
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
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
        color: Theme.of(context).colorScheme.secondary,
      ),
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
  Widget? getFloatingActionButton({
    bool? firstPane,
    TabControllerHelper? tab,
    TabControllerHelper? secoundTab,
  }) {
    return null;
  }

  @override
  Widget? getPaneDraggableExpandedHeader({
    required bool firstPane,
    TabControllerHelper? tab,
  }) {
    return null;
  }

  @override
  Widget? getPaneDraggableHeader({
    required bool firstPane,
    TabControllerHelper? tab,
  }) {
    return null;
  }

  @override
  List<Widget>? getPane({
    required bool firstPane,
    ScrollController? controler,
    TabControllerHelper? tab,
  }) {
    if (firstPane) {
      return [
        SliverToBoxAdapter(
          //todo translate
          child: getPrimaryText(
            "PENDING CUT REQUEST\n SCAN WITH Code Scanner to begin progress ",
          ),
        ),
        SliverApiMixinViewAbstractWidget(
          cardType: CardItemType.list,
          scrollDirection: Axis.vertical,
          enableSelection: false,
          // hasCustomSeperater: Divider(),
          isSliver: true,
          searchString: _searchQuery,
          hasCustomCardItemBuilder: (index, item) {
            CutRequest cutRequest = item as CutRequest;
            return CutRequestListCard(item: cutRequest);
          },
          toListObject: CutRequestWorker().setRequestOption(
            option: RequestOptions().addSearchByField("cut_status", "PENDING"),
          ),
        ),
      ];
    }
    return [
      SliverFillRemaining(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //todo translate
            getPrimaryText("ON PROGRESS"),
            Expanded(
              child: Card(
                child: SliverApiMixinViewAbstractWidget(
                  searchString: _searchQuery,
                  isSliver: false,
                  scrollDirection: Axis.vertical,
                  toListObject: CutRequestWorker().setRequestOption(
                    option: RequestOptions().addSearchByField(
                      "cut_status",
                      "PROCESSING",
                    ),
                  ),
                ),
              ),
            ),
            //todo translate
            getPrimaryText("COMPLETED WITH IN A WEEK"),
            Expanded(
              child: SliverApiMixinViewAbstractWidget(
                searchString: _searchQuery,
                isSliver: false,
                scrollDirection: Axis.vertical,
                toListObject: CutRequestWorker().setRequestOption(
                  option: RequestOptions().addSearchByField(
                    "cut_status",
                    "COMPLETED",
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ];
  }
}
