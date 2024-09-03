import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/auto_rest.dart';
import 'package:flutter_view_controller/models/permissions/user_auth.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/providers/actions/list_multi_key_provider.dart';
import 'package:flutter_view_controller/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import 'package:auto_animated/auto_animated.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_view_controller/components/scroll_snap_list.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/customs_widget/draggable_home.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/new_components/lists/horizontal_list_card_item_shimmer.dart';
import 'package:flutter_view_controller/new_components/lists/list_card_item.dart';
import 'package:flutter_view_controller/new_components/lists/list_card_item_selected.dart';
import 'package:flutter_view_controller/new_screens/home/components/empty_widget.dart';
import 'package:flutter_view_controller/providers/actions/list_scroll_provider.dart';
import 'package:flutter_view_controller/screens/web/components/grid_view_api_category.dart';

import 'package:flutter_view_controller/size_config.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
import 'package:skeletons/skeletons.dart';

enum _ObjectType {
  AUTO_REST,
  VIEW_ABSTRACT,
  STRING,
  CUSTOM_LIST,
  CUSTOM_VIEW_RESPONSE
}

abstract class SliverApiMixinWithStaticStateful extends StatefulWidget {
  ///could be [AutoRest] or [ViewAbstract] or String of [tableName] or [List<ViewAbstract>] or [CustomViewHorizontalListResponse]
  Object toListObject;
  ViewAbstract? setParentForChildCardItem;
  ValueNotifier<List<ViewAbstract>>? onSeletedListItemsChanged;
  String? searchString;
  bool isSliver;

  ///when scrollDirection is horizontal grid view well build instaed  and override the [isGridView] even when its true
  Axis scrollDirection;
  bool isGridView;

  SliverApiMixinWithStaticStateful(
      {super.key,
      required this.toListObject,
      this.isGridView = true,
      this.scrollDirection = Axis.vertical,
      this.onSeletedListItemsChanged,
      this.searchString,
      this.isSliver = true,
      this.setParentForChildCardItem});
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

  String? get getSearchString => this._searchString;

  EdgeInsets defaultSliverListPadding =
      const EdgeInsets.symmetric(horizontal: kDefaultPadding / 3);
  EdgeInsets defaultSliverGridPadding =
      const EdgeInsets.symmetric(vertical: 15, horizontal: 15);
  set setSearchString(String? value) => this._searchString = value;

  String getListProviderKey();

  Widget? onResponseHasCustomWidget();

  Widget? onLoadingHasCustomWidget();

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
    _searchString = widget.searchString;

    ///override the gride view when the scroll axis is horizontal
    valueNotifierGrid = ValueNotifier<bool>(
        widget.isGridView || widget.scrollDirection == Axis.horizontal);

    _onSeletedListItemsChanged =
        widget.onSeletedListItemsChanged ?? ValueNotifier([]);

    _toListObject = checkToInitToListObject();

    checkForOverridingSetttings();

    debugPrint(
        "SliverApiWithStaticMixin===> initState=> setParentForChild: ${_setParentForChildCardItem.runtimeType} _toListObject => ${_toListObject.runtimeType} _searchString => $_searchString  _toListObjcetType => $_toListObjectType isGrid=>${valueNotifierGrid.value}");
    super.initState();
    fetshListWidgetBinding();
  }

  @override
  void didUpdateWidget(covariant oldWidget) {
    _checkToUpdateToListObject();
    _setParentForChildCardItem = widget.setParentForChildCardItem;
    if (valueNotifierGrid.value != widget.isGridView) {
      valueNotifierGrid.value = widget.isGridView;
    }

    debugPrint(
        "SliverApiWithStaticMixin===> didUpdateWidget=> setParentForChild: ${_setParentForChildCardItem.runtimeType} _toListObject => ${_toListObject.runtimeType} _searchString => $_searchString  _toListObjcetType => $_toListObjectType isGrid=>${valueNotifierGrid.value}");

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
    return getListSelector();
  }

  Selector<ListMultiKeyProvider, Tuple3<bool, int, bool>> getListSelector() {
    return Selector<ListMultiKeyProvider, Tuple3<bool, int, bool>>(
      builder: (context, value, child) {
        bool isLoading = value.item1;
        int count = value.item2;
        bool isError = value.item3;
        String key = getListProviderKey();
        Widget? customWidget = onResponseHasCustomWidget();
        Widget? customLoading = onLoadingHasCustomWidget();
        debugPrint(
            "SliverApiWithStaticMixin===> didUpdateWidget=>Selector=> key: $key isloading: $isLoading iserror: $isError count: $count");

        if (!isLoading && (count == 0 || isError)) {
          return getEmptyWidget(isError: isError);
        }
        if (isLoading && customLoading != null) {
          return customLoading;
        }
        if (customWidget != null) {
          return customWidget;
        }
        return getListValueListenableIsGrid(count: count, isLoading: isLoading);
      },
      selector: (p0, p1) {
        String key = getListProviderKey();
        return Tuple3(p1.isLoading(key), p1.getCount(key), p1.isHasError(key));
      },
    );
  }

  ValueListenableBuilder<bool> getListValueListenableIsGrid(
      {List? list, required int count, required bool isLoading}) {
    return ValueListenableBuilder<bool>(
      valueListenable: valueNotifierGrid,
      builder: (context, value, child) {
        if (value) {
          return widget.isSliver
              ? getSliverGridList(
                  list: list, count: count, isLoading: isLoading)
              : getNonSliverGridList(
                  list: list, count: count, isLoading: isLoading);
        } else {
          return widget.isSliver
              ? getSliverList(count, isLoading)
              : getNonSliverList(count, isLoading);
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
  Widget getNonSliverList(int count, bool isLoading) {
    return Padding(
      padding: defaultSliverListPadding,
      child: ListView.builder(
        itemCount: count + (isLoading ? 8 : 0),
        itemBuilder: (context, index) {
          if (isLoading && index >= count - 1) {
            return SkeletonListTile(
              hasLeading: true,
              hasSubtitle: true,
              padding: const EdgeInsets.symmetric(
                  horizontal: kDefaultPadding / 2,
                  vertical: kDefaultPadding / 2),
            );
          }
          ViewAbstract va = listProvider.getList(getListProviderKey())[index];
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
    );
  }

  Widget getSliverList(int count, bool isLoading) {
    return SliverPadding(
        padding: defaultSliverListPadding,
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
                    listProvider.getList(getListProviderKey())[index];
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
        ...listProvider.getList(getListProviderKey()).map(getGridItem),
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

  Widget getNonSliverGridList(
      {List? list, required int count, required bool isLoading}) {
    list = list ?? listProvider.getList(getListProviderKey());
    return Padding(
      padding: defaultSliverGridPadding,
      child: widget.scrollDirection == Axis.vertical
          ? getGridViewWhenAxisIsVerticalNonSliver(list, count, isLoading)
          : getGridViewWhenAxisIsHorizontalSizedBox(list, isLoading),
    );
  }

  /// if axis is horizontal then we do need to padding or adding the hover puttons
  Widget getSliverGridList(
      {List? list, required int count, required bool isLoading}) {
    return SliverPadding(
      padding: defaultSliverGridPadding,
      sliver: widget.scrollDirection == Axis.vertical
          ? getGridViewWhenAxisIsVertical(list, count, isLoading)
          : getGridViewWhenAxisIsHorizontal(list, count, isLoading),
    );
  }

  ///TODO not working because [ScrollSnapList] is not Sliver
  Widget getGridViewWhenAxisIsHorizontal(
      List<dynamic>? list, int count, bool isLoading) {
    list = list ?? listProvider.getList(getListProviderKey());
    return SliverToBoxAdapter(
        child: getGridViewWhenAxisIsHorizontalSizedBox(list, isLoading));
  }

  Widget getGridViewWhenAxisIsHorizontalSizedBox(
      List<dynamic>? list, bool isLoading) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * .15,
      child: LayoutBuilder(
        builder: (co, constraints) {
          double size = constraints.maxHeight;
          return ScrollSnapList(
            itemCount: list!.length + (isLoading ? 5 : 0),
            selectedItemAnchor: SelectedItemAnchor.START,
            // endOfListTolerance: constraints.maxWidth,
            scrollDirection: Axis.horizontal,
            itemSize: size,
            listController: _scrollController,
            itemBuilder: (c, index) {
              if (isLoading && index > list!.length - 1) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: kDefaultPadding / 2),
                  child: GridTile(
                      child: SizedBox(
                          height: size,
                          width: size,
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
      ),
    );
  }

  Widget getGridViewWhenAxisIsVerticalNonSliver(
      List<dynamic>? list, int count, bool isLoading) {
    return ResponsiveGridList(
        minItemWidth: minGridItemSize,
        children: getGridList(list: list, count: count, isLoading: isLoading));
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
    if (widget.isSliver) {
      return SliverFillRemaining(
        child: _getEmptyWidget(isError),
      );
    }
    return _getEmptyWidget(isError);
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

    debugPrint(
        "SliverApiWithStaticMixin===> didUpdateWidget=>shouldFetsh : $shouldFetsh");
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
    } else {
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
    bool bottom = _isBottom;
    debugPrint("SliverApiWithStaticMixin===> _onScroll=> isBottom: $bottom");
    if (bottom) {
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
