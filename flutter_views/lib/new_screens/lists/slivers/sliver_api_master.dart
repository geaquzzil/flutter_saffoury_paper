import 'package:draggable_home/draggable_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/customs_widget/sliver_delegates.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/fabs_on_list_widget.dart';
import 'package:flutter_view_controller/new_components/lists/headers/filters_and_selection_headers_widget.dart';
import 'package:flutter_view_controller/new_components/lists/list_card_item.dart';
import 'package:flutter_view_controller/new_components/scroll_to_hide_widget.dart';
import 'package:flutter_view_controller/new_screens/home/components/empty_widget.dart';
import 'package:flutter_view_controller/new_screens/lists/components/search_components.dart';
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
  bool buildFilterableView;
  @Deprecated("message")
  bool fetshListAsSearch;
  SliverApiMaster(
      {super.key,
      this.viewAbstract,
      this.buildAppBar = true,
      this.buildSearchWidget = true,
      this.buildFilterableView = false,
      this.fetshListAsSearch = false,
      this.buildFabIfMobile = true});

  @override
  State<SliverApiMaster> createState() => SliverApiMasterState();
}

class SliverApiMasterState<T extends SliverApiMaster> extends State<T> {
  late ViewAbstract viewAbstract;
  final _scrollController = ScrollController();
  late ListMultiKeyProvider listProvider;
  late DrawerMenuControllerProvider drawerViewAbstractObsever;
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
    listProvider = Provider.of<ListMultiKeyProvider>(context, listen: false);
    drawerViewAbstractObsever =
        Provider.of<DrawerMenuControllerProvider>(context, listen: false);
    drawerViewAbstractObsever.addListener(_onChangedViewAbstract);
    if (widget.viewAbstract != null) {
      viewAbstract = widget.viewAbstract!;
    } else {
      viewAbstract = drawerViewAbstractObsever.getObject;
    }
    fetshListWidgetBinding();
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
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        if (widget.buildAppBar) getAppBar(context),
        if (widget.buildSearchWidget) getSearchWidget(),
        if (widget.buildFilterableView) getFilterableWidget(),
        Selector<ListMultiKeyProvider, Tuple3<bool, int, bool>>(
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
            return SliverList(
                delegate: SliverChildBuilderDelegate(
                    (context, index) => ListCardItem(
                        object: listProvider.getList(findCustomKey())[index]),
                    childCount: count));
          },
          selector: (p0, p1) => Tuple3(p1.isLoading(findCustomKey()),
              p1.getCount(findCustomKey()), p1.isHasError(findCustomKey())),
        )
      ],
    );
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

  SliverPersistentHeader getSearchWidget() {
    return SliverPersistentHeader(
        pinned: true,
        delegate: SliverAppBarDelegatePreferedSize(
            child: PreferredSize(
          preferredSize: const Size.fromHeight(70.0),
          child: SearchWidgetComponent(
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
      surfaceTintColor: Theme.of(context).colorScheme.background,
      automaticallyImplyLeading: true,
      actions: [],
      leading: const SizedBox(),
      flexibleSpace: getSilverAppBarBackground(context),
    );
  }

  FlexibleSpaceBar getSilverAppBarBackground(BuildContext context) {
    return const FlexibleSpaceBar(
      stretchModes: [StretchMode.fadeTitle],
      centerTitle: true,
      // titlePadding: const EdgeInsets.only(bottom: 62),
      title: Text("Welcome back"),
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
      listProvider.fetchList(findCustomKey(), viewAbstract);
    }
  }

  Widget getShimmerLoading() {
    return SliverFillRemaining(
      child: SkeletonListView(
        itemCount: viewAbstract.getPageItemCount,
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
