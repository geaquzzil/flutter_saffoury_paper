import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_view_controller/configrations.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/customs_widget/sliver_delegates.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/models/view_abstract_base.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:flutter_view_controller/utils/responsive_scroll.dart';
import 'package:rxdart/rxdart.dart';

class SliverCustomScrollView extends StatefulWidget {
  List<Widget> slivers;
  ScrollController? scrollController;
  List<TabControllerHelper>? tabs;
  List<Widget> Function(ScrollController, TabControllerHelper?)? builder;
  String? scrollKey;
  ScrollPhysics? physics;
  final RefreshCallback? onRefresh;
  final ValueNotifier<double>? onScroll;

  //this works with one object only todo cant retrun full List
  Widget Function(bool fullyCol, bool fullyExp, TabControllerHelper? tab)?
  builderAppbar;
  final bool animateTabbar;
  SliverCustomScrollView({
    super.key,
    required this.slivers,
    this.scrollController,
    this.builder,
    this.builderAppbar,
    this.onRefresh,
    this.physics,
    this.onScroll,
    this.animateTabbar = true,
    this.tabs,
    this.scrollKey,
  });

  @override
  State<SliverCustomScrollView> createState() =>
      _SliverCustomScrollViewDraggableState();
}

class _SliverCustomScrollViewDraggableState
    extends State<SliverCustomScrollView>
    with TickerProviderStateMixin {
  TabController? _tabController;
  List<TabControllerHelper>? _tabs;
  late ScrollController _scrollController;
  late String bucketOffsetKey;
  String? _lastTabsKey;

  ValueNotifier<double>? _onScroll;

  final BehaviorSubject<bool> isFullyExpanded = BehaviorSubject<bool>.seeded(
    false,
  );
  final BehaviorSubject<bool> isFullyCollapsed = BehaviorSubject<bool>.seeded(
    false,
  );

  late ValueNotifier<int> onTabSelectedValueNotifier;

  late double expandedHeight;

  static const double headerExpandedHeight = .7;

  String? getTabKey() {
    return widget.tabs
        ?.map((e) => e.viewAbstractGeneratedKey ?? "_")
        .toList()
        .join("-");
  }

  @override
  void initState() {
    _scrollController = widget.scrollController ?? ScrollController();
    bucketOffsetKey = widget.scrollKey ?? "scrollKey";
    _lastTabsKey = getTabKey();
    _onScroll = widget.onScroll ?? ValueNotifier<double>(0);
    if (widget.tabs != null) {
      onTabSelectedValueNotifier = ValueNotifier<int>(0);
      _tabs = <TabControllerHelper>[];
      _tabs!.clear();
      _tabs!.addAll(widget.tabs!);
      _tabController = TabController(length: _tabs!.length, vsync: this)
        ..addListener(onTabSelected);
    }
    super.initState();
  }

  @override
  void didUpdateWidget(covariant SliverCustomScrollView oldWidget) {
    bucketOffsetKey = widget.scrollKey ?? "scrollKey";
    debugPrint("didUpdateWidget draggable $bucketOffsetKey");
    // WidgetsBinding.instance.addPostFrameCallback((c) {
    //   if (mounted) {
    //     double lastSavedScroll =
    //         Configurations.currentPageScrollOffset(context, bucketOffsetKey);
    //     if (lastSavedScroll != 0) {
    //       _scrollTo(lastSavedScroll);
    //     } else {
    //       _scrollTop();
    //     }
    //   }
    // });

    // debugPrint("_SliverCustomScrollViewDraggableState  last $_lastTabsKey");
    if (_lastTabsKey == getTabKey()) {
      // if (widget.tabs != null) {
      //   onTabSelectedValueNotifier.value = 0;
      // }
      return;
    }
    if (widget.tabs != null) {
      _lastTabsKey = getTabKey();
      _tabs = <TabControllerHelper>[];
      _tabs!.clear();
      _tabs!.addAll(widget.tabs!);
      _tabController?.removeListener(onTabSelected);
      _tabController?.dispose();
      _tabController = TabController(length: _tabs!.length, vsync: this)
        ..addListener(onTabSelected);

      onTabSelectedValueNotifier.value = 0;
    }

    super.didUpdateWidget(oldWidget);
  }

  void onTabSelected() {
    onTabSelectedValueNotifier.value = _tabController?.index ?? 0;
    // onTabSelectedVal.value = _tabController!.index;
  }

  bool canExpandBody() {
    return isMobile(context);
  }

  Widget getTabbarSliver() {
    return SliverSafeArea(
      sliver: SliverPadding(
        padding: EdgeInsets.zero,
        sliver: SliverPersistentHeader(
          pinned: true,
          delegate: SliverAppBarDelegatePreferedSize(
            wrapWithSafeArea: true,
            shouldRebuildWidget: true,
            child: PreferredSize(
              preferredSize: Size.fromHeight(kDefaultAppbarHieght),
              child: getTabbarWidget(),
            ),
          ),
        ),
      ),
    );
  }

  Widget getTabbarWidget() {
    Widget tabbar = TabBar(
      tabs: _tabs!.map((e) => e.getTitled((context))).toList(),
      isScrollable: true,
      controller: _tabController,
    );
    if (widget.animateTabbar) {
      return ValueListenableBuilder<double>(
        valueListenable: _onScroll!,
        builder: (context, value, child) {
          return AnimatedContainer(
            duration: Durations.short2,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(kBorderRadius),
              ),
              boxShadow: value == 0
                  ? null
                  : [
                      BoxShadow(
                        spreadRadius: 3,
                        color: Theme.of(
                          context,
                        ).shadowColor.withValues(alpha: .2),

                        offset: const Offset(0, 2.0),
                        blurRadius: 5,
                      ),
                    ],
              // border: value == 0
              //     ? null
              //     : Border(
              //         bottom: BorderSide(
              //           width: 1,
              //           color: Theme.of(context).highlightColor,
              //         ),
              //       ),
              color: value == 0
                  ? null
                  : Theme.of(
                      context,
                    ).scaffoldBackgroundColor.withValues(alpha: .7),
            ),
            child: ClipRRect(
              borderRadius: BorderRadiusGeometry.only(
                bottomRight: Radius.circular(kBorderRadius),
                bottomLeft: Radius.circular(kBorderRadius),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: value == 0 ? 3 : 10,
                  sigmaY: value == 0 ? 3 : 10,
                ),
                child: tabbar,
              ),
            ),
          );
        },
      );
    }
    return tabbar;
  }

  @override
  Widget build(BuildContext context) {
    expandedHeight = canExpandBody()
        ? MediaQuery.of(context).size.height * headerExpandedHeight
        : 0;

    return PageStorage(
      bucket: appBucket,
      child: hasTabbar()
          ? ValueListenableBuilder(
              valueListenable: onTabSelectedValueNotifier,
              builder: (c, x, v) => getNotificationListener(tab: _tabs?[x]),
            )
          : getNotificationListener(),
    );
  }

  bool hasTabbar() {
    return _tabs != null && (_tabs?.isNotEmpty ?? false);
  }

  Widget sliver({TabControllerHelper? tab}) {
    Widget scrollView = _getCustomScrollView(tab);
    if (widget.onRefresh != null) {
      scrollView = RefreshIndicator(
        onRefresh: widget.onRefresh!,
        child: scrollView,
      );
    }
    return SafeArea(
      child: ResponsiveScroll(
        controller: _scrollController,
        // scrollOffset: 250, // additional offset to users scroll input
        // animationDuration: 600,
        child: scrollView,
      ),
    );
  }

  CustomScrollView _getCustomScrollView(TabControllerHelper? tab) {
    return CustomScrollView(
      controller: _scrollController,
      physics: isDesktopPlatform()
          ? NeverScrollableScrollPhysics()
          : widget.physics ??
                const BouncingScrollPhysics(
                  // decelerationRate:ScrollDecelerationRate.fast ,
                  parent: AlwaysScrollableScrollPhysics(),
                ),
      slivers: [
        if (widget.builderAppbar != null)
          StreamBuilder<List<bool>>(
            stream: CombineLatestStream.list<bool>([
              isFullyCollapsed.stream,
              isFullyExpanded.stream,
            ]),
            builder:
                (BuildContext context, AsyncSnapshot<List<bool>> snapshot) {
                  final List<bool> streams = (snapshot.data ?? [false, false]);
                  final bool fullyCollapsed = streams[0];
                  final bool fullyExpanded = streams[1];
                  return widget.builderAppbar!.call(
                    fullyCollapsed,
                    fullyExpanded,
                    tab,
                  );
                },
          ),
        if (hasTabbar()) getTabbarSliver(),
        if (widget.builder != null)
          ...widget.builder!.call(_scrollController, tab)
        else
          ...widget.slivers,
      ],
    );
  }

  String getKeyForSaving({TabControllerHelper? tab}) {
    return bucketOffsetKey + ((tab?.text) ?? "");
  }

  NotificationListener<ScrollNotification> getNotificationListener({
    TabControllerHelper? tab,
  }) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        _onScroll?.value = notification.metrics.extentBefore;
        if (notification is ScrollEndNotification &&
            notification.metrics.axis == Axis.vertical) {
          Configurations.saveScrollOffset(
            context,
            notification.metrics.pixels,
            getKeyForSaving(tab: tab),
          );
        }
        if (notification.metrics.axis == Axis.vertical) {
          if ((isFullyExpanded.value) &&
              notification.metrics.extentBefore > 100) {
            isFullyExpanded.add(false);
          }

          //isFullyCollapsed
          if (notification.metrics.extentBefore >
              expandedHeight - AppBar().preferredSize.height - 40) {
            if (!(isFullyCollapsed.value)) isFullyCollapsed.add(true);
          } else {
            if ((isFullyCollapsed.value)) isFullyCollapsed.add(false);
          }
        }
        return false;
      },
      child: sliver(tab: tab),
    );
  }

  void _scrollDown() {
    if (_scrollController.hasClients == false) return;
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 400),
      curve: Curves.fastOutSlowIn,
    );
  }

  void _scrollTo(double pos) {
    debugPrint("scrollTo pos===> $pos");
    if (_scrollController.hasClients == false) return;
    _scrollController.animateTo(
      pos,
      duration: const Duration(milliseconds: 700),
      curve: Curves.fastOutSlowIn,
    );
  }

  void _scrollToHideTopWidget() {
    debugPrint("_scrollToHideTopWidget ===> top");
    if (_scrollController.hasClients == false) return;
    _scrollController.animateTo(
      _scrollController.position.minScrollExtent,
      duration: const Duration(milliseconds: 700),
      curve: Curves.fastOutSlowIn,
    );
  }

  void _scrollTop() {
    debugPrint("scrollTo ===> top");
    if (_scrollController.hasClients == false) return;
    _scrollController.animateTo(
      _scrollController.position.minScrollExtent,
      duration: const Duration(milliseconds: 700),
      curve: Curves.fastOutSlowIn,
    );
  }

  void _scrollToCollapsed() {
    if (_scrollController.hasClients == false) return;
    _scrollController.jumpTo(500);
  }
}
