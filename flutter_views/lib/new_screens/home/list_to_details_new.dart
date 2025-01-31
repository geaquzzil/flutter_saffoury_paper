import 'package:flutter/material.dart';
import 'package:flutter_view_controller/customs_widget/sliver_delegates.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_base.dart';
import 'package:flutter_view_controller/new_components/lists/headers/filters_and_selection_headers_widget.dart';
import 'package:flutter_view_controller/new_components/lists/list_card_item.dart';
import 'package:flutter_view_controller/new_screens/actions/cruds/view.dart';
import 'package:flutter_view_controller/new_screens/base_page.dart';
import 'package:flutter_view_controller/new_screens/lists/components/search_components.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_api_master_new.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_view_abstract_new.dart';
import 'package:flutter_view_controller/screens/base_shared_drawer_navigation.dart';

class ListToDetailsSecoundPaneNotifier extends BasePageSecoundPaneNotifier {
  ViewAbstract viewAbstract;
  ListToDetailsSecoundPaneNotifier(
      {super.key,
      super.forceHeaderToCollapse = true,
      super.buildDrawer = false,
      required this.viewAbstract,
      super.isFirstToSecOrThirdPane});

  @override
  State<ListToDetailsSecoundPaneNotifier> createState() =>
      _ListToDetailsSecoundPaneNotifierState();
}

class _ListToDetailsSecoundPaneNotifierState
    extends BasePageState<ListToDetailsSecoundPaneNotifier>
    with BasePageSecoundPaneNotifierState {
  late ViewAbstract _viewAbstract;
  String? _lastSearchQuery;
  final keyList = GlobalKey<SliverApiWithStaticMixin>(debugLabel: 'keyList');

  final ValueNotifier<List?> _listNotifier = ValueNotifier(null);
  final kk = GlobalKey<BasePageSecoundPaneNotifierState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _viewAbstract = widget.viewAbstract;
    _listNotifier.addListener(
      () => debugPrint("ListToDet=> isNotifie"),
    );
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
  Widget? getFloatingActionButton(
          {bool? firstPane, TabControllerHelper? tab}) =>
      null;

  @override
  Widget? getPaneDraggableExpandedHeader(
          {required bool firstPane, TabControllerHelper? tab}) =>
      null;

  @override
  Widget? getPaneDraggableHeader(
          {required bool firstPane, TabControllerHelper? tab}) =>
      null;

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
  List<Widget>? getPaneNotifier(
      {required bool firstPane,
      ScrollController? controler,
      TabControllerHelper? tab,
      SecondPaneHelper? valueNotifier}) {
    if (firstPane) {
      // asda
      debugPrint("getPaneNotifier firstPane $valueNotifier");
      return [
        SliverPersistantContainer(
          // floating: true,
          pinned: true,
          minExtent: 100,
          maxExtent: 110,
          child: Container(
            color: Theme.of(context).colorScheme.surface,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SearchWidgetComponent(
                  viewAbstract: _viewAbstract,
                  onSearchTextChanged: (p0) {
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
                        secPaneNotifer: getSecondPaneNotifier,
                      );
                    })
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
        SliverApiMixinViewAbstractWidget(
          valueListProviderNotifier: _listNotifier,
          key: keyList,
          hasCustomCardBuilder: (i, v) {
            debugPrint(
                "getPaneNotifier  valueNotifier ==> $valueNotifier ${valueNotifier?.value.hashCode} == ${v.hashCode}");
            return ListCardItem(
              // state: this,
              object: v,
              // isSelected: (lastSecondPaneItem?.value?.isEquals(v) ?? false),//TODO what if the value of viewAbstract is Widget fix this

              //  valueNotifier?.value.hashCode == v.hashCode,
              onClick: (v) {
                debugPrint("getPaneNotifier onClick $v");
                notify(SecondPaneHelper(
                    title: v.getMainHeaderTextOnly(context), value: v));
              },
            );
          },

          isGridView: false,
          scrollDirection: Axis.vertical,
          enableSelection: true,
          scrollController: controler,
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
          toListObject: _viewAbstract,
        )
      ];
    }
    if (valueNotifier == null) {
      return [
        const SliverFillRemaining(
          child: Text("valueNotifer==null"),
        )
      ];
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
        )
      ];
    }
    List<Widget>? top = (valueNotifier.value as ViewAbstract)
        .getCustomTopWidget(context, action: ServerActions.view);
    return [
      // if (top != null)
      //   ...top.map((p) => SliverToBoxAdapter(
      //         child: p,
      //       )),
      SliverFillRemaining(
        child: ViewNew(
          buildSecondPane: true,
          viewAbstract: valueNotifier.value,
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
