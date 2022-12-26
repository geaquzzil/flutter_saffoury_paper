import 'package:draggable_home/draggable_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/fabs_on_list_widget.dart';
import 'package:flutter_view_controller/new_components/scroll_to_hide_widget.dart';
import 'package:flutter_view_controller/providers/actions/list_actions_provider.dart';
import 'package:flutter_view_controller/providers/actions/list_multi_key_provider.dart';
import 'package:flutter_view_controller/providers/actions/list_scroll_provider.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_viewabstract_list.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:skeletons/skeletons.dart';
import '../../new_components/lists/headers/filters_and_selection_headers_widget.dart';
import '../home/components/empty_widget.dart';
import 'components/search_components.dart';

abstract class ListApiMaster extends StatefulWidget {
  ViewAbstract? viewAbstract;
  bool buildSearchWidget;
  bool buildFabIfMobile;
  bool fetshListAsSearc;
  ListApiMaster(
      {super.key,
      this.viewAbstract,
      this.buildSearchWidget = true,
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

class ListApiMasterState extends State<ListApiMaster> {
  late ViewAbstract viewAbstract;
  final _scrollController = ScrollController();
  late ListMultiKeyProvider listProvider;
  late DrawerViewAbstractListProvider drawerViewAbstractObsever;
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
        Provider.of<DrawerViewAbstractListProvider>(context, listen: false);
    drawerViewAbstractObsever.addListener(_onChangedViewAbstract);
    if (widget.viewAbstract != null) {
      viewAbstract = widget.viewAbstract!;
    } else {
      viewAbstract = drawerViewAbstractObsever.getObject;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      listProvider.fetchList(getCustomKey(), viewAbstract);
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
              controller: controller,
              onSearchTextChanged: _onSearchTextChanged),
        // FiltersAndSelectionListHeader(),
        Expanded(
            child: ChangeNotifierProvider.value(
          value: listProvider,
          child: Consumer<ListMultiKeyProvider>(
              builder: (context, provider, listTile) {
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
                  customKey: findCustomKey(),
                  listProvider: listProvider,
                ),
                Divider(),
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
    listProvider.refresh(findCustomKey(), drawerViewAbstractObsever.getObject);
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
        floatingActionButton: widget.buildFabIfMobile
            ? FabsOnListWidget(
                customKey: findCustomKey(),
                listProvider: listProvider,
                key: fabsOnListWidgetState)
            : null,
        body: Stack(
            alignment: Alignment.topCenter,
            fit: StackFit.loose,
            children: [
              ChangeNotifierProvider.value(
                value: listProvider,
                child: Consumer<ListMultiKeyProvider>(
                    builder: (context, provider, listTile) {
                  if (provider.isLoading(findCustomKey())) {
                    if (provider.getCount(findCustomKey()) == 0) {
                      return getShimmerLoading();
                    }
                  } else {
                    if (provider.getCount(findCustomKey()) == 0 &&
                        provider.isHasError(findCustomKey())) {
                      return getErrorWidget();
                    } else if (provider.getCount(findCustomKey()) == 0) {
                      return getEmptyWidget();
                    }
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 75),
                    child: AnimatedSwitcher(
                        // transitionBuilder: (child, animation) => ScaleTransition(
                        //   scale: animation,
                        //   child: child,
                        // ),
                        duration: Duration(milliseconds: 500),
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
                }),
              ),
              if (!isSelectedMode && widget.buildSearchWidget)
                SearchWidgetComponent(
                    controller: controller,
                    onSearchTextChanged: _onSearchTextChanged),
            ]),
      ),
    );
  }

  Widget getErrorWidget() {
    return ListView(children: [
      FiltersAndSelectionListHeader(
        customKey: findCustomKey(),
        listProvider: listProvider,
      ),
      Center(
        child: EmptyWidget(
            onSubtitleClicked: () {
              listProvider.fetchList(getCustomKey(), viewAbstract);
            },
            lottiUrl:
                "https://assets7.lottiefiles.com/packages/lf20_0s6tfbuc.json",
            title: AppLocalizations.of(context)!.cantConnect,
            subtitle: AppLocalizations.of(context)!.cantConnectConnectToRetry),
      ),
    ]);
  }

  Widget getEmptyWidget() {
    return ListView(children: [
      FiltersAndSelectionListHeader(
        customKey: findCustomKey(),
        listProvider: listProvider,
      ),
      Center(
        child: EmptyWidget(
            lottiUrl:
                "https://assets7.lottiefiles.com/packages/lf20_0s6tfbuc.json",
            title: AppLocalizations.of(context)!.noItems,
            subtitle: AppLocalizations.of(context)!.error_empty),
      ),
    ]);
  }

  Widget getShimmerLoading() {
    return Padding(
      padding: const EdgeInsets.only(top: 75),
      child: Skeleton(
        // darkShimmerGradient: ,
        isLoading: true,
        skeleton: SkeletonListView(
          itemCount: viewAbstract.getPageItemCount,
        ),
        child: Container(child: Center(child: Text("Content"))),
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
        getCustomKey(searchTextKey: query), viewAbstract, query);
  }

  void _onChangedViewAbstract() {
    //if we get viewAbstract from constructor then we dont need to do anything
    if (widget.viewAbstract != null) return;

    viewAbstract = drawerViewAbstractObsever.object;
    listProvider.fetchList(findCustomKey(), viewAbstract);
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
        listProvider.fetchList(getCustomKey(), viewAbstract);
      } else {
        listProvider.fetchListSearch(
            getCustomKey(searchTextKey: controller.text),
            viewAbstract,
            controller.text);
      }
      widget.onScroll(
          context: context,
          listProvider: listProvider,
          viewAbstract: viewAbstract);
    }
  }
}
