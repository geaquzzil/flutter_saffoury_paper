import 'dart:math';

import 'package:auto_animated/auto_animated.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_view_controller/components/scroll_snap_list.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/customs_widget/draggable_home.dart';
import 'package:flutter_view_controller/customs_widget/sliver_delegates.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/helper_model/qr_code.dart';
import 'package:flutter_view_controller/models/auto_rest.dart';
import 'package:flutter_view_controller/models/permissions/user_auth.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/cartable_draggable_header.dart';
import 'package:flutter_view_controller/new_components/fabs/floating_action_button_extended.dart';
import 'package:flutter_view_controller/new_components/fabs_on_list_widget.dart';
import 'package:flutter_view_controller/new_components/lists/headers/filters_and_selection_headers_widget.dart';
import 'package:flutter_view_controller/new_components/lists/horizontal_list_card_item.dart';
import 'package:flutter_view_controller/new_components/lists/horizontal_list_card_item_shimmer.dart';
import 'package:flutter_view_controller/new_components/lists/list_card_item.dart';
import 'package:flutter_view_controller/new_components/lists/list_card_item_selected.dart';
import 'package:flutter_view_controller/new_components/lists/slivers/sliver_animated_card.dart';
import 'package:flutter_view_controller/new_components/qr_code_widget.dart';
import 'package:flutter_view_controller/new_components/scroll_to_hide_widget.dart';
import 'package:flutter_view_controller/new_screens/home/components/empty_widget.dart';
import 'package:flutter_view_controller/new_screens/home/list_to_details_widget_new.dart';
import 'package:flutter_view_controller/new_screens/lists/components/search_components.dart';
import 'package:flutter_view_controller/providers/actions/list_multi_key_provider.dart';
import 'package:flutter_view_controller/providers/actions/list_scroll_provider.dart';
import 'package:flutter_view_controller/providers/auth_provider.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_controler.dart';
import 'package:flutter_view_controller/providers/filterables/filterable_provider.dart';
import 'package:flutter_view_controller/screens/web/components/grid_view_api_category.dart';
import 'package:flutter_view_controller/screens/web/components/header_text.dart';

import 'package:flutter_view_controller/size_config.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
import 'package:skeletons/skeletons.dart';
import 'package:tuple/tuple.dart';

mixin SliverCustomListMixinBuilder<T extends StatefulWidget> on State<T> {
  @override
  Widget build(BuildContext context) {}
}

abstract class SliverApiMixinWithStaticStateful extends StatefulWidget {
  ///could be [AutoRest] or [ViewAbstract] or String of [tableName] or [List<ViewAbstract>] or [CustomViewHorizontalListResponse]
  Object toListObject;
  ViewAbstract? setParentForChildCardItem;
  ValueNotifier<List<ViewAbstract>>? onSeletedListItemsChanged;
  bool buildSearchWidgetAsEditText;

  ///when scrollDirection is horizontal grid view well build instaed  and override the [isGridView] even when its true
  Axis scrollDirection;
  bool isGridView;

  SliverApiMixinWithStaticStateful(
      {super.key,
      required this.toListObject,
      this.isGridView = true,
      this.scrollDirection = Axis.vertical,
      this.buildSearchWidgetAsEditText = false,
      this.onSeletedListItemsChanged,
      this.setParentForChildCardItem});
}

enum _ObjectType {
  AUTO_REST,
  VIEW_ABSTRACT,
  STRING,
  CUSTOM_LIST,
  CUSTOM_VIEW_RESPONSE
}

mixin SliverApiWithStaticMixin<T extends SliverApiMixinWithStaticStateful>
    on State<T> {
  late Object _toListObject;
  late _ObjectType _toListObjectType;
  ViewAbstract? _setParentForChildCardItem;
  String? _searchString;
  final _scrollController = ScrollController();
  late ListMultiKeyProvider listProvider;
  late ValueNotifier<bool> valueNotifierGrid;
  late ValueNotifier<List<ViewAbstract>>? _onSeletedListItemsChanged;
  final double horizontalGridSpacing = 10;
  final double verticalGridSpacing = 10;
  final double horizontalGridMargin = 10;
  final double verticalGridMargin = 10;
  final int minItemsPerRow = 3;
  final int maxItemsPerRow = 8;
  bool _selectMood = false;
  final double minGridItemSize = 100;

  final Curve _defualtScrollCurve = Curves.fastOutSlowIn;
  final Duration _defaultScrollDuration = const Duration(milliseconds: 700);

  final ValueNotifier<ExpandType> _expandType =
      ValueNotifier<ExpandType>(ExpandType.HALF_EXPANDED);

  String? get setSearchString => this._searchString;

  set getSearchString(String? value) => this._searchString = value;

  String findListCustomKey() {
    ViewAbstract? v = getToListObjectCastViewAbstractNullIfNot();
    if (v != null) {
      String key = v.getListableKey();
      key = key + (_searchString ?? "");
      return key;
    }
    if (_toListObjectType == _ObjectType.CUSTOM_VIEW_RESPONSE) {
      return getToListObjectHorizontalListResponse().getCustomViewKey();
    } else if (_toListObjectType == _ObjectType.AUTO_REST) {
      return getToListObjectCastAutoRest().key;
    } else {
      return "";
    }
  }

  void toggleSelectedMood() {
    if (mounted) {
      setState(() {
        _selectMood = !_selectMood;
      });
    }
  }

  AutoRest getToListObjectCastAutoRest() {
    return _toListObject as AutoRest;
  }

  String getToListObjectCastString() {
    return _toListObject as String;
  }

  ViewAbstract getToListObjectCastViewAbstract() {
    return _toListObject as ViewAbstract;
  }

  List<ViewAbstract> getToListObjectCastList() {
    return _toListObject as List<ViewAbstract>;
  }

  bool isToListObjectIsViewAbstract() {
    return _toListObject is ViewAbstract;
  }

  CustomViewHorizontalListResponse getToListObjectHorizontalListResponse() {
    return _toListObject as CustomViewHorizontalListResponse;
  }

  AutoRest? getToListObjectCastAutoRestNullIfNot() {
    if (_toListObjectType != _ObjectType.AUTO_REST) return null;
    return _toListObject as AutoRest;
  }

  ViewAbstract? getToListObjectCastViewAbstractNullIfNot() {
    if (_toListObjectType == _ObjectType.VIEW_ABSTRACT ||
        _toListObjectType == _ObjectType.STRING)
      return _toListObject as ViewAbstract;
    return null;
  }

  _ObjectType getToListObjectType() {
    if (widget.toListObject is AutoRest) {
      return _ObjectType.AUTO_REST;
    } else if (widget.toListObject is String) {
      return _ObjectType.STRING;
    } else if (widget.toListObject is ViewAbstract) {
      return _ObjectType.VIEW_ABSTRACT;
    } else if (widget.toListObject is List) {
      return _ObjectType.CUSTOM_LIST;
    } else {
      return _ObjectType.CUSTOM_VIEW_RESPONSE;

      ///this is a  CustomViewHorizontalListResponse
    }
  }

  void checkForOverridingSetttings() {
    ///TODO check for overriding setttings
  }
  Object checkToInitToListObject() {
    if (_toListObjectType == _ObjectType.STRING) {
      return context
          .read<AuthProvider<AuthUser>>()
          .getNewInstance(widget.toListObject as String)!;
    } else {
      return widget.toListObject;
    }
  }

  @override
  void initState() {
    listProvider = Provider.of<ListMultiKeyProvider>(context, listen: false);
    _setParentForChildCardItem = widget.setParentForChildCardItem;
    _scrollController.addListener(_onScroll);
    _toListObjectType = getToListObjectType();

    ///override the gride view when the scroll axis is horizontal
    valueNotifierGrid = ValueNotifier<bool>(
        widget.isGridView || widget.scrollDirection == Axis.horizontal);

    _onSeletedListItemsChanged =
        widget.onSeletedListItemsChanged ?? ValueNotifier([]);

    _toListObject = checkToInitToListObject();

    checkForOverridingSetttings();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant oldWidget) {
    _checkToUpdateToListObject();
    _setParentForChildCardItem = widget.setParentForChildCardItem;
    if (valueNotifierGrid.value != widget.isGridView) {
      valueNotifierGrid.value = widget.isGridView;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  Selector<ListMultiKeyProvider, Tuple3<bool, int, bool>> getListSelector() {
    return Selector<ListMultiKeyProvider, Tuple3<bool, int, bool>>(
      builder: (context, value, child) {
        bool isLoading = value.item1;
        int count = value.item2;
        bool isError = value.item3;
        if(_toListObjectType==_ObjectType.CUSTOM_VIEW_RESPONSE){
          return getCustomViewResponseWidget();

        }else{
        debugPrint(
            "Selector building widget: ${findListCustomKey()} isloading: $isLoading iserror: $isError count: $count");
        if (!isLoading && (count == 0 || isError)) {
          return getEmptyWidget(isError: isError);
        }
        return getListValueListenableIsGrid(count: count, isLoading: isLoading);
        }
      },
      selector: (p0, p1) => Tuple3(p1.isLoading(findListCustomKey()),
          p1.getCount(findListCustomKey()), p1.isHasError(findListCustomKey())),
    );
  }
  Widget getCustomViewResponseWidget(){
     switch (autoRest.getCustomViewResponseType()) {
      case ResponseType.LIST:
        return getListWidget(listProvider);

      case ResponseType.SINGLE:
        return getSingleWidget(listProvider);

      case ResponseType.NONE_RESPONSE_TYPE:
        return getSingleWidget(listProvider);
    }
  }

  Widget getSearchWidget() {
    return SearchWidgetComponent(
      appBardExpandType: _expandType,
      viewAbstract: getToListObjectCastViewAbstract(),
      onSearchTextChanged: !widget.buildSearchWidgetAsEditText
          ? null
          : (serchQuery) {
              _searchString = serchQuery;
              _scrollTop();
              fetshList(notifyNotSearchable: _searchString == null);
            },
      key: const ValueKey(2),
      heroTag: "list/search",
    );
  }

  ValueListenableBuilder<bool> getListValueListenableIsGrid(
      {List? list, required int count, required bool isLoading}) {
    return ValueListenableBuilder<bool>(
      valueListenable: valueNotifierGrid,
      builder: (context, value, child) {
        if (value) {
          return getSliverGridList(
              list: list, count: count, isLoading: isLoading);
        } else {
          return getSliverList(count, isLoading);
        }
      },
    );
  }

  Widget Function(
    BuildContext context,
    int index,
    Animation<double> animation,
  ) animationItemBuilder(
    Widget Function(int index) child, {
    EdgeInsets padding = EdgeInsets.zero,
  }) =>
      (
        BuildContext context,
        int index,
        Animation<double> animation,
      ) =>
          FadeTransition(
            opacity: Tween<double>(
              begin: 0,
              end: 1,
            ).animate(animation),
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, -0.1),
                end: Offset.zero,
              ).animate(animation),
              child: Padding(
                padding: padding,
                child: child(index),
              ),
            ),
          );

  Widget getSliverList(int count, bool isLoading) {
    return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding / 3),
        sliver: LiveSliverList(
            controller: _scrollController,
            showItemInterval: Duration(milliseconds: isLoading ? 0 : 100),
            itemBuilder: animationItemBuilder(
              (index) {
                if (isLoading && index >= count - 1) {
                  return SkeletonListTile(
                    hasLeading: true,
                    hasSubtitle: true,
                    padding: const EdgeInsets.symmetric(
                        horizontal: kDefaultPadding / 2,
                        vertical: kDefaultPadding / 2),
                  );
                }
                ViewAbstract va =
                    listProvider.getList(findListCustomKey())[index];
                va.setParent(_setParentForChildCardItem);
                Widget w = _selectMood
                    ? ListCardItemSelected(
                        isSelected: _isSelectedItem(va),
                        onSelected: _onSelectedItem,
                        object: va)
                    : ListCardItem(
                        state: this,
                        object: va,
                      );
                return w;
              },
            ),
            itemCount: count + (isLoading ? 8 : 0)));
  }

  bool _isSelectedItem(ViewAbstract va) {
    return _onSeletedListItemsChanged?.value
            .firstWhereOrNull((p0) => p0.isEquals(va)) !=
        null;
  }

  void _onSelectedItem(ViewAbstract obj, bool isSelected) {
    List<ViewAbstract>? list = _onSeletedListItemsChanged?.value;
    if (!isSelected) {
      list?.removeWhere((element) => element.isEquals(obj));
      _onSeletedListItemsChanged?.value = [
        if (list != null) ...list else ...[]
      ];
    } else {
      ViewAbstract? isFounded = _onSeletedListItemsChanged?.value
          .firstWhereOrNull((p0) => p0.isEquals(obj));
      if (isFounded == null) {
        _onSeletedListItemsChanged?.value = [
          if (list != null) ...list else ...[],
          obj
        ];
      }
    }
  }

  List<Widget> getGridList(
      {List? list, required int count, required bool isLoading}) {
    return [
      if (list == null)
        ...listProvider.getList(findListCustomKey()).map(getGridItem),
      if (list == null)
        if (isLoading)
          ...List.generate(
              5, (index) => GridTile(child: ListHorizontalItemShimmer())),
      if (list != null) ...list.map(getGridItem)
    ];
  }

  Widget getGridItem(e) => WebGridViewItem(
        isSelectMood: _selectMood,
        isSelected: _isSelectedItem(e),
        onSelected: _onSelectedItem,
        item: e,
        state: this,
        setDescriptionAtBottom: false,
      );

  /// if axis is horizontal then we do need to padding or adding the hover puttons
  Widget getSliverGridList(
      {List? list, required int count, required bool isLoading}) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      sliver: widget.scrollDirection == Axis.vertical
          ? getGridViewWhenAxisIsVertical(list, count, isLoading)
          : getGridViewWhenAxisIsHorizontal(list, count, isLoading),
    );
  }

  Widget getGridViewWhenAxisIsHorizontal(
      List<dynamic>? list, int count, bool isLoading) {
    list = list ?? listProvider.getList(findListCustomKey());
    return LayoutBuilder(
      builder: (co, constraints) {
        return ScrollSnapList(
          itemCount: list!.length + (isLoading ? 5 : 0),
          selectedItemAnchor: SelectedItemAnchor.START,
          // endOfListTolerance: constraints.maxWidth,
          scrollDirection: Axis.horizontal,
          itemSize: constraints.maxHeight,
          listController: _scrollController,
          itemBuilder: (c, index) {
            if (isLoading && index > list!.length - 1) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
                child: GridTile(
                    child: SizedBox(
                        height: constraints.maxHeight,
                        width: constraints.maxHeight,
                        child: ListHorizontalItemShimmer(
                          lines: SizeConfig.hasPointer(context) ? 0 : 3,
                        ))),
              );
            }
            Widget currentTile = WebGridViewItem(
              setDescriptionAtBottom: !SizeConfig.hasPointer(context),
              item: list![index],
            );
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
              child: GridTile(child: currentTile),
            );
          },
          onItemFocus: (p0) {},
        );
      },
    );
  }

  Widget getGridViewWhenAxisIsVertical(
      List<dynamic>? list, int count, bool isLoading) {
    return ResponsiveSliverGridList(
        horizontalGridSpacing:
            horizontalGridSpacing, // Horizontal space between grid items
        verticalGridSpacing:
            verticalGridSpacing, // Vertical space between grid items
        horizontalGridMargin:
            horizontalGridMargin, // Horizontal space around the grid
        verticalGridMargin:
            verticalGridMargin, // Vertical space around the grid
        minItemsPerRow:
            minItemsPerRow, // The minimum items to show in a single row. Takes precedence over minItemWidth
        maxItemsPerRow:
            maxItemsPerRow, // The maximum items to show in a single row. Can be useful on large screens
        sliverChildBuilderDelegateOptions: SliverChildBuilderDelegateOptions(),
        minItemWidth: minGridItemSize,
        children: getGridList(list: list, count: count, isLoading: isLoading));
  }

  Widget getEmptyWidget({bool isError = false}) {
    return SliverFillRemaining(
      child: _getEmptyWidget(isError),
    );
  }

  EmptyWidget _getEmptyWidget(bool isError) {
    return EmptyWidget(
        onSubtitleClicked: isError
            ? () {
                fetshList();
              }
            : null,
        lottiUrl: "https://assets7.lottiefiles.com/packages/lf20_0s6tfbuc.json",
        title: isError
            ? AppLocalizations.of(context)!.cantConnect
            : AppLocalizations.of(context)!.noItems,
        subtitle: isError
            ? AppLocalizations.of(context)!.cantConnectConnectToRetry
            : AppLocalizations.of(context)!.no_content);
  }

  void _checkToUpdateToListObject() {
    bool shouldFetsh = false;
    _ObjectType lastUpdated = getToListObjectType();
    if (lastUpdated == _ObjectType.VIEW_ABSTRACT &&
        _toListObjectType == _ObjectType.VIEW_ABSTRACT) {
      ViewAbstract checkedViewAbstract = widget.toListObject as ViewAbstract;
      if (checkedViewAbstract.runtimeType !=
          getToListObjectCastViewAbstract().runtimeType) {
        shouldFetsh = true;
        _toListObject = checkedViewAbstract;
        _resetValues();
      } else if (lastUpdated == _ObjectType.STRING &&
          _toListObjectType == _ObjectType.STRING) {
        String tableName = widget.toListObject as String;
        if (tableName != getToListObjectCastViewAbstract().getTableNameApi()) {
          shouldFetsh = true;
          _toListObject = checkToInitToListObject();
          _resetValues();
        }
      } else if (lastUpdated == _ObjectType.CUSTOM_VIEW_RESPONSE &&
          _toListObjectType == _ObjectType.CUSTOM_VIEW_RESPONSE) {
        CustomViewHorizontalListResponse newObject =
            widget.toListObject as CustomViewHorizontalListResponse;

        if (newObject.getCustomViewKey() !=
            getToListObjectHorizontalListResponse().getCustomViewKey()) {
          shouldFetsh = true;
          _toListObject = newObject;
          _resetValues();
        }
      } else if (lastUpdated == _ObjectType.AUTO_REST &&
          _toListObjectType == _ObjectType.AUTO_REST) {
        AutoRest autoRest = widget.toListObject as AutoRest;
        if (autoRest.key != getToListObjectCastAutoRest().key) {
          shouldFetsh = true;
          _toListObject = autoRest;
          _resetValues();
        }
      } else {
        shouldFetsh = true;
        _toListObject = widget.toListObject;
        _toListObjectType = getToListObjectType();
      }
    }
    if (shouldFetsh) {
      fetshListWidgetBinding();
    }
  }

  void _resetValues() {
    _searchString = null;
    _onSeletedListItemsChanged?.value = [];
  }

  bool canFetshList() {
    return _toListObjectType != _ObjectType.CUSTOM_LIST;
  }

  void fetshList({bool notifyNotSearchable = false}) {
    if (!canFetshList()) return;
    String customKey = findListCustomKey();
    if (_toListObjectType == _ObjectType.CUSTOM_VIEW_RESPONSE) {
      CustomViewHorizontalListResponse c =
          getToListObjectHorizontalListResponse();
      switch (c.getCustomViewResponseType()) {
        case ResponseType.LIST:
          listProvider.fetchList(customKey, viewAbstract: c as ViewAbstract);
          break;
        case ResponseType.SINGLE:
          listProvider.fetchView(customKey, viewAbstract: c as ViewAbstract);
          break;

        case ResponseType.NONE_RESPONSE_TYPE:
          break;
      }
    } else if (isToListObjectIsViewAbstract()) {
      if (notifyNotSearchable) {
        listProvider.notifyNotSearchable(customKey,
            autoRest: getToListObjectCastAutoRestNullIfNot(),
            viewAbstract: getToListObjectCastAutoRestNullIfNot()?.obj ??
                getToListObjectCastViewAbstractNullIfNot());
      }
      if (listProvider.getCount(customKey) == 0) {
        if (_searchString == null) {
          listProvider.fetchList(customKey,
              autoRest: getToListObjectCastAutoRestNullIfNot(),
              viewAbstract: getToListObjectCastAutoRestNullIfNot()?.obj ??
                  getToListObjectCastViewAbstractNullIfNot());
        } else {
          listProvider.fetchListSearch(
              customKey, getToListObjectCastViewAbstract(), _searchString!);
        }
      }
    }
  }

  void refresh() {
    ViewAbstract? v = getToListObjectCastViewAbstractNullIfNot();
    if (v == null) return;
    listProvider.refresh(findListCustomKey(), v);
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _scrollTop() {
    _scrollController.animateTo(
      _scrollController.position.minScrollExtent,
      duration: _defaultScrollDuration,
      curve: _defualtScrollCurve,
    );
  }

  void scrollTo(double pos) {
    debugPrint("ListHorizontalApiAutoRestWidget scrollTo pos===> $pos");
    if (_scrollController.hasClients == false) return;
    _scrollController.jumpTo(
      pos,
    );
  }

  void scrollToCollapsed() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: _defaultScrollDuration,
      curve: _defualtScrollCurve,
    );
  }

  void _onScroll() {
    final direction = _scrollController.position.userScrollDirection;
    if (direction == ScrollDirection.forward) {
      context.read<ListScrollProvider>().setScrollDirection = direction;
    } else if (direction == ScrollDirection.reverse) {
      context.read<ListScrollProvider>().setScrollDirection = direction;
    }
    if (_isBottom) {
      fetshList();
    }
  }

  void fetshListWidgetBinding() {
    if (!canFetshList()) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetshList();
    });
  }
}

class SliverApiMaster extends StatefulWidget {
  ViewAbstract? viewAbstract;
  bool buildSearchWidget;
  bool buildSearchWidgetAsEditText;
  bool buildAppBar;
  bool buildFabIfMobile;
  bool buildToggleView;
  bool buildFilterableView;

  CurrentScreenSize? currentScreenSize;
  String? tableName;

  List<ViewAbstract>? initialSelectedList;
  void Function(List<ViewAbstract> selectedList)? onSelectedListChange;
  ValueNotifier<List<ViewAbstract>>? onSelectedListChangeValueNotifier;
  @Deprecated("Use glbal key and check for large screen")
  ValueNotifier<ListToDetailsSecoundPaneHelper?>?
      onSelectedCardChangeValueNotifier;
  ViewAbstract? setParentForChild;
  final bool showLeadingAsHamborg;
  @Deprecated("message")
  bool fetshListAsSearch;

  SliverApiMaster(
      {super.key,
      this.setParentForChild,
      this.viewAbstract,
      this.tableName,
      this.buildAppBar = true,
      this.buildSearchWidgetAsEditText = false,
      this.showLeadingAsHamborg = true,
      this.buildSearchWidget = true,
      this.buildFilterableView = true,
      this.buildToggleView = true,
      this.initialSelectedList,
      this.onSelectedListChange,
      this.currentScreenSize,
      this.onSelectedListChangeValueNotifier,
      this.onSelectedCardChangeValueNotifier,
      this.fetshListAsSearch = false,
      this.buildFabIfMobile = true});

  @override
  State<SliverApiMaster> createState() => SliverApiMasterState();
}

class SliverApiMasterState<T extends SliverApiMaster> extends State<T> {
  late ViewAbstract viewAbstract;
  final isDialOpen = ValueNotifier(false);
  ViewAbstract? scanedQr;
  final _scrollController = ScrollController();
  late ListMultiKeyProvider listProvider;
  late DrawerMenuControllerProvider drawerViewAbstractObsever;
  GlobalKey<FabsOnListWidgetState> fabsOnListWidgetState =
      GlobalKey<FabsOnListWidgetState>();
  ValueNotifier<bool> valueNotifierGrid = ValueNotifier<bool>(false);
  final GlobalKey<SliverAnimatedListState> _listKey =
      GlobalKey<SliverAnimatedListState>();

  String? _searchStringQuery;

  bool _selectMood = false;

  bool get isSelectedMode => _selectMood;

  ValueNotifier<ExpandType> expandType =
      ValueNotifier<ExpandType>(ExpandType.HALF_EXPANDED);
  ValueNotifier<ExpandType> expandTypeOnlyOnExpand =
      ValueNotifier<ExpandType>(ExpandType.CLOSED);

  ValueNotifier<QrCodeNotifierState> valueNotifierQrState =
      ValueNotifier<QrCodeNotifierState>(
          QrCodeNotifierState(state: QrCodeCurrentState.NONE));

  late ValueNotifier<List<ViewAbstract>> onSelectedListChangeValueNotifier;

  void toggleSelectMood() {
    if (mounted) {
      setState(() {
        _selectMood = !_selectMood;
      });
    }
  }

  void clearSelection() {
    onSelectedListChangeValueNotifier.value.clear();
  }

  @override
  void initState() {
    super.initState();
    debugPrint("listApiMaster initState ");
    _scrollController.addListener(_onScroll);
    listProvider = Provider.of<ListMultiKeyProvider>(context, listen: false);
    drawerViewAbstractObsever =
        Provider.of<DrawerMenuControllerProvider>(context, listen: false);
    // drawerViewAbstractObsever.addListener(_onChangedViewAbstract);

    _selectMood = widget.onSelectedListChange != null ||
        widget.onSelectedListChangeValueNotifier != null;

    if (_selectMood) {
      onSelectedListChangeValueNotifier = widget
              .onSelectedListChangeValueNotifier ??
          ValueNotifier<List<ViewAbstract>>(widget.initialSelectedList ?? []);
    }
    if (widget.viewAbstract != null) {
      viewAbstract = widget.viewAbstract!;
    } else if (widget.tableName != null) {
      //todo check for table name if exits first
      viewAbstract = context
          .read<AuthProvider<AuthUser>>()
          .getNewInstance(widget.tableName!)!;
    } else {
      viewAbstract = drawerViewAbstractObsever.getObjectCastViewAbstract;
    }
    fetshListWidgetBinding();
  }

  void checkToUpdate() {
    ViewAbstract checkedViewAbstract;
    if (widget.viewAbstract != null) {
      checkedViewAbstract = widget.viewAbstract!;
    } else if (widget.tableName != null) {
      //todo check for table name if exits first
      checkedViewAbstract = context
          .read<AuthProvider<AuthUser>>()
          .getNewInstance(widget.tableName!)!;
    } else {
      checkedViewAbstract = drawerViewAbstractObsever.getObjectCastViewAbstract;
    }
    debugPrint(
        "didUpdateWidget sliverApiMaster checkedViewAbstract :${checkedViewAbstract.runtimeType} current:${viewAbstract.runtimeType}");
    if (checkedViewAbstract.runtimeType != viewAbstract.runtimeType) {
      debugPrint(
          "didUpdateWidget sliverApiMaster checkedViewAbstract.runtimeType!=viewAbstract.runtimeType updateing");
      viewAbstract = checkedViewAbstract;
      _searchStringQuery = null;
    }
    fetshListWidgetBinding();
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    checkToUpdate();
    super.didUpdateWidget(oldWidget);
  }

  void fetshListWidgetBinding() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetshList();
    });
  }

  @override
  void dispose() {
    debugPrint("listApiMaster dispose");
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return getBuildBodyDraggable();
    // return Selector<DrawerMenuControllerProvider, ViewAbstract>(
    //   builder: (context, value, child) {
    //     debugPrint(
    //         "drawerViewAbstractObsever SliverList ViewAbstract has changed from DrawerMenuController ${value.getTableNameApi()} customMap ${value.getCustomMap}");
    //     // if (viewAbstract== null) {
    //     //   viewAbstract = value;
    //     //   fetshListWidgetBinding();
    //     //   debugPrint(
    //     //       "SliverList ViewAbstract has changed from DrawerMenuController ViewAbstractProvider CHANGED");
    //     // }
    //     // view
    //     // if (!value.isEqualsAsType(viewAbstract)) {
    //     //   viewAbstract = value;
    //     //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     //     _scrollTop();
    //     //     fetshList();
    //     //   });
    //     //   // fetshListWidgetBinding();
    //     // }
    //     viewAbstract = value;

    //     WidgetsBinding.instance.addPostFrameCallback((_) {
    //       // _scrollTop();
    //       fetshList();
    //     });
    //   },
    //   selector: (p0, p1) => p1.getObjectCastViewAbstract,
    // );
  }

  Widget getAppbarTitle() {
    if (isSelectedMode) {
      return ValueListenableBuilder<List<ViewAbstract>>(
        valueListenable: onSelectedListChangeValueNotifier,
        builder: (context, value, child) {
          debugPrint(
              "ValueListenableBuilder sliverApiMaster appBar changed  ${value.length}");
          return Text(
              "${value.length} ${AppLocalizations.of(context)!.selectItems}");
        },
      );
    }
    return Text(viewAbstract.getMainHeaderLabelTextOnly(context));
  }

  Widget? getHeaderWidget() {
    // return  null;
    if (isSelectedMode) {
      if (viewAbstract.isCartable()) {
        return ValueListenableBuilder<List<ViewAbstract>>(
          valueListenable: onSelectedListChangeValueNotifier,
          builder: (context, value, child) {
            debugPrint(
                "ValueListenableBuilder sliverApiMaster appBar changed  ${value.length}");
            return CartableDraggableHeader(listableInterface: value.cast());
          },
        );
      }
      return null;
    }

    if (!canShowHeaderWidget()) return null;
    List<Widget>? homeList = viewAbstract.getHomeListHeaderWidgetList(context);
    // if (homeList == null) return null;
    return SizedBox(
      height: MediaQuery.of(context).size.height * .35,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(kDefaultPadding),
            child: Text(
              "SaffouryPaper",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          if (homeList != null)
            ...homeList.map((e) => SizedBox(
                  height: MediaQuery.of(context).size.height * .24,
                  // height: MediaQuery.of(context).size.height * .1,
                  child: e,
                ))

          // StaggeredGrid.count(
          //     crossAxisCount: 2,
          //     mainAxisSpacing: 1,
          //     crossAxisSpacing: 1,
          //     children: [if (homeList != null) ...homeList]),
        ],
      ),
    );
  }

  Widget getBuildBodyDraggable() {
    return DraggableHome(
        scrollKey: viewAbstract.getScrollKey(ServerActions.list),
        showLeadingAsHamborg:
            isLargeScreenFromScreenSize(widget.currentScreenSize)
                ? false
                : widget.showLeadingAsHamborg,
        valueNotifierExpandType: expandType,
        valueNotifierExpandTypeOnExpandOny: expandTypeOnlyOnExpand,
        scrollController: _scrollController,
        floatingActionButton: !widget.buildFabIfMobile
            ? null
            : Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ScrollToHideWidget(
                      height: 40,
                      useAnimatedSwitcher: true,
                      showOnlyWhenCloseToTop: false,
                      controller: _scrollController,
                      child: FloatingActionButton.small(
                          backgroundColor: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest
                              .withOpacity(.5),
                          foregroundColor:
                              Theme.of(context).colorScheme.onSurfaceVariant,
                          key: UniqueKey(),
                          heroTag: UniqueKey(),
                          onPressed: () {
                            _scrollTop();

                            // context.goNamed(posRouteName);
                          },
                          child: const Icon(Icons.arrow_drop_up_rounded)),
                    ),
                    const Spacer(),
                    FloatingActionButtonExtended(
                        onPress: () => {
                              drawerViewAbstractObsever
                                  .getObjectCastViewAbstract
                                  .onDrawerLeadingItemClicked(context)
                            },
                        expandedWidget:
                            Text(viewAbstract.getBaseTitle(context)))
                  ],
                ),
              ),

        // backgroundColor: Colors.red,
        title: getAppbarTitle(),
        headerExpandedHeight: !canShowHeaderWidget()
            ? 0.1
            : isSelectedMode
                ? 0.25
                : 0.4,
        stretchMaxHeight: isSelectedMode ? .3 : .5,
        fullyStretchable: isSelectedMode ? false : true,
        // headerBottomBar: getHeaderWidget(),
        pinnedToolbar: isSelectedMode,
        centerTitle: false,
        actions: [
          if (isSelectedMode)
            IconButton(onPressed: () {}, icon: const Icon(Icons.delete))
        ],
        headerWidget: getHeaderWidget(),
        expandedBody: isSelectedMode
            ? null
            : QrCodeReader(
                getViewAbstract: true,
                currentHeight: 20,
                valueNotifierQrState: valueNotifierQrState,
              ),
        slivers: [
          // if (isSelectedMode) getHeaderWidget()!,
          if (!canShowHeaderWidget())
            ...viewAbstract
                    .getHomeListHeaderWidgetList(context)
                    ?.map((e) => SliverToBoxAdapter(
                          child: e,
                        ))
                    .toList() ??
                [],

          if (widget.buildSearchWidget) getSearchWidget(),
          if (widget.buildFilterableView) getFilterableWidget(),
          if (widget.buildToggleView) getToggleView(),
          // if (searchStringQuery != "") getSearchDescription(),
          ValueListenableBuilder<ExpandType>(
              valueListenable: expandTypeOnlyOnExpand,
              builder: (context, value, child) {
                debugPrint("SliverApiMaster valueListenable expandType");
                if (value == ExpandType.EXPANDED) {
                  return getQrCodeSelector();
                }
                scanedQr = null;
                return getListSelector();
              })
        ]);
  }

  bool canShowHeaderWidget() {
    return false;
    return SizeConfig.isMobileFromScreenSize(context);
  }

  void _scrollTop() {
    _scrollController.animateTo(
      _scrollController.position.minScrollExtent,
      duration: const Duration(milliseconds: 700),
      curve: Curves.fastOutSlowIn,
    );
  }

  void _scrollToCollapsed() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 700),
      curve: Curves.fastOutSlowIn,
    );
  }

  Widget getQrCodeSelector() {
    return ValueListenableBuilder<QrCodeNotifierState>(
      valueListenable: valueNotifierQrState,
      builder: (context, value, _) {
        switch (value.state) {
          case QrCodeCurrentState.LOADING:
            scanedQr = null;

            return const SliverFillRemaining(
              child: EmptyWidget(
                expand: true,
                lottieJson: "loading_indecator.json",
              ),
            );

          case QrCodeCurrentState.NONE:
            scanedQr = null;
            return const SliverFillRemaining(
              child: EmptyWidget(
                expand: true,
                lottiUrl:
                    "https://assets3.lottiefiles.com/packages/lf20_oqfmttib.json",
              ),
            );

          case QrCodeCurrentState.DONE:
            scanedQr = value.viewAbstract as ViewAbstract;
            scanedQr!.setCustomMap({"<iD>": "${scanedQr!.iD}"});
            return SliverFillRemaining(
              child: Center(
                child: SizedBox(
                  height: 200,
                  width: 200,
                  child: ListCardItemHorizontal<ViewAbstract>(
                      useImageAsBackground: true,
                      object: scanedQr as ViewAbstract),
                ),
              ),
            );
            break;
        }
        // return getListSelector();
      },
    );
  }

  Selector<ListMultiKeyProvider, Tuple3<bool, int, bool>> getListSelector() {
    return Selector<ListMultiKeyProvider, Tuple3<bool, int, bool>>(
      builder: (context, value, child) {
        bool isLoading = value.item1;
        int count = value.item2;
        bool isError = value.item3;
        debugPrint(
            "SliverApiMaster building widget: ${findCustomKey()} isloading: $isLoading iserror: $isError count: $count");
        if (!isLoading && (count == 0 || isError)) {
          return getEmptyWidget(isError: isError);
        }
        return ValueListenableBuilder<bool>(
          valueListenable: valueNotifierGrid,
          builder: (context, value, child) {
            if (value) {
              return getSliverGridResponsive(count, isLoading);
            } else {
              return getSliverList(count, isLoading);
            }
          },
        );
      },
      selector: (p0, p1) => Tuple3(p1.isLoading(findCustomKey()),
          p1.getCount(findCustomKey()), p1.isHasError(findCustomKey())),
    );
  }

  Widget getSharedLoadingItem(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(kDefaultPadding / 2),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

//todo
  Widget getSliverGridResponsive(int count, bool isLoading) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      sliver: ResponsiveSliverGridList(
          horizontalGridSpacing: 10, // Horizontal space between grid items
          verticalGridSpacing: 10, // Vertical space between grid items
          horizontalGridMargin: 10, // Horizontal space around the grid
          verticalGridMargin: 10, // Vertical space around the grid
          minItemsPerRow:
              3, // The minimum items to show in a single row. Takes precedence over minItemWidth
          maxItemsPerRow:
              8, // The maximum items to show in a single row. Can be useful on large screens
          sliverChildBuilderDelegateOptions:
              SliverChildBuilderDelegateOptions(),
          minItemWidth: 100,
          children: [
            ...listProvider.getList(findCustomKey()).map((e) => WebGridViewItem(
                  item: e,
                  setDescriptionAtBottom: false,
                )),
            if (isLoading)
              ...List.generate(
                  5, (index) => GridTile(child: ListHorizontalItemShimmer()))
          ]),
    );
  }

  Widget getSliverGrid(int count, bool isLoading) {
    return SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount:
              isLargeScreenFromScreenSize(widget.currentScreenSize) ? 3 : 2,
          crossAxisSpacing: kDefaultPadding / 2,
          mainAxisSpacing: kDefaultPadding / 2,
          childAspectRatio: 1,
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
          if (isLoading && index > count - 1) {
            return ListHorizontalItemShimmer();
            // return getSharedLoadingItem(context);
          }
          ViewAbstract va = listProvider.getList(findCustomKey())[index];
          va.setParent(widget.setParentForChild);
          Widget currentTile = WebGridViewItem(
            hightLightonSelect: true,
            onPress: () => va.onCardClicked(context),
            setDescriptionAtBottom: true,
            // setDescriptionAtBottom: !kIsWeb,
            item: va,
          );

          return GridTile(child: currentTile);
          return ListCardItemHorizontal<ViewAbstract>(
              useImageAsBackground: true, object: va);
        }, childCount: count + (isLoading ? 5 : 0)));
  }

  Widget getSliverList(int count, bool isLoading) {
    return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding / 3),
        sliver: LiveSliverList(
            controller: _scrollController,

            // key: _listKey,
            showItemInterval: Duration(milliseconds: isLoading ? 0 : 100),
            showItemDuration: Duration(milliseconds: isLoading ? 0 : 100),
            itemBuilder: animationItemBuilder(
              (index) {
                if (isLoading && index >= count - 1) {
                  return SkeletonListTile(
                    hasLeading: true,
                    hasSubtitle: true,
                    padding: const EdgeInsets.symmetric(
                        horizontal: kDefaultPadding / 2,
                        vertical: kDefaultPadding / 2),
                  );
                }
                ViewAbstract va = listProvider.getList(findCustomKey())[index];
                va.setParent(widget.setParentForChild);
                Widget w = _selectMood
                    ? ListCardItemSelected(
                        isSelected: isSelected(va),
                        onSelected: onSelectedItem,
                        object: va)
                    : ListCardItem(
                        object: va,
                        onSelectedItem:
                            widget.onSelectedCardChangeValueNotifier,
                      );
                return w;
              },
            ),
            itemCount: count + (isLoading ? 8 : 0)));
  }

  Widget Function(
    BuildContext context,
    int index,
    Animation<double> animation,
  ) animationItemBuilder(
    Widget Function(int index) child, {
    EdgeInsets padding = EdgeInsets.zero,
  }) =>
      (
        BuildContext context,
        int index,
        Animation<double> animation,
      ) =>
          FadeTransition(
            opacity: Tween<double>(
              begin: 0,
              end: 1,
            ).animate(animation),
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, -0.1),
                end: Offset.zero,
              ).animate(animation),
              child: Padding(
                padding: padding,
                child: child(index),
              ),
            ),
          );
  void onSelectedItem(ViewAbstract obj, bool isSelected) {
    if (!isSelected) {
      List<ViewAbstract> list = onSelectedListChangeValueNotifier.value;
      list.removeWhere((element) => element.isEquals(obj));
      onSelectedListChangeValueNotifier.value = [...list];
    } else {
      ViewAbstract? isFounded = onSelectedListChangeValueNotifier.value
          .firstWhereOrNull((p0) => p0.isEquals(obj));
      if (isFounded == null) {
        onSelectedListChangeValueNotifier.value = [
          ...onSelectedListChangeValueNotifier.value,
          obj
        ];
      }
    }

    widget.onSelectedListChange?.call(onSelectedListChangeValueNotifier.value);
  }

  bool isSelected(ViewAbstract v) {
    return onSelectedListChangeValueNotifier.value
            .firstWhereOrNull((p0) => p0.isEquals(v)) !=
        null;
  }

  Widget getFilterableWidget() {
    return Selector<FilterableProvider, int>(
      builder: (c, v, s) {
        debugPrint("getFilterableWidget FiltersAndSelectionListHeader $v");
        return SliverPersistentHeader(
            pinned: true,
            delegate: SliverAppBarDelegatePreferedSize(
                shouldRebuildWidget: true,
                child: PreferredSize(
                  preferredSize: Size.fromHeight(v > 0 ? 140 : 60.0),
                  child: FiltersAndSelectionListHeader(
                      viewAbstract: viewAbstract,
                      listProvider: listProvider,
                      customKey: findCustomKey()),
                )));
      },
      selector: (p0, p1) => p1.getCount(),
    );
  }

  Widget getAddBotton(BuildContext context) => IconButton(
      onPressed: () {
        drawerViewAbstractObsever.getObjectCastViewAbstract
            .onDrawerLeadingItemClicked(context);
      },
      icon: const Icon(Icons.add));

  Widget getToggleView() {
    return ValueListenableBuilder<ExpandType>(
        valueListenable: expandTypeOnlyOnExpand,
        builder: (context, value, child) {
          debugPrint("SliverApiMaster valueListenable expandType");
          if (value == ExpandType.EXPANDED) {
            return const SliverToBoxAdapter(child: SizedBox());
          }
          return SliverPersistentHeader(
              pinned: false,
              delegate: SliverAppBarDelegatePreferedSize(
                  child: PreferredSize(
                      preferredSize: const Size.fromHeight(50.0),
                      child: Container(
                        color: Theme.of(context).colorScheme.surface,
                        padding: const EdgeInsets.only(
                            // bottom: kDefaultPadding * .25,
                            top: kDefaultPadding * .25,
                            left: kDefaultPadding / 2,
                            right: kDefaultPadding / 2),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    valueNotifierGrid.value =
                                        !valueNotifierGrid.value;
                                  },
                                  icon: const Icon(Icons.grid_view_rounded))
                            ]),
                      ))));
        });
  }

  Widget getSearchDescription() {
    return SliverToBoxAdapter(
        child: HeaderText(
      fontSize: 12,
      useRespnosiveLayout: false,
      text: _searchStringQuery != null
          ? "Search results: “$_searchStringQuery"
          // : customFilterChecker != null
          //     ? "Showing products by filter"
          : "Showing products",
    )
        // description: searchStringQuery != ""
        //     // || customFilterChecker != null
        //     ? Html(
        //         data:
        //             "Search results may appear roughly depending on the user's input and may take some time, so please be patient :)",
        //       )
        //     : null),
        );
    // return SliverPersistentHeader(
    //     pinned: true,
    //     delegate: SliverAppBarDelegatePreferedSize(
    //       shouldRebuildWidget: true,
    //       child: PreferredSize(
    //         preferredSize: const Size.fromHeight(60),
    //         child: AnimatedSwitcher(
    //           duration: const Duration(milliseconds: 400),
    //           transitionBuilder: (child, animation) => ScaleTransition(
    //             scale: animation,
    //             child: child,
    //           ),
    //           child: value == ExpandType.EXPANDED
    //               ? Text(
    //                   key: const ValueKey(1),
    //                   AppLocalizations.of(context)!.scan,
    //                   style: Theme.of(context).textTheme.titleLarge,
    //                 )
    //               : SearchWidgetComponent(
    //                   currentScreenSize: widget.currentScreenSize,
    //                   appBardExpandType: expandType,
    //                   onSearchTextChanged: !widget.buildSearchWidgetAsEditText
    //                       ? null
    //                       : (serchQuery) {
    //                           searchStringQuery = serchQuery;
    //                           fetshList();
    //                         },
    //                   key: const ValueKey(2),
    //                   heroTag: "list/search",
    //                 ),
    //         ),
    //       ),
    //     ));
  }

  Widget getSearchWidget() {
    return ValueListenableBuilder<ExpandType>(
        valueListenable: expandType,
        builder: (__, value, ____) {
          debugPrint("SliverApiMaster expanmd $value ");
          return SliverPersistentHeader(
              pinned: true,
              delegate: SliverAppBarDelegatePreferedSize(
                shouldRebuildWidget: true,
                child: PreferredSize(
                  preferredSize: const Size.fromHeight(60),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    transitionBuilder: (child, animation) => ScaleTransition(
                      scale: animation,
                      child: child,
                    ),
                    child: value == ExpandType.EXPANDED
                        ? Text(
                            key: const ValueKey(1),
                            AppLocalizations.of(context)!.scan,
                            style: Theme.of(context).textTheme.titleLarge,
                          )
                        : SearchWidgetComponent(
                            currentScreenSize: widget.currentScreenSize,
                            appBardExpandType: expandType,
                            viewAbstract: viewAbstract,
                            onSearchTextChanged:
                                !widget.buildSearchWidgetAsEditText
                                    ? null
                                    : (serchQuery) {
                                        _searchStringQuery = serchQuery;
                                        // expandType.value = ExpandType.HALF_EXPANDED;
                                        _scrollTop();
                                        fetshList(
                                            notifyNotSearchable:
                                                _searchStringQuery == null);
                                      },
                            key: const ValueKey(2),
                            heroTag: "list/search",
                          ),
                  ),
                ),
              ));
        });
    // return Consumer<DraggableHomeExpandProvider>(builder: (__, value, ____) {
    //   debugPrint("SliverApiMaster expanmd ${value.type} ");
    //   return SliverPersistentHeader(
    //       delegate: SliverAppBarDelegate(
    //     maxHeight: 70,
    //     minHeight: 70,
    //     child: AnimatedSwitcher(
    //       duration: Duration(milliseconds: 750),
    //       transitionBuilder: (child, animation) => ScaleTransition(
    //         scale: animation,
    //         child: child,
    //       ),
    //       child: value.type == ExpandType.EXPANDED
    //           ? Text(key: ValueKey(1), "Qri CIODE")
    //           : SearchWidgetComponent(
    //               key: ValueKey(2),
    //               heroTag: "list/search",
    //               controller: TextEditingController(),
    //               onSearchTextChanged: (p0) {},
    //             ),
    //     ),
    //   ));
    // });
  }

  SliverAppBar getAppBar(BuildContext context) {
    return SliverAppBar.large(
      pinned: false,
      floating: true,
      elevation: 4,
      stretch: true,
      primary: true,
      stretchTriggerOffset: 150,
      surfaceTintColor: Theme.of(context).colorScheme.surface,
      automaticallyImplyLeading: true,
      actions: const [],
      leading: const SizedBox(),
      flexibleSpace: getSilverAppBarBackground(context),
    );
  }

  FlexibleSpaceBar getSilverAppBarBackground(BuildContext context) {
    return const FlexibleSpaceBar(
      stretchModes: [
        StretchMode.blurBackground,
        StretchMode.zoomBackground,
        StretchMode.fadeTitle
      ],
      centerTitle: true,
      // background: Text("Welcome back"),
      // titlePadding: const EdgeInsets.only(bottom: 62),
      // title: ValueListenableBuilder<bool>(
      //   valueListenable: valueNotifierCameraMode,
      //   builder: (context, value, child) {
      //     if (value) {
      //       return Text("Qr code back",
      //           style: Theme.of(context).textTheme.titleLarge?.copyWith(
      //                 color: Theme.of(context).colorScheme.primary,
      //               ));
      //     }
      //     return Text(
      //       "Welcome back",
      //       style: Theme.of(context).textTheme.titleLarge?.copyWith(
      //             color: Theme.of(context).colorScheme.primary,
      //           ),
      //     );
      //   },
      // ),
    );
  }

  void _refresh() {
    listProvider.refresh(
        findCustomKey(), drawerViewAbstractObsever.getObjectCastViewAbstract);
  }

  Widget getRefreshWidget() => IconButton(
      onPressed: () {
        _refresh();
      },
      icon: const Icon(Icons.refresh));

  Widget getEmptyWidget({bool isError = false}) {
    return SliverFillRemaining(
      child: _getEmptyWidget(isError),
    );
  }

  EmptyWidget _getEmptyWidget(bool isError) {
    return EmptyWidget(
        onSubtitleClicked: isError
            ? () {
                fetshList();
              }
            : null,
        lottiUrl: "https://assets7.lottiefiles.com/packages/lf20_0s6tfbuc.json",
        title: isError
            ? AppLocalizations.of(context)!.cantConnect
            : AppLocalizations.of(context)!.noItems,
        subtitle: isError
            ? AppLocalizations.of(context)!.cantConnectConnectToRetry
            : AppLocalizations.of(context)!.no_content);
  }

  void fetshList({bool notifyNotSearchable = false}) {
    String customKey = findCustomKey();

    debugPrint("findCustomKey fetshList $customKey");

    if (notifyNotSearchable) {
      listProvider.notifyNotSearchable(customKey,
          viewAbstract: scanedQr ?? viewAbstract);
    }
    if (listProvider.getCount(customKey) == 0) {
      if (_searchStringQuery == null) {
        listProvider.fetchList(customKey,
            viewAbstract: scanedQr ?? viewAbstract);
      } else {
        listProvider.fetchListSearch(
            customKey, viewAbstract, _searchStringQuery!);
      }
    }
  }

  String findCustomKey() {
    if (scanedQr != null) return scanedQr!.getListableKey();
    String key = viewAbstract.getListableKey();
    key = key + (_searchStringQuery ?? "");
    debugPrint("findCustomKey getCustomKey $key");
    return key;
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _onScroll() {
    final direction = _scrollController.position.userScrollDirection;
    if (direction == ScrollDirection.forward) {
      context.read<ListScrollProvider>().setScrollDirection = direction;
    } else if (direction == ScrollDirection.reverse) {
      context.read<ListScrollProvider>().setScrollDirection = direction;
    }
    if (_isBottom) {
      fetshList();
    }
  }
}

class SliverApiNewMixin extends SliverApiMixinWithStaticStateful {
  bool buildSearchWidget;
  bool buildAppBar;
  bool buildFabIfMobile;
  bool buildToggleView;
  bool showLeadingAsHamborg;
  bool buildFilterableView;
  SliverApiNewMixin({
    super.key,
    required super.toListObject,
    this.buildAppBar = true,
    super.buildSearchWidgetAsEditText = false,
    this.showLeadingAsHamborg = true,
    this.buildSearchWidget = true,
    this.buildFilterableView = true,
    this.buildToggleView = true,
    this.buildFabIfMobile = true,
    super.setParentForChildCardItem,
  });

  @override
  State<SliverApiNewMixin> createState() => _SliverApiNewState();
}

class _SliverApiNewState extends State<SliverApiNewMixin>
    with SliverApiWithStaticMixin {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class SliverApiMixinAutoRestWidget extends SliverApiMixinWithStaticStateful {
  SliverApiMixinAutoRestWidget(
      {super.key, super.scrollDirection, required super.toListObject});

  @override
  State<SliverApiMixinAutoRestWidget> createState() =>
      _SliverApiMixinAutoRestState();
}

class _SliverApiMixinAutoRestState extends State<SliverApiMixinAutoRestWidget>
    with SliverApiWithStaticMixin {
  @override
  Widget build(BuildContext context) {
    return getListSelector();
  }
}
