import 'package:flutter/material.dart';
import 'package:flutter_view_controller/customs_widget/sliver_delegates.dart';
import 'package:flutter_view_controller/models/request_options.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_base.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:flutter_view_controller/new_components/lists/headers/filters_and_selection_headers_widget.dart';
import 'package:flutter_view_controller/new_screens/actions/cruds/view.dart';
import 'package:flutter_view_controller/new_screens/base_page.dart';
import 'package:flutter_view_controller/new_screens/lists/components/search_components.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_api_master_new.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_view_abstract_new.dart';
import 'package:flutter_view_controller/providers/filterables/filterable_provider.dart';
import 'package:flutter_view_controller/screens/base_shared_drawer_navigation.dart';
import 'package:sliver_tools/sliver_tools.dart';

class ListToDetailsSecoundPaneNotifier extends BasePageSecoundPaneNotifier {
  ViewAbstract viewAbstract;
  ListToDetailsSecoundPaneNotifier({
    super.key,
    super.forceHeaderToCollapse = true,
    super.buildDrawer = false,
    required this.viewAbstract,
    super.isFirstToSecOrThirdPane,
  });

  @override
  State<ListToDetailsSecoundPaneNotifier> createState() =>
      _ListToDetailsSecoundPaneNotifierState();
}

class _ListToDetailsSecoundPaneNotifierState
    extends BasePageState<ListToDetailsSecoundPaneNotifier>
    with BasePageSecoundPaneNotifierState {
  late ViewAbstract _viewAbstract;
  String? _lastSearchQuery;
  Map<String, FilterableProviderHelper>? _lastFilterData;
  SortFieldValue? _lastSortValue;
  final keyList = GlobalKey<SliverApiWithStaticMixin>(debugLabel: 'keyList');

  final ValueNotifier<List?> _listNotifier = ValueNotifier(null);
  final kk = GlobalKey<BasePageSecoundPaneNotifierState>();

  @override
  List<TabControllerHelper>? initTabBarList({
    bool? firstPane,
    TabControllerHelper? tab,
  }) {
    if (firstPane == false) {
      dynamic val = getSecondPaneNotifier.value;
      if (val is ViewAbstract) {
        return val.getCustomTabList(
          context,
          action: ServerActions.view,
          basePage: getSecoundPaneHelper(),
        );
      }
      return null;
    }
    return super.initTabBarList(firstPane: firstPane, tab: tab);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _viewAbstract = widget.viewAbstract;
    _listNotifier.addListener(() => debugPrint("ListToDet=> isNotifie"));
  }

  @override
  void didUpdateWidget(covariant ListToDetailsSecoundPaneNotifier oldWidget) {
    if (!widget.viewAbstract.isEquals(_viewAbstract)) {
      _viewAbstract = widget.viewAbstract;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget? getAppbarTitle({bool? firstPane, TabControllerHelper? tab}) => null;

  @override
  Widget? getFloatingActionButtonPaneNotifier({
    bool? firstPane,
    TabControllerHelper? tab,
  }) => null;

  @override
  Widget? getPaneDraggableExpandedHeader({
    required bool firstPane,
    TabControllerHelper? tab,
  }) => null;

  @override
  Widget? getPaneDraggableHeader({
    required bool firstPane,
    TabControllerHelper? tab,
  }) => null;

  @override
  Future<void>? getPaneIsRefreshIndicator({required bool firstPane}) {
    return null;
    if (firstPane) {
      return getRefreshIndicator();
    }
    return null;
  }

  //TODO test this
  Future<void> getRefreshIndicator() {
    if (keyList.currentState != null) {
      return keyList.currentState!.refresh();
    }
    return Future.value();
  }

  @override
  List<Widget>? getCustomViewWhenSecondPaneIsEmpty(
    ScrollController? controler,
    TabControllerHelper? tab,
  ) {
    return _viewAbstract.getHomeListHeaderWidgetList(context);
  }

  @override
  List<Widget>? getPaneNotifier({
    required bool firstPane,
    ScrollController? controler,
    TabControllerHelper? tab,
    SecondPaneHelper? valueNotifier,
  }) {
    List<Widget>? top;
    top = _viewAbstract.getCustomTopWidget(
      context,
      action: _lastSearchQuery != null
          ? ServerActions.search
          : ServerActions.list,
      basePage: getSecoundPaneHelper(),
      isFromFirstAndSecPane: firstPane,
      extras: _lastSearchQuery,
    );

    if (firstPane) {
      // asda
      debugPrint("getPaneNotifier firstPane $valueNotifier");
      return [
        SliverPersistantContainer(
          // floating: true,
          pinned: true,
          minExtent: 110,
          maxExtent: 110,
          child: Container(
            color: Theme.of(context).colorScheme.surface,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SearchWidgetComponent(
                  state: getSecoundPaneHelper(),
                  viewAbstract: _viewAbstract,
                  onSearchTextChanged: (p0) {
                    //TODO this is the old way
                    // notify(SecondPaneHelper(
                    //     title:
                    //         AppLocalizations.of(context)!.searchInFormat(p0!),
                    //     value: p0));
                    setState(() {
                      _lastSearchQuery = p0;
                    });
                  },
                ),
                ValueListenableBuilder(
                  valueListenable: _listNotifier,
                  builder: (context, value, child) {
                    debugPrint("ListToDet=> fff $value");
                    return FiltersAndSelectionListHeaderValueNotifier(
                      width: firstPaneWidth,
                      viewAbstract: _viewAbstract,
                      valueNotifer: _listNotifier,
                      filterInitial: _lastFilterData,
                      sortInitial: _lastSortValue,
                      onDoneFilter: (value) {
                        setState(() {
                          _lastFilterData = (value is bool)
                              ? value
                                    ? null
                                    : _lastFilterData
                              : value;
                        });
                      },
                      onDoneSort: (sort) {
                        setState(() {
                          _lastSortValue = sort;
                        });
                      },
                      // onDoneFilter: ,
                      secPaneNotifer: getSecoundPaneHelper(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        // ValueListenableBuilder(
        //   valueListenable: _listNotifier,
        //   builder: (context, value, child) {
        //     debugPrint("ListToDet=> $value");
        //     return SliverPersistentHeader(
        //         pinned: true,
        //         delegate: SliverAppBarDelegatePreferedSize(
        //             shouldRebuildWidget: true,
        //             child: PreferredSize(
        //               preferredSize: Size.fromHeight(60),
        //               child: FiltersAndSelectionListHeaderValueNotifier(
        //                 width: firstPaneWidth,
        //                 viewAbstract: _viewAbstract,
        //                 valueNotifer: _listNotifier,
        //               ),
        //             )));
        //   },
        // ),
        if (top != null) ...top,
        SliverApiMixinViewAbstractWidget(
          state: getSecoundPaneHelper(),
          valueListProviderNotifier: _listNotifier,
          key: keyList,
          isSelectForCard: (object) {
            return isSelectForCard(object);
          },

          // onClickForCard: (object) {
          //   // debugPrint("getPaneNotifier onClick $v");
          //   notify(
          //     SecondPaneHelper(
          //       title: object.getMainHeaderTextOnly(context),
          //       value: object,
          //     ),
          //   );
          // },
          cardType: CardItemType.list,
          scrollDirection: Axis.vertical,
          enableSelection: true,
          scrollController: controler,
          filterData: _lastFilterData,
          searchString: _lastSearchQuery,
          // hasCustomSeperater: Divider(),
          isSliver: true,
          // searchString: _searchQuery,
          // hasCustomCardBuilder: (index, item) {
          //   CutRequest cutRequest = item as CutRequest;
          //   return CutRequestListCard(
          //     item: cutRequest,
          //   );
          // },
          copyWithRequestOption: _lastSortValue == null
              ? null
              : RequestOptions().addSortBy(
                  _lastSortValue!.field,
                  _lastSortValue!.type,
                ),
          toListObject: _viewAbstract,
        ),
      ];
    }
    return [];
    if (valueNotifier == null) {
      return [const SliverFillRemaining(child: Text("valueNotifer==null"))];
    }
    debugPrint("${valueNotifier.value}");
    if (valueNotifier.value is BasePage) {
      return [
        // if (top != null)
        //   ...top.map((p) => SliverToBoxAdapter(
        //         child: p,
        //       )),
        SliverFillRemaining(
          child: (valueNotifier.value as BasePage)
            ..setParent = this
            ..setParentOnBuild = onBuild,
        ),
      ];
    }

    return [
      if (valueNotifier.value is MultiSliver) valueNotifier.value,
      // if (top != null)
      //   ...top.map((p) => SliverToBoxAdapter(
      //         child: p,
      //       )),
      if (valueNotifier.value is ViewAbstract)
        SliverFillRemaining(
          child: ViewNew(
            extras: valueNotifier.value,
            iD: valueNotifier.value.iD,
            tableName: valueNotifier.value.getTableNameApi(),
            onBuild: onBuild,
            key: kk,
            parent: this,
          ),
        ),
      // MasterView(
      //   viewAbstract: valueNotifier.value,
      // ),
      // MasterView(
      //   viewAbstract: valueNotifier.value,
      // ),
      // MasterView(
      //   viewAbstract: valueNotifier.value,
      // )
    ];
  }

  @override
  bool isPaneScaffoldOverlayColord(bool firstPane) => false;

  @override
  String onActionInitial() => _viewAbstract.getMainHeaderLabelTextOnly(context);

  @override
  bool setClipRect(bool? firstPane) => false;
  @override
  bool setHorizontalDividerWhenTowPanes() => false;

  @override
  bool setMainPageSuggestionPadding() => false;

  @override
  bool setPaneBodyPaddingHorizontal(bool firstPane) => !firstPane;
}
