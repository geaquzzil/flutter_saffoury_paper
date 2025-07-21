import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_view_controller/components/scroll_snap_list.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/customs_widget/draggable_home.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/l10n/app_localization.dart';
import 'package:flutter_view_controller/models/auto_rest.dart';
import 'package:flutter_view_controller/models/permissions/user_auth.dart';
import 'package:flutter_view_controller/models/request_options.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/lists/horizontal_list_card_item_shimmer.dart';
import 'package:flutter_view_controller/new_components/lists/list_card_item_api_request.dart';
import 'package:flutter_view_controller/new_components/lists/list_card_item_master.dart';
import 'package:flutter_view_controller/new_components/lists/skeletonizer/widgets.dart';
import 'package:flutter_view_controller/new_components/lists/slivers/sliver_animated_card.dart';
import 'package:flutter_view_controller/new_screens/home/components/empty_widget.dart';
import 'package:flutter_view_controller/new_screens/theme.dart';
import 'package:flutter_view_controller/providers/actions/list_multi_key_provider.dart';
import 'package:flutter_view_controller/providers/auth_provider.dart';
import 'package:flutter_view_controller/providers/filterables/filterable_provider.dart';
import 'package:flutter_view_controller/screens/base_shared_drawer_navigation.dart';
import 'package:flutter_view_controller/screens/on_hover_button.dart';
import 'package:flutter_view_controller/screens/web/components/grid_view_api_category.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:tuple/tuple.dart';

enum SliverMixinObjectType {
  AUTO_REST,
  VIEW_ABSTRACT,
  STRING,
  CUSTOM_LIST,
  CUSTOM_VIEW_RESPONSE,
  FROM_CARD_API,
}

enum CardItemType { list, grid, staggered }

abstract class SliverApiMixinWithStaticStateful extends StatefulWidget {
  ///could be [AutoRest] or [ViewAbstract] or String of [tableName] or [List<ViewAbstract>] or [CustomViewHorizontalListResponse]
  Object toListObject;
  ViewAbstract? setParentForChildCardItem;
  ValueNotifier<List<ViewAbstract>>? onSeletedListItemsChanged;
  ScrollController? scrollController;
  final bool hideOnEmpty;
  @Deprecated("use RequestOptions")
  String? searchString;
  @Deprecated("use RequestOptions")
  Map<String, FilterableProviderHelper>? filterData;
  bool isSliver;
  bool enableSelection;
  bool isCardRequestApi;
  Widget Function(List response)? hasCustomWidgetOnResponseBuilder;
  Widget Function(int idx, ViewAbstract item)? hasCustomCardItemBuilder;
  Function(dynamic object)? onClickForCard;
  bool Function(dynamic object)? isSelectForCard;
  Widget? hasCustomSeperater;
  Widget? hasCustomLoadingItem;
  final ValueNotifier<List?>? valueListProviderNotifier;
  final SecoundPaneHelperWithParentValueNotifier? state;
  Widget? header;

  ///when scrollDirection is horizontal grid view well build instaed  and override the [cardType] even when its true
  Axis scrollDirection;
  CardItemType cardType;
  RequestOptions? customRequestOption;
  RequestOptions? copyWithRequestOption;
  bool requiresFullFetsh;

  SliverApiMixinWithStaticStateful({
    super.key,
    required this.toListObject,
    this.cardType = CardItemType.list,
    this.scrollDirection = Axis.vertical,
    this.onSeletedListItemsChanged,
    this.hasCustomCardItemBuilder,
    this.scrollController,
    this.searchString,
    this.hasCustomWidgetOnResponseBuilder,
    this.filterData,
    this.header,
    this.state,
    this.isSelectForCard,
    this.onClickForCard,
    this.hideOnEmpty = false,
    this.requiresFullFetsh = false,
    this.isCardRequestApi = false,
    this.copyWithRequestOption,
    this.enableSelection = true,
    this.isSliver = true,
    this.hasCustomSeperater,
    this.customRequestOption,
    this.valueListProviderNotifier,
    this.setParentForChildCardItem,
  });
}

mixin SliverApiWithStaticMixin<T extends SliverApiMixinWithStaticStateful>
    on State<T> {
  late Object _toListObject;
  late SliverMixinObjectType _toListObjectType;
  ViewAbstract? _setParentForChildCardItem;
  String? _searchString;
  RequestOptions? _customRequestOptions;
  RequestOptions? _copyWithRequestOption;

  Map<String, FilterableProviderHelper>? _filterData;
  final ValueNotifier<bool> _valueNotifierHover = ValueNotifier<bool>(false);
  late String _lastKey;
  late final ScrollController _scrollController;
  late ListMultiKeyProvider listProvider;
  late ValueNotifier<CardItemType> valueNotifierGrid;
  late ValueNotifier<List<ViewAbstract>>? _onSeletedListItemsChanged;
  final double horizontalGridSpacing = 10;
  final double verticalGridSpacing = 10;
  final double horizontalGridMargin = 10;
  final double verticalGridMargin = 10;
  final int minItemsPerRow = 3;
  final int maxItemsPerRow = 8;
  bool _selectMood = false;
  late bool _isScrollable;
  final double minGridItemSize = 100;

  final GlobalKey<SliverAnimatedListState> _listKey =
      GlobalKey<SliverAnimatedListState>();

  final Curve _defualtScrollCurve = Curves.fastOutSlowIn;
  final Duration _defaultScrollDuration = const Duration(milliseconds: 700);

  final ValueNotifier<ExpandType> _expandType = ValueNotifier<ExpandType>(
    ExpandType.HALF_EXPANDED,
  );

  String? get getSearchString => this._searchString;
  RequestOptions? get getCustomRequestOptions => this._customRequestOptions;
  RequestOptions? get getCopyWithCustomRequestOptions =>
      this._copyWithRequestOption;

  Map<String, FilterableProviderHelper>? get getFilterData => this._filterData;

  EdgeInsets defaultSliverListPadding = const EdgeInsets.symmetric(
    horizontal: kDefaultPadding / 3,
  );
  EdgeInsets defaultSliverGridPadding = const EdgeInsets.symmetric(
    vertical: 15,
    horizontal: 15,
  );
  set setSearchString(String? value) => this._searchString = value;

  //TODO be carefull the list should be taken from the newObject
  String getListProviderKey();

  ListMultiKeyProvider getListProvider() {
    return listProvider;
  }

  Widget? onResponseHasCustomWidget();

  Widget? onLoadingHasCustomWidget();

  void toggleSelectedMood() {
    if (!widget.enableSelection) return;
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

  List? getToListObjectCastList() {
    if (_toListObjectType != SliverMixinObjectType.CUSTOM_LIST) return null;
    return _toListObject as List;
  }

  bool isToListObjectIsViewAbstract() {
    return _toListObject is ViewAbstract;
  }

  CustomViewHorizontalListResponse getToListObjectHorizontalListResponse() {
    return _toListObject as CustomViewHorizontalListResponse;
  }

  AutoRest? getToListObjectCastAutoRestNullIfNot() {
    if (_toListObjectType != SliverMixinObjectType.AUTO_REST) return null;
    return _toListObject as AutoRest;
  }

  ViewAbstract? getToListObjectCastViewAbstractNullIfNot() {
    if (_toListObjectType == SliverMixinObjectType.VIEW_ABSTRACT ||
        _toListObjectType == SliverMixinObjectType.STRING) {
      return _toListObject as ViewAbstract;
    }
    return null;
  }

  SliverMixinObjectType getToListObjectType() {
    if (widget.isCardRequestApi) {
      return SliverMixinObjectType.FROM_CARD_API;
    } else if (widget.toListObject is String) {
      return SliverMixinObjectType.STRING;
    } else if (widget.toListObject is CustomViewHorizontalListResponse) {
      return SliverMixinObjectType.CUSTOM_VIEW_RESPONSE;
    } else if (widget.toListObject is ViewAbstract) {
      return SliverMixinObjectType.VIEW_ABSTRACT;
    } else if (widget.toListObject is List) {
      return SliverMixinObjectType.CUSTOM_LIST;
    } else if (widget.toListObject is AutoRest) {
      return SliverMixinObjectType.AUTO_REST;
    } else {
      return SliverMixinObjectType.CUSTOM_VIEW_RESPONSE;

      ///this is a  CustomViewHorizontalListResponse
    }
  }

  void checkForOverridingSetttings() {
    ///TODO check for overriding setttings
  }
  Object checkToInitToListObject() {
    if (_toListObjectType == SliverMixinObjectType.STRING) {
      return context.read<AuthProvider<AuthUser>>().getNewInstance(
        widget.toListObject as String,
      )!;
    } else {
      return widget.toListObject;
    }
  }

  @override
  void initState() {
    listProvider = Provider.of<ListMultiKeyProvider>(context, listen: false);
    _toListObjectType = getToListObjectType();
    _toListObject = checkToInitToListObject();
    _setParentForChildCardItem = widget.setParentForChildCardItem;
    _scrollController = widget.scrollController ?? ScrollController();
    _scrollController.addListener(_onScroll);

    _lastKey = getListProviderKey();

    _searchString = widget.searchString;
    _filterData = widget.filterData;
    _customRequestOptions = widget.customRequestOption;
    _copyWithRequestOption = widget.copyWithRequestOption;

    ///override the gride view when the scroll axis is horizontal
    valueNotifierGrid = ValueNotifier<CardItemType>(widget.cardType);

    _onSeletedListItemsChanged =
        widget.onSeletedListItemsChanged ?? ValueNotifier([]);

    checkForOverridingSetttings();
    List? customList = getToListObjectCastList();
    if (customList != null) {
      listProvider.initCustomList(_lastKey, customList.cast());
    }
    debugPrint(
      "SliverApiWithStaticMixin===> initState=> setParentForChild: ${_setParentForChildCardItem.runtimeType} _toListObject => ${_toListObject.runtimeType} _searchString => $_searchString  _toListObjcetType => $_toListObjectType isGrid=>${valueNotifierGrid.value}",
    );
    super.initState();
    fetshListWidgetBinding();
  }

  @override
  void didUpdateWidget(covariant oldWidget) {
    // _checkToUpdateToListObject();
    _setParentForChildCardItem = widget.setParentForChildCardItem;
    if (valueNotifierGrid.value != widget.cardType) {
      valueNotifierGrid.value = widget.cardType;
    }
    SliverMixinObjectType lastUpdated = getToListObjectType();
    if (_filterData != widget.filterData) {
      _filterData = widget.filterData;
    }
    if (_customRequestOptions != widget.customRequestOption) {
      _customRequestOptions = widget.customRequestOption;
    }
    if (_copyWithRequestOption != widget.copyWithRequestOption) {
      _copyWithRequestOption = widget.copyWithRequestOption;
    }
    if (_searchString != widget.searchString) {
      _searchString = widget.searchString;
    }
    bool shouldFetsh = false;
    if (_lastKey != getListProviderKey()) {
      shouldFetsh = lastUpdated != SliverMixinObjectType.CUSTOM_LIST;
      _lastKey = getListProviderKey();

      _toListObject = widget.toListObject;
      _toListObjectType = lastUpdated;
      if (lastUpdated == SliverMixinObjectType.CUSTOM_LIST) {
        List? customList = getToListObjectCastList();
        if (customList != null) {
          listProvider.initCustomList(_lastKey, customList.cast());
        }
      } else {
        _resetValues();
      }
    }
    if (shouldFetsh) {
      fetshListWidgetBinding();
    }

    debugPrint(
      "SliverApiWithStaticMixin===> didUpdateWidget=> setParentForChild: ${_setParentForChildCardItem.runtimeType} _toListObject => ${_toListObject.runtimeType} _searchString => $_searchString  _toListObjcetType => $_toListObjectType isGrid=>${valueNotifierGrid.value} should fetish $shouldFetsh filter=>$_filterData",
    );

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Selector<ListMultiKeyProvider, Tuple3<bool, int, bool>>(
      builder: (context, value, child) {
        bool isLoading = value.item1;
        int count = value.item2;
        bool isError = value.item3;
        String key = getListProviderKey();
        debugPrint(
          "ListToDet=>count $count isLoading $isLoading   isError $isError key $key  ",
        );
        WidgetsBinding.instance.addPostFrameCallback((_) {
          widget.valueListProviderNotifier?.value =
              widget.valueListProviderNotifier?.value != null
              ? List.from(widget.valueListProviderNotifier!.value!)
              : [getListProvider(), key, count];
        });

        // .withItem1(getListProvider());
        Widget? customWidget = onResponseHasCustomWidget();
        Widget? customLoading = onLoadingHasCustomWidget();
        debugPrint(
          "SliverApiWithStaticMixin===> Selector=>Selector=> key: $key isloading: $isLoading iserror: $isError count: $count",
        );

        if (!isLoading && (count == 0 || isError)) {
          return getEmptyWidget(isError: isError);
        }
        if (isLoading && customLoading != null) {
          return customLoading;
        }
        if (customWidget != null) {
          return customWidget;
        }
        // if (!isLoading) {
        //   _isScrollable = _scrollController.position.maxScrollExtent > 0;
        //   debugPrint("_onScrollable $_isScrollable");
        // }
        return getAutoDetermineWidget(count, isLoading);
      },
      selector: (p0, p1) {
        String key = getListProviderKey();
        return Tuple3(p1.isLoading(key), p1.getCount(key), p1.isHasError(key));
      },
    );
  }

  Widget getAutoDetermineWidget(int count, bool isLoading) {
    if (getToListObjectType() == SliverMixinObjectType.CUSTOM_VIEW_RESPONSE) {
      if (isLoading) {
        Widget w = EmptyWidget.loading(expand: true);
        return widget.isSliver ? SliverFillRemaining(child: w) : w;
      } else {
        dynamic w = (getList()[0] as CustomViewHorizontalListResponse)
            .getCustomViewResponseWidget(
              context,
              state: this,
              items: getList(),
              requestObjcet: _toListObject,
            );

        if (w == null) {
          return getEmptyWidget();
        } else if (w is List) {
          return widget.isSliver
              ? MultiSliver(
                  children: [
                    if (widget.header != null) widget.header!,
                    ...w.cast(),
                  ],
                )
              : Column(children: w.cast());
        } else {
          return widget.isSliver
              ? MultiSliver(
                  children: [if (widget.header != null) widget.header!, w],
                )
              : w;
        }
      }
    }
    Widget w = widget.hasCustomWidgetOnResponseBuilder != null
        ? widget.hasCustomWidgetOnResponseBuilder!.call(getList())
        : getListValueListenableIsGrid(count: count, isLoading: isLoading);

    if (widget.header != null) {
      return MultiSliver(children: [widget.header!, w]);
    } else {
      return w;
    }
  }

  Widget getCustomListResponseWidget(
    CustomViewHorizontalListResponse response,
  ) {
    return Text("S");
  }

  ValueListenableBuilder<CardItemType> getListValueListenableIsGrid({
    required int count,
    required bool isLoading,
  }) {
    return ValueListenableBuilder<CardItemType>(
      valueListenable: valueNotifierGrid,
      builder: (context, value, child) {
        if (value == CardItemType.grid) {
          return widget.isSliver
              ? getSliverGridList(count: count, isLoading: isLoading)
              : getNonSliverGridList(count: count, isLoading: isLoading);
        } else if (value == CardItemType.staggered) {
          return Text("TODO");
          // return widget.isSliver
          //     ? getSliverStaggeredList(count: count, isLoading: isLoading)
          //     : getNonSliverStaggeredList(count: count, isLoading: isLoading);
        } else {
          return widget.isSliver
              ? getSliverList(count, isLoading)
              : getNonSliverList(count, isLoading);
        }
      },
    );
  }

  Widget Function(BuildContext context, int index, Animation<double> animation)
  animationItemBuilder(
    Widget Function(int index) child, {
    EdgeInsets padding = EdgeInsets.zero,
  }) =>
      (BuildContext context, int index, Animation<double> animation) =>
          FadeTransition(
            opacity: Tween<double>(begin: 0, end: 1).animate(animation),
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, -0.1),
                end: Offset.zero,
              ).animate(animation),
              child: Padding(padding: padding, child: child(index)),
            ),
          );
  Widget getListItem(int index, int count, bool isLoading) {
    if (isLoading && index >= count - 1) {
      return widget.hasCustomLoadingItem ??
          SkeletonListTile(
            hasLeading: true,
            hasSubtitle: true,
            padding: const EdgeInsets.symmetric(
              horizontal: kDefaultPadding / 2,
              vertical: kDefaultPadding / 2,
            ),
          );
    }
    ViewAbstract va = getList()[index];
    va.setParent(_setParentForChildCardItem);
    if (widget.hasCustomCardItemBuilder != null) {
      if ((_toListObjectType != SliverMixinObjectType.FROM_CARD_API)) {
        return ListCardItemApi(
          viewAbstract: va,
          state: this,
          hasCustomLoadingWidget: widget.hasCustomLoadingItem,
          hasCustomCardBuilderOnResponse:
              widget.hasCustomCardItemBuilder == null
              ? null
              : (item) {
                  return widget.hasCustomCardItemBuilder!.call(-1, item);
                },
        );
      }
      return widget.hasCustomCardItemBuilder!.call(index, va);
    }
    if (_toListObjectType != SliverMixinObjectType.FROM_CARD_API) {
      return ListCardItemMaster(
        object: va,
        isSelectForListTile: widget.isSelectForCard,
        isSelectMoodEnabled: _selectMood,
        onTap: widget.onClickForCard,
        searchQuery: _searchString,
        state: widget.state,
        stateForToggle: this,
        isSelectForSelection: _onSelectedItem,
      );
    } else {
      return ListCardItemApi(
        viewAbstract: va,
        state: this,
        hasCustomLoadingWidget: widget.hasCustomLoadingItem,
        hasCustomCardBuilderOnResponse: widget.hasCustomCardItemBuilder == null
            ? null
            : (item) {
                return widget.hasCustomCardItemBuilder!.call(-1, item);
              },
      );
    }
  }

  Widget getNonSliverList(int count, bool isLoading) {
    Widget? seperatedWidget = widget.hasCustomSeperater;
    Widget w = seperatedWidget == null
        ? ListView.builder(
            shrinkWrap: true,
            controller: _scrollController,
            itemCount: count + (isLoading ? 8 : 0),
            itemBuilder: (context, index) {
              return getListItem(index, count, isLoading);
            },
          )
        : ListView.separated(
            shrinkWrap: true,
            controller: _scrollController,
            itemCount: count + (isLoading ? 8 : 0),
            separatorBuilder: (c, i) {
              return seperatedWidget;
            },
            itemBuilder: (context, index) {
              return getListItem(index, count, isLoading);
            },
          );

    return Padding(padding: defaultSliverListPadding, child: w);
  }

  Widget getSliverList(int count, bool isLoading, {List? customList}) {
    return SliverPadding(
      padding: defaultSliverListPadding,
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          debugPrint("SliverApi getSliverList count $count index $index");
          return getListItem(index, count, isLoading);
        }, childCount: count + (isLoading ? 8 : 0)),
      ),
    );

    // LiveSliverList(
    //     key: _listKey,
    //     controller: _scrollController,
    //     showItemInterval: Duration(milliseconds: isLoading ? 0 : 100),
    //     itemBuilder: animationItemBuilder(
    //       (index) {
    //         return getListItem(index, count, isLoading);
    //       },
    //     ),
    //     itemCount: count + (isLoading ? 8 : 0)));
  }

  bool _isSelectedItem(ViewAbstract va) {
    return _onSeletedListItemsChanged?.value.firstWhereOrNull(
          (p0) => p0.isEquals(va),
        ) !=
        null;
  }

  void _onSelectedItem(ViewAbstract obj, bool isSelected) {
    List<ViewAbstract>? list = _onSeletedListItemsChanged?.value;
    if (!isSelected) {
      list?.removeWhere((element) => element.isEquals(obj));
      _onSeletedListItemsChanged?.value = [
        if (list != null) ...list else ...[],
      ];
    } else {
      ViewAbstract? isFounded = _onSeletedListItemsChanged?.value
          .firstWhereOrNull((p0) => p0.isEquals(obj));
      if (isFounded == null) {
        _onSeletedListItemsChanged?.value = [
          if (list != null) ...list else ...[],
          obj,
        ];
      }
    }
  }

  List<Widget> getGridList({required int count, required bool isLoading}) {
    List list = getList();
    return [
      ...list.map(getGridItem),
      if (getToListObjectCastList() == null)
        if (isLoading)
          ...List.generate(
            5,
            (index) => GridTile(child: ListHorizontalItemShimmer()),
          ),
    ];
  }

  Widget getGridItem(e) {
    if (widget.hasCustomCardItemBuilder != null) {
      return widget.hasCustomCardItemBuilder!.call(-1, e);
    }
    return WebGridViewItem(
      isSelectMood: _selectMood,
      isSelectedForCard: widget.isSelectForCard?.call(e),
      isSelected: _isSelectedItem(e),
      onSelected: _onSelectedItem,
      onPress: widget.onClickForCard == null
          ? null
          : () => widget.onClickForCard?.call(e),
      item: e,
      state: this,
      setDescriptionAtBottom: false,
    );
  }

  Widget getNonSliverGridList({required int count, required bool isLoading}) {
    return Padding(
      padding: defaultSliverGridPadding,
      child: widget.scrollDirection == Axis.vertical
          ? getGridViewWhenAxisIsVerticalNonSliver(count, isLoading)
          : getGridViewWhenAxisIsHorizontalSizedBox(isLoading),
    );
  }

  /// if axis is horizontal then we do need to padding or adding the hover puttons
  Widget getSliverGridList({required int count, required bool isLoading}) {
    return SliverPadding(
      padding: defaultSliverGridPadding,
      sliver: widget.scrollDirection == Axis.vertical
          ? getGridViewWhenAxisIsVertical(count, isLoading)
          : getGridViewWhenAxisIsHorizontal(count, isLoading),
    );
  }

  Widget getSliverStaggeredList({required int count, required bool isLoading}) {
    return SliverPadding(
      padding: defaultSliverGridPadding,
      sliver: getStaggeredViewWhenAxisIsSliver(count, isLoading),
    );
  }

  ///TODO not working because [ScrollSnapList] is not Sliver
  Widget getGridViewWhenAxisIsHorizontal(int count, bool isLoading) {
    return SliverToBoxAdapter(
      child: getGridViewWhenAxisIsHorizontalSizedBox(isLoading),
    );
  }

  Widget getGridViewWhenAxisIsHorizontalSizedBox(bool isLoading) {
    List list = getList();
    return SizedBox(
      height: getHeightOfHorizontalGridList(context),
      child: LayoutBuilder(
        builder: (co, constraints) {
          double size = constraints.maxHeight;
          return wrapWithArrows(
            ScrollSnapList(
              itemCount: list.length + (isLoading ? 5 : 0),
              selectedItemAnchor: SelectedItemAnchor.START,
              // endOfListTolerance: constraints.maxWidth,
              scrollDirection: Axis.horizontal,
              itemSize: size,
              listController: _scrollController,
              itemBuilder: (c, index) {
                if (isLoading && index > list.length - 1) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: kDefaultPadding / 2,
                    ),
                    child: GridTile(
                      child: SizedBox(
                        height: size,
                        width: size,
                        child: ListHorizontalItemShimmer(
                          lines: SizeConfig.hasPointer(context) ? 0 : 3,
                        ),
                      ),
                    ),
                  );
                }
                Widget currentTile = WebGridViewItem(
                  currentSize: size,
                  isSelected:
                      widget.isSelectForCard?.call(list[index]) ?? false,
                  onPress: widget.onClickForCard == null
                      ? null
                      : () => widget.onClickForCard?.call(list[index]),
                  isSelectedForCard: widget.isSelectForCard?.call(list[index]),
                  setDescriptionAtBottom: !SizeConfig.hasPointer(context),
                  item: list[index],
                );
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: kDefaultPadding / 2,
                  ),
                  child: GridTile(child: currentTile),
                );
              },
              onItemFocus: (p0) {},
            ),
            size,
          );
        },
      ),
    );
  }

  Widget getGridViewWhenAxisIsVerticalNonSliver(int count, bool isLoading) {
    return ResponsiveGridList(
      minItemWidth: minGridItemSize,
      children: getGridList(count: count, isLoading: isLoading),
    );
  }

  Widget getStaggeredViewWhenAxisIsSliver(int count, bool isLoading) {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
        (context, index) =>
            Container(color: Colors.cyanAccent, child: Text("$index")),
        childCount: 44,
      ),
      gridDelegate: SliverQuiltedGridDelegate(
        crossAxisCount: 3,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        repeatPattern: QuiltedGridRepeatPattern.inverted,
        pattern: const [
          QuiltedGridTile(2, 1),
          QuiltedGridTile(2, 2),
          QuiltedGridTile(1, 1),
          QuiltedGridTile(1, 1),
          QuiltedGridTile(1, 1),
        ],
      ),
    );
  }

  Widget getGridViewWhenAxisIsVertical(int count, bool isLoading) {
    return ResponsiveSliverGridList(
      horizontalGridSpacing:
          horizontalGridSpacing, // Horizontal space between grid items
      verticalGridSpacing:
          verticalGridSpacing, // Vertical space between grid items
      horizontalGridMargin:
          horizontalGridMargin, // Horizontal space around the grid
      verticalGridMargin: verticalGridMargin, // Vertical space around the grid
      minItemsPerRow:
          minItemsPerRow, // The minimum items to show in a single row. Takes precedence over minItemWidth
      maxItemsPerRow:
          maxItemsPerRow, // The maximum items to show in a single rwow. Can be useful on large screens
      sliverChildBuilderDelegateOptions: SliverChildBuilderDelegateOptions(),

      minItemWidth: minGridItemSize,
      children: getGridList(count: count, isLoading: isLoading),
    );
  }

  Widget wrapWithArrows(Widget widget, double itemSize) {
    if (!SizeConfig.hasPointer(context)) return widget;
    return OnHoverWidget(
      onHover: _valueNotifierHover,
      scale: false,
      builder: (isHovered) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: kDefaultPadding,
                ),
                child: widget,
              ),
            ),
            HoverButtons(
              valueNotifier: _valueNotifierHover,
              valuePageNotifierVoid: (idx, isNext) {
                debugPrint("HoverButton idx $idx");
                if (isNext) {
                  if (_isBottom) {
                    fetshList();
                  } else {
                    //todo fix that only when item is scrolling
                    scrollToCollapsed(
                      customOffset: _scrollController.offset + itemSize - 20,
                    );
                  }
                } else {
                  scrollToCollapsed(
                    customOffset: _scrollController.position.minScrollExtent,
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget getEmptyWidget({bool isError = false}) {
    if (widget.isSliver) {
      Widget w;
      if (widget.scrollDirection == Axis.horizontal) {
        w = SliverToBoxAdapter(child: _getEmptyWidget(isError, expand: false));
      } else {
        w = SliverFillRemaining(child: _getEmptyWidget(isError));
      }
      if (widget.hideOnEmpty) {
        return SliverVisibility(sliver: w, visible: false);
      }
      return w;
    } else {
      Widget w = _getEmptyWidget(isError);
      if (widget.hideOnEmpty) {
        return Visibility(visible: false, child: w);
      } else {
        return w;
      }
    }
  }

  EmptyWidget _getEmptyWidget(bool isError, {bool expand = true}) {
    return EmptyWidget(
      expand: expand,
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
          : AppLocalizations.of(context)!.no_content,
    );
  }

  void _resetValues() {
    // _searchString = null;
    // _filterData = null;
    _onSeletedListItemsChanged?.value = [];
  }

  bool canFetshList() {
    if (_toListObjectType == SliverMixinObjectType.FROM_CARD_API ||
        _toListObjectType == SliverMixinObjectType.CUSTOM_LIST) {
      return false;
    }
    return true;
  }

  void fetshList({bool notifyNotSearchable = false}) {
    if (!canFetshList()) return;
    String customKey = getListProviderKey();
    debugPrint("fetshList object type $_toListObjectType");
    if (_toListObjectType == SliverMixinObjectType.CUSTOM_VIEW_RESPONSE) {
      CustomViewHorizontalListResponse c =
          getToListObjectHorizontalListResponse();
      switch (c.getCustomViewResponseType()) {
        //TODO this is the customKey should pressentes here !
        //         String findListCustomKey() {
        //   ViewAbstract? v = getToListObjectCastViewAbstractNullIfNot();
        //   if (v != null) {
        //     String key = v.getListableKey();
        //     key = key + (_searchString ?? "");
        //     return key;
        //   }
        //   if (_toListObjectType == _ObjectType.CUSTOM_VIEW_RESPONSE) {
        //     return getToListObjectHorizontalListResponse().getCustomViewKey();
        //   } else if (_toListObjectType == _ObjectType.AUTO_REST) {
        //     return getToListObjectCastAutoRest().key;
        //   } else {
        //     return "";
        //   }
        // }

        case ResponseType.LIST:
          listProvider.fetchList(
            customKey,
            viewAbstract: c as ViewAbstract,
            context: context,
          );
          break;
        case ResponseType.SINGLE:
          listProvider.fetchView(
            customKey,
            viewAbstract: c as ViewAbstract,
            context: context,
          );
          break;

        case ResponseType.NONE_RESPONSE_TYPE:
          break;
      }
    } else {
      if (notifyNotSearchable) {
        listProvider.notifyNotSearchable(customKey);
      }
      listProvider.fetchList(
        customKey,
        context: context,
        viewAbstract:
            getToListObjectCastAutoRestNullIfNot()?.obj ??
            getToListObjectCastViewAbstractNullIfNot(),
        autoRest: getToListObjectCastAutoRestNullIfNot(),
        options:
            _customRequestOptions ??
            RequestOptions(
              filterMap: _filterData ?? {},
              searchQuery: _searchString,
            ).copyWithObjcet(option: getCopyWithCustomRequestOptions),
        requiresFullFetsh: widget.requiresFullFetsh,
      );
    }
  }

  Future<void> refresh() {
    ViewAbstract? v = getToListObjectCastViewAbstractNullIfNot();
    if (v == null) return Future.delayed(Duration(milliseconds: 0));
    return listProvider.refreshIndicater(
      getListProviderKey(),
      v,
      context: context,
    );
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
    _scrollController.jumpTo(pos);
  }
  // void _scroll() {
  //   _scrollController.position.animateTo(
  //     _scrollController.offset + itemsShowingWidth - 20,
  //     duration: const Duration(milliseconds: 500),
  //     curve: Curves.fastOutSlowIn,
  //   );
  // }

  void scrollToCollapsed({double? customOffset}) {
    _scrollController.animateTo(
      customOffset ?? _scrollController.position.maxScrollExtent,
      duration: _defaultScrollDuration,
      curve: _defualtScrollCurve,
    );
  }

  void _onScroll() {
    debugPrint("_onScroll");
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      debugPrint("_onScroll last is showing");
    }
    // final direction = _scrollController.position.userScrollDirection;
    // if (direction == ScrollDirection.forward) {
    //   context.read<ListScrollProvider>().setScrollDirection = direction;
    // } else if (direction == ScrollDirection.reverse) {
    //   context.read<ListScrollProvider>().setScrollDirection = direction;
    // }
    bool bottom = _isBottom;
    debugPrint(
      "_onScroll SliverApiWithStaticMixin===> _onScroll=> isBottom: $bottom",
    );
    if (bottom) {
      fetshList();
    }
  }

  void fetshListWidgetBinding() {
    _isScrollable = false;
    if (!canFetshList()) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetshList();
    });
  }

  List<E> getList<E>() {
    List<E> l = listProvider.getList<E>(getListProviderKey());
    debugPrint(
      "SliverApi getList for ${getListProviderKey()} count ${l.length} ",
    );
    return l;
  }

  void addAnimatedListItem(ViewAbstract view) {
    SliverMixinObjectType type = getToListObjectType();
    if (type == SliverMixinObjectType.FROM_CARD_API) {
      listProvider.addCardToRequest(_lastKey, view);
    } else {
      listProvider.addCardToRequest(_lastKey, view);
    }

    // int idx = getList().indexOf(widget);
    // debugPrint("SliverApiWithStaticMixin addAnimatedListItem  at $idx");
    // _listKey.currentState?.insertItem(idx);
  }

  bool removeByValue<C>(C value) {
    return listProvider.removeItemObjcet(_lastKey, value);
  }

  C? removeByWhere<C>(bool Function(C) test) {
    return listProvider.removeItem(_lastKey, test);
    // if (getList().isEmpty) return;
    // int idx = getList().indexOf(widget);
    // debugPrint(
    //     "SliverApiWithStaticMixin removeAnimatedListItemByWidget  at $idx");
    // if (idx == -1) return;
    // Widget removed = getList().removeAt(idx);
    // _listKey.currentState?.removeItem(
    //     idx,
    //     (context, animation) =>
    //         SliverAnimatedCard(animation: animation, child: removed));
  }

  void removeAnimatedListItemByIndex(int idx) {
    if (getList().isEmpty) return;
    Widget removed = getList().removeAt(idx);
    _listKey.currentState?.removeItem(
      idx,
      (context, animation) =>
          SliverAnimatedCard(animation: animation, child: removed),
    );
  }

  C? removeItem<C>(bool Function(C) test) {
    debugPrint(
      "searchForItem list length => ${listProvider.getList(getListProviderKey()).length}",
    );
    return listProvider.getList(_lastKey).cast<C>().firstWhereOrNull(test);
  }

  C? searchForItem<C>(bool Function(C) test) {
    debugPrint(
      "searchForItem list length => ${listProvider.getList(getListProviderKey()).length}",
    );
    return listProvider.getList(_lastKey).cast<C>().firstWhereOrNull(test);
  }
}
