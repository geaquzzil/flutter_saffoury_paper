import 'package:flutter/material.dart';
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
  Map<ServerActions, List<String>>? isRequiredObjectsList() => {
        ServerActions.edit: ["cut_request_results", "sizes_cut_requests"],
        ServerActions.view: ["cut_request_results", "sizes_cut_requests"],
        ServerActions.list: ["cut_request_results", "sizes_cut_requests"],
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
        notiferSearchVoid: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
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

  Widget getPrimaryText(String text) {
    return Text(
      //TODO translate
      text,
      style: Theme.of(context)
          .textTheme
          .bodyLarge!
          .copyWith(color: Theme.of(context).colorScheme.secondary),
    ).padding();
  }

  @override
  getTickerFirstPane(bool isDesktop,
      {TabControllerHelper? tab, TabControllerHelper? secoundTab}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getPrimaryText(
            "PENDING CUT REQUEST\n SCAN WITH Code Scanner to begin progress "),
        Expanded(
          child: SliverApiMixinViewAbstractWidget(
            isGridView: false,
            scrollDirection: Axis.vertical,
            isSliver: false,
            searchString: _searchQuery,
            hasCustomCardBuilder: (item) {
              return ListTile(
                // trailing: item.getCount,
                leading: ClipRRect(
                    child: Padding(
                        padding: const EdgeInsets.all(kDefaultPadding),
                        child: SizedBox(
                            height: 200,
                            width: 200,
                            child: item.getCachedImage(context)))),
                title: item.getWebListTileItemTitle(context),
                subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      item.getWebListTileItemSubtitle(context)!,
                      getPrimaryText(AppLocalizations.of(context)!.details),
                      ...item
                          .getListableInterface()
                          .getListableList()
                          .map((toElement) => OutlinedCard(
                                child: ListTile(
                                  // selected: isSelected,
                                  // selectedTileColor: Theme.of(context).colorScheme.onSecondary,
                                  // onTap: onTap,
                                  // onLongPress: onLongTap,
                                  title: (toElement
                                      .getWebListTileItemSubtitle(context)),
                                  subtitle: Column(
                                    children: [
                                      (toElement
                                          .getWebListTileItemTitle(context))!,
                                      Text(
                                        (toElement as SizesCutRequest)
                                            .quantity
                                            .toCurrencyFormat(),
                                      ),
                                    ],
                                  ),

                                  // leading: toElement.getWebListTileItemLeading(context),
                                  // trailing: object.getCardTrailing(context)
                                ),
                              ))
                          .toList()
                      // ListStaticWidget<ViewAbstract>(
                      //     list: item!.getListableInterface().getListableList(),
                      //     emptyWidget: const Text("null"),
                      //     listItembuilder: (item) => ListCardItemWeb(
                      //           object: item,
                      //         )),
                    ]),
              );
            },
            toListObject: CutRequestWorker()
              ..setCustomMap({"<cut_status>": "PENDING"}),
          ),
        ),
      ],
    );
  }

  @override
  getTickerSecondPane(bool isDesktop,
      {TabControllerHelper? tab, TabControllerHelper? secoundTab}) {
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
                ..setCustomMap({"<cut_status>": "PROCESSING"}),
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
              ..setCustomMap({"<cut_status>": "COMPLETED"}),
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
  Future getCallApiFunctionIfNull(BuildContext context,
      {TabControllerHelper? tab}) {
    // TODO: implement getCallApiFunctionIfNull
    throw UnimplementedError();
  }

  @override
  ServerActions getServerActions() => ServerActions.list;
}
