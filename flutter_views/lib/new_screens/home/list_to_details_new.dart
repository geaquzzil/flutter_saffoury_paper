import 'package:flutter/material.dart';
import 'package:flutter_view_controller/customs_widget/sliver_delegates.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_base.dart';
import 'package:flutter_view_controller/new_components/lists/list_card_item.dart';
import 'package:flutter_view_controller/new_screens/base_page.dart';
import 'package:flutter_view_controller/new_screens/lists/components/search_components.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _viewAbstract = widget.viewAbstract;
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
          maxExtent: 60,
          child: SearchWidgetComponent(
            viewAbstract: _viewAbstract as ViewAbstract,
            onSearchTextChanged: (p0) {
             
              setState(() {
                 _lastSearchQuery = p0;
              });
            },
          ),
        ),
        SliverApiMixinViewAbstractWidget(
          hasCustomCardBuilder: (i, v) {
            debugPrint(
                "getPaneNotifier  valueNotifier ==> $valueNotifier ${valueNotifier?.value.hashCode} == ${v.hashCode}");
            return ListCardItem(
              // state: this,
              object: v,
              isSelected: (lastSecondPaneItem?.value?.isEquals(v) ?? false),

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
    return [
      // SliverFillRemaining(
      //   child: getWidgetFromListToDetailsSecoundPaneHelper(
      //       selectedItem: selectedItem, tab: tab),
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
  bool setPaneBodyPadding(bool firstPane) => false;
}
