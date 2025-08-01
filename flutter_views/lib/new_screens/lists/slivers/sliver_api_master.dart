import 'package:auto_animated/auto_animated.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/customs_widget/draggable_home.dart';
import 'package:flutter_view_controller/customs_widget/sliver_delegates.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/l10n/app_localization.dart';
import 'package:flutter_view_controller/models/permissions/user_auth.dart';
import 'package:flutter_view_controller/models/request_options.dart';
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
import 'package:flutter_view_controller/new_components/lists/skeletonizer/widgets.dart';
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
import 'package:responsive_grid_list/responsive_grid_list.dart';
import 'package:tuple/tuple.dart';

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
        // headerWidget: getHeaderWidget(),
        expandedBody: isSelectedMode
            ? null
            : QrCodeReader(
                getViewAbstract: true,
                currentHeight: 20,
                valueNotifierQrState: valueNotifierQrState,
              ),
        slivers: [
          // if (isSelectedMode) getHeaderWidget()!,
          // if (!canShowHeaderWidget())
          //   ...viewAbstract.getHomeListHeaderWidgetList(context) ?? [],

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
            scanedQr!.setRequestOption(
                option: RequestOptions().addSearchByField("iD", scanedQr?.iD));
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
        findCustomKey(), drawerViewAbstractObsever.getObjectCastViewAbstract,
        context: context);
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
      listProvider.notifyNotSearchable(customKey);
    }
    if (listProvider.getCount(customKey) == 0) {
      listProvider.fetchList(
        customKey,
        context: context,
        viewAbstract: scanedQr ?? viewAbstract,
        options: RequestOptions(
          searchQuery: _searchStringQuery,
        ),
      );
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
