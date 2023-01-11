import 'package:draggable_home/draggable_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/customs_widget/sliver_delegates.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/cards/outline_card.dart';
import 'package:flutter_view_controller/new_components/fabs_on_list_widget.dart';
import 'package:flutter_view_controller/new_components/lists/headers/filters_and_selection_headers_widget.dart';
import 'package:flutter_view_controller/new_components/lists/horizontal_list_card_item.dart';
import 'package:flutter_view_controller/new_components/lists/horizontal_list_card_item_shimmer.dart';
import 'package:flutter_view_controller/new_components/lists/list_card_item.dart';
import 'package:flutter_view_controller/new_components/qr_code_widget.dart';
import 'package:flutter_view_controller/new_components/scroll_to_hide_widget.dart';
import 'package:flutter_view_controller/new_screens/actions/base_floating_actions.dart';
import 'package:flutter_view_controller/new_screens/home/base_home_main.dart';
import 'package:flutter_view_controller/new_screens/home/components/empty_widget.dart';
import 'package:flutter_view_controller/new_screens/lists/components/search_components.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/components/qr_code_widget.dart';
import 'package:flutter_view_controller/providers/actions/list_actions_provider.dart';
import 'package:flutter_view_controller/providers/actions/list_multi_key_provider.dart';
import 'package:flutter_view_controller/providers/actions/list_scroll_provider.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_controler.dart';

import 'package:flutter_view_controller/size_config.dart';
import 'package:nil/nil.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:skeletons/skeletons.dart';
import 'package:tuple/tuple.dart';

import '../../actions/dashboard/base_dashboard_screen_page.dart';

class SliverApiMaster extends StatefulWidget {
  ViewAbstract? viewAbstract;
  bool buildSearchWidget;
  bool buildAppBar;
  bool buildFabIfMobile;
  bool buildToggleView;
  bool buildFilterableView;
  @Deprecated("message")
  bool fetshListAsSearch;
  SliverApiMaster(
      {super.key,
      this.viewAbstract,
      this.buildAppBar = true,
      this.buildSearchWidget = true,
      this.buildFilterableView = false,
      this.buildToggleView = true,
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
  bool _selectMood = false;
  bool get isSelectedMode => _selectMood;

  List<ViewAbstract> _selectedList = [];

  List<ViewAbstract> get getSelectedList => _selectedList;

  void onSelectedItem(ViewAbstract obj) {
    if (obj.isSelected) {
      ViewAbstract? isFounded;
      try {
        isFounded = _selectedList.firstWhereOrNull((p0) => p0.isEquals(obj));
      } catch (e, s) {}
      if (isFounded == null) {
        _selectedList.add(obj);
        // if (widget.onSelected != null) {
        //   widget.onSelected!(selectedList);
        //   setState(() {});
        // }
      }
    } else {
      _selectedList.removeWhere((element) => element.isEquals(obj));
      // if (widget.onSelected != null) {
      //   widget.onSelected!(selectedList);
      //   setState(() {});
      // }
    }
    context.read<ListActionsProvider>().notifySelectedItem();
  }

  void toggleSelectMood() {
    if (mounted) {
      setState(() {
        _selectMood = !_selectMood;
      });
    }
  }

  void clearSelection() {
    for (var element in _selectedList) {
      element.selected = false;
    }
    _selectedList.clear();
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
    if (widget.viewAbstract != null) {
      viewAbstract = widget.viewAbstract!;
    } else {
      viewAbstract = drawerViewAbstractObsever.getObject;
    }
    fetshListWidgetBinding();
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    if (valueNotifierGrid == null) {}
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
    return WillPopScope(
      onWillPop: () async {
        if (isDialOpen.value) {
          isDialOpen.value = false;
          return false;
        }
        return true;
      },
      child: Scaffold(
        floatingActionButton: SpeedDial(
          openCloseDial: isDialOpen,
          animatedIcon: AnimatedIcons.menu_close,
          overlayColor: Colors.black,
          overlayOpacity: .4,
          spacing: 12,
          spaceBetweenChildren: 12,
          // backgroundColor: Colors.black,
          children: [
            SpeedDialChild(
              child: Icon(Icons.add),
            ),
            SpeedDialChild(
                child: Icon(Icons.camera),
                onTap: () => valueNotifierCameraMode.value =
                    !valueNotifierCameraMode.value),
          ],
        ),
        body: getBuildBody(),
      ),
    );
  }

  Selector<DrawerMenuControllerProvider, ViewAbstract<dynamic>> getBuildBody() {
    return Selector<DrawerMenuControllerProvider, ViewAbstract>(
      builder: (context, value, child) {
        debugPrint(
            "SliverList ViewAbstract has changed from DrawerMenuController");
        if (widget.viewAbstract == null) {
          viewAbstract = value;
          fetshListWidgetBinding();
          debugPrint(
              "SliverList ViewAbstract has changed from DrawerMenuController ViewAbstractProvider CHANGED");
        }
        return getBody(context);
      },
      selector: (p0, p1) => p1.getObject,
    );
  }

  CustomScrollView getBody(BuildContext context) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        const QrCodeWidgetListner(),
        if (widget.buildAppBar) getAppBar(context),
        if (widget.buildSearchWidget) getSearchWidget(),
        if (widget.buildFilterableView) getFilterableWidget(),
        if (widget.buildToggleView) getToggleView(),
        ValueListenableBuilder<bool>(
            valueListenable: valueNotifierCameraMode,
            builder: (context, value, child) {
              if (!value) {
                scanedQr = null;
                return getListSelector();
              }
              _scrollTop();
              return getQrCodeSelector();
            })
      ],
    );
  }

  void _scrollTop() {
    _scrollController.animateTo(
      _scrollController.position.minScrollExtent,
      duration: const Duration(milliseconds: 700),
      curve: Curves.fastOutSlowIn,
    );
  }

  Widget getQrCodeSelector() {
    return ValueListenableBuilder(
      valueListenable: readerViewAbstract,
      builder: (context, value, _) {
        if (value == null) {
          return SliverFillRemaining(
            child: EmptyWidget(
              expand: true,
              lottiUrl:
                  "https://assets3.lottiefiles.com/packages/lf20_oqfmttib.json",
            ),
          );
        }
        scanedQr = value as ViewAbstract;
        scanedQr!.setCustomMap({"<iD>": "${scanedQr!.iD}"});
        fetshList();
        return getListSelector();
      },
    );
  }

  Selector<ListMultiKeyProvider, Tuple3<bool, int, bool>> getListSelector() {
    return Selector<ListMultiKeyProvider, Tuple3<bool, int, bool>>(
      builder: (context, value, child) {
        // List<Widget> widgets;
        debugPrint("SliverApiMaster building widget: ${findCustomKey()}");
        bool isLoading = value.item1;
        int count = value.item2;
        bool isError = value.item3;

        if (isLoading) {
          if (count == 0) {
            return getShimmerLoading();
          }
        } else {
          if (count == 0 || isError) {
            return getEmptyWidget(isError: isError);
          }
        }
        return ValueListenableBuilder<bool>(
          valueListenable: valueNotifierGrid,
          builder: (context, value, child) {
            if (value) {
              return getSliverGrid(count, isLoading);
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

  Widget getSliverGrid(int count, bool isLoading) {
    return SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: kDefaultPadding / 2,
          mainAxisSpacing: kDefaultPadding / 2,
          childAspectRatio: 1,
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
          if (isLoading && index > count - 1) {
            return ListHorizontalItemShimmer();
            // return getSharedLoadingItem(context);
          }
          return ListCardItemHorizontal<ViewAbstract>(
              useImageAsBackground: true,
              object: listProvider.getList(findCustomKey())[index]);
        }, childCount: count + (isLoading ? 5 : 0)));
  }

  SliverList getSliverList(int count, bool isLoading) {
    return SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
      if (isLoading && index == count) {
        return getSharedLoadingItem(context);
      }
      return ListCardItem(object: listProvider.getList(findCustomKey())[index]);
    }, childCount: count + (isLoading ? 1 : 0)));
  }

  SliverPersistentHeader getFilterableWidget() {
    return SliverPersistentHeader(
        pinned: true,
        delegate: SliverAppBarDelegatePreferedSize(
            child: PreferredSize(
          preferredSize: const Size.fromHeight(70.0),
          child: FiltersAndSelectionListHeader(
            listProvider: listProvider,
            customKey: findCustomKey(),
          ),
        )));
  }

  SliverPersistentHeader getToggleView() {
    return SliverPersistentHeader(
        pinned: false,
        delegate: SliverAppBarDelegatePreferedSize(
            child: PreferredSize(
                preferredSize: const Size.fromHeight(70.0),
                child: Container(
                  color: Theme.of(context).colorScheme.background,
                  padding:
                      const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                  child:
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    IconButton(
                        onPressed: () {
                          valueNotifierGrid.value = !valueNotifierGrid.value;
                        },
                        icon: const Icon(Icons.grid_view_rounded))
                  ]),
                ))));
  }

  SliverPersistentHeader getSearchWidget() {
    return SliverPersistentHeader(
        pinned: true,
        delegate: SliverAppBarDelegatePreferedSize(
            child: PreferredSize(
          preferredSize: const Size.fromHeight(70.0),
          child: SearchWidgetComponent(
            heroTag: "list/search",
            controller: TextEditingController(),
            onSearchTextChanged: (p0) {},
          ),
        )));
  }

  SliverAppBar getAppBar(BuildContext context) {
    return SliverAppBar.large(
      pinned: false,
      floating: true,
      elevation: 4,
      stretch: true,
      primary: true,
      stretchTriggerOffset: 150,
      surfaceTintColor: Theme.of(context).colorScheme.background,
      automaticallyImplyLeading: true,
      actions: const [],
      leading: const SizedBox(),
      flexibleSpace: getSilverAppBarBackground(context),
    );
  }

  FlexibleSpaceBar getSilverAppBarBackground(BuildContext context) {
    return FlexibleSpaceBar(
      stretchModes: const [
        StretchMode.blurBackground,
        StretchMode.zoomBackground,
        StretchMode.fadeTitle
      ],
      centerTitle: true,
      // background: Text("Welcome back"),
      // titlePadding: const EdgeInsets.only(bottom: 62),
      title: ValueListenableBuilder<bool>(
        valueListenable: valueNotifierCameraMode,
        builder: (context, value, child) {
          if (value) {
            return Text("Qr code back",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ));
          }
          return Text(
            "Welcome back",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          );
        },
      ),
    );
  }

  void _refresh() {
    listProvider.refresh(findCustomKey(), drawerViewAbstractObsever.getObject);
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

  void fetshList() {
    if (listProvider.getCount(findCustomKey()) == 0) {
      listProvider.fetchList(findCustomKey(), scanedQr ?? viewAbstract);
    }
  }

  Widget getShimmerLoading() {
    return SliverFillRemaining(
      child: SkeletonTheme(
        shimmerGradient: const LinearGradient(
          colors: [
            Color(0xFFD8E3E7),
            Color(0xFFC8D5DA),
            Color(0xFFD8E3E7),
          ],
          stops: [
            0.1,
            0.5,
            0.9,
          ],
        ),
        darkShimmerGradient: const LinearGradient(
          colors: [
            Color(0xFF222222),
            Color(0xFF242424),
            Color(0xFF2B2B2B),
            Color(0xFF242424),
            Color(0xFF222222),
            // Color(0xFF242424),
            // Color(0xFF2B2B2B),
            // Color(0xFF242424),
            // Color(0xFF222222),
          ],
          stops: [
            0.0,
            0.2,
            0.5,
            0.8,
            1,
          ],
          // begin: Alignment(-2.4, -0.2),
          // end: Alignment(2.4, 0.2),
          // tileMode: TileMode.clamp,
        ),
        child: SkeletonListView(
          itemCount: viewAbstract.getPageItemCount,
        ),
      ),
    );
  }

  Padding _getShimmerLoadingBody() {
    return Padding(
      padding: const EdgeInsets.only(top: 75),
      child: Skeleton(
        // darkShimmerGradient: ,
        isLoading: true,
        skeleton: SkeletonListView(
          itemCount: viewAbstract.getPageItemCount,
        ),
        child: Container(child: const Center(child: Text("Content"))),
      ),
    );
  }

  void _onChangedViewAbstract() {
    //if we get viewAbstract from constructor then we dont need to do anything
    if (widget.viewAbstract != null) return;

    viewAbstract = drawerViewAbstractObsever.getObject;
    listProvider.fetchList(findCustomKey(), viewAbstract);
    debugPrint("ViewAbstractProvider CHANGED");
  }

  String findCustomKey() {
    if (scanedQr != null) return scanedQr!.getListableKey();
    String key = viewAbstract.getListableKey();
    // debugPrint("getCustomKey $key");
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
      listProvider.fetchList(findCustomKey(), viewAbstract);
    }
  }
}
