import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/fabs_on_list_widget.dart';
import 'package:flutter_view_controller/providers/actions/list_actions_provider.dart';
import 'package:flutter_view_controller/providers/actions/list_multi_key_provider.dart';
import 'package:flutter_view_controller/providers/actions/list_scroll_provider.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_controler.dart';

import 'package:flutter_view_controller/size_config.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:skeletons/skeletons.dart';
import 'package:tuple/tuple.dart';
import '../../new_components/lists/headers/filters_and_selection_headers_widget.dart';
import '../home/components/empty_widget.dart';
import 'components/search_components.dart';

abstract class ListApiMaster extends StatefulWidget {
  ViewAbstract? viewAbstract;
  bool buildSearchWidget;
  bool buildFabIfMobile;
  bool fetshListAsSearc;
  bool useSlivers;
  ListApiMaster(
      {super.key,
      this.viewAbstract,
      this.buildSearchWidget = true,
      this.useSlivers = false,
      this.fetshListAsSearc = false,
      this.buildFabIfMobile = true});

  void onScroll(
      {required BuildContext context,
      required ViewAbstract viewAbstract,
      required ListMultiKeyProvider listProvider});

  Widget getListViewWidget(
      {required BuildContext context,
      required String key,
      required ScrollController scrollController,
      required ListMultiKeyProvider listProvider});

  Widget getListSelectedViewWidget(
      {required BuildContext context,
      required String key,
      required ScrollController scrollController,
      required ListMultiKeyProvider listProvider});

  Widget getSharedLoadingItem(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(kDefaultPadding),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
    return SkeletonItem(
        child: Center(
      child: Text(AppLocalizations.of(context)!.loading),
    ));
  }

  GlobalKey<ListApiMasterState>? getKey() {
    if (key == null) return null;
    return key as GlobalKey<ListApiMasterState>;
  }

  @override
  State<ListApiMaster> createState() => ListApiMasterState();
}

class ListApiMasterState<T extends ListApiMaster> extends State<T> {
  late ViewAbstract viewAbstract;
  final _scrollController = ScrollController();
  late ListMultiKeyProvider listProvider;
  late DrawerMenuControllerProvider drawerViewAbstractObsever;
  TextEditingController controller = TextEditingController();
  GlobalKey<FabsOnListWidgetState> fabsOnListWidgetState =
      GlobalKey<FabsOnListWidgetState>();
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
    // Future.delayed(Duration.zero,() {

    // },);
    listProvider = Provider.of<ListMultiKeyProvider>(context, listen: false);
    drawerViewAbstractObsever =
        Provider.of<DrawerMenuControllerProvider>(context, listen: false);
    drawerViewAbstractObsever.addListener(_onChangedViewAbstract);
    if (widget.viewAbstract != null) {
      viewAbstract = widget.viewAbstract!;
    } else {
      viewAbstract = drawerViewAbstractObsever.getObjectCastViewAbstract;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (listProvider.getPage(getCustomKey()) == 0) {
        listProvider.fetchList(getCustomKey(), viewAbstract: viewAbstract,context:context);
      }
    });
  }

  @override
  void dispose() {
    debugPrint("listApiMaster dispose");
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    // listProvider.dispose();
    // drawerViewAbstractObsever.c();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    debugPrint("listApiMaster didChangeDependencies ");
  }

  @override
  Widget build(BuildContext context) {
    if (widget.useSlivers) {
      return getConsumer();
    }
    if (SizeConfig.isMobile(context) || SizeConfig.isFoldable(context)) {
      return getSmallScreenWidget();
    } else {
      return getLargeScreenWidget();
    }
  }

  Widget getLargeScreenWidget() {
    return Column(
      children: <Widget>[
        if (widget.buildSearchWidget)
          SearchWidgetComponent(
            viewAbstract: viewAbstract,
          ),
        // FiltersAndSelectionListHeader(),
        Expanded(
            child: ChangeNotifierProvider.value(
          value: listProvider,
          child: Consumer<ListMultiKeyProvider>(
              builder: (context, provider, listTile) {
            debugPrint(
                "ListApiMasterState building widget: ${findCustomKey()}");
            if (provider.isLoading(findCustomKey())) {
              if (provider.getCount(findCustomKey()) == 0) {
                return getShimmerLoading();
              }
            } else {
              if (provider.getCount(findCustomKey()) == 0) {
                return getEmptyWidget();
              } else {}
            }
            return ListView(
              children: [
                FiltersAndSelectionListHeader(
                  viewAbstract: viewAbstract,
                  customKey: findCustomKey(),
                  listProvider: listProvider,
                ),
                const Divider(),
                widget.getListViewWidget(
                    context: context,
                    listProvider: listProvider,
                    key: findCustomKey(),
                    scrollController: _scrollController),
              ],
            );
          }),
        )),
      ],
    );
  }

  void _refresh() {
    listProvider.refresh(
        findCustomKey(), drawerViewAbstractObsever.getObjectCastViewAbstract,context:context);
  }

  Widget getRefreshWidget() => IconButton(
      onPressed: () {
        _refresh();
      },
      icon: const Icon(Icons.refresh));
  Widget getSmallScreenWidget() {
    return WillPopScope(
      onWillPop: () async {
        if (fabsOnListWidgetState.currentState?.isDialOpen.value ?? false) {
          fabsOnListWidgetState.currentState?.isDialOpen.value = false;
          return false;
        }
        return true;
      },
      child: Scaffold(
        // floatingActionButton: widget.buildFabIfMobile
        //     ? FabsOnListWidget(
        //         customKey: findCustomKey(),
        //         listProvider: listProvider,
        //         key: fabsOnListWidgetState)
        //     : null,
        body: Stack(
            alignment: Alignment.topCenter,
            fit: StackFit.loose,
            children: [
              getConsumer(),
              if (!isSelectedMode && widget.buildSearchWidget)
                SearchWidgetComponent(
                  viewAbstract: viewAbstract,
                ),
            ]),
      ),
    );
  }

  Widget getConsumer() {
    return Selector<ListMultiKeyProvider, Tuple3<bool, int, bool>>(
      builder: (context, value, child) {
        debugPrint("ListApiMasterState building widget: ${findCustomKey()}");
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
        return getListBody(context);
      },
      selector: (p0, p1) => Tuple3(p1.isLoading(findCustomKey()),
          p1.getCount(findCustomKey()), p1.isHasError(findCustomKey())),
    );
  }

  Widget getListBody(BuildContext context) {
    if (widget.useSlivers) {
      return widget.getListSelectedViewWidget(
          key: findCustomKey(),
          scrollController: _scrollController,
          context: context,
          listProvider: listProvider);
    }
    return Padding(
      padding: const EdgeInsets.only(top: 75),
      child: AnimatedSwitcher(
          // transitionBuilder: (child, animation) => ScaleTransition(
          //   scale: animation,
          //   child: child,
          // ),
          duration: const Duration(milliseconds: 500),
          child: RefreshIndicator(
            onRefresh: () async {
              _refresh();
            },
            child: isSelectedMode
                ? widget.getListSelectedViewWidget(
                    key: findCustomKey(),
                    scrollController: _scrollController,
                    context: context,
                    listProvider: listProvider)
                : widget.getListViewWidget(
                    key: findCustomKey(),
                    scrollController: _scrollController,
                    context: context,
                    listProvider: listProvider),
          )),
    );
  }

  Widget getEmptyWidget({bool isError = false}) {
    return widget.useSlivers
        ? SliverToBoxAdapter(
            child: _getEmptyWidget(isError),
          )
        : _getEmptyWidget(isError);
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
    if (listProvider.getCount(getCustomKey()) == 0) {
      listProvider.fetchList(getCustomKey(), viewAbstract: viewAbstract,context:context);
    }
  }

  Widget getShimmerLoading() {
    return widget.useSlivers
        ? SliverFillRemaining(
            child: SkeletonListView(
              itemCount: viewAbstract.getPageItemCount,
            ),
          )
        : _getShimmerLoadingBody();
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

  void _onSearchTextChanged(String? text) async {
    if (text == null) return;
    await Future.delayed(
      const Duration(milliseconds: 750),
      () {
        fetshListSearch(text);
        // setState(() {});
      },
    );
  }

  void fetshListSearch(String query) {
    controller.text = query;
    listProvider.fetchListSearch(
        getCustomKey(searchTextKey: query), viewAbstract, query,context:context);
  }

  void _onChangedViewAbstract() {
    //if we get viewAbstract from constructor then we dont need to do anything
    if (widget.viewAbstract != null) return;

    viewAbstract = drawerViewAbstractObsever.getObjectCastViewAbstract;
    listProvider.fetchList(findCustomKey(), viewAbstract: viewAbstract,context:context);
    debugPrint("ViewAbstractProvider CHANGED");
  }

  String getCustomKey({String? searchTextKey}) {
    String key = viewAbstract.getListableKey();
    debugPrint("getCustomKey $key");
    return searchTextKey == null ? key : key + searchTextKey;
  }

  String findCustomKey() {
    return getCustomKey(
        searchTextKey: controller.text.isEmpty ? null : controller.text);
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
    // debugPrint(" IS _onScroll $_isBottom");
    if (_isBottom) {
      // debugPrint(" IS BOTTOM $_isBottom");
      if (controller.text.isEmpty) {
        listProvider.fetchList(getCustomKey(), viewAbstract: viewAbstract,context:context);
      } else {
        listProvider.fetchListSearch(
            getCustomKey(searchTextKey: controller.text),
            viewAbstract,
            controller.text,context:context);
      }
      widget.onScroll(
          context: context,
          listProvider: listProvider,
          viewAbstract: viewAbstract);
    }
  }
}
